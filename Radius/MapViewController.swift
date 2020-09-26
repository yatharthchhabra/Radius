//
//  MapViewController.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//


import UIKit
import MapKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var isRed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        var circleArray: [MKCircle] = []
        
        let db = Firestore.firestore()
        
        //yellow zones
        db.collection("stores").whereField("isSafe", isEqualTo: "crowded")
                                 .getDocuments() { (querySnapshot, err) in
                                     if let err = err {
                                         print("Error getting documents: \(err)")
                                     } else {
                                        self.isRed = false
                                         for document in querySnapshot!.documents {
                                             if let coords = document.get("geolocation") as? [Double]{
                                                 if let name = document.get("name") as? String{
                                                    print("crowded: \(name)")
                                                 let annotation1 = MKPointAnnotation()
                                                 annotation1.coordinate = CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1])
                                                 annotation1.title = name
                                                 annotation1.subtitle = "Crowded"
                                                 self.mapView.addAnnotation(annotation1)
                                                   let yellowCircle: MKCircle = MKCircle(center: CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1]), radius: CLLocationDistance(200))
                                                   circleArray.append(yellowCircle)
                                                   self.mapView.addOverlay(yellowCircle)
                                             }
                                                 
                                         }
                                     }
                             }
                       }
        
        // red zones
        db.collection("stores").whereField("infectedVisitors", isGreaterThan: 0)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.isRed = true
                    for document in querySnapshot!.documents {
                       // print(document.data())
                        if let coords = document.get("geolocation") as? [Double]{
                            if let name = document.get("name") as? String{
                                print("infected: \(name)")
                            let annotation1 = MKPointAnnotation()
                            annotation1.coordinate = CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1])
                            annotation1.title = name
                            annotation1.subtitle = "Infected"
                            self.mapView.addAnnotation(annotation1)
                            let redCircle: MKCircle = MKCircle(center: CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1]), radius: CLLocationDistance(200))
                            circleArray.append(redCircle)
                            self.mapView.addOverlay(redCircle)
                        }
                    }
                }
        }
                
       
