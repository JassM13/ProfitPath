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
            Spacer(minLength: 50)
            ZStack {
                Circle()
                    .frame(width: 140, height: 140)
                    .foregroundColor(.orangeMain)
                    .opacity(0.6)
                    .offset(x: 140, y: -350)
                
                Circle()
                    .frame(width: 495, height: 495)
                    .foregroundColor(.blueMain)
                    .opacity(0.6)
                    .offset(x: 0, y: 300)
                
                VStack(alignment: .leading) {
                    Text("ProfitPath")
                        .fontWeight(.bold)
                        .font(.system(size: 28))
                        .padding(.leading, 24)
                        .padding(.leading, 50)
                        .foregroundColor(.gray)
                    
                    Text("Automated Futures Journal \nand Notes")
                        .fontWeight(.bold)
                        .padding(.leading, 24)
                        .font(.system(size: 40))
                        .padding(.leading, 50)
                    
                    /*HStack {
                        Spacer()
                        Image(.onboarding)
                        Spacer()
                    }*/
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.isMainViewActive = true
                        }) {
                            Image(.arrowRight)
                                .foregroundColor(Color.red)
                                .padding()
                                //.background(Color.white)
                                .foregroundColor(Color.white)
                                .cornerRadius(0)
                        }
                        .frame(width: 64, height: 64)
                        Spacer()
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
