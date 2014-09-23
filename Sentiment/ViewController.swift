//
//  ViewController.swift
//  Sentiment
//
//  Created by Skip Wilson on 9/11/14.
//  Copyright (c) 2014 Skip Wilson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var stackCommentsURL = "http://api.stackexchange.com/2.2/comments?pagesize=100&fromdate=1409529600&todate=1410652800&order=desc&sort=votes&site=stackoverflow&filter=!1zSoQj(ntDnj)US2KN2NS"
    
    var comments = [Comment]()
    
    var regex = NSRegularExpression.regularExpressionWithPattern("<[^>]*>", options: nil, error: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailView:DetailView = segue.destinationViewController as DetailView
        detailView.comment = comments[tableView.indexPathForSelectedRow()!.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "commentCell"
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = comments[indexPath.row].body
        cell.detailTextLabel!.text = "\(comments[indexPath.row].ownerName) : \(String(comments[indexPath.row].ownerRep))"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func getData() {
        Get.JSON(stackCommentsURL) {
            (response) in
            for comment in response["items"]! as NSArray {
                var commentBody = comment["body"]! as NSString
                var removeHTML = self.regex!.stringByReplacingMatchesInString(commentBody, options: nil, range: NSMakeRange(0, commentBody.length), withTemplate: "")
                var owner = comment["owner"]! as NSDictionary
                var rep = owner["reputation"]! as Int
                var commentID = comment["comment_id"]! as Int
                var ownerName = owner["display_name"]! as String
                var commentObj = Comment(body: removeHTML, commentID: commentID, ownerRep: rep, ownerName: ownerName)
                self.comments.append(commentObj)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.fixComments()
                println(String(self.comments.count))
                println("reloading")
                self.tableView.reloadData()
            }
        }
    }
    
    func fixComments() {
        for comment in comments {
            let encodedData = comment.body.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType]
            let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
            let decodedString = attributedString.string
            comment.body = decodedString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

