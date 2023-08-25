@testable import ImageFeed
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var profileService: ProfileService
    weak var view: ProfileViewControllerProtocol?
    var didLogoutCalled: Bool = false
    var clean: Bool = false
    var observeAvatar: Bool = false
    
    init (profileService: ProfileService ) {
        self.profileService = profileService
    }
    
    func updateProfile() {
    }
    
    func viewDidLoad() {
    }
    
    func showAlert() -> UIAlertController {
        UIAlertController()
    }
    
    func observeAvatarChanges() {
        observeAvatar = true
    }
    
    func cleanAllService() {
        clean = true
    }
    
    func logOut() {
        didLogoutCalled = true
    }
}
