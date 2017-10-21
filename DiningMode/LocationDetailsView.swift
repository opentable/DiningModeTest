//
//  LocationDetailsView.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/18/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("LocationsDetailView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        mapView.isScrollEnabled = false
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}

extension LocationDetailsView: ReservationConfigurable {
    func configure(with reservation: Reservation) {
        let region = MKCoordinateRegion(center: reservation.restaurant.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
    }
}
