//
//  HeaderView.swift
//  DzematApp
//
//  Created by Irfan Godinjak on 04/07/16.
//  Copyright © 2016 eu.devlogic. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        headerLabel.text = title
        self.backgroundColor = .clearColor()
        self.addSubview(headerLabel)
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    lazy var headerLabel: UILabel = {
        let title: UILabel = UILabel.init(frame: self.frame)
        title.textColor = .whiteColor()
        title.labelFont = UIFont.preferredDzematFontForTextStyle(.Title5)
        return title
    }()
  
}
