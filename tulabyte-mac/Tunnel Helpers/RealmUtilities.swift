//
//  RealmUtilities.swift
//  tunnel
//
//  Created by Arjun Singh on 10/2/21.
//

import Foundation
import RealmSwift
import WidgetKit
import os.log


//MARK:- CONFIG
let fileURL = FileManager.default
    .containerURL(forSecurityApplicationGroupIdentifier: "group.com.tulabyte.tulabyte")!
    .appendingPathComponent("tulabyte.realm")
let config = Realm.Configuration(fileURL: fileURL)

func addBlockLogItem(url: String, timestamp: Date = Date()) {
    let realm = try! Realm(configuration: config)
    
    let newItem = BlockLogItem()
    newItem.url = url
    newItem.timestamp = timestamp
    
    try! realm.write {
        realm.add(newItem)
        if #available(macOS 11.0, *) {
            os_log("TB MAC REALM: Added \(url) to Realm")
        } else {
            // Fallback on earlier versions
        }
    }
    
    if #available(iOSApplicationExtension 14.0, iOS 14.0, *) {
        if #available(macOS 11, *) {
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            // Fallback on earlier versions
        }
}
}


func retrieveBlockLog() -> Results<BlockLogItem> {
    let realm = try! Realm(configuration: config)
    
    let todayStart = Calendar.current.startOfDay(for: Date())
    
    let blockLog = realm.objects(BlockLogItem.self).sorted(byKeyPath: "timestamp", ascending: false)
    
    if #available(macOS 11.0, *) {
        os_log("TB MAC REALM: There are \(blockLog.count) items in the block log")
    } else {
        // Fallback on earlier versions
    }
    
    return blockLog
}

func retrieveBlockLogToday() -> Results<BlockLogItem> {
    let realm = try! Realm(configuration: config)
    
    let todayStart = Calendar.current.startOfDay(for: Date())
    
    let blockLog = realm.objects(BlockLogItem.self).filter("timestamp >= %@", todayStart).sorted(byKeyPath: "timestamp", ascending: false)
    
    if #available(macOS 11.0, *) {
        os_log("TB MAC REALM: There are \(blockLog.count) items in the block log")
    } else {
        // Fallback on earlier versions
    }
    
    return blockLog
}

func retrieveGroupedCount() -> Array<DisplayBlockLogItem> {
    let realm = try! Realm(configuration: config)
    
    let blockLog = realm.objects(BlockLogItem.self).sorted(byKeyPath: "timestamp", ascending: false)
    
    let groupedLog = Dictionary(grouping: blockLog, by: {$0.url})
    
    var groupedLogCount = Array<DisplayBlockLogItem>()
    
    for (key, value) in groupedLog {
        groupedLogCount.append(DisplayBlockLogItem(url: key, count: value.count))
    }
    
    groupedLogCount.sort(by: {$0.count > $1.count})
    
    return groupedLogCount
}

func retrieveGroupedCountToday() -> Array<DisplayBlockLogItem> {
    let realm = try! Realm(configuration: config)
    
    let todayStart = Calendar.current.startOfDay(for: Date())
    
    let blockLog = realm.objects(BlockLogItem.self).filter("timestamp >= %@", todayStart).sorted(byKeyPath: "timestamp", ascending: false)
    
    let groupedLog = Dictionary(grouping: blockLog, by: {$0.url})
    
    var groupedLogCount = Array<DisplayBlockLogItem>()
    
    for (key, value) in groupedLog {
        groupedLogCount.append(DisplayBlockLogItem(url: key, count: value.count))
    }
    
    groupedLogCount.sort(by: {$0.count > $1.count})
    
    return groupedLogCount
}

func clearBlockLog() {
    let realm = try! Realm(configuration: config)
    try! realm.write {
      realm.deleteAll()
    }
}

