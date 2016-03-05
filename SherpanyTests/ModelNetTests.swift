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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDowloadUsers() {
        let net = ModelNet()
        let expectation = expectationWithDescription("Async Method")

        do {
            try net.downloadUsers({ (result: [UserData]?) -> Void in
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
        } catch ModelNet.Error.URLFormat {
            print("error caught: wrong uml format.")
        } catch {
            print("error caught.")
        }

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(net.status == ModelNet.Status.kNetFinished)
    }

    func testDowloadAlbums() {
        let net = ModelNet()
        let expectation = expectationWithDescription("Async Method")

        do {
            try net.downloadAlbums({ (result: [AlbumData]?) -> Void in
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
        } catch ModelNet.Error.URLFormat {
            print("error caught: wrong uml format.")
        } catch {
            print("error caught.")
        }

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(net.status == ModelNet.Status.kNetFinished)
    }

    func testDowloadPhotos() {
        let net = ModelNet()
        let expectation = expectationWithDescription("Async Method")

        do {
            try net.downloadPhotos({ (result: [PhotoData]?) -> Void in
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
        } catch ModelNet.Error.URLFormat {
            print("error caught: wrong uml format.")
        } catch {
            print("error caught.")
        }

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(net.status == ModelNet.Status.kNetFinished)
    }
}
