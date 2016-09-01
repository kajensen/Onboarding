//
//  ViewController.swift
//  Onboarding
//
//  Created by Kurt Jensen on 9/1/16.
//
//

import UIKit
import CoreLocation
import Contacts

class ViewController: UIViewController {
    
    private let contactsStore = CNContactStore()
    private let locationManager = CLLocationManager()

    var vc = OnboardingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showOnboarding()
    }
    
    func showOnboarding() {
        vc.delegate = self
        vc.view.backgroundColor = UIColor.blackColor()
        vc.addImage(UIImage(named: "bg"), nextEnabled: false, image: UIImage(named: "location"), title: "LOCATION", text: "Onboarding needs your location to use the app. Can we use your phone's gps information?", actionTitle: "ALLOW LOCATION") {
            print("requesting location access")
            self.requestLocation()
        }
        vc.addImage(UIImage(named: "bg"), nextEnabled: true, image: UIImage(named: "contacts"), title: "CONTACTS", text: "Onboarding would like your contacts to use the app. Can we use your phone's contact information?", actionTitle: "ALLOW CONTACTS") {
            print("requesting contacts access")
            self.requestContacts()
        }
        vc.addColor(UIColor.orangeColor(), nextEnabled: true, image: UIImage(named: "ghost"), title: "WELCOME", text: "Enjoy the app!", actionTitle: nil, action: nil)
        presentViewController(vc, animated: true, completion: nil)
    }

    func requestLocation() {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            vc.moveForward()
        }
    }
    
    func requestContacts() {
        contactsStore.requestAccessForEntityType(.Contacts) {
            granted, error in
            if (granted) {
                self.vc.moveForward()
            }
        }
    }
}

extension ViewController: OnboardingViewControllerDelegate {
    
    func onboardingViewControllerDoneTapped() {
        if navigationController?.childViewControllers.contains(self) == true && navigationController?.childViewControllers.first != self {
            navigationController?.popViewControllerAnimated(true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
        vc = OnboardingViewController()
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        vc.moveForward()
    }
}

