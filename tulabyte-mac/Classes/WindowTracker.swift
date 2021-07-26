//
//  WindowTracker.swift
//  TulaByte
//
//  Created by Arjun Singh on 21/7/21.
//

import Foundation
import Cocoa
import SwiftUI

enum WindowTypes {
    case modifylists
    case menubar
    case subscribe
}

struct Window {
    var window: NSWindow?
    var popover: NSPopover?
    var type: WindowTypes
}

class WindowTracker {
    static let shared = WindowTracker()
    
    public var popover: NSPopover?
    
    public var subscribe: NSWindow?
    
    public var modifyLists: NSWindow?
}
