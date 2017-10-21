//
//  DishesView.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/18/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class DishesView: UIView {

    private var dishes = [Dish]()
    private var topBarConstraint: NSLayoutConstraint?

    private lazy var topView: UIView = {
        let label = UILabel()
        self.addSubview(label)
        label.text = "Popular Dishes"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        updateConstraintsIfNeeded()
        let hConstraint = topView.heightAnchor.constraint(equalToConstant: 0.0)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hConstraint
            ])


        self.topBarConstraint = hConstraint
        layoutSubviews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 8
        layer.masksToBounds = true

    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
}

extension DishesView: ReservationConfigurable {

    func configure(with reservation: Reservation) {
        dishes = reservation.restaurant.dishes
        self.topBarConstraint?.constant = dishes.count > 0 ? 45.0 : 0.0
        guard dishes.count > 0 else {
            return
        }

        let displayCount = min(3, dishes.count)
        var aboveView = topView
        for i in 0..<displayCount {
            let detailView = DishDetailView()
            detailView.configure(with: dishes[i])
            addSubview(detailView)
            detailView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                detailView.topAnchor.constraint(equalTo: aboveView.bottomAnchor),
                detailView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
                ])
            aboveView = detailView

        }
        NSLayoutConstraint.activate([
            aboveView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
    }
}

