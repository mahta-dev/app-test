import SwiftUI
import UIKit

extension View {
    func snapshotTestWrapper() -> some View {
        self
            .frame(width: 375, height: 812)
            .background(Color(.systemBackground))
    }
}

extension UIViewController {
    func snapshotTestWrapper() -> UIViewController {
        let wrapper = UIViewController()
        wrapper.view.backgroundColor = .systemBackground
        wrapper.view.addSubview(self.view)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: wrapper.view.topAnchor),
            self.view.leadingAnchor.constraint(equalTo: wrapper.view.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: wrapper.view.trailingAnchor),
            self.view.bottomAnchor.constraint(equalTo: wrapper.view.bottomAnchor)
        ])
        
        return wrapper
    }
}

struct SnapshotTestEnvironment {
    static func setup() {
        UIView.setAnimationsEnabled(false)
    }
    
    static func teardown() {
        UIView.setAnimationsEnabled(true)
    }
}
