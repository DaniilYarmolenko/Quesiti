//
//  ProfileView.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import UIKit

class ProfileView: UIView {
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    var id = 1
    
    lazy var logoButton: UIButton = {
        logoButton = UIButton()
        logoButton.setImage(UIImage(named: "avatar"), for: .normal)
        
        logoButton.clipsToBounds = true
        logoButton.layer.cornerRadius = .cornerRadius/2
        logoButton.layer.borderWidth = 2
        logoButton.layer.borderColor = UIColor.lightGray.cgColor
        
        logoButton.translatesAutoresizingMaskIntoConstraints = false
        return logoButton
    }()
    
    lazy var changeInfoButton: UIButton = {
        changeInfoButton = UIButton()
        changeInfoButton.setTitle("Change info", for: .normal)
        changeInfoButton.backgroundColor = .systemBlue
        
        changeInfoButton.clipsToBounds = true
        changeInfoButton.layer.cornerRadius = 10
        
        changeInfoButton.translatesAutoresizingMaskIntoConstraints = false
        return changeInfoButton
    }()
    
    lazy var textView: UITextView = {
        textView = UITextView()
        textView.font = UIFont(name: "Kurale-Regular", size: 17)
        textView.translatesAutoresizingMaskIntoConstraints = true
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logoButton)
        for cellNames in ["Name", "Email", "Phone number", "City"]{
            createTableCell(cellNames)
        }
        self.stackView.addArrangedSubview(createAboutYou())
        scrollView.addSubview(changeInfoButton)
        setupStack()
        stackView.spacing = self.bounds.height / 200
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
        
        setupLayout()
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            logoButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            logoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoButton.heightAnchor.constraint(equalToConstant: 100),
            logoButton.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: logoButton.bottomAnchor, constant: 16),

            changeInfoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            changeInfoButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            changeInfoButton.widthAnchor.constraint(equalToConstant: 150),
            changeInfoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupShadow(){
        logoButton.layer.shadowColor = UIColor.black.cgColor
        logoButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        logoButton.layer.shadowOpacity = 0.7
        logoButton.layer.shadowRadius = 55.0
    }
    
    private func setupStack() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        scrollView.addSubview(stackView)
        self.addSubview(scrollView)
    }
    
    private func createCellLabelView(_ text: String) -> UILabel{
        
        let cellLabelView = UILabel()
        cellLabelView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cellLabelView.textColor = .darkGray
        cellLabelView.text = text
        cellLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        return cellLabelView
    }
    
    private func createTextField(_ placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.font = UIFont(name: "Kurale-Regular", size: 17)
        textField.placeholder = "Add Something"
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
    
    private func createSpacing(_ padding: CGFloat = 16) -> UIView {
        let line = UIView()
        line.backgroundColor = .white
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([line.heightAnchor.constraint(equalToConstant: padding)])
        
        return line
    }
    
    private func createAboutYou() -> UIView{
        let conteiner = UIView()
        conteiner.clipsToBounds = true
        conteiner.backgroundColor = .clear
        conteiner.layer.cornerRadius = 10
        conteiner.layer.borderWidth = 1
        conteiner.layer.borderColor = UIColor.lightGray.cgColor
        conteiner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([conteiner.heightAnchor.constraint(equalToConstant: 75)])
        
        let aboutYou = UITextView()
        self.stackView.addArrangedSubview(createCellLabelView("About you"))
        self.stackView.addArrangedSubview(createSpacing(5))
        aboutYou.font = UIFont(name: "Kurale-Regular", size: 17)
        aboutYou.textContainer.lineBreakMode = .byTruncatingTail
        conteiner.addSubview(aboutYou)
        
        aboutYou.tag = id
        id += 1
        
        aboutYou.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aboutYou.leadingAnchor.constraint(equalTo: conteiner.leadingAnchor),
            aboutYou.topAnchor.constraint(equalTo: conteiner.topAnchor),
            aboutYou.trailingAnchor.constraint(equalTo: conteiner.trailingAnchor),
            aboutYou.bottomAnchor.constraint(equalTo: conteiner.bottomAnchor),
        ])
        
        return conteiner
    }
    
    private func createTableCell(_ text: String) {
        self.stackView.addArrangedSubview(createCellLabelView(text))
        self.stackView.addArrangedSubview(createTextField(text))
        self.stackView.addArrangedSubview(createLine())
        self.stackView.addArrangedSubview(createSpacing())
    }
}

private extension CGFloat{
    static let cornerRadius = 100.0
    static let topPaddingLogo = 10.0
}
