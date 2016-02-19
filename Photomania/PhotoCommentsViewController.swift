//
//  PhotoCommentsViewController.swift
//  Photomania
//
//  Created by Essan Parto on 2014-08-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit
import Alamofire

class PhotoCommentsViewController: UITableViewController {
    var photoID: Int = 0
    var comments: [Comment]?
    
    // MARK: Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        
        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        
        Alamofire.request(Five100px.Router.Comments(photoID, 1)).validate().responseCollection() {
            (response: Response<[Comment], NSError>) in
            
            switch response.result {
            case .Success:
                self.comments = response.result.value
                self.tableView.reloadData()
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! PhotoCommentTableViewCell
        
        cell.userFullnameLabel.text = comments![indexPath.row].userFullname
        cell.commentLabel.text = comments![indexPath.row].commentBody
        
        cell.userImageView.image = nil
        
        let imageURL = comments![indexPath.row].userPictureURL
        
        Alamofire.request(.GET, imageURL).validate().responseData() {
            response in
            
            switch response.result {
            case .Success:
                let data = response.result.value
                let image = UIImage(data:data!)
                if response.request!.URLString.isEqual(imageURL) {
                    cell.userImageView.image = image
                }
            case .Failure(let error):
                print(error)
            }
        }
        return cell
    }
}

class PhotoCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userFullnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 5.0
        userImageView.layer.masksToBounds = true
        
        commentLabel.numberOfLines = 0
    }
}