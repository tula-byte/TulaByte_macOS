//
//  EditView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 17/7/21.
//

import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var model: ModifyListsModel
    
    @State var displaySingleItemAddAlert: Bool = false
    @State var displayResetListAlert: Bool = false
    @State var displayClearListAlert: Bool = false
    
    var body: some View {
        VStack(spacing:15) {
            Text("Right click any list item to see options")
                .font(.caption)
            
            HStack (alignment: .firstTextBaseline ,spacing: 30) {
                Button(action: {
                    displaySingleItemAddAlert = true
                }, label: {
                    Text("Add a \(model.listModeLabel) URL")
                        .frame(idealWidth: 150)
                })
                .sheet(isPresented: $displaySingleItemAddAlert, content: {
                    AddSingleURLView(isDisplayed: $displaySingleItemAddAlert)
                        .environmentObject(model)
                })
                
                
                Button(action: {
                    let panel = fileOpenPanel(listModeLabel: model.listModeLabel)
                    
                    panel.begin { response in
                        if response == NSApplication.ModalResponse.OK, let fileURL = panel.url {
                            model.addFileToList(fileURL)
                            model.updateList()
                            model.updateFilteredList()
                        }
                    }
                }, label: {
                    Text("Add a \(model.listModeLabel) file")
                        .frame(idealWidth: 150)
                })
            }
            
            
            HStack (alignment: .firstTextBaseline ,spacing: 30) {
                Button(action: {
                    displayResetListAlert = true
                }, label: {
                    Text("Reset \(model.listModeLabel)list")
                        .frame(idealWidth: 150)
                })
                .alert(isPresented: $displayResetListAlert, content: {
                    Alert(title: Text("Reset \(model.listModeLabel)list"), message: Text("This will delete all custom URLs and reset the \(model.listModeLabel)list to the TulaByte default"), primaryButton: .destructive(Text("Reset"), action: {
                        clearList(dKey: model.key)
                        switch model.listMode {
                        case .allow:
                            setupTulaByteAllowlist()
                        case .block:
                            setupTulaByteBlocklist()
                        }
                        model.updateList()
                        model.updateFilteredList()
                    }), secondaryButton: .cancel())
                })
                
                Button(action: {
                    displayClearListAlert = true
                }, label: {
                    Text("Clear \(model.listModeLabel)list")
                        .foregroundColor(.red)
                        .frame(idealWidth: 150)
                })
                .alert(isPresented: $displayClearListAlert, content: {
                    Alert(title: Text("Clear \(model.listModeLabel)list"), message: Text("This will delete all URLs and completely clear the \(model.listModeLabel)list"), primaryButton: .destructive(Text("Clear"), action: {
                        clearList(dKey: model.key)
                        model.updateList()
                        model.updateFilteredList()
                    }), secondaryButton: .cancel())
                })
            }
            
            Button(action: {
                NSWorkspace.shared.open(URL(string: "https://info.tulabyte.com/lists-guide")!)
            }, label: {
                Label("Help", systemImage: "questionmark")
                    .frame(idealWidth: 150)
            })
        }
    }
}

// helper functions
func fileOpenPanel(listModeLabel: String) -> NSOpenPanel {
    let panel = NSOpenPanel()
    panel.nameFieldLabel = "Choose a \(listModeLabel)list file (.txt)"
    panel.canChooseFiles = true
    panel.canChooseDirectories = false
    panel.allowsMultipleSelection = false
    panel.allowedFileTypes = ["txt"]
    
    return panel
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
