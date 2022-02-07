//
//  OtherProfileView.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 08.12.2021.
//

import UIKit

class OtherProfileView: UIView {

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
        cityLabel.textColor =  .systemGray2
        cityLabel.font = UIFont(name: "Kurale-Regular", size: 16)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return cityLabel
    }()
    
    lazy var aboutYouText: UITextView = {
        aboutYouText = UITextView()
        aboutYouText.isEditable = false
        aboutYouText.text = "No info"
        aboutYouText.font = UIFont(name: "Kurale-Regular", size: 16)
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
    
    lazy var followButton: UIButton = {
        followButton = UIButton()
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .blue
        followButton.clipsToBounds = true
        followButton.layer.cornerRadius = 8
        followButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(followButton)
        
        return followButton
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
            
            cityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            cityLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            
            questionsCount.centerXAnchor.constraint(equalTo: questionsLabel.centerXAnchor),
            questionsCount.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 8),
            
            questionsLabel.topAnchor.constraint(equalTo: questionsCount.bottomAnchor, constant: 4),
            questionsLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            
            subsCount.centerXAnchor.constraint(equalTo: subscriptionsLabel.centerXAnchor),
            subsCount.topAnchor.constraint(equalTo: questionsCount.topAnchor),
            
            subscriptionsLabel.topAnchor.constraint(equalTo: subsCount.bottomAnchor, constant: 4),
            subscriptionsLabel.leadingAnchor.constraint(equalTo: questionsLabel.trailingAnchor, constant: 8),
            
            folCount.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor),
            folCount.topAnchor.constraint(equalTo: questionsCount.topAnchor),
            
            followersLabel.topAnchor.constraint(equalTo: folCount.bottomAnchor, constant: 4),
            followersLabel.leadingAnchor.constraint(equalTo: subscriptionsLabel.trailingAnchor, constant: 8),
            
            followButton.topAnchor.constraint(equalTo: questionsLabel.bottomAnchor, constant: 16),
            followButton.leadingAnchor.constraint(equalTo: questionsLabel.leadingAnchor),
            followButton.trailingAnchor.constraint(equalTo: followersLabel.trailingAnchor),
            
            aboutYouText.leadingAnchor.constraint(equalTo: questionsLabel.leadingAnchor),
            aboutYouText.topAnchor.constraint(equalTo: followButton.bottomAnchor, constant: 8),
            aboutYouText.trailingAnchor.constraint(equalTo: followersLabel.trailingAnchor),
            aboutYouText.bottomAnchor.constraint(equalTo: cityLabel.bottomAnchor),
        ])
    }
}
