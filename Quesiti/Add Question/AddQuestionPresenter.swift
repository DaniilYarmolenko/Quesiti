//
//  AddQuestionPresenter.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import Foundation

protocol AddQuestionViewPresenter: AnyObject {
    init(view: AddQuestionViewController)
    func viewDidLoad()
    func saveData()
}

class AddQuestionPresenter: AddQuestionViewPresenter {
    
    private weak var view: AddQuestionViewController?
    
    required init(view: AddQuestionViewController) {
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func saveData() {
        
    }
}
