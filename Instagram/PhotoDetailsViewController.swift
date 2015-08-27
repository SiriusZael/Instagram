//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Matt Rucker on 8/26/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var photo: NSDictionary!
    var comments: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: photo.valueForKeyPath("images.thumbnail.url") as! String)!
        photoView.setImageWithURL(url)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comments = comments {
            return comments.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
        
        let comment = comments![indexPath.row]
        
        cell.commentLabel.text = comment["text"] as? String
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
