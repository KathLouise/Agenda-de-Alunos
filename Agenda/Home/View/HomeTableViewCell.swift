//
//  HomeTableViewCell.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var labelNomeDoAluno: UILabel!

    func configuraCelula(_ aluno: Aluno){
        //Seta o nome do aluno na celula
        labelNomeDoAluno.text = aluno.nome;
        
        //Para deixar a borda arredondada
        imageAluno.layer.cornerRadius = imageAluno.frame.width / 2;
        imageAluno.layer.masksToBounds = true;
        
        //Seta a imagem do aluno na celula
        if let imagemDoAluno = aluno.foto as? UIImage {
            imageAluno.image = imagemDoAluno
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
