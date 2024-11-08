//
//  SearchedUserCell.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/06.
//

import Foundation
import UIKit

class SearchedUserCell:UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followeesCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    var userId:String = ""
    func cellInit(profileImageData: Data?,
                  userName: String?,
                  followeesCount: Int?,
                  followersCount: Int?,
                  userId:String?) {
        // データがないときはNoImageを返す
        var image:UIImage = UIImage(named: "NoImage")!
        if let profileImageData = profileImageData {
            image = UIImage(data: profileImageData)!
        }
        guard let userName = userName else { return }
        guard let followeesCount = followeesCount else { return }
        guard let followersCount = followersCount else { return }
        guard let userId = userId else { return }
        self.profileImageView.image = image
        // ImageViewを丸くする
        self.profileImageView.makeCircule()
        self.userNameLabel.text = userName
        self.followeesCountLabel.text = String(followeesCount)
        self.followersCountLabel.text = String(followersCount)
        self.userId = userId
    }
}
