//
//  HomePageView.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import UIKit

let user = [1: "avatar", 2: "Alex" ,3: "Moscow"]

class HomePageView: UIView {
    
    lazy var avatarView: UIImageView = {
        avatarView = UIImageView()
        avatarView.backgroundColor = .white
        avatarView.image = UIImage(named: user[1] ?? "")
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 20
        avatarView.contentMode = .scaleToFill
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        return avatarView
    }()
    
    lazy var nameLabel: UILabel = {
        nameLabel = UILabel()
        nameLabel.text = user[2] ?? ""
        nameLabel.textColor = .black
        nameLabel.font = UIFont(name: "SF-Pro-Rounded-Regular", size: 25)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLabel
    }()
    
    lazy var cityLabel: UILabel = {
        cityLabel = UILabel()
        cityLabel.text = user[3] ?? ""
        cityLabel.textColor = .systemGray2
        cityLabel.font = UIFont(name: "Kurale-Regular", size: 16)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return cityLabel
    }()
    
    lazy var aboutYouText: UITextView = {
        aboutYouText = UITextView()
        aboutYouText.text = "About you..."
        aboutYouText.font = UIFont(name: "Kurale-Regular", size: 16)
        aboutYouText.textAlignment = .center
        aboutYouText.textContainer.maximumNumberOfLines = 0
        aboutYouText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(aboutYouText)
        
        return aboutYouText
    }()
    
    lazy var questionsCount: UILabel = {
        questionsCount = UILabel()
        questionsCount.text = "-"
        questionsCount.textColor = .black
        questionsCount.font = UIFont.boldSystemFont(ofSize: 24)
        questionsCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(questionsCount)
        
        return questionsCount
    }()
    
    lazy var subsCount: UILabel = {
        subsCount = UILabel()
        subsCount.text = "-"
        subsCount.textColor = .black
        subsCount.font = UIFont.boldSystemFont(ofSize: 24)
        subsCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subsCount)
        
