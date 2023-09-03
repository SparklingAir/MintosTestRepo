//
//  BankDetailsCell.swift
//  MintosTest
//
//  Created by Maksim Polous on 01/08/2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol BankDetailSubCellModel {}

struct BankDetailsCellModel: CommonCellModel {
    let items: [BankDetailSubCellModel]
}

final class BankDetailsCell: UITableViewCell {
    private let backView = UIView()
    private var views: [UIView] = []
    
    private var model: BankDetailsCellModel?
    
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
        model = nil
        backView.subviews.forEach { $0.removeFromSuperview() }
        views = []
    }
    
    func bind(_ model: BankDetailsCellModel) {
        self.model = model
        model.items.enumerated().forEach { index, item in
            var view = UIView()
            if let titleModel = item as? BankDetailTitleViewModel {
                let titleView = BankDetailTitleView()
                titleView.bind(titleModel)
                view = titleView
            } else if let itemModel = item as? BankDetailItemViewModel {
                let itemView = BankDetailItemView()
                itemView.bind(itemModel)
                view = itemView
            }
            backView.addSubview(view)
            views.append(view)
            if index == 0 {
                view.snp.makeConstraints {
                    $0.left.top.right.equalToSuperview()
                }
            } else if index < model.items.count - 1 {
                view.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.top.equalTo(views[index - 1].snp.bottom)
                }
            } else {
                view.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.top.equalTo(views[index - 1].snp.bottom)
                    $0.bottom.equalToSuperview()
                }
            }
        }
    }
    
    private func setup() {
        backgroundColor = .clear
        backView.backgroundColor = Colors.background
        backView.layer.cornerRadius = 12
        contentView.addSubview(backView)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
    }
}
