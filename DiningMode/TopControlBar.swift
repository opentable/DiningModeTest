//
//  TopBarView.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/20/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol TobBarControlBarDelegate {
    func bannerAction(for topBar: TopControlBar)
    func shareAction(for topBar: TopControlBar)
}

class TopControlBar: UIView {
    var closeButton = UIView()
    var shareButton = UIButton(type: .custom)
    var delegate: TobBarControlBarDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var isEnabled: Bool = true {
        willSet {
            shareButton.isEnabled = newValue
            gestureRecognizers?.forEach { $0.isEnabled = newValue }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    func commonInit() {
        addSubview(closeButton)
        addSubview(shareButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: topAnchor),
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor)
            ])
        
        closeButton.backgroundColor = .blue
        shareButton.backgroundColor = .yellow
        shareButton.addTarget(self, action: #selector(shareAction(_:)), for: .touchUpInside)
        //NOTE: slight inconsistency in addding tapGR to topBar, and panGR to vc.view
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(bannerAction(_:)))
        addGestureRecognizer(tapGR)
    }
    
    @objc func shareAction(_ sender: UIButton) {
        delegate?.shareAction(for: self)
    }
    @objc func bannerAction(_: UIButton) {
        delegate?.bannerAction(for: self)
    }
    
    func configure(for position: PopupPosition) {
        backgroundColor = .orange
        
        switch position {
        case .fullExpanded:
            closeButton.backgroundColor = .blue
        case .minimized:
            closeButton.backgroundColor = .green
        case .outOfPosition:
            closeButton.backgroundColor = .lightGray
        }
    }
}


