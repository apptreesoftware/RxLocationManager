//
//  Bridge.swift
//  RxLocationManager
//
//  Created by Hao Yu on 16/7/6.
//  Copyright © 2016年 GFWGTH. All rights reserved.
//

import Foundation
import CoreLocation

class CLLocationManagerBridge: CLLocationManager, CLLocationManagerDelegate{
    var didFailWithError: ((CLLocationManager, NSError) -> Void)?
    var didChangeAuthorizationStatus: ((CLLocationManager, CLAuthorizationStatus)->Void)?
    var didUpdateLocations: ((CLLocationManager, [CLLocation]) -> Void)?
    
    #if os(iOS) || os(OSX)
    var didFinishDeferredUpdatesWithError: ((CLLocationManager, NSError?) -> Void)?
    var didEnterRegion: ((CLLocationManager, CLRegion) -> Void)?
    var didExitRegion: ((CLLocationManager, CLRegion) -> Void)?
    var monitoringDidFailForRegion: ((CLLocationManager, CLRegion?, NSError) -> Void)?
    var didDetermineState:((CLLocationManager, CLRegionState, CLRegion) -> Void)?
    var didStartMonitoringForRegion:((CLLocationManager, CLRegion) -> Void)?
    #endif
    
    #if os(iOS)
    var didPausedUpdate:((CLLocationManager) -> Void)?
    var didResumeUpdate:((CLLocationManager) -> Void)?
    var displayHeadingCalibration:Bool = false
    var didUpdateHeading: ((CLLocationManager, CLHeading) -> Void)?
    var didRangeBeaconsInRegion:((CLLocationManager, [CLBeacon], CLBeaconRegion) -> Void)?
    var rangingBeaconsDidFailForRegion:((CLLocationManager, CLBeaconRegion, NSError) -> Void)?
    var didVisit:((CLLocationManager, CLVisit) -> Void)?
    #endif
    
    required override init() {
        super.init()
        self.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError?(manager, error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuthorizationStatus?(manager, status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didUpdateLocations?(manager, locations)
    }
}

#if os(iOS) || os(OSX)
extension CLLocationManagerBridge{

    @objc(locationManager:didDetermineState:forRegion:) func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    didDetermineState?(manager, state, region)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    didEnterRegion?(manager, region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    didExitRegion?(manager, region)
    }
    
    @objc(locationManager:monitoringDidFailForRegion:withError:) func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    monitoringDidFailForRegion?(manager, region, error as NSError)
    }
    
    @objc(locationManager:didStartMonitoringForRegion:) func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    didStartMonitoringForRegion?(manager, region)
    }
}
#endif

#if os(iOS)
extension CLLocationManagerBridge{

    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
    didFinishDeferredUpdatesWithError?(manager, error as NSError?)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    didPausedUpdate?(manager)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
    didResumeUpdate?(manager)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return displayHeadingCalibration
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    didUpdateHeading?(manager, newHeading)
    }
    
    @objc(locationManager:didRangeBeacons:inRegion:) func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    didRangeBeaconsInRegion?(manager, beacons, region)
    }
    
    @objc(locationManager:rangingBeaconsDidFailForRegion:withError:) func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error){
    rangingBeaconsDidFailForRegion?(manager, region, error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    didVisit?(manager, visit)
    }
}
#endif
