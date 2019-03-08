//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class HomeTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Variáveis
    let searchController = UISearchController(searchResultsController: nil)
    var alunoViewController: AlunoViewController?;
    var mensagem = Mensagem();
    var alunos:Array<Aluno> = [];
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recuperaAluno();
    }
    
    // MARK: - Métodos
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editar"){
            //preparando a transiçao de tela para a tela de formulario
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func recuperaAluno(){
        Repositorio().recuperaAlunos { (listaDeAlunos) in
            self.alunos = listaDeAlunos;
            self.tableView.reloadData();
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alunos.count;
    }
    
    //Evento para abrir o menu de opçoes com Long Press
    @objc func abrirActionSheet (_ longPress:UILongPressGestureRecognizer){
        if longPress.state == .began{
            //recupero o aluno que sofreu long press
            let alunoSelecionado = alunos[(longPress.view?.tag)!]
            //Cria o menu com as opçoes
            let menu = MenuDeOpcoes().configuraMenuAluno(completion: { (opcao) in
                switch opcao{
                case .sms:
                    //configura para abrir o app padrão de mensagem do IOS
                    if let componetMensagem = self.mensagem.configuraSMS(alunoSelecionado){
                        componetMensagem.messageComposeDelegate = self.mensagem
                        self.present(componetMensagem, animated: true, completion: nil);
                    }
                    break;
                case .ligacao:
                    guard let numeroAluno = alunoSelecionado.telefone else { return; }
                    //Verifica se existe um numero do aluno e se pode abrir o app de ligacao
                    if let url = URL(string: "tel://\(numeroAluno)"), UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    break;
                case .waze:
                    //Verifica se o waze esta instalado, se estiver executa o código do if
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!){
                        //tenta extrair o endereço do aluno
                        guard let enderecoAluno = alunoSelecionado.endereco else { return; }
                        //Do endereço extrai as coordenadas
                        Localizacao().converteEnderecoEmCoordenadas(endereco: enderecoAluno, coordenada: { (coordenada) in
                            //Pega a latitude e converte em string
                            let latitude = String(describing: coordenada.location!.coordinate.latitude);
                            //Pega a longitude e converte em string
                            let longitude = String(describing: coordenada.location!.coordinate.longitude);
                            //COmpoem uma url para poder abrir o waze
                            let url = "waze://?ll=\(latitude),\(longitude)&navigation=yes";
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil);
                        })
                    }
                    break;
                case .mapa:
                    //Cria uma constante de MapaViewController
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController;
                    //Pega o aluno que sofreu longPress
                    mapa.aluno = alunoSelecionado;
                    //Empilha a tela do mapa nativo
                    self.navigationController?.pushViewController(mapa, animated: true);
                    
                    break;
                case .navegador:
                    if let urlDoAluno = alunoSelecionado.site{
                        var urlFormatada = urlDoAluno;
                        //Verifica se a url contem http://
                        //senão contiver, adiciona
                        if !urlFormatada.hasPrefix("http://"){
                            urlFormatada = String(format: "http://%@", urlDoAluno);
                        }
                        
                        guard let url = URL(string: urlFormatada) else { return; }
                        let safari = SFSafariViewController(url: url);
                        self.present(safari, animated: true, completion: nil);
                    }
                    
                    break;
                }
            })
            self.present(menu, animated: true, completion: nil);
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        //Seta um identificador para cada célula, para não abrir sempre a mesma
        cell.tag = indexPath.row;
        //Coloca o evento de longPress para abrir o menu
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_:)))
        
        //Pega o aluno da linha que esta sendo passada
        let aluno = alunos[indexPath.row]
        
        cell.configuraCelula(aluno);
        //Adiciona o evento de LongPress a celula selecionada
        cell.addGestureRecognizer(longPress);
        return cell
    }
    
    //Muda o tamanho da celula para o que você definir
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85;
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //verifica se o usuário tem permissão para deletar
            AutenticacaoLocal().confirmacaoDeAutenticacao { (autenticacao) in
                if(autenticacao){
                    //Obriga o método a executar na tred principal
                    DispatchQueue.main.async {
                        //se tiver, então deleta o aluno selecionado
                       /* let alunoSelecionado = self.alunos[indexPath.row]
                        self.contexto.delete(alunoSelecionado);
                        
                        do {
                            try self.contexto.save();
                        } catch {
                            print(error.localizedDescription);
                        }*/
                    }
                }
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Pegando o aluno que vai ser editado
        let alunoSelecionado = alunos[indexPath.row]
        alunoViewController?.aluno = alunoSelecionado;
    }
    
    // MARK: - FetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
            break;
        default:
            tableView.reloadData()
        }
    }
    
    // MARK: - SearchBarDelegate
    
    // Procura pelo nome do aluno dentro da tableview
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
    }
    
    // MARK: - Actions
    
    @IBAction func buttonMedia(_ sender: UIBarButtonItem) {
        CalculaMediaAPI().calculaMediaDosAlunos(alunos: alunos, sucesso: { (dicionario) in
            let alerta = Notificacoes().exibeMediaGeralDosAlunos(dicionario);
            self.present(alerta, animated: true, completion: nil);
        }) { (erro) in
            print(erro.localizedDescription)
        }
    }

    @IBAction func btnLocalizacaoGeral(_ sender: UIBarButtonItem) {
        //Recupera o viewCOntroller que deve ser usado, no caso o de MAPA
        let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController;
        //Da um push na view
        navigationController?.pushViewController(mapa, animated: true);
        
    }
}
