//
//  SearchBar.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 17/7/21.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchInput: String = ""
    
    @EnvironmentObject var model: ModifyListsModel
    
    var body: some View {
            // Search Area TextField
            TextField("Search", text: $searchInput, onEditingChanged: { focused in
                if focused {
                    model.searching = true
                }
            })
            .onChange(of: searchInput, perform: { searchText in
                model.searchInput = searchInput
            
                if searchInput.count != 0 {
                    model.searching = true
                } else {
                    model.searching = false
                }
                
                model.updateFilteredList()
                
            })
            .accentColor(.white)
            .foregroundColor(.white)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.vertical, 10)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
