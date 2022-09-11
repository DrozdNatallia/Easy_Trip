//
//  FormattedType.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 11.09.22.
//

import Foundation

enum FormattedType {
    case date
    case time
    
    var description: String {
        switch self {
         case .date:
             return "yyyy-MM-dd"
         case .time:
             return "yyyy-MM-dd'T'HH:mm"
         }
    }
}
