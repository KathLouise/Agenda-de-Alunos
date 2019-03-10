//
//  Safari.swift
//  Agenda
//
//  Created by Katheryne Graf on 10/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import SafariServices

class Safari: NSObject {
    
    func abrirPaginaWeb(_ aluno: Aluno, controller: UIViewController){
        if let urlDoAluno = aluno.site{
            var urlFormatada = urlDoAluno;
            //Verifica se a url contem http://
            //senão contiver, adiciona
            if !urlFormatada.hasPrefix("http://"){
                urlFormatada = String(format: "http://%@", urlDoAluno);
            }
            
            guard let url = URL(string: urlFormatada) else { return; }
            let safari = SFSafariViewController(url: url);
            controller.present(safari, animated: true, completion: nil);
        }
    }

}
