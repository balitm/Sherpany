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
    var albumId: Int16 = -1

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder, reuseId: "PhotoCell", entityName: "PhotoEntity", sortKey: "photoId")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the predicate for the Core Data fetch.
        predicate = NSPredicate(format: "albumId == %d", self.albumId)

        // Download and set up the data of the photos in database.
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

    // Configure a PhotosTableViewCell.
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as? PhotoEntity {
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
            }
        }
    }
}
