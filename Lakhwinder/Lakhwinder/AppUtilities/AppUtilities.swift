//
//  AppUtilities.swift
//  Lakhwinder
//
//  Created by GuruNanak on 5/23/20.
//  Copyright © 2020 SkillTest. All rights reserved.
//

import UIKit

let appid = "66c3fd0cb6de2383542585703136321a"
let climateURL = "http://api.openweathermap.org/data/2.5/weather"

extension String{
    func getImage() ->UIImage{
        switch self {
        case "Clear":
            return UIImage.init(named: "clear Sky")!
        case "Sunny":
            return UIImage.init(named: "sunny")!
        case "Thunder":
            return UIImage.init(named: "thunderstorm")!
        case "Rainy","Haze":
            return UIImage.init(named: "rainy")!
        default:
            return UIImage.init(named: "clouds")!
        }
    }
}
