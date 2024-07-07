//
//  AppError.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import Foundation

struct APIErrorResponse: Decodable {
    let error: APIError
}

struct APIError: Decodable {
    let code: Int
    let message: String
}
