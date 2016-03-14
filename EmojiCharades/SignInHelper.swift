//
//  SignInHelper.swift
//  EmojiCharades
//
//  Created by Robert Masen on 3/4/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

class SignInHelper {
    
    static var user: User?

    static func removeSpecialChars(email: String) -> String? {
        var beforeAt = String()
        var userName = String()
        for index in email.characters.indices {
            if email[index] == "@" {
                beforeAt = email.substringToIndex(index)
            }
        }
        for c in beforeAt.lowercaseString.characters {
            if c != "." {
            userName.append(c)
            }
        }
        if !userName.isEmpty {
            return userName
        }
        return nil
    }
}