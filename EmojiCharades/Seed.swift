//
//  Seed.swift
//  EmojiCharades
//
//  Created by Robert Masen on 3/4/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

class Seed {
    
    static func seedUserWithMessages() {
        var messages = [Message]()
        let messageContent = "🤓👈🍕💞"
        for _ in 1...10 {
            let message = Message(sender: "rfmasen", reciever: "elizabethannashton", content: messageContent)
            messages.append(message)
        }
        for _ in 1...10 {
            let message = Message(sender: "elizabethannashton", reciever: "rfmasen", content: messageContent)
            messages.append(message)
        }
        let robert = User(name: "Robert Masen", userName: "rfmasen", score: 0, messages: messages)
        let beth = User(name: "Beth Ashton", userName: "elizabethannashton", score: 0, messages: messages)
        FireBaseHelper.insertNewUser(robert)
        FireBaseHelper.insertNewUser(beth)
    }
    
    static func seedWithMessageTypes() {
        let messageContent = "🤓👈🍕💞"

        let robert = User(name: "Robert Masen", userName: "rfmasen", score: 0, messages: [Message]())
        let rob = User(name: "Rob Masen", userName: "mochzynski", score: 0, messages: [Message]())
        let needingGrade = Message(sender: robert.UserName, reciever: rob.UserName, content: messageContent)
        needingGrade.Response = "I love pizza"
        let needingResponse = Message(sender: rob.UserName, reciever: robert.UserName, content: messageContent)
        FireBaseHelper.insertNewUser(robert)
        FireBaseHelper.insertNewUser(rob)
        FireBaseHelper.insertNewMessage(needingResponse)
        FireBaseHelper.insertNewMessage(needingGrade)
    }
}

