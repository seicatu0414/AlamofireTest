//
//  QiitaMainViewModel.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/01.
//

import Foundation

class QiitaMainViewModel {
    var searchUserInfo : SearchUser? = nil
    var searchedUserInfo : [SearchedUser]? = nil
    
    func getAPISend(userId:String) async throws {
        do {
            searchUserInfo = try await GetAPI().sendUserApi(userId: "\(userId)")
        } catch Errors.networkError(let statusCode) {
            throw Errors.networkError(statusCode)
        } catch {
            print("不明なエラー")
        }
    }
    // Coredataのエンティティユーザーの情報呼び出し
    func readUserInfoFromCoreData()
    {
        do {
            searchedUserInfo = try CoreDataModel().searchUserRead()
        } catch {
            print("読み込み失敗")
        }
    }
}
