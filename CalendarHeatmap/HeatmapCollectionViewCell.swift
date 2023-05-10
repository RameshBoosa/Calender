//
//  HeatmapCollectionViewCell.swift
//  CalendarHeatmap_Example
//
//  Created by Venkateswara Rao Meda on 10/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

open class HeatmapCollectionViewCell: UICollectionViewCell {
    
    open var config: HeatmapConfig! {
        didSet {
            backgroundColor = config.backgroundColor
        }
    }
    
    open var itemColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override func draw(_ rect: CGRect) {
        let cornerRadius = config.itemCornerRadius
        let maxCornerRadius = min(bounds.width, bounds.height) * 0.5
        let path = UIBezierPath(roundedRect: rect, cornerRadius: min(cornerRadius, maxCornerRadius))
        itemColor.setFill()
        path.fill()
        guard isSelected, config.allowItemSelection else { return }
        config.selectedItemBorderColor.setStroke()
        path.lineWidth = config.selectedItemBorderLineWidth
        path.stroke()
    }
}
