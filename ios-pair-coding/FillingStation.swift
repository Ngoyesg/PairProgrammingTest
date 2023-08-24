//
//  FillingStation.swift
//  ios-pair-coding
//
//  Copyright © 2022 Mercedes-Benz.io GmbH. All rights reserved.
//

import Foundation

struct FillingStation: Codable {

    let id: String
    let name: String
    let lat: Double
    let lng: Double
    let brand_id: String?
    var price: Int?

}
