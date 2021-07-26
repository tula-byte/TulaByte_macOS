//
//  ModifyListsView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 13/7/21.
//

import SwiftUI
import Cocoa

struct ModifyListsTabView: View {
    
    @StateObject var model = ModifyListsModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Picker(selection: $model.listMode, label: Text(""), content: {
                    Text("Blocklist")
                        .tag(ListMode.block)
                        .foregroundColor(.white)
                    Text("Allowlist")
                        .tag(ListMode.allow)
                        .foregroundColor(.white)
                })
                .padding(.top, 15)
                .padding(.horizontal)
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                
                SearchBar()
                    .environmentObject(model)
                    .padding(.horizontal)
            }
            .background(tulabyteBG)
            
            List {
                ForEach(model.searching ? (0..<model.filteredListArray.count) : (0..<model.listArray.count), id: \.self) { row in
                    ListRow(text: "\(model.searching ? (model.filteredListArray[row]) : (model.listArray[row]))")
                        .contextMenu(ContextMenu(menuItems: {
                            //Swap List action
                            Button(action: {
                                model.swapRow(index: row)
                            }, label: {
                                Text("Move to \(model.oppListModeLabel)list")
                            })
                            
                            
                            //Delete Action
                            Button(action: {
                                model.deleteRow(index: row)
                            }, label: {
                                Text("Delete")
                                    .foregroundColor(tulabyteRed)
                            })
                        }))
                }
            }
            
            EditView()
                .environmentObject(model)
                .frame(minWidth: 300, maxWidth: .infinity)
                .padding(.top, 12.5)
                .padding(.bottom)
                .background(tulabyteBG)
        }
        .onDisappear(perform: {
            NotificationCenter.default.post(openMenubarNotification)
        })
    }
}

struct ModifyListsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyListsTabView()
            .frame(width: 400, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
