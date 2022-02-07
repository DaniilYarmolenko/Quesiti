//
//  ProfileViewController.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import UIKit
import Firebase

protocol LogOutDelegate{
    func logOut()
}

class ProfileViewController: UIViewController {
    var presenter: ProfileViewPresenter!
    
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var city: String = ""
    var aboutYou: String = ""
    var delegate: LogOutDelegate?
    //var url: String = ""
    
    var user: User? {
        didSet {
            setupProfileView()
        }
    }
    
    
    lazy var profileView: ProfileView = {
        let profileView = ProfileView()
        
        return profileView
    }()
    lazy var btnAddQuestion: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        btn.backgroundColor = ThemeColors.mainColor
        btn.setImage(UIImage(systemName: "plus.circle", withConfiguration: config), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.white
        btn.imageView?.sizeToFit()
        btn.addTarget(self, action: #selector(btnAddQuestionAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var logOutButton: UIButton = {
        logOutButton = UIButton()
        logOutButton.backgroundColor = .clear
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        logOutButton.backgroundColor = ThemeColors.mainColor
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.layer.cornerRadius = 8
        logOutButton.clipsToBounds=true
        logOutButton.addTarget(self, action: #selector(clickLogOutButton), for: .touchUpInside)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        
        return logOutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileView)
        view.addSubview(btnAddQuestion)
        navigationController?.navigationBar.isHidden = true
        
        setupLayoutProfileView()
        setupProfileView()
        registerForKeyboardNotification()
    }
    
    deinit{
        removeForKeyboardNotification()
    }
    
    private func setupProfileView(){
        if let url = user?.avatarURL{
            if url != "" {
                Storage.storage().loadUserProfileImage(url: url, completion: {(imageData) in
                    let image = UIImage(data: imageData)
                    self.profileView.logoButton.setImage(image, for: .normal)
                })
            }
        }
        
        if let theTextFieldName = profileView.stackView.viewWithTag(1) as? UITextField{
            theTextFieldName.text = user?.name
            name = user?.name ?? ""
            theTextFieldName.addTarget(self, action: #selector(changeName(_:)), for: .editingChanged)
        }
        
        if let theTextFieldEmail = profileView.stackView.viewWithTag(2) as? UITextField{
            theTextFieldEmail.text = user?.email
            email = user?.email ?? ""
            theTextFieldEmail.addTarget(self, action: #selector(changeEmail(_:)), for: .editingChanged)
        }
        if let theTextFieldPhoneNumber = profileView.stackView.viewWithTag(3) as? UITextField{
            theTextFieldPhoneNumber.text = user?.phoneNumber
            phoneNumber = user?.phoneNumber ?? ""
            theTextFieldPhoneNumber.addTarget(self, action: #selector(changePhoneNumber(_:)), for: .editingChanged)
        }
        
        if let theTextFieldCity = profileView.stackView.viewWithTag(4) as? UITextField{
            theTextFieldCity.text = user?.city
            city = user?.city ?? ""
            theTextFieldCity.addTarget(self, action: #selector(changeCity(_:)), for: .editingChanged)
        }
        
        if let theTextFieldAboutYou = profileView.stackView.viewWithTag(5) as? UITextView{
            theTextFieldAboutYou.text = user?.aboutYou
            aboutYou = user?.aboutYou ?? ""
            theTextFieldAboutYou.delegate = self
            
//            theTextFieldAboutYou.addTarget(self, action: #selector(changeAboutYou(_:)), for: .editingChanged)
        }
        
        profileView.changeInfoButton.addTarget(self, action: #selector(changeInfo(_:)), for: .touchUpInside)
        profileView.logoButton.addTarget(self, action: #selector(clickPhotoButton(_:)), for: .touchUpInside)
    }
    
    private func setupLayoutProfileView(){
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            btnAddQuestion.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            btnAddQuestion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAddQuestion.widthAnchor.constraint(equalToConstant: 50),
            btnAddQuestion.heightAnchor.constraint(equalTo: btnAddQuestion.widthAnchor),
            
            logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            logOutButton.widthAnchor.constraint(equalToConstant: 80),
            logOutButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    @objc func changeName(_ textField: UITextField){
        guard let text = textField.text else { return }
        name = text
    }
    
    @objc func changeEmail(_ textField: UITextField){
        guard let text = textField.text else { return }
        email = text
    }
    
    @objc func changePhoneNumber(_ textField: UITextField){
        guard let text = textField.text else { return }
        phoneNumber = text
    }
    
    @objc func changeCity(_ textField: UITextField){
        guard let text = textField.text else { return }
        city = text
    }
    
//    @objc func changeAboutYou(_ textField: UITextField){
//        guard let text = textField.text else { return }
//        aboutYou = text
//    }
    
    @objc func changeInfo(_ sender: Any) {
        
        guard let id = self.user?.uid else {return}
        
        
        
        Storage.storage().uploadUserProfileImage(currentUserId: id, image: profileView.logoButton.imageView?.image ?? UIImage(), completion: {(profileImageUrl) in
            let changeInfoList = ["name": self.name, "email": self.email.lowercased(), "phoneNumber": self.phoneNumber, "city": self.city, "aboutYou": self.aboutYou, "avatarURL": profileImageUrl]
            let ref = Database.database().reference().child("users")
            ref.child(id).updateChildValues(changeInfoList)
        })
        let alert = UIAlertController(title: "Success", message: "Info updated successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func clickPhotoButton(_ sender: Any){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func btnAddQuestionAction() {
        let addQuuestion: AddQuestionViewController = AddQuestionViewController()
        addQuuestion.modalPresentationStyle = .fullScreen
        self.present(addQuuestion, animated: true, completion: nil)
    }
    
    @objc func clickLogOutButton() {
        do{
            try Auth.auth().signOut()
            self.delegate?.logOut()
        } catch {
            print(error)
        }
    }
    
    private func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeForKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let scrolSize = self.profileView.changeInfoButton.frame.maxY + keyboardSize.height - self.view.bounds.maxY + 8 + self.view.safeAreaInsets.top
        profileView.scrollView.contentSize = CGSize(width: profileView.bounds.width, height: profileView.bounds.height + scrolSize)
        profileView.scrollView.contentOffset = CGPoint(x: 0, y: scrolSize)
        profileView.scrollView.isScrollEnabled = true
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        profileView.scrollView.contentSize = CGSize(width: profileView.bounds.width, height: profileView.bounds.height - keyboardSize.height)
        profileView.scrollView.isScrollEnabled = false
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        profileView.logoButton.setImage(image, for: .normal)
    }
}

extension ProfileViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        aboutYou = text
    }
}
