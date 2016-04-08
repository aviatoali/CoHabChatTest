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

//MARK: Create Chatroom

//function that takes 2 backendless users and combines their user ids to generate a chatroom ID to return as a string
func startChat(user1: BackendlessUser, user2: BackendlessUser) -> String
{
    //user 1 is current user
    let userId1: String = user1.objectId
    let userId2: String = user2.objectId
    
    var chatRoomId: String = "" //Store chatroom ID
    
    let value = userId1.compare(userId2).rawValue //compare user ID values
    
    if(value < 0)
    {
        chatRoomId = userId1.stringByAppendingString(userId2)
    }
    else
    {
        chatRoomId = userId2.stringByAppendingString(userId2)
    }
    let members = [userId1, userId2]
    //call function to create recent
    CreateRecent(userId1, chatRoomID: chatRoomId, members: members, withUserUsername: user2.name!, withUseruserId: userId2)
    CreateRecent(userId2, chatRoomID: chatRoomId, members: members, withUserUsername: user1.name!, withUseruserId: userId1)
    
    return chatRoomId
}


//MARK: Create recent item

//function to create a recent
func CreateRecent(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUseruserId: String)
{
    firebase.childByAppendingPath("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomID).observeSingleEventOfType(.Value, withBlock: { snapshot in //will run only once due to observeSingleEventType, since firebase is live database, so if we don't flag it as single, it'll push to users every change
        
        var createRec = true
        //check for a result in snapshot (returned by query):
        if(snapshot.exists())
        {
            for recent in snapshot.value.allValues //go through all snapshot values
            {
                if(recent["userId"] as! String == userId) //if theres already a recent with based user ID, don't make one
                {
                    createRec = false
                }
            }
        }
        if(createRec) //call function to create recent item
        {
            createRecentItem(userId, chatRoomID: chatRoomID, members: members, withUserUsername: withUserUsername, withUserUserId: withUseruserId)
        }
    })
}
//function to create recent item
func createRecentItem(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUserUserId: String)
{
    let reference = firebase.childByAppendingPath("Recent").childByAutoId() //generating auto ID from firebase
    let recentId = reference.key //taking generated auto ID, which is the key and adding it to recent ID
    let date = dateFormatter().stringFromDate(NSDate()) //create date text from current date
    let recent = ["recentId" : recentId, "userId" : userId, "chatRoomID" : chatRoomID, "members" : members, "withUserUsername" : withUserUsername, "lastMessage" : "", "counter" : 0, "date" : date, "withUserUserId" : withUserUserId] //creating recent dictionary from values
    //save recent dictionary to firebase:
    reference.setValue(recent) { (error, reference) -> Void in
        if (error != nil)
        {
            print("error in creating recent \(error)")
        }
    }
    
}
//MARK: Helper functions

private let dateFormat = "yyyyMMddHHmmss"

//date formatter:
func dateFormatter() -> NSDateFormatter
{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}
