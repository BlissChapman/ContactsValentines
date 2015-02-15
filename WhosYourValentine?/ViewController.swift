//
//  ViewController.swift
//  WhosYourValentine?
//
//  Created by Bliss Chapman on 2/14/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit
import AddressBook

class ViewController: UIViewController {
    
    @IBOutlet weak var valentinesName: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    var contactsHelper = ContactsHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeArrayOfNames() {
        if contactsHelper.determinePermissionStatus() == true {
            contactsHelper.createAddressBook()
            if contactsHelper.addressBook != nil {
                contactsHelper.getContactsNames()
            }
        }
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        println("motion detected!!!")
        if motion == UIEventSubtype.MotionShake {
            displayLabel.text = "Your valentine is:"
            makeArrayOfNames()
            if let potentialValentines = contactsHelper.usersContactsNames {
                var destinyFactor = arc4random_uniform(UInt32(potentialValentines.count))
                valentinesName.text = potentialValentines[Int(destinyFactor)]
            }
        }
        
    }

}

