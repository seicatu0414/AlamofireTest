//
//  QiitaUserDetailViewModel.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/07.
//

import Foundation

class QiitaUserDetailViewModel {
    var searchUserInfo : SearchUser?
    var searchUserItemsInfo : [SearchUserItems]?
    var userFolloweesInfo : [SearchUserFollowee]?
    var userFollowersInfo : [SearchUserFollowers]?
    var iconData:Data?
    
    func getUserItemsSend(userId:String) async throws {
        do {
            searchUserItemsInfo = try await GetAPI().sendUserItemsApi(userId: "\(userId)")
        } catch Errors.decodingError {
            print("デコード失敗")
        } catch Errors.networkError(let statusCode) {
            throw Errors.networkError(statusCode)
        } catch {
            print("不明なエラー")
        }
    }
    
    
    func getIcon(url:String) async -> Data {
        do {
            let iconData = try await GetAPI().sendGetIconData(url: "\(url)")
            self.iconData = iconData
            return iconData
        } catch Errors.networkError(let statusCode) {
            print("\(statusCode)")
        } catch {
            print("不明なエラー")
        }
        return Data()
    }
    
    func getFolloweeSend(userId:String) async throws {
        do {
            userFolloweesInfo = try await GetAPI().sendFolloweesApi(userId: "\(userId)")
        } catch Errors.decodingError {
            print("デコード失敗")
        } catch Errors.networkError(let statusCode) {
            throw Errors.networkError(statusCode)
        } catch {
            print("不明なエラー")
        }
    }
    
    func getFollowerSend(userId:String) async throws {
        do {
            userFollowersInfo = try await GetAPI().sendFollowersApi(userId: "\(userId)")
        } catch Errors.decodingError {
            print("デコード失敗")
        } catch Errors.networkError(let statusCode) {
            throw Errors.networkError(statusCode)
        } catch {
            print("不明なエラー")
        }
    }
    
    // Coredataにエンティティユーザー情報を書き込み
    func wrightUserInfoFromCoreData()
    {
        guard let searchUserInfo = searchUserInfo else { return }
        guard let profileImageData = iconData else { return }
        let searchedUser = SearchedUser.init(id: searchUserInfo.id, name: searchUserInfo.name, profileImageData: profileImageData, followeesCount: searchUserInfo.followeesCount, followersCount: searchUserInfo.followersCount, lookDate: .now)
        do {
            try CoreDataModel().userInfoUpdate(containerName: "User", entity: searchedUser)
        } catch {
            print("書き込み失敗")
        }
    }
    
}
