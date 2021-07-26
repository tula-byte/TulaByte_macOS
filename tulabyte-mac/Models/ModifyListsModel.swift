//
//  ModifyListsModel.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 17/7/21.
//

import Foundation

class ModifyListsModel: ObservableObject {
    
    @Published var listMode: ListMode = .block {
        didSet {
            listArray = getListArray(mode: listMode)
            searching = false
            
            switch listMode {
            case .allow:
                listModeLabel = "Allow"
                oppListModeLabel = "Block"
                key = tulabyteAllowlistKey
                oppKey = tulabyteBlocklistKey
            case .block:
                listModeLabel = "Block"
                oppListModeLabel = "Allow"
                key = tulabyteBlocklistKey
                oppKey = tulabyteAllowlistKey
            }
        }
    }
    
    @Published var listModeLabel: String = "Block"
    @Published var oppListModeLabel: String = "Allow"
        
    @Published var listArray: [String] = getListArray(mode: .block)
    @Published var filteredListArray: [String] = getListArray(mode: .block)
    
    @Published var searching = false
    @Published var searchInput: String = ""
    
    @Published var key: String = tulabyteBlocklistKey
    @Published var oppKey: String = tulabyteAllowlistKey
    
    public func updateList() {
        listArray = getListArray(mode: listMode)
    }
    
    public func updateFilteredList() {
            filteredListArray = listArray.filter({ (searchTerm: String) -> Bool in
                //check whether an element contains the search term and return a boolean to confirm this
                return searchTerm.range(of: searchInput, options: .caseInsensitive) != nil
            })
    }
    
    public func swapRow(index: Int) {
        setAllowlistDomain(dKey: oppKey, domain: listArray[listArray.firstIndex(of: searching ? (filteredListArray[index]) : (listArray[index]))!])
        
        deleteRow(index: index)
    }

    public func deleteRow(index: Int) {
        var key: String {
            switch listMode {
            case .allow:
                return tulabyteAllowlistKey
            case .block:
                return tulabyteBlocklistKey
            }
        }
        
        disableListDomain(dKey: key, domain: listArray[listArray.firstIndex(of: searching ? (filteredListArray[index]) : (listArray[index]))!])
        
        updateList()
        
        if searching {
            updateFilteredList()
        }
    }
    
    public func addSingleItemToList(_ domain: String) {
        setAllowlistDomain(dKey: key, domain: domain.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    public func addFileToList(_ fileURL: URL) {
    
        var key: String {
            switch listMode {
            case .allow:
                return tulabyteAllowlistKey
            case .block:
                return tulabyteBlocklistKey
            }
        }
        
        var newDomains = [String: Bool]()
        
        do {
            if fileURL.startAccessingSecurityScopedResource() == true {
                let contents = try String(contentsOfFile: fileURL.path)
                let lines = contents.components(separatedBy: "\n")
                for line in lines {
                    if (line.trimmingCharacters(in: CharacterSet.whitespaces) != "" && !line.starts(with: "#")) && !line.starts(with: "\n") {
                        newDomains[line] = true
                        NSLog("TBT DB: \(line) enabled on blocklog")
                    }
                }
            } else {
                NSLog("TBT Lists ERROR: Permission not received to read file")
            }
            fileURL.stopAccessingSecurityScopedResource()
        }
        catch{
            NSLog("TBT Lists ERROR: \(error)")
        }
        
        DispatchQueue.global(qos: .utility).async {
            addCustomList(dKey: key, newDomains: newDomains)
            DispatchQueue.main.async {
                self.updateList()
                self.updateFilteredList()
            }
        }
    }
}

    

func getListArray(mode: ListMode) -> [String] {
    if mode == .allow {
        return getAllowlistArray()
    } else {
        return getBlocklistArray()
    }
}

enum ListMode: Hashable {
    case allow
    case block
}



