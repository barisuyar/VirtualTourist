//
//  TravelMapVC.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 11.01.2022.
//

import UIKit
import MapKit
import CoreData

final class TravelMapVC: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet private weak var mapView: MKMapView!

    var fetchedResultsController: NSFetchedResultsController<Pin>?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pin a Location"
        setupFetchedResultsController()
        loadZoomLevel()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongTap(gesture: )))
        mapView.addGestureRecognizer(gestureRecognizer)
        saveZoomLevel()
    }

    func saveZoomLevel() {
        UserDefaults.standard.set(mapView.centerCoordinate.latitude, forKey: ZoomLevelKeysConstants.latitude)
        UserDefaults.standard.set(mapView.centerCoordinate.longitude, forKey: ZoomLevelKeysConstants.longitude)
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: ZoomLevelKeysConstants.latitudeDelta)
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: ZoomLevelKeysConstants.longitudeDelta)
    }

    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: DataController.shared.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }

    @objc private func didLongTap(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .ended else { return }
        let location = gesture.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.setCenter(mapView.centerCoordinate, animated: true)
        persistPin(lat: coordinate.latitude, lon: coordinate.longitude)
    }

    private func persistPin(lat: Double, lon: Double) {
        let context = DataController.shared.viewContext
        let pin = Pin(context: context)
        pin.latitude = lat
        pin.longitude = lon
        pin.page = 1
        pin.creationDate = Date()
        try? context.save()
        setupFetchedResultsController()
    }

    private func loadZoomLevel() {
        guard let longitude = UserDefaults.standard.object(forKey: ZoomLevelKeysConstants.longitude) as? Double,
              let latitude = UserDefaults.standard.object(forKey: ZoomLevelKeysConstants.latitude) as? Double,
              let latitudeDelta = UserDefaults.standard.object(forKey: ZoomLevelKeysConstants.latitudeDelta) as? Double,
              let longitudeDelta = UserDefaults.standard.object(forKey: ZoomLevelKeysConstants.longitudeDelta) as? Double else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

        guard let pins = fetchedResultsController?.fetchedObjects else { return }
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            mapView.addAnnotation(annotation)
        }
    }
}
