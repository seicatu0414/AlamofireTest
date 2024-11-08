//
//  Enums.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/01.
//

enum Urls:String {
    case MainUrl = "https://qiita.com/api/v2/users/"
    case Items = "/items"
    case Followees = "/followees"
    case Followers = "/followers"
}

enum Errors: Error {
    case decodingError
    case networkError(Int)
    case castError
    case coreDataReadError
    case coreDataWriteError
    case containersError
}
