//
//  Date+.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/07.
//

import Foundation

extension Date {
    // 날짜 데이터를 "yyyy년 MM월 dd일"의 형태의 문자열로 변환
    func toYMDString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let string = dateFormatter.string(from: date)
        return string
    }
}
