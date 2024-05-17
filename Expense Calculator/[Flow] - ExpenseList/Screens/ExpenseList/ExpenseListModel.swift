//
//  ExpenseListModel.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import Foundation

struct ExpenseModel: Identifiable {
    let id: UUID?
    let createdAt: Date
    let title: String
    let subtitle: String?
    let cost: Double?
    let image: Data?
    let parentListId: UUID?
}

struct ExpenseListItemModel: Identifiable {
    let id: UUID?
    let date: Date?
    let name: String
    let totalCost: String?
    var expenses: [ExpenseModel]
    let iconName: String
}
