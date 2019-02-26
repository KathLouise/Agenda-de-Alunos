//
//  Mensagem.swift
//  Agenda
//
//  Created by Katheryne Graf on 22/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    
    //MARK: - Metodos
    func configuraSMS(_ aluno:Aluno) -> MFMessageComposeViewController? {
        //verifica se é possivel mandar uma mensagem
        if MFMessageComposeViewController.canSendText(){
            let componetMensagem = MFMessageComposeViewController();
            //testo se o numero do telefone não é nulo
            guard let numeroAluno = aluno.telefone else { return componetMensagem; }
            componetMensagem.recipients = [numeroAluno];
            componetMensagem.messageComposeDelegate = self;
            
            return componetMensagem
        }
        return nil;
    }
    
    //MARK: - Message Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil);
    }
}
