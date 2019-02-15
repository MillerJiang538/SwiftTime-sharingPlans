//
//  MinhourModel.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/2/13.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

import SwiftyJSON

struct MinhourDataModel {
    var preClose: String?
    var chgInterest: String?
    var close: String?
    var updown: String?
    var volume: String?
    var interest: String?
    var ruleAt: Int64?
    var settle: String?
    var last: String?
    var highest: String?
    var chgVolume: String?
    var preInterest: String?
    var open: String?
    var percent: String?
    var average: String?
    var point: CGPoint? //分时点
    var averagePoint: CGPoint? //均线点

    init(jsonData: JSON) {
        preClose = jsonData["preClose"].stringValue
        chgInterest = jsonData["chgInterest"].stringValue
        close = jsonData["close"].stringValue
        updown = jsonData["updown"].stringValue
        volume = jsonData["volume"].stringValue
        interest = jsonData["interest"].stringValue
        ruleAt = jsonData["ruleAt"].int64
        settle = jsonData["settle"].stringValue
        last = jsonData["last"].stringValue
        highest = jsonData["highest"].stringValue
        chgVolume = jsonData["chgVolume"].stringValue
        preInterest = jsonData["preInterest"].stringValue
        open = jsonData["open"].stringValue
        percent = jsonData["percent"].stringValue
        average = jsonData["average"].stringValue
    }
}

struct MinhourCJLModel {
    var startPoint: CGPoint? //起始点
    var endPoint: CGPoint? //结束点
    var columnColor: UIColor? //色值
}

struct MinhourCJLLineModel {
    var point: CGPoint?
}
