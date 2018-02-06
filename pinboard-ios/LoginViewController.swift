import SweetUIKit
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginButton.layer.cornerRadius = 12
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loginTextField.becomeFirstResponder()
    }


    @IBAction func attemptLogin(_ sender: UIButton) {
        guard let username = self.loginTextField.text, let password = self.passwordTextField.text else { return }

        PinboardAPIClient.shared.getAPIToken(username: username, password: password) { token in
            if let token = token {
                PinboardAPIClient.shared.authToken = token
                self.dismiss(animated: true)
            } else {
                self.alertLoginFailure()
            }
        }
    }

    private func alertLoginFailure() {
        let alert = UIAlertController.dismissableAlert(title: "Could not login", message: "Ensure username and password are correct.")
        self.present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginTextField {
            self.passwordTextField.becomeFirstResponder()
        }

        if textField == self.passwordTextField {
            self.attemptLogin(self.loginButton)
        }

        return true
    }
}
