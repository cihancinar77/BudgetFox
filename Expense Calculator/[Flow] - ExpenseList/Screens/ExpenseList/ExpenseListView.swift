//
//  ExpenseListView.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import SwiftUI
import CoreData

struct ExpenseListContentView: View {
    var body: some View {
        NavigationView {
            ExpenseListView()
                .navigationTitle("Expense Categories")
        }
    }
}

struct ExpenseListView: View {
    @StateObject private var viewModel = ExpenseListViewModel()
    @State private var didTapCreateList = false
    
    init() {
        let appearance = UINavigationBarAppearance()

         appearance.configureWithOpaqueBackground() // configure
    
         let backItemAppearance = UIBarButtonItemAppearance()
         backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor(named: "Accent1")] // fix text color
         appearance.backButtonAppearance = backItemAppearance
          
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(UIColor(named: "Accent1") ?? .orange, renderingMode: .alwaysOriginal) // fix indicator color
         appearance.setBackIndicatorImage(image, transitionMaskImage: image)
          
         UINavigationBar.appearance().tintColor = .white // probably not needed
          
         UINavigationBar.appearance().standardAppearance = appearance
         UINavigationBar.appearance().scrollEdgeAppearance = appearance
         UINavigationBar.appearance().compactAppearance = appearance
         UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 12)
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                if viewModel.filteredExpenseList.isEmpty {
                    EmptyListView(didTapCreateList: $didTapCreateList)
                } else {
                    List {
                        ForEach(viewModel.filteredExpenseList) { expenseListItem in
                            NavigationLink(destination: ExpenseListDetailView(selectedExpenseDetail: expenseListItem)) {
                                ExpenseListRowView(expenseListItem: expenseListItem, viewModel: viewModel)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteExpense(at: indexSet)
                            viewModel.fetchExpenses()
                            viewModel.fetchExpenseList()
                        }
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
            .tint(Color("Accent1"))
            .navigationTitle("Expense Categories")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                didTapCreateList = true
            }) {
                Image(systemName: "plus")
                    .tint(Color("Accent1"))
                    .font(.title)
            }
            )
            .sheet(isPresented: $didTapCreateList, onDismiss: {
                viewModel.fetchExpenses()
                viewModel.fetchExpenseList()
            }) {
                CreateExpenseListItemView(showView: $didTapCreateList)
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                viewModel.fetchExpenses()
                viewModel.fetchExpenseList()
            }
        }
    }
}

struct EmptyListView: View {
    @Binding var didTapCreateList: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "cart.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(Color("Accent1"))
                .padding(.bottom)
            Text("No Expenses Found")
                .font(.headline)
                .foregroundColor(Color("Accent1"))
                .padding(.bottom)
            
            Button(action: {
                didTapCreateList = true
            }) {
                Text("Create a list")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color("Accent1").gradient)
                    .cornerRadius(10)
                    .font(.body)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ExpenseListRowView: View {
    var expenseListItem: ExpenseListItemModel
    var viewModel: ExpenseListViewModel
    @AppStorage("selectedCurrency") var selectedCurrency = "USD"
    var body: some View {
        HStack {
            Image(systemName: expenseListItem.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text("\(expenseListItem.name)")
                    .font(.body)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.dateFormatToString(item: expenseListItem))
                    .font(.caption)
                    .foregroundColor(Color("Accent1"))
                Text("total: \(selectedCurrency)\(expenseListItem.totalCost != nil ? "\(expenseListItem.totalCost!)" : "N/A")")
                    .font(.caption)
            }
        }
        .padding(4)
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListView()
    }
}
