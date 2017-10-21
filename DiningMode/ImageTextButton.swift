//
//  ImageTextButton.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/18/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class ImageTextButton: UIControl {

    enum Arrangement: String {
        typealias RawValue = String

        case textTop = "top", textRight = "right", textLeft = "left" //NOTE: incomplete implementation of cases due to time constraints
        var textAlignment: NSTextAlignment {
            switch self {
            case .textTop:
                return .center
            case .textRight:
                return .left
            case .textLeft:
                return .right
            }
        }
    }

    @IBInspectable var arrangementOption: String? = "top" {
        willSet {
            guard let _ = Arrangement(rawValue: newValue ?? "") else {
                fatalError("The value \"\(String(describing: newValue))\" is not a valid arrangement argurment. Use \"top\", or \"right\" only")
            }
        }
    }

    @IBInspectable var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }

    @IBInspectable var text: String? {
        didSet {
            self.label.text = text
        }
    }

    var font: UIFont? {
        didSet {
            label.font = font
        }
    }

    private lazy var textArrangement: Arrangement = {
        let option = self.arrangementOption ?? "top"
        return Arrangement(rawValue: option) ?? .textTop
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = textArrangement.textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = tintColor

        if textArrangement == .textRight {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                imageView.rightAnchor.constraint(equalTo: label.leftAnchor),
                label.trailingAnchor.constraint(equalTo: trailingAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
                label.topAnchor.constraint(equalTo: topAnchor)
            ])
        } else if textArrangement == .textLeft {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
                label.topAnchor.constraint(equalTo: topAnchor),
                label.rightAnchor.constraint(equalTo: imageView.leftAnchor),
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10.0),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        } else { //if .textTop
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                imageView.bottomAnchor.constraint(equalTo: label.topAnchor),
                label.trailingAnchor.constraint(equalTo: trailingAnchor),
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.heightAnchor.constraint(equalTo: label.heightAnchor)
            ])
        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
    }

    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        sendActions(for: .valueChanged)
    }
}

