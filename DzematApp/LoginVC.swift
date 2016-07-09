//
//  LoginVC.swift
//  DzematApp
//
//  Created by Irfan Godinjak on 05/05/16.
//  Copyright © 2016 eu.devlogic. All rights reserved.
//

import UIKit

class LoginVC: BaseVC, UITableViewDelegate, UITableViewDataSource, BaseVCProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    let reuseIdentifierForTextFieldCell = TVC.textField

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        hideNavigationBar(true)
        registerNIB()
    }
    func registerNIB(){
        let textFieldTVC = UINib(nibName: reuseIdentifierForTextFieldCell , bundle:nil)
        tableView.registerNib(textFieldTVC, forCellReuseIdentifier: reuseIdentifierForTextFieldCell)        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: UITableViewDelegate
extension LoginVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideNavigationBar(true)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clearColor()
        tableView.separatorStyle  = .None
     
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


// MARK: UITableViewDelegate 
extension LoginVC{
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return HeaderView.init(frame: tableView.rectForHeaderInSection(section), title: Placeholders.LoginTitle)
    }
        return UIView()
    }
 
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
            return 10
    }
}


// MARK: UITableViewDataSource
extension LoginVC {
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let section = LoginSections(rawValue: indexPath.section) else { fatalError(LoginSections.errorMessage) }

        let cell =  tableView.dequeueReusableCellWithIdentifier(TVC.textField, forIndexPath: indexPath) as! TextFieldTVC
        switch section {
        case .Email:
            cell.dataSource = Placeholders.Email
        case .Password:
            cell.dataSource = Placeholders.Password
        }
            return cell
        }
}

//MARK : UITable Row and Section Enumerators
enum LoginSections: Int {
    case Email = 0, Password
    static var errorMessage: String { return "Unrecognized Section" }
}
