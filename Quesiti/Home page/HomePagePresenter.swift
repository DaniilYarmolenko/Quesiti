//
//  HomePagePresenter.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import Foundation

protocol HomePageViewPresenter: AnyObject {
    init(view: HomePageViewController)
    func viewDidLoad()
    func saveData()
}

class HomePagePresenter: HomePageViewPresenter {
    
    
    private weak var view: HomePageViewController?
    
    
    required init(view: HomePageViewController) {
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func saveData() {
        
    }
}
