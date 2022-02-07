//
//  UserModel.swift
//  MapDemo
//
//  Created by Даниил Ярмоленко on 08.11.2021.
//

import Foundation
import Firebase

struct User {
    let uid: String
    //let profileImageUrl: String
    let name: String
    let email: String
    let phoneNumber: String
    let city: String
    let aboutYou: String
    let avatarURL: String?
    let followerCount: Int
    let followingCount: Int
    
        
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    // we get back a dictionary from Firebase, so this init method is how we are
    // going to construct our user without having to manually pass in all the data
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        //self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.aboutYou = dictionary["aboutYou"] as? String ?? ""
        self.avatarURL = dictionary["avatarURL"] as? String ?? ""
        self.followerCount = dictionary["followerCount"] as? Int ?? 0
        self.followingCount = dictionary["followingCount"] as? Int ?? 0
        
        // Default stats (0,0,0) that get set properly after the API Call
    }
}
