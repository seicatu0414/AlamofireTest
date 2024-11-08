//
//  UserFollowerCellViewModel.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/08.
//

import Foundation
class UserFollowerCellViewModel {
    func getIcon(url:String) async -> Data {
        do {
            let iconData = try await GetAPI().sendGetIconData(url: "\(url)")
            return iconData
        } catch Errors.networkError(let statusCode) {
            print("通信失敗:ステータスコード\(statusCode)")
        } catch {
            print("不明なエラー")
        }
        return Data()
    }
}
