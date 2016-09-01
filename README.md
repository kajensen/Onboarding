# Onboarding
A simple swift onboarding view controller for iOS

Entirely in code, show basic tutorial information including actionable callbacks (for requesting location access, etc).
```
    let vc = OnboardingViewController()

    func showOnboarding() {
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
```

# Usage
Copy source folder into your project. Refer to ViewController.swift for example implementation.

![Alt text](http://imgur.com/WNJ6m8N.png "screen")
