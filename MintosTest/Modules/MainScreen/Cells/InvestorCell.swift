//
//  InvestorCell.swift
//  MintosTest
//
//  Created by Maksim Polous on 01/08/2023.
//

import UIKit
import RxSwift
import SnapKit

struct InvestorCellModel: CommonCellModel {
    let title: String
    let subTitle: String
    let didTapCopy: AnyObserver<Void>
}

final class InvestorCell: UITableViewCell {
    private let backView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let copyButton = UIButton()
    
    private var bag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        subtitleLabel.text = nil
        
    }
    
    func bind(_ model: InvestorCellModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subTitle
        copyButton.rx.tap.bind(to: model.didTapCopy).disposed(by: bag)
    }
    
    private func setup() {
        backgroundColor = .clear
        backView.backgroundColor = Colors.backgroundTertiary
        backView.layer.cornerRadius = 12
        
        titleLabel.font = Typography.micro
        titleLabel.textColor = Colors.labelSecondary
        subtitleLabel.font = Typography.basic
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .medium)
        let image = UIImage(systemName: "rectangle.portrait.on.rectangle.portrait", withConfiguration: imageConfig)
        copyButton.setImage(image, for: .normal)
        copyButton.setTitleColor(.systemGray, for: .normal)
        copyButton.imageView?.tintColor = Colors.labelSecondary
        
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(subtitleLabel)
        backView.addSubview(copyButton)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
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
