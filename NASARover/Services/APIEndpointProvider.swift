//
//  APIEndpointProvider.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import Foundation

extension APIEndpointProvider {
    enum Config {
        case config
        
        var configName: String {
            switch self {
            case .config: return "Config"
            }
        }
    }
    
    enum Endpoint {
        case manifests(rover: Rovers)
        case photosByDate(date: Date, rover: Rovers, page: Int)
        case photosBySol(sol: Int, rover: Rovers, page: Int)
        
        var pathComponent: String {
            switch self {
            case .manifests: return "manifests"
            case .photosBySol: return "sol"
            case .photosByDate: return "earth_date"
            }
        }
    }
    
    enum Constants {
        case photos (rover: Rovers)
        case page
        
        var pathComponent: String {
            switch self {
            case .photos (let rover): return "rovers/\(rover.rawValue)/photos"
            case .page: return "page"
            }
        }
    }
}

final class APIEndpointProvider {
    
    let baseUrl: URL
    private let apiKey: String
    
    init(for config: Config) {
        var format = PropertyListSerialization.PropertyListFormat.xml
        guard let path = Bundle.main.path(forResource: config.configName, ofType: "plist"),
              let file = FileManager.default.contents(atPath: path),
              let configuration = try? PropertyListSerialization.propertyList(
                from: file,
                options: .mutableContainersAndLeaves,
                format: &format
              ) as? [String: Any] else {
            fatalError("\(config.configName).plist not found")
        }
        
        guard let configApiKey = configuration["apiKey"] as? String,
              let nasaAPI = configuration["nasaAPI"] as? [String: Any],
              let scheme = nasaAPI["scheme"] as? String,
              let host = nasaAPI["host"] as? String,
              let subDomain = nasaAPI["subDomain"] as? String,
              let apiVersion = nasaAPI["apiVersion"] as? String
        else {
            fatalError()
        }
        apiKey = configApiKey
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = subDomain + apiVersion
        baseUrl = urlComponents.url!
    }
    
    func getURL(for endpoint: Endpoint) -> URL {
        var url = baseUrl
        switch endpoint {
        case .manifests(let rover):
            url.append(path: "\(endpoint.pathComponent)/\(rover.rawValue)")
        case .photosByDate(let date, let rover, let page):
            url.append(path: "\(Constants.photos(rover: rover).pathComponent)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            url.append(queryItems: [URLQueryItem(name: endpoint.pathComponent, value: dateFormatter.string(from: date)),
                                    URLQueryItem(name: Constants.page.pathComponent, value: String(page))])
        case .photosBySol(let sol, let rover, let page):
            url.append(path: "\(Constants.photos(rover: rover).pathComponent)")
            url.append(queryItems: [URLQueryItem(name: endpoint.pathComponent, value: String(sol)),
                                    URLQueryItem(name: Constants.page.pathComponent, value: String(page))])
        }
        url.append(queryItems: [
            URLQueryItem(name: "api_key", value: apiKey)
        ])
        return url
    }
}
