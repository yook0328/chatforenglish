//
//  MenuBar.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 8..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit

class MenuBar: UIView , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Colors.primary_light_color
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "menuCellId"
    let icons = ["list", "messages","setting"]
    
    let menuCount = 3
    var mainController : MainController?
    override init(frame: CGRect){
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        //collectionView.collectionViewLayout.invalidateLayout()
        
        //collectionView.alwaysBounceVertical = false
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        
        
        setupIndicator()
        
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .left)
    }
    var indicatorLeftAnchor : NSLayoutConstraint?
    
    
    func setupIndicator(){
        
        let indicator = UIView()
        indicator.backgroundColor = Colors.primary_dark_color
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicator)
        
        indicatorLeftAnchor = indicator.leftAnchor.constraint(equalTo: self.leftAnchor)
        indicatorLeftAnchor?.isActive = true

        indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        indicator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/CGFloat(menuCount)).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /////
        mainController?.scrollToMenu(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(menuCount), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.icon?.image = UIImage(named: icons[indexPath.item])?.withRenderingMode(.alwaysTemplate)

        cell.icon?.tintColor = UIColor.black
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: UICollectionViewCell {
    var icon : UIImageView?
    
    override var isHighlighted: Bool{
        didSet {
            icon?.tintColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    override var isSelected: Bool{
        didSet {
            icon?.tintColor = isSelected ? UIColor.white : UIColor.black
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        icon = UIImageView()
        self.addSubview(icon!)

        icon?.translatesAutoresizingMaskIntoConstraints = false
        icon?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        icon?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        icon?.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -8).isActive = true
        icon?.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
        
    }
  
}
