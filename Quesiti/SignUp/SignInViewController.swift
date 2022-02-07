//
//  DimaSignUpViewController.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 29.10.2021.
//

import UIKit
import Firebase

protocol DismissDelegate{
    func dissmisSignIn()
    func dissmisSignUp()
}

class SignInViewController: UIViewController {

    var signInView: SignInView!
    private var email: String = ""
    private var password: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayoutProfileView()
    }
    
    override func loadView() {
        super.loadView()
        setupSignIn()
    }
    
    
    private func setupSignIn(){
        signInView = SignInView(frame: self.view.frame)
        if let theTextFieldLogin = signInView.stack.viewWithTag(1) as? UITextField{
            theTextFieldLogin.addTarget(self, action: #selector(changeLogin(_:)), for: .editingChanged)
        }
        if let theTextFieldPassword = signInView.stack.viewWithTag(2) as? UITextField{
            theTextFieldPassword.isSecureTextEntry = true
            theTextFieldPassword.addTarget(self, action: #selector(changePassword(_:)), for: .editingChanged)
        }
        signInView.signInButtom.addTarget(self, action: #selector(clickSignInButtom(_:)), for: .touchUpInside)
        view.addSubview(signInView)
    }
    
    private func setupLayoutProfileView() {
        signInView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signInView.topAnchor.constraint(equalTo: view.topAnchor),
            signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
    }
    
    private func showAlert(mes: String){
        let alert = UIAlertController(title: "Error", message: mes, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func changeLogin(_ textField: UITextField){
        guard let text = textField.text else { return }
        email = text
    }
    
    @objc func changePassword(_ textField: UITextField){
        guard let text = textField.text else { return }
        password = text
    }
    @objc func clickSignInButtom(_ textField: UITextField){
        Auth.auth().signIn(withEmail: email.lowercased(), password: password) { result, error in
            if let err = error {
                self.showAlert(mes: err.localizedDescription)
                return
            }
            
            if let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController {
                //mainTabBarController.configureTabBarItems()
                //mainTabBarController.selectedIndex = 0
                NotificationCenter.default.post(name: Notification.Name("configureTabBarItems"), object: nil)
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
}
