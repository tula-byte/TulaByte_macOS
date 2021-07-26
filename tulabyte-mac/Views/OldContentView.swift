//
//  ContentView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 3/7/21.
//
/*
 //
 //  ContentView.swift
 //  tulabyte-mac
 //
 //  Created by Arjun Singh on 3/7/21.
 //

 import SwiftUI
 import NetworkExtension
 import SystemExtensions
 import os.log

 var tulabyteGreen: Color = Color(NSColor(named: "TulabyteGreen")!)
 var tulabyteRed: Color = Color(NSColor(named: "TulabyteRed")!)
 var tulabyteBG: Color = Color(NSColor(named: "TulabyteBackground")!)
 var tulabyteHomeBG: Color = Color(NSColor(named: "TulabyteHomeGradient")!)

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

 class TulaModel: NSObject, ObservableObject, OSSystemExtensionRequestDelegate {
     
     //MARK:- Variables
     @Published var isTunnelOn: Bool = TunnelController.shared.isTunnelEnabled() {
         didSet {
             if isTunnelOn == true {
                 startTunnel()
             } else if isTunnelOn == false {
                 stopTunnel()
             }
         }
     }
     
     @Published var blockCount: [Int] = [retrieveBlockLog().count, retrieveBlockLogToday().count]
     
     @Published var blockLog: [Array<DisplayBlockLogItem>] = [retrieveGroupedCount(), retrieveGroupedCountToday()]
     
     @Published var statsMode: Int = 0 {
         didSet {
             blockCount = [retrieveBlockLog().count, retrieveBlockLogToday().count]
             blockLog = [retrieveGroupedCount(), retrieveGroupedCountToday()]
         }
     }
     
     
     //MARK:- Functions
     func startTunnel() {
         TunnelController.shared.setupTunnel { err in
             guard let extensionIdentifier = extensionBundle.bundleIdentifier else {
                 fatalError("TB MAC: Provider extension bundle ID not found")
             }
             
             let activationRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionIdentifier, queue: .main)
             activationRequest.delegate = self
             OSSystemExtensionManager.shared.submitRequest(activationRequest)
         }
     }
     
     func stopTunnel() {
         TunnelController.shared.enableTunnel(false, isUserExplicitToggle: false)
     }
     
     func enableFilterConfig() {
        TunnelController.shared.enableTunnel(true, isUserExplicitToggle: true)
     }
     
     //MARK:- System Extensions Functions
     func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
         if #available(macOS 11.0, *) {
             os_log("TB MAC: Replacing extension \(request.identifier) version \(existing.bundleShortVersion) with version \(ext.bundleShortVersion)")
         } else {
             // Fallback on earlier versions
         }
         return .replace
     }
     
     func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
         if #available(macOS 11.0, *) {
             os_log("TB MAC: \(request.identifier) extension requires user approval")
         } else {
             // Fallback on earlier versions
         }
     }
     
     func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
         guard result == .completed else {
             if #available(macOS 11.0, *) {
                 os_log("TB MAC: Unexpected result for system extension request. Error: %{public}@", result.rawValue)
             } else {
                 // Fallback on earlier versions
             }
             return
         }
         
         enableFilterConfig()
         os_log("TB MAC: System Extension request granted. Tunnel Enabled.")
     }
     
     func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
         if #available(macOS 11.0, *) {
             os_log("TB MAC: System Extension request failed. Error: \(error.localizedDescription)")
         } else {
             // Fallback on earlier versions
         }
     }
 }


 struct ContentView: View {
     
     @StateObject var model = TulaModel()
     
     var body: some View {
         VStack(spacing: -3, content: {
             HeaderView().environmentObject(model)
             
             ShareView().environmentObject(model)
             
             SegmentedControlView().environmentObject(model)
             
             ListView().environmentObject(model)
         })
         .frame(minWidth: 300, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
         .background(tulabyteHomeBG)
         .onAppear {
             let blockLog = [retrieveGroupedCount(), retrieveGroupedCountToday()]
             let blockCount = [retrieveBlockLog().count, retrieveBlockLogToday().count]
             
             model.blockLog = blockLog
             model.blockCount = blockCount
         }
     }
     
 }


 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }

*/
