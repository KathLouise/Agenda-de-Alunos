//
//  Localizacao.swift
//  Agenda
//
//  Created by Katheryne Graf on 25/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class Localizacao: NSObject, MKMapViewDelegate {
    
    //Recebe como entrada um endereço e o converte em coordenada
    func converteEnderecoEmCoordenadas (endereco:String, coordenada:@escaping(_ coordenada: CLPlacemark) -> Void){
        let conversor = CLGeocoder();
        conversor.geocodeAddressString(endereco) { (listaDeLocalizacao, error) in
            if let local = listaDeLocalizacao?.first {
                coordenada(local);
            }
        }
    }
    
    //Cria o pino de referencia para por no mapa
    func criaPino(titulo: String, coordenada:CLPlacemark, cor: UIColor?, icone: UIImage?) -> Pino {
        let pino = Pino(coordenada: coordenada.location!.coordinate);
        pino.title = titulo;
        pino.color = cor;
        pino.icon = icone;
        return pino;
    }
    
    //customização do pino ou utiliza o default
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Pino {
            let annotationView = annotation as! Pino;
            //cria a view para o pino
            var pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationView.title!) as? MKMarkerAnnotationView;
            //cria nova visualização para o pino
            pinoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationView.title!);
            pinoView?.annotation = annotationView;
            pinoView?.glyphImage = annotationView.icon;
            pinoView?.markerTintColor = annotationView.color;
            
            return pinoView;
        }
        return nil;
    }
    
    func configuraBotaoLocalizacaoAtual(mapa:MKMapView) -> MKUserTrackingButton {
        let button = MKUserTrackingButton(mapView: mapa);

        //Configura a posiçao do botao no mapa
        button.frame.origin.x = 10;
        button.frame.origin.y = 100;
        return button;
    }
}
