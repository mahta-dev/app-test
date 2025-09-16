import SwiftUI

struct APODErrorView: View {
    let error: APODErrorModel
    let onRetry: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            APODErrorIconView(error: error)
            APODErrorContentView(error: error)
            APODErrorActionsView(
                error: error,
                onRetry: onRetry,
                onDismiss: onDismiss
            )
            APODErrorTimestampView(error: error)
        }
        .padding()
    }
}

struct APODErrorIconView: View {
    let error: APODErrorModel
    
    var body: some View {
        Image(systemName: error.iconName)
            .font(.system(size: 60))
            .foregroundColor(Color(error.iconColor))
    }
}

struct APODErrorContentView: View {
    let error: APODErrorModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text(error.title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(error.message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
        }
    }
}

struct APODErrorActionsView: View {
    let error: APODErrorModel
    let onRetry: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            if error.canRetry {
                Button("Try Again") {
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
            }
            
            Button("Dismiss") {
                onDismiss()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct APODErrorTimestampView: View {
    let error: APODErrorModel
    
    var body: some View {
        Text("Error occurred at \(error.timestamp.formatted(date: .omitted, time: .shortened))")
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}
