@testable import ImageFeed
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    
    var dateFormatter: DateFormatter
    
    var photos: [ImageFeed.Photo]
    
    var alertShow: Bool = true
    
    var imageListCellDidTapLikeDone: Bool = false
    
    var viewDidLoadDid: Bool = false
    
    init(view: ImagesListViewControllerProtocol? = nil, dateFormatter: DateFormatter, photos: [ImageFeed.Photo]) {
        self.view = view
        self.dateFormatter = dateFormatter
        self.photos = photos
    }
    
    func showAlert() -> UIAlertController {
        return UIAlertController()
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {
        imageListCellDidTapLikeDone = true
    }
    
    func cellURL(indexPath: IndexPath) -> URL? {
        return nil
    }
    
    func isLiked(indexPath: IndexPath) -> Bool {
        return true
    }
    
    func updateTableView() {
    }
    
    func fetchPhotosNextPage() {
    }
    
    func viewDidLoad() {
        viewDidLoadDid = true
    }
    
    
}
