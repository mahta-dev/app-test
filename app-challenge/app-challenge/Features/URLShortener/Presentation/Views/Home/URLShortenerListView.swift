import SwiftUI

struct URLShortenerListView<ViewModel: URLShortenerDetailViewModelProtocol>: View where ViewModel: ObservableObject {
    let urls: [ShortenedURLEntity]
    let onDelete: (String) -> Void
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent links")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if urls.isEmpty {
                URLShortenerEmptyStateView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(urls, id: \.id) { url in
                            URLShortenerItemView(
                                url: url,
                                onDelete: { onDelete(url.id) },
                                viewModel: viewModel
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct URLShortenerEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "link.badge.plus")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No links yet")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Shorten your first URL to see it here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
