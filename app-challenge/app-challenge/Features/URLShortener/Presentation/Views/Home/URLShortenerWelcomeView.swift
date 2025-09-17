import SwiftUI

struct URLShortenerWelcomeView: View {
    let onLoadURLs: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            URLShortenerWelcomeIconView()
            URLShortenerWelcomeContentView()
            URLShortenerWelcomeActionView(onLoadURLs: onLoadURLs)
        }
        .padding()
    }
}

struct URLShortenerWelcomeIconView: View {
    var body: some View {
        Image(systemName: "link.circle.fill")
            .font(.system(size: 80))
            .foregroundColor(.primaryPurple)
    }
}

struct URLShortenerWelcomeContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("URL Shortener")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primaryPurple)
            
            Text("Shorten your links")
                .font(.title3)
                .foregroundColor(.darkGray)
            
            Text("Paste your long URL above and get a short, shareable link instantly.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.darkGray)
        }
    }
}

struct URLShortenerWelcomeActionView: View {
    let onLoadURLs: () -> Void
    
    var body: some View {
        Button(action: onLoadURLs) {
            HStack(spacing: 12) {
                Image(systemName: "clock.arrow.circlepath")
                Text("Load Recent Links")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primaryPurple)
            )
            .shadow(color: Color.primaryPurple.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
}
