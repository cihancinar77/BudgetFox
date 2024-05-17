//
//  CreateExpenseListItemViewModel.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import Foundation

class CreateExpenseListItemViewModel: ObservableObject {
    
    let systemIcons = ["dollarsign.circle", "creditcard", "briefcase", "cart", "figure.disc.sports", "chart.pie", "building.columns", "banknote", "person", "house", "car", "bicycle", "gift", "fork.knife", "airplane", "heart.text.square"]
    
    func saveNewListItem(date: Date, icon: String, title: String ) {
        
        let expenseItem = ExpenseListItem(context: PersistenceService.context)
        expenseItem.date = date
        expenseItem.expenses = []
        expenseItem.iconName = icon
        expenseItem.name = title
        expenseItem.id = UUID()
   
        PersistenceService.saveContext()
    }
}
