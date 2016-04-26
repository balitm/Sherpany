//
//  UsersTableViewController.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import DATAStack


class UsersTableViewController: BaseTableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    private let _listDataSource: SearchableListDataSourceProtocol

    required init?(coder aDecoder: NSCoder) {
        _listDataSource = SearchableListDataSource(reuseId: "UserCell", entityName: UserEntity.entityName, sortKey: "userId")
        super.init(coder: aDecoder)
        _listDataSource.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the data source object.
        _listDataSource.managedObjectContext = dataStack.mainContext
        _listDataSource.tableView = tableView
        tableView.dataSource = _listDataSource

        // Download and set up the data of the users in database.
        if model.isEmptyUsers() {
            model.setupUsers {
                print("users added to db.")
            }
        } else if tableView(tableView, numberOfRowsInSection: 0) == 0 {
            _listDataSource.refetch()
        }

        // Setup the search bar.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

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
            let user = _listDataSource.objectAtIndexPath(indexPath) as! UserEntity
            let controller = segue.destinationViewController as! AlbumsTableViewController
            controller.model = model
            controller.dataStack = dataStack
            controller.userId = user.userId
            controller.navigationItem.title = user.name
        }
    }
}


// MARK: - ListDataSourceDelegate

extension UsersTableViewController: ListDataSourceDelegate {
    // Configure a UsersTableViewCell.
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let userCell = cell as? UsersTableViewCell else {
            assert(false)
        }
        if let user = _listDataSource.objectAtIndexPath(indexPath) as? UserEntity {
            userCell.nameLabel.text = user.name
            userCell.emailLabel.text = user.email
            userCell.catchPhraseLabel.text = user.catchPhrase
        }
    }
}


// MARK: - UISearchResultsUpdating

extension UsersTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        var pred: NSPredicate? = nil
        if !searchText.isEmpty {
            pred = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        _listDataSource.fetchWithPredicate(pred)
    }
}

extension UsersTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        _listDataSource.fetchWithPredicate(nil)
    }
}