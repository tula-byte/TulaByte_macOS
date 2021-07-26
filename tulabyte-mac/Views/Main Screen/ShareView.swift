//
//  ShareView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 5/7/21.
//

import SwiftUI

struct ShareView: View {
    
    @EnvironmentObject var model: TulaModel
    
    var body : some View {
        HStack {
            VStack(alignment: .leading, content: {
                Text("\(model.blockCount[model.statsMode].roundedWithAbbreviations)")
                    .font(.title)
                Text("Trackers Blocked - \((model.statsMode == 0) ? "All Time" : "Today")")
                    .font(.subheadline)
            })
            
            Spacer()
            
            /*
            VStack {
                Image("share")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .onTapGesture {
                        print("share button pressed")
                    }
                
                Text("Share")
                    .font(.footnote)
            }
             */
        }
        .padding()
        .padding(.leading)
        .padding(.trailing)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(tulabyteGreen)
                .padding(.leading)
                .padding(.trailing)
        )
        
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView().environmentObject(TulaModel())
    }
}
