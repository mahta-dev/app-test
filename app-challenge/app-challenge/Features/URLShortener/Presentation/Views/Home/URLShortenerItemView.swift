import SwiftUI

struct URLShortenerItemView<ViewModel: URLShortenerDetailViewModelProtocol>: View where ViewModel: ObservableObject {
    let url: ShortenedURLEntity
    let onDelete: () -> Void
    @ObservedObject var viewModel: ViewModel
    
    @State private var showingDeleteAlert = false
    @State private var showingDetailModal = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(url.displayOriginalURL)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text(url.shortURL)
                        .font(.headline)
                        .foregroundColor(.primaryPurple)
                        .lineLimit(1)
                    
                    Text(url.timeAgo)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: copyToClipboard) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.primaryPurple)
                            .font(.title3)
                    }
                    
                    Button(action: shareURL) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.primaryPurple)
                            .font(.title3)
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .onTapGesture {
            showingDetailModal = true
        }
        .sheet(isPresented: $showingDetailModal) {
            URLShortenerDetailModal(url: url, isPresented: $showingDetailModal, viewModel: viewModel)
        }
        .alert("Delete Link", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this link?")
        }
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = url.shortURL
    }
    
    private func shareURL() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [url.shortURL],
            applicationActivities: nil
        )
        
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = window
            popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        rootViewController.present(activityViewController, animated: true)
    }
}
