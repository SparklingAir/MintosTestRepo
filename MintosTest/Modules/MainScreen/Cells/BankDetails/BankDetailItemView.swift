//
//  BankDetailItemView.swift
//  MintosTest
//
//  Created by Maksim Polous on 01/08/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct BankDetailItemViewModel: BankDetailSubCellModel {
    let title: String
    let subTitle: String
    let showSeparator: Bool
    let didTapCopy: AnyObserver<Void>
}

final class BankDetailItemView: UIView {
    private let backView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let copyButton = UIButton()
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
    
    func bind(_ model: BankDetailItemViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subTitle
        separator.isHidden = !model.showSeparator
        copyButton.rx.tap.bind(to: model.didTapCopy).disposed(by: bag)
    }
    
    private func setup() {
        backgroundColor = .clear
        backView.backgroundColor = .clear
        
        titleLabel.font = Typography.micro
        titleLabel.textColor = Colors.labelSecondary
        titleLabel.numberOfLines = 0
        subtitleLabel.font = Typography.basic
        subtitleLabel.numberOfLines = 0
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .medium)
        let image = UIImage(systemName: "rectangle.portrait.on.rectangle.portrait", withConfiguration: imageConfig)
        copyButton.setImage(image, for: .normal)
        copyButton.setTitleColor(.systemGray, for: .normal)
        copyButton.imageView?.tintColor = Colors.labelSecondary
        
        separator.backgroundColor = Colors.separator
        
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(subtitleLabel)
        backView.addSubview(copyButton)
        backView.addSubview(separator)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        separator.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(0.5)
        }
        copyButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(16)
            $0.right.lessThanOrEqualTo(copyButton.snp.left).offset(-16)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.right.lessThanOrEqualTo(copyButton.snp.left).offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
