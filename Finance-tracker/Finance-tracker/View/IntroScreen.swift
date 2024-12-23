//
//  IntroScreen.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI

struct IntroScreen: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Whats New int the \nExpense Tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.top, 35)
            
            VStack(alignment: .leading, spacing: 25, content: {
                PointView(symbol: "dollarsign", title: "Transactions", subTitle: "Keep track of your earnings and expense")
                
                PointView(symbol: "chart.bar.fill", title: "Visual Charts", subTitle: "View your transactions using eye-catching graphic representations.")
                
                PointView(symbol: "magnifyingglass", title: "Advance Filters", subTitle: "Findthe expense you want by advance search and filtering")
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            Spacer(minLength: 10)
            Button(action: {
                isFirstTime = false
            }, label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(appTint.gradient)
                    .cornerRadius(20)
                    .contentShape(.rect)
                
            })
        }
        .padding(15)
    }
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String)-> some View {
        HStack(spacing: 20) {
           Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint.gradient)
                .frame(width: 45)
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.gray)
            })
        }
    }
}


#Preview {
    IntroScreen()
}
