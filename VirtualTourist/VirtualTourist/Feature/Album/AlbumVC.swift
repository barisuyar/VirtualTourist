//
//  AlbumVC.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

import UIKit
import MapKit
import CoreData

final class AlbumVC: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var renewButton: UIButton!
    @IBOutlet weak var noImageLabel: UILabel!

    var pin: Pin?
    var photo: Photo?
    var fetchedResultsController: NSFetchedResultsController<Photo>?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        setupFetchedResultsController()
        getPhotos(page: pin?.page ?? 1)
        setupMap()
    }

    func setupFetchedResultsController() {
        guard let pin = pin else { return }
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: DataController.shared.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }

    @IBAction func didTapRenewCollection(_ sender: Any) {
        guard let album = fetchedResultsController?.fetchedObjects else { return }
        let pages = pin?.pages ?? 1
        let newPage = Int16.random(in: 1...pages)
        renewButton.isEnabled = false
        for photo in album {
            DataController.shared.viewContext.delete(photo)
        }
        setupFetchedResultsController()
        getPhotos(page: newPage)
    }

    private func getPhotos(page: Int16) {
        guard let album = fetchedResultsController?.fetchedObjects,
              album.isEmpty, let pin = pin else {
            noImageLabel.isHidden = false
            return }
        FlickerClient.getPhotos(latitude: pin.latitude, longitude: pin.longitude, page: page) { [weak self] response, error in
            guard let strongSelf = self,
                  error == nil,
                  let response = response,
                  !response.photos.photo.isEmpty else {
                self?.noImageLabel.isHidden = false
                return
            }
            let context = DataController.shared.viewContext
            strongSelf.pin?.page = page
            strongSelf.pin?.pages = Int16(response.photos.pages)
            for image in response.photos.photo {
                let photo = Photo(context: context)
                photo.creationDate = Date()
                photo.url = "https://live.staticflickr.com/\(image.server)/\(image.id)_\(image.secret).jpg"
                photo.pin = strongSelf.pin
                try? context.save()
                strongSelf.collectionView.reloadData()
            }
            strongSelf.noImageLabel.isHidden = true
            strongSelf.renewButton.isEnabled = true
        }
    }

    private func setupMap() {
        let latitude = pin?.latitude ?? 0
        let longitude = pin?.longitude ?? 0
        let annotation = MKPointAnnotation()
        annotation.coordinate.longitude = longitude
        annotation.coordinate.latitude = latitude
        mapView.addAnnotation(annotation)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.275, longitudeDelta: 0.275)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
