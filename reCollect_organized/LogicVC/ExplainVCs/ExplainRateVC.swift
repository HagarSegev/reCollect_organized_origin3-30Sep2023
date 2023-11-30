//
//  ExplainRateVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 30/09/2023.
//

import UIKit

class ExplainRateVC: ExplainVC {
    
    override func labelForStage()-> String {
        return "Significance"
    }
    
    override func textForState(_ state: State) -> String {
        switch state {
        case .stage0: return ""
        case .stage1: return "In this stage you will defy the significance of your photos.\nYou can choose the significance of a single memory on a scale between 1 (least significant) to 4 (most significant). "
        case .stage2: return "All photos are initialized to significance value 1.\nBy tapping a memory you will increase the significance rating of it by 1, and the image will increase in size accordingly. "
        case .stage3: return "How personally significant is this photo?\n\n Tap on the it! "
        case .finished: return ""
        }
    }
    
    override func imageForState(_ state: State) -> UIImage? {
        switch state {
        case .stage0: return nil
        case .stage1: return UIImage(named: "rate1")
        case .stage2: return UIImage(named: "rate2")
        case .stage3: return UIImage(named: "rate3")
        case .finished: return nil
        }
    }
    
    override func changeZoomToCurrentExplain() {
        Background.shared.changeZoom(newScale: 2.1, newX: 20, newY: 50, duration: 1)
    }
    
    override func advanceToNextVC(){
        self.delegate?.handler(self, didFinishWithTransitionTo: RateVC.self)
    }
}
