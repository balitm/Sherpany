//
//  AlbumsTableViewController.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData

private let _kReuseId = "AlbumCell"

class AlbumsTableViewController: UITableViewController {
    weak var model: Model!
    var userId: Int16 = -1
    private var _fetchedResultsController: NSFetchedResultsController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Download and set up the data of the albums in database.
        if model.isEmptyAlbums() {
            model.setupAlbums {
                print("albums added to db.")
            }
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(_kReuseId, forIndexPath: indexPath)
        _configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    // Configure a basic UITableViewCell for an album entity.
    private func _configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let album = self.fetchedResultsController.objectAtIndexPath(indexPath) as? AlbumEntity {
            cell.textLabel?.text = album.title
        }
    }
}


// MARK: - Fetched results controller
extension AlbumsTableViewController: NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let moc = CoreDataManager.instance.managedContext
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("AlbumEntity", inManagedObjectContext: moc)
        fetchRequest.entity = entity

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "albumId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchRequest.predicate = NSPredicate(format: "userId == %d", self.userId)

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc , sectionNameKeyPath: nil, cacheName: "Albums")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController

        do {
            try _fetchedResultsController!.performFetch()
        } catch let error as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }

        return _fetchedResultsController!
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // In the simplest, most efficient, case, reload the table view.
        self.tableView.reloadData()
    }
}
