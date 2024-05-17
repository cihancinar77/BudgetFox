//
//  CreateExpenseViewModel.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 11.05.2024.
//

import Foundation
import SwiftUI
import CoreData

class CreateExpenseViewModel: ObservableObject {
    
    private var fetchRequest: NSFetchRequest<ExpenseListItem> {
        return ExpenseListItem.fetchRequest()
    }
    
    func getRelevantListItem(item: ExpenseListItemModel) -> ExpenseListItem? {
        do {
            let items = try PersistenceService.context.fetch(fetchRequest)
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
    
    func addExpense(model: ExpenseModel, listItem: ExpenseListItemModel) {
        
        guard let matchingObject = getRelevantListItem(item: listItem) else {
            // Handle the case when the relevant item is not found
            return
        }
        let expenseContext = Expense(context: PersistenceService.context)
        expenseContext.id = model.id
        expenseContext.createdAt = model.createdAt
        expenseContext.title = model.title
        expenseContext.subtitle = model.subtitle
        expenseContext.cost = model.cost ?? 0.0
        expenseContext.image = model.image
        expenseContext.expenseListItem = matchingObject

        matchingObject.addToExpenses(expenseContext)
        PersistenceService.saveContext()
        
 
    }
}
