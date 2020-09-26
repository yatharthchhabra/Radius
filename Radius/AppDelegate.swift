//
//  AppDelegate.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//
import UIKit
import CoreData
import RadarSDK
import Firebase
import FirebaseAuth
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RadarDelegate {
    var locationManager: CLLocationManager!
    
    var locationsDictionary: [String: Int] = [:]
    
    func didReceiveEvents(_ events: [RadarEvent], user: RadarUser) {
        //print(events)
    }
    
    func didUpdateLocation(_ location: CLLocation, user: RadarUser) {
        //print(location)
    }
    
    func didUpdateClientLocation(_ location: CLLocation, stopped: Bool, source: RadarLocationSource) {
        print(location)
        print("hi")
        Radar.searchPlaces(
          near: location,
          radius: 50, // meters
          chains: nil,
          categories: ["food-beverage", "shopping-retail"],
          groups: nil,
          limit: 10
        ) { (status, location, places) in
            if(status == .success && places != nil && places!.count>0){
                print("Current Report: \(places)")
                
                // add all the detected places to location dictionary
                for place in places!{
                    // if place is already in location dictionary
                    if let val = self.locationsDictionary[place.name] {
                        // increment count of location in dictionary
                        self.locationsDictionary[place.name]!+=1
                        // if count is 3, send to firebase
                        if(self.locationsDictionary[place.name] == 3){
                            print("FINAL Place: \(place.name)")
                            //send to user specific firebase
                            self.sendToUserDatabase(place: place)
                            //send to location specific firebase
                            self.sendToLocationDatabase(place: place)
                        }
                    }
                    else{
                        // make a new entry in dictionary
                        print("NEW PLACE: \(place.name)")
                        self.locationsDictionary[place.name] = 1
                    }
                }
            }
        }
    }
    func sendToUserDatabase(place: RadarPlace){
        let db = Firestore.firestore()
        let mail = UserDefaults.standard.string(forKey: "email")
        let docRef = db.collection("users").document(mail!)
        
        //get user document
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //check if visitedStores field exists
                if var stores =  document.get("visitedStores") as? Array<String>{
                    //get stores list and add new place
                    stores.append(place.name)
                    //push to firebase
                    document.reference.updateData([
                    "visitedStores": stores
                    ])
                    print("Updated 2nd \(place.name) in firebase")
                } else{
                    document.reference.updateData([
                        "visitedStores": [place.name]
                    ])
                    
                    print("Updated new \(place.name) in firebase")
                }
                if var times =  document.get("visitedTimes") as? Array<Timestamp>{
                    //get time stamps
                    times.append(Timestamp(date: Date(timeIntervalSinceNow: 0)))
                    //push to firebase
                    document.reference.updateData([
                        "visitedTimes": times
                    ])
                    print("Updated 2nd time \(time) in firebase")
                } else{
                    document.reference.updateData([
                        "visitedTimes": Timestamp(date: Date(timeIntervalSinceNow: 0))    //FieldValue.serverTimestamp()
                    ])
                   
                    print("Updated new time \(time) in firebase")
               }
            } else {
                print("Document does not exist")
            }
        }
    }
    func sendToLocationDatabase(place: RadarPlace){
        let db = Firestore.firestore()
        let docRef = db.collection("stores").document(place.name)
        //get location document
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if var count = document.get("visitors") as? Int{
                document.reference.updateData([
                                    "visitors": count+1
                                    ])
                    if(count+1>=15){
                        document.reference.updateData([
                                                    "isSafe": "crowded"
                                                ])
                    }
                }
            }
        else {
                // Add a new document in collection
                db.collection("stores").document(place.name).setData([
                    "geolocation": [place.location.coordinate.latitude,place.location.coordinate.longitude],
                    "infectedVisitors": 0,
                    "isSafe": "safe" ,
                    "name" : place.name,
                    "visitors" : 1
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }

            }
        }
    }
        
    func didFail(status: RadarStatus) {
        //TODO
    }
    
    func didLog(message: String) {
        // TODO
    }
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Radar.initialize(publishableKey: "prj_test_pk_ffeffe8749342a653760e223b7f12703bd2bcd09")
        self.locationManager = CLLocationManager()

        // background
        self.locationManager.requestAlwaysAuthorization()
        Radar.setDelegate(self)
        
        
//        }
        //LocationService.sharedInstance = LocationService()
        //SearchControl.searchSingleton.initBeaconSearch()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Radius")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


 // if a place is not detected right now, delete it
//                for (place, count) in self.locationsDictionary {
//                    var hasPlace: Bool = false
//                    for p in places!{
//                        if(place.name == p.name){
//                            hasPlace = true
//                        }
//                    }
//                    if(!hasPlace){
//                        self.locationsDictionary.removeValue(forKey: place)
//                    }
//                    else if(count>=3){
//                        print(place)
                        //Check if user has a visited locations doc
                        
//                        let db = Firestore.firestore()
//                        let mail = UserDefaults.standard.string(forKey: "email")
//                        db.collection("users").document(mail!).
//
//                        setData(["email": mail]){
//                        (error) in
//                            if error != nil{
//                                // Show error message
//                                print("Error saving user data")
//                            }
//                        }
 //                   }


