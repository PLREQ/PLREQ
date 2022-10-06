//
//  Date+.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/07.
//

import Foundation

extension Date {
    func toYMDString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let string = dateFormatter.string(from: date)
        return string
    }
}
