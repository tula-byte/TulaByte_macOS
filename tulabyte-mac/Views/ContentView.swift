//
//  ContentView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 3/7/21.
//

import SwiftUI
import NetworkExtension
import os.log
import SwiftyStoreKit

class TulaModel: NSObject, ObservableObject {
    
    //MARK:- Variables
    @Published var isTunnelOn: Bool = TunnelController.shared.isTunnelEnabled() {
        didSet {
            if isTunnelOn == true {
                if !TunnelController.shared.isTunnelEnabled() {
                    startTunnel()
                }
            } else if isTunnelOn == false {
                if TunnelController.shared.isTunnelEnabled() {
                    stopTunnel()
                }
            }
        }
    }
    
    @Published var blockCount: [Int] = [retrieveBlockLog().count, retrieveBlockLogToday().count]
    
    @Published var blockLog: [Array<DisplayBlockLogItem>] = [retrieveGroupedCount(), retrieveGroupedCountToday()]
    
    @Published var statsMode: Int = 0 {
        didSet {
            blockCount = [retrieveBlockLog().count, retrieveBlockLogToday().count]
            blockLog = [retrieveGroupedCount(), retrieveGroupedCountToday()]
        }
    }
    
    @Published var subscriptionValid: Bool = false// (defaults.value(forKey:hasUserPurchasedKey) != nil)
    
    
    //MARK:- Functions
    public func update() {
        let newBlockLog = [retrieveGroupedCount(), retrieveGroupedCountToday()]
        let newBlockCount = [retrieveBlockLog().count, retrieveBlockLogToday().count]
        let newTunnelStatus = TunnelController.shared.isTunnelEnabled()
        
        blockLog = newBlockLog
        blockCount = newBlockCount
    }
    
    func startTunnel() {
        TunnelController.shared.enableTunnel(true, isUserExplicitToggle: true) { e in
            if e != nil {
                NSLog("TB MAC: Error handling was activated on tunnel enablement")
                self.isTunnelOn = false
                NotificationCenter.default.post(openMenubarNotification)
            }
        }
    }
    
    func stopTunnel() {
        TunnelController.shared.enableTunnel(false, isUserExplicitToggle: false) { e in
            if e != nil {
                NSLog("TB MAC: Error handling was activated on tunnel disablement")
            }
        }
    }
    
}


struct ContentView: View {
    
    @StateObject var model = TulaModel()
    
    @State private var subscriptionAlert: Alert?
    @State private var isSubAlertDisplayed: Bool = false
    
    var body: some View {
        
        MainView()
            .environmentObject(model)
            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            .background(tulabyteHomeBG)
            //.background(VisualEffectView())
            .onReceive(NotificationCenter.default.publisher(for: menubarWillAppearNotification.name), perform: { _ in
                model.update()
                
                //check if sub is valid
                if (defaults.value(forKey: nwConnectedKey) as! Bool) == true {
                    switch TunnelController.shared.tunnelStatus() {
                    case .connected, .disconnected, .invalid:
                        SwiftyStoreKit.verifyReceipt(using: AppleValidator) { (receiptResult) in
                            switch receiptResult {
                            case .success(receipt: let receipt):
                                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: Set(Subscriptions), inReceipt: receipt)
                                
                                switch purchaseResult {
                                case .purchased( _, _):
                                    defaults.setValue(true, forKey: hasUserPurchasedKey)
                                    model.subscriptionValid = true
                                    
                                case .expired(_, _), .notPurchased:
                                    subscriptionAlert = Alert(title: Text("Subscription Expired"), message: Text("Your subscription has expired. Please resubscribe to continue using the TulaByte app."), dismissButton: .default(Text("Ok"), action: {
                                        defaults.setValue(false, forKey: hasUserPurchasedKey)
                                        model.subscriptionValid = false
                                    }))
                                    TunnelController.shared.deleteManager()
                                    isSubAlertDisplayed = true
                                    
                                }
                                
                            case .error(let error as ReceiptError):
                                let message: String = "Something went wrong. Please restart the app. Error: \(error)"
                                subscriptionAlert = Alert(title: Text("Error"), message: Text(message), dismissButton: .default(Text("Ok")))
                                isSubAlertDisplayed = true
                            }
                        }
                    default:
                        NSLog("TB MAC: Tunnel in intermediate state, ignoring subscription check for now.")
                    }
                    
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: TunnelController.shared.tunnelEnabledNotification.name), perform: { _ in
                model.update()
            })
            .onReceive(NotificationCenter.default.publisher(for: TunnelController.shared.tunnelDisabledNotification.name), perform: { _ in
                model.update()
            })
            .onReceive(NotificationCenter.default.publisher(for: purchasedNotification.name), perform: { _ in
                model.subscriptionValid = (defaults.value(forKey: hasUserPurchasedKey) != nil) as Bool
            })
            .onReceive(NotificationCenter.default.publisher(for: blockLogClearedNotification.name), perform: { _ in
                model.update()
            })
            .alert(isPresented: $isSubAlertDisplayed, content: {
                subscriptionAlert!
            })
    }
    
}

struct MainView: View {
    
    @EnvironmentObject var model: TulaModel
    
    var body: some View {
        if model.subscriptionValid == true {
            HomeView()
                .environmentObject(model)
        } else {
            PaywallView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//MARK:- Extra
struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        
        view.blendingMode = .behindWindow    // << important !!
        view.isEmphasized = true
        view.material = .appearanceBased
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}
