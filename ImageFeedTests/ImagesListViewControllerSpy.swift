@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImagesListPresenterProtocol?
    
    init (presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
    }
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
    }
    
    
}
