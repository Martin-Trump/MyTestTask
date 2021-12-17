//
//  SearchService.swift
//  Tutu_Test
//
//  Created by Павел Шатунов on 14.12.2021.
//

import Foundation
import Alamofire

final class SearchService {
    public typealias CompletionApps = (Result<[ITunesApp]>) -> Void
    
    private let networkManager = NetService()
    private let decoder = JSONDecoder()
    
    private let baseUrl = "https://itunes.apple.com/search"
    private let defaultRegionCode = "RU"
    
    private enum MediaType: String {
        case apps = "software"
    }
    
    private struct Parameter {
        static let query = "term"
        static let regionCode = "country"
        static let mediaType = "media"
    }
    
    public func getApps(forQuery query: String, then completion: CompletionApps?) {
        let regionCode = Locale.current.regionCode ?? defaultRegionCode
        var parameters: Parameters = [:]
        parameters[Parameter.query] = query
        parameters[Parameter.regionCode] = regionCode
        parameters[Parameter.mediaType] = MediaType.apps.rawValue
        
        let request = WebRequest(method: .get, url: baseUrl, params: parameters)
        
        networkManager.request(request) { [weak self] result in
            guard let self = self else {
                completion?(.success([]))
                return
            }
            result
                .withValue { data in
                    do {
                        let result = try self.decoder.decode(ITunesSearchResult<ITunesApp>.self, from: data)
                        let apps = result.results
                        completion?(.success(apps))
                    } catch {
                        print(error)
                        completion?(.failure(error))
                    }
                }
                .withError {
                    completion?(.failure($0))
                }
        }
    }
}
