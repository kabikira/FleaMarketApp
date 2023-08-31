//
//  ProductsCollectionViewCell.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/08/30.
//

import UIKit
import Kingfisher

class ElectronicsCollectionViewCell: UICollectionViewCell {

    static var className: String { String(describing: ElectronicsCollectionViewCell.self)}

    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!

    private var isFavorite = false

    override func awakeFromNib() {
         super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true

        favoriteButton.addTarget(self, action: #selector(favoriButtonTapped), for: .touchUpInside)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImage.image = nil
        self.priceLabel.text = nil
    }

    func configure(fakeStoreModel: FakeStoreModel) {
        self.priceLabel.text = "$\(fakeStoreModel.price.description)"
        productImage.kf.indicatorType = .activity

        let processor = DownsamplingImageProcessor(size: productImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 10)
        productImage.kf.setImage(
            with: fakeStoreModel.image,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),  
            ]
        )

    }

    @objc private func favoriButtonTapped() {
        isFavorite.toggle()
        let heartSymbolName = isFavorite ? "heart.fill" : "heart"
        let heartSymbol = UIImage(systemName: heartSymbolName)?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(heartSymbol, for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemPink : .white
    }

}
