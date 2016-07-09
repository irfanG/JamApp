//
//  TextFieldTVC.swift
//  DzematApp
//
//  Created by Irfan Godinjak on 03/07/16.
//  Copyright © 2016 eu.devlogic. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
class TextFieldTVC: UITableViewCell {

    @IBOutlet weak var simpleTextFiled: JVFloatLabeledTextField!
    static let reuseIdentifier = TVC.textField
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        simpleTextFiled.defaultSetting()
        layer.cornerRadius = 10
        backgroundColor = UIColor.appleDark
        
        print("I'm running!")
       
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
     required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)!
    }
    

    var dataSource: String? {
        didSet {
            guard let dataSource: String = dataSource else { return }
            simpleTextFiled.attributedPlaceholder =  NSAttributedString(string: dataSource, attributes: [NSForegroundColorAttributeName : UIColor.ivory])
        }
    }
    
}


