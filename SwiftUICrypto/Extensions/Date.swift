//
//  Date.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/21.
//

import Foundation

extension Date {
    
    //2021-11-10T14:24:11.849Z
    init(coinString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
