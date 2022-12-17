//
//  CommentsAPI.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 18.12.2022.
//

import Foundation

struct CommentsRequest: APIRequest {
    var method: RequestType = .get
    var path: String = "comments/"
    var pathParameters: [String: String] = [:]
    var parameters: [String: Any] = [:]

    init(commentId: Int) {
        path += "\(commentId)"
    }
}

protocol CommentsAPIProtocol {
    func getComments(
        commentId: Int,
        success: @escaping CompletionWithDecodable<CommentResponse>,
        failed: @escaping CompletionWithError
    )
}

final class CommentsAPI: CommentsAPIProtocol {
    private let apiService: APIServiceProtocol = APIService()

    func getComments(
        commentId: Int,
        success: @escaping CompletionWithDecodable<CommentResponse>,
        failed: @escaping CompletionWithError
    ) {
        var request = CommentsRequest(commentId: commentId)
        apiService.executeRequest(
            request,
            encodeType: .json,
            success: { data in
                do {
                    let response = try JSONDecoder().decode(CommentResponse.self, from: data)
                    success(response)
                } catch let error {
                    failed(error)
                }
            },
            failed: { failed($0) }
        )
    }
}
