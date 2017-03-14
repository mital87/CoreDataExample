//
//  UserListVC.swift
//  CoreDataExample
//
//  Created by Mital Solanki on 10/3/17.
//  Copyright © 2017 DEFSYS GROUP. All rights reserved.
//

import UIKit
import CoreData

class UserListVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    // MARK: - Variable & Properties
    
    @IBOutlet weak var tblUsers: UITableView!
    var arrUsers : [User] = []
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        getUsers()
        tblUsers.reloadData()
    }

    // MARK: - UITableView DataSource / Delegate Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrUsers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let lblName = aCell.viewWithTag(100) as! UILabel
        let lblEmail = aCell.viewWithTag(101) as! UILabel
        let lblContactNo = aCell.viewWithTag(102) as! UILabel
        
        let aUser = arrUsers[indexPath.row] 
        
        lblName.text = aUser.fullName
        lblEmail.text = aUser.email
        lblContactNo.text = aUser.contactNo

        return aCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            // ==================== Delete User ==================== //
            
            // Delete Record From CoreData & TableView
            
            let context = AppDelegate.shared.persistentContainer.viewContext
            let user = arrUsers[indexPath.row]
            context.delete(user)
            AppDelegate.shared.saveContext()
            arrUsers.remove(at: indexPath.row)
            tblUsers.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "pushToAddUserVC", sender: arrUsers[indexPath.row])
    }
    
    // MARK: - Button Click Events
    
    @IBAction func AddUserBtnClick(_ sender: UIButton)
    {
       self.performSegue(withIdentifier: "pushToAddUserVC", sender: nil)
    }
    
    // MARK: - UIStoryboardSegue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "pushToAddUserVC")
        {
            let aVC = segue.destination as! AddUserVC
            aVC.aUser = sender as! User?
        }
    }
    
    // MARK: - Custom Methods
    
    func getUsers()
    {
        // ==================== Fetch User ==================== //
        
        // Fetch Record From CoreData
        
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        // Method: - 1
        
//        do
//        {
//            arrUsers = try context.fetch(User.fetchRequest())
//        }
//        catch
//        {
//            print("Users fetching fail")
//        }
        
        // Method: - 2
        
//        let fetchRequest = NSFetchRequest<User>()
//        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: context)
//        fetchRequest.entity = entityDescription
        
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        
//        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            arrUsers = try context.fetch(fetchRequest)            
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
}
