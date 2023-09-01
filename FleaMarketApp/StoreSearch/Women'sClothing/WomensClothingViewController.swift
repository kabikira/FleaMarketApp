//
//  WomensClothingViewController.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/08/31.
//

import UIKit

class WomensClothingViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: ProductsCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ProductsCollectionViewCell.className)
        collectionViewProductslayout(collectionView: collectionView)

    }
}

private var fakeStoreModel = [FakeStoreModel]()

override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .systemGroupedBackground
    fetchElectronics()

}
private func fetchElectronics() {
    let client = FakeStoreClient(httpClient: URLSession.shared)
    let request = FakeStoreAPI.GetWomensClothings()
    client.send(request: request) { result in
        DispatchQueue.main.async {
            switch result {
            case.failure(let error):
                print(error)
            case .success(let response):
                self.fakeStoreModel = response
                self.collectionView.reloadData()
            }
        }
    }

}

}
// MARK: - CollectionView
extension WomensClothingViewController: UICollectionViewDelegate {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("タップされたよん")

}

}
extension WomensClothingViewController: UICollectionViewDataSource {
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.className, for: indexPath) as? ProductsCollectionViewCell else { fatalError()
    }
    let model = fakeStoreModel[indexPath.row]
    cell.configure(fakeStoreModel: model)
    return cell
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fakeStoreModel.count
}
}
