//
//  MapaViewController.swift
//  Agenda
//
//  Created by Katheryne Graf on 25/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK - Outlets
    
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK - Variables
    
    var aluno: Aluno?;
    lazy var localizacao = Localizacao();
    lazy var gerenciadorDeLocalizacao = CLLocationManager();
    
    // MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo();
        verificaAutorizacaoDoUsuario();
        localizacaoInicial();
        mapa.delegate = localizacao;
        gerenciadorDeLocalizacao.delegate = self;
        
    }

    // MARK - Métodos
    
    //Coloca um titulo no mapa
    func getTitulo() -> String{
        return "Localiza alunos"
    }
    
    func verificaAutorizacaoDoUsuario(){
        //Verifica se o serviço esta disponivel
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            //Com permissao
            case .authorizedWhenInUse:
                let button = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa);
                //adiciona o botao ao mapa
                mapa.addSubview(button);
                //para mostrar a localizacao do usuario
                gerenciadorDeLocalizacao.startUpdatingLocation();
                break;
            
            //Primeira vez que abriu o app
            case .notDetermined:
                //pede a permissão para o usuário
                gerenciadorDeLocalizacao.requestWhenInUseAuthorization();
                break;
                
            //usuario negou a permissão
            case .denied:
                
                break;
            
            default:
                break;
            }
        }
    }
    
    //Coloca um pino de referencia inicial dentro do mapa
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Palladium - Curitiba") { (localizacao) in
            let pino = Localizacao().criaPino(titulo: "Palladium", coordenada: localizacao, cor: .black, icone: UIImage(named: "icon_caelum"));
            //AProxima o mapa
            let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 10000, 10000);
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino);
            self.localizaAluno();
        }
    }
    
    //Coloca um pino no endereço registrado para o aluno
    func localizaAluno () {
        if let aluno = aluno {
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacao) in
                //let pino = self.criaPino(titulo: aluno.nome!, coordenada: localizacao);
                let pino = Localizacao().criaPino(titulo: aluno.nome!, coordenada: localizacao, cor: nil, icone: nil);
                self.mapa.addAnnotation(pino);
                self.mapa.showAnnotations(self.mapa.annotations, animated: true);
            }
        }
        
    }
    
    //MARK: - CLLLOcationMAnagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            let button = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa);
            //adiciona o botao ao mapa
            mapa.addSubview(button);
            //para mostrar a localizacao do usuario
            gerenciadorDeLocalizacao.startUpdatingLocation();
        default:
            break;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("hello");
    }
}
