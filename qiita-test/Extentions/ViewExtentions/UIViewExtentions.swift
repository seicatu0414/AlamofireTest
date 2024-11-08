//
//  UIViewExtentions.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/06.
//

import UIKit
extension UIView {
    // UIViewを丸くする
    func makeCircule() {
        self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height) / 2
        self.clipsToBounds = true
    }
}
