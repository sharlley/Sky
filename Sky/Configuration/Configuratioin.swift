//
//  Configuratioin.swift
//  Sky
//
//  Created by 夏忠胜 on 2019/1/23.
//  Copyright © 2019 MrXia. All rights reserved.
//

import Foundation

struct API {
    static let key = "d3d828fec84c0a0c5825250cf4716735"
    static let baseUrl = URL(string: "https://api.darksky.net/forecast")!
    static let authenticatedUrl = baseUrl.appendingPathComponent(key)
}
