//
//  MenuBarController.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 12/7/21.
//

import Foundation
import AppKit

class MenuBarController {
    private var menuBar: NSStatusBar
    private var menuItem: NSStatusItem
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
    
    init(_ popover: NSPopover) {
        self.popover = popover
        menuBar = NSStatusBar.init()
        menuItem = menuBar.statusItem(withLength: 40)
        
        if let menuBarButton = menuItem.button {
            menuBarButton.image = #imageLiteral(resourceName: "TulaIcon")
            menuBarButton.image?.size = NSSize(width: 22.0, height: 14.0)
            menuBarButton.image?.isTemplate = true
            
            menuBarButton.action = #selector(togglePopover(sender:))
            menuBarButton.target = self
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mousePressedOutsideApp)
        NotificationCenter.default.addObserver(self, selector: #selector(showPopover(_:)), name: openMenubarNotification.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidePopover(_:)), name: closeMenubarNotification.name, object: nil)
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if (popover.isShown) {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    @objc func showPopover(_ sender: AnyObject) {
        if let menuBarButton = menuItem.button {
            NotificationCenter.default.post(menubarWillAppearNotification)
            menuBarButton.isHighlighted = true
            popover.show(relativeTo: menuBarButton.bounds, of: menuBarButton, preferredEdge: NSRectEdge.maxY)
            eventMonitor?.start()
        }
    }
    
    @objc func hidePopover(_ sender: AnyObject) {
        menuItem.button?.isHighlighted = false
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func mousePressedOutsideApp(_ event: NSEvent?) {
        if popover.isShown {
            hidePopover(event!)
        }
    }
}

class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as! NSObject
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
