//
//  ContentView.swift
//  app-challenge
//
//  Created by Pablo Rosalvo on 16/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showNetworkDemo = false
    @State private var factoryManager: APODFactoryManagerProtocol = APODFactoryManager()
    
    var body: some View {
        factoryManager.createAPODView()
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
