//
//  BikeRecordDataModel.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/31.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import Foundation
import CoreLocation

struct bikeRecord{
    let date: NSDate
    let distance: Double
    let duration: Double
    let route: [CLLocation]
}

