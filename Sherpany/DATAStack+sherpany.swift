//
//  DATAStack+sherpany.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/26/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import DATAStack

extension DATAStack {
    func createUserEntity(data: UserData) -> UserEntity {
        let user = UserEntity.createUserEntity(self.mainContext)
        user.userId = data.userId
        user.name = data.name
        user.email = data.email
        user.catchPhrase = data.catchPhrase
        return user
    }

    func createAlbumEntity(data: AlbumData) -> AlbumEntity {
        let album = AlbumEntity.createAlbumEntity(self.mainContext)
        album.albumId = data.albumId
        album.userId = data.userId
        album.title = data.title
        return album
    }

    func createPhotoEntity(data: PhotoData) -> PhotoEntity {
        let photo = PhotoEntity.createPhotoEntity(self.mainContext)
        photo.photoId = data.photoId
        photo.albumId = data.albumId
        photo.title = data.title
        photo.thumbnailUrl = data.thumbnailUrl
        return photo
    }

    func isEmpty(entityName: String) -> Bool {
        let request = NSFetchRequest(entityName: entityName)
        return self.mainContext.countForFetchRequest(request, error: nil) == 0
    }
}