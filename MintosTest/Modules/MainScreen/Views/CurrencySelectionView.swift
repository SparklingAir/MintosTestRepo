//
//  CurrencySelectionView.swift
//  MintosTest
//
//  Created by Maksim Polous on 01/08/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct CurrencySelectionViewModel {
    let title: String
    let currency: Driver<String>
    let didTap: AnyObserver<Void>
}

final class CurrencySelectionView: UIView {
    private let iconBackView = UIView()
    private let iconImageView = UIImageView()
    private let titleLable = UILabel()
    private let currencyLabel = UILabel()
    private let arrowButton = UIButton()
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(_ model: CurrencySelectionViewModel) {
        titleLable.text = model.title
        model.currency.drive(currencyLabel.rx.text).disposed(by: bag)
        arrowButton.rx.tap.bind(to: model.didTap).disposed(by: bag)
    }
    
    private func setup() {
        iconBackView.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        iconBackView.layer.cornerRadius = 20
        iconImageView.image = UIImage(systemName: "creditcard.fill")

        titleLable.font = Typography.micro
        titleLable.textColor = Colors.labelSecondary
        currencyLabel.font = Typography.basicAccent
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        arrowButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: imageConfig), for: .normal)
        arrowButton.imageView?.tintColor = .systemGray3
        
        addSubview(iconBackView)
        iconBackView.addSubview(iconImageView)
        addSubview(titleLable)
        addSubview(currencyLabel)
        addSubview(arrowButton)
    }
    
    private func setupConstraints() {
        iconBackView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.bottom.equalToSuperview().offset(-16)
            $0.left.equalToSuperview().offset(16)
        }
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.center.equalTo(iconBackView.snp.center)
        }
        titleLable.snp.makeConstraints {
            $0.top.equalTo(iconBackView.snp.top)
            $0.left.equalTo(iconBackView.snp.right).offset(12)
        }
        currencyLabel.snp.makeConstraints {
            $0.bottom.equalTo(iconBackView.snp.bottom)
            $0.left.equalTo(iconBackView.snp.right).offset(12)
        }
        arrowButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(iconBackView.snp.centerY)
        }
    }
}
