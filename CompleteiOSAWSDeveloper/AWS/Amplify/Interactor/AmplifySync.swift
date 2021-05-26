//
//  AmplifySync.swift
//  CompleteiOSAWSDeveloper
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/05/21.
//

import Amplify
import AWSCognitoIdentityProvider

class AmplifySync {
    func sync() {
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .APSoutheast2, identityPoolId: "ap-southeast-2:33abee1c-87b1-439b-b617-7aacab5a2172")
        
        let configuration = AWSServiceConfiguration(region: .APSoutheast2, credentialsProvider: credentialProvider)
        
        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
        
        let cognitoId = credentialProvider.identityId
        print("Cognito id: \(cognitoId ?? "0000")")
        
//        let syncClient = AWSCognito.default()
//        let dataset = syncClient.openOrCreateDataset("preferences")
//        
//        let existingData = dataset.getAllRecords()
//        
//        if existingData == nil {
//            dataset.setString("disabled", forKey: "sound")
//            dataset.synchronize().continueWith {(task: AWSTask!) -> AnyObject! in
//                return nil
//            }
//        } else {
//            print(existingData ?? [])
//        }
    }
}
