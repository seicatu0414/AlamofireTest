//
//  UIImageExtentions.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/06.
//

import Foundation
import UIKit

extension UIImage {
    // imageをDataに変換
    func imageToBainary(image:UIImage) throws -> Data {
        guard let imageData = self.pngData() ?? self.jpegData(compressionQuality: 1.0) else {
            return Data()
        }
        return imageData
    }
}
