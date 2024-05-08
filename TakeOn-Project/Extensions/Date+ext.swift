//
//  Date+ext.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-26.
//

import Foundation

extension Date{
    func convertToMonthYearFromat ()-> String{
         let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "MMM yyyy"
        return dateFromatter.string(from: self)
    }
}
