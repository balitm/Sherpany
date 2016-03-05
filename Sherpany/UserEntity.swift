//
//  UserEntity.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation
import CoreData


class UserEntity: NSManagedObject {
    class func createUserEntity(moc: NSManagedObjectContext) -> UserEntity {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserEntity", inManagedObjectContext: moc) as! UserEntity
        return newItem
    }
}
