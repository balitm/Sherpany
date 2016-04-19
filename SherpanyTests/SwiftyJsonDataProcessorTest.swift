//
//  SwiftyJsonDataProcessorTest.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/19/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
@testable import Sherpany


class SwiftyJsonDataProcessorTest: XCTestCase {

    var bundle: NSBundle! = nil
    var processor: SwiftyJsonDataProcessor!

    override func setUp() {
        super.setUp()
        bundle = NSBundle(forClass: self.dynamicType)
        processor = SwiftyJsonDataProcessor()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUsersData() {
        guard let path = bundle.pathForResource("users", ofType: "json"), data = NSData(contentsOfFile: path) else {
            XCTFail()
            return
        }
        let users = processor.processUsers(data)
        XCTAssertNotNil(users)
        XCTAssertEqual(users?.count, 10)
    }

    func testAlbumsData() {
        guard let path = bundle.pathForResource("albums", ofType: "json"), data = NSData(contentsOfFile: path) else {
            XCTFail()
            return
        }
        let albums = processor.processAlbums(data)
        XCTAssertNotNil(albums)
        XCTAssertEqual(albums?.count, 100)
    }

    func testPhotosData() {
        guard let path = bundle.pathForResource("photos", ofType: "json"), data = NSData(contentsOfFile: path) else {
            XCTFail()
            return
        }
        let photos = processor.processPhotos(data)
        XCTAssertNotNil(photos)
        XCTAssertEqual(photos?.count, 5000)
    }
}
