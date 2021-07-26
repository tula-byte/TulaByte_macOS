//
//  BlockLogItem.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 5/7/21.
//

import Foundation
import RealmSwift

class BlockLogItem: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var timestamp: Date = Date()
}

struct DisplayBlockLogItem: Identifiable {
    var id: UUID = UUID()
    var url: String = ""
    var count: Int = 0
}

