//
//  AddUserVC.swift
//  CoreDataExample
//
//  Created by Mital Solanki on 10/3/17.
//  Copyright © 2017 DEFSYS GROUP. All rights reserved.
//

import UIKit
import CoreData

class AddUserVC: UIViewController
{
    
    // MARK: - Variable & Properties
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    
    var aUser : User?
    
    // MARK: - View LifeCycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (aUser != nil)
        {
            lblHeader.text = "EDIT USER"
            txtFullName.text = aUser?.fullName
            txtEmail.text = aUser?.email
            txtContactNo.text = aUser?.contactNo
        }
        else
        {
            lblHeader.text = "ADD USER"
        }
    }

    // MARK: - Button Click Event
    
    @IBAction func BackBtnClick(_ sender: UIButton)
    {
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func SaveBtnClick(_ sender: UIButton)
    {
        
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            
            if ((self.txtFullName.text?.trimWhitespace().characters.count)! > 0)
            {
                if ((self.txtEmail.text?.trimWhitespace().characters.count)! > 0)
                {
                    if ((self.txtContactNo.text?.trimWhitespace().characters.count)! > 0)
                    {
                        let context = AppDelegate.shared.persistentContainer.viewContext
                        
                        if (self.aUser != nil)
                        {
                            // ==================== Edit User ==================== //
                            
                            // Method: - 1
                            
                            self.aUser?.setValue(self.txtFullName.text?.trimWhitespace(), forKey: "fullName")
                            self.aUser?.setValue(self.txtEmail.text?.trimWhitespace(), forKey: "email")
                            self.aUser?.setValue(self.txtContactNo.text?.trimWhitespace(), forKey: "contactNo")
                            self.aUser?.setValue(NSDate(), forKey: "createdDate")
                            
                            //save the object
                            do
                            {
                                try context.save()
                                self.navigationController!.popViewController(animated: true)
                            }
                            catch let error as NSError
                            {
                                print("Could not save \(error), \(error.userInfo)")
                            }
                            catch
                            {
                                
                            }
                            
                            // Method: - 2

//                            self.aUser?.fullName = self.txtFullName.text?.trimWhitespace()
//                            self.aUser?.email = self.txtEmail.text?.trimWhitespace()
//                            self.aUser?.contactNo = self.txtContactNo.text?.trimWhitespace()
//                            self.aUser?.createdDate = Date() as NSDate?
//                            AppDelegate.shared.saveContext()
//                            self.navigationController!.popViewController(animated: true)
                        }
                        else
                        {
                            // ==================== Create User ==================== //
                            
                            // Method: - 1
                            
                            //retrieve the entity
                            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                            let user = NSManagedObject(entity: entity!, insertInto: context)
                            
                            //set the entity values
                            user.setValue(self.txtFullName.text?.trimWhitespace(), forKey: "fullName")
                            user.setValue(self.txtEmail.text?.trimWhitespace(), forKey: "email")
                            user.setValue(self.txtContactNo.text?.trimWhitespace(), forKey: "contactNo")
                            user.setValue(NSDate(), forKey: "createdDate")
                            
                            //save the object
                            do
                            {
                                try context.save()
                                self.navigationController!.popViewController(animated: true)
                                print("saved!")
                            }
                            catch let error as NSError
                            {
                                print("Could not save \(error), \(error.userInfo)")
                            }
                            catch
                            {
                                
                            }
                            
//                            // Method: - 2
//    
//                            let user = User(context: context)
//                            user.fullName = self.txtFullName.text?.trimWhitespace()
//                            user.email = self.txtEmail.text?.trimWhitespace()
//                            user.contactNo = self.txtContactNo.text?.trimWhitespace()
//                            user.createdDate = Date() as NSDate?
//                            AppDelegate.shared.saveContext()
//                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                    else
                    {
                        self.displayAlertMessage(strMessage: "Please enter contact no")
                    }
                }
                else
                {
                    self.displayAlertMessage(strMessage: "Please enter email")
                }
            }
            else
            {
                self.displayAlertMessage(strMessage: "Please enter fullname")
            }
        }
    }
    
    // MARK: - Custom Methods
    
    func displayAlertMessage(strMessage : String)
    {
        let alert = UIAlertController(title: "CoreData Example", message: strMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
