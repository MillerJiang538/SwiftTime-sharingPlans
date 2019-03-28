//
//  CommonConfigHelper.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/3/27.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

class GJCommonConfigHelper {
    class func valueCheck(_ value: String?) -> String? {
        if value == nil || (value == "-") || (value?.count ?? 0) == 0 {
            return "- -"
        }
        return value
    }
    
    /**
     根据value 返回颜色
     */
    class func convertColor(withValue value: String?) -> UIColor? {
        if (value == "--") {
            return UIColor(rgb: 0xE7EDF5)
        }
        if Float(value ?? "") ?? 0.0 > 0 {
            return UIColor(rgb: 0xFF5252)
        } else if Float(value ?? "") ?? 0.0 < 0 {
            return UIColor(rgb: 0x35CB6B)
        } else {
            return UIColor(rgb: 0xE7EDF5)
        }
    }
    
    /**
     日期补零
     */
    class func dateCheckZero(_ value: Int) -> String? {
        if value > 9 {
            return String(format: "%ld", value)
        }
        return String(format: "0%ld", value)
    }

    /**
     数据为空检查
     */
    class func checkResultDataIsNull(_ data: NSObject?) -> Bool {
        if (data is NSNull) || data == nil {
            return true
        }
        if (data is String) {
            let str = data as? String
            if (str == "- -") || (str == "--") || (str == "-") {
                return true
            }
        }
        return false
    }

    /**
     string 转 json
     */
    class func stringToJson(with jsonString: String?) -> [AnyHashable : Any]? {
        if GJCommonConfigHelper.checkResultDataIsNull(jsonString! as NSObject) {
            return nil
        }
        let data: Data? = jsonString?.data(using: .utf8)
        var _: Error?
        var jsonDict: [AnyHashable : Any]? = nil
        if let data = data {
            jsonDict = try! JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any]
        }
        return jsonDict
    }
    
    
    /**
     返回数据判空
     */
    
    class func checkResponseDataIsNull(_ data: NSObject?) -> Bool {
        if (data is NSNull) || data == nil {
            return true
        }
        return false
    }
    
    /**
     判断字典是否包含键
     */
    class func checkDictKey(withDict dict: [AnyHashable : Any]?, key: String?) -> Bool {
        if GJCommonConfigHelper.checkResponseDataIsNull(dict as! NSObject) {
            //字典是否为空
            return false
        }
        if GJCommonConfigHelper.checkResponseDataIsNull(key as! NSObject) {
            //key是否为空
            return false
        }
        if !(dict != nil) {
            //是否字典类
            return false
        }
        if dict?.keys.contains(key ?? "") ?? false {
            //是否包含key
            return true
        }
        return false
    }
}


