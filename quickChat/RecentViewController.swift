//
//  RecentViewController.swift
//  quickChat
//
//  Created by Shan-e-Ali Shah on 4/7/16.
//  Copyright © 2016 Shan-e-Ali Shah. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChooseUserDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var recents: [NSDictionary] = [] //stores recents
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1 //only going to have 1 section in table
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //dynamic, dependent on how many recent messages
        return recents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RecentTableViewCell
        
        let recent = recents[indexPath.row]
        
        cell.bindData(recent)
        
        return cell
    }
    
    //MARK: UITableViewDelegate functions
    
    //when user selects the table view at indexpath call segue:
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)//deselect user
        performSegueWithIdentifier("recentToChatSeg", sender: indexPath) //segue awaaaaay!
        
    }

    
    
    //MARK: IBActions
    
    @IBAction func startNewChatBarButtonItemPressed(sender: AnyObject)
    {
        //button calling the segue
        performSegueWithIdentifier("recentToChooseUserVC", sender: self)
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //check segue
        if(segue.identifier == "recentToChooseUserVC")
        {
            let vc = segue.destinationViewController as! ChooseUserViewController
            vc.delegate = self
        }
        
        if(segue.identifier == "recentToChatSegue")
        {
            let indexPath = sender as! NSIndexPath
            let chatVC = segue.destinationViewController as! ChatViewController
            
            let recent = recents[indexPath.row]
            
            //set chatVC recent to the recents for chatroom
            chatVC.recent = recent
            chatVC.chatRoomId = recent["chatroomID"] as? String //set chatroom ID
            
        }
    }
    
    //MARK: ChooseUserDelegate
    
    //as soon as user taps cell to create chatroom with selected user
    func createChatroom(withUser: BackendlessUser)
    {
        let chatVC = ChatViewController()//instantiate chat view controller
        chatVC.hidesBottomBarWhenPushed = true //hide the bottom navigation bar from view when chat initiated
        
        //call the navigation controller to put to new created chat view controller on stack
        navigationController?.pushViewController(chatVC, animated: true)
        
        //set chatVC recent to the recent
        chatVC.withUser = withUser
        chatVC.chatRoomId = startChat(currentUser, user2:withUser) //generate chatroom ID using user ID
    }
}
