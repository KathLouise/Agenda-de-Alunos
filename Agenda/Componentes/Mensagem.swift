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
    
    var delegate: MFMessageComposeViewControllerDelegate?
    
    func setaDelegate() -> MFMessageComposeViewControllerDelegate?{
        delegate = self;
        return delegate;
    }
    
    //MARK: - Metodos
    func enviaSMS(_ aluno:Aluno, controller: UIViewController){
        //verifica se é possivel mandar uma mensagem
        if MFMessageComposeViewController.canSendText(){
            let componetMensagem = MFMessageComposeViewController();
            guard let delegate = setaDelegate() else { return; }
            //testo se o numero do telefone não é nulo
            guard let numeroAluno = aluno.telefone else { return; }
            componetMensagem.recipients = [numeroAluno];
            componetMensagem.messageComposeDelegate = delegate;
            
            controller.present(componetMensagem, animated: true, completion: nil);
        }
    }
    
    //MARK: - Message Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil);
    }
}
