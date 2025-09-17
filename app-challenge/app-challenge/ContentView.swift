import SwiftUI

struct ContentView: View {
    @State private var showNetworkDemo = false
    @State private var factoryManager: URLShortenerFactoryManagerProtocol = URLShortenerFactoryManager(factory: URLShortenerFactory())
    
    var body: some View {
        factoryManager.createURLShortenerView()
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
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
