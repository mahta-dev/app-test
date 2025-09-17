import Foundation

enum TestError: Error, Equatable {
    case mockError
    case networkError
    case notFound
    case deleteError
}