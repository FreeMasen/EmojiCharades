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
    
    static func getUser(email: String, completionHandler: (user: User)->()) throws  {
        var u: User?
        if let username = SignInHelper.removeSpecialChars(email) {
            let query = ConnectToFirebase().childByAppendingPath("/users/\(username)")
            do {
                query.observeSingleEventOfType(.Value, withBlock: { q in
 
                        u = try? parseUser(q, userName: username)
                    if u != nil {
                        completionHandler(user: u!)
                    }
                })
            }
        }
        if u == nil {
            throw FBError.generalError
        }
    }
    
    static func parseUser(queryResponse: FDataSnapshot, userName: String) throws -> User {
        if let score = queryResponse.value["globalScore"] as? Int,
            name = queryResponse.value["name"] as? String,
            mResponse = queryResponse.value["messages"] as? [String : NSDictionary]  {
            do {
                let messages = try parseMessages(mResponse)
                return User(name: name, userName: userName, score: score, messages: messages)
            } catch {
                throw FBError.messgaeParseFail
            }
        } else {
            throw FBError.userParseFail
        }
    }
    
    static func parseMessages(messages: [String:NSDictionary]) throws -> [Message] {
        var messageArray = [Message]()

        for (key, value) in messages {
            if let id = key as? String,
                sender = value["sender"] as? String,
                reciever =  value["reciever"] as? String,
                content = value["content"] as? String,
                response = value["response"] as? String,
                pointTo = value["pointTo"] as? Int {
                let score = Score(rawValue: pointTo)!
                    let newMessage = Message(id: UInt(id)!, sender: sender, reciever: reciever, content: content, response: response, pointTo: score)
                    messageArray.append(newMessage)
            } else {
                throw FBError.messgaeParseFail
            }
        }
        return messageArray
    }
    
    static func processMessageUpdate(update: FDataSnapshot, user: User) throws {
        do {
            if let key = update.key as? String, value = update.value as? NSDictionary {
            let messages = [key: value]
            let messageArray = try parseMessages(messages)
            var newMessages = [Message]()
            for m in messageArray {
                if !user.Messages.contains(m) {
                    newMessages.append(m)
                } else {
                    let oldMsg = user.Messages.filter { $0.Id == m.Id }[0]
                    user.GlobalScore += addPoints(m, oldMsg: oldMsg, userName: user.UserName)
                    updateGlobalScore(user)
                    user.updateMessage(m)
                }
            }
            user.Messages += newMessages
            } else {
                throw FBError.messgaeParseFail
                }
        } catch {
                throw FBError.messgaeParseFail
            }
        NSNotificationCenter.defaultCenter().postNotificationName("userChange", object: nil)
    }
    
    static func addPoints(newMsg: Message, oldMsg: Message, userName: String) -> Int {
        if oldMsg.PointTo != newMsg.PointTo {
            if newMsg.Sender == userName {
                if newMsg.PointTo == Score.Sender {
                    return 1
                }
            } else if newMsg.Reciever == userName {
                if newMsg.PointTo == Score.Reciever {
                    return 1
                }
            }
        }
        return 0
    }
    
    static func updateGlobalScore(user: User) {
        let score = ConnectToFirebase().childByAppendingPath("/users/\(user.UserName)/globalScore")
        score.setValue(user.GlobalScore)
    }
}
    enum FBError: ErrorType {
        case messgaeParseFail
        case userParseFail
        case generalError
}