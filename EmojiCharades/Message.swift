//
//  Message.swift
//  EmojiCharades
//
//  Created by Robert Masen on 3/4/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

class Message {
    let Id: Int
    let Sender: String
    let Reciever: String
    let Content: String
    var Response: String = ""
    var PointTo: Score = .NotYetScored
    
    init(sender: String, reciever: String, content: String) {
        Id = 0
        Sender = sender
        Reciever = reciever
        Content = content
    }
    
    func scoreMessage(responseCorrect: Bool) {
        if responseCorrect {
            PointTo = .Reciever
        } else {
            PointTo = .Sender
        }
    }
    
    func asDictionary() -> AnyObject {
        let dictionary = ["sender":Sender, "reciever":Reciever, "Content":Content, "response":Response, "pointto":PointTo.rawValue]
        return dictionary
    }
}

enum Score : Int{
    case NotYetScored
    case Sender
    case Reciever
}