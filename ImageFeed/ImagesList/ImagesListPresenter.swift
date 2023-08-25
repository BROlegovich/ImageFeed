
import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var dateFormatter: DateFormatter { get set }
    var photos: [Photo] { get set }
    func showAlert() -> UIAlertController
    func imageListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func cellURL(indexPath: IndexPath) -> URL?
    func isLiked(indexPath: IndexPath) -> Bool
    func updateTableView()
    func fetchPhotosNextPage()
    
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    private var imagesListServiceObserver: NSObjectProtocol?
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    var photos: [Photo] = []
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            self.updateTableView()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func showAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Что-то пошло не так",
                                                message: "Ошибка",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok",
                                   style: .default)
        alertController.addAction(action)
        alertController.dismiss(animated: true)
        return alertController
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
            case .failure:
                self.showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func cellURL(indexPath: IndexPath) -> URL? {
        guard let imageUrl = photos[indexPath.row].thumbImageURL,
              let url = URL(string: imageUrl)
        else { return nil }
        return url
    }
    
    func isLiked(indexPath: IndexPath) -> Bool {
        return imagesListService.photos[indexPath.row].isLiked == false
    }
    
    func updateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
}
