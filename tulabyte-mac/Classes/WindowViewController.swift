//
//  WindowViewController.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 12/7/21.
//

import Cocoa
import SwiftUI

class WindowViewController<RootView: View>: NSWindowController{
    convenience init(rootView: RootView) {
        let hostingController = NSHostingController(rootView: rootView.frame(width: 400, height: 500).background(tulabyteBG).preferredColorScheme(.dark))
        let window = NSWindow(contentViewController: hostingController)
        window.setContentSize(NSSize(width: 400, height: 500))
        self.init(window: window)
    }
}
