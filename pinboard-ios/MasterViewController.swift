//
//  MasterViewController.swift
//  pinboard-ios
//
//  Created by Igor Ranieri on 06.02.18.
//  Copyright © 2018 Bakken & Bæck. All rights reserved.
//

import UIKit
import SweetUIKit

class MasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var detailViewController: DetailViewController?

    var recentPosts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(RecentTableCell.self)
        self.tableView.fillSuperview()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if PinboardAPIClient.shared.authToken == nil {
            self.performSegue(withIdentifier: "presentLogin", sender: self)
        } else {
            PinboardAPIClient.shared.getRecent() { recent in
                self.recentPosts = recent
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.recentPosts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RecentTableCell.self, for: indexPath)
        let post = self.recentPosts[indexPath.row]

        self.configureCell(cell, with: post)

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete this!")
        }
    }

    func configureCell(_ cell: RecentTableCell, with post: Post) {
        cell.set(title: post.description)
        cell.set(details: post.path)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
}
