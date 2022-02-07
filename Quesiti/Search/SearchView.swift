//
//  SearchView.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 13.11.2021.
//

import UIKit

class SearchView: UIView {
    
    lazy var conteinerView: UIView = {
        conteinerView = UIView()
        conteinerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //conteinerView.clipsToBounds = true
        conteinerView.layer.cornerRadius = 25
        conteinerView.layer.shadowColor = UIColor.black.cgColor
        conteinerView.layer.shadowRadius = 5
        conteinerView.layer.shadowOffset = .init(width: -3, height: 3)
        conteinerView.layer.shadowOpacity = 0.4
        conteinerView.translatesAutoresizingMaskIntoConstraints = false
        
        return conteinerView
    }()
    
    lazy var textField: UITextField = {
        textField = UITextField()
        textField.placeholder = "Start your question..."
        textField.font = UIFont(name: "Kurale-Regular", size: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var clearButton: UIButton = {
        clearButton = UIButton()
        clearButton.setImage(UIImage(systemName: "clear"), for: .normal)
        
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        return clearButton
    }()
    
    lazy var questionButton: UIButton = {
        questionButton = UIButton()
        questionButton.setTitle("Questions", for: .normal)
        questionButton.setTitleColor(.black, for: .normal)
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        questionButton.addTarget(self, action: #selector(clickQuestionButton(_:)), for: .touchUpInside)
        self.addSubview(questionButton)
        
        return questionButton
    }()
    
    lazy var peopleButton: UIButton = {
        peopleButton = UIButton()
        peopleButton.setTitle("People", for: .normal)
        peopleButton.setTitleColor(.gray, for: .normal)
        peopleButton.addTarget(self, action: #selector(clickPeopleButton(_:)), for: .touchUpInside)
        peopleButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(peopleButton)
        
        return peopleButton
    }()
    
    lazy var questionLine: UIView = {
        questionLine = UIView()
        questionLine.backgroundColor = .blue
        questionLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(questionLine)
        
        return questionLine
    }()
    
    lazy var peopleLine: UIView = {
        peopleLine = UIView()
        peopleLine.backgroundColor = .white
        peopleLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(peopleLine)
        
        return peopleLine
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(conteinerView)
        conteinerView.addSubview(clearButton)
        conteinerView.addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            conteinerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            conteinerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            conteinerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            conteinerView.heightAnchor.constraint(equalToConstant: 50),
            
            clearButton.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -16),
            //clearButton.topAnchor.constraint(equalTo: conteinerView.topAnchor),
            //clearButton.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor),
            clearButton.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor),
            clearButton.leadingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -42),
            
            textField.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -8),
            textField.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: -5),
            
            questionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 75),
            questionButton.topAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: 25),
            
            questionLine.centerXAnchor.constraint(equalTo: questionButton.centerXAnchor),
            questionLine.topAnchor.constraint(equalTo: questionButton.bottomAnchor, constant: 8),
            questionLine.heightAnchor.constraint(equalToConstant: 1),
            questionLine.widthAnchor.constraint(equalToConstant: 50),
            
            peopleButton.leadingAnchor.constraint(equalTo: questionButton.trailingAnchor, constant: 115),
            peopleButton.topAnchor.constraint(equalTo: questionButton.topAnchor),
            
            peopleLine.centerXAnchor.constraint(equalTo: peopleButton.centerXAnchor),
            peopleLine.topAnchor.constraint(equalTo: peopleButton.bottomAnchor, constant: 8),
            peopleLine.heightAnchor.constraint(equalToConstant: 1),
            peopleLine.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
     
    @objc func clickQuestionButton(_: Any){
        questionButton.setTitleColor(.black, for: .normal)
        questionLine.backgroundColor = .blue
        peopleButton.setTitleColor(.gray, for: .normal)
        peopleLine.backgroundColor = .white
    }
    
    @objc func clickPeopleButton(_: Any){
        peopleButton.setTitleColor(.black, for: .normal)
        peopleLine.backgroundColor = .blue
        questionButton.setTitleColor(.gray, for: .normal)
        questionLine.backgroundColor = .white
    }
}
