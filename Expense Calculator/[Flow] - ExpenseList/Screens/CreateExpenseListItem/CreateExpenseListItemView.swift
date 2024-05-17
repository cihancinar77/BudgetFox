//
//  CreateExpenseListItemView.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import SwiftUI

struct CreateExpenseListItemView: View {
    @Binding var showView: Bool
    @StateObject private var viewModel = CreateExpenseListItemViewModel()
    @State private var selectedDate = Date()
    @State private var title = ""
    @State private var subtitle = ""
    @State private var selectedIconIndex = 0
    @State private var selectedIconName = "cart"
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Create New Expense Document")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding([.top, .leading, .trailing], 18)
            
            TextField("Name your document", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
                .tint((Color("Accent1")))
            
            VStack(alignment: .center, content: {
                Text("Select an Icon")
                Picker(selection: $selectedIconIndex, label: Text("Select Icon")) {
                    ForEach(0..<viewModel.systemIcons.count) { index in
                        Image(systemName: viewModel.systemIcons[index])
                            .tag(index)
                            .foregroundColor(Color("Accent1"))
                    }
                }
                .onChange(of: selectedIconIndex) { newValue in
                    selectedIconName = viewModel.systemIcons[newValue]
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 100)
                .padding()
            })
            
            Button(action: {
                if title.isEmpty {
                    showAlert = true
                } else {
                    viewModel.saveNewListItem(date: selectedDate, icon: selectedIconName, title: title)
                    showView = false // Dismiss view
                                    }
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("Accent1").gradient)
                    .cornerRadius(10)
                    .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please enter a title."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct CreateExpenseListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreateExpenseListItemView(showView: .constant(true))
    }
}
