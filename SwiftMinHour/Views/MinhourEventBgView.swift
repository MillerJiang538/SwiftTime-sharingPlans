//
//  MinhourEventBgView.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/3/27.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class MinhourEventBgView: UIView {

    let detailValueView : MinhourDetailValueView = {
        let detailValueView = MinhourDetailValueView.init(frame: CGRect.zero)
        return detailValueView
    }()

    let slideLineView : UIView = {
        let slideLineView = UIView.init(frame: CGRect.zero)
        slideLineView.backgroundColor = UIColor(rgb: 0x6774FF)
        return slideLineView
    }()
    
    var minhourHelper : MinhourDataHelper?

    var dataArray:Array<MinhourDataModel>?

    let disposeBag = DisposeBag()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpSubViews() {
        self.addSubview(detailValueView)
        detailValueView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize.init(width: 78, height: 236))
        }
        
        self.addSubview(slideLineView)
        slideLineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp_bottomMargin).offset(-20)
            make.left.equalTo(self.snp_leftMargin).offset(1)
            make.width.equalTo(1)
        }
        
        self.addTapGesture()
    }
    
    //增加tap手势
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.bind(onNext: { recognizer in
            self.isHidden = true
        }).disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    
    func slideVerticalLinePoint(point: CGPoint) {
        self.slideLineView.snp.updateConstraints { (make) in
            make.left.equalTo(self.snp_leftMargin).offset(point.x)
        }
        let xDateDict = self.minhourHelper?.xDateDict
        let dateWidth = xDateDict?["dateWidth"]
        let dateFloat = Float(dateWidth!)
        let modeIndex = Float(point.x) / dateFloat!
        if Int(modeIndex) >= self.dataArray?.count ?? 0 {
            return
        }
        let model = self.dataArray?[Int(modeIndex)]
        self.detailValueView.setValueModel(model)
        
        let width = UIScreen.main.bounds.width
        if point.x > width/2 {//滑动到右边
            if self.detailValueView.locationType == .right {
                if point.x >= width - 20 - 78 {//移动到左边
                    self.detailValueView.snp.remakeConstraints { (make) in
                        make.left.top.equalToSuperview().offset(10)
                        make.size.equalTo(CGSize.init(width: 78, height: 236))
                    }
                    self.detailValueView.locationType = .left
                }
            }
        }else {//滑动到左边
            if self.detailValueView.locationType == .left {
                if point.x <=  20 + 78 {//移动到右边
                    self.detailValueView.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview().offset(10)
                        make.right.equalToSuperview().offset(-10)
                        make.size.equalTo(CGSize.init(width: 78, height: 236))
                    }
                    self.detailValueView.locationType = .right
                }
            }
        }
    }
}
