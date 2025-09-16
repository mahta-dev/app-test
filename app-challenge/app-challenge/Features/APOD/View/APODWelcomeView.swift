import SwiftUI

struct APODWelcomeView: View {
    let onLoadAPOD: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            APODWelcomeIconView()
            APODWelcomeContentView()
            APODWelcomeActionView(onLoadAPOD: onLoadAPOD)
        }
        .padding()
    }
}

struct APODWelcomeIconView: View {
    var body: some View {
        Image(systemName: "photo.on.rectangle.angled")
            .font(.system(size: 80))
            .foregroundColor(.blue)
    }
}

struct APODWelcomeContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("NASA APOD")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Astronomy Picture of the Day")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text("Discover the cosmos! Each day a different image or photograph of our fascinating universe is featured, along with a brief explanation written by a professional astronomer.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
}

struct APODWelcomeActionView: View {
    let onLoadAPOD: () -> Void
    
    var body: some View {
        Button("Load Today's APOD") {
            onLoadAPOD()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}
