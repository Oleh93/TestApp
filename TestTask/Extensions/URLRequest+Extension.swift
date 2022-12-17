//
//  URLRequest+Extension.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 18.12.2022.
//

import Foundation

extension URLRequest {
    mutating func setHeaderKey(_ value: String?, header: HTTPHeadersKey) {
        setValue(value, forHTTPHeaderField: header.rawValue)
    }
}
