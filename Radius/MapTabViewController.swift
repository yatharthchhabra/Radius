//
//  MapTabViewController.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//
import UIKit
import BLTNBoard

class MapTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        print("cool stuff")
        boardManager.showBulletin(above: self)
    }
    
    private lazy var boardManager: BLTNItemManager = {
         let item = BLTNPageItem(title: "Welcome")
         item.actionButtonTitle = "Get Started"
         //item.alternativeButtonTitle = "Get Started"
         item.descriptionText = "Start by hovering over to the Report Tab and selecting the most recently visited locations."
         
        
         item.actionHandler = { _ in
             self.didTapBoardContinue()
         }
         
         item.alternativeHandler = { _ in
             self.didTapBoardSkip()
         }
         item.appearance.actionButtonColor = .systemGreen
         item.appearance.alternativeButtonTitleColor = .gray
         
         return BLTNItemManager(rootItem: item)
     }()
    
    func didTapBoardContinue(){
        print("did tap continue")
    }
    
    func didTapBoardSkip(){
        print("did tap skip")
    }
    
    @IBAction func maps(_ sender: UIButton) {
        let map = storyboard?.instantiateViewController(identifier: "mapView")
        view.window?.rootViewController = map
        view.window?.makeKeyAndVisible()
    }
    @IBAction func signOut(_ sender: Any) {
        let main = storyboard?.instantiateViewController(identifier: "start") as? NavViewController
        view.window?.rootViewController = main
        view.window?.makeKeyAndVisible()
    }
}

