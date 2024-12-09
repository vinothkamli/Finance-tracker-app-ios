//
//  OnboardingScreen.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI

struct OnboardingScreen: View {
    var body: some View {
        ZStack {
            Color("LightBackground").ignoresSafeArea()
            
            VStack {
                VStack {
                    Image("OnboadingImage")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .scaledToFit()
                }
                .frame(height: getRect().height / 1.5)
                
                    
                    VStack(spacing: 20) {
                        Text("spend smarter \nsave more")
                            .font(.system(size: 26))
                            .bold()
                            .padding(20)
                        
                        Button(action: {
              
                        }) {
                            Text("Get Started").bold()
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                                .foregroundColor(.black)

                        }
                        .frame(width: getRect().width * 0.8, height: 50)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(25)
                        
                        HStack {
                            Text("Already have account?")
                            Button(action: {}, label: {
                                Text("Log In")
                                    .foregroundStyle(Color("PrimaryColor"))
                            })
                            
                        }
                    }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.white
                        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 40))
                )
            }
            .ignoresSafeArea()
        }
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

#Preview {
    OnboardingScreen()
}
