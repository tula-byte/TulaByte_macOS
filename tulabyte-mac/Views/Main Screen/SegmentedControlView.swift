//
//  SegmentedControlView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 5/7/21.
//

import SwiftUI

struct SegmentedControlView: View {
    
    @EnvironmentObject var model: TulaModel
    
    var body: some View {
        Picker(selection: $model.statsMode, label: Text(""), content: {
            Text("All Time").tag(0)
            Text("Today").tag(1)
        })
        .padding()
        .pickerStyle(SegmentedPickerStyle())
        .labelsHidden()
    }
}

struct SegmentedControlView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControlView()
    }
}
