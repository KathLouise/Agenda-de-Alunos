//
//  AlunoDao.swift
//  Agenda
//
//  Created by Katheryne Graf on 07/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoDao: NSObject {
    
    //Criação do contexto
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        return appDelegate.persistentContainer.viewContext;
    }
    
    func salvaAlunoDao(_ dicionarioDeAluno: Dictionary<String,Any>, _ imageAluno: UIImageView) {
        //Se o aluno não existir, cria um novo
        //Caso contrário, faz update do existente
        let aluno = Aluno(context: contexto);
        
        aluno.nome = dicionarioDeAluno["nome"] as? String;
        aluno.endereco = dicionarioDeAluno["endereco"] as? String;
        aluno.telefone = dicionarioDeAluno["telefone"] as? String;
        aluno.site = dicionarioDeAluno["site"] as? String;
        //transforma o valor de texto em double
        aluno.nota = (dicionarioDeAluno["nota"] as! NSString).doubleValue;
        aluno.foto = imageAluno.image;
        
        atualizaContexto();
    }
    
    func atualizaContexto(){
        do{
            try contexto.save();
            
        } catch{
            print(error.localizedDescription)
        }
    }

}
