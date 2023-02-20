//
//  ContentColectionViewMainCell.swift
//  NetflixStyleSampleApp
//
//  Created by hana on 2022/06/27.
//

import UIKit

class ContentCollectionViewMainCell: UICollectionViewCell{
    let baseStackView = UIStackView()
    let menuStackView = UIStackView()
    
    let tvButton = UIButton()
    let moviewButton = UIButton()
    let categoryButton = UIButton()
    
    let imageView = UIImageView()       //데이터
    let descriptionLabel = UILabel()    //데이터
    let contentStackView = UIStackView()
    
    let plusButton = UIButton()
    let playButton = UIButton()
    let infoButton = UIButton()
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        [baseStackView, menuStackView].forEach{
            contentView.addSubview($0)
        }
        
        //baseStackView
        baseStackView.axis = .vertical
        baseStackView.alignment = .center
        baseStackView.distribution = .fillProportionally
        baseStackView.spacing = 5
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [imageView, descriptionLabel, contentStackView].forEach{
            //contentView가 아닌, stackView에 넣을 때는 add"Arranged"Subview
            baseStackView.addArrangedSubview($0)
        }
        
        //imageView
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints{
            $0.width.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        //descriptionLabel
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.sizeToFit()
        //contentStackView
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.distribution = .equalCentering
        contentStackView.spacing = 20
        
        [plusButton, playButton, infoButton].forEach{
            contentStackView.addArrangedSubview($0)
        }
        contentStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        [plusButton, infoButton].forEach{
            $0.titleLabel?.font = .systemFont(ofSize: 13)
            $0.setTitleColor(.white, for: .normal)
            $0.imageView?.tintColor = .white
            //UIButton 사용자 정의 함수 //title과 image 둘 다 노출
            $0.adjustVerticalLayout(5)
        }
        
        //content button
        plusButton.setTitle("내가 찜한 콘텐츠", for: .normal)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        infoButton.setTitle("정보", for: .normal)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        playButton.setTitle("재생", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 3
        playButton.snp.makeConstraints{
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        //menuStackView
        menuStackView.axis = .horizontal
        menuStackView.alignment = .center
        menuStackView.distribution = .equalSpacing
        menuStackView.spacing = 20
        
        [tvButton, moviewButton, categoryButton].forEach{
            menuStackView.addArrangedSubview($0)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 3
        }
        
        //menu button
        tvButton.setTitle("TV 프로그램", for: .normal)
        moviewButton.setTitle("영화", for: .normal)
        categoryButton.setTitle("카테고리", for: .normal)
        //스토리보드의 아울렛 액션추가. #selector = objct method
        tvButton.addTarget(self, action: #selector(tvButtonTapped), for: .touchUpInside)
        moviewButton.addTarget(self, action: #selector(movieButtonTapped), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        menuStackView.snp.makeConstraints{
            $0.top.equalTo(baseStackView)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    @objc func tvButtonTapped(sender: UIButton!){
        print("TEST: TV Button Tapped")
    }
    @objc func movieButtonTapped(sender: UIButton!){
        print("TEST: MOVIE Button Tapped")
    }
    @objc func categoryButtonTapped(sender: UIButton!){
        print("TEST: CATEGORY Button Tapped")
    }
    
    @objc func plusButtonTapped(sender: UIButton!){
        print("TEST: PLUS Button Tapped")
    }
    @objc func infoButtonTapped(sender: UIButton!){
        print("TEST: INFO Button Tapped")
    }
    @objc func playButtonTapped(sender: UIButton!){
        print("TEST: PLAY Button Tapped")
    }
    
}

extension UIButton {
    
    func adjustVerticalLayout(_ spacing: CGFloat = 0){
        let imageSize = self.imageView?.frame.size ?? .zero
        let titleLabelSize = self.titleLabel?.frame.size ?? .zero
        
//        self.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -imageSize.width, bottom: -(imageSize.height + spacing), trailing: 0)
//        self.configuration?.contentInsets = UIEdgeInsets(top: -(titleLabelSize.height + spacing), left: 0, bottom: 0, right: -titleLabelSize.width)
                
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleLabelSize.height + spacing), left: 0, bottom: 0, right: -titleLabelSize.width)
    }
    
    open override var intrinsicContentSize: CGSize{
        return CGSize(width: super.intrinsicContentSize.width, height: super.intrinsicContentSize.width)
    }
}
