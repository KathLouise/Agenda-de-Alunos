//
//  AutenticacaoLocal.swift
//  Agenda
//
//  Created by Katheryne Graf on 26/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import LocalAuthentication

class AutenticacaoLocal: NSObject {
    
    var erro: NSError?;
    
    func confirmacaoDeAutenticacao(completion:@escaping(_ autenticacao: Bool) -> Void) {
        //Pega o contexto da autenticaçao
        let contexto = LAContext();
        let mensagem = "É necessário autenticação para efetuar esta operação.";
        
        //Verifica se a autenticaçao de senha ou biometrica esta disponivel
        if contexto.canEvaluatePolicy(.deviceOwnerAuthentication, error: &erro){
            //Se estiver, pede a autenticação
            contexto.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: mensagem) { (resposta, erro) in
                completion(resposta);
            }
        }
    }

}
