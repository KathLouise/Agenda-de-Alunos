//
//  Notificacoes.swift
//  Agenda
//
//  Created by Katheryne Graf on 26/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {
    
    func exibeMediaGeralDosAlunos(_ dicionario: Dictionary<String,Any>) -> UIAlertController{
        var alerta = UIAlertController();
        if let media = dicionario["media"] as? String{
            let mensagem = "A média geral dos alunos é: \(media)";
            alerta = UIAlertController(title: "Atenção", message: mensagem, preferredStyle: .alert);
            
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil);
            alerta.addAction(btnOK);
        } else {
            let mensagem = "Não foi possível obter a média geral dos alunos. Verifique sua conexão.";
            alerta = UIAlertController(title: "Atenção", message: mensagem, preferredStyle: .alert);
            
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil);
            alerta.addAction(btnOK);
        }
        
        return alerta;
    }
}
