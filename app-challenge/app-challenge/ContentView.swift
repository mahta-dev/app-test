//
//  ContentView.swift
//  app-challenge
//
//  Created by Pablo Rosalvo on 16/09/2024.
//

import SwiftUI
import Network

@available(iOS 15.0, *)
struct ContentView: View {
    @StateObject private var viewModel = APODViewModel(
        apodService: APODService(
            requestManager: RequestManager()
        )
    )
    @State private var showNetworkDemo = false
    @State private var showJSON = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading APOD...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let apod = viewModel.apod {
                    APODView(apod: apod, showJSON: $showJSON, jsonResponse: viewModel.responseJSON)
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        Task {
                            await viewModel.loadAPOD(date: "2024-01-01")
                        }
                    }
                } else {
                    WelcomeView {
                        Task {
                            await viewModel.loadAPOD(date: "2024-01-01")
                        }
                    }
                }
            }
            .navigationTitle("NASA APOD")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Features") {
                        showNetworkDemo = true
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Random") {
                        Task {
                            await viewModel.loadRandomAPOD()
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .sheet(isPresented: $showNetworkDemo) {
                NetworkModuleView()
            }
        }
    }
}

@available(iOS 15.0, *)
struct APODView: View {
    let apod: APODResponse
    @Binding var showJSON: Bool
    let jsonResponse: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(apod.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                // Date
                Text("Date: \(apod.date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Image
                AsyncImage(url: URL(string: apod.url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(16/9, contentMode: .fit)
                        .overlay(
                            ProgressView()
                        )
                }
                .cornerRadius(12)
                
                // Explanation
                Text(apod.explanation)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                // Media Type
                HStack {
                    Text("Media Type:")
                        .fontWeight(.semibold)
                    Text(apod.mediaType)
                        .foregroundColor(.secondary)
                }
                .font(.caption)
                
                // JSON Toggle
                Button(action: {
                    showJSON.toggle()
                }) {
                    HStack {
                        Image(systemName: showJSON ? "eye.slash" : "eye")
                        Text(showJSON ? "Hide JSON" : "Show JSON")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                
                if showJSON {
                    VStack(alignment: .leading) {
                        Text("JSON Response:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        ScrollView {
                            Text(jsonResponse)
                                .font(.system(.caption, design: .monospaced))
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .frame(maxHeight: 200)
                    }
                }
            }
            .padding()
        }
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Try Again") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct WelcomeView: View {
    let onLoadAPOD: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
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
            
            Button("Load Today's APOD") {
                onLoadAPOD()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

struct NetworkModuleView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Network Module Demo")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("This demonstrates the Network module capabilities")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Network Demo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}