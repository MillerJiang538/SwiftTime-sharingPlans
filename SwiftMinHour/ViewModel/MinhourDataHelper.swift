//
//  MinhourDataHelper.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/2/13.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

import SwiftyJSON

class MinhourDataHelper {
    
    var xDateArray:Array<Dictionary<String, String>>?
    
    var xDateDict:Dictionary<String, String>?

    var totalRanges:Array<JSON>?

    var minhourArray:Array<MinhourDataModel>
    
    var cjlLineModelArray:Array<MinhourCJLLineModel>?

    /**
     最大值 最小值
     */
    var maxValue:Float?
    
    var minValue:Float?

    /**
     成交量 最大 最小
     */
    var maxVolume:Float?

    var minVolume:Float?

    /**
     持仓量 最大 最小
     */
    var maxInterest:Float?

    var minInterest:Float?
    
    //前一日收盘价 今日均线
    var averagePre:String

    init (dataArray : Array<MinhourDataModel> , averagePre : String ) {
        self.minhourArray = dataArray
        self.averagePre = averagePre
    }
    
    //计算坐标系
    func convertPositionModelFromMinHourModels() -> Array<MinhourDataModel> {
        let navHeight = CommonMacro.navigationBarHeight()
        self.xDateArray = self.calculateXPosition()
        self.xDateDict = self.calculateXdateValue()
        
        self.maxValue = -MAXFLOAT
        self.minValue = +MAXFLOAT
        
        self.maxVolume = -MAXFLOAT
        self.minVolume = +MAXFLOAT

        self.maxInterest = -MAXFLOAT
        self.minInterest = MAXFLOAT

        for model in self.minhourArray {
            if model.last!.isEmpty {
                continue
            }
            //价格
            if Float(model.last!)! > self.maxValue! {
                self.maxValue = Float(model.last!)
            }
            if Float(model.last!)! < self.minValue! {
                self.minValue = Float(model.last!)
            }
            //成交量
            if Float(model.volume!)! > self.maxVolume! {
                self.maxVolume = Float(model.volume!)
            }
            if Float(model.volume!)! < self.maxVolume! {
                self.minVolume = Float(model.volume!)
            }
            //持仓量
            if Float(model.interest!)! > self.maxInterest! {
                self.maxInterest = Float(model.interest!)
            }
            if Float(model.interest!)! < self.minInterest! {
                self.minInterest = Float(model.interest!)
            }
        }
        self.calculateYvalueWithAveragePre(averagePre: self.averagePre)
        
        self.cjlLineModelArray = Array<MinhourCJLLineModel>()
        let minhourHeight = (UIScreen.main.bounds.height - navHeight) * 0.75
        let indexHeight = (UIScreen.main.bounds.height - navHeight) * 0.25 - 20
        let yUnitValue = minhourHeight / CGFloat((self.maxValue! - self.minValue!))
        let yIndexUnitValue = (indexHeight-20) / CGFloat((self.maxInterest! - self.minInterest!))
        for i in 0 ..< self.minhourArray.count {
            var model = self.minhourArray[i]
            let dateDict = self.xDateArray?[i]
            let position = dateDict!["position"]
            let xPosition = Double(position!)
            var indexModel = MinhourCJLLineModel()
            if model.last!.isEmpty {
                let point = CGPoint(x: xPosition!,y: -1.0)
                model.point = point
                model.averagePoint = point
                self.minhourArray[i] = model
                indexModel.point = point;
                continue
            }
            //均线和分时线
            let value = CGFloat((Float(model.last!)! - self.minValue!))*yUnitValue
            let yPostion = abs(minhourHeight - CGFloat(value))
            let point = CGPoint(x: CGFloat(xPosition!),y: yPostion)
            let averageValue = CGFloat((Float(model.average!)! - self.minValue!))*yUnitValue
            let averageYPostion = abs(minhourHeight - CGFloat(averageValue))
            let averagePoint = CGPoint(x: CGFloat(xPosition!),y: averageYPostion)
            model.point = point
            model.averagePoint = averagePoint
            self.minhourArray[i] = model
            //持仓量变化线
            let indexValue = CGFloat(Float(model.interest!)! - self.minInterest!)
            let yIndexPostion = abs((indexHeight - 20) - indexValue*yIndexUnitValue) + 20
            let indexPoint = CGPoint(x: CGFloat(xPosition!) ,y: yIndexPostion)
            indexModel.point = indexPoint
            self.cjlLineModelArray?.append(indexModel)
        }
        return self.minhourArray
    }
    
