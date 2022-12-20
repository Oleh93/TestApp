//
//  APIService.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 18.12.2022.
//

import Foundation

typealias CompletionWithData = (_ data: Data) -> Void
typealias CompletionWithError = (_ error: Error) -> Void
typealias CompletionWithDecodable<T: Decodable> = (T) -> Void

enum ResponseError: Error {
    case unknown
}

enum EncodeType: String {
    case json = "application/json"
}

enum HTTPHeadersKey: String {
    case contentType = "Content-Type"
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var pathParameters: [String: String] { get }
    var parameters: [String: Any] { get }
}

extension APIRequest {
    func createRequest(baseURL: URL, requestEncodeType: EncodeType) -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            fatalError("Unable to create URL components")
        }

        if !pathParameters.isEmpty {
            components.queryItems = pathParameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }

        guard let url = components.url else { fatalError("Failed to get url") }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setHeaderKey(requestEncodeType.rawValue, header: .contentType)

        if !parameters.isEmpty {
            switch requestEncodeType {
            case .json:
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        return request
    }
}

struct Results {
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?

    init(withData data: Data?, response: HTTPURLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    init(withError error: Error) {
        self.error = error
    }
}

protocol APIServiceProtocol {
    var baseUrl: String { get }

    func executeRequest(
        _ request: APIRequest,
        encodeType: EncodeType,
        success: @escaping CompletionWithData,
        failed: @escaping CompletionWithError
    )
}

// MARK: - APIService
final class APIService: APIServiceProtocol {
    var baseUrl: String { "https://jsonplaceholder.typicode.com/" }

    func executeRequest(
        _ request: APIRequest,
        encodeType: EncodeType,
        success: @escaping CompletionWithData,
        failed: @escaping CompletionWithError
    ) {
        let url = URL(string: baseUrl)!
        let urlRequest = request.createRequest(baseURL: url, requestEncodeType: encodeType)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let result = Results(withData: data, response: response as? HTTPURLResponse, error: error)
            switch result.response?.statusCode {
            case 200, 201, 202:
                guard let data = result.data else {
                    DispatchQueue.main.async { failed(ResponseError.unknown) }
                    return
                }
                DispatchQueue.main.async { success(data) }
            default:
                DispatchQueue.main.async { failed(ResponseError.unknown) }
            }
        }

        DispatchQueue.global(qos: .background).async { task.resume() }
    }
}
