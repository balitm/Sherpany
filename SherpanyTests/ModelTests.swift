//
//  ModelTests.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/16/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
import CoreData
import UIKit
@testable import Sherpany


class ModelTests: XCTestCase {
    class FileJsonURLs: DataURLs {
        lazy var bundle: NSBundle = {
            return NSBundle(forClass: ModelTests.self)
        }()

        lazy var kUsersURL: NSURL = {
            let urlpath = self.bundle.pathForResource("users", ofType: "json")
            let url = NSURL.fileURLWithPath(urlpath!)
            return url
        }()

        lazy var kAlbumsURL: NSURL = {
            let urlpath = self.bundle.pathForResource("albums", ofType: "json")
            let url = NSURL.fileURLWithPath(urlpath!)
            return url
        }()

        lazy var kPhotosURL: NSURL = {
            let urlpath = self.bundle.pathForResource("photos", ofType: "json")
            let url = NSURL.fileURLWithPath(urlpath!)
            return url
        }()
    }

    private let _coreDataHelper = CoreDataHelper()
    private let _urls = FileJsonURLs()
    private var _model: Model! = nil

    override func setUp() {
        super.setUp()
        _coreDataHelper.setUpInMemoryManagedObjectContext()
        XCTAssertNotEqual(_coreDataHelper.managedObjectContext, nil)
        CoreDataManager.initialize(_coreDataHelper.managedObjectContext)
        _model = Model(urls: _urls, dataProvider: JsonDataProvider())
    }
    
    override func tearDown() {
        XCTAssert(_coreDataHelper.releaseMemoryManagedObjectContext())
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
        let fetch = NSFetchRequest(entityName: UserEntity.entityName)

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
        let fetch = NSFetchRequest(entityName: AlbumEntity.entityName)

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

    func testLoadPhotos() {
        let expectation = expectationWithDescription("Async Method")

        _model.setupPhotos {
            print("Photos downloaded.")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: nil)

        let cdm = CoreDataManager.instance
        let moc = cdm.managedContext
        let fetch = NSFetchRequest(entityName: PhotoEntity.entityName)

        do {
            let fetched = try moc.executeFetchRequest(fetch) as! [PhotoEntity]
            print("photos: \(fetched.count)")
            XCTAssert(fetched.count == 5000)
            for photo in fetched {
                print("#: \(photo.photoId)")
                print("  userId: \(photo.albumId)")
                print("  name: \(photo.title)")
                print("  name: \(photo.thumbnailUrl)")
            }
        } catch {
            fatalError("Failed to fetch users: \(error)")
        }
    }

    func testLoadPicture() {
        let expectation = expectationWithDescription("Async Method")
        let urlpath = _urls.bundle.pathForResource("thumbnail", ofType: "png")
        let url = NSURL.fileURLWithPath(urlpath!)
        let urlString = url.absoluteString
        let photoData = PhotoData(photoId: 1000, albumId: 1, title: "Sample", thumbnailUrl: urlString)

        let cdm = CoreDataManager.instance
        let photoEntity = cdm.createPhotoEntity(photoData)

        _model.addPicture(photoEntity, finished: {
            print("dowloaded image: \(photoEntity.thumbnailUrl)")
            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssertNotEqual(photoEntity.thumbnail, nil)
        let img = UIImage(data: photoEntity.thumbnail!)
        XCTAssertNotEqual(img, nil)
        XCTAssert(img!.size.width == 150 && img!.size.height == 150)
    }
}
