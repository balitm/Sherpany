//
//  Model.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class Model {
    private let _net = ModelNet()

    func setupUsers(finished: () -> Void) {
        do {
            try _net.downloadUsers { (result) -> Void in
                if let users = result {
                    let cdm = CoreDataManager.instance
                    for user in users {
                        cdm.createUserEntity(user)
                    }
                    cdm.saveContext()
                } else {
                    print("No users downloaded.")
                }
                finished();
            }
        } catch {
        }
    }
}