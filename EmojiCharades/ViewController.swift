//
//  ViewController.swift
//  EmojiCharades
//
//  Created by Robert Masen on 3/3/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let information = NSDictionary(contentsOfFile: path!)
        let id = information!["Bundle identifier"]
        print(information)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

