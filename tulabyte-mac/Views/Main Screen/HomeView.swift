//
//  MainView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 19/7/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: TulaModel
    
    var body: some View {
        VStack(spacing: -3, content: {
                
            SettingsView()
            
            HeaderView().environmentObject(model)
            
            ShareView().environmentObject(model)
            
            SegmentedControlView().environmentObject(model)
            
            ListView().environmentObject(model)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
