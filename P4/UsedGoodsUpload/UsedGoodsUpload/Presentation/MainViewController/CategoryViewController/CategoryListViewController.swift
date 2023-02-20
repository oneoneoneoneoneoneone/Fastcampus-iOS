//
//  CategoryListViewController.swift
//  UsedGoodsUpload
//
//  Created by hana on 2022/09/27.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryListViewController: UIViewController{
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: CategoryViewModel){
        viewModel.cellData
        //@escaping //카테고리 리스트를 다 깔아주는듯 ?
            .drive(tableView.rx.items){tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "CategoryListCell", for: IndexPath(row: row, section: 0))
                //TableViewCell을 따로 정의하지 않고, 기본형태에 맞춰서 작성..?
                cell.textLabel?.text = data.name
                
                return cell
            }
            .disposed(by: disposeBag)
        
        //pop이벤트를 받았을 때, onNext 인라인 실행됨
        viewModel.pop
            .emit(onNext:{[weak self]_ in
                self?.navigationController?
                    .popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        //뷰 -> 뷰모델
        tableView.rx.itemSelected
        //indexPath 전체 > 로우값만 받는 걸로 변환
            .map{$0.row}
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
