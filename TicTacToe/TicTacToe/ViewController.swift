//
//  ViewController.swift
//  TicTacToe
//
//  Created by tplocal on 10/02/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let totalCell: Int = 9;

    @IBOutlet var gridView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self;
    }
}
    
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "net.romain.GridViewCell", for: indexPath) as! GridViewCell;
                
        cell.initCell();
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCell;
    }
}

// TODO to set cell size
//extension YourViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: screenWidth, height: screenWidth)
//    }
//}

