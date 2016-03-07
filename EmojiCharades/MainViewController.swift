//
//  MainViewController.swift
//  EmojiCharades
//
//  Created by Robert Masen on 3/4/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import UIKit
import Google

class MainViewController : UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Seed.testTwoUsersOneMessage()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
}