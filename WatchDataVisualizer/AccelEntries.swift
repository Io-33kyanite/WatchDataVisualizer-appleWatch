//
//  AccelEntries.swift
//  WatchDataVisualizer
//
//  Created by SASAKI Iori on 2021/12/26.
//

import Foundation

struct AccelEntries: Codable {
    var accelData: [AccelData] = []
}

struct AccelData: Codable {
    let x: Double
    let y: Double
    let z: Double
}
