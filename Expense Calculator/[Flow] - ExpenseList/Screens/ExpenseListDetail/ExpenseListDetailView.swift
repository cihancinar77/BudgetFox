//
//  ExpenseListDetailView.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import SwiftUI

struct ExpenseListDetailView: View {
    @StateObject var viewModel = ExpenseListDetailViewModel()
    @State var selectedExpenseDetail: ExpenseListItemModel
    @State var didTapCreateExpense = false
    @State var totalCost: String = "N/A"
    @AppStorage("selectedCurrency") var selectedCurrency = "USD"
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack(alignment: .center) {
                    Image(systemName: selectedExpenseDetail.iconName)
                        .font(.title)
                        Text(selectedExpenseDetail.name)
                            .font(.title)
                    Spacer()
                        Text("Total: \(selectedCurrency)\(totalCost)")
                        .font(.system(size: 14))
                            .multilineTextAlignment(.trailing)
                    
                }
                .padding()
                    
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                List {
                    ForEach(viewModel.filteredExpenses) { expense in
                        NavigationLink(destination: ExpenseDetailsView(expense: expense)) {
                            ExpenseRowView(expense: expense, selectedCurrency: selectedCurrency)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteExpense(at: indexSet)
                    }
                }
             
                .onAppear(perform: {
                    viewModel.updateExpensesArray(expenses: selectedExpenseDetail.expenses)
                    totalCost = viewModel.calculateTotalExpense(items: selectedExpenseDetail.expenses)
                })
            }
            
            Button(action: {
                didTapCreateExpense = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add expense")
                }
                .padding()
                .background(Color("Accent1").gradient)
                .foregroundColor(.white)
                .font(.body)
                .cornerRadius(25)
            }
            .padding(.bottom, 24) // Adjust the button position up
            .padding(.trailing, 24)
            .sheet(isPresented: $didTapCreateExpense, onDismiss: {
                viewModel.updateExpensesArray(expenses: selectedExpenseDetail.expenses)
                totalCost = viewModel.calculateTotalExpense(items: selectedExpenseDetail.expenses)
            }) {
                CreateExpenseView(showView: $didTapCreateExpense, listItem: $selectedExpenseDetail)
            }
        }
    }
}

struct ExpenseRowView: View {
    var expense: ExpenseModel
    var selectedCurrency: String
    
    var body: some View {
        HStack {
            if let imageData = expense.image,
                       let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: "cart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
            
            VStack(alignment: .leading) {
                Text("\(expense.title)")
                    .font(.body)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(DateFormatters.dateFormatToString(item: expense.createdAt))
                    .font(.caption)
                    .foregroundColor(Color("Accent1"))
                if let cost = expense.cost {
                    Text("Cost: \(selectedCurrency)\(String(format: "%.2f", cost))")
                        .font(.caption)
                } else {
                    Text("Cost: N/A")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(4)
    }
}

struct ExpenseListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let expense = ExpenseModel(id: UUID(), createdAt: Date(), title: "fuel", subtitle: "18721km", cost: 53.2, image: nil, parentListId: UUID())
        let selectedExpenseDetail = ExpenseListItemModel(id: UUID(), date: Date(), name: "Sample", totalCost: "100", expenses: [expense], iconName: "dollarsign.circle")
        
        return ExpenseListDetailView(selectedExpenseDetail: selectedExpenseDetail, totalCost: "N/A")
    }
}
