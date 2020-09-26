//
//  LocationsViewController.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import RadarSDK

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
        
    public var locationNames: [String] = []
        
    public var locationTimes: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectAllButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    private var selectedLocations: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        doneButton.layer.cornerRadius = 8
        selectAllButton.layer.cornerRadius = 8
        tableView.allowsMultipleSelection = true
        
        selectedLocations.removeAll()
    }
    override func viewWillAppear(_ animated: Bool) {
        //DispatchQueue.global(qos: .background).async{
            let db = Firestore.firestore()
           let mail = UserDefaults.standard.string(forKey: "email")
           let docRef = db.collection("users").document(mail!)
           //get location document
           docRef.getDocument { (document, error) in
               if let document = document, document.exists {
                   if var stores = document.get("visitedStores") as? [String]{
                       // add locationNames database
                       self.locationNames = stores
                   }
                print(self.locationNames)
                   if var stamps = document.get("visitedTimes") as? [Timestamp]{
                       for stamp in stamps{
                           let date = stamp.dateValue()

                           let formatter = DateFormatter()
                           formatter.dateStyle = .medium
                           formatter.timeStyle = .medium

                           let datetime = formatter.string(from: date)
                           // add locationTimes database
                           self.locationTimes.append(datetime)
                       }
                   }
                self.tableView.reloadData()
               }
               else {
                   print("Document does not exist")
               }
           }
            

    }
    func numberOfSections(in tableView: UITableView) -> Int {
       //only 1 section in tableview
       return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationTableViewCell
        // Set text to physionet sample info
        let location = locationNames[indexPath.row]
        let time = locationTimes[indexPath.row]
        
        //set cell label to text
        cell.locationLabel.text = location
        cell.timeLabel.text = time
        
        //round cell corners
        //cell.layer.cornerRadius = 8
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //not needed right now
    }
    
    @IBAction func selectAllPressed(_ sender: UIButton) {
        //select all rows
        let totalRows = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        // get array of selected addresses
        if((tableView!.indexPathsForSelectedRows) != nil){
            for i in tableView!.indexPathsForSelectedRows!{
                selectedLocations.append(locationNames[i.row])
            }
        }
        //DispatchQueue.global(qos: .background).async{
        //push addresses array to firebase
        let db = Firestore.firestore()
            for loc in self.locationNames {
            let docRef = db.collection("stores").document(loc)
            //get location document
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let count = document.get("infectedVisitors") as? Int{
                        print("good")
                           document.reference.updateData([
                                               "infectedVisitors": count+1
                                               ])
                        //add geofence
//                           }
//                    else{
//                        print("failed update")
//                    }
                      }
//                else{
//                    print("failed update")
                }
                   }
           }
        //return occurs automatically due to unwind segue
      // }
    }
    
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
