//
//  AmplifyStorage.swift
//  CompleteiOSAWSDeveloper
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/05/21.
//

import Foundation
import Amplify
import Combine
import AWSS3StoragePlugin

class AmplifyStorage {
    
    var resultSink: AnyCancellable?
    var progressSink: AnyCancellable?
    
    func uploadData() {
        let dataString = "Example file contents"
        let data = dataString.data(using: .utf8)!
        let storageOperation = Amplify.Storage.uploadData(key: "ExampleKey", data: data)
        
        progressSink = storageOperation
            .progressPublisher
            .sink { progress in print("Progress: \(progress)") }

        resultSink = storageOperation
            .resultPublisher
            .sink {
                if case let .failure(storageError) = $0 {
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            receiveValue: { data in
                print("Completed: \(data)")
            }
    }
    
    func uploadFile() {
        let dataString = "My Data"
        let fileNameKey = "myFile.txt"
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileNameKey)
        do {
            try dataString.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to write to file \(error)")
        }

        let storageOperation = Amplify.Storage.uploadFile(key: fileNameKey, local: filename)
        _ = storageOperation.progressPublisher.sink { progress in print("Progress: \(progress)") }
        _ = storageOperation.resultPublisher.sink {
            if case let .failure(storageError) = $0 {
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        receiveValue: { data in
            print("Completed: \(data)")
        }
    }
    
    func downloadFile() {
        let downloadToFileName = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask)[0]
            .appendingPathComponent("myFile.txt")
        let storageOperation = Amplify.Storage.downloadFile(key: "myKey", local: downloadToFileName)
        _ = storageOperation.progressPublisher.sink { progress in print("Progress: \(progress)") }
        _ = storageOperation.resultPublisher.sink {
            if case let .failure(storageError) = $0 {
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        receiveValue: {
            print("Completed")
        }
    }
    
    func listFiles() {
        _ = Amplify.Storage.list()
            .resultPublisher
            .sink {
                if case let .failure(storageError) = $0 {
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            receiveValue: { listResult in
                print("Completed")
                listResult.items.forEach { item in
                    print("Key: \(item.key)")
                }
            }
    }
    
    func removeFiles() {
        _ = Amplify.Storage.remove(key: "myKey")
            .resultPublisher
            .sink {
                if case let .failure(storageError) = $0 {
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            receiveValue: { data in
                print("Completed: Deleted \(data)")
            }
    }
}
