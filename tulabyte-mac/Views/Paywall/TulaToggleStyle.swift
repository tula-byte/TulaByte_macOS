//
//  TulaToggleStyle.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 18/7/21.
//

import Foundation
import SwiftUI
import Cocoa

struct TulaToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return VStack {
            
            configuration.label
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .foregroundColor(.clear)
                        .opacity(0)
                        .background(configuration.isOn ? tulabyteGreen : tulabyteActiveButton)
                )
                .overlay (
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(tulabyteGreen, lineWidth: 3)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
