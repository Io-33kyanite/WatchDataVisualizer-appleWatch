//
//  ViewController.swift
//  WatchDataVisualizer
//
//  Created by SASAKI Iori on 2021/12/16.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBOutlet weak var accelLabel_x: UILabel!
    @IBOutlet weak var accelLabel_y: UILabel!
    @IBOutlet weak var accelLabel_z: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWatchConnecting()
    }


}


//MARK: - Watch Connector

extension ViewController: WCSessionDelegate {
    private func setupWatchConnecting() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    /// Message would be sent from my paired watch
    internal func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let accelX = message["accel_x"] as! Double
        let accelY = message["accel_y"] as! Double
        let accelZ = message["accel_z"] as! Double
        
        DispatchQueue.main.async {
            self.accelLabel_x.text = String(accelX)
            self.accelLabel_y.text = String(accelY)
            self.accelLabel_z.text = String(accelZ)
        }
        
        
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    internal func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    internal func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
}
