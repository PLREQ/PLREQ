//
//  MapViewController.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/10/29.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
        var dismissButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
    }()
    
    var playListList: [NSManagedObject] {
        return PLREQDataManager.shared.fetch()
    }

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
            render()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setMapView()
        view.addSubview(dismissButton)
        setDismissButton()
        registerMapAnnotationView()
        showAnnotations()

    }

    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocationManager()
    }

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

        for i in 0..<playListList.count{
            let playListData = playListList[i]
            addCustomPin(
                playListData.dataToDouble(forKey: "latitude"),
                playListData.dataToDouble(forKey: "longtitude"),
                playListDB: playListList[i] as! PlayListDB
            )
        }
    }

    // MARK: - 커스텀 핀
    func addCustomPin(_ latitude: Double, _ longtitude: Double, playListDB: PlayListDB) {
        let customAnnotation = CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: latitude,
                                               longitude: longtitude),
            playListDB: playListDB)
        mapView.addAnnotation(customAnnotation)
        showAnnotations()
    }
    
    func setMapView() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.delegate = self
    }
    
    func setDismissButton() {
        let safeArea = self.view.safeAreaLayoutGuide
        dismissButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        dismissButton.contentVerticalAlignment = .fill
        dismissButton.contentHorizontalAlignment = .fill
        dismissButton.tintColor = .white
        dismissButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissMapView), for: .touchUpInside)
    }
    
    // MARK: - 뒤로가기
    @objc func dismissMapView(){
        navigationController?.popViewController(animated: true)
    }
    
    // Custom Annotation 등록
    private func registerMapAnnotationView() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
    }
    
    func render() {
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let center = CLLocationCoordinate2D(latitude: 37.786_996, longitude: -122.440_100)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    }

    func render(_ location: CLLocation){

        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)

        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)

        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        mapView.setRegion(region, animated: true)
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }

    // MARK: - Button Actions
    func showAnnotations() {
        displayedAnnotations = allAnnotations
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func setLocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {

        if let annotation = annotation as? CustomAnnotation {

            let storyBoard = UIStoryboard(name: "PlayListDetailView", bundle: nil)

            guard let playListDetailViewController = storyBoard.instantiateViewController(withIdentifier: "PlayListDetailView") as? PlayListDetailViewController else { return }

            playListDetailViewController.playList = annotation.playList

            self.navigationController?.pushViewController(playListDetailViewController, animated: true)
        }
        
        // selected된 annotation을 deselected로 전환합니다
        mapView.deselectAnnotation(annotation, animated: false)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? CustomAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
        }
        
        return annotationView
    }
    
    private func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotation.self), for: annotation)
    }
}
