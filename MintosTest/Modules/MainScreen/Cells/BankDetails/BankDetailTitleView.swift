//
//  BankDetailTitleView.swift
//  MintosTest
//
//  Created by Maksim Polous on 01/08/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct BankDetailTitleViewModel: BankDetailSubCellModel {
    let title: String
}

final class BankDetailTitleView: UIView {
    private let backView = UIView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(_ model: BankDetailTitleViewModel) {
        titleLabel.text = model.title
    }
    
    private func setup() {
        backgroundColor = .clear
        backView.backgroundColor = .clear
        
        titleLabel.font = Typography.basicAccent
        titleLabel.numberOfLines = 0
        
        addSubview(backView)
        backView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-4)
            $0.right.lessThanOrEqualToSuperview().offset(-16)
        }
    }
}
