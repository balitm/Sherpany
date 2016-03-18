//
//  ListDataSource.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/18/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData


class ListDataSource: NSObject, ListDataSourceProtocol {
    var managedObjectContext: NSManagedObjectContext?
    weak var tableView: UITableView!

    var kReuseId: String
    var kEntityName: String
    var kSortKey: String
    var kCacheName: String
    var predicate: NSPredicate?
    private var _fetchedResultsController: NSFetchedResultsController? = nil
    weak var delegate: ListDataSourceDelegate? = nil


    init(reuseId: String, entityName: String, sortKey: String) {
        kReuseId = reuseId
        kEntityName = entityName
        kSortKey = sortKey
        kCacheName = entityName
        predicate = nil
        super.init()
    }


    // MARK: - Table View Data Source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReuseId, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    // Configure a UITableViewCell.
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        delegate?.configureCell(cell, atIndexPath: indexPath)
    }

    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        return _fetchedResultsController?.objectAtIndexPath(indexPath)
    }
}


// MARK: - Fetched results controller

extension ListDataSource: NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        guard let moc = self.managedObjectContext else {
            assert(false)
        }

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

    func refetch() {
        NSFetchedResultsController.deleteCacheWithName(kCacheName)
        _performFetch()
        tableView.reloadData()
    }

    private func _performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
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


class SearchableListDataSource: ListDataSource, SearchableListDataSourceProtocol {
    func fetchWithPredicate(predicate: NSPredicate?) {
        guard let fetchedResultsController = _fetchedResultsController else {
            return
        }
        NSFetchedResultsController.deleteCacheWithName(kCacheName)
        fetchedResultsController.fetchRequest.predicate = predicate == nil ? self.predicate : predicate;
        _performFetch()
        tableView.reloadData()
    }
}