//
//  ApplicationFlowCoordinator.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import UIKit

class ApplicationFlowCoordinator: FlowCoordination {
    
    let window: UIWindow
    private var dashboardFlowCoordinator: FlowCoordination?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        dashboardFlowCoordinator = DashboardFlowCoordinator(window: window, coordinator: self)
        dashboardFlowCoordinator?.start()
    }
}
