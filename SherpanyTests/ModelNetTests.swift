//
//  ModelNetTest.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
@testable import Sherpany

class ModelNetTests: XCTestCase {
    let net = ModelNet(URLs: HttpJsonURLs())

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDowloadUsers() {
        let expectation = expectationWithDescription("Async Method")

        net.downloadUsers({ (result: [UserData]?) -> Void in
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
        XCTAssert(net.status == ModelNet.Status.kNetFinished)
    }

    func testDowloadAlbums() {
        let expectation = expectationWithDescription("Async Method")

        net.downloadAlbums({ (result: [AlbumData]?) -> Void in
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
        XCTAssert(net.status == ModelNet.Status.kNetFinished)
    }

    func testDowloadPhotos() {
        let expectation = expectationWithDescription("Async Method")

        net.downloadPhotos({ (result: [PhotoData]?) -> Void in
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
        XCTAssert(net.status == ModelNet.Status.kNetFinished)
    }

    func testDownloadPicture() {
        let expectation = expectationWithDescription("Async Method")
        let url = NSURL(string: "http://placehold.it/150/6ba424")!

        net.downloadPicture(url, finished: {(pictureData: NSData?) -> Void in
            if let data = pictureData {
                let image = UIImage(data: data)
                assert(image != nil)
            } else {
                XCTAssert(false)
            }
            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(net.status == ModelNet.Status.kNetFinished)
    }
}
