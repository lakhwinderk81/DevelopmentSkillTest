//
//  HomeVC.swift
//  Lakhwinder
//
//  Created by GuruNanak on 5/22/20.
//  Copyright © 2020 SkillTest. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeVC: UIViewController {

    @IBOutlet var lblLocation: UILabel?
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var lblTemp: UILabel?
    @IBOutlet var lblDay: UILabel?
    @IBOutlet var lblMaxTemp: UILabel?
    @IBOutlet var lblMinTemp: UILabel?
    @IBOutlet var collectionTimeslots: UICollectionView?
    @IBOutlet var tblView: UITableView?
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var viewTodayTemp: UIView?
    @IBOutlet var imgBg: UIImageView?
    
    var lastContentOffset: CGFloat = 0
    var details = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getClimateDetails()
    }
    
    func setData() {
        let location = UserDefaults.standard.value(forKey: "location") as! String
        lblLocation?.text = location
        details = AppManager.shared.fetchDetails(for: lblLocation?.text ?? "")
        if details != JSON.null{
            imgBg?.image = details[0]["main_detail"].stringValue.getImage()
            lblTemp?.text = details[0]["temp"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)
            lblDetails?.text = details[0]["weather_description"].stringValue.capitalized
            lblMinTemp?.text = details[0]["temp_min"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)
            lblMaxTemp?.text = details[0]["temp_max"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "EEEE"
            lblDay?.text = dateformatter.string(from: Date()) + " Today"
            collectionTimeslots?.reloadData()
            tblView?.reloadData()
        }
    }
}

//MARK:- CollectionView Delegate & Datasource

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollCell
        cell.lblTime?.text = (indexPath.item+1).description + "AM"
        cell.lblTemp?.text = self.details[0]["temp"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)
        return cell
    }    
}

//MARK:- TableView Delegate & Datasource

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 6 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell :HomeCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeCell
            switch indexPath.row{
            case 0:
                cell.lblDay?.text = "Sunday"
            case 1:
                cell.lblDay?.text = "Monday"
            case 2:
                cell.lblDay?.text = "Tuesday"
            case 3:
                cell.lblDay?.text = "Wednesday"
            case 4:
                cell.lblDay?.text = "Thursday"
            case 5:
                cell.lblDay?.text = "Friday"
            case 6:
                cell.lblDay?.text = "Saturday"
            default:
                cell.lblDay?.text = "Sunday"
            }
            cell.lblMaxTemp?.text = details[0]["temp_max"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)
            cell.lblMinTemp?.text = details[0]["temp_min"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)
            return cell
        }else{
            let cell :HomeCell = tableView.dequeueReusableCell(withIdentifier: "specificationCell") as! HomeCell
            cell.lblDetail?.text = "Today: "+details[0]["main_detail"].stringValue+". It's currently "+details[0]["temp"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)+";the high will be "+details[0]["temp_max"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)+"."
            var date = Date.init(timeIntervalSince1970: details[0]["sunrise"].doubleValue)
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            cell.lblSunrise?.text = dateformatter.string(from: date)
            date = Date.init(timeIntervalSince1970: details[0]["sunset"].doubleValue)
            cell.lblSunset?.text = dateformatter.string(from: date)
            cell.lblWind?.text = "w " + details[0]["speed"].intValue.description + " km/hr"
            cell.lblUvIndex?.text = "4"
            cell.lblFeelLike?.text = details[0]["feels_like"].intValue.description + (NSString(format:"%@", "\u{00B0}") as String)
            cell.lblhumidity?.text = details[0]["humidity"].stringValue+"%"
            cell.lblPressure?.text = details[0]["pressure"].stringValue+"hPa"
            cell.lblVisibility?.text = "8.1 km"
            cell.lblRainPercent?.text = "20%"
            cell.lblPrecipitation?.text = details[0]["clouds"].stringValue+" cm"
            return cell
        }
        // ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 650
        return indexPath.section == 0 ? 60 : UITableView.automaticDimension
    }
    
}

//MARK:- ScrollView Delegate

extension HomeVC: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            viewTodayTemp?.isHidden = true
        } else if self.lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y <= 0{
            viewTodayTemp?.isHidden = false
        }
    }
    
//    MARK:- Webservices
    
    func getClimateDetails() {
        let url = climateURL + "?q=\(lblLocation?.text ?? "")&appid=" + appid
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
                    AppManager.shared.createContext(dic: dic, with: self.lblLocation?.text ?? "")
                    self.setData()
                }
        }, failureHandler: {
                error in
        }, networkHandler: {
                connectionFailed in
        })
    }
}
