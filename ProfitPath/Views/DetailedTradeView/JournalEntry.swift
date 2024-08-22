//
//  JournalEntry.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/22/24.
//

import SwiftUI
import Combine

struct JournalEntryView: View {
    @Binding var tradeGroup: TradeGroup
    @State private var journalText: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isKeyboardVisible = false
    
    private var keyboardHeight: CGFloat {
        isKeyboardVisible ? 300 : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $journalText)
                    .scrollContentBackground(.hidden)
                    .frame(height: 250)
                    .background(Color.black)
                    .overlay(
                        Text("Type here...")
                            .foregroundColor(.gray)
                            .opacity(journalText.isEmpty ? 1 : 0)
                    )
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            Image(systemName: "photo")
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Text("Done")
                        }
                    }
                    .background(Color.clear)
                }
            }
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, keyboardHeight)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .onReceive(Publishers.keyboardHeight) { height in
            isKeyboardVisible = height > 0
        }
    }
    
    private func saveJournalEntry() {
        var content = journalText.data(using: .utf8) ?? Data()
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
            content.append(imageData)
        }
        
        let journalEntry = JournalEntry(content: content)
        tradeGroup.journalEntry = journalEntry
        
        journalText = ""
        selectedImage = nil
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let notificationCenter = NotificationCenter.default
        let keyboardWillShowPublisher = notificationCenter.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                return value?.height ?? 0
            }
        
        let keyboardWillHidePublisher = notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return Publishers.Merge(keyboardWillShowPublisher, keyboardWillHidePublisher)
            .eraseToAnyPublisher()
    }
}
