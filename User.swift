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
    
    init(name: String, userName: String, score: Int) {
        Name = name
        UserName = userName
        GlobalScore = score
    }
    
    func AsDictionary() -> AnyObject {
        let dictionary = ["name": Name, "GlobalScore": GlobalScore]
        return dictionary
    }
}