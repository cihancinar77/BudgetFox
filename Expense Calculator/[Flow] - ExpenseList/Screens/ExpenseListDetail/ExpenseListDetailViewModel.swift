//
//  ExpenseListDetailViewModel.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 12.05.2024.
//

import Foundation
import CoreData

class ExpenseListDetailViewModel: ObservableObject {
    
    private var expensesFetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
    @Published var expenses: [ExpenseModel] = []
    @Published var searchText = ""
    
    var filteredExpenses: [ExpenseModel] {
        if searchText.isEmpty {
            return expenses
        } else {
            let lowercaseSearchText = searchText.lowercased()
            return expenses.filter { $0.title.lowercased().contains(lowercaseSearchText) }
        }
    }
    
    func updateExpensesArray(expenses: [ExpenseModel]) {
        self.expenses = expenses
    }
    
    func deleteExpense(at offsets: IndexSet) {
        for index in offsets {
            let expense = filteredExpenses[index]
            guard let matchingItem = getRelevanExpenseItem(item: expense) else { return }
            PersistenceService.context.delete(matchingItem)
            PersistenceService.saveContext()
        }
    }
    
    func getRelevanExpenseItem(item: ExpenseModel) -> Expense? {
        do {
            let items = try PersistenceService.context.fetch(expensesFetchRequest)
            if let matchingItem = items.first(where: { $0.id == item.id }) {
                // Perform operations with matchingItem
                return matchingItem
            } else {
                // Handle case where no matching item is found
                return nil
            }
        } catch {
            print("Failed to fetch ExpenseListItems: \(error)")
            // Handle error
            return nil
        }
    }
    
    func calculateTotalExpense(items: [ExpenseModel]) -> String {
        let total = items.reduce(0.0) { $0 + ($1.cost ?? 0) }
        return String(format: "%.2f", total)
    }
}
