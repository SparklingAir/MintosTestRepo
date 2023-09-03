//
//  MainViewController.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    private let currencySelectionView = CurrencySelectionView()
    private lazy var tableView = {
        let tv = UITableView()
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.register(TextCell.self, forCellReuseIdentifier: TextCell.className())
        tv.register(BankDetailsCell.self, forCellReuseIdentifier: BankDetailsCell.className())
        tv.register(InvestorCell.self, forCellReuseIdentifier: InvestorCell.className())
        tv.register(TitleCell.self, forCellReuseIdentifier: TitleCell.className())
        tv.contentInset = .init(top: 24, left: 0, bottom: 24, right: 0)
        tv.backgroundColor = Colors.backgroundSecondary
        tv.allowsSelection = false
        tv.separatorColor = .clear
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private let viewModel: MainViewModel
    
    private let _items = BehaviorRelay<[CommonCellModel]>(value: [])
    private let bag = DisposeBag()
    
    // MARK: - Life cycle
    
    init(viewMode: MainViewModel) {
        self.viewModel = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
        bindViewModel()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.onNext(())
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.items.drive(onNext: { [weak self] items in
            self?._items.accept(items)
            self?.tableView.reloadData()
            
        })
        .disposed(by: bag)
        currencySelectionView.bind(viewModel.currencySelectionViewModel)
        viewModel.showLoading.map { !$0 }.drive(loadingIndicator.rx.isHidden).disposed(by: bag)
    }
    
    private func setup() {
        view.backgroundColor = Colors.background
        view.addSubview(currencySelectionView)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    private func setupConstraints() {
        currencySelectionView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(MarginHelper.safeAreaMaxY + 60)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(currencySelectionView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - UITableView data source

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        _items.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = _items.value[indexPath.section] as? TitleCellModel {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TitleCell.className(), for: indexPath) as? TitleCell {
                cell.bind(model)
                return cell
            }
        }
        if let model = _items.value[indexPath.section] as? InvestorCellModel {
            if let cell = tableView.dequeueReusableCell(withIdentifier: InvestorCell.className(), for: indexPath) as? InvestorCell {
                cell.bind(model)
                return cell
            }
        }
        if let model = _items.value[indexPath.section] as? BankDetailsCellModel {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BankDetailsCell.className(), for: indexPath) as? BankDetailsCell {
                cell.bind(model)
                return cell
            }
        }
        if let model = _items.value[indexPath.section] as? TextCellModel {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.className(), for: indexPath) as? TextCell {
                cell.bind(model)
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableView delegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        false
    }
}


