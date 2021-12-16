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
    
    let motionManager = CMMotionManager()
    @IBOutlet weak var activationStatusLabel: WKInterfaceLabel!
    @IBOutlet weak var reachableStatusLabel: WKInterfaceLabel!
    @IBOutlet weak var accelLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        setupPhoneConnecting()
        
        startMotionSensing()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func sendMessage() {
//        if WCSession.default.isReachable {
//            let msg = "Hello, iPhone!"
//            let data = ["message":msg]
//
//            WCSession.default.sendMessage(data, replyHandler: nil) { error in
//                print(error)
//            }
//        }
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
        print("activationDidCompleteWith state= \(activationState.rawValue)")
        if activationState.rawValue==2 {
            self.activationStatusLabel.setText("status: active")
        } else {
            self.activationStatusLabel.setText("status: not active")
        }
    }
}


//MARK: - Motion Sensing

extension InterfaceController {
    private func startMotionSensing() {
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 0.1
            self.motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: { (motion:CMDeviceMotion?, error:Error?) in
                let x = motion?.userAcceleration.x
                let y = motion?.userAcceleration.y
                let z = motion?.userAcceleration.z
                let dic = ["accel_x":x, "accel_y":y, "accel_z":z]
                self.accelLabel.setText("x=\(x), y=\(y), z=\(z)")
                
                if WCSession.default.isReachable {
                    self.reachableStatusLabel.setText("true")
                    WCSession.default.sendMessage(dic, replyHandler: nil) { error in
                        print(error)
                    }
                } else {
                    self.reachableStatusLabel.setText("false")
                }
            })
        }
    }
}
