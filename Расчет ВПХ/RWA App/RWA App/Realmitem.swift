//
//  Realmitem.swift
//  RWA App
//
//  Created by Александр on 26.05.2019.
//  Copyright © 2019 Alexander Melnichuk. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Airport: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var adrwy: String = ""
    @objc dynamic var brit: Bool = true
    @objc dynamic var ad: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var iata: String = ""
    @objc dynamic var rwy: String = ""
    @objc dynamic var hdg: Double = 0
    @objc dynamic var elev: Double = 0
    @objc dynamic var runway_slope: Double = 0
    @objc dynamic  var tora_available_run_length: Double = 0
    @objc dynamic var toda_available_takeoff_distance: Double = 0
    @objc dynamic var asda_accelerate_stop_distance: Double = 0
    @objc dynamic var lda_available_landing_distance: Double = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum AirportCodingKeys: String, CodingKey {
        case id
        case adrwy
        case brit
        case ad
        case name
        case iata
        case rwy
        case hdg
        case elev
        case runway_slope
        case tora_available_run_length
        case toda_available_takeoff_distance
        case asda_accelerate_stop_distance
        case lda_available_landing_distance
    }
    
    convenience init(id: Int, adrwy: String, brit: Bool, ad: String, name: String, iata: String, rwy: String, hdg: Double, elev: Double, runway_slope: Double, tora_available_run_length: Double, toda_available_takeoff_distance: Double, asda_accelerate_stop_distance: Double, lda_available_landing_distance: Double) {
        self.init()
        self.id = id
        self.adrwy = adrwy
        self.brit = brit
        self.ad = ad
        self.name = name
        self.iata = iata
        self.rwy = rwy
        self.hdg = hdg
        self.elev = elev
        self.runway_slope = runway_slope
        self.tora_available_run_length = tora_available_run_length
        self.toda_available_takeoff_distance = toda_available_takeoff_distance
        self.asda_accelerate_stop_distance = asda_accelerate_stop_distance
        self.lda_available_landing_distance = lda_available_landing_distance
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AirportCodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let adrwy = try container.decode(String.self, forKey: .adrwy)
        let brit = try container.decode(Bool.self, forKey: .brit)
        let ad = try container.decode(String.self, forKey: .ad)
        let name = try container.decode(String.self, forKey: .name)
        let iata = try container.decode(String.self, forKey: .iata)
        let rwy = try container.decode(String.self, forKey: .rwy)
        let hdg = try container.decode(Double.self, forKey: .hdg)
        let elev = try container.decode(Double.self, forKey: .elev)
        let runway_slope = try container.decode(Double.self, forKey: .runway_slope)
        let tora_available_run_length = try container.decode(Double.self, forKey: .tora_available_run_length)
        let toda_available_takeoff_distance = try container.decode(Double.self, forKey: .toda_available_takeoff_distance)
        let asda_accelerate_stop_distance = try container.decode(Double.self, forKey: .asda_accelerate_stop_distance)
        let lda_available_landing_distance = try container.decode(Double.self, forKey: .lda_available_landing_distance)
        self.init(id: id, adrwy: adrwy, brit: brit, ad: ad, name: name, iata: iata, rwy: rwy, hdg: hdg, elev: elev, runway_slope: runway_slope, tora_available_run_length: tora_available_run_length, toda_available_takeoff_distance: toda_available_takeoff_distance, asda_accelerate_stop_distance: asda_accelerate_stop_distance, lda_available_landing_distance: lda_available_landing_distance)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
}
