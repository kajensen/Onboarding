//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by Kurt Jensen on 9/1/16.
//
//

import UIKit

struct OnboardingAction {
    var title: String?
    var handler: (() -> Void)?
}

class OnboardingView: UIView {
    
    var enabled = false {
        didSet {
            actionButton.enabled = enabled
        }
    }
    var nextEnabled = true
    
    private var action: OnboardingAction?
    private var backgroundView: UIView?
    private var titleLabel = UILabel()
    private var textLabel = UILabel()
    private var imageView = UIImageView()
    private var actionButton = UIButton(type: UIButtonType.System)
    
    private let titleLabelTopConstraint: CGFloat = 40
    private let textLabelTopConstraint: CGFloat = 20
    private let textLabelSideConstraint: CGFloat = 10
    private let actionButtonBottomConstraint: CGFloat = 32
    private let imageViewSizeConstraint: CGFloat = 80
    private let imageViewBottomConstraint: CGFloat = 20
    
    convenience init(backgroundImage: UIImage?, action: OnboardingAction, image: UIImage?, title: String?, text: String?) {
        self.init()
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.clipsToBounds = true
        self.backgroundView = backgroundImageView
        self.action = action
        self.imageView.image = image
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        self.titleLabel.text = title
        self.titleLabel.numberOfLines = 2
        self.textLabel.text = text
        self.textLabel.numberOfLines = 0
        addSubviews()
    }
    
    convenience init(backgroundView: UIView, action: OnboardingAction, image: UIImage?, title: String?, text: String?) {
        self.init()
        self.backgroundView = backgroundView
        self.action = action
        self.imageView.image = image
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        self.titleLabel.text = title
        self.titleLabel.numberOfLines = 2
        self.textLabel.text = text
        self.textLabel.numberOfLines = 0
        addSubviews()
    }
    
    func actionButtonTapped() {
        action?.handler?()
    }
    
}

extension OnboardingView {
    
    private func addSubviews() {
        clipsToBounds = true
        addBackgroundView()
        addTitleLabel()
        addTextLabel()
        addActionButton()
        addImageView()
    }
    
    private func addBackgroundView() {
        guard let backgroundView = backgroundView else {
            return
        }
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        let topConstraint = NSLayoutConstraint(item: backgroundView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: backgroundView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        addConstraints([topConstraint, rightConstraint, leftConstraint, bottomConstraint])
    }
    
    private func addTitleLabel() {
        titleLabel.font = OnboardingViewController.defaultTitleFont
        titleLabel.textColor = OnboardingViewController.defaultTitleColor
        titleLabel.textAlignment = .Center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        let leftConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: titleLabelTopConstraint)
        addConstraints([topConstraint, leftConstraint, rightConstraint])
    }
    
    private func addTextLabel() {
        textLabel.font = OnboardingViewController.defaultTextFont
        textLabel.textColor = OnboardingViewController.defaultTextColor
        textLabel.textAlignment = .Center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        
        let leftConstraint = NSLayoutConstraint(item: textLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: textLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1, constant: textLabelTopConstraint)
        addConstraints([topConstraint, leftConstraint, rightConstraint])
    }
    
    private func addActionButton() {
        actionButton.setTitle(action?.title, forState: .Normal)
        actionButton.setTitleColor(OnboardingViewController.defaultButtonColor, forState: .Normal)
        actionButton.titleLabel?.font = OnboardingViewController.defaultButtonFont
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(actionButtonTapped), forControlEvents: .TouchUpInside)
        addSubview(actionButton)
        
        let centerConstraint = NSLayoutConstraint(item: actionButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: actionButton, attribute: .Bottom, multiplier: 1, constant: actionButtonBottomConstraint)
        addConstraints([centerConstraint, bottomConstraint])
    }
    
    private func addImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        let centerConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: actionButton, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: imageViewBottomConstraint)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: imageViewSizeConstraint)
        let squareConstraint = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: imageView, attribute: .Width, multiplier: 1, constant: 0)
        addConstraints([centerConstraint, bottomConstraint, heightConstraint, squareConstraint])
    }
    
}