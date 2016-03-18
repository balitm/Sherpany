//
//  ListDataSourceProtocol.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/18/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import CoreData


protocol ListDataSourceDelegate: class {
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
}


protocol ListDataSourceProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get set }
    weak var tableView: UITableView! { get set }
    var predicate: NSPredicate? { get set }
    var delegate: ListDataSourceDelegate? { get set }

    func refetch()
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject?
}

protocol SearchableListDataSourceProtocol: ListDataSourceProtocol {
    func fetchWithPredicate(predicate: NSPredicate?)
}