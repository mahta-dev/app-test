import XCTest

class URLShortenerHomePage {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    var title: XCUIElement {
        app.staticTexts["Shorten links"]
    }
    
    var urlInputField: XCUIElement {
        app.textFields.firstMatch
    }
    
    var shortenButton: XCUIElement {
        app.buttons["Shorten"]
    }
    
    var recentLinksSection: XCUIElement {
        app.staticTexts["Recent links"]
    }
    
    var noLinksYet: XCUIElement {
        app.staticTexts["No links yet"]
    }
    
    var pasteURLField: XCUIElement {
        app.textFields["Paste URL"]
    }
    
    func tapURLInput() {
        urlInputField.tap()
    }
    
    func typeURL(_ url: String) {
        urlInputField.typeText(url)
    }
    
    func clearInput() {
        urlInputField.tap()
        urlInputField.press(forDuration: 1.0)
        if app.menuItems["Select All"].exists {
            app.menuItems["Select All"].tap()
            urlInputField.typeText("")
        }
    }
    
    func tapShortenButton() {
        shortenButton.tap()
    }
    
    func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5.0) -> Bool {
        return element.waitForExistence(timeout: timeout)
    }
    
    func waitForTitle() -> Bool {
        return waitForElement(title)
    }
    
    func waitForShortenButton() -> Bool {
        return waitForElement(shortenButton)
    }
    
    func waitForInputField() -> Bool {
        return waitForElement(urlInputField)
    }
    
    func isInputFieldEmpty() -> Bool {
        guard let value = urlInputField.value as? String else { return true }
        return value.isEmpty
    }
    
    func getInputFieldValue() -> String {
        return urlInputField.value as? String ?? ""
    }
    
    func hasRecentLinks() -> Bool {
        return !noLinksYet.exists
    }
    
    func getRecentLinksCount() -> Int {
        return app.cells.count
    }
    
    func tapRecentLink(at index: Int) {
        let cells = app.cells
        if index < cells.count {
            cells.element(boundBy: index).tap()
        }
    }
    
    func getRecentLinkTitle(at index: Int) -> String {
        let cells = app.cells
        if index < cells.count {
            return cells.element(boundBy: index).staticTexts.firstMatch.label
        }
        return ""
    }
    
    func getRecentLinkURL(at index: Int) -> String {
        let cells = app.cells
        if index < cells.count {
            let cell = cells.element(boundBy: index)
            let staticTexts = cell.staticTexts
            if staticTexts.count > 1 {
                return staticTexts.element(boundBy: 1).label
            }
        }
        return ""
    }
    
    func tapCopyButton(at index: Int) {
        let cells = app.cells
        if index < cells.count {
            let cell = cells.element(boundBy: index)
            let copyButton = cell.buttons["Copy"]
            if copyButton.exists {
                copyButton.tap()
            }
        }
    }
    
    func tapShareButton(at index: Int) {
        let cells = app.cells
        if index < cells.count {
            let cell = cells.element(boundBy: index)
            let shareButton = cell.buttons["Share"]
            if shareButton.exists {
                shareButton.tap()
            }
        }
    }
    
    func tapDeleteButton(at index: Int) {
        let cells = app.cells
        if index < cells.count {
            let cell = cells.element(boundBy: index)
            let deleteButton = cell.buttons["Delete"]
            if deleteButton.exists {
                deleteButton.tap()
            }
        }
    }
    
    func dismissKeyboard() {
        if app.keyboards.count > 0 {
            app.keyboards.buttons["return"].tap()
        }
    }
    
    func swipeToRefresh() {
        let startPoint = CGPoint(x: app.frame.midX, y: app.frame.midY)
        let endPoint = CGPoint(x: app.frame.midX, y: app.frame.midY - 100)
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            .press(forDuration: 0.1, thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3)))
    }
}
