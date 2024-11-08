//
//  CoreDataModel.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/02.
//
import CoreData

class CoreDataModel {
    /// コンテナからUserエンティティを読み込みSearchUser配列群として返す
    func searchUserRead() throws -> [SearchedUser] {
        guard let container = searchContainer(containerName: "User") else { return [] }
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map {
                SearchedUser(id: $0.id,
                             name: $0.name,
                             profileImageData: $0.profileImage,
                             followeesCount: Int($0.followeesCount),
                             followersCount: Int($0.followersCount),
                             lookDate:$0.lookDate)
            }
        } catch {
            throw Errors.coreDataReadError
        }
    }
    
    /// 指定されたSearchedUsertの情報を使用してUserエンティティを更新、または新規追加
    func userInfoUpdate(containerName:String, entity:SearchedUser) throws {
        guard let container = searchContainer(containerName:containerName) else { return }
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        guard let id = entity.id else { return }
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                // 新たに作成
                let newUseredInfo = User(context: context)
                newUseredInfo.id = entity.id
                newUseredInfo.name = entity.name
                newUseredInfo.followeesCount = Int32(entity.followeesCount!)
                newUseredInfo.followersCount = Int32(entity.followersCount!)
                newUseredInfo.lookDate = entity.lookDate
            } else {
                // 一致した場合更新
                for result in results {
                    result.id = entity.id
                    result.name = entity.name
                    result.profileImage = entity.profileImageData
                    result.followeesCount = Int32(entity.followeesCount!)
                    result.followersCount = Int32(entity.followersCount!)
                    result.lookDate = entity.lookDate
                }
            }
            try context.save()
        } catch {
            throw Errors.coreDataWriteError
        }
    }
    
    /// 指定された名前の永続コンテナを検索しそれを返す
    private func searchContainer(containerName:String) -> NSPersistentContainer? {
        let container: NSPersistentContainer
        if containerName == "User" {
            container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores(completionHandler: {_,error in
                if (error as NSError?) != nil {
                    fatalError("User情報取得の失敗")
                }
            })
            
        } else {
            fatalError("containerNameの間違い")
        }
        return container
    }
}
