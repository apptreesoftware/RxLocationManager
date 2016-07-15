//
//  VisitMonitoringViewController.swift
//  RxLocationManager
//
//  Created by Hao Yu on 16/7/15.
//  Copyright © 2016年 GFWGTH. All rights reserved.
//

import UIKit
import CoreLocation
import RxLocationManager
import RxSwift

class VisitMonitoringViewController: UIViewController {
    
    @IBOutlet weak var coordValueLbl: UILabel!
    @IBOutlet weak var horizontalAccuracyLbl: UILabel!
    @IBOutlet weak var arriveDateLbl: UILabel!
    @IBOutlet weak var departureDateLbl: UILabel!
    @IBOutlet weak var toggleBtn: UIButton!
    
    private var disposeBag = DisposeBag()
    private var subscription: Disposable?
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleBtn.rx_tap
            .subscribeNext{
                [unowned self]
                _ in
                if self.subscription != nil{
                    self.subscription!.dispose()
                    self.toggleBtn.setTitle("Start", forState: .Normal)
                    self.subscription = nil
                }else{
                    self.subscription = RxLocationManager.VisitMonitoring.visiting
                        .subscribeNext{
                            visit in
                            self.coordValueLbl.text = "\(visit.coordinate.latitude),\(visit.coordinate.longitude)"
                            self.horizontalAccuracyLbl.text = visit.horizontalAccuracy.description
                            self.arriveDateLbl.text = visit.arrivalDate.description
                            self.departureDateLbl.text = visit.departureDate.description
                        }
                    self.toggleBtn.setTitle("Stop", forState: .Normal)
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}