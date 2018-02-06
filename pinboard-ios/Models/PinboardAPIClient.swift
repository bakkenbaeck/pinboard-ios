import Foundation
import Teapot

class PinboardAPIClient {
    private let baseURL = URL(string: "https://api.pinboard.in")!

    private lazy var teapot: Teapot = {
        Teapot(baseURL: self.baseURL)
    }()

    let shared = PinboardAPIClient()

    func getAPIToken() {
        self.teapot.get("/v1/user/api_token/") { result in
            print(result)
        }
    }

    func recent() {
        self.teapot.get("/v1/posts/recent?format=json") { result in
            print(result)
        }
    }
}
