//
//  MinhourIndexView.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/2/13.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class MinhourIndexView: UIView {
    
    let disposeBag = DisposeBag()

    var dataArray:Array<MinhourCJLModel>?

    var cjlLineModelArray:Array<MinhourCJLLineModel>?

    let nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor(rgb: 0xD4975C)
        nameLabel.font = UIFont.systemFont(ofSize: 11)
        nameLabel.text = "CJL"
        return nameLabel
    }()

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        if self.dataArray == nil {
            return
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineWidth(0.5)
        for i in 0 ..< self.dataArray!.count {
            let model = self.dataArray?[i]
            if model?.startPoint?.y == -1.0 {
                continue
            }
            context.setStrokeColor(model?.columnColor?.cgColor ?? UIColor.white.cgColor)
            context.strokeLineSegments(between: [(model?.startPoint)!,(model?.endPoint)!])
        }
        
        //持仓量
        let averageColor = UIColor(rgb: 0xEFD521)
        context.setStrokeColor(averageColor.cgColor)
        context.setLineWidth(0.8)
        var isEnd = false
        for i in 0 ..< self.cjlLineModelArray!.count {
            let model = self.cjlLineModelArray?[i]
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
    }
    
    func setUpSubViews() {
        let navHeight = CommonMacro.navigationBarHeight()
        let verSpace = (UIScreen.main.bounds.width - 19*2 - 6)/5
        let horSpace = ((UIScreen.main.bounds.height - navHeight)*0.25 - 5 - 20*2)/4
        //绘制竖线
        for i in 0 ..< 6 {
            let verLineView = UIView()
            verLineView.backgroundColor = UIColor(rgb: 0xFFFFFF, a: 0.05)
            self.addSubview(verLineView)
            verLineView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(20)
                make.bottom.equalTo(self).offset(-20)
                make.width.equalTo(1);
                make.left.equalTo(self.snp.left).offset(19+CGFloat(i)*(1+verSpace))
            }
        }
        
        //绘制横线
        for i in 0 ..< 5 {
            let horLineView = UIView()
            horLineView.backgroundColor = UIColor(rgb: 0xFFFFFF, a: 0.05)
            self.addSubview(horLineView)
            horLineView.snp.makeConstraints { (make) -> Void in
                make.left.right.equalTo(self)
                make.height.equalTo(1);
                make.top.equalTo(self.snp.top).offset(20+CGFloat(i)*(1+horSpace))
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
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(8)
            make.top.equalToSuperview().offset(4)
        }
        
        self.addTapGesture()
    }
    
    //增加tap手势
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.bind(onNext: { recognizer in
            if self.nameLabel.text == "CJL" {
                self.nameLabel.text = "MACD"
            }else {
                self.nameLabel.text = "CJL"
            }
        }).disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    
    //绘制分时线的x轴
    func drawMinhourDateOriginX(dateArray:Array<Dictionary<String, String>>) {
        let navHeight = CommonMacro.navigationBarHeight()
        let indexWidth = UIScreen.main.bounds.width
        let indexHeight = (UIScreen.main.bounds.height - navHeight)*0.25 - 20
        for i in 0 ..< dateArray.count {
            let dict = dateArray[i]
            let date = Date.init(timeIntervalSince1970:Double(dict["date"]!)!/1000.0)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let dateStr = formatter.string(from: date)
            let x = Float(dict["position"]!)!
            var drawDatePoint = CGPoint(x: 0, y: 0)
            if CGFloat(x + 30) > indexWidth {
                drawDatePoint = CGPoint(x: CGFloat(x - 15), y: indexHeight+8)
            }else if x < 30 {
                drawDatePoint = CGPoint(x: CGFloat(x + 15), y: indexHeight+8)
            }else {
                drawDatePoint = CGPoint(x: CGFloat(x - 15), y: indexHeight+8)
            }
            let label = UILabel()
            label.text = dateStr
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textColor = UIColor(rgb: 0x6A798E)
            label.textAlignment = NSTextAlignment.center
            self.addSubview(label)
            label.frame.size.height = 11
            label.frame.size.width = 30
            label.center = drawDatePoint
        }
    }
}
