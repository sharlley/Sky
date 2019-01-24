//
//  URLSession.swift
//  Sky
//
//  Created by 夏忠胜 on 2019/1/24.
//  Copyright © 2019 MrXia. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping DataTaskHandler)
        -> URLSessionDataTaskProtocol {
            return (dataTask(
                with: request,
                completionHandler: completionHandler)
                as URLSessionDataTask)
                as URLSessionDataTaskProtocol
    }
}
