//
//  URLSessionProtocol.swift
//  Sky
//
//  Created by 夏忠胜 on 2019/1/24.
//  Copyright © 2019 MrXia. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol
}
