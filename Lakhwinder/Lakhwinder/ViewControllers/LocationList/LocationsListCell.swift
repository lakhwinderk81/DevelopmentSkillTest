//
//  LocationsListCell.swift
//  Lakhwinder
//
//  Created by GuruNanak on 5/24/20.
//  Copyright © 2020 SkillTest. All rights reserved.
//

import UIKit

class LocationsListCell: UITableViewCell {

    @IBOutlet var lblTime:UILabel?
    @IBOutlet var lblLocation:UILabel?
    @IBOutlet var lblTemp:UILabel?
    @IBOutlet var imgBg:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
