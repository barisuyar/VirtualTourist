//
//  AlbumVC+MapKit.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

import MapKit

extension AlbumVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if  pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.tintColor = .red
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
}
