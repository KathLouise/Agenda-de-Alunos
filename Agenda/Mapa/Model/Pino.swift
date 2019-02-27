//
//  Pino.swift
//  Agenda
//
//  Created by Katheryne Graf on 26/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class Pino: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D;
    var title: String?;
    var color: UIColor?;
    var icon: UIImage?;
    
    init(coordenada: CLLocationCoordinate2D){
        self.coordinate = coordenada;
    }
}
