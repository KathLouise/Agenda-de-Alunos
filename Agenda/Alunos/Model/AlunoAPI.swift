//
//  AlunoAPI.swift
//  Agenda
//
//  Created by Katheryne Graf on 07/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import Alamofire

class AlunoAPI: NSObject {
    
    //MARK: - GET
    func recuperaAlunosDoServidor(completion:@escaping() -> Void) {
        AF.request("http://localhost:8080/api/aluno", method: .get).responseJSON { (response) in
            switch response.result{
            case .success:
                if let resposta = response.result.value as? Dictionary<String, Any>{
                    guard let listaDeAlunos = resposta["alunos"] as? Array<Dictionary<String,Any>> else { return; };
                    for aluno in listaDeAlunos{
                        AlunoDao().salvaAlunoDao(aluno, nil);
                    }
                    completion()
                }
                break;
            case .failure:
                if let error = response.error {
                    print(error.localizedDescription);
                }
                completion();
                break;
            }
        }
    }
    
    //MARK: - PUT
    
    func salvaAlunoNoServidor(_ parametros:Array<Dictionary<String,String>>) {
        //url do servidor
        guard let url = URL(string: "http://localhost:8080/api/aluno/lista") else { return; }
        
        //Compoe a requisicao
        var requisicao = URLRequest(url: url);
        requisicao.httpMethod = "PUT";
        //cria um json para compor o httpBody
        let json = try! JSONSerialization.data(withJSONObject: parametros, options: []);
        //coloca o json dentro do httpbody
        requisicao.httpBody = json;
        //Monta o tipo e o cabeçalho da requisicao
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type");
        AF.request(requisicao).responseJSON { (response) in
            switch response.result{
            case .failure:
                if let error = response.error {
                    print(error.localizedDescription);
                }
                break;
            default:
                break;
            }
        };
    }
    
    //MARK: - DELETE
    
    func deletaAluno(id: String){
        AF.request("http://localhost:8080/api/aluno/\(id)", method: .delete).responseJSON { (response) in
            switch response.result{
            case .failure:
                if let error = response.error {
                    print(error.localizedDescription);
                }
                break;
            default:
                break;
            }
        }
    }

}
