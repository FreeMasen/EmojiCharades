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
    
    static func ConnectToFirebase() -> Firebase {
        let database = Firebase(url: "https://glaring-torch-2429.firebaseio.com/")
        return database
    }
    
    static func insertNewUser(user: User) {
        let users = ConnectToFirebase().childByAppendingPath("/users/\(user.UserName)")
        users.setValue(user.AsDictionary())
    }
    
    static func insertNewMessage(message: Message) {
        let sender = message.Sender
        let reciever = message.Reciever
        let senderLocation = ConnectToFirebase().childByAppendingPath("/users/\(sender)/messages/\(message.Id)")
        senderLocation.setValue(message.asDictionary())
        let recieverLoction = ConnectToFirebase().childByAppendingPath("/users/\(reciever)/messages/\(message.Id)")
        recieverLoction.setValue(message.asDictionary())
    }
    
    static func getUser(email: String, completionHandler: (user: User)->() )  {
        var user: User?
        if let username = SignInHelper.removeSpecialChars(email) {
            let query = ConnectToFirebase().childByAppendingPath("/users/\(username)")
            query.observeSingleEventOfType(.Value, withBlock: { q in
                user = parseUser(q as FDataSnapshot, userName: username)
                completionHandler(user: user!)
            })
        }
        
    }
    
    static func parseUser(queryResponse: FDataSnapshot, userName: String) -> User {
        let score = queryResponse.value!["globalScore"] as! Int
        let name = queryResponse.value!["name"] as! String
    
        if let mResponse = queryResponse.value!["messages"] as? [String : NSDictionary] {
            let messages = parseMessages(mResponse)
            return User(name: name, userName: userName, score: score, messages: messages)
        } else {
            return User(name: name, userName: userName, score: score, messages: [Message]())
        }
        
    }
    
    static func parseMessages(messages: [String:NSDictionary]) -> [Message] {
        var messageArray = [Message]()
        for (key, value) in messages {
            let id = Int(key)
            let sender = value["sender"] as! String
            let reciever = value["reciever"] as! String
            let content = value["content"] as! String
            let response = value["response"] as! String
            let pointTo = value["pointTo"] as! Int
            
            let newMessage = Message(id: id!, sender: sender, reciever: reciever, content: content, response: response, pointTo: Score(rawValue: pointTo)!)
            messageArray.append(newMessage)
        }
        return messageArray
    }
    
    static func processMessageUpdate(update: FDataSnapshot, user: User) {
        var messages = [String:NSDictionary]()
        messages[update.key] = update.value as? NSDictionary
        let messageArray = parseMessages(messages)
        var newMessages = [Message]()
        for m in messageArray {
            if !user.Messages.contains(m) {
                newMessages.append(m)
            } else {
                user.updateMessage(m)
            }
        }
        user.Messages += newMessages
    }
}