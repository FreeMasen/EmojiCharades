//
//  Seed.swift
//  EmojiCharades
//
//  Created by Robert Masen on 3/4/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

class Seed {
    
    
    static func testTwoUsersOneMessage() {
        let robert = User(name: "Robert Masen", userName: "rfmasen", score: 0)
        let beth = User(name: "Beth Ashton", userName: "elizabethannashton", score: 0)
        let messageContent = "🤓👈🍕💞"
        let message = Message(sender: robert.UserName, reciever: beth.UserName, content: messageContent)
        FireBaseHelper.insertNewUser(robert)
        FireBaseHelper.insertNewUser(beth)
        FireBaseHelper.insertNewMessage(message)
    }
}