//
//  GridViewCell.swift
//  TicTacToe
//
//  Created by tplocal on 10/02/2022.
//

import UIKit

class GridViewCell: UICollectionViewCell {
    
    @IBOutlet var button: UIButton!
    
    func initCell() {
        button.setImage(UIImage(named: "croix.png"), for: .normal);
        
        self.si
    }
    
    @IBAction func OnCellClick(_ sender: Any) {
        
    }

}
