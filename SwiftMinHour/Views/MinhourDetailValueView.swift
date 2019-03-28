//
//  MinhourDetailValueView.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/3/27.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

enum MinhourDetailLocationType {
    case left
    case right
}

class MinhourDetailValueView: UIView {
    
    private var valueColor: UIColor?
    private var nameColor: UIColor?
    private var rangeColor: UIColor?
    
    private var dateLabel: UILabel?
    private var priceNameLabel: UILabel?
    private var priceValueLabel: UILabel?
    private var averageNameLabel: UILabel?
    private var averageValueLabel: UILabel?
    private var updadownNameLabel: UILabel?
    private var updownValueLabel: UILabel?
    private var updownRangeLabel: UILabel?
    private var interestNameLabel: UILabel?
    private var interestValueLabel: UILabel?
    private var interestRangeLabel: UILabel?
    private var volumeNameLabel: UILabel?
    private var volumeValueLabel: UILabel?
    private var volumeRangeLabel: UILabel?
    private var formatter: DateFormatter?
    public var valueModel: MinhourDataModel?
    var locationType: MinhourDetailLocationType?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        valueColor = UIColor(rgb: 0xE7EDF5)
        nameColor = UIColor(rgb: 0x9EB2CD)
        rangeColor = UIColor(rgb: 0x35CB6B)
        setUpSubViews()
        
        backgroundColor = UIColor(rgb: 0x4F5490)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        formatter = DateFormatter()
        locationType = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        let nameDict = ["color": nameColor,
                        "font": UIFont(name: "PingFangSC-Regular", size: 10)]
        let valueDict = ["color": valueColor,
                        "font": UIFont(name: "PingFangSC-Regular", size: 13)]
        let rangeDict = ["color": rangeColor,
                        "font": UIFont(name: "PingFangSC-Regular", size: 13)]
        let dateDict = ["color": nameColor,
                         "font": UIFont(name: "PingFangSC-Regular", size: 12)]
        let dictArray = [dateDict,nameDict,valueDict,nameDict,valueDict,nameDict,rangeDict,rangeDict,nameDict,valueDict,rangeDict,nameDict,valueDict,rangeDict]
        let textArray = ["", "价格", "", "均价", "", "涨跌", "", "", "持仓量", "", "", "成交量", "", ""]
        for i in 0..<dictArray.count {
            let dict = dictArray[i] as? [AnyHashable : Any]
            let color = dict?["color"] as? UIColor
            let font = dict?["font"] as? UIFont
            let text = textArray[i]
            let label: UILabel? = createLabel(with: font, textcolor: color)
            if text.count > 0 {
                label?.text = text
            }
            if let label = label {
                addSubview(label)
            }
            label?.frame = CGRect(x: 6, y: CGFloat(7 + i * (14 + 2)), width: 70, height: 14)
            bindLabel(label, index: i)
        }
    }
    
    func createLabel(with font: UIFont?, textcolor: UIColor?) -> UILabel? {
        let label = UILabel()
        if let font = font {
            label.font = font
        }
        if let textcolor = textcolor {
            label.textColor = textcolor
        }
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func setValueModel(_ valueModel: MinhourDataModel?) {
        self.valueModel = valueModel
        
        priceValueLabel!.text = GJCommonConfigHelper.valueCheck(valueModel?.last)
        updownValueLabel!.text = GJCommonConfigHelper.valueCheck(valueModel?.updown)
        updownRangeLabel!.text = GJCommonConfigHelper.valueCheck(valueModel?.percent)
        interestValueLabel!.text = GJCommonConfigHelper.valueCheck(valueModel?.interest)
        interestRangeLabel!.text = GJCommonConfigHelper.valueCheck(valueModel?.chgInterest)
        volumeValueLabel!.text = GJCommonConfigHelper.valueCheck(valueModel?.volume)
        averageValueLabel!.text = GJCommonConfigHelper.valueCheck(valueModel?.average)
        volumeRangeLabel!.text = GJCommonConfigHelper.valueCheck(valueModel?.chgVolume)
        
        updownValueLabel!.textColor = GJCommonConfigHelper.convertColor(withValue: updownValueLabel!.text)
        updownRangeLabel!.textColor = GJCommonConfigHelper.convertColor(withValue: updownRangeLabel!.text)
        interestRangeLabel!.textColor = GJCommonConfigHelper.convertColor(withValue: interestRangeLabel!.text)
        volumeRangeLabel!.textColor = GJCommonConfigHelper.convertColor(withValue: volumeRangeLabel!.text)
        
        //设置均线值颜色
        if (valueModel?.average == "- -") {
            averageValueLabel!.textColor = valueColor
        } else if (valueModel?.average == "0") {
            averageValueLabel!.textColor = valueColor
        } else {
            averageValueLabel!.textColor = UIColor(rgb: 0xEFD521)
        }
        let date = Date(timeIntervalSince1970: TimeInterval(valueModel?.ruleAt ?? 1000 / 1000))
        formatter?.dateFormat = "HH:mm"
        let dateStr = formatter?.string(from: date)
        dateLabel!.text = dateStr
    }
    
    func bindLabel(_ label: UILabel?, index: Int) {
        switch index {
        case 0:
            dateLabel = label
        case 1:
            priceNameLabel = label
        case 2:
            priceValueLabel = label
        case 3:
            averageNameLabel = label
        case 4:
            averageValueLabel = label
        case 5:
            updadownNameLabel = label
        case 6:
            updownValueLabel = label
        case 7:
            updownRangeLabel = label
        case 8:
            interestNameLabel = label
        case 9:
            interestValueLabel = label
        case 10:
            interestRangeLabel = label
        case 11:
            volumeNameLabel = label
        case 12:
            volumeValueLabel = label
        case 13:
            volumeRangeLabel = label
        default:
            break
        }
    }
}
