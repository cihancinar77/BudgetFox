//
//  ImageFullScreenView.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 13.05.2024.
//

import SwiftUI

struct ImageFullScreenView: View {
    let image: UIImage
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("Accent1"))
                            .padding(10)
                    }
                    .background(Color.gray)
                    .clipShape(Circle())
                    .padding(.trailing, 20) // Adjust this value to adjust the distance from the right edge
                }
                .padding(.top, 40) // Adjust this value to adjust the distance from the top edge
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Spacer()
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}
