//
//  ListDataSourceTests.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/21/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
import CoreData
@testable import Sherpany


class ListDataSourceTests: XCTestCase {

    private let _coreDataHelper = CoreDataHelper()
    private var _dataSource: ListDataSource!
    private var _tableView: UITableView!
    private var _testUser = UserData(userId: 1, name: "John Appleseed", email: "a@b.c", catchPhrase: "catch me")

    override func setUp() {
        super.setUp()
        _coreDataHelper.setUpInMemoryManagedObjectContext()
        XCTAssertNotEqual(_coreDataHelper.managedObjectContext, nil)
        CoreDataManager.initialize(_coreDataHelper.managedObjectContext)

        _dataSource = ListDataSource(reuseId: "UserCell", entityName: UserEntity.entityName, sortKey: "userId")
        _dataSource.managedObjectContext = _coreDataHelper.managedObjectContext

        _tableView = UITableView()
        _dataSource.tableView = _tableView
        _tableView.dataSource = _dataSource
    }
    
    override func tearDown() {
        XCTAssert(_coreDataHelper.releaseMemoryManagedObjectContext())
        _tableView = nil
        _dataSource = nil
        super.tearDown()
    }

    func testOneUserInThePersistantStoreResultsInOneSection() {
        CoreDataManager.instance.createUserEntity(_testUser)
        XCTAssertEqual(_dataSource.numberOfSectionsInTableView(_tableView), 1, "After adding one user number of sections should be 1")
    }

    func testOneUserInThePersistantStoreResultsInOneRow() {
        CoreDataManager.instance.createUserEntity(_testUser)
        XCTAssertEqual(_dataSource.tableView(_tableView, numberOfRowsInSection: 0), 1, "After adding one user number of rows should be 1")
    }
    
}
