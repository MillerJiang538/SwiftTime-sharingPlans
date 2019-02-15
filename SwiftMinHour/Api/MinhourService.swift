//
//  MinhourService.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/2/13.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

class MinhourService: NSObject {
    class func minhourDataApi() -> String {
        return "/rest/future/getMinutes"
    }
}
