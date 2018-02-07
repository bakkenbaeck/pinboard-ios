import UIKit
import SafariServices
import SweetUIKit
import CoreData

final class RecentViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    // private let searchResultsUpdater = SearchResultsUpdater()

    lazy var defaultFetchRequest: NSFetchRequest<Post> = {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.fetchBatchSize = 50
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        return fetchRequest
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<Post> = {
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: self.defaultFetchRequest, managedObjectContext: LocalStorage.context, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self

        do {
            try aFetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return aFetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController

        self.tableView.register(RecentTableCell.self)
        self.tableView.fillSuperview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: animated)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if PinboardAPIClient.shared.authToken == nil {
            self.performSegue(withIdentifier: "presentLogin", sender: self)
        } else {
            PinboardAPIClient.shared.getRecent({ (_) in
                
            })
        }
    }
}

extension RecentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RecentTableCell.self, for: indexPath)
        let post = self.fetchedResultsController.object(at: indexPath)

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
        cell.set(title: post.postDescription!)
        cell.set(details: post.path!)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.fetchedResultsController.object(at: indexPath)
        guard let url = URL(string: post.path!) else { return }

        let safari = SFSafariViewController(url: url)
        self.present(safari, animated: true)
    }
}

extension RecentViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}

extension RecentViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text, !searchTerm.isEmpty else {
            return
        }

//        self.searchPredicate = NSPredicate(format: "postDescription like %@", searchTerm)
    }
}
