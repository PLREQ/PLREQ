//
//  MapViewController.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/09/27.
//  Reference https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data

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
    private var allAnnotations: [MKAnnotation]?
    
    private var displayedAnnotations: [MKAnnotation]? {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                mapView.removeAnnotations(currentAnnotations)
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                mapView.addAnnotations(newAnnotations)
            }
        }
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setMapView()
        setdismissButton()

        // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        registerMapAnnotationViews()
        showAnnotation()
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
    }

    // MARK: - viewWillAppear
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

    // 플레이리스트의 위치 정보를 받아오고 핀을 찍어줍니다.
    func configuration() {
        setCurrentLocation()
        playListList = PLREQDataManager.shared.fetch()

        for i in 0..<playListList.count{
            let playListData = playListList[i]
            addCustomPin(
                playListData.dataToDouble(forKey: "latitude"),
                playListData.dataToDouble(forKey: "longtitude")
            )
        }
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

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
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

    // MARK: - 기본 핀
    func addDefaultPin(_ latitude: Double, _ longtitude: Double) {

        let pin = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                longitude: longtitude)
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }

    // MARK: - 커스텀 핀
    func addCustomPin(_ latitude: Double, _ longtitude: Double) {
        let customAnnotation = CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: latitude,
                                               longitude: longtitude))
        customAnnotation.imageName = "ella"
        mapView.addAnnotation(customAnnotation)
        showAnnotation()
    }

    // MARK: - 뒤로가기
    @objc func dismissMapView(){
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Custom Annotation Identifier 등록을 해줍니다.
    private func registerMapAnnotationViews() {
        mapView.register(
            CustomAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
    }

    // MARK: - Annotation View를 등록해줍니다
    private func registerMapAnnotationView() {
        mapView.register(
            CustomAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
    }

    private func showAnnotation(){
        displayedAnnotations = allAnnotations
    }
}

extension MapViewController: CLLocationManagerDelegate {

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

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?

        // Custom Annotation
        if let annotation = annotation as? CustomAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
        }
        return annotationView
    }

    // Custom AnnotationView
    private func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotation.self), for: annotation)
    }

}
