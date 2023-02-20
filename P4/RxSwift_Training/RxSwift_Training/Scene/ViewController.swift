//
//  ViewController.swift
//  RxSwift_Training
//
//  Created by hana on 2023/01/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController{
    let disposeBag = DisposeBag()
    
    let textfield = UITextField()
    let submitButton = UIButton()
    let resetButton = UIButton()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
    }
    
    func bind(_ viewModel: ViewModel){
        
        viewModel.resetText
            .map{_ in ""}
            .emit(to: textfield.rx.text, label.rx.text)
            .disposed(by: disposeBag)
  
        submitButton.rx.tap
            .bind{ [weak self] in
                self?.buttonTap()
            }
//            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: viewModel.resetButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func buttonTap(){
        label.text = textfield.text
    }
    
    private func setAttribute(){
        view.backgroundColor = .systemBackground
        
        textfield.placeholder = "입력"
        
        submitButton.setTitle("확인", for: .normal)
        submitButton.setTitleColor(.label, for: .normal)
        submitButton.backgroundColor = .yellow
        
        resetButton.setTitle("리셋", for: .normal)
        resetButton.setTitleColor(.label, for: .normal)
        resetButton.backgroundColor = .red
        
        label.text = "text"
    }
    
    private func setLayout(){
        [textfield, submitButton, resetButton, label].forEach{
            view.addSubview($0)
        }
        
        textfield.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints{
            $0.centerX.equalToSuperview().offset(-50)
            $0.top.equalTo(textfield.snp.bottom).offset(10)
        }
        resetButton.snp.makeConstraints{
            $0.centerX.equalToSuperview().offset(50)
            $0.top.equalTo(textfield.snp.bottom).offset(10)
        }
        
        label.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(submitButton.snp.bottom).offset(10)
        }
        
    }
    
}
