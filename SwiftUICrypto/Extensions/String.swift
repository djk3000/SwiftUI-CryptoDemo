//
//  String.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/21.
//

import Foundation


extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
