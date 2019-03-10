//
//  MenuDeOpcoes.swift
//  Agenda
//
//  Created by Katheryne Graf on 22/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class MenuDeOpcoes: NSObject {
    func configuraMenuAluno(_ aluno: Aluno, navigationController: UINavigationController) -> UIAlertController{
        let mensagem = "Escolhe uma das opções abaixo";
        
        let menu = UIAlertController(title: "Menu de Opções", message: mensagem, preferredStyle: .actionSheet);
        guard let viewController = navigationController.viewControllers.last else { return menu; }
        
        let sms = UIAlertAction(title: "Enviar sms", style: .default) { (acao) in
            Mensagem().enviaSMS(aluno, controller: viewController);
        }
        
        let ligacao = UIAlertAction(title: "Ligar", style: .default) { (acao) in
            LigacaoTelefonica().fazLigacao(aluno);
        }
        
        let waze = UIAlertAction(title: "Localizar no Waze", style: .default) { (acao) in
            Localizacao().localizaAlunoNoWaze(aluno);
        }
        
        let mapa = UIAlertAction(title: "Localizar no Mapa", style: .default) { (acao) in
            //Cria uma constante de MapaViewController
            let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController;
            //Pega o aluno que sofreu longPress
            mapa.aluno = aluno;
            //Empilha a tela do mapa nativo
            navigationController.pushViewController(mapa, animated: true);
        }
        
        let navegador = UIAlertAction(title: "Abrir no Navegador", style: .default) { (acao) in
            Safari().abrirPaginaWeb(aluno, controller: viewController);
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
