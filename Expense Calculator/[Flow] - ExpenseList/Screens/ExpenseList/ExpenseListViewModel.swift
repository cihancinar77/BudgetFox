//
//  ExpenseListViewModel.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import Foundation
import SwiftUI
import CoreData

class ExpenseListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var expenseList: [ExpenseListItemModel] = []
    @Published var expenses: [ExpenseModel] = []
    
    private var expenseListItemsFetchRequest: NSFetchRequest<ExpenseListItem> = ExpenseListItem.fetchRequest()
    private var expensesFetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
    
    func fetchExpenseList() {
        do {
            let items = try PersistenceService.context.fetch(expenseListItemsFetchRequest)
            let mappedItems = items.map { mapToExpenseListItemModel($0) }
            expenseList = mappedItems
        } catch {
            print("Failed to fetch ExpenseListItems: \(error)")
            expenseList = []
        }
    }
    
    func fetchExpenses() {
        do {
            let fetchedExpenses = try PersistenceService.context.fetch(expensesFetchRequest)
            let mappedItems = fetchedExpenses.map { i in
                return ExpenseModel(id: i.id, createdAt: i.createdAt ?? Date(), title: i.title ?? "", subtitle: i.subtitle, cost: i.cost, image: i.image, parentListId: i.expenseListItem?.id)
            }
            self.expenses = mappedItems
        } catch {
            print("Failed to fetch ExpenseListItems: \(error)")
            self.expenses = []
        }
    }
    
    var filteredExpenseList: [ExpenseListItemModel] {
        if searchText.isEmpty {
            return expenseList
        } else {
            let lowercaseSearchText = searchText.lowercased()
            return expenseList.filter { $0.name.lowercased().contains(lowercaseSearchText) }
        }
    }
    
    func deleteExpense(at offsets: IndexSet) {
        for index in offsets {
            let expenseList = filteredExpenseList[index]
            guard let matchingItem = getRelevantListItem(item: expenseList) else { return }
            PersistenceService.context.delete(matchingItem)
            PersistenceService.saveContext()
        }
    }
    
    func getRelevantListItem(item: ExpenseListItemModel) -> ExpenseListItem? {
        do {
            let items = try PersistenceService.context.fetch(expenseListItemsFetchRequest)
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
    
    private func mapToExpenseListItemModel(_ item: ExpenseListItem) -> ExpenseListItemModel {
        var includedExpenses = expenses.filter { i in
            i.parentListId == item.id
        }
        
        let totalCost = includedExpenses.compactMap { $0.cost }.reduce(0, +)
        let roundedTotalCost = (totalCost * 100).rounded() / 100
        
        return ExpenseListItemModel(
            id: item.id,
            date: item.date,
            name: item.name ?? "",
            totalCost: "\(roundedTotalCost)",
            expenses: includedExpenses,
            iconName: item.iconName ?? ""
        )
    }
    
    private func mapToExpenseModel(_ expense: Expense) -> ExpenseModel? {
        guard let createdAt = expense.createdAt, let title = expense.title else {
            return nil
        }
        
        return ExpenseModel(
            id: expense.id,
            createdAt: createdAt,
            title: title,
            subtitle: expense.subtitle,
            cost: expense.cost,
            image: expense.image,
            parentListId: expense.expenseListItem?.id
        )
    }
    
    func calculateTotalExpense(item: ExpenseListItemModel) -> String {
        let total = item.expenses.reduce(0.0) { $0 + ($1.cost ?? 0) }
        return String(format: "%.2f", total)
    }
    
    func dateFormatToString(item: ExpenseListItemModel) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        guard let date = item.date else { return "" }
        return dateFormatter.string(from: date)
    }
}
