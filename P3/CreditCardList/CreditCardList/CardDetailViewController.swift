//
//  CardDetailViewController.swift
//  CreditCardList
//
//  Created by hana on 2022/06/15.
//

import UIKit
import Lottie

class CardDetailViewController: UIViewController{
    var promotionDetail: PromotionDetail?
    
    //에어비엔비에서 제공하는 움짤.gif 변환 오픈소스
    @IBOutlet weak var lottieView: AnimationView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var benefitConditionLabel: UILabel!
    @IBOutlet weak var benefitDetailLabel: UILabel!
    @IBOutlet weak var benefitDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = AnimationView(name: "money")
        lottieView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //옵셔널 처리
        guard let detail = promotionDetail else {return}
        
        titleLabel.text = """
        \(detail.companyName)
        \(detail.amount)
        """
        
        periodLabel.text = detail.period
        conditionLabel.text = detail.condition
        benefitConditionLabel.text = detail.benefitCondition
        benefitDetailLabel.text = detail.benefitDetail
        benefitDateLabel.text = detail.benefitDate
    
    }
}
