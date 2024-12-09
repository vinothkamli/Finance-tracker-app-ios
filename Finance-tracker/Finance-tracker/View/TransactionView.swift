//
//  TransactionView.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI

struct TransactionView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var editTransaction: Transaction?
    
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: Category = .expense
    @State private var titleIsValid = true
    @State private var remarksIsValid = true
    @State private var amountIsValid = true
    @State private var amountFieldCheck: Bool = false
    @State private var currentDate = Date()

    @State private var tint: TintColor = tints.randomElement()!
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 10) {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                
                TransactionCardView(transaction: .init(title: title.isEmpty ? "Title" : title, remark: remarks.isEmpty ? "Remarks" : remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint))
                
                CustomSection("Title", "Title", value: $title, isValid: $titleIsValid)
                CustomSection("Remarks", "Remark", value: $remarks, isValid: $remarksIsValid)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing: 15) {
                        HStack(spacing: 4) {
                            Text(currencySymbol)
                                .font(.callout.bold())
                            
                            TextField("0", text: Binding<String>(
                                get: {
                                    String(format: "%.0f", amount)
                                },
                                set: { newValue in
                                    if let value = NumberFormatter().number(from: newValue) {
                                        amount = value.doubleValue
                                        amountFieldCheck = false
                                    }
                                }), onEditingChanged: { _ in })
                            .keyboardType(.decimalPad)
                        }
                        .padding([.horizontal, .vertical], 14)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .frame(maxWidth: 120)
                        
                        CategoryCheckBox()
                    }
                    
                    if amountFieldCheck {
                        Text("Amount cannot be zero")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .hSpacing(.leading)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.leading)
                    
                    DatePicker("", selection: $dateAdded, in: ...currentDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding([.horizontal, .vertical], 13)
                        .padding(.leading)
                        .background(.background, in: .rect(cornerRadius: 10))
                    
                }
            }
            .padding(15)

        }
        .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction")
        .background(.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("save") {
                    saveButton()
                }
            }
        })
        
        .onAppear(perform: {
            if let editTransaction = editTransaction {
                title = editTransaction.title
                remarks = editTransaction.remark
                amount = editTransaction.amount
                if let category = editTransaction.rawCatgory {
                    self.category = category
                }
                dateAdded = editTransaction.dateAdded
                if let tint = editTransaction.tint {
                    self.tint = tint
                }
            }
        })
    }
    
    func saveButton() {
        
        if title.isEmpty || remarks.isEmpty {
            titleIsValid = false
            remarksIsValid = false
            return
        }
        
        if amount == 0 {
            amountFieldCheck = true
            return
        }
        
        if let editTransaction = editTransaction {
            editTransaction.title = title
            editTransaction.amount = amount
            editTransaction.dateAdded = dateAdded
            editTransaction.remark = remarks
            editTransaction.category = category.rawValue
        } else {
            let transition = Transaction(title: title, remark: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            context.insert(transition)
        }
        
        dismiss()
    }

    
    @ViewBuilder
    func CustomSection(_ title: String, _ hint: String, value: Binding<String>, isValid: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.leading)
            
            TextField(hint, text: value)
                .padding([.horizontal, .vertical], 14)
                .background(.background, in: .rect(cornerRadius: 10))
                .onChange(of: value.wrappedValue) { newValue in
                    isValid.wrappedValue = !newValue.isEmpty
                }
            
            if !isValid.wrappedValue {
                Text("This field cannot be empty")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.leading)
            }
        }
    }
    
    @ViewBuilder
    func CategoryCheckBox() -> some View {
        HStack(spacing: 15) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                HStack(spacing: 5) {
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTint)
                        }
                    }
                    
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding([.horizontal, .vertical], 13)
        .padding(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        
        return formatter
    }
}

#Preview {
    NavigationStack {
        TransactionView()
    }
}
