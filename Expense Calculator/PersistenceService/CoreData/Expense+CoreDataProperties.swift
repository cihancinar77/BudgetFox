//
//  Expense+CoreDataProperties.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 12.05.2024.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var cost: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var image: Data?
    @NSManaged public var expenseListItem: ExpenseListItem?

}

extension Expense : Identifiable {

}
