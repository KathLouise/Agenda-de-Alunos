//
//  MenuDeOpcoes.swift
//  Agenda
//
//  Created by Katheryne Graf on 22/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

enum MenuOpcoesAluno{
    case sms
    case ligacao
    case waze
    case mapa
    case navegador
}

class MenuDeOpcoes: NSObject {
    func configuraMenuAluno(completion:@escaping (_ opcao:MenuOpcoesAluno) -> Void) -> UIAlertController{
        let mensagem = "Escolhe uma das opções abaixo";
        
        let menu = UIAlertController(title: "Menu de Opções", message: mensagem, preferredStyle: .actionSheet);
        
        let sms = UIAlertAction(title: "Enviar sms", style: .default) { (acao) in
            completion(.sms);
        }
        
        let ligacao = UIAlertAction(title: "Ligar", style: .default) { (acao) in
            completion(.ligacao);
        }
        
        let waze = UIAlertAction(title: "Localizar no Waze", style: .default) { (acao) in
            completion(.waze);
        }
        
        let mapa = UIAlertAction(title: "Localizar no Mapa", style: .default) { (acao) in
            completion(.mapa)
        }
        
        let navegador = UIAlertAction(title: "Abrir no Navegador", style: .default) { (acao) in
            completion(.navegador)
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        menu.addAction(sms);
        menu.addAction(ligacao);
        menu.addAction(waze);
        menu.addAction(mapa);
        menu.addAction(navegador);
        menu.addAction(cancelar);
        return menu;
    }
}
