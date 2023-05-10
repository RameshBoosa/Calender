//
//  ViewController.swift
//  CalendarHeatmap
//
//  Created by Zacharysp on 03/02/2020.
//  Copyright (c) 2020 Zacharysp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var heatMap: Heatmap = {
        var config = HeatmapConfig()
        config.backgroundColor = .gray
        // config item
        config.selectedItemBorderColor = .white
        config.allowItemSelection = true
        // config month header
        config.headerHeight = 30
        config.headerFont = UIFont.systemFont(ofSize: 18)
        config.headerColor = UIColor(named: "text")!
        // config weekday label on left
        config.rowFont = UIFont.systemFont(ofSize: 12)
        config.rowWidth = 30
        config.rowColor = UIColor(named: "text")!
        
        let heatmap = Heatmap(config: config, startDate: Date(2023, 5, 1), endDate: Date(2023, 5, 23))
        heatmap.delegate = self
        return heatmap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        view.addSubview(heatMap)
        heatMap.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heatMap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            heatMap.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            heatMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            heatMap.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
//    private func readHeatmap() -> [String: Int]? {
//        guard let url = Bundle.main.url(forResource: "heatmap", withExtension: "plist") else { return nil }
//        return NSDictionary(contentsOf: url) as? [String: Int]
//    }
    
}

extension ViewController: HeatmapDelegate {
    func colorFor(dateComponents: DateComponents) -> UIColor {
        return .red
    }
    
    func didSelectedAt(dateComponents: DateComponents) {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return }
        // do something here
        print(year, month, day)
    }
    
    func finishLoadCalendar() {
        heatMap.scrollTo(date: Date(2023, 5, 12), at: .right, animated: false)
    }
}

extension Date {
    init(_ year:Int, _ month: Int, _ day: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        self.init(timeInterval:0, since: Calendar.current.date(from: dateComponents)!)
    }
}
