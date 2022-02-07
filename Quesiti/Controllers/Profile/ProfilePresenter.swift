//
//  ProfilePresenter.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import Foundation

protocol ProfileViewPresenter: AnyObject {
    init(view: ProfileViewController)
    func viewDidLoad()
    func saveData()
}

class ProfilePresenter: ProfileViewPresenter {
    
    private weak var view: ProfileViewController?
    
    required init(view: ProfileViewController) {
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func saveData() {
        
    }
}
