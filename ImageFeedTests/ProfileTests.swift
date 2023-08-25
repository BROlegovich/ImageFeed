@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testExitFromProfile() {
        //given
        let profileService = ProfileService()
        var presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        //when
        presenter.logOut()
        
        //then
        XCTAssertTrue(presenter.didLogoutCalled)
    }
    
    func testAlert() {
        //given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        //when
        presenter.showAlert()
        
        //then
        XCTAssertTrue(view.alertShow)
    }
    
    func testUpdateAvatar() {
        //given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        //when
        view.updateAvatar()
        
        //then
        XCTAssertTrue(view.updateAva)
    }
    
    func testObserveAvatarChanges() {
        //given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        //when
        presenter.observeAvatarChanges()
        
        //then
        XCTAssertTrue(presenter.observeAvatar)
    }
}

