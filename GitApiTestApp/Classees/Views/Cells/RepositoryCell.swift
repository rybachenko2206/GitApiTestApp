//
//  RepositoryCell.swift
//  GitApiTestApp
//
//  Created by Roman Rybachenko on 02.03.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell, ReusableCell {
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pushedAtLabel: UILabel!
    
    
    static var height: CGFloat {
        return 78
    }
    
}
