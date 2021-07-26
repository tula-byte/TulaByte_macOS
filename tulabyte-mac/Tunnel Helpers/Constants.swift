//
//  Constants.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 18/7/21.
//

import Foundation
import SwiftUI
import Cocoa

let openMenubarNotification: Notification = NSNotification(name: NSNotification.Name("openMenubar"), object: nil) as Notification
let closeMenubarNotification: Notification = NSNotification(name: NSNotification.Name("closeMenubar"), object: nil) as Notification
let menubarWillAppearNotification: Notification = NSNotification(name: NSNotification.Name("menubarWillAppear"), object: nil) as Notification

let blockLogClearedNotification: Notification = NSNotification(name: NSNotification.Name("blockLogCleared"), object: nil) as Notification

var tulabyteGreen: Color = Color(NSColor(named: "TulabyteGreen")!)
var tulabyteRed: Color = Color(NSColor(named: "TulabyteRed")!)
var tulabyteBG: Color = Color(NSColor(named: "TulabyteBackground")!)
var tulabyteHomeBG: Color = Color(NSColor(named: "TulabyteHomeGradient")!)
var tulabyteInactiveButton: Color = Color(NSColor(named: "TulabyteInactiveButton")!)
var tulabyteActiveButton: Color = Color(NSColor(named: "TulabyteActiveButton")!)

var extensionBundle: Bundle {
    let directoryURL = URL(fileURLWithPath: "Contents/Library/SystemExtensions", relativeTo: Bundle.main.bundleURL)
    let extensionsURLs: [URL]
    do {
        extensionsURLs = try FileManager.default.contentsOfDirectory(at: directoryURL,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: .skipsHiddenFiles)
    } catch let error {
        fatalError("TB MAC: Failed to get the contents of \(directoryURL.absoluteString): \(error.localizedDescription)")
    }
    
    guard let extensionURL = extensionsURLs.first else {
        fatalError("TB MAC: Failed to find any system extensions")
    }
    
    guard let extensionBundle = Bundle(url: extensionURL) else {
        fatalError("TB MAC: Failed to create a bundle with URL \(extensionURL.absoluteString)")
    }
    
    return extensionBundle
}
