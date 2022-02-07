//
//  DimaSignUp.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 29.10.2021.
//

import UIKit

class DimaSignUp: UIView {
    
    let stack: UIStackView
    let scroll: UIScrollView
    let signInButtom: UIButton
    let signUpButtom: UIButton
    var id = 1
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        self.stack = UIStackView()
        self.scroll = UIScrollView()
        self.signInButtom = UIButton()
        self.signUpButtom = UIButton()
        super.init(frame: frame)
        
        for cellNames in ["Name", "Email", "Password", "Confirm password"]{
            createTableCell(cellNames)
        }
        stack.spacing = self.bounds.height / 200
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        setupTable()
        setupSignInButtom()
        setupSignUpButtom()
        
        setupLayout()
    }
    
    
    private func setupLayout(){
        let navBarHeight = CGFloat(self.safeAreaInsets.top)
        NSLayoutConstraint.activate([
            signInButtom.topAnchor.constraint(equalTo: self.topAnchor, constant: navBarHeight + 15),
            signInButtom.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            signInButtom.widthAnchor.constraint(equalToConstant: 60),
            signInButtom.heightAnchor.constraint(equalToConstant: 20),
            
            scroll.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scroll.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            scroll.topAnchor.constraint(equalTo: self.topAnchor, constant: navBarHeight + 150),
            scroll.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10),
            
            stack.topAnchor.constraint(equalTo: scroll.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scroll.widthAnchor),
            
            signUpButtom.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signUpButtom.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            signUpButtom.widthAnchor.constraint(equalToConstant: 150),
            signUpButtom.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupSignInButtom(){
        signInButtom.setTitle("Sign in", for: .normal)
        signInButtom.tintColor = .blue
        signInButtom.setTitleColor(.blue, for: .normal)
        signInButtom.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(signInButtom)
    }
    
    private func setupSignUpButtom(){
        signUpButtom.translatesAutoresizingMaskIntoConstraints = false
        signUpButtom.setTitle("Sign Up", for: .normal)
        //signUpButtom.setImage(UIImage(systemName: "search"), for: .normal)
        signUpButtom.imageView?.layer.cornerRadius = 50
        signUpButtom.backgroundColor = .blue
        signUpButtom.layer.cornerRadius = 20
        self.addSubview(signUpButtom)
    }
    
    private func setupTable() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        scroll.addSubview(stack)
        self.addSubview(scroll)
    }
    
    private func createCellLabelView(_ text: String) -> UILabel{
        
        let cellLabelView = UILabel()
        cellLabelView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        cellLabelView.textColor = .darkGray
        cellLabelView.text = text
        cellLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        return cellLabelView
    }
    
    private func createTextField(_ placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Add your " + placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = id
        id += 1
        
        return textField
    }
    
    private func createLine() -> UIView{
        let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([line.heightAnchor.constraint(equalToConstant: 0.5)])
        
        return line
    }
    
    private func createSpacing() -> UIView {
        let line = UIView()
        line.backgroundColor = .white
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([line.heightAnchor.constraint(equalToConstant: self.bounds.height/150)])
        
        return line
    }
    
    private func createTableCell(_ text: String) {
        self.stack.addArrangedSubview(createCellLabelView(text))
        self.stack.addArrangedSubview(createTextField(text))
        self.stack.addArrangedSubview(createLine())
        self.stack.addArrangedSubview(createSpacing())
    }


}
