//
//  Message.swift
//  EmojiCharades
//
//  Created by Robert Masen on 3/4/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

class Message : Equatable {
    let Id: UInt
    let Sender: String
    let Reciever: String
    let Content: String
    var Response: String = ""
    var PointTo: Score = .NotYetScored
    
    init(sender: String, reciever: String, content: String) {
        
        Id = UInt(NSDate().timeIntervalSince1970*1000000)
        Sender = sender
        Reciever = reciever
        Content = content
    }
    
    init(id: UInt, sender: String, reciever: String, content: String, response: String, pointTo: Score) {
        Id = id
        Sender = sender
        Reciever = reciever
        Content = content
        Response = response
        PointTo = pointTo
    }
    
    
    func scoreMessage(responseCorrect: Bool) {
        if responseCorrect {
            PointTo = .Reciever
        } else {
            PointTo = .Sender
        }
    }
    
    func asDictionary() -> AnyObject {
        let dictionary = ["sender":Sender, "reciever":Reciever, "content":Content, "response":Response, "pointTo":PointTo.rawValue]
        return dictionary
    }
    


}

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.Id == rhs.Id
}

enum Score : Int{
    case NotYetScored
    case Sender
    case Reciever
}