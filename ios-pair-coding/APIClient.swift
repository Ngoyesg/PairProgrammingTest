//
//  APIClient.swift
//  ios-pair-coding
//
//  Copyright © 2022 Mercedes-Benz.io GmbH. All rights reserved.
//

import Foundation
import MapKit

class APIClient {

    static let shared = APIClient()

    private let dispatchQueue = DispatchQueue(label: "api.fillingstations", qos: .userInitiated)
    private let names = ["Aral", "TotalEnergies", "Shell", "Sprint", "Esso", "Elan", "JET", "HEM"]

    func requestStations(northWest: CLLocationCoordinate2D,
                         northEast: CLLocationCoordinate2D,
                         southEast: CLLocationCoordinate2D,
                         southWest: CLLocationCoordinate2D,
                         completion: @escaping ([FillingStation]) -> Void) {
        dispatchQueue.async {
            var fillingStations = [FillingStation]()
            for _ in 0 ..< 5 {
                let name = self.names.randomElement() ?? ""
                fillingStations.append(
                    FillingStation(
                        id: UUID().uuidString.replacingOccurrences(of: "-", with: ""),
                        name: name,
                        lat: Double.random(in: southWest.latitude ..< northWest.latitude),
                        lng: Double.random(in: northWest.longitude ..< northEast.longitude),
                        brand_id: name.lowercased()
                    )
                )
            }
            completion(fillingStations)
        }
    }

    func requestPrice(for station: FillingStation, completion: (Int?) -> Void) {
        let price = Int.random(in: 1..<10)
        completion(price)
    }

}
