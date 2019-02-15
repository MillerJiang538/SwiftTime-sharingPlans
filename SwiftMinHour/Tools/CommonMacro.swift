//
//  CommonMacro.swift
//  SwiftMinHour
//
//  Created by Miller on 2019/2/14.
//  Copyright © 2019 Miller. All rights reserved.
//

import UIKit

class CommonMacro {
    class func navigationBarHeight() -> CGFloat {
        if UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896 { //x系列
            return 88
        }
        return 64
    }
}
