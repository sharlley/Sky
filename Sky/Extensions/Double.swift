//
//  Double.swift
//  Sky
//
//  Created by 夏忠胜 on 2019/1/25.
//  Copyright © 2019 MrXia. All rights reserved.
//

import Foundation

extension Double {
    func toCelcius() -> Double {
        return (self - 32.0) / 1.8
    }
}
