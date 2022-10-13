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
    var dissmissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        setMapView()
        view.addSubview(dissmissButton)
        setDissmissButton()
        addCustomPin()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest // battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func setDissmissButton(){
        let safeArea = self.view.safeAreaLayoutGuide
        dissmissButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        dissmissButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        dissmissButton.tintColor = .white
        dissmissButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        dissmissButton.addTarget(self, action: #selector(dissmissMapView), for: .touchUpInside)
    }

    func setMapView(){
        mapView.delegate = self
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
        let pin = MKPointAnnotation()
        
        let firstCoordinate = CLLocationCoordinate2D(latitude: 36.0139,
                                                     longitude: 129.3232)
        let secondCoordinate = CLLocationCoordinate2D(latitude: 36.0192,
                                                     longitude: 129.3433)
        pin.coordinate = firstCoordinate
        mapView.addAnnotation(pin)
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
    
    @objc func dissmissMapView(){
        navigationController?.popViewController(animated: true)
//        navigationController?.popToRootViewController(animated: true)
//        navigationController?.popViewController(animated: true)
//        navigationController?.popToViewController(PlacePlayListViewController, animated:  )
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
}
