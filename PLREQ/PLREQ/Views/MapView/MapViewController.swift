//
//  MapViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/09/27.
//

import CoreLocation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.delegate = self
        addCustomPin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest // battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location: CLLocation){
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        mapView.setRegion(region,
                          animated: true)

    }
    
    func addCustomPin() {
        // testpin
        let firstPin = MKPointAnnotation()
        let secondPin = MKPointAnnotation()
        
        let firstCoordinate = CLLocationCoordinate2D(latitude: 36.0139,
                                                     longitude: 129.3232)
        let secondCoordinate = CLLocationCoordinate2D(latitude: 36.0192,
                                                     longitude: 129.3433)
        firstPin.coordinate = firstCoordinate
        secondPin.coordinate = secondCoordinate
        mapView.addAnnotation(firstPin)
        mapView.addAnnotation(secondPin)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
         
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotation ==  nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
//        annotationView?.inputView(
        
        
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
}
