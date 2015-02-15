//
//  ContactsHelper.swift
//  WhosYourValentine?
//
//  Created by Bliss Chapman on 2/15/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import Foundation
import AddressBook

class ContactsHelper {
    
    init () {
    }
    
    var usersContactsNames: [String]?
    var addressBook: ABAddressBook!
    
    //Determine our application's permission status
    func determinePermissionStatus() -> Bool {
        
        let contactsPermissionStatus = ABAddressBookGetAuthorizationStatus()
        
        switch contactsPermissionStatus {
        case .Authorized:
            return self.createAddressBook()
        case .NotDetermined:
            var ok = false
            ABAddressBookRequestAccessWithCompletion(nil) {
                (granted:Bool, err:CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        ok = self.createAddressBook()
                    }
                }
            }
            if ok == true {
                return true
            }
            self.usersContactsNames = nil
            return false
        case .Restricted:
            self.usersContactsNames = nil
            return false
        case .Denied:
            self.usersContactsNames = nil
            return false
        }
    }
    
    
    //Create address book
    func createAddressBook() -> Bool {
        if usersContactsNames != nil {
            return true
        }
        var error: Unmanaged<CFError>?
        let addressBook: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        if addressBook == nil {
            println(error)
            self.addressBook = nil
            return false
        }
        self.addressBook = addressBook
        return true
    }
    
    //Retrieve just the contact's names and store them in our usersContactsNames array.
    func getContactsNames() {
        if !self.determinePermissionStatus() {
            return
        }
        if addressBook != nil {
            usersContactsNames = []
            let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
            for person in people {
                var name: String = ABRecordCopyCompositeName(person).takeRetainedValue()
                self.usersContactsNames?.append(name)
            }
        }
        println(usersContactsNames!)
    }
}