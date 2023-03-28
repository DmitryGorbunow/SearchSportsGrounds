//
//  ViewController.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/9/23.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var calloutView: CalloutView!
    @IBOutlet weak var locationButton: UIButton!
    
    // MARK: - Private properties
    private let locationManager = CLLocationManager()
    private var regionInMeters: Double = 3000
    private var route: [MKRoute] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        checkLocationService()
        DataManager.shared.loadPlaces()
       
        mapView.addAnnotations(DataManager.shared.places)
        
        calloutView.showOverlay = { [weak self] (place, distance) in
            let vc = DetailsViewController(place: place, distance: distance)
            let navigationController = UINavigationController(rootViewController: vc)
            self?.present(navigationController, animated: true)
        }
        locationButton.corneredRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Private funcs
    private func setupTextField() {
        searchTextField.layer.shadowColor = UIColor.systemGray3.cgColor
        searchTextField.layer.shadowOpacity = 1
        searchTextField.layer.shadowOffset = .zero
        searchTextField.layer.shadowRadius = 5
        searchTextField.addLeft(image: UIImage(named: "magnifyingglass")!)
        searchTextField.delegate = self
    }
    
    private func checkLocationService() {
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {
                // Show alert letting the user know they have to turn this on.
                self.showAlert(title: "Ошибка", message: "Включите использование геопозиции")
                return
            }
        }
        
        setupLocationManager()
        checkLocationAuthorization()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Show alert instructing them how to turn on permissions
            showAlert(title: "Ошибка",
                      message: "Нет прав на использование ваших координат. Разрешите использовать ваши координаты в настройках устройства")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func createPath(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D) {
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let  direction = MKDirections(request: directionRequest)
        direction.calculate { [weak self] (response, error) in
            guard let response = response else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            self?.route = response.routes
            
            if let route = self?.route.first?.polyline {
                self?.mapView.addOverlay(route, level: MKOverlayLevel.aboveRoads)
            }
        }
    }
    
    func distanceBetweenTwoPointsInString(location1: CLLocation, location2: CLLocation) -> String {
        
        let distance = location1.distance(from: location2)
        
        if distance >= 1000 {
            return String(format: " ~ %.0f км", distance / 1000)
        } else {
            return String(format: " ~ %.0f м", distance)
        }
    }
    
    @IBAction func locationButtonAction(_ sender: Any) {
        centerViewOnUserLocation()
    }
}

// MARK: - Extension: UICollectionViewDataSource
extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(text: DataManager.shared.cells[indexPath.row])
        return cell
    }
}

// MARK: - Extension: UICollectionViewDelegate
extension MapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) is FilterCollectionViewCell {
            
            let titleMatches = DataManager.shared.places.filter { $0.subtitle == DataManager.shared.cells[indexPath.row] }
            
            mapView.removeAnnotations(DataManager.shared.places)
            DataManager.shared.places = titleMatches
            mapView.addAnnotations(DataManager.shared.places)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            cell.cellView.backgroundColor = .white
            cell.filterLabel.textColor = UIColor(named: "TextColor")
            
            mapView.removeAnnotations(DataManager.shared.places)
            DataManager.shared.loadPlaces()
            mapView.addAnnotations(DataManager.shared.places)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
        if item.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            item.cellView.backgroundColor = .white
            item.filterLabel.textColor = UIColor(named: "TextColor")
            mapView.removeAnnotations(DataManager.shared.places)
            DataManager.shared.loadPlaces()
            mapView.addAnnotations(DataManager.shared.places)
        } else {
            item.cellView.backgroundColor = UIColor(named: "YellowColor")
            item.filterLabel.textColor = .white
            return true
        }
        
        return false
    }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        label.text = DataManager.shared.cells[indexPath.row]
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + 20,
                      height: 30)
    }
    
}

// MARK: - Extension: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

// MARK: - Extension: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let reuseIdentifier = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "glyphImage")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !(view.annotation is MKUserLocation) else { return }
        guard let annotation = view.annotation else { return }
        
        view.image = UIImage(named: "selectedGlyphImage")
        
        let span = mapView.region.span
        
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        calloutView.isHidden = false
        calloutView.configure(coordinate: annotation.coordinate.latitude)
        
        guard let location = locationManager.location else { return }
        
        let distance = distanceBetweenTwoPointsInString(location1: location, location2: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
        
        calloutView.getDistance(distance: distance)
        
        calloutView.buildRoute = { [weak self] in
            self?.createPath(sourceLocation: location.coordinate, destinationLocation: annotation.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "glyphImage")
        calloutView.isHidden = true
        
        if let route = route.first?.polyline {
            self.mapView.removeOverlay(route)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 2
        renderer.strokeColor = UIColor(named: "YellowColor")
        renderer.lineDashPattern = [3, 3]
        return renderer
    }
}

// MARK: - Extension: UITextFieldDelegate
extension MapViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        search(searchText)
    }
    
    func search(_ query: String) {
        if query.count >= 2 {
            DataManager.shared.filteredPlaces = DataManager.shared.places.filter { $0.name.lowercased().contains(query.lowercased()) }
        } else {
            DataManager.shared.filteredPlaces = DataManager.shared.places
        }
        mapView.removeAnnotations(DataManager.shared.places)
        mapView.addAnnotations(DataManager.shared.filteredPlaces)
    }
}












