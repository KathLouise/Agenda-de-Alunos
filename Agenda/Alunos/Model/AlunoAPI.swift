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
        AF.request(requisicao);
    }

}
