//
//  FireBaseHelper.swift
//  EmojiCharades
//
//  Created by Robert Masen on 3/4/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation
import Firebase

class FireBaseHelper {
    
    private static func ConnectToFirebase() -> Firebase {
        let database = Firebase(url: "https://glaring-torch-2429.firebaseio.com/")
        return database
    }
    
    static func insertNewUser(user: User) {
        let users = ConnectToFirebase().childByAppendingPath("/emojichrades/users")
        users.setValue(user.AsDictionary())
    }
}