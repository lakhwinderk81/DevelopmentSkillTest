//
//  LocationListVC.swift
//  Lakhwinder
//
//  Created by GuruNanak on 5/24/20.
//  Copyright © 2020 SkillTest. All rights reserved.
//

import UIKit
import SwiftyJSON

class LocationListVC: UIViewController {

    @IBOutlet var tblLocations: UITableView?
    @IBOutlet var lblcf: UILabel?
    
    var locations = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblcf?.text = (NSString(format:"%@", "\u{00B0}") as String)+"C/"+(NSString(format:"%@", "\u{00B0}") as String)+"F"
        self.locations = AppManager.shared.fetchAllDetails()
        tblLocations?.reloadData()
    }
    
    @IBAction func btnAddLocationAction(sender: UIButton){
        let alert = UIAlertController(title: "Add location", message: "Enter location name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Location Name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.getClimateDetails(location: textField?.text ?? "")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LocationListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LocationsListCell
        cell.lblLocation?.text = locations[indexPath.row]["location_name"].stringValue
        cell.lblTemp?.text = locations[indexPath.row]["temp"].intValue.description+(NSString(format:"%@", "\u{00B0}") as String)
        cell.imgBg?.image = locations[indexPath.row]["main_detail"].stringValue.getImage()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(locations[indexPath.row]["location_name"].stringValue, forKey: "location")
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if AppManager.shared.deleteLocation(for: locations[indexPath.row]["location_name"].stringValue){
                tableView.deleteRows(at: [indexPath], with: .none)
                self.locations = AppManager.shared.fetchAllDetails()
            }
        }
    }
}

extension LocationListVC{
    func getClimateDetails(location: String) {
        if location == "" {
            return
        }
        let url = climateURL + "?q=\(location)&appid=" + appid
        ServerManger.shared.httpGet(request: url, successHandler:
            {
                response in
                print(response)
                if response["cod"].intValue != 404{
                    let dic :[String:Any] = ["clouds":response["clouds"]["all"].doubleValue,
                                             "deg":response["wind"]["deg"].doubleValue,
                                             "feels_like":response["main"]["feels_like"].doubleValue,
                                             "humidity":response["main"]["humidity"].doubleValue,
                                             "main_detail":response["weather"][0]["main"].stringValue,
                                             "pressure":response["main"]["pressure"].doubleValue,
                                             "sea_level":response["main"]["sea_level"].doubleValue,
                                             "speed":response["wind"]["speed"].doubleValue,
                                             "sunrise":response["sys"]["sunrise"].doubleValue,
                                             "sunset":response["sys"]["sunset"].doubleValue,
                                             "temp":response["main"]["temp"].doubleValue,
                                             "temp_max":response["main"]["temp_max"].doubleValue,
                                             "temp_min":response["main"]["temp_min"].doubleValue,
                                             "location_name":response["name"].stringValue,
                                             "weather_description":response["weather"][0]["description"].stringValue]
                    AppManager.shared.createContext(dic: dic, with: location)
                    self.locations = AppManager.shared.fetchAllDetails()
                    self.tblLocations?.reloadData()
                }
        }, failureHandler: {
            error in
        }, networkHandler: {
            connectionFailed in
        })
    }
}
