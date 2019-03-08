//
//  Repositorio.swift
//  Agenda
//
//  Created by Katheryne Graf on 07/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class Repositorio: NSObject {
    
    func recuperaAlunos(completion:@escaping(_ listaDeAlunos: Array<Aluno>) -> Void){
        var alunos = AlunoDao().recuperaAluno()
        if alunos.count == 0{
            AlunoAPI().recuperaAlunosDoServidor {
                alunos = AlunoDao().recuperaAluno();
                completion(alunos);
            }
        } else {
            completion(alunos);
        }
    }

    func salvaAluno(_ aluno: Dictionary<String,String>, _ imageAluno: UIImageView){
        AlunoAPI().salvaAlunoNoServidor([aluno]);
        AlunoDao().salvaAlunoDao(aluno, imageAluno)
    }
}
