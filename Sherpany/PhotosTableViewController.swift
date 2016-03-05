//
//  PhotosTableViewController.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData

private let _kReuseId = "PhotoCell"


class PhotosTableViewController: UITableViewController {
    weak var model: Model!
    var albumId: Int16 = -1
    private var _fetchedResultsController: NSFetchedResultsController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if model.isEmptyPhotos() {
            model.setupPhotos {
                print("photo info added to db.")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCellWithIdentifier(_kReuseId, forIndexPath: indexPath) as! PhotosTableViewCell
        _configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    private func _configureCell(cell: PhotosTableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as? PhotoEntity {
            cell.titleLabel.text = photo.title
            if photo.thumbnail == nil {
                model.addPicture(photo, finished: {
                    print("Thumbnail \(photo.thumbnailUrl) downloaded.")
                })
            } else {
                cell.thumbnail.image = UIImage(data: photo.thumbnail!)
            }
        }
    }
}


// MARK: - Fetched results controller

extension PhotosTableViewController: NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let moc = CoreDataManager.instance.managedContext
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("PhotoEntity", inManagedObjectContext: moc)
        fetchRequest.entity = entity

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "photoId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchRequest.predicate = NSPredicate(format: "albumId == %d", self.albumId)

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "Photos")
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

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self._configureCell(tableView.cellForRowAtIndexPath(indexPath!) as! PhotosTableViewCell, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
