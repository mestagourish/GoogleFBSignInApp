//
//  PreviewCradViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 29/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
/*
 29/06/2018
 Preview card implementation
 */
class PreviewCradViewController: UIViewController,CNContactPickerDelegate {
    
    var PrevSelectedSongCell:IndexPath!
    var PrevSelectedAnimationCell:IndexPath!
    var PrevSelectedMessageCell:IndexPath!
    var strMomentUrl : String = ""
    var strReceipentName : String = ""
    var strInitials :String = ""
    var strMessage : String = ""
    var InstanceoOfcollectionView : collectionViewController!
    @IBOutlet weak var imgMoment: UIImageView!
    @IBOutlet weak var txtReceipentName: UITextField!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var txtInitials: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtReceipentName.backgroundColor = UIColor.clear
        txtViewMessage.backgroundColor = UIColor.clear
        txtInitials.backgroundColor = UIColor.clear
        txtViewMessage.translatesAutoresizingMaskIntoConstraints = true
        imgMoment.downloadedFrom(link: "\(strMomentUrl)")
        txtViewMessage.text = strMessage
        txtViewMessage.sizeToFit()
        txtViewMessage.isScrollEnabled = false
        txtReceipentName.text = strReceipentName
        txtInitials.text = strInitials
        //imgMoment.image = UIImage(named : "\(InstanceoOfcollectionView.Momentdata[MomentImageIndexPath.row].ImageUrl)")
        // Do any additional setup after loading the view.
        /*txtReceipentName.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(getContacts))
        txtReceipentName.addGestureRecognizer(tapRecognizer)*/
    }
    /*
     06/07/2018
     Passes the parameter to the Create Card screen
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateCardViewController
        {
            //destination.PrevSelectedAnimationCell = PrevSelectedAnimationCell!
            //destination.PrevSelectedSongCell = PrevSelectedSongCell!
            //destination.PrevSelectedMessageCell = PrevSelectedMessageCell!
            //destination.strRecipientName = txtReceipentName.text!
        }
    }
    @objc func getContacts()
    {
        let entityType = CNEntityType.contacts
        let authstatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authstatus == CNAuthorizationStatus.notDetermined
        {
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType, completionHandler: { (success, error) in
                if success {
                    self.openContacts()
                }
                else{
                    print("not authorized")
                }
            })
        }
        else if authstatus == CNAuthorizationStatus.authorized
        {
            openContacts()
        }
    }
    func openContacts()
    {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true)
        {
            
        }
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let fullname = "\(contact.givenName) \(contact.familyName)"
        txtReceipentName.text = fullname
        var Email = "Not Available"
        if !contact.emailAddresses.isEmpty
        {
            let emailString = (((contact.emailAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value"))
            print(emailString as! String)
        }
        
        /*if !contact.phoneNumbers.isEmpty
        {
            let phoneNumber = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "LabelValuePair") as AnyObject).value(forKey: "Value") as AnyObject).value(forKey: "stringValue"))
            print(phoneNumber!)
        }*/
    }
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 1
        line.lineJoin = kCALineJoinRound
        self.view.layer.addSublayer(line)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
