//
//  DateFilterView.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI

struct DateFilterView: View {
    @State var start: Date
    @State var end: Date
    var onSubmit: (Date, Date) -> ()
    var onClose: () -> ()
    
    let currentDate = Date()
    
    var body: some View {
        VStack(spacing: 15) {
            DatePicker("Start Date", selection: $start, in: ...currentDate, displayedComponents: [.date])
            
            DatePicker("End Date", selection: $end, in: ...currentDate, displayedComponents: [.date])

            HStack(spacing: 15) {
                Button(action: {
                    onClose()
                }, label: {
                    Text("Cancel")
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                Button(action: {
                    onSubmit(start, end)
                }, label: {
                    Text("Submit")
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(appTint.gradient)
            }
            .padding(.top, 10)
        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}
