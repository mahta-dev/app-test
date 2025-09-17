import SwiftUI

struct URLShortenerInputView<ViewModel: URLShortenerViewModelProtocol>: View where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    @State private var isValidInput: Bool = true
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Paste URL", text: $viewModel.inputText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isTextFieldFocused ? Color.primaryPurple : (isValidInput ? Color.lightGray : Color.red),
                                    lineWidth: 2
                                )
                        )
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isTextFieldFocused)
                .onChange(of: viewModel.inputText) { newValue in
                    validateInput(newValue)
                }
                .onSubmit {
                    if !viewModel.inputText.isEmpty && isValidInput {
                        viewModel.handle(.shortenURL(viewModel.inputText))
                        isTextFieldFocused = false
                    }
                }
            
            Button(action: {
                viewModel.handle(.shortenURL(viewModel.inputText))
                isTextFieldFocused = false
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Shorten")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.primaryPurple)
                )
                .shadow(color: Color.primaryPurple.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .disabled(viewModel.inputText.isEmpty || viewModel.state.isLoading || !isValidInput)
            .scaleEffect(viewModel.inputText.isEmpty || viewModel.state.isLoading || !isValidInput ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: viewModel.inputText.isEmpty)
            
            if !isValidInput && !viewModel.inputText.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Please enter a valid URL")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(0.1))
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private func validateInput(_ input: String) {
        isValidInput = input.isEmpty || input.isValidURL
    }
}
