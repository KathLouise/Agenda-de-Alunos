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
        
        var aluno: NSManagedObject?
        guard let id = UUID(uuidString: (dicionarioDeAluno["id"] as? String)!) else { return; }
        
        let alunos = recuperaAluno().filter(){ $0.id == id};
        
        if(alunos.count > 0){
            guard let alunoEncontrado = alunos.first else { return; }
            aluno = alunoEncontrado;
        } else {
            let entidade = NSEntityDescription.entity(forEntityName: "Aluno", in: contexto);
            aluno = NSManagedObject(entity: entidade!, insertInto: contexto);
        }
        
        aluno?.setValue(id, forKey: "id");
        aluno?.setValue(dicionarioDeAluno["nome"] as? String, forKey: "nome");
        aluno?.setValue(dicionarioDeAluno["endereco"] as? String, forKey: "endereco");
        aluno?.setValue(dicionarioDeAluno["telefone"] as? String, forKey: "telefone");
        aluno?.setValue(dicionarioDeAluno["site"] as? String, forKey: "site")
        
        guard let nota = dicionarioDeAluno["nota"] else { return; }
        if(nota is String){
            //transforma o valor de texto em double
            aluno?.setValue((dicionarioDeAluno["nota"] as! NSString).doubleValue, forKey: "nota")
        } else {
            let conversaoDeNota = String(describing: nota);
            aluno?.setValue((conversaoDeNota as NSString).doubleValue, forKey: "nota")
        }
        
        if let imagem = imageAluno{
            aluno?.setValue(imagem.image, forKey: "foto")
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
