//
//  SettingsView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 12/7/21.
//

import SwiftUI
import Cocoa

struct SettingsView: View {
    var body: some View {
        Menu(content: {
            //App Controls
            Menu("Controls") {
                Button("Modify Lists") {
                    let modifyView = ModifyListsTabView()
                    let controller = WindowViewController(rootView: modifyView)
                    WindowTracker.shared.modifyLists = controller.window
                    controller.window?.title = "TulaByte - Modify Lists"
                    controller.showWindow(nil)
                    controller.window?.makeKey()
                    NotificationCenter.default.post(closeMenubarNotification)
                }
                
                Button(action: {
                    TunnelController.shared.resetManager()
                }, label: {
                    Text("Reset Tunnel")
                })
                
                Button(action: {
                    clearBlockLog()
                    NotificationCenter.default.post(blockLogClearedNotification)
                }, label: {
                    Text("Clear Block Log")
                        .foregroundColor(tulabyteRed)
                })
                
            }
            
            //General
            Menu("General") {
                Button("Frequently Asked Questions") {
                    NSWorkspace.shared.open(URL(string: "https://info.tulabyte.com/faq")!)
                }
                
                Button("Support") {
                    NSWorkspace.shared.open(URL(string: "https://tulabyte.com/#support")!)
                }
                
                Button("Privacy Policy") {
                    NSWorkspace.shared.open(URL(string: "https://info.tulabyte.com/privacy-policy")!)
                }
                
                Button("Bulletin Sign Up") {
                    NSWorkspace.shared.open(URL(string: "https://tulabyte.com/#signup")!)
                }
            }
            
            // Subscriptions
            Button("Manage Subscription"){
                NSWorkspace.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
            }
            
        }, label: {
            Image(systemName: "gear")
                .foregroundColor(tulabyteGreen)
        })
        .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: false))
        .padding(.top)
        .padding(.leading)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
        }
    }
}
