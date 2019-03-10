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
    
    func deletaAluno(_ aluno: Aluno){
        guard  let id = aluno.id else { return; }
        AlunoAPI().deletaAluno(id: String(describing: id).lowercased());
        AlunoDao().deletaAluno(aluno);
    }
    
    func sincronizaAlunos(){
        let alunos = AlunoDao().recuperaAluno();
        var listaDeAlunos:Array<Dictionary<String,String>> = [];
        
        for aluno in alunos{
            guard let id = aluno.id else { return; }
            let parametros:Dictionary<String,String> = [
                "id": String(describing: id).lowercased(),
                "nome": aluno.nome ?? "",
                "endereco": aluno.endereco ?? "",
                "telefone": aluno.telefone ?? "",
                "site": aluno.site ?? "",
                "nota": "\(aluno.nota)"
            ];
            listaDeAlunos.append(parametros);
        }
        AlunoAPI().salvaAlunoNoServidor(listaDeAlunos);
    }
}
