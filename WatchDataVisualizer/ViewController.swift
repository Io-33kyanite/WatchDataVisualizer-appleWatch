//
//  ViewController.swift
//  WatchDataVisualizer
//
//  Created by SASAKI Iori on 2021/12/16.
//

import UIKit
import Charts
import WatchConnectivity

enum WatchConnectionError: Error {
    case NotSupported
}

class ViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    //MARK: #property
    private let CHART_UPDATE_INTERVAL_s: Double = 0.5
    private var curAccelEntries: AccelEntries!
    
    //MARK: #component
    @IBOutlet weak var accelLabel_x: UILabel!
    @IBOutlet weak var accelLabel_y: UILabel!
    @IBOutlet weak var accelLabel_z: UILabel!
    @IBOutlet weak var AccelLineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLineChart()
        dispSampleLineChart()
        return
        
        do {
            try setupWatchConnecting()
            self.curAccelEntries = AccelEntries()
        } catch {
            return
        }
    }


}


//MARK: - Line Chart Drawing

extension ViewController {
    private func setupLineChart() {
        self.AccelLineChartView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func dispSampleLineChart() {
        var chartDataEntries: [ChartDataEntry] = []

        for i in 0...200 {
            let timestamp: Double = Double(i) * 0.1
            let rawAccel: Double = Double.random(in: 0...5)
            let entry = ChartDataEntry(x: timestamp, y: rawAccel)
            chartDataEntries.append(entry)
        }
        
        let line = LineChartDataSet(entries: chartDataEntries, label: "Sample")
        line.colors = [.darkGray]
        
        let chartData = LineChartData()
        chartData.addDataSet(line)
        
        self.AccelLineChartView.data = chartData
    }
}


//MARK: - Watch Connector

extension ViewController: WCSessionDelegate {
    private func setupWatchConnecting() throws {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        } else {
            throw WatchConnectionError.NotSupported
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
