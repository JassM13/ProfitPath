//
//  NavigationCell.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct NavigationCell: View {
    let viewModel: MeditationModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.text)
                        .fontWeight(.medium)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Button(action: {
                    }) {
                        Text("\(viewModel.time) min")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .font(.system(size: 12))
                    }
                    .padding(.init(top: 5, leading: 12, bottom: 5, trailing: 12))
                    .background(.white)
                    .cornerRadius(16)
                }
                .padding()
                
                Spacer()
            }
            Image(viewModel.image)
                .resizable()
                .frame(width: 48, height: 48)
                .padding(.bottom)
        }
        .background(viewModel.background)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationCell(viewModel: MeditationModel(text: "Reflection",
                                              image: .reflection,
                                              background: .blueMain,
                                              time: 6, index: 1))
    .frame(width: UIScreen.main.bounds.width/2)
}
