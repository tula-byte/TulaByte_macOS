//
//  AppDelegate.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 3/7/21.
//

import Cocoa
import SwiftUI
import Network
import os.log
import SwiftyStoreKit

let nwConnectedKey = "NetworkConnected"

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let nwmon = NWPathMonitor()
    var menuBar: MenuBarController?
    var popover = NSPopover.init()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().preferredColorScheme(.dark)
        
        //setup lists
        setupTulaByteBlocklist()
        setupTulaByteAllowlist()
        
        //setup network monitor
        setupNWMonitor()
        
        //create menu bar item
        popover.contentSize = NSSize(width: 300.0, height: 400.0)
        popover.contentViewController = NSHostingController(rootView: contentView)
        menuBar = MenuBarController.init(popover)
        
        //update costs
        for sub in Subscriptions {
            addSubscriptionInfoToDefaults(id: sub)
        }
        
        // complete app store transactions
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                default:
                    break
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationCenter.default.post(openMenubarNotification)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    func setupNWMonitor() {
        nwmon.pathUpdateHandler = { path in
            if path.status == .satisfied {
                defaults.setValue(true, forKey: nwConnectedKey)
                os_log("TB NW: Connected")
            } else if path.status == .unsatisfied {
                defaults.setValue(false, forKey: nwConnectedKey)
                os_log("TB NW: Not Connected")
            }
        }
            
        let q = DispatchQueue(label: nwConnectedKey)
        
        nwmon.start(queue: q)
    }

}

