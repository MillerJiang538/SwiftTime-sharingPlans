//
//  MinhourViewModel.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/2/13.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

//声明闭包
typealias requestCallback = (_ jsonData : JSON) -> Void

class MinhourViewModel: NSObject {
    func requestMinHourData(contract:String,callback:@escaping requestCallback) {
        let url = MinhourService.minhourDataApi()
        let parameters: Parameters = ["contract":contract,"preIndex":0]
        Alamofire.request("https://liveapp.shmet.com/mapi"+url,parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                let minhourJson = JSON(json)
                callback(minhourJson)
            }
        }
    }
}
