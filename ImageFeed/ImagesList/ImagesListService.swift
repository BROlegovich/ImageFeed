
import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    private let perPage = "10"
    private let dateFormater = ISO8601DateFormatter()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private var lastLoadedPage: Int?
    private let builder: URLRequestBuilder
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        guard let request = fetchImageListRequest(page: String(nextPage), perPage: perPage) else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.task = nil
                switch result {
                case .success(let photoResult):
                    photoResult.forEach { image in
                        let date = self.dateFormater.date(from: image.createdAt ?? "")
                        guard let thumbImage = image.urls?.thumbImageURL,
                              let fullImage = image.urls?.largeImageURL else { return }
                        self.photos.append(Photo(id: image.id,
                                                 size: CGSize(width: image.width ?? 0, height: image.height ?? 0),
                                                 createdAt: date,
                                                 welcomeDescription: image.welcomeDescription,
                                                 thumbImageURL: thumbImage,
                                                 largeImageURL: fullImage,
                                                 isLiked: image.isLiked ?? false))
                        //print(self.photos)
                    }
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["Images": self.photos])
                    self.lastLoadedPage = nextPage
                case .failure(let error):
                    assertionFailure("Не удалось получить изображение \(error)")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func fetchImageListRequest(page: String, perPage: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/photos?page=\(page)&&per_page=\(perPage)",
                                httpMethod: "GET",
                                baseURL: URL(string: "https://api.unsplash.com")!
        )
    }
}
