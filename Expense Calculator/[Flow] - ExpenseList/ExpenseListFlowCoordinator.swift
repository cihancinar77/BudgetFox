//
//  ExpenseListFlowCoordinator.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import UIKit

class ExpenseListFlowCoordinator: FlowCoordination {
    
    private(set) var navigationController = UINavigationController()
    private var expenseListViewController: UIViewController?
    
    func start() {
        let viewController = ExpenseListViewController()
        self.expenseListViewController = viewController
        navigationController.viewControllers = [viewController]
        navigationController.isNavigationBarHidden = true
        
        navigationController.tabBarItem = UITabBarItem(
            title: "List",
            image: UIImage(systemName: "list.bullet.clipboard")?.withTintColor(.gray, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "list.clipboard.fill")?.withTintColor(UIColor(named: "Accent1") ?? .yellow, renderingMode: .alwaysOriginal)
        )
    }
}
