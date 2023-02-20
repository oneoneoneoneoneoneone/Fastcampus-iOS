//
//  SearchBar.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchBar: UISearchBar{
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchBarViewModel){
        //쿼리를 뷰모델로 전달
        self.rx.text
            .bind(to: viewModel.queryText)
            .disposed(by: disposeBag)
        
        //SearchBar searchButton 탭(키보드의 검색 버튼) + 커스텀 버튼 탭 => searchButtonTap
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: viewModel.searchButtonTap)
            .disposed(by: disposeBag)
       
        //이벤트 발생시 emit(to:) 액션 추가
        viewModel.searchButtonTap
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
                

    }
    
    private func attribute(){
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout(){
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12)    //inset?
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

extension Reactive where Base: SearchBar{
    var endEditing: Binder<Void>{
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
