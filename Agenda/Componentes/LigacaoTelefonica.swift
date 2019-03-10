//
//  LigacaoTelefonica.swift
//  Agenda
//
//  Created by Katheryne Graf on 10/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class LigacaoTelefonica: NSObject {

    func fazLigacao(_ aluno: Aluno){
        guard let numeroAluno = aluno.telefone else { return; }
        //Verifica se existe um numero do aluno e se pode abrir o app de ligacao
        if let url = URL(string: "tel://\(numeroAluno)"), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }
}
