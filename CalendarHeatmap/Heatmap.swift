//
//  Heatmap.swift
//  CalendarHeatmap_Example
//
//  Created by Venkateswara Rao Meda on 10/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

@objc public protocol HeatmapDelegate {
    func colorFor(dateComponents: DateComponents) -> UIColor
    @objc optional func didSelectedAt(dateComponents: DateComponents)
    @objc optional func finishLoadCalendar()
}

open class Heatmap: UIView {
    
    // MARK: ui components
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(HeatmapCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: config.contentRightInset)
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.layer.masksToBounds = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = CGSize(width: config.itemSide, height: config.itemSide)
        flow.sectionInset = UIEdgeInsets(top: config.headerHeight, left: 0, bottom: 0, right: config.lineSpacing)
        flow.minimumLineSpacing = config.lineSpacing
        flow.minimumInteritemSpacing = config.interitemSpacing
        return flow
    }()
    
    private lazy var rowView: RowView = {
        return RowView(config: config)
    }()
    
    private lazy var headerView: HeaderView = {
        return HeaderView(config: config)
    }()
    
    private let cellIdentifier = "HeatmapCell"
    private let config: HeatmapConfig
    private var startDate: Date
    private var endDate: Date
    
    private var heatmapData: HeatmapData?
    
    open weak var delegate: HeatmapDelegate?
    
    public init(config: HeatmapConfig = HeatmapConfig(), startDate: Date, endDate: Date = Date()) {
        self.config = config
        self.startDate = startDate
        self.endDate = endDate
        super.init(frame: .zero)
        render()
        setup()
    }
    
    public func reload() {
        DispatchQueue.main.async {
            [weak self] in
            self?.collectionView.reloadData()

        }
    }
    
    public func reload(newStartDate: Date?, newEndDate: Date?) {
        guard newStartDate != nil || newEndDate != nil else {
            reload()
            return
        }
        startDate = newStartDate ?? startDate
        endDate = newEndDate ?? endDate
        setup()
    }
    
    public func scrollTo(date: Date, at: UICollectionView.ScrollPosition, animated: Bool) {
        let difference = Date.daysBetween(start: startDate, end: date)
        collectionView.scrollToItem(at: IndexPath(item: difference - 1, section: 0), at: at, animated: animated)
    }
    
    private func setup() {
        backgroundColor = config.backgroundColor
        DispatchQueue.global(qos: .userInteractive).async {
            // calculate calendar date in background
            self.heatmapData = HeatmapData(config: self.config,
                                                    startDate: self.startDate,
                                                    endDate: self.endDate)
            self.headerView.build(headers: self.heatmapData!.config.headerItems)
            DispatchQueue.main.async { [weak self] in
                // then reload
                self?.collectionView.reloadData()
                self?.delegate?.finishLoadCalendar?()
            }
        }
    }
    
    private func render() {
        clipsToBounds = true
        
        addSubview(collectionView)
        addSubview(rowView)
        collectionView.addSubview(headerView)
        collectionView.bringSubviewToFront(headerView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        rowView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            rowView.topAnchor.constraint(equalTo: self.topAnchor),
            rowView.widthAnchor.constraint(equalToConstant: config.rowWidth),

            rowView.heightAnchor.constraint(equalToConstant: 20),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: config.itemSide * 3 + config.interitemSpacing * 6 + config.headerHeight),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: rowView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: config.headerHeight)
        ])
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("no storyboard implementation, should not enter here")
    }
}

extension Heatmap: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (heatmapData?.config.headerItems.count ?? 0)*3
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HeatmapCollectionViewCell
        cell.config = config
        if let date = heatmapData?.itemAt(indexPath: indexPath),
            let itemColor = delegate?.colorFor(dateComponents: Calendar.current.dateComponents([.year, .month, .day], from: date)) {
            cell.itemColor = itemColor
        } else {
            cell.itemColor = .clear
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let date = heatmapData?.itemAt(indexPath: indexPath) else { return }
        delegate?.didSelectedAt?(dateComponents: Calendar.current.dateComponents([.year, .month, .day], from: date))
    }
}
