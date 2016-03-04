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
    
    func testSendDataToFireBase() {
        let user = User(id: 1, name: "Robert Masen", email: "r.f.masen@gmail.com", score: 0)
        let messageContent = "🤓👈🍕💞"
        let message = Message(sender: user.Email, reciever: "elizabethann.ashton@gmail.com ", content: messageContent)
        FireBaseHelper.insertUser(user)
    }
    
}
