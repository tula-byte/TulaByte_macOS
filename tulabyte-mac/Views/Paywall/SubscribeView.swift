//
//  PaywallView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 18/7/21.
//

import SwiftUI
import SwiftyStoreKit
import StoreKit

struct SubscribeView: View {
    
    @State private var individualSubscription: Bool = false
    
    @State private var familySubscription: Bool = false
    
    
    private var individualPrice: String {
        defaults.value(forKey: IndividualSubscription) as! String
    }
    
    private var familyPrice: String {
        defaults.value(forKey: FamilySubscription) as! String
    }
    
    @State private var chosenSub: String?
    
    @State private var purchaseAlert: Alert?
    @State private var isPurchaseAlertDisplayed: Bool = false
    
    @State private var restoreAlert: Alert?
    @State private var isRestoreAlertDisplayed: Bool = false
    
    @State private var isInfoAlertDisplayed: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text("TulaByte")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Divider()
                    .frame(width: 50)
                    .padding(.bottom, 10)
                
                Text("Subscribe")
                    .font(.headline)
                    .foregroundColor(tulabyteGreen)
                    .padding(.bottom, 1)
                
                Text("TulaByte runs on user subscriptions, not money from advertisers. Both subscriptions provide full access to the app, on iOS and macOS")
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding()
            .padding(.bottom, 15)
            
            
            VStack(spacing: 15) {
                Text("Charged after a 3 day free trial")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.bottom, -5)
                
