import UIKit
import Social
import MobileCoreServices

extension NSItemProvider {
    var isURL: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeURL as String)
    }
    var isText: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeText as String)
    }
}

class ShareViewController: SLComposeServiceViewController {

    var contentURL: URL?

    override func isContentValid() -> Bool {
        let contentTypeURL = kUTTypeURL as String
        // let contentTypeText = kUTTypeText as String
        let extensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem

        for attachment in extensionItem.attachments as! [NSItemProvider] {
            if attachment.isURL {
                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
                    self.contentURL = results as? URL? ?? nil
                })
            }
        }

        return (self.contentURL != nil)
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        let apiClient = PinboardAPIClient()

        guard let urlPath = self.contentURL?.absoluteString else { return }

        apiClient.addBookmark(urlPath: urlPath, description: self.contentText)
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        super.didSelectPost()
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
