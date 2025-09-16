//
//  ContentView.swift
//  app-challenge
//
//  Created by Pablo Rosalvo on 16/09/2024.
//

import SwiftUI
import Network

struct ContentView: View {
    @StateObject private var viewModel = APODViewModel(
        apodService: APODService(
            requestManager: RequestManager()
        )
    )
    @State private var showNetworkDemo = false
    
    var body: some View {
        APODContentView(viewModel: viewModel)
            .sheet(isPresented: $showNetworkDemo) {
                NetworkModuleView()
            }
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