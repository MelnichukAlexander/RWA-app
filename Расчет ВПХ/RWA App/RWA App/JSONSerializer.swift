//
//  JSONSerializer.swift
//  RWA App
//
//  Created by Александр on 26.05.2019.
//  Copyright © 2019 Alexander Melnichuk. All rights reserved.
//

import Foundation
import RealmSwift

class JSONSerializer {
    func serialize(input sourceName: String) {
      //  let urlString = "https://efbgroup.ru/airports_data.json"
       // guard let url = URL(string: urlString) else { return }
        
        let url = URL(string: "https://efbgroup.ru/airport_data_3.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: url!)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard json is [AnyObject] else {
                    assert(false, "failed to parse")
                    return
                }
                do {
                    let Airports = try jsonDecoder.decode([Airport].self, from: data)
                    
                    let realm = try! Realm()
                
                    try! realm.write {     // стираем БД перед повторной загрузкой
                        realm.deleteAll()
                    }
                    
                    for Airport in Airports { //вносим данные в БД
                        try! realm.write {
                            realm.add(Airport)
                        }
                    }
                } catch {
                    print("failed to convert data")
                }
            } catch let error {
                print(error)
            }
            }.resume()
        
       
   /*     URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            
            let jsonDecoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: url!)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard json is [AnyObject] else {
                    assert(false, "failed to parse")
                    return
                }
                do {
                    let Airports = try jsonDecoder.decode([Airport].self, from: data)
                    let realm = try! Realm()
                    for Airport in Airports {
                        try! realm.write {
                            realm.add(Airport)
                        }
                    }
                } catch {
                    print("failed to convert data")
                }
            } catch let error {
                print(error)
            }
        } */
    }
    
}
