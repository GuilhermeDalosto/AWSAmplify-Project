//
//  AmplifyInteractor.swift
//  CompleteiOSAWSDeveloper
//
//  Created by Guilherme Martins Dalosto de Oliveira on 25/05/21.
//


import Amplify
import AWSAPIPlugin
import AWSDataStorePlugin
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import AWSPinpointAnalyticsPlugin

class AmplifyInteractor {
        
    class func configureAmplify() {
        let amplifyModels = AmplifyModels()
        let apiPlugin = AWSAPIPlugin(modelRegistration: amplifyModels)
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: amplifyModels)
        let authPlugin = AWSCognitoAuthPlugin()
        let storagePlugin = AWSS3StoragePlugin()
        let analyticsPlugin = AWSPinpointAnalyticsPlugin()
        
        do {
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: authPlugin)
            try Amplify.add(plugin: storagePlugin)
            try Amplify.add(plugin: analyticsPlugin)
            try Amplify .configure()
            print("Initialized Amplify")
        } catch {
            print("Could not initialize Amplify: \(error)")
        }
    }
    
}
