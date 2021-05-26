//
//  ViewController.swift
//  CompleteiOSAWSDeveloper
//
//  Created by Guilherme Martins Dalosto de Oliveira on 25/05/21.
//

import UIKit
import Amplify

class ViewController: UIViewController {

    typealias database = AmplifyDataStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchItem()
        updateItem()
        fetchItem()
        
    }
    
    func saveItem() {
        let item = Todo(name: "Think Mark.", priority: .high, description: "Mandella effect")
        
        database.saveToDatastore(object: item)
    }
    
    func fetchItem() {
        database.fetchFromDatastore(object: Todo.self)
    }
    
    func updateItem() {
        database.updateInDatastore(object: Todo.self)
    }

}

