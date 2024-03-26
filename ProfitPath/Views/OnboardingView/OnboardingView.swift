//
//  OnboardingView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isMainViewActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading) {
                    Image(.logo)
                        .resizable()
                        .frame(width: 396, height: 396)
                        .foregroundColor(.blueMain)
                        .opacity(0.6)
                    Text("ProfitPath")
                        .fontWeight(.bold)
                        .font(.system(size: 28))
                        .padding(.leading, 24)
                        .padding(.leading, 50)
                        .foregroundColor(.gray)
                    
                    Text("Automated Futures Journal \nand Notes")
                        .fontWeight(.bold)
                        .padding(.leading, 24)
                        .font(.system(size: 36))
                        .padding(.leading, 50)
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.isMainViewActive = true
                        }) {
                            HStack {
                                Text("Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Image(systemName: "arrow.right") // System image for arrow
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.gray) // Your desired background color
                            .cornerRadius(15) // Adjust corner radius as needed
                        }
                        .padding(.horizontal)
                    }
                    .navigationDestination(isPresented: $isMainViewActive) {
                                    MainView(viewModel: MenuViewModel())
                                }
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
