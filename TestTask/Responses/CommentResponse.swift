//
//  CommentResponse.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 18.12.2022.
//

import Foundation

struct CommentResponse: Decodable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
