//
//  CollectionViewCell.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 17.11.2021.
//

import Foundation
import UIKit
import Cosmos

final class CollectionViewCell: UICollectionViewCell{
    
    private let containerView = UIView()
    
    lazy var avatarView: UIImageView = {
        avatarView = UIImageView()
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.borderWidth = 4
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.backgroundColor = .white
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 20
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        return avatarView
    }()
    lazy var ratingStars: CosmosView = {
        ratingStars = CosmosView()
        ratingStars.settings.starSize = 10.0
        ratingStars.settings.starMargin = 0
        ratingStars.rating = 4
        ratingStars.settings.updateOnTouch = false
        ratingStars.updateConstraints()
        return ratingStars
    }()
//    lazy var cointainerStars: UIView = {
//        cointainerStars.addSubview(ratingStars)
//        cointainerStars.translatesAutoresizingMaskIntoConstraints = false
//        return cointainerStars
//    }()
    
    lazy var nameLabel: UILabel = {
        nameLabel = UILabel(frame: .zero)
        nameLabel.font = UIFont(name: "SF-Pro-Rounded-Regular", size: 16)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLabel
    }()
    
    lazy var cityLabel: UILabel = {
        cityLabel = UILabel(frame: .zero)
        cityLabel.font = UIFont(name: "Kurale-Regular", size: 14)
        cityLabel.textAlignment = .center
        cityLabel.textColor = .systemGray
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return cityLabel
    }()
    
//    lazy var starsView: UIImageView = {
//        starsView = UIImageView(image: UIImage(named: "stars"))
//        starsView.translatesAutoresizingMaskIntoConstraints = false
//
//        return starsView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
    }
    
    override func layoutSubviews() {
        setupLayoutCell()
    }
    
    private func setupLayoutCell(){
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarView.topAnchor.constraint(equalTo: containerView.topAnchor),
            avatarView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            avatarView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50),
            
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 4),
            
            cityLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            
//            cointainerStars.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
//            cointainerStars.heightAnchor.constraint(equalToConstant: 15),
//            cointainerStars.leadingAnchor.constraint(equalTo: containerView.centerXAnchor),
//            cointainerStars.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
        ])
    }
    
    private func setupContainerView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .white
        
        
        [avatarView, nameLabel, cityLabel].forEach {
            containerView.addSubview($0)
        }
        
        contentView.addSubview(containerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
