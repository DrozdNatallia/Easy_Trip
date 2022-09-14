//
//  Int+Extension.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.09.22.
//

import Foundation

extension Int {
    func minToTime() -> String {
        let (h, m) = (self / 60,  self % 60)
        let hStr = h < 10 ? "0\(h)" : "\(h)"
        let mStr = m < 10 ? "0\(m)" : "\(m)"
        
        return "\(hStr):\(mStr)"
    }
}
