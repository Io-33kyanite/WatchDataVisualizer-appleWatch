//
//  InterfaceController.swift
//  WatchDataVisualizer WatchKit Extension
//
//  Created by SASAKI Iori on 2021/12/16.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion


class InterfaceController: WKInterfaceController {
    
    //MARK: User Setting
    let MOTION_DATA_UPDATE_INTERVAL_s: Double = 0.1
    
    //MARK: #variable
    var motionManager: CMMotionManager?
    var erSession: WKExtendedRuntimeSession?
    var dataUpdatingCounter: Int = 0
    
    //MARK: #component
    @IBOutlet weak var watchConnectivityStatusLabel: WKInterfaceLabel!
    @IBOutlet weak var reachableStatusLabel: WKInterfaceLabel!
    @IBOutlet weak var erSessionStatusLabel: WKInterfaceLabel!
    @IBOutlet weak var StartERSessionButton: WKInterfaceButton!
    @IBOutlet weak var debugField: WKInterfaceLabel!
    @IBOutlet weak var countLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        countLabel.setText("00:00")
        setupPhoneConnecting()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func startMonitoringOnPhone() {
        startMotionSensing()
        
        erSession = WKExtendedRuntimeSession()
        erSession?.delegate = self
        erSession?.start()
    }
}


extension InterfaceController: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("extendedRuntimeSessionDidStart")
        erSessionStatusLabel.setText("did start ERSession")
        erSessionStatusLabel.setTextColor(.green)
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("extendedRuntimeSessionWillExpire")
        erSessionStatusLabel.setText("will expire ERSession")
        erSessionStatusLabel.setTextColor(.red)
        resetMotionSensing()
    }
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("didInvalidateWith reason=\(reason)")
        erSessionStatusLabel.setText("did invalidate ERSession")
        debugField.setText("\(reason)")
        erSessionStatusLabel.setTextColor(.red)
        resetMotionSensing()
    }
}


//MARK: - Phone Connector

extension InterfaceController: WCSessionDelegate {
    private func setupPhoneConnecting() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState.rawValue {
        case 0:
            watchConnectivityStatusLabel.setText("WC: not activated")
            watchConnectivityStatusLabel.setTextColor(.lightGray)
        case 1:
            watchConnectivityStatusLabel.setText("WC: inactive")
            watchConnectivityStatusLabel.setTextColor(.lightGray)
        case 2:
            watchConnectivityStatusLabel.setText("WC: active")
            watchConnectivityStatusLabel.setTextColor(.green)
        default:
            watchConnectivityStatusLabel.setText("WC: ---")
            watchConnectivityStatusLabel.setTextColor(.lightGray)
        }
    }
}


//MARK: - Motion Sensing

extension InterfaceController {
    func startMotionSensing() {
        motionManager = CMMotionManager()
        if motionManager!.isDeviceMotionAvailable {
            motionManager!.deviceMotionUpdateInterval = MOTION_DATA_UPDATE_INTERVAL_s
            
            motionManager!.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (motion:CMDeviceMotion?, error:Error?) in
                if let x = motion?.userAcceleration.x,
                   let y = motion?.userAcceleration.y,
                   let z = motion?.userAcceleration.z {
                    
                    self.dataUpdatingCounter += 1
                    let timeInterval: Int = Int(self.MOTION_DATA_UPDATE_INTERVAL_s * Double(self.dataUpdatingCounter))
                    let time_m = timeInterval / 60 % 60
                    let time_s = timeInterval % 60
                    self.countLabel.setText(String(format: "%02d:%02d", time_m, time_s))
                    
                    if WCSession.default.isReachable {
                        self.reachableStatusLabel.setText("WC: reachable")
                        self.reachableStatusLabel.setTextColor(.green)
                        let dic: [String:Double] = ["accel_x":x, "accel_y":y, "accel_z":z]
                        WCSession.default.sendMessage(dic, replyHandler: nil) { error in
                            self.debugField.setText("Could not send a message in WCSession: \(error)")
                        }
                    } else {
                        self.reachableStatusLabel.setText("WC: not reachable")
                        self.reachableStatusLabel.setTextColor(.lightGray)
                        self.resetMotionSensing()
                    }
                    
                }
            })
            
        }
    }
    
    func resetMotionSensing() {
        if let motionManager = motionManager {
            motionManager.stopDeviceMotionUpdates()
            countLabel.setText("--:--")
            dataUpdatingCounter = 0
        }
    }
    
}
