//
//  AlbumsTableViewController.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData

class AlbumsTableViewController: BaseTableViewController {
    var userId: Int16 = -1

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder, reuseId: "AlbumCell", entityName: "AlbumEntity", sortKey: "albumId")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the predicate for the Core Data fetch.
        predicate = NSPredicate(format: "userId == %d", self.userId)

        // Download and set up the data of the albums in database.
        if model.isEmptyAlbums() {
            model.setupAlbums {
                print("albums added to db.")
            }
        } else if tableView(tableView, numberOfRowsInSection: 0) == 0 {
            refreshFetch()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    // Prepare for showing albums data.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        assert(segue.identifier == "photosSegue")
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let album = self.fetchedResultsController.objectAtIndexPath(indexPath) as! AlbumEntity
            let controller = segue.destinationViewController as! PhotosTableViewController
            controller.model = model
            controller.albumId = album.albumId
            controller.navigationItem.title = album.title
        }
    }


    // MARK: - Table View

    // Configure a basic UITableViewCell for an album entity.
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let album = self.fetchedResultsController.objectAtIndexPath(indexPath) as? AlbumEntity {
            cell.textLabel?.text = album.title
        }
    }
}