
import Foundation
import UIKit
//import Cosmos
import FirebaseStorage
import VerticalAlignmentLabel

class QuestionPreviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        self.clipsToBounds=true
        self.layer.masksToBounds=true
        self.layer.cornerRadius = 20
        self.layer.shadowRadius = 10
        self.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
     
        setupViews()
    }
    func setData(title: String, img: UIImage, name: String, time: Date, countAnswer: Int) {
        lblTitle.text = title
        imgView.image = img
        lblName.text = name
        timeLabel.text = time.timeAgoDisplay()
        lblTitle.setLineHeight(lineHeight: 0.9)
        countOfComsView.text = "\(countAnswer)"
        
    }
    
    func setupViews() {
        addSubview(containerView)
        
        [imgView, lblName, timeLabel, lblTitle, comView, countOfComsView].forEach {
            containerView.addSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
        containerView.leftAnchor.constraint(equalTo: leftAnchor),
        containerView.topAnchor.constraint(equalTo: topAnchor),
        containerView.rightAnchor.constraint(equalTo: rightAnchor),
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        imgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7),
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 7),
        imgView.heightAnchor.constraint(equalToConstant: 40),
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
        
//        cointainerStars.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 2),
//        cointainerStars.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4),
//        cointainerStars.heightAnchor.constraint(equalToConstant: 10),
//        cointainerStars.rightAnchor.constraint(equalTo: imgView.rightAnchor, constant: 2),
        
        lblName.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 3),
        lblName.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 3),
        lblName.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -65),
        lblName.heightAnchor.constraint(equalToConstant: 8),
        
        timeLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5),
        timeLabel.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 6),
        timeLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 140),
        timeLabel.bottomAnchor.constraint(equalTo: lblName.bottomAnchor),
        
        lblTitle.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 5),
        lblTitle.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 2),
        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5),
        lblTitle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        
        comView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -40),
        comView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2),
        comView.heightAnchor.constraint(equalToConstant: 10),
        comView.widthAnchor.constraint(equalToConstant: 10),
        
        countOfComsView.leadingAnchor.constraint(equalTo: comView.trailingAnchor, constant: 4),
        countOfComsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2),
        countOfComsView.bottomAnchor.constraint(equalTo: comView.bottomAnchor),
        countOfComsView.heightAnchor.constraint(equalToConstant: 10)
        
        ])
    }
    
    let containerView: UIView = {
        let v=UIView()
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowRadius = 1.5
        v.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        v.layer.shadowOpacity = 0.8
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let imgView: UIImageView = {
        let v=UIImageView()
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let lblTitle: VerticalAlignmentLabel = {
        let lbl=VerticalAlignmentLabel()
        lbl.font = UIFont(name: "Kurale-Regular", size: 9)
        lbl.verticalTextAlignment = .top
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 3
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblName: UILabel = {
        let lbl=UILabel()
        
        lbl.font=UIFont.boldSystemFont(ofSize: 8)
        lbl.textColor = UIColor.systemGray
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let timeLabel: UILabel = {
        let timeLbl = UILabel()
        timeLbl.text = "18/11 7:00 p.m"
        timeLbl.font = UIFont(name: "Kurale-Regular", size: 7)
        timeLbl.textAlignment = .left
        timeLbl.textColor = ThemeColors.secondaryColor
        timeLbl.translatesAutoresizingMaskIntoConstraints=false
        return timeLbl
    }()
//    lazy var likeButton: UIButton = {
//        likeButton = UIButton()
//        likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
//        likeButton.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
//        likeButton.translatesAutoresizingMaskIntoConstraints = false
//
//        return likeButton
//    }()
//
//    private var isLike = false
    
    lazy var comView: UIImageView = {
        comView = UIImageView()
        comView.image = UIImage(systemName: "message")
        comView.translatesAutoresizingMaskIntoConstraints = false
        
        return comView
    }()
    
    lazy var countOfComsView: UILabel = {
        countOfComsView = UILabel()
        countOfComsView.text = "30"
        countOfComsView.textAlignment = .left
        countOfComsView.font = UIFont.systemFont(ofSize: 7)
        countOfComsView.textColor = .black
        countOfComsView.translatesAutoresizingMaskIntoConstraints = false
        
        return countOfComsView
    }()
    
//    lazy var countOfLike: UILabel = {
//        countOfLike = UILabel()
//        countOfLike.text = "15"
//        countOfLike.font = UIFont.systemFont(ofSize: 7)
//        countOfLike.textColor = .black
//        countOfLike.translatesAutoresizingMaskIntoConstraints = false
//
//        return countOfLike
//    }()
    //
//    lazy var cointainerStars: UIView = {
//        cointainerStars = UIView()
//
//        var starsRating = CosmosView()
//        starsRating.settings.starSize = 10.0
//        starsRating.settings.starMargin = 0
//        starsRating.rating = 4
//        starsRating.settings.updateOnTouch = false
//        starsRating.updateConstraints()
//        cointainerStars.addSubview(starsRating)
//
//        cointainerStars.translatesAutoresizingMaskIntoConstraints = false
//        return cointainerStars
//    }()
    
//
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