    //计算x轴的位置
    func calculateXPosition() -> Array<Dictionary<String, String>> {
        let width = UIScreen.main.bounds.width
        var dateArray = Array<Dictionary<String, String>>()
        let dateCount = self.totalRanges?.count
        for i in 0 ..< dateCount! {
            let dateDict = self.totalRanges![i]
            let end = dateDict["end"].int64
            let start = dateDict["start"].int64
            let startDate = self.convertMinDateWithDate(date: start!)
            let endDate = self.convertMinDateWithDate(date: end!)
            for j in startDate ..< endDate+1 {
                var dict = Dictionary<String,String>()
                dict["date"] = String(j)
                dict["position"] = "0"
                dateArray.append(dict)
            }
        }
        
        let interval = width/CGFloat(dateArray.count)
        for i in 0 ..< dateArray.count {
            var dict = dateArray[i]
            let x = CGFloat(i)*interval
            dict["position"] = String(format: "%f", Double(x))
            dateArray[i] = dict
        }
        
        return dateArray
    }
    
    //计算x轴的基本参数
    func calculateXdateValue() -> Dictionary<String, String> {
        let width = UIScreen.main.bounds.width
        var dateCount:Int64 = 0
        let rangesCount = self.totalRanges?.count
        for i in 0 ..< rangesCount! {
            let dateDict = self.totalRanges![i]
            let end = dateDict["end"].int64
            let start = dateDict["start"].int64
            let startDate = self.convertMinDateWithDate(date: start!)
            let endDate = self.convertMinDateWithDate(date: end!)
            dateCount = dateCount + (endDate - startDate)
        }
        return ["dateCount":String(dateCount), "dateWidth":String(format: "%f", Double(width/CGFloat(dateCount))) ]
    }
    
    //转化成分钟数据
    func convertMinDateWithDate(date:Int64) -> Int64 {
        return date/(60*1000)
    }
    
    //y轴刻度 最大最小
    func calculateYvalueWithAveragePre(averagePre:String) {
        if averagePre.isEmpty {
            return
        }
        
        var maxLast = self.maxValue!
        var minLast = self.minValue!
        if maxLast == minLast {
            maxLast = maxLast*1.05
            minLast = minLast*0.95
        }
        let maxAbs = max(abs(maxLast - Float(averagePre)!), abs(Float(averagePre)! - minLast))
        self.maxValue = Float(averagePre)! + maxAbs*1.05
        self.minValue = Float(averagePre)! - maxAbs*1.05
    }
    
    //时间轴添加
    func setUpTotalRanges(ranges:Array<JSON>) {
        self.totalRanges = Array<JSON>()
        for i in ranges.reversed().enumerated() {
            self.totalRanges?.append(i.1)
        }
    }
    
    //分时图左轴数值和右轴数值
    func calculateMinHourYvalue () -> Dictionary<String, Array<String>> {
        if self.averagePre.isEmpty {
            return ["":[""]]
        }
        
        let interval = (self.maxValue! - self.minValue!) / 4
        var leftArray = Array<String>()
        var rightArray = Array<String>()
        for i in 0 ..< 5 {
            let value = self.minValue! + interval*Float(i)
            leftArray.append(String(value))
            let percentValue = (value - Float(self.averagePre)!)/Float(self.averagePre)!*100
            if percentValue > 0 {
                rightArray.append(String(format: "+%.2f%%",percentValue))
            }else if percentValue < 0  {
                rightArray.append(String(format: "%.2f%%",percentValue))
            }else {
                rightArray.append("0")
            }
        }
        let dict = ["left":leftArray,"right":rightArray]
        return dict
    }
    
