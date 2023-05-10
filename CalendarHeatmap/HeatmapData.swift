//
//  HeatmapData.swift
//  CalendarHeatmap_Example
//
//  Created by Venkateswara Rao Meda on 10/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//
import UIKit

struct HeatmapData {
  
    let config: HeatmapConfig
    private var columnCountInSection: Int = 0

    init(config: HeatmapConfig, startDate: Date, endDate: Date) {
        self.config = config
    }
    
    func itemAt(indexPath: IndexPath) -> Date? {
        return Date()
    }
    
    // MARK: setup header related functions
    private func calculateHeaderWidth(_ itemCount: Int, _ columnCount: Int) -> CGFloat {
        // based on the current item position.
        // if the current item is the first on in column, it belongs to the next month
        // otherwirs, it belongs to this month
        let sectionColumnCount = itemCount == 1 ? (columnCount - 1) : columnCount
        return CGFloat(sectionColumnCount) * (config.itemSide + config.lineSpacing)
    }
}
