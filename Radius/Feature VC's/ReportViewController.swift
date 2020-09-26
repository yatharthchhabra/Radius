//
//  ReportViewController.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

   import UIKit
    import Firebase
    import FirebaseAuth
    import FirebaseFirestore

    class ReportViewController: UIViewController {

        @IBOutlet weak var reportLabel: UILabel!
        
        @IBOutlet weak var reportButton: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            reportButton.layer.cornerRadius = 8
            //UserDefaults.standard.set("123456@gmail.com", forKey: "email")
            //RadarControl.radarSingleton.track()
    //        guard let url = URL(string: "https://api.lucidtech.ai/v0/receipts"),
    //            let payload = "{\"documentId\": \"a50920e1-214b-4c46-9137-2c03f96aad56\"}".data(using: .utf8) else
    //        {
    //            return
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.addValue("your_api_key", forHTTPHeaderField: "x-api-key")
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.httpBody = payload
    //
    //        URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            guard error == nil else { print(error!.localizedDescription); return }
    //            guard let data = data else { print("Empty data"); return }
    //
    //            if let str = String(data: data, encoding: .utf8) {
    //                print(str)
    //            }
    //        }.resume()

            // Do any additional setup after loading the view.
        }
        @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {}

    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "locationsSegue" {
    //            if let nextViewController = segue.destination as? LocationsViewController {
    //                // clear data
    ////                nextViewController.locationNames.removeAll()
    ////                nextViewController.locationTimes.removeAll()
    //
    //
    //            }
    //        }
    //    }
    }
