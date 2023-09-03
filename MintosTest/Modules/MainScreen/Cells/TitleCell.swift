//
//  TitleCell.swift
//  MintosTest
//
//  Created by Maksim Polous on 01/08/2023.
//

import UIKit

struct TitleCellModel: CommonCellModel {
    let title: String
    let subTitle: String
}

final class TitleCell: UITableViewCell {
    private let backView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
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
        titleLabel.text = nil
        subtitleLabel.text = nil
        
    }
    
    func bind(_ model: TitleCellModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subTitle
    }
    
    private func setup() {
        backgroundColor = .clear
        backView.backgroundColor = .clear
        
        titleLabel.font = Typography.title2
        
        subtitleLabel.font = Typography.small
        subtitleLabel.textColor = Colors.labelSecondary
        subtitleLabel.numberOfLines = 0
        
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

