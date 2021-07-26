//
//  PaywallView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 19/7/21.
//

import SwiftUI

struct PaywallView: View {
    var body: some View {
        VStack(spacing: 25) {
            Text("You must purchase a subscription to use the TulaByte app.")
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
            
            Button(action: {
                let subscribeView = SubscribeView().background(tulabyteBG)
                let controller = WindowViewController(rootView: subscribeView)
                WindowTracker.shared.subscribe = controller.window
                controller.window?.title = "TulaByte - Subscribe"
                controller.showWindow(nil)
                controller.window?.makeKey()
                NotificationCenter.default.post(closeMenubarNotification)
            }, label: {
                Text("Purchase Subscription")
                    .foregroundColor(tulabyteGreen)
                    .fontWeight(.medium)
            })
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
    }
}
