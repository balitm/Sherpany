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
    let searchController = UISearchController(searchResultsController: nil)

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder, reuseId: "UserCell", entityName: "UserEntity", sortKey: "userId")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Download and set up the data of the users in database.
        if model.isEmptyUsers() {
            model.setupUsers {
                print("users added to db.")
            }
        } else if tableView(tableView, numberOfRowsInSection: 0) == 0 {
            refreshFetch()
        }

        // Setup the search bar.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

        // Put the search bar into the navigation bar.
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar

        // Avoid hiding the navigation bar when presenting the search interface.
        searchController.hidesNavigationBarDuringPresentation = false
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

extension UsersTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        var pred: NSPredicate? = nil
        if !searchText.isEmpty {
            pred = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        changePredicate(pred)
    }
}

extension UsersTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        changePredicate(nil)
    }
}