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

    let Id: Int
    var Name: String
    var Email: String
    var GlobalScore: Int
    
    init(id: Int, name: String, email: String, score: Int) {
        Id = id
        Name = name
        Email = email
        GlobalScore = score
    }
    
    func AsDictionary() -> AnyObject {
        let dictionary = ["id": Id, "name": Name, "email": Email, "GlobalScore": GlobalScore]
        return dictionary
    }
}