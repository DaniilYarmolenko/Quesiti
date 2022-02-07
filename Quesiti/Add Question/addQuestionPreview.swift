//
//  addQuestionPreview.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 13.11.2021.
//

import UIKit

class AddQuestionPreviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        setupViews()
    }
    
    func setData(radius: String, adress: String) {
        lbRadius.text = "radius question = \(radius) m"
        lbAdress.text = adress
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.addSubview(lbAdress)
        containerView.addSubview(lbRadius)
        
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lbAdress.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            lbAdress.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            lbAdress.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
            lbAdress.heightAnchor.constraint(equalToConstant: 50),
            
            lbRadius.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 2),
            lbRadius.topAnchor.constraint(equalTo: lbAdress.bottomAnchor, constant: 0),
            lbRadius.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
            lbRadius.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
    }
    
    let containerView: UIView = {
        let v=UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    
    let lbRadius: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font=UIFont.boldSystemFont(ofSize: 10)
        lbl.textColor = UIColor.black
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let lbAdress: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font=UIFont.boldSystemFont(ofSize: 10)
        lbl.textColor = UIColor.black
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

