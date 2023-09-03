//
//  CurrencyPickerViewController.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CurrencyPickerViewController: UIViewController {
    private let titleLablel = UILabel()
    private let separator = UIView()
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CurrencyPickerCell.self, forCellWithReuseIdentifier: CurrencyPickerCell.className())
        cv.dataSource = self
        return cv
    }()
    
    private let viewModel: CurrencyPickerViewModel
    private let bag = DisposeBag()
    
    init(viewModel: CurrencyPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstrints()
        bindViewMode()
    }
    
    private func bindViewMode() {
        titleLablel.text = viewModel.title
    }
    
    private func setup() {
        view.backgroundColor = Colors.background
        
        titleLablel.textAlignment = .center
        titleLablel.font = Typography.headline
        separator.backgroundColor = Colors.separator
        
        view.addSubview(titleLablel)
        view.addSubview(separator)
        view.addSubview(collectionView)
    }
    
    private func setupConstrints() {
        titleLablel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        separator.snp.makeConstraints {
            $0.top.equalTo(titleLablel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}

extension CurrencyPickerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.items.isEmpty ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyPickerCell.className(),
            for: indexPath
        )
        if let casted = cell as? CurrencyPickerCell {
            casted.bind(viewModel.items[indexPath.row], collectionView.bounds.width)
        }
        return cell
    }
}
