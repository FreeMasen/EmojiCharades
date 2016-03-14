//
//  File.swift
//  
//
//  Created by Robert Masen on 3/3/16.
//
//

import Foundation
import Google

class User {

    var Name: String
    var UserName: String
    var GlobalScore: Int
    var Messages: [Message]
    var messageCount: Int {
        return Messages.count
    }
    
    //for existing users
    init(name: String, userName: String, score: Int, messages: [Message]) {
        Name = name
        UserName = userName
        GlobalScore = score
        Messages = messages
    }
    
    //only for new users
    init(googleUser: GIDGoogleUser) {
        let email = googleUser.profile.email
        UserName = SignInHelper.removeSpecialChars(email)!
        Name = googleUser.profile.name
        GlobalScore = 0
        Messages = [Message]()
    }
    
    //returns the object as a dictionary to hand over to FireBase
    func AsDictionary() -> AnyObject {
        let dictionary = ["name": Name, "globalScore": GlobalScore, "messages": messageArrayToDictionary()]
        return dictionary
    }
    
    //Converts the messages to dictionary to hand over to firebase
    func messageArrayToDictionary() -> [String: AnyObject] {
        var messages = [String: AnyObject]()
        for m in Messages {
            messages[String(m.Id)] = m.asDictionary()
        }
        return messages
    }
    
    func updateMessage(message: Message) {
        var oldMessage = Messages.filter { $0.Id == message.Id }[0]
        oldMessage = message
    }
    
    func removeMessage(messageID: Int) {
        let shorterList = Messages.filter { $0.Id != messageID }
        self.Messages = shorterList
    }
    
    func sent() -> [Message]{
        return Messages.filter { $0.Sender == UserName }
    }
    
    func recieved() -> [Message] {
        return Messages.filter { $0.Reciever == UserName }
    }
    
    func unread() -> [Message] {
        let notYetGaded = Messages.filter { $0.PointTo == .NotYetScored }
        let needingResponse = notYetGaded.filter { $0.Sender != self.UserName && $0.Response == "" }
        let needingGrade = notYetGaded.filter { $0.Sender == self.UserName && $0.Response != "" }
        return needingGrade + needingResponse
    }
}