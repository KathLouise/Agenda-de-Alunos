//
//  Filtro.swift
//  Agenda
//
//  Created by Katheryne Graf on 10/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class Filtro: NSObject {
    
    func filtraAlunos(_ listaDeAlunos: Array<Aluno>, _ textoProcurado:String) -> Array<Aluno>{
        let alunosEncontrados = listaDeAlunos.filter { (aluno) -> Bool in
            if let nome = aluno.nome{
                return nome.contains(textoProcurado);
            }
            return false;
        }
        return alunosEncontrados;
    }
    
}
