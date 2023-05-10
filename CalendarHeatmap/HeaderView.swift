//
//  HeaderView.swift
//  CalendarHeatmap_Example
//
//  Created by Venkateswara Rao Meda on 10/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class HeaderView: UIStackView {
    
    private let config: HeatmapConfig
    
    fileprivate func commonInit() {
        alignment = .center
        axis = .horizontal
        distribution = .fillProportionally
        spacing = 0
    }
    
    init(config: HeatmapConfig) {
        self.config = config
        super.init(frame: .zero)
        
        commonInit()
    }
    
    
    func build(headers: [String]) {
        DispatchQueue.main.async {
            self.removeAllArrangedSubviews()
            for header in headers {
                self.append(text: header, width: 24)
            }
        }
    }
    
    private func append(text: String, width: CGFloat) {
        let label = UILabel()
        label.font = config.headerFont
        label.text = text
        label.textColor = config.headerColor
        label.backgroundColor = config.backgroundColor
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        addArrangedSubview(label)
    }
    
    required init(coder: NSCoder) {
        fatalError("no storyboard implementation, should not enter here")
    }
}
