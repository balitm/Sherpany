//
//  UsersTableViewController.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData


class UsersTableViewController: BaseTableViewController {
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder, reuseId: "UserCell", entityName: "UserEntity", sortKey: "userId")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Download and set up the data of the users in database.
        model.setupUsers {
            print("users added to db.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    // Prepare for showing albums data.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        assert(segue.identifier == "albumsSegue")
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let user = self.fetchedResultsController.objectAtIndexPath(indexPath) as! UserEntity
            let controller = segue.destinationViewController as! AlbumsTableViewController
            controller.model = model
            controller.userId = user.userId
            controller.navigationItem.title = user.name
        }
    }


    // MARK: - Table View

    // Configure a UsersTableViewCell.
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let userCell = cell as? UsersTableViewCell else {
            assert(false)
        }
        if let user = self.fetchedResultsController.objectAtIndexPath(indexPath) as? UserEntity {
            userCell.nameLabel.text = user.name
            userCell.emailLabel.text = user.email
            userCell.catchPhraseLabel.text = user.catchPhrase
        }
    }
}
