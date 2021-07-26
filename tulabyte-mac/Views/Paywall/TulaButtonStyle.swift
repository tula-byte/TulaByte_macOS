//
//  TulaButtonStyle.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 18/7/21.
//

import Foundation
import SwiftUI
import Cocoa

struct TulaButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return TulaButtonView(configuration: configuration)
    }
    
    struct TulaButtonView: View {
        
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            VStack {
                configuration.label
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5.0)
                            .foregroundColor(.clear)
                            .opacity(0)
                            .background(
                                (isEnabled ? tulabyteActiveButton : tulabyteInactiveButton)
                                    .cornerRadius(5.0)
                            )
                    )
                    .overlay (
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(isEnabled ? tulabyteGreen : Color.clear, lineWidth: 3)
                    )
            }
        }
    }
    
}

