//
//  XmarkButton.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/14.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButton()
    }
}
