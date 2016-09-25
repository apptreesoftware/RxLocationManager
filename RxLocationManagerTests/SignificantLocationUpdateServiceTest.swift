//
//  SignificantLocationServiceTest.swift
//  RxLocationManager
//
//  Created by Yonny Hao on 16/7/25.
//  Copyright © 2016年 GFWGTH. All rights reserved.
//
import XCTest
import Nimble
import CoreLocation
import RxSwift
@testable
import RxLocationManager
#if os(iOS) || os(OSX)
    class SignificantLocationUpdateServiceTest: XCTestCase {
        var significantLocationUpdateService:DefaultSignificantLocationUpdateService!
        var bridge:LocationManagerStub!
        var disposeBag: DisposeBag!
        override func setUp() {
            significantLocationUpdateService = DefaultSignificantLocationUpdateService(bridgeClass:LocationManagerStub.self)
            bridge = significantLocationUpdateService.locMgr as! LocationManagerStub
            disposeBag = DisposeBag()
        }
        
        override func tearDown() {
            disposeBag = nil
        }
        
        func testLocatingObservableWithoutError() {
            let xcTestExpectation = self.expectation(description: "GotSeriesOfLocations")
            var n = 1
            significantLocationUpdateService.locating
                .subscribe{
                    event in
                    switch event{
                    case .Next(let location):
                        switch n{
                        case 1:
                            expect(location.last!).to(equal(Locations.London))
                            n += 1
                        case 2:
                            expect(location.last!).to(equal(Locations.Johnannesburg))
                            n += 1
                        case 3:
                            expect(location.last!).to(equal(Locations.Moscow))
                            xcTestExpectation.fulfill()
                        default:
                            expect(true).to(beFalse(), description: "You should not be here")
                        }
                    case .Completed:
                        expect(true).to(beFalse(), description: "Completed should not get called when observing location updating")
                    case .Error:
                        expect(true).to(beFalse(), description: "Error should not get called when location is reported")
                    }
                }
                .addDisposableTo(disposeBag)
            expect(self.bridge.monitoringSignificantLocationChange).to(beTrue())
            bridge.didUpdateLocations!(dummyLocationManager, [Locations.London])
            bridge.didUpdateLocations!(dummyLocationManager, [Locations.Johnannesburg])
            bridge.didUpdateLocations!(dummyLocationManager, [Locations.Moscow])
            self.waitForExpectations(timeout: 100, handler:nil)
        }
        
        func testLocatingObservableWithError() {
            let xcTextExpectation = self.expectation(description: "GotSeriesOfLocationsAndError")
            var n = 1
            significantLocationUpdateService.locating
                .subscribe{
                    event in
                    switch event{
                    case .Next(let location):
                        switch n{
                        case 1:
                            expect(location.last!).to(equal(Locations.London))
                            n += 1
                        case 2:
                            expect(location.last!).to(equal(Locations.Johnannesburg))
                            n += 1
                        case 3:
                            expect(true).to(beFalse(), description: "You should not be here")
                        default:
                            expect(true).to(beFalse(), description: "You should not be here")
                        }
                    case .Completed:
                        expect(true).to(beFalse(), description: "Completed should not get called when observing location updating")
                    case .Error(let error as NSError):
                        expect(error.domain == CLError.Network.toNSError().domain).to(beTrue())
                        expect(error.code == CLError.Network.toNSError().code).to(beTrue())
                        xcTextExpectation.fulfill()
                    default:
                        expect(true).to(beFalse(), description: "You should not be here")
                    }
                }
                .addDisposableTo(disposeBag)
            bridge.didUpdateLocations!(dummyLocationManager, [Locations.London])
            bridge.didUpdateLocations!(dummyLocationManager, [Locations.Johnannesburg])
            bridge.didFailWithError!(dummyLocationManager, CLError.Code.Network.toNSError())
            bridge.didUpdateLocations!(dummyLocationManager, [Locations.Moscow])
            self.waitForExpectations(timeout: 100, handler:nil)
        }
    }
#endif
