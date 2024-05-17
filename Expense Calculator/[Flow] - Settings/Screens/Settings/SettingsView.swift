//
//  SettingsView.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 13.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @AppStorage("selectedCurrency") var selectedCurrency = "USD" // UserDefaults
    @AppStorage("isDarkMode") var isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    @AppStorage("didUserDecideColor") var didUserDecideColor = UserDefaults.standard.bool(forKey: "didUserDecideColor")
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("🦊")
                .font(.system(size: 100))
                .padding(.top, 4)
            Text("BudgetFox")
                .font(Font.custom("Marker Felt Thin", size: 32.0))
                .foregroundColor(Color("Accent1"))
            Form {
                Section {
                    Picker("Select Currency", selection: $selectedCurrency) {
                        Text("USD").tag("USD")
                        Text("EUR").tag("EUR")
                        Text("TRY").tag("TRY")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    .tint(Color("Accent1"))
                }

                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark Mode")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color("Accent1")))
                    .onAppear(perform: {
                        guard !didUserDecideColor else {
                            return
                        }
                        if colorScheme == .light {
                            isDarkMode = false
                        } else {
                            isDarkMode = true
                        }
                    })
                    .onChange(of: isDarkMode) { newValue in
                        // Update the preferred color scheme when dark mode is toggled
                        UIApplication.shared.windows.first?.rootViewController?.view.window?.overrideUserInterfaceStyle = newValue ? .dark : .light
                        UserDefaults.standard.set(newValue, forKey: "isDarkMode")
                        UserDefaults.standard.set(true, forKey: "didUserDecideColor")// Save to UserDefaults
                    }
                    
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) // Set preferred color scheme
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

