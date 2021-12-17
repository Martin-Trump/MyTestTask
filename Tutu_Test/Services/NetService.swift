//
//  NetService.swift
//  Tutu_Test
//
//  Created by Павел Шатунов on 14.12.2021.
//

import Foundation
import Alamofire

final class NetService {
    
    public func request(_ request: WebRequest, completion: ((Result<Data>) -> Void)?) {
        Alamofire.request(request.url, method: request.method, parameters: request.params).validate().responseData { [weak self] response in
            response.result
                .withValue { data in
                    completion?(.success(data))
                }
                .withError {
                    self?.logError($0, request: request)
                    completion?(.failure($0))
                }
        }
    }
    
    public func jsonRequest(_ request: WebRequest, completion: ((Result<[String:Any]?>) -> Void)?) {
        Alamofire.request(request.url, method: request.method, parameters: request.params).validate().responseJSON { [weak self] response in
            response.result
                .withValue { json in
                    completion?(.success(json as? [String:Any]))
                }
                .withError {
                    self?.logError($0, request: request)
                    completion?(.failure($0))
                }
        }
    }
    
    private func logError(_ error: Error, request: WebRequest) {
        print("Error while executing request \(request.url), error: \(error.localizedDescription)")
    }

}
