//
//  CoreDataTests.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/17/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import XCTest
import DATAStack
@testable import Sherpany


private func ==(lhs: UserEntity, rhs: UserData) -> Bool {
    return lhs.name == rhs.name
        && lhs.userId == rhs.userId
        && lhs.email == rhs.email
        && lhs.catchPhrase == rhs.catchPhrase
}

class CoreDataTests: XCTestCase {

    var dataStack: DATAStack!

    override func setUp() {
        super.setUp()
        dataStack = DATAStack(modelName: "Sherpany", bundle: NSBundle(forClass: CoreDataTests.self), storeType: .InMemory)
        XCTAssertNotNil(dataStack)
    }
    
    override func tearDown() {
        dataStack.drop()
        dataStack = nil
        super.tearDown()
    }

    func testCoreData() {
        let user = UserData(userId: 1, name: "John Appleseed", email: "a@b.c", catchPhrase: "catch me")

        dataStack.createUserEntity(user)

        let moc = dataStack.mainContext
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
