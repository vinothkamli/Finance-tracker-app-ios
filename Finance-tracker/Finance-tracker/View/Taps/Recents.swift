//
//  Recents.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI
import SwiftData

struct Recents: View {
    
    @AppStorage("userName") private var userName: String = ""
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var selectedCategory: Category = .expense
    @State private var showFilterView: Bool = false
    @State private var currentDate = Date()
    
    /// For Animation
    @Namespace private var animation
    
    @Query(sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy) private var transactions: [Transaction]
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            Button {
                                showFilterView = true
                            } label: {
                                Text("\(format(date: startDate,format: "dd - MMM yy")) to \(format(date: endDate,format: "dd - MMM yy"))")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            
                            .hSpacing(.leading)
                                                        
                            FilterTransactionView(startDate: startDate, endDate: endDate) { filteredTransactions in
                                CardView(
                                    income: total(filteredTransactions, category: .income),
                                    expense: total(filteredTransactions, category: .expense)
                                )
                                
                                CustomSegmentControl()
                                    .padding(.bottom, 10)
                                
                                ForEach(filteredTransactions.filter({ $0.category == selectedCategory.rawValue })) { transaction in
                                    NavigationLink(value: transaction) {
                                        TransactionCardView(transaction: transaction)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .blur(radius: showFilterView ? 5 : 0)
                .disabled(showFilterView)
                .navigationDestination(for: Transaction.self) { transaction in
                    TransactionView(editTransaction: transaction)
                }
            }
            
            .overlay {
                if showFilterView {
                    DateFilterView(start: startDate, end: endDate, onSubmit: {
                        start, end in
                        startDate = start
                        endDate = end
                        showFilterView = false
                    }, onClose: {
                        showFilterView = false
                    })
                    .transition(.move(edge: .leading))
                }
            }
            .animation(.snappy, value: showFilterView)
        }
    }
    
    @ViewBuilder
    func HeaderView(_ size: CGSize)-> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10, content: {
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            })
            Spacer(minLength: 10)
            
            NavigationLink() {
                TransactionView()
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(appTint.gradient, in: .circle)
                    .contentShape(.circle)
            }
        }
        
        .visualEffect { content, geometryProxy in
            content
                .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
        }
        .padding(.bottom, 8)
        
        .background(
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
                .padding(.horizontal, -15)
                .padding(.top, -(safeArea.top + 15))
            
        )
    }
    
    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        return 1
    }
    
    ///Custom Segment Control
    @ViewBuilder
    func CustomSegmentControl() -> some View {
        HStack(spacing: 0) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAP", in: animation)
                        }
                    }
                
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedCategory = category
                        }
                    }
            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 10)
    }
}


#Preview {
    Recents()
}
