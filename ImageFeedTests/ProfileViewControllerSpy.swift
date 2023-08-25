import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol
    
    init (presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    var profileImage = UIImageView()
    
    var nameLabel = UILabel()
    
    var loginLabel = UILabel()
    
    var descriptionLabel = UILabel()
    
    var updateAva: Bool = false
    
    var layouts: Bool = false
    
    var alertShow: Bool = false
    
    func updateAvatar() {
        updateAva = true
    }
    
    func layout() {
        layouts = true
    }
    
    func showAlert() {
        alertShow = true
    }
    
}
