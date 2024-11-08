//
//  UserCreateItemsCell.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/07.
//

import Foundation
import UIKit

class UserCreateItemsCell:UITableViewCell {
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var LGTMCountLabel: UILabel!
    
    func initCell(title:String,createDate:String,tags:[Tag],LGTM:Int) {
        itemTitleLabel.text = title
        dateLabel.text = dateFormat(createDate:createDate)
        var tagStrArr = [String]()
        for tag in tags {
            tagStrArr.append(tag.name!)
        }
        tagLabel.text = tagStrArr.joined(separator: ",")
        LGTMCountLabel.text = String(LGTM)
    }
    
    func dateFormat(createDate:String) -> String {
        let formatter = DateFormatter()
        // 入力フォーマットを設定
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = formatter.date(from: createDate) {
            // 出力フォーマットを設定
            formatter.dateFormat = "yyyy/MM/dd"
            let formattedDateString = formatter.string(from: date)
            return formattedDateString
        } else {
            print("無効な日付文字列です")
        }
        return ""
        
    }
    
}
