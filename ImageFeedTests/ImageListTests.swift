@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let imageListService = ImagesListService()
        let view = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(dateFormatter: DateFormatter(), photos: imageListService.photos)
        view.presenter = presenter
        presenter.view = view
        
        // when
        presenter.showAlert()
        
        // then
        XCTAssertTrue(presenter.alertShow)
    }
    
    func testViewControllerDidViewLoad() {
        //given
        let imageListService = ImagesListService()
        let view = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(dateFormatter: DateFormatter(), photos: imageListService.photos)
        presenter.view = view
        view.presenter = presenter
        //when
        presenter.viewDidLoad()
        //then
        XCTAssertTrue(presenter.viewDidLoadDid)
    }
    
    func testIsLiked() {
        //given
        let imageListService = ImagesListService()
        let view = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(dateFormatter: DateFormatter(), photos: imageListService.photos)
        presenter.view = view
        view.presenter = presenter
        //when
        presenter.isLiked(indexPath: IndexPath())
        //then
        XCTAssertTrue(presenter.isLiked(indexPath: IndexPath()))
    }
    
}
