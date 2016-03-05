//
//  AlbumEntity+CoreDataProperties.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AlbumEntity {

    @NSManaged var albumId: Int16
    @NSManaged var userId: Int16
    @NSManaged var title: String?
    @NSManaged var user: UserEntity?

}
