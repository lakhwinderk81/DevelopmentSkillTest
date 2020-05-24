//
//  HomeCell.swift
//  Lakhwinder
//
//  Created by GuruNanak on 5/24/20.
//  Copyright © 2020 SkillTest. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet var lblDay:UILabel?
    @IBOutlet var lblMaxTemp:UILabel?
    @IBOutlet var lblMinTemp:UILabel?
    @IBOutlet var lblDetail:UILabel?
    @IBOutlet var lblSunrise:UILabel?
    @IBOutlet var lblSunset:UILabel?
    @IBOutlet var lblRainPercent:UILabel?
    @IBOutlet var lblhumidity:UILabel?
    @IBOutlet var lblWind:UILabel?
    @IBOutlet var lblFeelLike:UILabel?
    @IBOutlet var lblPrecipitation:UILabel?
    @IBOutlet var lblPressure:UILabel?
    @IBOutlet var lblVisibility:UILabel?
    @IBOutlet var lblUvIndex:UILabel?
    @IBOutlet var imgClimate:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
