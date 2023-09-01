//
//  ViewController.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/08/29.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var productsButton: UIButton!
    @IBOutlet private weak var electronicsButton: UIButton!
    @IBOutlet private weak var jeweleryButton: UIButton!
    @IBOutlet private weak var mensClothing: UIButton!
    @IBOutlet private weak var womensClothing: UIButton!
    @IBOutlet private weak var tabScrollView: UIScrollView!
    @IBOutlet private weak var pageScrollView: UIScrollView! {
        didSet {
            pageScrollView.delegate = self
        }
    }
    @IBOutlet private weak var announcementsButton: UIButton! {
        didSet{
            announcementsButton.layer.cornerRadius = 25
        }
    }
    @IBOutlet private weak var thingsToDoButton: UIButton! {
        didSet {
            thingsToDoButton.layer.cornerRadius = 25
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib.init(nibName: ProductsCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ProductsCollectionViewCell.className)
            collectionViewProductslayout(collectionView: collectionView)
        }
    }
    private var fakeStoreModel = [FakeStoreModel]()
    private var tabButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemGroupedBackground
        fetchProducts()
        setupTabButtons()
    }
}

private extension ViewController {
    func setupTabButtons() {
        // ページの順番に合わせてボタンをtabButtonsに追加
        tabButtons = [productsButton, electronicsButton, jeweleryButton, mensClothing, womensClothing]
        // 各ボタンにアクションを追加
        for (index, button) in tabButtons.enumerated() {
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.tag = index  // タグを利用してどのボタンがタップされたかを識別
        }
    }
    // MARK: - ButtonAction
    @objc func tabButtonTapped(_ sender: UIButton) {
        let targetPageIndex = CGFloat(sender.tag)
        let targetOffsetX = targetPageIndex * pageScrollView.frame.width
        // ページスクロールビューを指定のページに移動
        pageScrollView.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
        // タブボタンを中心に移動
        centerButtonForPage(at: sender.tag)
    }
    // MARK: - DataFetch
     func fetchProducts() {
        let client = FakeStoreClient(httpClient: URLSession.shared)
        let request = FakeStoreAPI.GetProducts()
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
    // tabScrollViewのButtonをページに合わせて中心に移動
    func centerButtonForPage(at index: Int) {
        guard index >= 0 && index < tabButtons.count else {
                return
            }
        let targetButton = tabButtons[index]
        let scrollCenter = tabScrollView.frame.size.width / 2
        let targetPosition = targetButton.center.x - scrollCenter

//        // オフセットの最大、最小を計算して、スクロールがスクロールビューの境界を超えないようにします
//        targetPosition = max(targetPosition, 0)
//        targetPosition = min(targetPosition, tabScrollView.contentSize.width - tabScrollView.frame.size.width)

        // ボタンを中心にスクロール
        tabScrollView.setContentOffset(CGPoint(x: targetPosition, y: 0), animated: true)
    }

}
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.pageScrollView {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            centerButtonForPage(at: pageIndex)

        }
    }
}
// MARK: - CollectionView
extension ViewController: UICollectionViewDelegate {
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return 1
    //    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("タップされたよん")

    }

}
extension ViewController: UICollectionViewDataSource {
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


