//
//  PromoCollectionViewCell.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit
import Kingfisher

class PromoCollectionViewCell: UICollectionViewCell{
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var containerView: GradientView = {
        let view = GradientView()
        view.startColor = .clear
        view.endColor = .black.withAlphaComponent(0.9)
        view.startLocation = 0
        view.endLocation = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .secondaryBackgroundColor
        addImageView()
        addContainerView()
        addNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImageView(){
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func addContainerView(){
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        ])
    }
    
    func addNameLabel(){
        containerView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 10)
        ])
    }
    
    func setupCell(promo: Promo){
        nameLabel.text = promo.name
        guard let urlString = promo.imagesURL,
                let url = URL(string: urlString)
        else{return}
        let imageType = ["png", "jpg"]
        let str = String(urlString.suffix(3))
        if imageType.contains(str){
            imageView.kf.setImage(with: url)
        }else{
            let urlString = "https://firebasestorage.googleapis.com/v0/b/test-reyhan-f2bc2.appspot.com/o/ELF-Digital%20Banner%2039x69_Fleksi%20Pensiun%20Pra%20Purna%20Generik-FA-230818-01-2.jpg?alt=media&token=1488a70b-2e1d-4d31-8464-7672245e5e1d"
            let url = URL(string: urlString)
            imageView.kf.setImage(with: url)
        }
    }
}
