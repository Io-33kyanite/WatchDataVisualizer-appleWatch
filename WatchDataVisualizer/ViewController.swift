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
    private let CHART_UPDATE_INTERVAL_s: Double = 0.1
    private var curAccelEntries: AccelEntries!
    private var accelUpdateTimer: Timer?
    private var curAccel_x: Double?
    private var curAccel_y: Double?
    private var curAccel_z: Double?
    
    //MARK: #component
    @IBOutlet weak var accelLabel_x: UILabel!
    @IBOutlet weak var accelLabel_y: UILabel!
    @IBOutlet weak var accelLabel_z: UILabel!
    @IBOutlet weak var AccelLineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAccelLineChart()
        startAccelChartDrawing()
        
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
    private func setupAccelLineChart() {
        self.AccelLineChartView.translatesAutoresizingMaskIntoConstraints = false
        
        let chartDataSet_x = LineChartDataSet(entries: nil, label: "x-accel")
        chartDataSet_x.drawCirclesEnabled = false
        chartDataSet_x.setColor(.red)
        chartDataSet_x.mode = .linear
        chartDataSet_x.drawValuesEnabled = false
        
        let chartDataSet_y = LineChartDataSet(entries: nil, label: "y-accel")
        chartDataSet_y.drawCirclesEnabled = false
        chartDataSet_y.setColor(.blue)
        chartDataSet_y.mode = .linear
        chartDataSet_y.drawValuesEnabled = false
        
        let chartDataSet_z = LineChartDataSet(entries: nil, label: "z-accel")
        chartDataSet_z.drawCirclesEnabled = false
        chartDataSet_z.setColor(.green)
        chartDataSet_z.mode = .linear
        chartDataSet_z.drawValuesEnabled = false
        
        let chartData = LineChartData(dataSets: [chartDataSet_x, chartDataSet_y, chartDataSet_z])
        self.AccelLineChartView.data = chartData
    }
    
    private func startAccelChartDrawing() {
        self.curAccelEntries = AccelEntries()
        
        self.accelUpdateTimer = Timer.scheduledTimer(
            timeInterval: self.CHART_UPDATE_INTERVAL_s,
            target: self,
            selector: #selector(updateAccelChart),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func updateAccelChart() {
        guard let rawAccel_x = self.curAccel_x,
              let rawAccel_y = self.curAccel_y,
              let rawAccel_z = self.curAccel_z else {
                  return
              }
        
        let newAccelEntry: AccelData = AccelData(x: rawAccel_x, y: rawAccel_y, z: rawAccel_z)
        self.curAccelEntries.accelData.append(newAccelEntry)
        
        let accelEntryCount: Int = self.curAccelEntries.accelData.count
        let timestamp: Double = Double(accelEntryCount) / 10.0
        
        let entry_x = ChartDataEntry(x: timestamp, y: rawAccel_x)
        let entry_y = ChartDataEntry(x: timestamp, y: rawAccel_y)
        let entry_z = ChartDataEntry(x: timestamp, y: rawAccel_z)
        
        self.AccelLineChartView.data?.addEntry(entry_x, dataSetIndex: 0)
        self.AccelLineChartView.data?.addEntry(entry_y, dataSetIndex: 1)
        self.AccelLineChartView.data?.addEntry(entry_z, dataSetIndex: 2)
        self.AccelLineChartView.notifyDataSetChanged()
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
        guard let accelX = message["accel_x"] as? Double,
           let accelY = message["accel_y"] as? Double,
           let accelZ = message["accel_z"] as? Double else {
            return
        }
        
        self.curAccel_x = accelX
        self.curAccel_y = accelY
        self.curAccel_z = accelZ
        
        DispatchQueue.main.async {
            self.accelLabel_x.text = String(self.curAccel_x!)
            self.accelLabel_y.text = String(self.curAccel_y!)
            self.accelLabel_z.text = String(self.curAccel_z!)
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
