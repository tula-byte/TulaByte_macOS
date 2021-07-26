//
//  ListRow.swift
//  tulabyte-mac
//
//  Created by Arjun Singh on 17/7/21.
//

import SwiftUI

struct ListRow: View {
    var text: String
    
    var body: some View {
        VStack {
            Text(text)
            Divider()
        }
    }
}

