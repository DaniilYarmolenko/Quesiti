//
//  MapPresenter.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import Foundation

protocol MapViewPresenter: AnyObject {
    init (view: MapViewController)
    func viewDidLoad()
    func saveData()
}

class MapPresenter: MapViewPresenter {
    
  
    private weak var view: MapViewController?
    
    
    required init(view: MapViewController) {
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func saveData() {
        
    }
}
