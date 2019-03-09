//
//  AlunoViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit

class AlunoViewController: UIViewController, ImagePickerFotoSelecionada {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewImagemAluno: UIView!
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var buttonFoto: UIButton!
    @IBOutlet weak var scrollViewPrincipal: UIScrollView!
    
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldEndereco: UITextField!
    @IBOutlet weak var textFieldTelefone: UITextField!
    @IBOutlet weak var textFieldSite: UITextField!
    @IBOutlet weak var textFieldNota: UITextField!
    
    // MARK: - Atributos
    
    let imagePicker = ImagePicker();
    var aluno: Aluno?;
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.arredondaView()
        self.setup();
        self.updateAluno();
        NotificationCenter.default.addObserver(self, selector: #selector(aumentarScrollView(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Métodos
    
    func setup(){
        imagePicker.delegate = self;
    }
    
    func updateAluno(){
        if let alunoUpdate = aluno {
            textFieldNome.text = alunoUpdate.nome;
            textFieldEndereco.text = alunoUpdate.endereco;
            textFieldTelefone.text = alunoUpdate.telefone;
            textFieldSite.text = alunoUpdate.site;
            textFieldNota.text = "\(alunoUpdate.nota)";
            imageAluno.image = alunoUpdate.foto as? UIImage;
        }
    }
    
    func arredondaView() {
        self.viewImagemAluno.layer.cornerRadius = self.viewImagemAluno.frame.width / 2
        self.viewImagemAluno.layer.borderWidth = 1
        self.viewImagemAluno.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func aumentarScrollView(_ notification:Notification) {
        self.scrollViewPrincipal.contentSize = CGSize(width: self.scrollViewPrincipal.frame.width, height: self.scrollViewPrincipal.frame.height + self.scrollViewPrincipal.frame.height/2)
    }
    
    func mostraMUltimidia(_ opcao: MenuOpcoes){
        let multimidia = UIImagePickerController();
        multimidia.delegate = imagePicker;
        
        //Verifica se é  a opçao camera e se é possivel abrir a camera,
        if (opcao == .camera && UIImagePickerController.isSourceTypeAvailable(.camera)){
            multimidia.sourceType = .camera;
            
        } else {
            multimidia.sourceType = .photoLibrary
        }
        
        self.present(multimidia, animated: true, completion: nil);
    }
    
    func MontaDicionarioDeParamentros() -> Dictionary<String, String> {
        var id = "";
        
        if(aluno?.id == nil){
            id = String(describing: UUID());
        } else {
            guard let idDoAlunoExistente = aluno?.id else { return[:] }
            id = String(describing: idDoAlunoExistente);
        }
        
        guard let nome = textFieldNome.text else { return [:]; }
        guard let endereco = textFieldEndereco.text else { return [:]; }
        guard let telefone = textFieldTelefone.text else { return [:]; }
        guard let site = textFieldSite.text else { return [:]; }
        guard let nota = textFieldNota.text else { return [:]; }
        
        let dicionario:Dictionary <String,String> = [
            "id" : id.lowercased(),
            "nome": nome,
            "endereco": endereco,
            "telefone": telefone,
            "site": site,
            "nota": nota
        ];
        
        return dicionario;
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonFoto(_ sender: UIButton) {
        
        let menu = imagePicker.menuOpcoes { (opcao) in
            self.mostraMUltimidia(opcao);
        }
        
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func stepperNota(_ sender: UIStepper) {
        self.textFieldNota.text = "\(sender.value)"
    }
    
    @IBAction func buttonSalvar(_ sender: Any) {
        let json = MontaDicionarioDeParamentros();
        Repositorio().salvaAluno(json, imageAluno);
        navigationController?.popViewController(animated: true);

    }
    
    // MARK: - Delegate
    //Pega a foto que foi tirada e adicionei ao aluno
    func imagePickerFotoSelecionada(_ foto: UIImage) {
        imageAluno.image = foto;
    }
}
