//
//  ViewController.swift
//  ios-pair-coding
//
//  Copyright © 2022 Mercedes-Benz.io GmbH. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var loadStationsButton: UIButton!
    @IBOutlet var totalStationsLabel: UILabel!
    @IBOutlet var stationNameLabel: UILabel!
    @IBOutlet var stationBrandLabel: UILabel!
    @IBOutlet var stationLocationLabel: UILabel!
    @IBOutlet var detailView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.5159, longitude: 13.417), latitudinalMeters: 5_000, longitudinalMeters: 5_000), animated: false)
        mapView.delegate = self
        loadStationsButton.setTitle("Load Stations", for: .normal)
    }

    @IBAction func didTapLoadStationsButton(_ sender: UIButton) {
        requestStations()
    }

    private func requestStations() {
        mapView.removeAnnotations(mapView.annotations)
        let northWest = mapView.convert(.zero, toCoordinateFrom: mapView)
        let northEast = mapView.convert(CGPoint(x: mapView.frame.size.width, y: 0), toCoordinateFrom: mapView)
        let southEast = mapView.convert(CGPoint(x: mapView.frame.size.width, y: mapView.frame.size.height), toCoordinateFrom: mapView)
        let southWest = mapView.convert(CGPoint(x: 0, y: mapView.frame.size.height), toCoordinateFrom: mapView)

        APIClient.shared.requestStations(northWest: northWest,
                                         northEast: northEast,
                                         southEast: southEast,
                                         southWest: southWest) { stations in

            self.totalStationsLabel.text = "In total there are \(stations.count) stations";

            for var station in stations {
                APIClient().requestPrice(for: station) { price in
                    station.price = price
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: station.lat, longitude: station.lng)
                    annotation.title = station.name
                    annotation.subtitle = station.brand_id
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! MKPointAnnotation
        stationNameLabel.text = annotation.title
        stationLocationLabel.text = "Location: \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        stationBrandLabel.text = annotation.subtitle
        detailView.isHidden = false
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        detailView.isHidden = true
    }

}
