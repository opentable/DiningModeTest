//
//  ReservationDetailsView.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/17/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//


//Notes:
//mistook the people/date/time indicators for buttons, therefore made them a subclass of UIControl, which


import UIKit


class ReservationDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!

    @IBOutlet weak var peopleLabel: ImageTextButton!
    @IBOutlet weak var dateLabel: ImageTextButton!
    @IBOutlet weak var timeLabel: ImageTextButton!

    override func layoutSubviews() {
        super.layoutSubviews()
        restaurantImageView.layer.cornerRadius = restaurantImageView.frame.width/2.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
        restaurantImageView.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("ReservationDetailsView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])
    }
    @IBAction func cancelAction(_ sender: ImageTextButton) {
        print("cancel action")
    }

    @IBAction func changeAction(_ sender: Any) {
        print("cancel action")
    }

    @IBAction func callAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "tel:1-800-OPENTAB")!)
    }
}

extension ReservationDetailsView: ReservationConfigurable {
    func configure(with reservation: Reservation) {
        let size = reservation.partySize
        let imageSize = CGSize(width: restaurantImageView.frame.width, height: restaurantImageView.frame.height)
        if let imageURLString = reservation.restaurant.profilePhoto?.urlForSize(desiredSize: imageSize),
            let imageURL = URL(string: imageURLString) {
            restaurantImageView.setImageWith(imageURL)
        }

        let suffix = size > 1 ? " People" : " Person" //Note: there are nsstring/localization methods better adept at handling this.
        peopleLabel.text = String(describing: size) + suffix
        let formatter = DateFormatter() //would cache this if became a commonly used formatter
        formatter.dateFormat = "E, MMM d"
        dateLabel.text = formatter.string(from: reservation.localDate)
        formatter.dateFormat = "h:mm a"
        timeLabel.text = formatter.string(from: reservation.localDate)
    }
}
