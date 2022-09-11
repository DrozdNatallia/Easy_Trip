//
//  String+Extension.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 11.09.22.
//

import Foundation
import UIKit
// по поводу этой конвертации. Не получается здесь сразу вл время. Изначально, я получаю ISO формат, но там таймзона. Т покопавшись в интеренете, я не нашла, как это убрать, плэтому просто в строке убираю элементы, и конвертирую в дату уже в другом формате, а уже потом забираю часы.
extension String {
  func convertDateFromIsoToTime() -> String {
        let newDate = self.dropLast(6)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let convertDate = dateFormatter.date(from: String(newDate))
        if let convertDate = convertDate {
            dateFormatter.dateFormat =  "HH:mm"
            let res = dateFormatter.string(from: convertDate)
            return res
        }
        return ""
    }
    
    func convertStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let newDate = dateFormatter.date(from: self) else { return Date()}
        return newDate
    }
}
