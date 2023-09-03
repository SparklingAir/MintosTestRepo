//
//  TextCell.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import UIKit

struct TextCellModel: CommonCellModel {
    let title: String
}

final class TextCell: UITableViewCell {
    private let backView = UIView()
    private let titleLabel = UILabel()
    
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
        
    }
    
    func bind(_ model: TextCellModel) {
        titleLabel.text = model.title
    }
    
    private func setup() {
        backgroundColor = .clear
        backView.backgroundColor = Colors.background
        backView.layer.cornerRadius = 12
        
        titleLabel.font = Typography.basic
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        addSubview(backView)
        backView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-24)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
    }
}


