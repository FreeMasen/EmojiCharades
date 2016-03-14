//
//  EmojiCharadesTests.swift
//  EmojiCharadesTests
//
//  Created by Robert Masen on 3/3/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import XCTest
@testable import EmojiCharades

class EmojiCharadesTests: XCTestCase {
    var fireBaseHelper = FireBaseHelper()
    var signInHelper = SignInHelper()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEmail(){
        let test = removeSpecialChars("r.f.masen@gmail.com")
        print(test)
        XCTAssert(test == "rfmasen")
    }
    
    func testSendDataToFireBase() {
//        let user = User(name: "Robert Masen", userName: "rfmasen", score: 0)
//        let messageContent = "🤓👈🍕💞"
//        let message = Message(sender: user.UserName, reciever: "elizabethannashton", content: messageContent)
//        FireBaseHelper.insertUser(user)
    }
    
    func removeSpecialChars(email: String) -> String? {
        var beforeAt = String()
        var userName = String()
        for index in email.characters.indices {
            if email[index] == "@" {
                beforeAt = email.substringToIndex(index)
            }
        }
        for c in beforeAt.characters {
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
