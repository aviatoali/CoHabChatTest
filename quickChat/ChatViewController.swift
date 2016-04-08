//
//  ChatViewController.swift
//  quickChat
//
//  Created by Shan-e-Ali Shah on 4/7/16.
//  Copyright © 2016 Shan-e-Ali Shah. All rights reserved.
//


import UIKit

class ChatViewController: JSQMessagesViewController {
    
    let ref = Firebase(url: "https://quickchatapplication.firebaseio.com/Message") //set up firebase reference to query message
    var messages: [JSQMessage] = [] //array to hold messages
    var objects: [NSDictionary] = [] //array to hold NS dictionaries
    var loaded: [NSDictionary] = [] //array to hol 
    
    var withUser: BackendlessUser?
    var recent: NSDictionary?
    
    var chatRoomId: String! //not optional
    
    //JSQMessage message bubble colors:
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor()) //outgoing message bubble set to blue
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
//incoming message bubble set to light gray

    override func viewDidLoad() {
        super.viewDidLoad()

        //get sender ID and sender display name:
        self.senderId = currentUser.objectId
        self.senderDisplayName = currentUser.name
        
        //set avatar image size for image view
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeZero //incoming
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero //outgoing
        
        //now load Firebase messages through this function:
        
        //comment in, if you wanna change the placeholder for chatroom input box
        //self.inputToolbar?.contentView?.textView?.placeHolder
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
