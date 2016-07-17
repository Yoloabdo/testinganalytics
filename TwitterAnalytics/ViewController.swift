//
//  ViewController.swift
//  TwitterAnalytics
//
//  Created by Abdulrhman  eaita on 7/16/16.
//  Copyright © 2016 Abdulrhman eaita. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {
    
    struct StoryBorad {
        static let SegueId = "details"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)")

                self.loadUser((session?.userID)!, name: (session?.userName)!, completion: { (results) in
                    self.data = results
                    print("Data loaded")
                    self.performSegueWithIdentifier(StoryBorad.SegueId, sender: nil)
                    
                })
                
            } else {
                print("error: \(error!.localizedDescription)")
            }
        }

    }
    var data: userDetails!
    
    func loadUser(id: String, name: String, completion: (results: userDetails!)->Void) -> Void {
        let client = TWTRAPIClient.clientWithCurrentUser()
        let usersShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
        let params = ["id": id, "screen_name": name]
        
        
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: usersShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? JsonDic else { return }
                guard let bio = json["description"] as? String else {
                    print("error in getting description")
                    return
                }
                guard let favs = json["favourites_count"] as? Int else{
                    print("error in getting favourites_count")
                    return
                }
                guard let followers = json["followers_count"] as? Int else {
                    print("error in getting followers_count")
                    return
                }
                guard let friends = json["friends_count"] as? Int else {
                    print("error in getting friends_count")
                    return
                }

                let res = userDetails(username: name, followers: String(followers), following: String(friends), favs: String(favs), bioText: bio)
                completion(results: res)
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
                completion(results: nil)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBorad.SegueId {
            let dvc = segue.destinationViewController as! DetailsTableViewController
            dvc.data = data
            
        }
    }


    
}

typealias JsonDic = [String: AnyObject]

struct userDetails {
    var username: String!
    var followers: String!
    var following: String!
    var favs: String!
    var bioText: String!
    
}

