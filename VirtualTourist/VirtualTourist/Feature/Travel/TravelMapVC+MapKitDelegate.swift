//
//  TravelMapVC+MapKitDelegate.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

import Foundation
import MapKit

extension TravelMapVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if  pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)

        let latitudeClicked = view.annotation?.coordinate.latitude
        let longitudeClicked = view.annotation?.coordinate.longitude

        if let pins = fetchedResultsController?.fetchedObjects {
            for pin in pins where pin.latitude == latitudeClicked && pin.longitude == longitudeClicked {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumVC") as? AlbumVC else { return }
                vc.pin = pin
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveZoomLevel()
    }
}
