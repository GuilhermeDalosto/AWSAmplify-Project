//
//  AmplifyAnalytics.swift
//  CompleteiOSAWSDeveloper
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/05/21.
//

import Foundation
import Amplify
import AWSPinpoint
import AWSPinpointAnalyticsPlugin

class AmplifyAnalytics {
    let properties: AnalyticsProperties = ["globalPropertyKey": "value"]
    
    init(){
        Amplify.Analytics.registerGlobalProperties(properties)
    }
    
    deinit {
        Amplify.Analytics.unregisterGlobalProperties()
        // OR
        Amplify.Analytics.unregisterGlobalProperties(["globalPropertyKey"])
    }
    
    func enable() {
        Amplify.Analytics.enable()
    }
    
    func disable(){
        Amplify.Analytics.disable()
    }
    
    func recordEvents() {
        let properties: AnalyticsProperties = [
            "eventPropertyStringKey": "eventPropertyStringValue",
            "eventPropertyIntKey": 123,
            "eventPropertyDoubleKey": 12.34,
            "eventPropertyBoolKey": true
        ]
        let event = BasicAnalyticsEvent(name: "eventName", properties: properties)
        Amplify.Analytics.record(event: event)
    }
    
    func identifyUser() {

        guard let user = Amplify.Auth.getCurrentUser() else {
            print("Could not get user, perhaps the user is not signed in")
            return
        }

        let location = AnalyticsUserProfile.Location(latitude: 47.606209,
                                                     longitude: -122.332069,
                                                     postalCode: "98122",
                                                     city: "Seattle",
                                                     region: "WA",
                                                     country: "USA")

        let properties: AnalyticsProperties = ["phoneNumber": "+11234567890", "age": 25]

        let userProfile = AnalyticsUserProfile(name: user.username,
                                               email: "name@example.com",
                                               location: location,
                                               properties: properties)

        Amplify.Analytics.identifyUser(user.userId, withProfile: userProfile)

    }
    
    func getEscapeHatch() {
        do {
            let plugin = try Amplify.Analytics.getPlugin(for: "awsPinpointAnalyticsPlugin") as! AWSPinpointAnalyticsPlugin
            let awsPinpoint = plugin.getEscapeHatch()
        } catch {
            print("Get escape hatch failed with error - \(error)")
        }
    }
}
