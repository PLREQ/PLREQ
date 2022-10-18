//
//  MapViewController.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/09/27.
//

import CoreLocation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var playListList: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setMapView()
        setdismissButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // battery
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // Map을 처음 켰을 때 현재 위치를 받아옵니다.
    func setCurrentLocation(){
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            guard let currentLocation = locationManager.location else {
                return
            }
        }
    }

    func configuration() {
        setCurrentLocation()
        playListList = PLREQDataManager.shared.fetch()

        for i in 0..<playListList.count{
            let playListData = playListList[i]
            // 현재 들어오는 좌표를 확인하기 위해 남겨둔 코드입니다. 추후에 삭제하겠습니다.
            print("💙💙💙💙💙: ", playListData.dataToDouble(forKey: "latitude"))

            // TODO: Longtitude, Latitude의 데이터 타입을 Float을 Double로 바꿀 필요가 있습니다
            addCustomPin(playListData.dataToDouble(forKey: "latitude"), playListData.dataToDouble(forKey: "longtitude"))

        }

        // Test Coordinate입니다 이슈가 해결되면 삭제하겠습니다.
//        addCustomPin(21.282778, -157.829444)
//        addCustomPin(21.282778, -150.829444)
    }

    func setdismissButton() {
        view.addSubview(dismissButton)
        let safeArea = self.view.safeAreaLayoutGuide
        dismissButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        dismissButton.tintColor = .white
        dismissButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissMapView), for: .touchUpInside)
    }

    func setMapView() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
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

   func addCustomPin(_ latitude: Double, _ longtitude: Double) {

        let pin = MKPointAnnotation()
       let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                longitude: longtitude)
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }

    @objc func dismissMapView(){
        navigationController?.popViewController(animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapView")

//        if annotation ==  nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "MapView")
//            annotationView?.canShowCallout = true
//        } else {
//            annotationView?.annotation = annotation
//        }
        return annotationView
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
