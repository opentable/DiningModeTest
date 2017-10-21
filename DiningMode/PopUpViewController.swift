//
//  PopUpViewController.swift
//  DiningMode
//
//  Created by Chris Brandow Wag on 10/15/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit
typealias OptionalVoidBlock = (() -> ())?

enum PopupPosition {
    case minimized, fullExpanded, outOfPosition
}

protocol PopupControllerPresentationDelegate {
    func shouldPopupControllerTransition(_ popupController: PopupViewController) -> Bool
    func popupController(_ popupController: PopupViewController, willTransitionTo position: PopupPosition, duration: CGFloat)
    func popupController(_ popupController: PopupViewController, didTransitionTo position: PopupPosition)
    func popupController(_ popupController: PopupViewController, isDragging percentage: CGFloat)
    func container(for popupController: PopupViewController, position: PopupPosition) -> CGRect
}

class PopupViewController: UIViewController {
    
    var popDelegate: PopupControllerPresentationDelegate!
    var topBar = TopControlBar()
    var topBarHeight: CGFloat = 60.0
    private var popPosition = PopupPosition.minimized
    private var childController: UIViewController?
    private var activityController: UIActivityViewController?

    convenience init(delegate: PopupControllerPresentationDelegate, position: PopupPosition, child childViewController: UIViewController?) {
        self.init(nibName:nil, bundle: nil)
        self.popDelegate = delegate
        self.popPosition = position
        self.childController = childViewController

        topBar.delegate = self
        topBar.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 60.0)
        view.addSubview(topBar)
        let dragGR = UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:)))
        topBar.addGestureRecognizer(dragGR)
        topBar.configure(for: popPosition)

        view.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.frame = currentFrame
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cardsVC = childController {
            show(viewController: cardsVC)
        }

    }
    @objc func dragAction(_ panGR: UIPanGestureRecognizer) {
        if panGR.state == .began {
            let translation = panGR.location(in: view.superview)// view.frame.origin
            panGR.setTranslation(translation, in: view.superview)
            popPosition = .outOfPosition
            topBar.configure(for: popPosition)
        } else {
            let transY = panGR.translation(in: view.superview).y
            let maxY = popDelegate.container(for: self, position: .fullExpanded).origin.y
            let minY = popDelegate.container(for: self, position: .minimized).origin.y
            let maxTransY = minY - maxY
            let percentage = (maxTransY - transY)/maxTransY

            let slideUpThreshold: CGFloat = 0.4

            if panGR.state == .changed, percentage < 1.0 && percentage > 0.0 { //otherwise do nothing
                popDelegate.popupController(self, isDragging:percentage)
                view.frame.origin = CGPoint(x: view.frame.origin.x, y: transY)
            } else if panGR.state == .ended || panGR.state == .cancelled || panGR.state == .failed {
                transition(to: percentage > slideUpThreshold ? .fullExpanded : .minimized, completion: nil)
            }
        }
    }
    
    var currentFrame: CGRect {
        get {
            return popDelegate?.container(for: self, position: popPosition) ?? view.frame
        }
    }

    func show(viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }

    func add(viewController: UIViewController) {
        if let _ = childController {
            //NOTE: Normally I would remove old controller code here. I don't need for this exercise
            childController = nil //only doing this to suppress compiler warning
        }
        childController = viewController
        show(viewController: viewController)
    }
}

extension PopupViewController {

    func show(completion: OptionalVoidBlock) {
        transition(to: .fullExpanded, completion: completion)
    }

    func hide(completion: OptionalVoidBlock) {
        transition(to: .minimized, completion: completion)
    }

    func transition(to toPosition: PopupPosition, completion: OptionalVoidBlock) {
        guard popPosition != toPosition else {
            return
        }
        popPosition = toPosition
        topBar.isEnabled = false
        let targetFrame = (toPosition == .minimized) ? popDelegate.container(for: self, position: .minimized) : popDelegate.container(for: self, position: .fullExpanded)
        let duration: CGFloat = 0.3
        popDelegate?.popupController(self, willTransitionTo: popPosition, duration: duration)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.frame = targetFrame
        }, completion: { (complete) in
            self.topBar.isEnabled = true
            self.popDelegate?.popupController(self, didTransitionTo: self.popPosition)
            self.topBar.configure(for: self.popPosition)
            completion?()
        })
    }
}

extension PopupViewController: TobBarControlBarDelegate {

    func bannerAction(for topBar: TopControlBar) {
        if (popPosition == .minimized) {
            transition(to: .fullExpanded, completion: nil)
        } else {
            transition(to: .minimized, completion: nil)
        }
    }

    func shareAction(for topBar: TopControlBar) {
        let showBlock = {
            let shareMessage = "Placeholder for reservation info"
            self.activityController = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
            self.present(self.activityController!, animated: true, completion: nil)
        }

        if popPosition == .minimized {
            show(completion: showBlock)
        } else {
            showBlock()
        }
    }
}