//        // Sample Annotation
//        let annotation1 = MKPointAnnotation()
//
//        // Get the Lat. and Long. Coordinate
//
//        annotation1.coordinate = CLLocationCoordinate2D(latitude: 37.372631, longitude: -121.996033)
//
//        // Add custom title/subtitle
//        annotation1.title = "Costco"
//        annotation1.subtitle = "Crowded"
//
//        mapView.addAnnotation(annotation1)
//       // Costco Radar
//        let centerCostco =  CLLocationCoordinate2DMake(37.372631, -121.996033)
//
//        let CostcoCircle: MKCircle = MKCircle(center: centerCostco, radius: CLLocationDistance(200))
//        mapView.addOverlay(CostcoCircle)
//
//
//
//        // Sample Annotation
//        let annotation2 = MKPointAnnotation()
//
//        // Get the Lat. and Long. Coordinate
//
//        annotation2.coordinate = CLLocationCoordinate2D(latitude: 37.33822, longitude: -121.976)
//
//        // Add custom title/subtitle
//        annotation2.title = "Game Stop"
//        annotation2.subtitle = "Safe"
//
//        mapView.addAnnotation(annotation2)
//
//        // Costco Radar
//        let centerGame =  CLLocationCoordinate2DMake(37.33822, -121.976)
//
//        let gameCircle: MKCircle = MKCircle(center: centerGame, radius: CLLocationDistance(200))
//        mapView.addOverlay(gameCircle)
//
//
//        // Sample Annotation
//        let annotation3 = MKPointAnnotation()
//
//        // Get the Lat. and Long. Coordinate
//
//        annotation3.coordinate = CLLocationCoordinate2D(latitude: 37.351631, longitude: -122.005890)
//
//        // Add custom title/subtitle
//        annotation3.title = "India Cash & Carry"
//        annotation3.subtitle = "Unsafe"
//
//        mapView.addAnnotation(annotation3)
//
////        // Costco Radar
//        let centerCASH =  CLLocationCoordinate2DMake(37.351631, -122.005890)
////
//        let CASHCircle: MKCircle = MKCircle(center: centerCASH, radius: CLLocationDistance(200))
//        mapView.addOverlay(CASHCircle)
//
//
//
//        // Sample Annotation
//                let annotation4 = MKPointAnnotation()
//
//                // Get the Lat. and Long. Coordinate
//
//                annotation4.coordinate = CLLocationCoordinate2D(latitude: 37.3227653503418, longitude: -122.00669860839844)
//
//                // Add custom title/subtitle
//                annotation4.title = "Roasted Coffee Bean"
//                annotation4.subtitle = "Safe"
//
//                mapView.addAnnotation(annotation4)
//
//        //        // Costco Radar
//                let centerBEAN =  CLLocationCoordinate2DMake(37.3227653503418, -122.00669860839844)
//        //
//                let beanCircle: MKCircle = MKCircle(center: centerBEAN, radius: CLLocationDistance(200))
//                mapView.addOverlay(beanCircle)
//
//
//
//                // Sample Annotation
//                let annotation5 = MKPointAnnotation()
//
//                // Get the Lat. and Long. Coordinate
//
//                annotation5.coordinate = CLLocationCoordinate2D(latitude: 37.33747, longitude: -121.9948)
//
//                // Add custom title/subtitle
//                annotation5.title = "Subway"
//                annotation5.subtitle = "Crowded"
//
//                mapView.addAnnotation(annotation5)
//
//        //        // Costco Radar
//                let SUBcenter =  CLLocationCoordinate2DMake(37.33747, -121.9948)
//        //
//                let SUBCricle: MKCircle = MKCircle(center: SUBcenter, radius: CLLocationDistance(200))
//                mapView.addOverlay(SUBCricle)
//
//        // Sample Annotation
//                let annotation6 = MKPointAnnotation()
//
//                // Get the Lat. and Long. Coordinate
//
//                annotation6.coordinate = CLLocationCoordinate2D(latitude: 37.323029, longitude: -122.011452)
//
//                // Add custom title/subtitle
//                annotation6.title = "Target"
//                annotation6.subtitle = "Unsafe"
//
//                mapView.addAnnotation(annotation6)
//
//        //        // Costco Radar
//                let targeCen =  CLLocationCoordinate2DMake(37.323029, -122.011452)
//        //
//                let targetCirc: MKCircle = MKCircle(center: targeCen, radius: CLLocationDistance(200))
//                mapView.addOverlay(targetCirc)
//
        
        
//        let centerV =  CLLocationCoordinate2DMake(37.322583, -122.034656)
//
//        let myCircle: MKCircle = MKCircle(center: centerV, radius: CLLocationDistance(1000))
//        mapView.addOverlay(myCircle)
        
        // set the Map Region
            if(circleArray.count>0){
                let region = MKCoordinateRegion(center: circleArray[0].coordinate, latitudinalMeters: 9000, longitudinalMeters: 9000)
                self.mapView.setRegion(region, animated: true)
            }
        }
       
    }
    func getRedSpots() -> [[Int]]{
        var finalcoords: [[Int]] = [[]]
        let db = Firestore.firestore()
        db.collection("stores").whereField("infectedVisitors", isGreaterThan: 0)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let coords = document.get("geolocation") as? [Int]{
                            finalcoords.append(coords)
                        }
                            
                    }
                }
        }
        return finalcoords
    }
    
    
    func getYellowSpots() -> [[Int]]{
        var finalcoords: [[Int]] = [[]]
        let db = Firestore.firestore()
        db.collection("stores").whereField("visitors", isGreaterThan: 15)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let coords = document.get("geolocation") as? [Int]{
                            finalcoords.append(coords)
                        }
                            
                    }
                }
        }
        return finalcoords
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Generate renderer.
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        if(isRed){
            // Fill the inside of the circle with red.
            myCircleView.fillColor = UIColor.red
        } else{
            // Fill the inside of the circle with yellow.
            myCircleView.fillColor = UIColor.yellow
        }
            
        // Set the color of the circumferential line to black.
        myCircleView.strokeColor = UIColor.black
        
        // Transmit the circle.
        myCircleView.alpha = 0.5
        
        // Thickness of the circumference line.
        myCircleView.lineWidth = 1.5
        
        return myCircleView
    }

}
