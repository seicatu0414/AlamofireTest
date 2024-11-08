//
//  CoreDataStructs.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/06.
//

import Foundation

// 過去にサーチしたユーザー情報
struct SearchedUser {
    let id: String?
    let name: String?
    let profileImageData: Data?
    let followeesCount: Int?
    let followersCount: Int?
    let lookDate:Date?
    init(id: String?, name: String?, profileImageData: Data?, followeesCount: Int?, followersCount: Int?, lookDate: Date?) {
        self.id = id
        self.name = name
        self.profileImageData = profileImageData
        self.followeesCount = followeesCount
        self.followersCount = followersCount
        self.lookDate = lookDate
    }
}
