//
//  ServerManger.swift
//  Lakhwinder
//
//  Created by GuruNanak on 5/23/20.
//  Copyright © 2020 SkillTest. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Alamofire
import SwiftyJSON

typealias ServerSuccessCallBack = (_ json:JSON)->Void
typealias ServerFailureCallBack=(_ error:Error?)->Void
typealias ServerNetworkConnectionCallBck = (_ reachable:Bool) -> Void

enum ReachabilityType {
    case WWAN,
    WiFi,
    NotConnected
}

class ServerManger: NSObject {

    //MARK: - Singlton
    class var shared:ServerManger{
        struct  Singlton{
            static let instance = ServerManger()
        }
        return Singlton.instance
    }
    
    //MARK:-httpGetRequest-
    
    func httpGet(request url:String! ,successHandler:ServerSuccessCallBack?,failureHandler:ServerFailureCallBack?,networkHandler:ServerNetworkConnectionCallBck?){
        if self.isConnectedToNetwork(){
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            Alamofire.request(request).responseJSON {
                (response:DataResponse<Any>) in
                print(response)
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = JSON(data: response.data!)
                        if (successHandler != nil){
                            if ((json.null) == nil){
                                successHandler!(json)
                            }
                        }
                    }
                    break
                case .failure(_):
                    if (failureHandler != nil){
                        failureHandler!(response.result.error!)
                    }
                    break
                }
            }
        }else{
            networkHandler!(false)
        }
    }

    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
