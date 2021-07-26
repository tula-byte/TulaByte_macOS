//
//  HeaderView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 5/7/21.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    
    @EnvironmentObject var model: TulaModel
    
    var body: some View {
        HStack {
            HStack {
                Text("TulaByte -")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("\(model.isTunnelOn ? "On" : "Off")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(model.isTunnelOn ? tulabyteGreen : tulabyteRed)
            }
            Spacer()
            Toggle("", isOn: $model.isTunnelOn)
                .toggleStyle(SwitchToggleStyle())
        }
        .padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
