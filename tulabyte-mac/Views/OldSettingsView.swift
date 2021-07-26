//
//  OldSettingsView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 13/7/21.
//

import SwiftUI

struct OldSettingsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)
                .padding(.leading)
                .padding(.bottom, 3)
            
            List {
                Section {
                    Button {
                        NSWorkspace.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
                    } label: {
                        Cell(text: "Manage Subscriptions")
                        Spacer()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .insetGroupedStyle(header: Text("Subscriptions".uppercased()).font(.headline), footer: Text(""))
                
                
                Section {
                    Button {
                        print("")
                    } label: {
                        Cell(text: "Sign Up")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .insetGroupedStyle(header: Text("Bulletin".uppercased()).font(.headline), footer: Text(""))
                
                Section  {
                    Button {
                        print("")
                    } label: {
                        Cell(text: "Modify Lists")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                    
                    Button {
                        clearBlockLog()
                    } label: {
                        Cell(text: "Clear Block Log")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                    
                    Button {
                        TunnelController.shared.resetManager()
                    } label: {
                        Cell(text: "Reset Tunnel")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .insetGroupedStyle(header: Text("App Controls".uppercased()).font(.headline), footer: appControlsFooter)
                
                
                Section {
                    Button {
                        NSWorkspace.shared.open(URL(string: "https://info.tulabyte.com/faq")!)
                    } label: {
                        Cell(text: "Frequently Asked Questions")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                    
                    Button {
                        NSWorkspace.shared.open(URL(string: "https://tulabyte.com/#support")!)
                    } label: {
                        Cell(text: "Support")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                    
                    Button {
                        NSWorkspace.shared.open(URL(string: "https://info.tulabyte.com/privacy-policy")!)
                    } label: {
                        Cell(text: "Privacy Policy")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .insetGroupedStyle(header: Text("General".uppercased()).font(.headline), footer: Text(""))
            }
        }
    }
}

struct OldSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        OldSettingsView()
    }
}

let appControlsFooter: Text = Text(
    """
                Manage Lists allows you to control what domains are blocked and allowed by TulaByte.
                
                Clear Log allows you to clear the URLs that are displayed in the block log. This action is irreversible.
                
                Reset Tunnel removes and reconfigures the TulaByte tunnel setup on your device. You should try this if the tunnel is behaving erratically.
                """ ).font(.caption)

struct Cell: View {
    var text: String?
    
    var body: some View {
        HStack{
            Text(text!)
            Spacer()
        }
    }
}

extension View {
    func insetGroupedStyle<V: View>(header: V, footer: V) -> some View {
        #if os(iOS)
        return Section(header: header, footer: footer) {
            self
        }
        #else
        return VStack(alignment: .leading) {
            GroupBox(label: header.padding(.top).padding(.bottom, 6)) {
                VStack {
                    self.padding(.vertical, 3)
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
            footer.padding(.leading)
        }
        #endif
    }
}