                Toggle(isOn: $individualSubscription, label: {
                    Text("Individual - \(individualPrice)/year")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 250)
                })
                .toggleStyle(TulaToggleStyle())
                .onChange(of: individualSubscription, perform: { value in
                    if value == true {
                        chosenSub = Subscriptions[0]
                        familySubscription = false
                    }
                })
                
                Toggle(isOn: $familySubscription, label: {
                    Text("Family (up to 6 people) - \(familyPrice)/year")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 250)
                })
                .toggleStyle(TulaToggleStyle())
                .onChange(of: familySubscription, perform: { value in
                    if value == true {
                        chosenSub = Subscriptions[1]
                        individualSubscription = false
                    }
                })
                
                Button(action: {
                    if (defaults.value(forKey: nwConnectedKey) as! Bool) == true{
                    SwiftyStoreKit.purchaseProduct(chosenSub!, quantity: 1, atomically: true) { result in
                        switch result {
                        case .success(_):
                            SwiftyStoreKit.verifyReceipt(using: AppleValidator) { (receiptResult) in
                                switch receiptResult {
                                case .success(receipt: let receipt):
                                    let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: Set(Subscriptions), inReceipt: receipt)

                                    switch purchaseResult {
                                    case .purchased( _, _):
                                        defaults.setValue(true, forKey: hasUserPurchasedKey)
                                        NotificationCenter.default.post(purchasedNotification as Notification)
                                        let currentWindow = NSApplication.shared.windows.first { window in
                                            return window.title == "TulaByte - Subscribe"
                                        }
                                        currentWindow?.close()
                                        NotificationCenter.default.post(openMenubarNotification)
                                    
                                
                                    case .notPurchased, .expired(_, _):
                                        defaults.setValue(false, forKey: hasUserPurchasedKey)
                                        purchaseAlert = Alert(title: Text("Not Subscribed"), message: Text("A valid subscription isn't associated with this Apple ID. Please try pressing the Restore button to check again."), dismissButton: .default(Text("Ok")))
                                        isPurchaseAlertDisplayed = true
                                    }
                                case .error(error: let error):
                                    purchaseAlert = Alert(title: Text("Error"), message: Text("Something went wrong. Please try pressing the Restore button to check again. \(error.localizedDescription)"), dismissButton: .default(Text("Ok")))
                                    isPurchaseAlertDisplayed = true
                                }
                            }
                    
                        case .error(let error):
                            purchaseAlert = errorAlertController(type: error)
                            isPurchaseAlertDisplayed = true
                        }
                        
                    }
                    } else {
                        purchaseAlert = Alert(title: Text("No Internet"), message: Text("Please connect to the Internet and try again."), dismissButton: .default(Text("Ok")))
                        isPurchaseAlertDisplayed = true
                    }
                    
                }, label: {
                    Text("Subscribe")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 250)
                })
                .buttonStyle(TulaButtonStyle())
                .disabled(individualSubscription == false && familySubscription == false)
                .alert(isPresented: $isPurchaseAlertDisplayed, content: {
                    purchaseAlert!
                })
                
                
                Button(action: {
                    if (defaults.value(forKey: nwConnectedKey) as! Bool) == true {
                    SwiftyStoreKit.verifyReceipt(using: AppleValidator) { (receiptResult) in
                        switch receiptResult {
                        case .success(receipt: let receipt):
                            let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: Set(Subscriptions), inReceipt: receipt)
                            
                            switch purchaseResult {
                            case .purchased( _, _):
                                defaults.setValue(true, forKey: hasUserPurchasedKey)
                                NotificationCenter.default.post(purchasedNotification as Notification)
                                //NSApplication.shared.keyWindow?.close()
                                let currentWindow = NSApplication.shared.windows.first { window in
                                    return window.title == "TulaByte - Subscribe"
                                }
                                currentWindow?.close()
                                NotificationCenter.default.post(openMenubarNotification)
                                
                            case .expired( _, _):
                                restoreAlert = Alert(title: Text("Subscription Expired"), message: Text("Your subscription has expired. Please resubcribe to continue."), dismissButton: .default(Text("Ok")))
                                isRestoreAlertDisplayed = true
                                
                            case .notPurchased:
                                restoreAlert = Alert(title: Text("Not Subscribed"), message: Text("A valid subscription isn't associated with this Apple ID. Please try pressing the Restore button to check again."), dismissButton: .default(Text("Ok")))
                                isRestoreAlertDisplayed = true
                                
                            }
                        case .error(error: let error):
                            restoreAlert = Alert(title: Text("Error"), message: Text("Something went wrong. Please try pressing the Restore button to check again. \(error.localizedDescription)"), dismissButton: .default(Text("Ok")))
                            isRestoreAlertDisplayed = true
                        }
                    }
                    } else {
                        restoreAlert = Alert(title: Text("No Internet"), message: Text("Please connect to the Internet and try again."), dismissButton: .default(Text("Ok")))
                        isRestoreAlertDisplayed = true
                    }
                }, label: {
                    Text("Restore Purchases")
                        .font(.body)
                        .foregroundColor(tulabyteGreen)
                })
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented: $isRestoreAlertDisplayed, content: {
                    restoreAlert!
                })
                
                Button(action: {
                    isInfoAlertDisplayed = true
                }, label: {
                    Text("Subscription Information, Privacy & Terms")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                })
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isInfoAlertDisplayed, content: {
                    SubscriptionInfoView(isPresented: $isInfoAlertDisplayed)
                })
            }
        }
    }
}

struct SubscribeView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribeView()
            .frame(width: 350, height: 525, alignment: .center)
            .background(tulabyteBG)
    }
}


func errorAlertController(type: SKError) -> Alert {
    var info: (title: String, message: String)!
    
    switch type.code {
    case .paymentCancelled:
        info = ("Payment Cancelled", "You cancelled the payment. Please try again.")
    case .paymentInvalid:
        info = ("Invalid Product", "This product appears invalid. Please contact support and try again")
    case .paymentNotAllowed:
        info = ("Payment Not Allowed", "You aren't allowed to make a payment from this device, please try again")
    default:
        info = ("Error", "Something went wrong. Please try again. \(type)")
    }
    
    let ac = Alert(title: Text(info.title), message: Text(info.message), dismissButton: .default(Text("Ok")))
    
    return ac
}
