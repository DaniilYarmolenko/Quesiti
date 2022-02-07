//
//  SignInView.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 29.10.2021.
//

import UIKit

class SignInView: UIView {
    let stack: UIStackView
    let scroll: UIScrollView
    let signInButtom: UIButton
    var id = 1
    
    lazy var logoImage: UIImageView = {
        logoImage = UIImageView(image: UIImage(named: "Logo"))
        
        return logoImage
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        self.stack = UIStackView()
        self.scroll = UIScrollView()
        signInButtom = UIButton()
        super.init(frame: frame)
        
        for cellNames in ["Email", "Password"]{
            createTableCell(cellNames)
        }
        stack.spacing = self.bounds.height / 200
        self.backgroundColor = .white
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupImage()
        setupTable()
        setupSignInButtom()
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        let navBarHeight = CGFloat(self.safeAreaInsets.top)
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: self.topAnchor, constant: navBarHeight + 70),
            
            scroll.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 50),
            scroll.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scroll.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            scroll.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: scroll.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scroll.widthAnchor),
            
            signInButtom.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButtom.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 10),
            signInButtom.widthAnchor.constraint(equalToConstant: 150),
            signInButtom.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    
    
    private func setupImage() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.clipsToBounds = true
        logoImage.layer.cornerRadius = 5
        
        self.addSubview(logoImage)
    }
    
    private func setupTable() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        scroll.addSubview(stack)
        self.addSubview(scroll)
    }
    
    private func setupSignInButtom(){
        signInButtom.translatesAutoresizingMaskIntoConstraints = false
        signInButtom.setTitle("Sign In", for: .normal)
        //signUpButtom.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        signInButtom.imageView?.layer.cornerRadius = 50
        signInButtom.backgroundColor = .blue
        signInButtom.layer.cornerRadius = 20
        self.addSubview(signInButtom)
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

