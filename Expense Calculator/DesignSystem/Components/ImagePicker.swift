//
//  ImagePicker.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 13.05.2024.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var imageData: Data?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage { // Check for edited image
                parent.image = editedImage
                if let imageData = editedImage.jpegData(compressionQuality: 1.0) {
                    parent.imageData = imageData
                }
            } else if let originalImage = info[.originalImage] as? UIImage { // Fallback to original image
                parent.image = originalImage
                if let imageData = originalImage.jpegData(compressionQuality: 1.0) {
                    parent.imageData = imageData
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
