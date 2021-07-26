//
//  AddSingleURLView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 17/7/21.
//

import SwiftUI

struct AddSingleURLView: View {
    
    @EnvironmentObject var model: ModifyListsModel
    
    @Binding var isDisplayed: Bool
    @State var newURL: String = ""
    
    var body: some View {
        VStack (spacing: 10) {
            Text("Add a \(model.listModeLabel)list URL")
                .font(.title3)
            
            Divider()
                .padding(.bottom, 10)
                .padding(.horizontal)
            
            TextField("URL to add", text: $newURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            HStack(spacing: 10) {
                Button(action: {
                    isDisplayed = false
                }, label: {
                    Text("Cancel")
                })
                
                Button(action: {
                    if newURL != "" {
                        model.addSingleItemToList(newURL)
                        model.updateList()
                        model.updateFilteredList()
                        isDisplayed = false
                    }
                }, label: {
                    Text("Add")
                })
            }
        }
        .frame(width: 200, height: 150)
        .padding()
    }
}
