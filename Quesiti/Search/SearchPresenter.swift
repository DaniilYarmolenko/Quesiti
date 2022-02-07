//
//  SearchPresenter.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 13.11.2021.
//


import Foundation

protocol SearchViewPresenter: AnyObject {
    init(view: SearchViewController)
    func viewDidLoad()
    func saveData()
}

class SearchPresenter: SearchViewPresenter {
    
    
    private weak var view: SearchViewController?
    
    required init(view: SearchViewController) {
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func saveData() {
        
    }
}
