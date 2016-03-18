//
//  AlbumsTableViewController.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData

class AlbumsTableViewController: UITableViewController {
    weak var model: Model! = nil
    var userId: Int16 = -1
    private let _listDataSource: ListDataSourceProtocol

    required init?(coder aDecoder: NSCoder) {
        _listDataSource = SearchableListDataSource(reuseId: "AlbumCell", entityName: AlbumEntity.entityName, sortKey: "albumId")
        super.init(coder: aDecoder)
        _listDataSource.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the data source object.
        _listDataSource.managedObjectContext = CoreDataManager.instance.managedContext
        _listDataSource.tableView = tableView
        tableView.dataSource = _listDataSource

        // Set the predicate for the Core Data fetch.
        _listDataSource.predicate = NSPredicate(format: "userId == %d", self.userId)

        // Download and set up the data of the albums in database.
        if model.isEmptyAlbums() {
            model.setupAlbums {
                print("albums added to db.")
            }
        } else if tableView(tableView, numberOfRowsInSection: 0) == 0 {
            _listDataSource.refetch()
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
            let album = _listDataSource.objectAtIndexPath(indexPath) as! AlbumEntity
            let controller = segue.destinationViewController as! PhotosTableViewController
            controller.model = model
            controller.albumId = album.albumId
            controller.navigationItem.title = album.title
        }
    }

}


// MARK: - ListDataSourceDelegate

extension AlbumsTableViewController: ListDataSourceDelegate {
    // Configure a basic UITableViewCell for an album entity.
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let album = _listDataSource.objectAtIndexPath(indexPath) as? AlbumEntity {
            cell.textLabel?.text = album.title
        }
    }
}