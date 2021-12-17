//
//  WebRequest.swift
//  Tutu_Test
//
//  Created by Павел Шатунов on 14.12.2021.
//

import Foundation
import Alamofire

struct WebRequest {
    var method: HTTPMethod
    var url: String
    var params: Parameters
}

extension WebRequest: CustomStringConvertible {
    
    var description: String {
        return "WebRequest: method \(method.rawValue), url: \(url), parameters: \(params)"
    }
}
