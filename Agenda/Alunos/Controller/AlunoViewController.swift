//
//  AlunoViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

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
    //Criação do contexto
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        return appDelegate.persistentContainer.viewContext;
    }
    
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
        //Se o aluno não existir, cria um novo
        //Caso contrário, faz update do existente
        if (aluno == nil){
           aluno = Aluno(context: contexto);
        }
        
        aluno?.nome = textFieldNome.text;
        aluno?.endereco = textFieldEndereco.text;
        aluno?.telefone = textFieldTelefone.text;
        aluno?.site = textFieldSite.text;
        //transforma o valor de texto em double
        aluno?.nota = (textFieldNota.text! as NSString).doubleValue;
        aluno?.foto = imageAluno.image;
        
        do{
            try contexto.save();
            navigationController?.popViewController(animated: true);
        } catch{
            print(error.localizedDescription)
        }

    }
    
    // MARK: - Delegate
    //Pega a foto que foi tirada e adicionei ao aluno
    func imagePickerFotoSelecionada(_ foto: UIImage) {
        imageAluno.image = foto;
    }
}
