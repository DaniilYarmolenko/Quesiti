//
//  AnswerModel.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 22.11.2021.
//

import Foundation
import UIKit

struct Answer {
    
    let user: User
    let text: String
    let creationDate: Date
    let uid: String
    let anonimState: Bool
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0

        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.uid = dictionary["uid"] as? String ?? ""
        self.anonimState = dictionary["anonimState"] as? Bool ?? false
        
    }
}
