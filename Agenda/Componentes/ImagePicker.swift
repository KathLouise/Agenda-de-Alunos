//
//  ImagePicker.swift
//  Agenda
//
//  Created by Katheryne Graf on 21/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

enum MenuOpcoes {
    case camera
    case biblioteca
}

protocol ImagePickerFotoSelecionada {
    func imagePickerFotoSelecionada(_ foto:UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var delegate: ImagePickerFotoSelecionada?
    
    //Nos permite recuperar a foto
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        //pega a foto extraida do dicionario e converte ela para UIImage
        let foto = info[UIImagePickerControllerOriginalImage] as! UIImage;
        //Pegar a foto que foi tirada
        delegate?.imagePickerFotoSelecionada(foto);
        //Fecha a tela de foto
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Monta o menu para que o usuário escolhar entre tirar uma foto e usar alguma imagem que esta na biblioteca
    //Com o escaping sabe-se qual opção o usuário irá escolher
    func menuOpcoes(completion:@escaping(_ opcao:MenuOpcoes) -> Void) -> UIAlertController{
        let menu = UIAlertController(title: "Menu", message: "Escolha uma das opções abaixo", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Tirar Foto", style: .default) { (acao) in
            completion(.camera);
        }
        
        let biblioteca = UIAlertAction(title: "Biblioteca", style: .default) { (acao) in
            completion(.biblioteca);
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        menu.addAction(camera);
        menu.addAction(biblioteca);
        menu.addAction(cancelar);
        return menu;
    }
    
    
}
