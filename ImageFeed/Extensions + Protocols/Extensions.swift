
import Foundation

final class URLRequestBuilder {
    
    static let shared = URLRequestBuilder()
    
    private let storage: OAuth2TokenStorage
    init(storage: OAuth2TokenStorage = .shared) {
        self.storage = storage
    }
    
    func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        if let token = storage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
            let fulfillCompletion: (Result<T, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            let task = dataTask(with: request) { data, response, error in
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(T.self, from: data)
                            fulfillCompletion(.success(result))
                        } catch {
                            fulfillCompletion(.failure(NetworkError.decodingError(error)))
                        }
                    } else {
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                }
            }
            task.resume()
            return task
        }
}

extension Notification {
    
    static let userInfoImageURLKey: String = "URL"
    var userInfoImageURL: String? {
        userInfo?[Notification.userInfoImageURLKey] as? String
    }
}

extension Array {
    func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
        var photos = ImagesListService.shared.photos
        photos.replaceSubrange(itemAt...itemAt, with: [newValue])
        return photos
    }
}
