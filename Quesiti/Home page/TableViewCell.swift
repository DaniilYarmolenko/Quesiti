//
//  TableViewCell.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 14.11.2021.
//

import UIKit

class TableViewCell: UITableViewCell{
    
    private let containerView = UIView()
    
    lazy var avatarView: UIImageView = {
        avatarView = UIImageView()
        avatarView.contentMode = .scaleToFill
        avatarView.backgroundColor = .black
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 10
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        return avatarView
    }()
    
    lazy var nameLabel: UILabel = {
        nameLabel = UILabel(frame: .zero)
        nameLabel.font = UIFont(name: "SF-Pro-Rounded-Regular", size: 13)
        nameLabel.textColor = .systemGray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLabel
    }()
    
    lazy var questionLabel: UILabel = {
        questionLabel = UILabel(frame: .zero)
        questionLabel.font = UIFont(name: "Kurale-Regular", size: 18)
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return questionLabel
    }()
    
    lazy var dateLabel: UILabel = {
        dateLabel = UILabel()
        dateLabel.font = UIFont(name: "Kurale-Regular", size: 16)
        dateLabel.textColor = ThemeColors.secondaryColor
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return dateLabel
    }()
    
//    lazy var likeButton: UIButton = {
//        likeButton = UIButton()
//        likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
//        likeButton.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
//        likeButton.translatesAutoresizingMaskIntoConstraints = false
//
//        return likeButton
//    }()
    
    private var isLike = false
    
    lazy var comView: UIImageView = {
        comView = UIImageView()
        comView.image = UIImage(systemName: "message")
        comView.translatesAutoresizingMaskIntoConstraints = false
        
        return comView
    }()
    
    lazy var countOfComsView: UILabel = {
        countOfComsView = UILabel()
        countOfComsView.textColor = .black
        countOfComsView.translatesAutoresizingMaskIntoConstraints = false
        
        return countOfComsView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
            super.layoutSubviews()
        setupLayoutCell()
        let margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
                contentView.frame = contentView.frame.inset(by: margins)
    }

    private func setupLayoutCell(){
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding),
            avatarView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: .padding),
            
            questionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            questionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            comView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            comView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            comView.heightAnchor.constraint(equalToConstant: 20),
            comView.widthAnchor.constraint(equalToConstant: 20),
            
            countOfComsView.leadingAnchor.constraint(equalTo: comView.trailingAnchor, constant: 4),
            countOfComsView.bottomAnchor.constraint(equalTo: comView.bottomAnchor),
            countOfComsView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
    }
    
    private func setupContainerView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 1.5
        containerView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .white
        
        
        [avatarView, nameLabel, questionLabel, dateLabel, comView, countOfComsView].forEach {
            containerView.addSubview($0)
        }
        
        contentView.addSubview(containerView)
    }
    
//    @objc func like(_ textField: UITextField){
//        if !isLike {
//            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
//            isLike = true
//        }
//        else {
//            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
//            isLike = false
//        }
//    }
}

private extension CGFloat {
    static let padding: CGFloat = 16
}

extension String {

    func lineSpaced(_ spacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributedString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return attributedString
    }
}
