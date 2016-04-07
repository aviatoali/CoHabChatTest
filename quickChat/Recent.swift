//
//  Recent.swift
//  quickChat
//
//  Created by Shan-e-Ali Shah on 4/7/16.
//  Copyright © 2016 Shan-e-Ali Shah. All rights reserved.
//

import Foundation

let firebase = Firebase(url: "https://quickchatapplication.firebaseio.com/")
let backendless = Backendless.sharedInstance()
let currentUser = backendless.userService.currentUser


//MARK: Helper functions

private let dateFormat = "yyyyMMddHHmmss"

//date formatter:
func dateFormatter() -> NSDateFormatter
{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}
