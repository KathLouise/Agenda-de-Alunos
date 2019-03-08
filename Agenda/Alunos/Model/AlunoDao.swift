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
    
    var gerenciadorResultados: NSFetchedResultsController<Aluno>?
    
    //Criação do contexto
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        return appDelegate.persistentContainer.viewContext;
    }
    
    func recuperaAluno() -> Array<Aluno>{
        //Faz o Request para recuperar as informaçoes dos alunos
        let pesquisaAluno: NSFetchRequest<Aluno> = Aluno.fetchRequest();
        //invocando a função de ordenação de A-Z
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true);
        
        //faz a ordenaçao do resultado do request
        pesquisaAluno.sortDescriptors = [ordenaPorNome];
        //recupera os alunos salvos no banco de dados
        gerenciadorResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil);
        
        do{
            try gerenciadorResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        guard let listaDeAlunos = gerenciadorResultados?.fetchedObjects else { return []; }
        
        return listaDeAlunos;
    }
    
    func salvaAlunoDao(_ dicionarioDeAluno: Dictionary<String,Any>, _ imageAluno: UIImageView?) {
        //Se o aluno não existir, cria um novo
        //Caso contrário, faz update do existente
        let aluno = Aluno(context: contexto);
        
        aluno.nome = dicionarioDeAluno["nome"] as? String;
        aluno.endereco = dicionarioDeAluno["endereco"] as? String;
        aluno.telefone = dicionarioDeAluno["telefone"] as? String;
        aluno.site = dicionarioDeAluno["site"] as? String;
        
        guard let nota = dicionarioDeAluno["nota"] else { return; }
        if(nota is String){
            //transforma o valor de texto em double
            aluno.nota = (dicionarioDeAluno["nota"] as! NSString).doubleValue;
        } else {
            let conversaoDeNota = String(describing: nota);
            aluno.nota = (conversaoDeNota as NSString).doubleValue;
        }
        
        if let imagem = imageAluno{
            aluno.foto = imagem.image;
        }
        
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
