//
//  delegates.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/12/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


extension RunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }

}

extension RunVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //guard annotation is MKPointAnnotation else { return nil }
        guard annotation is UserSnapshot else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let ghostAnno = annotation as? UserSnapshot

        if (ghostAnno?.image != nil) {
            
            let im = ghostAnno?.image
            
            let size = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContext(size)
            im?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

            
            let imView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imView.image = resizedImage
            imView.layer.cornerRadius = imView.layer.frame.size.width/2
            imView.layer.borderWidth = 1.0
            imView.layer.borderColor = UIColor.white.cgColor
            imView.layer.masksToBounds = true
            annotationView?.addSubview(imView)
            
        }
        else {
            annotationView?.image = UIImage(systemName: "leaf.fill")
            //annotationView?.tintColor = UIColor.red
        }
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = .systemBlue
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
    
}
