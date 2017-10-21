//
//  OTTabBarController.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/15/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class OTTabBarController: UITabBarController {

    var popupVC: PopupViewController?
    var origTabFrame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cardsVC = storyboard.instantiateViewController(withIdentifier: "cardsViewController") as? CardsViewController
//        cardsVC?.reservation = ReservationAssembler().createReservation(fromJsonTerminatedFile: "FullReservationSuccess")
//        cardsVC?.reservation = ReservationAssembler().createReservation(fromJsonTerminatedFile: "PartialReservation")
        cardsVC?.reservation = ReservationAssembler().createReservation(fromJsonTerminatedFile: "2dishes")
        popupVC = PopupViewController(delegate: self, position: .minimized, child: cardsVC)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pop = popupVC {
            pop.willMove(toParentViewController: self)
            pop.beginAppearanceTransition(true, animated: false)
            view.insertSubview(pop.view, belowSubview: tabBar)
            popupVC?.didMove(toParentViewController: self)
            pop.view.backgroundColor = .red
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popupVC?.endAppearanceTransition()
        origTabFrame = tabBar.frame
    }
}

extension OTTabBarController: PopupControllerPresentationDelegate {

    func shouldPopupControllerTransition(_ popupController: PopupViewController) -> Bool {
        return true
    }

    func popupController(_ popupController: PopupViewController, willTransitionTo position: PopupPosition, duration: CGFloat) {
        UIView.animate(withDuration: CFTimeInterval(duration)) {
            self.updateFrame(for: position == .fullExpanded ? 1.0 : 0.0)
        }
    }

    func popupController(_ popupController: PopupViewController, didTransitionTo position: PopupPosition) {
        updateFrame(for: position == .fullExpanded ? 1.0 : 0.0)
    }
    
    func popupController(_ popupController: PopupViewController, isDragging percentage: CGFloat) {
        updateFrame(for: percentage)
    }

    private func updateFrame(for percentage: CGFloat) {
        var frame = tabBar.frame
        frame.origin.y = origTabFrame.origin.y + percentage*origTabFrame.height
        tabBar.frame = frame
    }

    func container(for popupController: PopupViewController, position: PopupPosition) -> CGRect {
        let topAdj: CGFloat
        let bottomAdj: CGFloat
        if #available(iOS 11, *) {
            topAdj = view.safeAreaInsets.top
            bottomAdj = view.safeAreaInsets.bottom
        } else {
            topAdj = topLayoutGuide.length
            bottomAdj = bottomLayoutGuide.length
        }
        let frameHeight = view.frame.height - (topAdj + bottomAdj)
        switch position {
        case .minimized:
            let popupMinHeight: CGFloat = popupController.topBarHeight + tabBar.frame.height
            return CGRect(x: 0.0, y: view.frame.height - popupMinHeight, width: view.frame.width, height: view.frame.height)
        case .fullExpanded:
            return CGRect(x: 0.0, y: topAdj, width: view.frame.width, height: frameHeight)
        case .outOfPosition:
            var rect = view.frame
            rect.size.height = frameHeight
            return rect
        }
    }
}
