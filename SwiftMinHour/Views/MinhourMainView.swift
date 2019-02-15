//
//  MinhourMainView.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/2/13.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

class MinhourMainView: UIView {
    
    var dataArray:Array<MinhourDataModel>?
    
    var valueLabelArray = Array<UILabel>()
    
    var percentLabelArray = Array<UILabel>()

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        if self.dataArray == nil {
            context.clear(rect)
            context.setFillColor(UIColor(rgb: 0x2A2D4F).cgColor)
            context.fill(rect)
            return;
        }

        context.clear(rect)
        context.setFillColor(UIColor(rgb: 0x2A2D4F).cgColor)
        context.fill(rect)
        
        //分时线
        let color = UIColor.white
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(0.8)
        var isEnd = false
        for i in 0 ..< self.dataArray!.count {
            let model = self.dataArray?[i]
            let point = model?.point
            if point?.y == -1 {
                if isEnd {
                    isEnd = false
                    context.strokePath()
                }
                continue
            }
            if isEnd {
                context.addLine(to: point!)
            }else {
                context.move(to: point!)
                isEnd = true
            }
        }
        context.strokePath()
        
        //均线
        let averageColor = UIColor(rgb: 0xEFD521)
        context.setStrokeColor(averageColor.cgColor)
        context.setLineWidth(0.8)
        isEnd = false
        for i in 0 ..< self.dataArray!.count {
            let model = self.dataArray?[i]
            let point = model?.averagePoint
            if point?.y == -1 {
                if isEnd {
                    isEnd = false
                    context.strokePath()
                }
                continue
            }
            if isEnd {
                context.addLine(to: point!)
            }else {
                context.move(to: point!)
                isEnd = true
            }
        }
        context.strokePath()
    }
    
    func setUpSubViews() {
        let navHeight = CommonMacro.navigationBarHeight()
        let verSpace = (UIScreen.main.bounds.width - 19*2 - 6)/5
        let horSpace = ((UIScreen.main.bounds.height - navHeight)*0.75 - 8)/7
        
        //绘制竖线
        for i in 0 ..< 6 {
            let verLineView = UIView()
            verLineView.backgroundColor = UIColor(rgb: 0xFFFFFF, a: 0.05)
            self.addSubview(verLineView)
            verLineView.snp.makeConstraints { (make) -> Void in
                make.top.bottom.equalTo(self)
                make.width.equalTo(1);
                make.left.equalTo(self.snp.left).offset(19+CGFloat(i)*(1+verSpace))
            }
        }
        
        //绘制横线
        for i in 0 ..< 8 {
            let horLineView = UIView()
            horLineView.backgroundColor = UIColor(rgb: 0xFFFFFF, a: 0.05)
            self.addSubview(horLineView)
            horLineView.snp.makeConstraints { (make) -> Void in
                make.left.right.equalTo(self)
                make.height.equalTo(1);
                make.top.equalTo(self.snp.top).offset(CGFloat(i)*(1+horSpace))
            }
        }
        
        let logo = UILabel()
        logo.textColor = UIColor(rgb: 0xFFFFFF, a: 0.05)
        logo.text = "jiang"
        logo.font = UIFont.boldSystemFont(ofSize: 80)
        self.addSubview(logo)
        logo.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
        
        let valueSpace = ((UIScreen.main.bounds.height - navHeight)*0.75 - 2 - 5*12)/4
        let valueText = ["200","150","100","50","0"]
        let percentText = ["+100.00%","+50.00%","0","-50.00%","-100.00%"]
        for i in 0 ..< 5 {
            let valueLabel = UILabel.init(frame: CGRect(x: 8, y: 1+CGFloat(i)*(valueSpace+12), width: 40, height: 12))
            valueLabel.font = UIFont.systemFont(ofSize: 11)
            valueLabel.textAlignment = NSTextAlignment.left
            valueLabel.adjustsFontSizeToFitWidth = true
            self.addSubview(valueLabel)
            self.valueLabelArray.append(valueLabel)
            
            let percentLabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width-8-50, y: 1+CGFloat(i)*(valueSpace+12), width: 50, height: 12))
            percentLabel.font = UIFont.systemFont(ofSize: 11)
            percentLabel.textAlignment = NSTextAlignment.right
            percentLabel.adjustsFontSizeToFitWidth = true
            self.addSubview(percentLabel)
            self.percentLabelArray.append(percentLabel)
            if i == 2 {
                valueLabel.textColor = UIColor(rgb: 0x6A798E)
                percentLabel.textColor = UIColor(rgb: 0x6A798E)
            } else if i > 2 {
                valueLabel.textColor = UIColor(rgb: 0x3EB86A)
                percentLabel.textColor = UIColor(rgb: 0x3EB86A)
            } else {
                valueLabel.textColor = UIColor(rgb: 0xF27A68)
                percentLabel.textColor = UIColor(rgb: 0xF27A68)
            }
            valueLabel.text = valueText[i]
            percentLabel.text = percentText[i]
        }

    }
    
    //更新Y轴
    func updateyValue(dict:Dictionary<String, Array<String>>) {
        let leftArray = dict["left"]
        let rightArray = dict["right"]
        for i in 0 ..< 5 {
            let leftLabel = self.valueLabelArray[4-i]
            let rightLabel = self.percentLabelArray[4-i]
            let value = leftArray?[i]
            let percent = rightArray?[i]
            leftLabel.text = value
            rightLabel.text = percent
        }
    }
    
}
