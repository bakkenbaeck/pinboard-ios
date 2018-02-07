import UIKit

class SearchResultsUpdater: NSObject, UISearchResultsUpdating {
    private weak var delegate: NSObject?

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else {
            // tell view controller to restore contents
            return
        }


    }
}
