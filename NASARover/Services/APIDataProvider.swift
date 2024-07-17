//
//  APIDataProvider.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import Foundation
import Alamofire
import Combine

enum AppError: Error, Decodable {
    case connectivityError
    case decodeJSONfailed
    case apiError(APIError)
    case networkError
    case other(_ error: String? = nil)
    case unknown
    
    var description: String {
        switch self {
        case .connectivityError: return "Connectivity Error"
        case .decodeJSONfailed: return "Decode JSON failed"
        case .apiError(let apiError): return apiError.message
        case .networkError: return "Network Error"
        case .other(let error): return error ?? "Unknown Error"
        case .unknown: return "Unknown Error"
        }
    }
}

final class APIDataProvider {
    private let endpointProvider = APIEndpointProvider(for: .config)
    
    func getData<T: Decodable>(for endpoint: APIEndpointProvider.Endpoint, completion: @escaping (T) -> Void?,
                               errorHandler: @escaping (AppError) -> Void?){
        let url = endpointProvider.getURL(for: endpoint)
        
        AF.request(url)
            .response {response in
                switch response.result {
                case .success(let data):
                    guard let data,
                          let statusCode = response.response?.statusCode else {
                        errorHandler(AppError.networkError)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    DispatchQueue.main.async {
                        if (200...299) ~= statusCode {
                            do {
                                let object = try decoder.decode(T.self, from: data)
                                completion(object)
                            } catch {
                                errorHandler(.decodeJSONfailed)
                            }
                        } else {
                            do {
                                let error = try decoder.decode(APIError.self,
                                                               from: data)
                                errorHandler(.apiError(error))
                            } catch {
                                errorHandler(.unknown)
                            }
                        }
                    }
                case .failure(let error):
                    errorHandler(.other(error.localizedDescription))
                }
            }
    }
    
    func request<T: Decodable>(for endpoint: APIEndpointProvider.Endpoint) -> AnyPublisher<T, AppError> {
        return URLSession.shared
            .dataTaskPublisher(for: endpointProvider.getURL(for: endpoint))
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .mapError{ _ in .connectivityError }
            .flatMap { data, response -> AnyPublisher<T, AppError> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let response = response as? HTTPURLResponse {
                    if (200...299) ~= response.statusCode {
                        return Just(data)
                            .decode(type: T.self, decoder: decoder)
                            .mapError { error in .decodeJSONfailed }
                            .eraseToAnyPublisher()
                    } else {
                        do {
                            let errorResponse = try decoder.decode(APIErrorResponse.self, from: data)
                            return Fail(error: .apiError(errorResponse.error))
                                .eraseToAnyPublisher()
                        } catch {
                            return Fail(error: .decodeJSONfailed)
                                .eraseToAnyPublisher()
                        }
                    }
                }
                return Fail(error: .unknown)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
