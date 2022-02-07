//
//  ModelMap.swift
//  MapDemo
//
//  Created by Даниил Ярмоленко on 08.11.2021.
//

import UIKit


struct QuestionModel {
    let user: User
    var id: String
    let titleQuestion: String
    let textQuestion: String
    //var id: String
    var latitude: Double
    var longitude: Double
    var radius: Int
    var adress: String
    var imageString: String
    var answerCount: Int
    var creationDate: Date
    var anonimState: Bool
    //var name: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.id = dictionary["id"] as? String ?? ""
        self.titleQuestion = dictionary["titleQuestion"] as? String ?? ""
        self.textQuestion = dictionary["textQuestion"] as? String ?? ""
        self.answerCount = dictionary["answerCount"] as? Int ?? 0
                //self.id = dictionary["id"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0
        self.longitude = dictionary["longitude"] as? Double ?? 0
        self.radius = dictionary["radius"] as? Int ?? 0
        self.adress = dictionary["adress"] as? String ?? ""
        self.imageString = dictionary["imageString"] as? String ?? ""
        self.anonimState = dictionary["anonimState"] as? Bool ?? false
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0

        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
