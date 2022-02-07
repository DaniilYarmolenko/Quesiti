//
//  Firebase.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 01.12.2021.
//

import Foundation
import Firebase

extension Auth {
    func createUser(withEmail email: String, username: String, password: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, err) in
            if let err = err {
                print("Failed to create user:", err)
                completion(err)
                return
            }
        })
    }
    
    func uploadUser(withUID uid: String, data: [String: AnyObject], completion: @escaping (() -> ())) {
        
        Database.database().reference().child("users").updateChildValues(data, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to upload user to database:", err)
                return
            }
            print(uid)
            let ref = Database.database().reference().child("users")
            ref.child(uid).updateChildValues(data)
        })
    }
}

extension Storage {
    
    func uploadUserProfileImage(currentUserId: String, image: UIImage, completion: @escaping (String) -> ()) {
        guard let uploadData = image.jpegData(compressionQuality: 0.01) else { return } //changed from 0.3
        
        let storageRef = Storage.storage().reference().child("avatars").child(currentUserId)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload profile image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for profile image:", err)
                    return
                }
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                completion(profileImageUrl)
            })
        })
    }
    
    func loadUserProfileImage(url: String, completion: @escaping(Data) -> ()){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 2*1024*1024) { data, error in
            guard let imageData = data else {return}
            completion(imageData)
        }
    }
}

extension Database {
    
    //MARK: Users
    
