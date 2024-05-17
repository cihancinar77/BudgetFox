//
//  ExpenseListItem+CoreDataProperties.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 12.05.2024.
//
//

import Foundation
import CoreData


extension ExpenseListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseListItem> {
        return NSFetchRequest<ExpenseListItem>(entityName: "ExpenseListItem")
    }

    @NSManaged public var date: Date?
    @NSManaged public var iconName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension ExpenseListItem {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension ExpenseListItem : Identifiable {

}
