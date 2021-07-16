//
//  DateHelper.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/15.
//

import Foundation

class DateHelper {
    // - 함수 실행 getDatesBetweenTwo(from: "2021-07-14",to: "2021-07-20")
    // - 배열 반환 ["2021-07-14", ""2021-07-15", ""2021-07-16", ..., "2021-07-20"]
    static func getDatesBetweenTwo(from startDate: String, to date: String) -> [String] {
        Formatter.date.dateFormat = "yyyy-MM-dd"
        
        // 시작 날짜와 끝 날짜를 date 형식으로 변환
        guard var startDate = Formatter.date.date(from: startDate) else { return [] }
        guard let endDate = Formatter.date.date(from: date) else { return [] }
        
        var dates: [String] = []
        
        // while date less than or equal to end date
        while startDate <= endDate {
            dates.append( Formatter.date.string(from: startDate))
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        }
        return dates
    }
    
    static func getOnlyDate(date: String) -> Int {
        guard let date = Formatter.date.date(from: date) else { return -1 }
        let components = Calendar.current.dateComponents([.day], from: date)
        guard let day = components.day else { return -1 }
        return day
    }
    
    static func getOnlyYear(date: String) -> String {
        Formatter.date.dateFormat = "yyyy-MM-dd"
        guard let date = Formatter.date.date(from: date) else { return "" }
        Formatter.date.dateFormat = "yyyy"
        return Formatter.date.string(from: date)
    }
    
    static func getOnlyMonth(date: String) -> String {
        Formatter.date.dateFormat = "yyyy-MM-dd"
        guard let date = Formatter.date.date(from: date) else { return "" }
        Formatter.date.dateFormat = "M"
        return Formatter.date.string(from: date)
    }
    
    static func isTodayInDates(dates: [String]) -> String {
        Formatter.date.dateFormat = "yyyy-MM-dd"
        let date = Formatter.date.string(from: Date())
        let state = dates.contains(date)

        if state {
            return date
        } else {
            return dates[0]
        }
    }
}
