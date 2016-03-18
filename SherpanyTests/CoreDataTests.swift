//
//  CoreDataTests.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/17/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
import CoreData
@testable import Sherpany


private func ==(lhs: UserEntity, rhs: UserData) -> Bool {
    return lhs.name == rhs.name
        && lhs.userId == rhs.userId
        && lhs.email == rhs.email
        && lhs.catchPhrase == rhs.catchPhrase
}

class CoreDataTests: XCTestCase {

    override func setUp() {
        super.setUp()
        CoreDataManager.initialize(setUpInMemoryManagedObjectContext())
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCoreData() {
        let user = UserData(userId: 1, name: "John Appleseed", email: "a@b.c", catchPhrase: "catch me")
        let cdm = CoreDataManager.instance

        cdm.createUserEntity(user)

        let moc = cdm.managedContext
        let fetch = NSFetchRequest(entityName: UserEntity.entityName)

        do {
            let fetched = try moc.executeFetchRequest(fetch) as! [UserEntity]
            XCTAssert(fetched.count == 1)
            XCTAssert(fetched[0] == user)
        } catch {
            fatalError("Failed to fetch users: \(error)")
        }

    }
}
