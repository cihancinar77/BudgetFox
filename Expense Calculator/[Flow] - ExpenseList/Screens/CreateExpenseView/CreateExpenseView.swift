//
//  CreateExpenseView.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 11.05.2024.
//

import SwiftUI

struct CreateExpenseView: View {
    @StateObject var viewModel = CreateExpenseViewModel()
    @Binding var showView: Bool
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var selectedImage: UIImage?
    @State private var cost: String = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var imageData: Data?
    @Binding var listItem: ExpenseListItemModel
    @AppStorage("selectedCurrency") var selectedCurrency = "USD"
    @State private var isShowingFullScreen = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense")) {
                    TextField("Title", text: $title)
                    TextField("Details", text: $subtitle)
                    TextField("Cost: \(selectedCurrency)", text: $cost)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Voucher")) {
                    if let selectedImage = selectedImage {
                        Button(action: {
                            self.selectedImage = nil
                            imageData = nil
                        }) {
                            Text("Delete Image")
                                .foregroundColor(.red)
                        }
                        .padding(.vertical, 10)
                        
                        Button(action: {
                            isShowingFullScreen.toggle()
                        }) {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .fullScreenCover(isPresented: $isShowingFullScreen) {
                                    ImageFullScreenView(image: selectedImage)
                                }
                        }
                    } else {
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Text("Select Image")
                                .tint(Color("Accent1"))
                        }
                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                            ImagePicker(image: $inputImage, imageData: $imageData)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        guard let matchingObject = viewModel.getRelevantListItem(item: listItem) else { return }
                        let costStringWithDot = cost.replacingOccurrences(of: ",", with: ".")
                        let expenseModel = ExpenseModel(
                            id: UUID(),
                            createdAt: Date(),
                            title: title,
                            subtitle: subtitle,
                            cost: Double(costStringWithDot),
                            image: imageData,
                            parentListId: matchingObject.id
                        )
                        viewModel.addExpense(model: expenseModel, listItem: listItem)
                        self.listItem.expenses.append(expenseModel)
                        showView = false //Dismiss view
                    }) {
                        Text("Save Expense")
                            .tint(Color("Accent1"))
                    }
                }
            }
            .navigationBarTitle("Expense Details")
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        selectedImage = inputImage
    }
}
