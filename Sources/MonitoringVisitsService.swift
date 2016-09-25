//
//  MonitoringVisitsService.swift
//  RxLocationManager
//
//  Created by Hao Yu on 16/7/6.
//  Copyright © 2016年 GFWGTH. All rights reserved.
//
#if os(iOS)
    import Foundation
    import CoreLocation
    import RxSwift
    
    
    //MARK: MonitoringVisitsService
    public protocol MonitoringVisitsService{
        /// Observable of visit event
        var visiting: Observable<CLVisit>{get}
    }
    
    //MARK: DefaultMonitoringVisitsService
    class DefaultMonitoringVisitsService: MonitoringVisitsService{
        let locMgr: CLLocationManagerBridge
        fileprivate var observers = [(id:Int, observer: AnyObserver<CLVisit>)]()
        
        var visiting: Observable<CLVisit>{
            get{
                return Observable.create{
                    observer in
                    var ownerService:DefaultMonitoringVisitsService! = self
                    let id = nextId()
                    ownerService.observers.append((id, observer))
                    ownerService.locMgr.startMonitoringVisits()
                    return Disposables.create{
                        ownerService.observers.remove(at: ownerService.observers.index{$0.id == id}!)
                        if ownerService.observers.count == 0{
                            ownerService.locMgr.stopMonitoringVisits()
                        }
                        ownerService = nil
                    }
                }
            }
        }
        
        init(bridgeClass: CLLocationManagerBridge.Type){
            locMgr = bridgeClass.init()
            locMgr.didVisit = {
                [weak self]
                mgr, visit in
                if let copyOfObservers = self?.observers{
                    for (_, observer) in copyOfObservers{
                        observer.onNext(visit)
                    }
                }
            }
        }
    }
#endif
