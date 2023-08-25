import SwiftKeychainWrapper
import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    private let login = "regspeedy@gmail.com"
     private let password = "jijCat-7pohfu-nukkub"
     private let userName = "bakenhouns"
     private let nickname = "@bakenhouns"

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("\(login)")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("\(password)")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        sleep(5)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.buttons["likeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["\(userName)"].exists)
        XCTAssertTrue(app.staticTexts["\(nickname)"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Выход"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
