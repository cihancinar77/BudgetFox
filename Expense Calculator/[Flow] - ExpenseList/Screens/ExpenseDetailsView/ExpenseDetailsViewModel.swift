//
//  ExpenseDetailsViewModel.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 13.05.2024.
//

import Foundation
import CoreData

class ExpenseDetailsViewModel: ObservableObject {
    
    func updateExpense(model: ExpenseModel) {
        
        guard let matchingObject = getRelevantExpense(item: model) else {
            // Handle the case when the relevant item is not found
            return
        }
      
        matchingObject.id = model.id
        matchingObject.createdAt = model.createdAt
        matchingObject.title = model.title
        matchingObject.subtitle = model.subtitle
        matchingObject.cost = model.cost ?? 0.0
        matchingObject.image = model.image
        matchingObject.expenseListItem = matchingObject.expenseListItem
        PersistenceService.saveContext()
    }
    
    func getRelevantExpense(item: ExpenseModel) -> Expense? {
        var expensesFetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
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
    
}
