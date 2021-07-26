//
//  ListView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 5/7/21.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var model: TulaModel
    
    var body: some View {
        if model.blockLog[model.statsMode].count == 0 {
            List {
                Text("Nothing's been blocked yet! Start browsing and items will appear here. You can edit the Blocklist and Allowlist in Settings -> Controls -> Modify Lists")
                    .padding(.top, 30)
                    .padding()
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        } else {
            List(model.blockLog[model.statsMode]) { item in
                VStack {
                    HStack{
                        Text("\(item.url)")
                        Spacer()
                        Text("\(item.count)")
                        
                    }
                    Divider()
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
