//
//  CardsViewController.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/18/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol ReservationConfigurable {
    func configure(with reservation: Reservation)
}

class CardsViewController: UIViewController {

    @IBOutlet var detailsCardView: ReservationDetailsView!
    @IBOutlet var locationCardView: LocationDetailsView!
    @IBOutlet var dishesCardView: DishesView!

    var reservation: Reservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let res = reservation {
            configure(with: res)
        }
    }
}

extension CardsViewController: ReservationConfigurable {
    func configure(with reservation: Reservation) {
        detailsCardView.configure(with: reservation)
        locationCardView.configure(with: reservation)
        dishesCardView.configure(with: reservation)
    }
}
