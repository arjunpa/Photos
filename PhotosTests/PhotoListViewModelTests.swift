//
//  PhotoListViewModelTests.swift
//  PhotosTests
//
//  Created by Arjun P A on 29/09/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import Photos

final class MockAPIService: APIServiceInterface
{
    var responseString: String
    
    init(response: String) {
        self.responseString = response
    }
    
    func request<T: Decodable>(with request: Requestable) -> Single<APIHTTPDecodableResponse<T>> {
        return Single<APIHTTPDecodableResponse<T>>.create { [weak self] single -> Disposable in
            let responseData = self?.responseString.data(using: .utf8)?.utf8Representation ?? Data()
            do {
                let decoded = try JSONDecoder().decode(T.self, from: responseData)
                single(.success(APIHTTPDecodableResponse<T>(data: responseData, decoded: decoded, httpResponse: HTTPURLResponse())))
            } catch {
                single(.error(error))
            }
            return Disposables.create {}
        }
    }
}

class PhotoListViewModelTests: XCTestCase {
    
    private enum Stubbed {
        static let successResponse =
        """
        {"title":"About Canada","rows":[{"title":"Beavers","description":"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony","imageHref":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"}]}
        """
    }
    
    private var mockAPIService: MockAPIService!
    private var photoRepository: PhotoListRepository!
    
    private var testScheduler: TestScheduler!
    private let disposeBag = DisposeBag()

    override func setUp() {
        self.mockAPIService = MockAPIService(response: Stubbed.successResponse)
        self.photoRepository = PhotoListRepository(with: self.mockAPIService)
        self.testScheduler = TestScheduler(initialClock: 0)
        
    }
    
    override func tearDown() {
        testScheduler.stop()
    }

    func testFetchPhotos() {
        let photoViewModelObserver = testScheduler.createObserver([PhotoViewModelInterface].self)
        self.testScheduler.start()
        let photoListModel = PhotoListViewModel(with: self.photoRepository)
        photoListModel.photoViewModel
            .drive(photoViewModelObserver)
            .disposed(by: self.disposeBag)
        photoListModel.fetchPhotos(ignoreCache: false)
        XCTAssertEqual(photoViewModelObserver.events[1].value.element?.count, 1)
        
        let photoViewModel = photoViewModelObserver
                                .events[1]
                                .value
                                .element?
                                .first
        let titleObserver = testScheduler.createObserver(String.self)
        photoViewModel?.title.drive(titleObserver).disposed(by: disposeBag)
        
        XCTAssertEqual(titleObserver.events, [.next(0, "Beavers")])
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
