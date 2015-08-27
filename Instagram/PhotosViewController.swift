//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Matt Rucker on 8/26/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var photos: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableFooterView: UIView = UIView(frame: CGRect(x:0, y:0, width:320, height:50))
        var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.tableView.tableFooterView = tableFooterView
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)

        
        loadData(){}
        
        tableView.rowHeight = 320
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let photos = photos {
            return photos.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let photo = photos![section]
        
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        var profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        let url = NSURL(string: photo.valueForKeyPath("user.profile_picture") as! String)!
        profileView.setImageWithURL(url)
        headerView.addSubview(profileView)
        
        var userNameView = UILabel(frame: CGRect(x: 50, y: 10, width: 100, height: 30))
        userNameView.text = photo.valueForKeyPath("user.username") as? String
        headerView.addSubview(userNameView)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let photo = photos![indexPath.section]
        
        let url = NSURL(string: photo.valueForKeyPath("images.thumbnail.url") as! String)!

        cell.photoView.setImageWithURL(url)
        
        if indexPath.section == numberOfSectionsInTableView(tableView) {
        
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onRefresh() {
        loadData() {self.refreshControl.endRefreshing()}
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let photoDetailsViewController = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        let photo = photos![indexPath.row]
        let comments = photos![indexPath.row]
        
        photoDetailsViewController.photo = photo
        photoDetailsViewController.comments = photo.valueForKeyPath("comments.data") as? [NSDictionary]
    }

    func loadData(cb: ()-> ()) {
        var clientId = "4087714d266740e3b6d1be098eb76539"
        
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
            self.photos = responseDictionary["data"] as? [NSDictionary]
            cb()
            self.tableView.reloadData()
        }
    }
}
