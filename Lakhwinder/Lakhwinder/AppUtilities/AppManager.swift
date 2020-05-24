//
//  AppManager.swift
//  Lakhwinder
//
//  Created by GuruNanak on 5/23/20.
//  Copyright © 2020 SkillTest. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class AppManager: NSObject {

    //MARK: - Singlton
    class var shared:AppManager{
        struct  Singlton{
            static let instance = AppManager()
        }
        return Singlton.instance
    }
    
    func createContext(dic: [String:Any],with location:String) {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "LocationData", in: context)
        let newRecord = NSManagedObject(entity: entity!, insertInto: context)
        //fetching same record
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationData")
        request.predicate = NSPredicate(format: "location_name = %@", location)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for obj in (result as! [NSManagedObject]){
                context.delete(obj)
            }
        } catch {
            print("Failed")
        }
        //Saving the value
        for (key,value) in dic{
            newRecord.setValue(value, forKey: key)
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchDetails(for location:String) -> JSON {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationData")
        request.predicate = NSPredicate(format: "location_name = %@", location)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print(result)
            print(convertToJSONArray(moArray: result as! [NSManagedObject]))
            return JSON.init(convertToJSONArray(moArray: result as! [NSManagedObject]))
        } catch {
            return JSON.null
        }
    }
    
    func fetchAllDetails() -> [JSON] {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationData")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print(result)
            print(convertToJSONArray(moArray: result as! [NSManagedObject]))
            return JSON.init(convertToJSONArray(moArray: result as! [NSManagedObject])).arrayValue
        } catch {
            return [JSON]()
        }
    }
    
    func deleteAll()  {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationData")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print(result)
            for data in (result as! [NSManagedObject]){
                context.delete(data)
            }
        } catch {
        }
    }
    
    func deleteLocation(for location:String) -> Bool {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationData")
        request.predicate = NSPredicate(format: "location_name = %@", location)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print(result)
            for data in (result as! [NSManagedObject]){
                context.delete(data)
            }
            return true
        } catch {
            return false
        }
    }
    
    func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
}
