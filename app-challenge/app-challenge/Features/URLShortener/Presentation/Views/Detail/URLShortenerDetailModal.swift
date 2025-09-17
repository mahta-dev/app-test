import SwiftUI

struct URLShortenerDetailModal<ViewModel: URLShortenerDetailViewModelProtocol>: View where ViewModel: ObservableObject {
    let url: ShortenedURLEntity
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if viewModel.isResolving {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Resolving URL...")
                            .font(.headline)
                            .foregroundColor(.darkGray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.resolveError {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        
                        Text("Error")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(error)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.darkGray)
                        
                        Button("Try Again") {
                            viewModel.handle(.resolveURL(url.alias))
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primaryPurple)
                    }
                    .padding()
                } else if let originalURL = viewModel.resolvedURL {
                    VStack(spacing: 20) {
                        URLShortenerDetailHeader(url: url)
                        URLShortenerDetailContent(originalURL: originalURL)
                        URLShortenerDetailActions(
                            shortURL: url.shortURL,
                            originalURL: originalURL
                        )
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("URL Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            viewModel.handle(.resolveURL(url.alias))
        }
    }
}

struct URLShortenerDetailHeader: View {
    let url: ShortenedURLEntity
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "link.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.primaryPurple)
            
            Text("Shortened URL")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(url.shortURL)
                .font(.headline)
                .foregroundColor(.primaryPurple)
                .multilineTextAlignment(.center)
        }
    }
}

struct URLShortenerDetailContent: View {
    let originalURL: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Original URL")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(originalURL)
                .font(.body)
                .foregroundColor(.darkGray)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.lightGray.opacity(0.3))
                )
        }
    }
}

struct URLShortenerDetailActions: View {
    let shortURL: String
    let originalURL: String
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: copyShortURL) {
                HStack {
                    Image(systemName: "doc.on.doc")
                    Text("Copy Short URL")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryPurple)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            Button(action: copyOriginalURL) {
                HStack {
                    Image(systemName: "doc.on.doc.fill")
                    Text("Copy Original URL")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryPurple.opacity(0.1))
                .foregroundColor(.primaryPurple)
                .cornerRadius(12)
            }
            
            Button(action: openOriginalURL) {
                HStack {
                    Image(systemName: "safari")
                    Text("Open in Safari")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(12)
            }
        }
    }
    
    private func copyShortURL() {
        UIPasteboard.general.string = shortURL
    }
    
    private func copyOriginalURL() {
        UIPasteboard.general.string = originalURL
    }
    
    private func openOriginalURL() {
        if let url = URL(string: originalURL) {
            UIApplication.shared.open(url)
        }
    }
}