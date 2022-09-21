//
//  UIApplication.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/13.
//

import Foundation
import SwiftUI

extension UIApplication{
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
