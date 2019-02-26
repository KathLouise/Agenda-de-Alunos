//
//  Localizacao.swift
//  Agenda
//
//  Created by Katheryne Graf on 25/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import CoreLocation

class Localizacao: NSObject {
    
    //Recebe como entrada um endereço e o converte em coordenada
    func converteEnderecoEmCoordenadas (endereco:String, coordenada:@escaping(_ coordenada: CLPlacemark) -> Void){
        let conversor = CLGeocoder();
        conversor.geocodeAddressString(endereco) { (listaDeLocalizacao, error) in
            if let local = listaDeLocalizacao?.first {
                coordenada(local);
            }
        }
    }
}
