//
//  CustomMarkerView.swift
//  googlMapTutuorial2
//
//  Created by Muskan on 12/17/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class CustomMarkerView: UIView {
    var imageConst = UIImage(named: "avatar")
    var borderColor: UIColor = .black
    var keyQuestion: String!
    var keyID: String!
    var radius: Int = 200
    
    init(frame: CGRect, image: String, borderColor: UIColor, keyQuestion: String, keyID: String, radius: Int, tag: Int) {
        super.init(frame: frame)
        self.setupViews()
        self.tag = tag
        self.imgView.image = imageConst
        if image != "" {
            Storage.storage().loadUserProfileImage(url: image, completion: {(imageData) in

                
                self.imgView.image = UIImage(data: imageData)
                self.imageConst = UIImage(data: imageData)
                self.imgView.layer.borderColor = self.borderColor.cgColor
//  
            })
        }
    self.borderColor=borderColor
    self.keyID = keyID
    self.keyQuestion = keyQuestion
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
//        }
}

func setupViews() {
    self.addSubview(imgView)
}
    let imgView: UIImageView = {
        let img = UIImageView()
        img.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        img.layer.cornerRadius = 25
        img.layer.borderWidth = 4
        img.clipsToBounds = true
        return img
    }()

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}









