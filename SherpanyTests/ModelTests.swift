//
//  ModelTests.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/16/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
import CoreData
@testable import Sherpany


class ModelTests: XCTestCase {
    class FileJsonURLs: JsonURLs {
        private lazy var _bundle: NSBundle = {
            return NSBundle(forClass: ModelTests.self)
        }()

        lazy var kUsersURL: NSURL = {
            let urlpath = self._bundle.pathForResource("users", ofType: "json")
            let url = NSURL.fileURLWithPath(urlpath!)
            return url
        }()

        lazy var kAlbumsURL: NSURL = {
            let urlpath = self._bundle.pathForResource("albums", ofType: "json")
            let url = NSURL.fileURLWithPath(urlpath!)
            return url
        }()

        lazy var kPhotosURL: NSURL = {
            let urlpath = self._bundle.pathForResource("photos", ofType: "json")
            let url = NSURL.fileURLWithPath(urlpath!)
            return url
        }()
    }

    private let _model = Model(downloader: ModelNet(URLs: FileJsonURLs()))

    override func setUp() {
        super.setUp()
        CoreDataManager.initialize(setUpInMemoryManagedObjectContext())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLoadUsers() {
        let expectation = expectationWithDescription("Async Method")

        _model.setupUsers {
            print("Users downloaded.")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: nil)

        let cdm = CoreDataManager.instance
        let moc = cdm.managedContext
        let fetch = NSFetchRequest(entityName: "UserEntity")

        do {
            let fetched = try moc.executeFetchRequest(fetch) as! [UserEntity]
            XCTAssert(fetched.count == 10)
            for user in fetched {
                print("#: \(user.userId)")
                print("  name: \(user.name)")
                print("  email: \(user.email)")
                print("  cqatchPhrase: \(user.catchPhrase)")
            }
        } catch {
            fatalError("Failed to fetch users: \(error)")
        }
    }

    func testLoadAlbums() {
        let expectation = expectationWithDescription("Async Method")

        _model.setupAlbums {
            print("Albums downloaded.")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: nil)

        let cdm = CoreDataManager.instance
        let moc = cdm.managedContext
        let fetch = NSFetchRequest(entityName: "AlbumEntity")

        do {
            let fetched = try moc.executeFetchRequest(fetch) as! [AlbumEntity]
            XCTAssert(fetched.count == 100)
            for album in fetched {
                print("#: \(album.albumId)")
                print("  userId: \(album.userId)")
                print("  name: \(album.title)")
            }
        } catch {
            fatalError("Failed to fetch users: \(error)")
        }
    }
}
