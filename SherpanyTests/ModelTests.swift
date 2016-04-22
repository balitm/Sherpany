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
    struct TestModelTypes: ModelTypes {
        var kProviderType = DataProviderType.AsyncSession
        var kProcessorType = DataProcessorType.Json
    }

    struct TestConfig: ConfigProtocol {
        var kBaseURL: String = ""
        var kUsersPath: String = ""
        var kAlbumsPath: String = ""
        var kPhotosPath: String = ""
        var kProviderType = DataProviderType.AsyncSession
        var kProcessorType = DataProcessorType.Json

        init(source: Config) {
            kBaseURL = source.kBaseURL
            kUsersPath = source.kUsersPath
            kAlbumsPath = source.kAlbumsPath
            kPhotosPath = source.kPhotosPath
            kProviderType = source.kProviderType
            kProcessorType = source.kProcessorType
        }
    }

    lazy var bundle: NSBundle = {
        return NSBundle(forClass: ModelTests.self)
    }()

    private let _coreDataHelper = CoreDataHelper()
    private let _config = TestConfig(source: Config())
    private var _model: Model! = nil

    override func setUp() {
        super.setUp()
        _coreDataHelper.setUpInMemoryManagedObjectContext()
        XCTAssertNotEqual(_coreDataHelper.managedObjectContext, nil)
        CoreDataManager.initialize(_coreDataHelper.managedObjectContext)
    }
    
    override func tearDown() {
        XCTAssert(_coreDataHelper.releaseMemoryManagedObjectContext())
        _model = nil
        super.tearDown()
    }


    // MARK: Async (NSURL) tests

    func testAsyncLoadUsers() {
        var config = _config; config.kProviderType = .Async
        _model = Model(config: config)
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

    func testAsyncLoadAlbums() {
        var config = _config; config.kProviderType = .Async
        _model = Model(config: config)
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

    func testAsyncLoadPhotos() {
        var config = _config; config.kProviderType = .Async
        _model = Model(config: config)
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

    func testAsyncLoadPicture() {
        var config = _config; config.kProviderType = .Async
        _model = Model(config: config)
        let expectation = expectationWithDescription("Async Method")
        let urlpath = bundle.pathForResource("thumbnail", ofType: "png")
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


    // MARK: AsyncSession (NSURLSession) tests

    func testAsyncSessionLoadUsers() {
        var config = _config; config.kProviderType = .AsyncSession
        _model = Model(config: config)
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

    func testAsyncSessionLoadAlbums() {
        var config = _config; config.kProviderType = .AsyncSession
        _model = Model(config: config)
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

    func testAsyncSessionLoadPhotos() {
        var config = _config; config.kProviderType = .AsyncSession
        _model = Model(config: config)
        let expectation = expectationWithDescription("Async Method")

        _model.setupPhotos {
            print("Photos downloaded.")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(15, handler: nil)

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

    func testAsyncSessionLoadPicture() {
        var config = _config; config.kProviderType = .AsyncSession
        _model = Model(config: config)
        let expectation = expectationWithDescription("Async Method")
        let urlpath = bundle.pathForResource("thumbnail", ofType: "png")
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


    // MARK: Alamofire (NSURL) tests

    func testAlamofireSessionLoadUsers() {
        var config = _config; config.kProviderType = .Alamofire
        _model = Model(config: config)
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

    func testAlamofireSessionLoadAlbums() {
        var config = _config; config.kProviderType = .Alamofire
        _model = Model(config: config)
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

    func testAlamofireSessionLoadPhotos() {
        var config = _config; config.kProviderType = .Alamofire
        _model = Model(config: config)
        let expectation = expectationWithDescription("Async Method")

        _model.setupPhotos {
            print("Photos downloaded.")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(15, handler: nil)

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

    func testAlamofireSessionLoadPicture() {
        var config = _config; config.kProviderType = .Alamofire
        _model = Model(config: config)
        let expectation = expectationWithDescription("Async Method")
        let urlpath = bundle.pathForResource("thumbnail", ofType: "png")
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
