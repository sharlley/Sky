//
//  MockURLSessionDataTask.swift
//  SkyTests
//
//  Created by 夏忠胜 on 2019/1/24.
//  Copyright © 2019 MrXia. All rights reserved.
//

import Foundation
@testable import Sky

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var isResumeCalled = false
    
    func resume() {
        self.isResumeCalled = true
    }
}
