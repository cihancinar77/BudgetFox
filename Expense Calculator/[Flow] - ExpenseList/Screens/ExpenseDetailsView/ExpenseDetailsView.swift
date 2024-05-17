//
//  ExpenseDetailsView.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 13.05.2024.
//

//
//  ExpenseDetailsView.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 13.05.2024.
//

import SwiftUI
import CoreData

struct ExpenseDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ExpenseDetailsViewModel()
    @State private var editedTitle: String
    @State private var editedSubtitle: String
    @State private var editedCost: String
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var imageData: Data?
    
    let expense: ExpenseModel
    
    init(expense: ExpenseModel) {
        self.expense = expense
        _editedTitle = State(initialValue: expense.title)
        _editedSubtitle = State(initialValue: expense.subtitle ?? "")
        _editedCost = State(initialValue: String(format: "%.2f", expense.cost ?? 0.0))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Voucher")) {
                if let image = inputImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                            ImagePicker(image: $inputImage, imageData: $imageData)
                        }
                } else {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("Add Image")
                            .tint(Color("Accent1"))
                    }
                    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: $inputImage, imageData: $imageData)
                    }
                }
            }
            
            Section(header: Text("Details")) {
                TextField("Title", text: $editedTitle)
                TextField("Subtitle", text: $editedSubtitle)
                HStack {
                    Text("Cost:")
                        .fontWeight(.bold)
                    TextField("Cost", text: $editedCost)
                        .keyboardType(.decimalPad)
                }
            }
        }
        .onAppear {
                   // Initialize inputImage with the existing image data
                   if let imageData = expense.image {
                       inputImage = UIImage(data: imageData)
                   }
               }
        .navigationBarTitle("Expense Details")
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            saveExpense()
        }
        .disabled(!hasChanges)
        .tint(Color("Accent1"))
    }
    
    private var hasChanges: Bool {
        editedTitle != expense.title ||
            editedSubtitle != (expense.subtitle ?? "") ||
            Double(editedCost) != expense.cost ||
            (imageData != nil && imageData != expense.image)
    }
    
    private func saveExpense() {
        let costStringWithDot = editedCost.replacingOccurrences(of: ",", with: ".")
        guard let cost = Double(costStringWithDot) else {
            return
        }
        
        loadImage()
        let updatedExpense = ExpenseModel(
            id: expense.id,
            createdAt: expense.createdAt,
            title: editedTitle,
            subtitle: editedSubtitle,
            cost: cost,
            image: imageData,
            parentListId: expense.parentListId
        )
      
        viewModel.updateExpense(model: updatedExpense)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func loadImage() {
        if let inputImage = inputImage {
            imageData = inputImage.jpegData(compressionQuality: 0.5)
        }
    }
}

struct ExpenseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let expense = ExpenseModel(id: UUID(), createdAt: Date(), title: "Sample Expense", subtitle: "asd", cost: 10.0, image: nil, parentListId: nil)
        return ExpenseDetailsView(expense: expense)
    }
}
