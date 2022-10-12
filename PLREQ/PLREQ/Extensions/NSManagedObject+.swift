//
//  NSManagedObject+.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/11.
//

import CoreData

// CoreData에서 원하는 데이터를 변환할 때 사용하는 extension
extension NSManagedObject {
    
    func dataToString(forKey: String) -> String {
        return self.value(forKey: forKey) as? String ?? "정보를 불러올 수 없습니다."
    }
    
    func dataToURL(forKey: String) -> URL {
        return self.value(forKey: forKey) as? URL ?? URL(string:"http://t1.daumcdn.net/thumb/R600x0/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fqna%2Fimage%2F4b035cdf8372d67108f7e8d339660479dfb41bbd")!
    }
    
    func dataToDate(forKey: String) -> Date {
        return self.value(forKey: forKey) as? Date ?? Date()
    }
    
    func dataToFloat(forKey: String) -> Float {
        return self.value(forKey: forKey) as? Float ?? 0
    }
}
