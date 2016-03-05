//
//  DataStructs.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

// Structs to hold data between JSON and core data entities.

struct UserData {
    var userId: Int16 = -1
    var name: String = ""
    var email: String = ""
    var catchPhrase: String = ""
}

struct AlbumData {
    var albumId: Int16 = -1
    var userId: Int16 = -1
    var title: String = ""
}

struct PhotoData {
    var photoId: Int16 = -1
    var albumId: Int16 = -1
    var title: String = ""
    var thumbnailUrl: String = ""
}