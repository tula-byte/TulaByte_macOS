//
//  SubscriptionInfoView.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 19/7/21.
//

import SwiftUI

struct SubscriptionInfoView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }, label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(tulabyteRed)
                        .padding(.top, 5)
                        .padding(.trailing, 5)
                        .padding(10)
                })
                .buttonStyle(PlainButtonStyle())
            }
            
            VStack (spacing: 10) {
                Text("Legal")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("A purchase will be applied to your Apple account upon the completion of the 3-day free trial. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. You can cancel anytime in your Apple account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription. For more information, see our Terms and Conditions and Privacy Policy.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.white)
                
                Divider()
                    .frame(width: 25)
                
                Button(action: {
                    NSWorkspace.shared.open(URL(string: "https://info.tulabyte.com/terms-and-conditions")!)
                }, label: {
                    Text("Terms and Conditions")
                        .foregroundColor(tulabyteGreen)
                })
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    NSWorkspace.shared.open(URL(string: "https://info.tulabyte.com/privacy-policy")!)
                }, label: {
                    Text("Privacy Policy")
                        .foregroundColor(tulabyteGreen)
                })
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    NSWorkspace.shared.open(URL(string: "https://tulabyte.com/#support")!)
                }, label: {
                    Text("Support")
                        .foregroundColor(tulabyteGreen)
                })
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
            Spacer()
        }
        .frame(width: 250, height: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct SubscriptionInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionInfoView(isPresented: .constant(true))
    }
}
