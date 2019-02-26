//
//  MapaViewController.swift
//  Agenda
//
//  Created by Katheryne Graf on 25/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController {
    
    // MARK - Outlets
    
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK - Variables
    
    var aluno: Aluno?;
    
    // MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo();
        self.localizacaoInicial();
        self.localizaAluno();
    }

    // MARK - Métodos
    
    //Coloca um titulo no mapa
    func getTitulo() -> String{
        return "Localiza alunos"
    }
    
    //Cria o pino de referencia para por no mapa
    func criaPino(titulo: String, coordenada:CLPlacemark) -> MKPointAnnotation {
        let pino = MKPointAnnotation();
        pino.title = titulo;
        pino.coordinate = coordenada.location!.coordinate;
        return pino;
    }
    
    //Coloca um pino de referencia inicial dentro do mapa
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Palladium - Curitiba") { (localizacao) in
            let pino = self.criaPino(titulo: "Palladium", coordenada: localizacao);
            self.mapa.addAnnotation(pino);
        }
    }
    
    //Coloca um pino no endereço registrado para o aluno
    func localizaAluno () {
        if let aluno = aluno {
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacao) in
                let pino = self.criaPino(titulo: aluno.nome!, coordenada: localizacao);
                self.mapa.addAnnotation(pino);
            }
        }
        
    }
}
