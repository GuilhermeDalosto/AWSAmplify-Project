//
//  AmplifyDataStore.swift
//  CompleteiOSAWSDeveloper
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/05/21.
//

import Foundation
import Combine
import Amplify
import AWSDataStorePlugin

class AmplifyDataStore {
    
    var subscription: AnyCancellable?
    func subscribeValues() {
        self.subscription =
            Amplify.DataStore.publisher(for: Todo.self)
            .sink(receiveCompletion: { completion in
                print("Subscription has been completed: \(completion)")
            }, receiveValue: { mutationEvent in
                print("Subscription got this value: \(mutationEvent)")
                
                do {
                    let todo = try mutationEvent.decodeModel(as: Todo.self)
                    
                    switch mutationEvent.mutationType {
                    case "create":
                        print("Created: \(todo)")
                    case "update":
                        print("Updated: \(todo)")
                    case "delete":
                        print("Deleted: \(todo)")
                    default:
                        break
                    }
                    
                } catch {
                    print("Model could not be decoded: \(error)")
                }
            })
        
    }
    
    class func saveToDatastore<Object: Model>(object: Object) {
        Amplify.DataStore.save(object) { result in
            switch(result) {
            case .success(let savedModel):
                print("Saved item: \(savedModel.modelName)")
            case .failure(let error):
                print("Could not save model to Datastore: \(error)")
            }
        }
    }
    
    class func fetchFromDatastore<Object: Model>(object: Object.Type) {
        Amplify.DataStore.query(Object.self) { result in
            switch(result){
            case .success(let models):
                for model in models{
                    print("==== Model ====")
                    if let todo = model as? Todo, let priority = todo.priority {
                        print("Name: \(todo.name)")
                        print("Priority: \(priority)")
                    }
                }
            case .failure(let error):
                print("Could not fetch DataStore: \(error)")
            }
        }
    }
    
    class func fetchFromDatastoreFiltered<Object: Model>(object: Object.Type) {
        Amplify.DataStore.query(Object.self, where: Todo.keys.priority.eq(Priority.high)) { result in
            switch(result){
            case .success(let models):
                for model in models{
                    print("==== Model ====")
                    if let todo = model as? Todo, let priority = todo.priority {
                        print("Name: \(todo.name)")
                        print("Priority: \(priority)")
                    }
                }
            case .failure(let error):
                print("Could not fetch DataStore: \(error)")
            }
        }
    }
    
    class func updateInDatastore<Object: Model>(object: Object.Type) {
        Amplify.DataStore.query(Object.self, where: Todo.keys.name.eq("Think Mark.")) { result in
            
            switch(result){
            case .success(let todos):
                guard todos.count == 1 else {
                    print("Did not find exactly one todo")
                    return
                }
                
                guard var todo = todos.first as? Todo else { return }
                todo.name = "Have you"
                Amplify.DataStore.save(todo) { result in
                    switch(result){
                    case .success(let savedTodo):
                        print("Updated item: \(savedTodo.modelName)")
                    case .failure(let error):
                        print("Could not update data in Datastore: \(error)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
    
    class func deleteInDataStore<Object: Model>(object: Object.Type){
        Amplify.DataStore.query(Object.self,
                                where: Todo.keys.name.eq("File quarterly taxes")) { result in
            switch(result) {
            case .success(let todos):
                guard todos.count == 1, let toDeleteTodo = todos.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                Amplify.DataStore.delete(toDeleteTodo) { result in
                    switch(result) {
                    case .success:
                        print("Deleted item: \(toDeleteTodo.modelName)")
                    case .failure(let error):
                        print("Could not update data in DataStore: \(error)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
}
