import Foundation
import SwiftUI
import Network

@MainActor
@available(iOS 15.0, *)
class APODViewModel: ObservableObject {
    @Published var apod: APODResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var responseJSON: String = ""
    
    private let apodService: APODServiceProtocol
    
    init(apodService: APODServiceProtocol) {
        self.apodService = apodService
    }
    
    func loadAPOD(date: String) async {
        isLoading = true
        errorMessage = nil
        responseJSON = ""
        
        do {
            let response = try await apodService.fetchAPOD(date: date)
            apod = response
            
            // Convert response to JSON string for display
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(response),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                responseJSON = jsonString
            }
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error: \(error)")
        }
        
        isLoading = false
    }
    
    func loadRandomAPOD() async {
        isLoading = true
        errorMessage = nil
        responseJSON = ""
        
        do {
            let endpoint = APIEndpoint.apodRandom(count: 1)
            let responses: [APODResponse] = try await apodService.request(endpoint: endpoint)
            apod = responses.first
            
            // Convert response to JSON string for display
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(responses),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                responseJSON = jsonString
            }
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error: \(error)")
        }
        
        isLoading = false
    }
}