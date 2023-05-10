//
//  HeatmapConfig.swift
//  CalendarHeatmap_Example
//
//  Created by Venkateswara Rao Meda on 10/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

public struct HeatmapConfig {
    public var backgroundColor: UIColor = .white
    public var contentRightInset: CGFloat = 60
    
    // calendar day item
    public var itemSide: CGFloat = 20
    public var itemCornerRadius: CGFloat = 4
    public var allowItemSelection: Bool = false
    public var selectedItemBorderColor: UIColor = .black
    public var selectedItemBorderLineWidth: CGFloat = 2
    public var interitemSpacing: CGFloat = 4
    public var lineSpacing: CGFloat = 4
    
    // calendar row
    public var rowColor: UIColor = .black
    public var rowFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    public var rowWidth: CGFloat = 30
    public var rowItems:[String] = DateFormatter().shortWeekdaySymbols.map({$0.capitalized})
    
    // calendar header
    public var headerItems: [String] = ["7","8","9","10","11","12","1","2","3","4","5","6","7","8","9","10","11","12"]
    public var headerColor: UIColor = .black
    public var headerFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    public var headerHeight: CGFloat = 20
    
    public init(){}
}