        return subsCount
    }()
    
    lazy var folCount: UILabel = {
        folCount = UILabel()
        folCount.text = "-"
        folCount.textColor = .black
        folCount.font = UIFont.boldSystemFont(ofSize: 24)
        folCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(folCount)
        
        return folCount
    }()
    
    lazy var questionsLabel: UILabel = {
        questionsLabel = UILabel()
        questionsLabel.text = "Questions"
        questionsLabel.textColor = .gray
        questionsLabel.font = UIFont.systemFont(ofSize: 12)
        questionsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(questionsLabel)
        
        return questionsLabel
    }()
    
    lazy var subscriptionsLabel: UILabel = {
        subscriptionsLabel = UILabel()
        subscriptionsLabel.text = "Subscriptions"
        subscriptionsLabel.textColor = .gray
        subscriptionsLabel.font = UIFont.systemFont(ofSize: 12)
        subscriptionsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subscriptionsLabel)
        
        return subscriptionsLabel
    }()
    
    lazy var followersLabel: UILabel = {
        followersLabel = UILabel()
        followersLabel.text = "Followers"
        followersLabel.textColor = .gray
        followersLabel.font = UIFont.systemFont(ofSize: 12)
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(followersLabel)
        
        return followersLabel
    }()
    
    
    lazy var myQuestionsButton: UIButton = {
        myQuestionsButton = UIButton()
        myQuestionsButton.setTitle("My questions", for: .normal)
        myQuestionsButton.setTitleColor(.black, for: .normal)
        myQuestionsButton.addTarget(self, action: #selector(clickMyQuestionsButton(_:)), for: .touchUpInside)
        myQuestionsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(myQuestionsButton)
        
        return myQuestionsButton
    }()
    
    lazy var folowingQuestionsButton: UIButton = {
        folowingQuestionsButton = UIButton()
        folowingQuestionsButton.setTitle("Folloving", for: .normal)
        folowingQuestionsButton.setTitleColor(.systemGray4, for: .normal)
        folowingQuestionsButton.addTarget(self, action: #selector(clickFolowingQuestionsButton(_:)), for: .touchUpInside)
        folowingQuestionsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(folowingQuestionsButton)
        
        return folowingQuestionsButton
    }()
    
    lazy var answerQuestionsButton: UIButton = {
        answerQuestionsButton = UIButton()
        answerQuestionsButton.setTitle("My answers", for: .normal)
        answerQuestionsButton.setTitleColor(.systemGray4, for: .normal)
        answerQuestionsButton.addTarget(self, action: #selector(answerQuestionsButton(_:)), for: .touchUpInside)
        answerQuestionsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answerQuestionsButton)
        
        return answerQuestionsButton
    }()
    
    lazy var myQuestionsLine: UIView = {
        myQuestionsLine = UIView()
        myQuestionsLine.backgroundColor = .blue
        myQuestionsLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(myQuestionsLine)
        
        return myQuestionsLine
    }()
    
    lazy var folowingQuestionsLine: UIView = {
        folowingQuestionsLine = UIView()
        folowingQuestionsLine.backgroundColor = .white
        folowingQuestionsLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(folowingQuestionsLine)
        
        return folowingQuestionsLine
    }()
    
    lazy var answerQuestionsLine: UIView = {
        answerQuestionsLine = UIView()
        answerQuestionsLine.backgroundColor = .white
        answerQuestionsLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answerQuestionsLine)
        
        return answerQuestionsLine
    }()
    
    lazy var lineView: UIView = {
        lineView = UIView()
        lineView.backgroundColor = .systemBlue
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        return lineView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        self.addSubview(cityLabel)
//        self.addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupLayout()
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            avatarView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarView.heightAnchor.constraint(equalToConstant: 150),
            avatarView.widthAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            cityLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            
            questionsCount.centerXAnchor.constraint(equalTo: questionsLabel.centerXAnchor),
            questionsCount.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 24),
            
            questionsLabel.topAnchor.constraint(equalTo: questionsCount.bottomAnchor, constant: 4),
            questionsLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 4),
            
            subsCount.centerXAnchor.constraint(equalTo: subscriptionsLabel.centerXAnchor),
            subsCount.topAnchor.constraint(equalTo: questionsCount.topAnchor),
            
            subscriptionsLabel.topAnchor.constraint(equalTo: subsCount.bottomAnchor, constant: 4),
            subscriptionsLabel.leadingAnchor.constraint(equalTo: questionsLabel.trailingAnchor, constant: 4),
            
            folCount.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor),
            folCount.topAnchor.constraint(equalTo: questionsCount.topAnchor),
            
            followersLabel.topAnchor.constraint(equalTo: folCount.bottomAnchor, constant: 4),
            followersLabel.leadingAnchor.constraint(equalTo: subscriptionsLabel.trailingAnchor, constant: 4),
            
            folowingQuestionsButton.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            folowingQuestionsButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            folowingQuestionsLine.centerXAnchor.constraint(equalTo: folowingQuestionsButton.centerXAnchor),
            folowingQuestionsLine.topAnchor.constraint(equalTo: folowingQuestionsButton.bottomAnchor, constant: 8),
            folowingQuestionsLine.heightAnchor.constraint(equalToConstant: 1),
            folowingQuestionsLine.widthAnchor.constraint(equalToConstant: 50),
            
            myQuestionsButton.topAnchor.constraint(equalTo: folowingQuestionsButton.topAnchor),
            myQuestionsButton.trailingAnchor.constraint(equalTo: folowingQuestionsButton.leadingAnchor, constant: -25),
            
            myQuestionsLine.centerXAnchor.constraint(equalTo: myQuestionsButton.centerXAnchor),
            myQuestionsLine.topAnchor.constraint(equalTo: myQuestionsButton.bottomAnchor, constant: 8),
            myQuestionsLine.heightAnchor.constraint(equalToConstant: 1),
            myQuestionsLine.widthAnchor.constraint(equalToConstant: 50),
            
            answerQuestionsButton.topAnchor.constraint(equalTo: folowingQuestionsButton.topAnchor),
            answerQuestionsButton.leadingAnchor.constraint(equalTo: folowingQuestionsButton.trailingAnchor, constant: 25),
            
            answerQuestionsLine.centerXAnchor.constraint(equalTo: answerQuestionsButton.centerXAnchor),
            answerQuestionsLine.topAnchor.constraint(equalTo: answerQuestionsButton.bottomAnchor, constant: 8),
            answerQuestionsLine.heightAnchor.constraint(equalToConstant: 1),
            answerQuestionsLine.widthAnchor.constraint(equalToConstant: 50),
            
            aboutYouText.leadingAnchor.constraint(equalTo: questionsLabel.leadingAnchor),
            aboutYouText.topAnchor.constraint(equalTo: subscriptionsLabel.bottomAnchor, constant: 2),
            aboutYouText.trailingAnchor.constraint(equalTo: followersLabel.trailingAnchor),
            aboutYouText.bottomAnchor.constraint(equalTo: cityLabel.bottomAnchor),
        ])
    }
    @objc func clickMyQuestionsButton(_: Any){
        myQuestionsButton.setTitleColor(.black, for: .normal)
        myQuestionsLine.backgroundColor = .blue
        folowingQuestionsButton.setTitleColor(.systemGray4, for: .normal)
        folowingQuestionsLine.backgroundColor = .white
        answerQuestionsButton.setTitleColor(.systemGray4, for: .normal)
        answerQuestionsLine.backgroundColor = .white
    }
    
    @objc func clickFolowingQuestionsButton(_: Any){
        myQuestionsButton.setTitleColor(.systemGray4, for: .normal)
        myQuestionsLine.backgroundColor = .white
        folowingQuestionsButton.setTitleColor(.black, for: .normal)
        folowingQuestionsLine.backgroundColor = .blue
        answerQuestionsButton.setTitleColor(.systemGray4, for: .normal)
        answerQuestionsLine.backgroundColor = .white
    }
    
    @objc func answerQuestionsButton(_: Any){
        myQuestionsButton.setTitleColor(.systemGray4, for: .normal)
        myQuestionsLine.backgroundColor = .white
        folowingQuestionsButton.setTitleColor(.systemGray4, for: .normal)
        folowingQuestionsLine.backgroundColor = .white
        answerQuestionsButton.setTitleColor(.black, for: .normal)
        answerQuestionsLine.backgroundColor = .blue
    }
}
