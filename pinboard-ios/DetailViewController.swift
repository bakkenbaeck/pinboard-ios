import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    func configureView() {
        // Update the user interface for the detail item.
        if let webView = self.webView, let detail = self.detailItem, let url = URL(string: detail.path) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Post? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
}
