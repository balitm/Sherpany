//
//  PhotosTableViewController.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData


class PhotosTableViewController: BaseTableViewController {
    private let _listDataSource: ListDataSourceProtocol
    var albumId: Int16 = -1

    required init?(coder aDecoder: NSCoder) {
        _listDataSource = ListDataSource(reuseId: "PhotoCell", entityName: PhotoEntity.entityName, sortKey: "photoId")
        super.init(coder: aDecoder)
        _listDataSource.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the data source object.
        _listDataSource.managedObjectContext = dataStack.mainContext
        _listDataSource.tableView = tableView
        tableView.dataSource = _listDataSource

        // Set the predicate for the Core Data fetch.
        _listDataSource.predicate = NSPredicate(format: "albumId == %d", self.albumId)

        // Download and set up the data of the photos in database.
        if model.isEmptyPhotos() {
            model.setupPhotos {
                print("photo info added to db.")
            }
        } else if tableView(tableView, numberOfRowsInSection: 0) == 0 {
            _listDataSource.refetch()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - ListDataSourceDelegate

extension PhotosTableViewController: ListDataSourceDelegate {
    // Configure a UsersTableViewCell.
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let photo = _listDataSource.objectAtIndexPath(indexPath) as? PhotoEntity {
            guard let photoCell = cell as? PhotosTableViewCell else {
                assert(false)
            }
            photoCell.titleLabel.text = photo.title
            if photo.thumbnail == nil {
                // No image data yet, dowload it now. When the async download is
                // finished the fetchedResultController will update this cell.
                model.addPicture(photo, finished: {
                    print("Thumbnail \(photo.thumbnailUrl) downloaded.")
                })
            } else {
                // Set up the image from the database.
                photoCell.thumbnail.image = UIImage(data: photo.thumbnail!)
                photoCell.indicator.stopAnimating()
            }
        }
    }
}
