//
//  CalculaMediaAPI.swift
//  Agenda
//
//  Created by Katheryne Graf on 25/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class CalculaMediaAPI: NSObject {
    
    /* Faz o calculo da média geral dos alunos mandando um json para o servidor com os dados e pegando como resposta o calculo feito*/
    func calculaMediaDosAlunos (alunos: Array<Aluno>, sucesso:@escaping(_ dicionarioDeMedias: Dictionary<String,Any>) -> Void, falha:@escaping(_ error:Error) -> Void){
        var json: Dictionary<String,Any> = [:];
        json = montaJSON(alunos);
        
        do {
            //Tenta converter o dicionario para tipo data
            let dicionario = try JSONSerialization.data(withJSONObject: json, options: []);
            
            //Monta a url de conexão do servidor e coloca em uma variavel
            guard let url = URL(string: "https://www.caelum.com.br/mobile") else { return; };
            
            let requisicao = montaURLConexao(url, dicionario);
            comunicaClienteServidor(requisicao, sucesso: { (dicionario) in
                sucesso(dicionario);
            }) { (erro) in
                falha(erro);
            }
        } catch {
            print(error.localizedDescription);
        }
    }
    
    /*Monta um JSON com os dados para enviar para o servidor*/
    func montaJSON (_ alunos: Array<Aluno>) -> Dictionary<String,Any> {
        var json: Dictionary<String,Any> = [:];
        var listaDeAluno: Array<Dictionary<String,Any>> = [];
        
        for aluno in alunos {
            guard let nome = aluno.nome else { break; };
            guard let endereco = aluno.endereco else { break; };
            guard let telefone = aluno.telefone else { break; };
            guard let site = aluno.site else { break; };
            
            //Monta o JSON da forma que o servidor esta esperando
            let dicionarioDeAlunos = [
                "id": "\(aluno.objectID)",
                "nome": nome,
                "endereco": endereco,
                "telefone": telefone,
                "site": site,
                "nota": String(aluno.nota)
            ];
            
            listaDeAluno.append(dicionarioDeAlunos as [String:Any]);
            json = [
                "list": [
                    ["aluno": listaDeAluno]
                ]
            ];
        }
        return json;
    }

    /*Monta a URL de conexao com o servidor para poder fazer o calculo das médias*/
    func montaURLConexao (_ url:URL, _ dicionario: Data) -> URLRequest {
        var requisicao = URLRequest(url: url);
        //Adiciona os dados que serão enviados
        requisicao.httpBody = dicionario;
        //Verbo da requisicão
        requisicao.httpMethod = "POST";
        //Mostra o tipo de dado que esta sendo enviado -> Aplication Json
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return requisicao
    }
    
    /*Faz a comunicação com o servidor atraves da URL de conexão e tenta pegar a resposta do servidor e converte-la do tipo data para dicionario*/
    func comunicaClienteServidor(_ requisicao: URLRequest, sucesso:@escaping(_ dicionarioDeMedias: Dictionary<String,Any>) -> Void, falha:@escaping(_ error:Error) -> Void) {
        let task = URLSession.shared.dataTask(with: requisicao) { (data, response, error) in
            if (error == nil){
                do {
                    //Tenta pegar a resposta do servidor (tipo data) e converte para um dicionario
                    let dicionario = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>;
                    sucesso(dicionario);
                } catch {
                    //Senão retorna erro
                    falha(error);
                }
            }
        }
        task.resume();
    }
}
