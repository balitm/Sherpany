//
//  ListDataSourceTests.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/21/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
import DATAStack
@testable import Sherpany


class ListDataSourceTests: XCTestCase {
    private var _dataSource: ListDataSource!
    private var _dataStack: DATAStack! = nil
    private var _tableView: UITableView!
    private var _testUser = UserData(userId: 1, name: "John Appleseed", email: "a@b.c", catchPhrase: "catch me")

    override func setUp() {
        super.setUp()
        _dataStack = DATAStack(modelName: "Sherpany", bundle: NSBundle(forClass: ListDataSourceTests.self), storeType: .InMemory)
        XCTAssertNotNil(_dataStack)

        _dataSource = ListDataSource(reuseId: "UserCell", entityName: UserEntity.entityName, sortKey: "userId")
        _dataSource.managedObjectContext = _dataStack.mainContext

        _tableView = UITableView()
        _dataSource.tableView = _tableView
        _tableView.dataSource = _dataSource
    }
    
    override func tearDown() {
        _dataStack.drop()
        _tableView = nil
        _dataSource = nil
        super.tearDown()
    }

    func testOneUserInThePersistantStoreResults() {
        _dataStack.createUserEntity(_testUser)
        XCTAssertEqual(_tableView.numberOfSections, 1, "After adding one user number of sections should be 1.")
        XCTAssertEqual(_tableView.numberOfRowsInSection(0), 1, "After adding one user number of rows should be 1.")
    }

}
