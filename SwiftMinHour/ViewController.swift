//
//  ViewController.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/2/13.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let mainView : MinhourMainView = {
        let mainView = MinhourMainView()
        mainView.backgroundColor = UIColor(rgb: 0x2A2D4F)
        return mainView
    }()
    
    let indexView : MinhourIndexView = {
        let indexView = MinhourIndexView()
        indexView.backgroundColor = UIColor(rgb: 0x2A2D4F)
        return indexView
    }()
    
    let minhourViewModel = MinhourViewModel()
    
    var minhourHelper : MinhourDataHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "沪铜1903";
        print("success")
        self.setUpSubViews()
        self.loadMinhourData()
    }
    
    //UI布局
    func setUpSubViews() {
        let navHeight = CommonMacro.navigationBarHeight()
        let visiHeight = UIScreen.main.bounds.height - navHeight
        self.view.addSubview(mainView)
        mainView.setUpSubViews()
        mainView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(visiHeight*0.75)
        }
        self.view.addSubview(indexView)
        indexView.setUpSubViews()
        indexView.snp.makeConstraints { (make) -> Void in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(mainView.snp.bottom)
        }
    }
    
    //请求分时数据
    func loadMinhourData() {
        //创建loading框
        let loading = UIActivityIndicatorView()
        loading.color = UIColor.white
        self.view.addSubview(loading)
        loading.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.center.equalToSuperview()
        }
        //沪铜03
        loading.startAnimating()
        minhourViewModel.requestMinHourData(contract: "CU03",callback: { (json) in
            loading.stopAnimating()
            loading.removeFromSuperview()
            let minhourArray = json["data"]["minuteDatas"].arrayValue
            var modelArray = Array<MinhourDataModel>()
            let count = minhourArray.count
            for i in 0 ..< count {
                let modelJson = minhourArray[i]
                let model = MinhourDataModel.init(jsonData: modelJson)
                modelArray.append(model)
            }
            self.minhourHelper = MinhourDataHelper.init(dataArray: modelArray, averagePre: json["data"]["preSettle"].stringValue)
            self.minhourHelper?.setUpTotalRanges(ranges: json["data"]["tradeRanges"].arrayValue)
            self.mainView.dataArray = self.minhourHelper?.convertPositionModelFromMinHourModels()
            self.mainView.setNeedsDisplay()
            self.mainView.updateyValue(dict: self.minhourHelper?.calculateMinHourYvalue() ?? ["":[""]])
            
            self.indexView.dataArray = self.minhourHelper?.convertCJLPositionModel()
            self.indexView.cjlLineModelArray = self.minhourHelper?.cjlLineModelArray
            self.indexView.drawMinhourDateOriginX(dateArray: self.minhourHelper!.calculateXdate())
            self.indexView.setNeedsDisplay()
        })
    }
}

