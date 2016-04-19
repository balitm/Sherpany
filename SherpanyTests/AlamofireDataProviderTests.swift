//
//  AlamofireDataProviderTests.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/19/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest

class AlamofireDataProviderTests: XCTestCase {
    private let _config = Config()
    private let _dataProvider = AlamofireDataProvider()

    override func setUp() {
        if _dataProvider.dataProcessor == nil {
            _dataProvider.dataProcessor = SwiftyJsonDataProcessor()
        }
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDowloadUsers() {
        let expectation = expectationWithDescription("Async Users Method")

        _dataProvider.processUsers(_config.kUsersURL, finished: { result in
            if let users = result {
                for user in users {
                    print("#\(user.userId)")
                    print("  name: \(user.name)")
                    print("  email: \(user.email)")
                    print("  catchPhrase: \(user.catchPhrase)")
                }
            } else {
                print("No users downloaded.")
            }
            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(_dataProvider.status == AsyncDataProvider.Status.kNetFinished)
    }

    func testDowloadAlbums() {
        let expectation = expectationWithDescription("Async Albums Method")

        _dataProvider.processAlbums(_config.kAlbumsURL, finished: { (result: [AlbumData]?) -> Void in
            if let albums = result {
                for album in albums {
                    print("#\(album.albumId)")
                    print("  user id: \(album.userId)")
                    print("  title: \(album.title)")
                }
            } else {
                print("No albums downloaded.")
            }
            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(_dataProvider.status == AsyncDataProvider.Status.kNetFinished)
    }

    func testDowloadPhotos() {
        let expectation = expectationWithDescription("Async Photos Method")

        _dataProvider.processPhotos(_config.kPhotosURL, finished: { (result: [PhotoData]?) -> Void in
            if let photos = result {
                for photo in photos {
                    print("#\(photo.photoId)")
                    print("  album id: \(photo.albumId)")
                    print("  title: \(photo.title)")
                }
            } else {
                print("No photos downloaded.")
            }
            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(_dataProvider.status == AsyncDataProvider.Status.kNetFinished)
    }
    
}
