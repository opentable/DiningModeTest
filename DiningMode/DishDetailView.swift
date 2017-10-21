//
//  DishesDetailView.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/18/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class DishDetailView: UIView {
    
    static let defaultImageHeight = 75.0
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var photosbutton: ImageTextButton!
    @IBOutlet weak var reviewsButton: ImageTextButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var dish: Dish?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func commonInit() {
        Bundle.main.loadNibNamed("DishDetailView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])
        photosbutton.font = UIFont.systemFont(ofSize: 12.0)
        reviewsButton.font = UIFont.systemFont(ofSize: 12.0)
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
}

extension DishDetailView {

    func configure(with dish: Dish) {
        photosbutton.text = String(describing: dish.photos.count) + " photos"
        if let snippetString = dish.snippet.snippetString {
            descriptionLabel.text = snippetString
            let attr = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0),
                        NSAttributedStringKey.foregroundColor: UIColor.red]
            let attString = NSMutableAttributedString(string: snippetString, attributes:[NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)])
            dish.snippet.highlights.forEach {
                if NSLocationInRange($0.location, dish.snippet.range) {
                    let updatedRange = NSRange(location: $0.location - dish.snippet.range.location, length: $0.length)
                    attString.setAttributes(attr, range: updatedRange)
                }
            }
            descriptionLabel.attributedText = attString
        } else {
            descriptionLabel.text = dish.snippet.snippetString
        }
        titleLabel.text = dish.name
        let height = DishDetailView.defaultImageHeight
        if let imageURLString = dish.photos.first?.urlForSize(desiredSize: CGSize(width: height, height: height)) {
            if let imageURL = URL(string: imageURLString) {
                imageView.setImageWith(imageURL)
            }

        }
    }
}

extension Snippet {
    
    var snippetString: String? {
        get {
            guard let range = Range(range, in: content) else { return nil }
            return String(content[range])
        }
    }
}
