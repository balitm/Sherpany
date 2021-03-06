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

    static var entityName: String {
        return String(self)
    }

    class func createUserEntity(moc: NSManagedObjectContext) -> UserEntity {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: moc) as! UserEntity
        return newItem
    }

}
