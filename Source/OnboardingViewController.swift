//
//  swift
//  Onboarding
//
//  Created by Kurt Jensen on 9/1/16.
//
//

import UIKit

protocol OnboardingViewControllerDelegate {
    func onboardingViewControllerDoneTapped()
}

class OnboardingViewController: UIViewController {
    
    private var scrollView = UIScrollView()
    private var pageControl = UIPageControl()
    private var nextButton = UIButton(type: UIButtonType.System)
    private var onboardingViews: [OnboardingView] = [] {
        didSet {
            pageControl.numberOfPages = onboardingViews.count
            layoutSubviews()
        }
    }
    static let nextButtonColor: UIColor = UIColor.whiteColor()
    static let nextButtonFont: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    static let defaultButtonColor: UIColor = UIColor.whiteColor()
    static let defaultButtonFont: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    static let defaultTextColor: UIColor = UIColor.whiteColor()
    static let defaultTextFont: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
    static let defaultTitleColor: UIColor = UIColor.whiteColor()
    static let defaultTitleFont: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    
    static let nextTitle = "NEXT"
    static let doneTitle = "DONE"
    
    var delegate: OnboardingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }
    
    func addImage(backgroundImage: UIImage?, nextEnabled: Bool, image: UIImage?, title: String?, text: String?, actionTitle: String?, action: (() -> Void)?) {
        let action = OnboardingAction(title: actionTitle, handler: action)
        let onboardingView = OnboardingView(backgroundImage: backgroundImage, action: action, image: image, title: title, text: text)
        onboardingView.nextEnabled = nextEnabled
        addContentView(onboardingView)
    }
    
    func addColor(color: UIColor, nextEnabled: Bool, image: UIImage?, title: String?, text: String?, actionTitle: String?, action: (() -> Void)?) {
        let view = UIView()
        view.backgroundColor = color
        let action = OnboardingAction(title: actionTitle, handler: action)
        let onboardingView = OnboardingView(backgroundView: view, action: action, image: image, title: title, text: text)
        onboardingView.nextEnabled = nextEnabled
        addContentView(onboardingView)
    }
    
    func moveForward() {
        guard pageControl.currentPage < pageControl.numberOfPages else {
            return
        }
        let frame = CGRectMake(scrollView.frame.width*CGFloat(pageControl.currentPage+1), 0, scrollView.frame.width, scrollView.frame.height)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    private func addContentView(view: OnboardingView) {
        onboardingViews.append(view)
    }
    
    @objc private func nextButtonTapped() {
        if pageControl.currentPage == (onboardingViews.count-1) {
            close()
        } else {
            guard onboardingViews.count > pageControl.currentPage else {
                return
            }
            let onboardingView = onboardingViews[pageControl.currentPage]
            if onboardingView.nextEnabled {
                moveForward()
            }
        }
    }
    
    private func close() {
        delegate?.onboardingViewControllerDoneTapped()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }
    
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshCurrentPage()
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        refreshCurrentPage()
    }
}

extension OnboardingViewController {
    
    private func refreshCurrentPage() {
        guard onboardingViews.count > pageControl.currentPage else {
            return
        }
        let percent = scrollView.contentOffset.x/scrollView.frame.size.width
        if !percent.isNaN {
            pageControl.currentPage = Int(percent)
        }
        let onboardingView = onboardingViews[pageControl.currentPage]
        nextButton.enabled = onboardingView.nextEnabled
        nextButton.hidden = !onboardingView.nextEnabled
        for view in onboardingViews {
            view.enabled = view == onboardingView
        }
        let title = pageControl.currentPage == (onboardingViews.count-1) ? OnboardingViewController.doneTitle : OnboardingViewController.nextTitle
        nextButton.setTitle(title, forState: .Normal)
    }
    
    private func layoutSubviews() {
        var count: CGFloat = 0
        for onboardingView in onboardingViews {
            if (onboardingView.superview == nil) {
                scrollView.addSubview(onboardingView)
            }
            let frame = CGRectMake(scrollView.frame.width*count, 0, scrollView.frame.width, scrollView.frame.height)
            onboardingView.frame = frame
            count += 1
        }
        scrollView.contentSize = CGSizeMake(scrollView.frame.width*count, scrollView.frame.height)
        refreshCurrentPage()
    }
    
    private func addSubviews() {
        addScrollview()
        addNextButton()
        addPageControl()
    }
    
    private func addScrollview() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        let topConstraint = NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: scrollView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraints([topConstraint, rightConstraint, leftConstraint, bottomConstraint])
    }
    
    private func addNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitleColor(OnboardingViewController.nextButtonColor, forState: .Normal)
        nextButton.titleLabel?.font = OnboardingViewController.nextButtonFont
        nextButton.addTarget(self, action: #selector(nextButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(nextButton)
        
        let rightConstraint = NSLayoutConstraint(item: nextButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .TrailingMargin, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: nextButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .BottomMargin, multiplier: 1, constant: 0)
        view.addConstraints([rightConstraint, bottomConstraint])
    }
    
    private func addPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        let centerConstraint = NSLayoutConstraint(item: pageControl, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .BottomMargin, multiplier: 1, constant: 0)
        view.addConstraints([centerConstraint, bottomConstraint])
    }
    
}
