//
//  TransactionCardView.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI

struct TransactionCardView: View {
    @Environment(\.modelContext) private var context
    var transaction: Transaction
    var showTransaction: Bool = false
    
    
    var body: some View {
        SwipeAction(cornerRadius: 10, direction: .trailing , content: {
            HStack(spacing: 12) {
                Text("\(String(transaction.title.prefix(1)))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(transaction.color.gradient, in: .circle)
                
                VStack(alignment: .leading, spacing: 2, content: {
                    Text(transaction.title)
                        .foregroundStyle(.primary)
                    
                    Text(transaction.remark)
                        .font(.caption)
                        .foregroundStyle(.primary.secondary)
                    
                    Text(format(date: transaction.dateAdded,format: "dd - MMM yyy"))
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    if showTransaction {
                        Text(transaction.category)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .foregroundStyle(.white)
                            .background(transaction.category == Category.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
                    }
                })
                
                Spacer(minLength: 10)
                Text(currencyString(transaction.amount, allowDigits: 1))
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.background, in: .rect(cornerRadius: 10))
        }, actions: {
            Action(tint: .red, icon: "trash") {
                context.delete(transaction)
            }
        })
    }
}

#Preview {
    ContentView()
}