    func fetchUser(withUID uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            //print(userDictionary)
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (err) in
            print("Failed to fetch user from database:", err)
        }
    }
    
    func fetchAllUsers(includeCurrentUser: Bool = true, completion: @escaping ([User]) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var users = [User]()
            
            dictionaries.forEach({ (key, value) in
                if !includeCurrentUser, key == Auth.auth().currentUser?.uid {
                    completion([])
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                users.append(user)
            })
            
            users.sort(by: { (user1, user2) -> Bool in
                return user1.name.compare(user2.name) == .orderedAscending
            })
            completion(users)
            
        }) { (err) in
            print("Failed to fetch all users from database:", (err))
            cancel?(err)
        }
    }
    
    func fetchFolQuestion(withUID uid: String, completion: @escaping ([QuestionModel]) -> ()){
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            var ques = [QuestionModel]()
            let countOfUsers = dictionaries.count
            var c = 0
            
            dictionaries.forEach({ (key, value) in
                Database.database().fetchAllPostsOfUser(withUID: key) { questions, count in
                    c += 1
                    ques.append(contentsOf: questions)
                    if c == countOfUsers{
                        completion(ques)
                    }
                } withCancel: { _ in
                    print("error")
                }
            })
        })
    }
    
    func fetchMyAnswers(withUID uid: String, completion: @escaping ([QuestionModel]) -> ()){
        let ref = Database.database().reference().child("questionsAnswer").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            var ques = [QuestionModel]()
            var allQuestions = [QuestionModel]()
            Database.database().fetchAllPosts { questions in
                allQuestions = questions
                
                dictionaries.forEach { (key, value) in
                    allQuestions.forEach { q in
                        if q.id == key{
                            ques.append(q)
                        }
                    }
                }
//                print(ques.count)?\
                completion(ques)
            }
        })
    }
    
    func addQuestion(titleQuestion: String, textQuestion: String, latitude: Double, longitude: Double, radius: Int, adress: String, answerCount: Int, completion: @escaping (Error?) -> ()){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("questions").child(uid).childByAutoId()
        
        guard let postId = userPostRef.key else { return }
        
        let values = ["titleQuestion": titleQuestion, "textQuestion": textQuestion, "latitude": latitude, "longitude": longitude, "radius": radius, "adress": adress, "id": postId, "answerCount": answerCount, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        userPostRef.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save post to database", err)
                return
            }
        }
    }
    
    func fetchPost(withUID uid: String, postId: String, completion: @escaping (QuestionModel) -> (), withCancel cancel: ((Error) -> ())? = nil) {
        //        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("questions").child(uid).child(postId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let postDictionary = snapshot.value as? [String: Any] else { return }
            
            Database.database().fetchUser(withUID: uid, completion: { (user) in
                var post = QuestionModel(user: user, dictionary: postDictionary)
                post.id = postId
                completion(post)
            })
        })
    }
    
    func fetchAllPostsOfUser(withUID uid: String, completion: @escaping ([QuestionModel], _ count: Int) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("questions").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([], 0)
                return
            }
            
            var posts = [QuestionModel]()
            
            dictionaries.forEach({ (postId, value) in
                Database.database().fetchPost(withUID: uid, postId: postId, completion: { (post) in
                    posts.append(post)
                    
                    if posts.count == dictionaries.count {
                        completion(posts, posts.count)
                    }
                })
            })
        })
    }
    
    func checkCountOfSubs(withUID uid: String, completion: @escaping (String) -> ()) {
        let ref = Database.database().reference().child("followers").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion("0")
                return
            }
            
            completion(String(dictionaries.count))
        })
    }
    
    func checkCountOfFolls(withUID uid: String, completion: @escaping (String) -> ()) {
        let ref = Database.database().reference().child("following").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion("0")
                return
            }
            
            completion(String(dictionaries.count))
        })
    }
    
    func fetchAllPosts(completion: @escaping ([QuestionModel]) -> ()){
        var countOfUsers = 0
        var allPosts = [QuestionModel]()
        Database.database().fetchAllUsers(completion: { (users) in
            countOfUsers = users.count
            users.forEach { user in
                Database.database().fetchAllPostsOfUser(withUID: user.uid, completion: { (posts, count) in
                    allPosts.append(contentsOf: posts)
                    countOfUsers -= 1
                    if countOfUsers == 0{
                        completion(allPosts)
                    }
                }){ (err) in
                    print("12 ")
                }
            }
            
        }) { (_) in
            return
        }
    }
    
    
    
    func isFollowingUser(withUID uid: String, completion: @escaping (Bool) -> (), withCancel cancel: ((Error) -> ())?) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUserId).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                completion(true)
            } else {
                completion(false)
            }
            
        }) { (err) in
            print("Failed to check if following:", err)
            cancel?(err)
        }
    }
    
    func followUser(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: 1]
        Database.database().reference().child("following").child(currentLoggedInUserId).updateChildValues(values) { (err, ref) in
            if let err = err {
                completion(err)
                return
            }
            
            let values = [currentLoggedInUserId: 1]
            Database.database().reference().child("followers").child(uid).updateChildValues(values) { (err, ref) in
                if let err = err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func unfollowUser(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUserId).child(uid).removeValue { (err, _) in
            if let err = err {
                print("Failed to remove user from following:", err)
                completion(err)
                return
            }
            
            Database.database().reference().child("followers").child(uid).child(currentLoggedInUserId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to remove user from followers:", err)
                    completion(err)
                    return
                }
                completion(nil)
            })
        }
    }
    
    func deleteQuestion(withUID uid: String, postId: String) {
        Database.database().reference().child("questions").child(uid).child(postId).removeValue()
        Database.database().reference().child("answer").child(postId).removeValue()
        
        let ref = Database.database().reference().child("questionsAnswer")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                return
            }
            dictionaries.forEach { (key, value) in
                let dict = value as? [String : Any]
                dict?.forEach { (idd, _) in
                    if idd == postId{
//                        print(postId, idd)
                        Database.database().reference().child("questionsAnswer").child(key).child(postId).removeValue()
                    }
                }
            }
        })
    }
    
    //MARK: Answer
    func addAnswerToQuestion(withId questionID: String, text: String, anonimState: Bool, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["text": text, "anonimState": anonimState, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        let answerRef = Database.database().reference().child("answer").child(questionID).childByAutoId()
        answerRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to add comment:", err)
                completion(err)
                return
            }
            completion(nil)
        }
    }
    func fetchAnswerForQuestion(withId questionID: String, completion: @escaping ([Answer]) -> (), withCancel cancel: ((Error) -> ())?) {
        let answerRef = Database.database().reference().child("answer").child(questionID)
        
        answerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var answers = [Answer]()
            
            dictionaries.forEach({ (key, value) in
                guard let answerDictionary = value as? [String: Any] else { return }
                guard let uid = answerDictionary["uid"] as? String else { return }
                
                Database.database().fetchUser(withUID: uid) { (user) in
                    let answer = Answer(user: user, dictionary: answerDictionary)
                    answers.append(answer)
                    
                    if answers.count == dictionaries.count {
                        answers.sort(by: { (answer1, answer2) -> Bool in
                            return answer2.creationDate.compare(answer2.creationDate) == .orderedAscending
                        })
                        completion(answers)
                    }
                }
            })
            
        }) { (err) in
            print("Failed to fetch comments:", err)
            cancel?(err)
        }
    }
    
    
    func addQuestionUserAnswer(idQuestion: String, completion: @escaping (Error?) -> ()){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [idQuestion: 1]
        Database.database().reference().child("questionsAnswer").child(uid).updateChildValues(values) { (err, ref) in
            if let err = err {
                completion(err)
                return
            }
            
        }
    }
    //MARK: Utilities
    
    func numberOfQuestionForUser(withUID uid: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child("questions").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
    func deletePost(withUID uid: String, postId: String, completion: ((Error?) -> ())? = nil) {
        Database.database().reference().child("questions").child(uid).child(postId).removeValue { (err, _) in
            if let err = err {
                print("Failed to delete post:", err)
                completion?(err)
                return
            }
            
            Database.database().reference().child("answer").child(postId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to delete comments on post:", err)
                    completion?(err)
                    return
                }
                FirebaseDatabase.Database.database().reference(withPath: "questionsAnswer").observeSingleEvent(of: .value) { (snapshot) in
                    if let locationquest = snapshot.value as? [String:Any] {
                        for eachqueastion in locationquest {
                            if let questionValue = eachqueastion.value as? [String: Any] {
                                if let questionREM = questionValue[postId]{
                                    Database.database().reference().child("questionsAnswer").child("\(eachqueastion.key)").child("\(questionValue.keys)").removeValue(completionBlock: { (err, _) in
                                        if let err = err {
                                            print("Failed to delete comments on post:", err)
                                            completion?(err)
                                            return
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            })
        }
    }
}

