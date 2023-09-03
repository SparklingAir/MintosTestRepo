//
//  CurrencyPickerCell.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

struct CurrencyPickerCellModel {
    let title: String
    let showSeparator: Bool
    let isSelected: Driver<Bool>
    let didTap: AnyObserver<Void>
}

final class CurrencyPickerCell: UICollectionViewCell {
    private let backView = UIView()
    private let titleLabel = UILabel()
    private let checkImageView = UIImageView()
    private let tapButton = UIButton()
    private let separator = UIView()
    
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        titleLabel.text = nil
        separator.isHidden = true
        checkImageView.isHidden = true
    }
    
    func bind(_ model: CurrencyPickerCellModel, _ width: CGFloat) {
        titleLabel.text = model.title
        model.isSelected.drive(onNext: { [weak self] isSelected in
            self?.titleLabel.font = isSelected ? Typography.basicAccent : Typography.basic
            self?.checkImageView.isHidden = !isSelected
        })
        .disposed(by: bag)
        separator.isHidden = !model.showSeparator
        tapButton.rx.tap.bind(to: model.didTap).disposed(by: bag)
        
        backView.snp.updateConstraints {
            $0.width.equalTo(width)
        }
    }
    
    private func setup() {
        backgroundColor = .clear
        backView.backgroundColor = .clear
        separator.backgroundColor = Colors.separator
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
        checkImageView.image = image
        
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(checkImageView)
        backView.addSubview(separator)
        backView.addSubview(tapButton)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(350)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        checkImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        separator.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        tapButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
