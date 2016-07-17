//
//  DetailsTableViewController.swift
//  TwitterAnalytics
//
//  Created by Abdulrhman  eaita on 7/17/16.
//  Copyright © 2016 Abdulrhman eaita. All rights reserved.
//

import UIKit

class DetailsTableViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var followersCounter: UILabel!
    @IBOutlet weak var followingCounter: UILabel!
    @IBOutlet weak var favoritesCounter: UILabel!
    
    
    var data: userDetails!
    
    // MARK: - Helper
    
    func updateUI() -> Void {
        
        bioTextView?.text = data.bioText
        followersCounter?.text = data.followers
        followingCounter?.text = data.following
        favoritesCounter?.text = data.favs
        title = data.username
    }
    
    
    
    // MARK: - View controller

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   }
