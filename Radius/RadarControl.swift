//
//  RadarControl.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//

import Foundation
import Foundation
import RadarSDK

class RadarControl : NSObject
{
    //singleton
    static let radarSingleton = RadarControl()
    private override init(){}
    
    public func track(){
        /*
             Summary: Stop tracking if not moving more than 10 meters for 10 minutes.
             Start tracking when moving more than 50 meters.
             When moving, tracks every 1 minute
             */
            
            
            // Set Radar tracking options
            var options: RadarTrackingOptions = RadarTrackingOptions()
            //tracking time interval when stopped
            options.desiredStoppedUpdateInterval = 0    // 0 seconds
            //tracking time interval when moving
            options.desiredMovingUpdateInterval = 60    // 60 seconds
            // time interval to sync with server. Not needded
            options.desiredSyncInterval = 0             // NA
            // location accuracy
            options.desiredAccuracy = .high             // highest accuracy
            // time interval not moving to consider stopped
            options.stopDuration = 600                   // 600 seconds
            // distance within which to consider stopped
            options.stopDistance = 10                   // 10 meters
            // date at when to start tracking
            options.startTrackingAfter = nil            // NA
            // date at when to stop tracking
            options.stopTrackingAfter = nil            // NA
            // which failed location updates to update
            options.replay = .none                     // NA
            //which locations to sync with server
            options.sync = .none                       // NA
            // show blue bar?
            options.showBlueBar = false                // no
            // create geofence around client when stopped
            options.useStoppedGeofence = true         // yes
            // radius of stopped geofence
            options.stoppedGeofenceRadius = 50       // 50 meters
            // create geofence around client when moving
            options.useMovingGeofence = false          // no    ADD LATER
            // radius of moving geofence
            options.movingGeofenceRadius = 0           // no    ADD LATER
            // iOS visit monitoring service
            options.useVisits = false                  // NA
            // power saving feature
            options.useSignificantLocationChanges = false // NA
            
            Radar.startTracking(trackingOptions: options)
    }
            
    //        Radar.trackOnce { (status: RadarStatus, location: CLLocation?, events: [RadarEvent]?, user: RadarUser?) in
    //          print(location)
    

}
