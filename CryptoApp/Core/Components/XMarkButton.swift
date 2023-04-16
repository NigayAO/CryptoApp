//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by Alik Nigay on 16.04.2023.
//

import SwiftUI

struct XMarkButton: View {
    
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.presentationMode) var presentationMode
    @Binding var show: Bool
    
    var body: some View {
        Button {
//            presentationMode.wrappedValue.dismiss()
//            dismiss.callAsFunction()
            show.toggle()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }

    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(show: .constant(false))
    }
}
