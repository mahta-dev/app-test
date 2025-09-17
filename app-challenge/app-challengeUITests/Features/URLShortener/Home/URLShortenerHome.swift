import XCTest

final class URLShortenerHome: XCTestCase {
    
    var app: XCUIApplication!
    var homePage: URLShortenerHomePage!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        homePage = URLShortenerHomePage(app: app)
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        homePage = nil
    }
    
    func testAppLaunches() throws {
        XCTAssertTrue(app.state == .runningForeground, "App should be running in foreground")
        
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "App Launch"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testHomeScreenElementsExist() throws {
        XCTAssertTrue(homePage.title.exists, "Title should exist")
        XCTAssertTrue(homePage.urlInputField.exists, "URL input field should exist")
        XCTAssertTrue(homePage.shortenButton.exists, "Shorten button should exist")
        XCTAssertTrue(homePage.recentLinksSection.exists, "Recent links section should exist")
    }
    
    func testHomeScreenElementsAreInteractive() throws {
        XCTAssertTrue(homePage.urlInputField.isHittable, "URL input field should be tappable")
        XCTAssertTrue(homePage.shortenButton.isHittable, "Shorten button should be tappable")
    }
    
    func testURLInputFlow() throws {
        let testURL = "https://www.apple.com"
        
        homePage.tapURLInput()
        homePage.typeURL(testURL)
        
        XCTAssertEqual(homePage.urlInputField.value as? String, testURL, "URL should be typed correctly")
    }
    
    func testShortenButtonFlow() throws {
        let testURL = "https://www.google.com"
        
        homePage.tapURLInput()
        homePage.typeURL(testURL)
        homePage.tapShortenButton()
        
        XCTAssertTrue(homePage.shortenButton.exists, "Shorten button should still exist after tap")
    }
    
    func testEmptyInputValidation() throws {
        homePage.tapURLInput()
        homePage.typeURL("test")
        homePage.clearInput()
        homePage.tapShortenButton()
        
        XCTAssertTrue(homePage.shortenButton.exists, "Shorten button should still exist with empty input")
    }
    
    func testInvalidURLInput() throws {
        let invalidURL = "not-a-valid-url"
        
        homePage.tapURLInput()
        homePage.typeURL(invalidURL)
        homePage.tapShortenButton()
        
        XCTAssertTrue(homePage.shortenButton.exists, "Shorten button should still exist with invalid URL")
    }
    
    func testAccessibility() throws {
        XCTAssertTrue(homePage.shortenButton.label.contains("Shorten"), "Shorten button should have proper accessibility label")
        XCTAssertTrue(homePage.urlInputField.label.contains("URL") || homePage.urlInputField.placeholderValue?.contains("URL") == true, "URL input should have proper accessibility label")
    }
    
    func testScreenOrientation() throws {
        XCTAssertTrue(homePage.title.exists, "Title should exist in portrait")
        
        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssertTrue(homePage.title.exists, "Title should exist in landscape")
        
        XCUIDevice.shared.orientation = .portrait
        XCTAssertTrue(homePage.title.exists, "Title should exist after returning to portrait")
    }
    
    func testPerformanceLaunch() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
    
    func testHomeScreenScreenshot() throws {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Home Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
