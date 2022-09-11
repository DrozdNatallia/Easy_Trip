//
//  Date+Extension.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 11.09.22.
//

import Foundation
import UIKit

extension Date {
    func convertDateToString(formattedType: FormattedType) -> String {
        let formatted = DateFormatter()
        formatted.dateFormat = formattedType.description
        let formattedTime = formatted.string(from: self)
        return formattedTime
    }
}