    func convertCJLPositionModel() -> Array<MinhourCJLModel> {
        var modelArray = Array<MinhourCJLModel>()
        let navHeight = CommonMacro.navigationBarHeight()
        let minY = CGFloat(20)
        let maxY = (UIScreen.main.bounds.height - navHeight) * 0.25 - minY //留出时间轴
        let yIndexUnitValue = (maxY - minY)/CGFloat(self.maxVolume!)
        for i in 0 ..< self.minhourArray.count {
            let model = self.minhourArray[i]
            var posModel = MinhourCJLModel()
            let dateDict = self.xDateArray?[i]
            let xPosition = dateDict?["position"]
            let doubleX = Double(xPosition!)
            if model.last!.isEmpty {
                posModel.startPoint = CGPoint(x: CGFloat(doubleX!), y: -1.0)
                posModel.endPoint = CGPoint(x: CGFloat(doubleX!), y: -1.0)
                continue
            }
            let cgVolume = CGFloat((self.maxVolume! - Float(model.volume!)!))
            let yPosition = cgVolume*yIndexUnitValue
            posModel.startPoint = CGPoint(x: CGFloat(doubleX!), y: yPosition+minY)
            posModel.endPoint = CGPoint(x: CGFloat(doubleX!), y: maxY)
            if i == 0 {
                if Float(model.updown!)! < 0.0 {
                    posModel.columnColor = UIColor(rgb: 0x35CB6B)
                }else if Float(model.updown!)! > 0.0 {
                    posModel.columnColor = UIColor(rgb: 0xFF5252)
                }else {
                    posModel.columnColor = UIColor.white
                }
            }else {
                let preModel = self.minhourArray[i-1]
                if (Float(model.updown!)! - Float(preModel.updown!)!) < 0.0 {
                    posModel.columnColor = UIColor(rgb: 0x35CB6B)
                }else if (Float(model.updown!)! - Float(preModel.updown!)!) > 0.0 {
                    posModel.columnColor = UIColor(rgb: 0xFF5252)
                }else {
                    posModel.columnColor = UIColor.white
                }
            }
            modelArray.append(posModel)
        }
        return modelArray
    }
    
    //x轴日期线
    func calculateXdate() -> Array<Dictionary<String, String>> {
        var xDateArray = Array<Dictionary<String, String>>()
        for i in 0 ..< self.totalRanges!.count {
            let dateDict = self.totalRanges![i]
            let end = self.convertMinDateWithDate(date: dateDict["end"].int64!)
            let start = self.convertMinDateWithDate(date: dateDict["start"].int64!)
            if i == self.totalRanges!.count - 1 {
                var muStartDict = Dictionary<String,String>()
                muStartDict["date"] = dateDict["start"].stringValue
                var muEndDict = Dictionary<String,String>()
                muEndDict["date"] = dateDict["end"].stringValue
                
                for i in 0 ..< self.xDateArray!.count {
                    let posDateDict = self.xDateArray![i]
                    if (Int64(posDateDict["date"]!) == start) {
                        muStartDict["position"] = posDateDict["position"]
                    }
                    if (Int64(posDateDict["date"]!) == end) {
                        muEndDict["position"] = posDateDict["position"]
                    }
                }
                xDateArray.append(muStartDict)
                xDateArray.append(muEndDict)
            }else {
                var muDict = Dictionary<String,String>()
                muDict["date"] = dateDict["start"].stringValue
                for i in 0 ..< self.xDateArray!.count {
                    let posDateDict = self.xDateArray![i]
                    if (Int64(posDateDict["date"]!) == start) {
                        muDict["position"] = posDateDict["position"]
                    }
                }
                xDateArray.append(muDict)
            }
        }
        return xDateArray
    }
}
