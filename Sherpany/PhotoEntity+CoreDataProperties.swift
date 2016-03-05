//
//  PhotoEntity+CoreDataProperties.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PhotoEntity {

    @NSManaged var albumId: Int16
    @NSManaged var photoId: Int16
    @NSManaged var thumbnailUrl: String?
    @NSManaged var title: String?
    @NSManaged var thumbnail: NSData?
    @NSManaged var album: AlbumEntity?

}
