//
//  WeatherDataManagerTest.swift
//  SkyTests
//
//  Created by 夏忠胜 on 2019/1/23.
//  Copyright © 2019 MrXia. All rights reserved.
//

import XCTest
@testable import Sky

class WeatherDataManagerTest: XCTestCase {
    let url = URL(string: "https://darksky.net")!
    var session: MockURLSession!
    var manager: WeatherDataManager!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        session = MockURLSession()
        manager = WeatherDataManager(baseURL: url, urlSession: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_weatherDataAt_starts_the_session() {
        let dataTask = MockURLSessionDataTask()
        session.sessionDataTask = dataTask
        
        let manager = WeatherDataManager(baseURL: url, urlSession: session)
        manager.weatherDataAt(latitude: 520, longitude: 100) { (_, _) in
            
        }
        
        XCTAssert(session.sessionDataTask.isResumeCalled)
    }

    
    // 测试可以正确的处理请求错误
    func test_weatherDataAt_handle_invalid_request() {
        session.responseError = NSError(
            domain: "Invalid Request",
            code: 100,
            userInfo: nil)
        
        var error: DataManagerError? = nil
        manager.weatherDataAt(
            latitude: 52,
            longitude: 100,
            completion: {
                (_, e) in
                error = e
        })
        
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    // 测试可以正确处理服务器返回的状态码
    func test_weatherDataAt_handle_statuscode_not_equal_to_200() {
        session.responseHeader = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let data = "{}".data(using: .utf8)!
        session.responseData = data
        
        var error: DataManagerError? = nil
    
        manager.weatherDataAt(latitude: 50, longitude: 100) { (_, e) in
            error = e
        }
        
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    // 测试服务器返回的内容不正确
    func test_weatherDataAt_handle_invalid_response() {
        session.responseHeader = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let data = "{}".data(using: .utf8)!
        session.responseData = data
        
        var error: DataManagerError? = nil
        
        
        manager.weatherDataAt(latitude: 50, longitude: 100) { (_, e) in
            error = e
        }
        
        XCTAssertEqual(error, DataManagerError.invalidResponse)
    }
    
    // 测试可以正确解码服务器返回值
    func test_weatherDataAt_handle_response_decode() {
        session.responseHeader = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        
        let data = """
    {
        "longitude" : 100,
        "latitude" : 52,
        "currently" : {
            "temperature" : 23,
            "humidity" : 0.91,
            "icon" : "snow",
            "time" : 1507180335,
            "summary" : "Light Snow"
        }
    }
    """.data(using: .utf8)!
       
        session.responseData = data
        var decoded: WeatherData? = nil
        
        manager.weatherDataAt(
            latitude: 52,
            longitude: 100,
            completion: {
                (d, _) in
                decoded = d
        })
        
        let expected = WeatherData(
            latitude: 52,
            longitude: 100,
            currently: WeatherData.CurrentWeather(
                time: Date(timeIntervalSince1970: 1507180335),
                summary: "Light Snow",
                icon: "snow",
                temperature: 23,
                humidity: 0.91))
        
        XCTAssertEqual(decoded, expected)
    }
    
}
