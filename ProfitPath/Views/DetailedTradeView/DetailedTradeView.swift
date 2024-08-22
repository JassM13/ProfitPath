//
//  DetailedTradeView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/21/24.
//

import SwiftUI
import Combine

struct DetailedTradeView: View {
    @ObservedObject var navigationController = NavigationController.shared
    
    @State var tradeGroup: TradeGroup
    @State private var journalText: String = "Type here..."
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isKeyboardVisible = false
    @Environment(\.presentationMode) var presentationMode
    
    private var keyboardHeight: CGFloat {
        // This function calculates the keyboard height
        // Use an external library or framework for accurate detection in real-world use cases
        return isKeyboardVisible ? 300 : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Trade Summary with Entries and Exits
            tradeSummary
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
            
            // Journal Entry
            journalEntrySection
        }
        .padding(.horizontal)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        navigationController.updateCurrentView(AnyView(TradesView()), viewName: "Trades")
                    }
                }
        )
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .onReceive(Publishers.keyboardHeight) { height in
            isKeyboardVisible = height > 0
        }
    }

    private var tradeSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(tradeGroup.trades.first?.contractName ?? "Unknown Contract")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(formattedDate(tradeGroup.trades.first?.tradeDay ?? Date()))
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            // Entries and Exits
            VStack(alignment: .leading, spacing: 16) {
                Text("Entries and Exits")
                    .font(.headline)
                
                ForEach(organizedTrades) { trade in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(formattedTime(trade.enteredAt))
                                .padding(.horizontal, 10)
                            Spacer()
                            Text(trade.type)
                                .foregroundColor(trade.type == "Buy" ? .green : .red)
                            Text("\(String(format: "%.2f", trade.size))")
                            Text("@")
                            Text(String(format: "$%.2f", trade.entryPrice))
                        }
                        .opacity(0.6)
                        .font(.subheadline)
                        .padding(.bottom, 4)
                        
                        // Show Exit only if the trade has been exited
                        if trade.exitedAt > trade.enteredAt {
                            HStack {
                                Text(formattedTime(trade.exitedAt))
                                    .padding(.horizontal, 10)
                                Spacer()
                                Text("Exit")
                                    .foregroundColor(.red)
                                Text("\(String(format: "%.2f", trade.size))")
                                Text("@")
                                Text(String(format: "$%.2f", trade.exitPrice))
                            }
                            .opacity(0.6)
                            .font(.subheadline)
                            .padding(.bottom, 4)
                        }
                        
                        // Additional trade details
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Instrument:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(trade.instrumentType)
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            HStack {
                                Text("Position Type:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(trade.type == "Long" ? "Long" : "Short")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            HStack {
                                Text("Total P&L: ")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(String(format: "$%.2f", totalPnL))
                                    .foregroundColor(totalPnL >= 0 ? .green : .red)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
        }
    }
    
    private var journalEntrySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 250)
                    
                    TextEditor(text: $journalText)
                        .scrollContentBackground(.hidden)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 10))
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
                                .background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
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
            .padding(.bottom, keyboardHeight) // Adjust for keyboard height
            
            HStack {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Image(systemName: "photo")
                    Text("Add Image")
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                Button(action: saveJournalEntry) {
                    Text("Save Entry")
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 5)
        }
        .padding(.horizontal, 10)
    }
    
    private var totalPnL: Double {
        tradeGroup.trades.reduce(0) { $0 + $1.pnl }
    }
    
    private var organizedTrades: [Trade] {
        let sortedTrades = tradeGroup.trades.sorted { $0.enteredAt < $1.enteredAt }
        return sortedTrades
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func saveJournalEntry() {
        // Convert text and image to Data
        var content = journalText.data(using: .utf8) ?? Data()
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
            content.append(imageData)
        }
        
        let journalEntry = JournalEntry(content: content)
        tradeGroup.journalEntry = journalEntry
        
        // Reset the form
        journalText = "Type here..."
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
