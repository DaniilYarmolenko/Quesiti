//
//  DimaSignUpViewController.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 29.10.2021.
//

import UIKit
import Firebase

class DimaSignUpViewController: UIViewController {

    var signUpView: DimaSignUp!
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutProfileView()
    }
    
    override func loadView() {
        super.loadView()
        setupSignUp()
    }
    
    private func setupSignUp() {
        signUpView = DimaSignUp(frame: self.view.frame)
        signUpView.signInButtom.addTarget(self, action: #selector(clickSignInButton(_:)), for: .touchUpInside)
        signUpView.signUpButtom.addTarget(self, action: #selector(clickSignUpButton(_:)), for: .touchUpInside)
        if let theTextFieldName = signUpView.stack.viewWithTag(1) as? UITextField{
            theTextFieldName.addTarget(self, action: #selector(changeName(_:)), for: .editingChanged)
        }
        if let theTextFieldEmail = signUpView.stack.viewWithTag(2) as? UITextField{
            theTextFieldEmail.addTarget(self, action: #selector(changeEmail(_:)), for: .editingChanged)
        }
        if let theTextFieldPassword = signUpView.stack.viewWithTag(3) as? UITextField{
            theTextFieldPassword.isSecureTextEntry = true
            theTextFieldPassword.addTarget(self, action: #selector(changePassword(_:)), for: .editingChanged)
        }
        
        if let theTextFieldConfirmPassword = signUpView.stack.viewWithTag(4) as? UITextField{
            theTextFieldConfirmPassword.isSecureTextEntry = true
            theTextFieldConfirmPassword.addTarget(self, action: #selector(changeConfirmPassword(_:)), for: .editingChanged)
        }
        
        
        view.addSubview(signUpView)
        
    }
    
    private func setupLayoutProfileView() {
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpView.topAnchor.constraint(equalTo: view.topAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
    }
    
    private func showAlert(mes: String){
        let alert = UIAlertController(title: "Error", message: mes, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertSuccess(){
        isRegistred = true
        let alert = UIAlertController(title: "Success", message: "You are registered", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            NotificationCenter.default.post(name: Notification.Name("configureTabBarItems"), object: nil)
            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func clickSignInButton(_ sender: Any) {
        let signInVC: SignInViewController = SignInViewController()
        present(signInVC, animated: true, completion: nil)
    }
    
    @objc func changeName(_ textField: UITextField){
        guard let text = textField.text else { return }
        name = text
    }
    
    @objc func changeEmail(_ textField: UITextField){
        guard let text = textField.text else { return }
        email = text
    }
    
    @objc func changePassword(_ textField: UITextField){
        guard let text = textField.text else { return }
        password = text
    }
    
    @objc func changeConfirmPassword(_ textField: UITextField){
        guard let text = textField.text else { return }
        confirmPassword = text
    }
    
    @objc func clickSignUpButton(_ sender: Any) {
        if (!name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty){
            if (password == confirmPassword){
//                print("Вы ввели" , name, email, password, confirmPassword)
                Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
                    if error != nil {
                        let responseError = error! as NSError
                        switch responseError.code{
                        case AuthErrorCode.emailAlreadyInUse.rawValue:
                            showAlert(mes: "email already exists")
                        default:
                            showAlert(mes: "\(responseError.localizedDescription)")
                        }
                        return
                    }
                    showAlertSuccess()
                    
                    if let result = result{
                        //print(result.user.uid)
                        let ref = Database.database().reference().child("users")
                        ref.child(result.user.uid).updateChildValues(["name" : name, "email" : email.lowercased()])
                    }
                }
            } else {
                showAlert(mes: "Password mismatch")
            }
        } else {
            showAlert(mes: "Set all text fields")
        }
    }
}


