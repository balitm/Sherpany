//
//  ModelTests.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/16/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLoadUsers() {
        _model.setupUsers {
            print("Users downloaded.")
        }
    }
}
