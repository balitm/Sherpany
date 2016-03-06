//
//  BaseTableViewController.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/6/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData

class BaseTableViewController: UITableViewController {
    weak var model: Model! = nil
    var kReuseId: String
    var kEntityName: String
    var kSortKey: String
    var kCacheName: String
    var predicate: NSPredicate?
    private var _fetchedResultsController: NSFetchedResultsController? = nil

    required init?(coder aDecoder: NSCoder) {
        assert(false)
        kReuseId = "Unknown"
        kEntityName = "Unknown"
        kSortKey = "Unknown"
        kCacheName = kEntityName
        super.init(coder: aDecoder)
    }

    required init?(coder aDecoder: NSCoder, reuseId: String, entityName: String, sortKey: String) {
        kReuseId = reuseId
        kEntityName = entityName
        kSortKey = sortKey
        kCacheName = entityName
        predicate = nil
        super.init(coder: aDecoder)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(kReuseId, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    // Configure a UsersTableViewCell.
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
    }
}


// MARK: - Fetched results controller

extension BaseTableViewController: NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let moc = CoreDataManager.instance.managedContext
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName(kEntityName, inManagedObjectContext: moc)
        fetchRequest.entity = entity

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: kSortKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Use predicate if defined.
        if let pred = predicate {
            fetchRequest.predicate = pred
        }

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController.deleteCacheWithName(kCacheName)
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: kCacheName)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController

        _performFetch()

        return _fetchedResultsController!
    }

    private func _performFetch() {
        do {
            try _fetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
    }

    func refreshFetch() {
        NSFetchedResultsController.deleteCacheWithName(kCacheName)
        _performFetch()
        tableView.reloadData()
    }

    func changePredicate(predicate: NSPredicate?) {
        guard let fetchedResultsController = _fetchedResultsController else {
            return
        }
        NSFetchedResultsController.deleteCacheWithName(kCacheName)
        fetchedResultsController.fetchRequest.predicate = predicate == nil ? self.predicate : predicate;
        _performFetch()
        tableView.reloadData()
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
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
