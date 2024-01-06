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
        case .stage1: return "In this stage, all photos you just chose will be displayed and you'll defy how each photo is significant for you."
        case .stage2: return "Choose the significance of a photo on a scale between 1 (least significant) to 4 (most significant. When you tap a photo, its significance level increases, and it becomes larger.\n "
        case .stage3:return
            "All photos start at a significance level 1. It's important to go over all the photos thoroughly. how personally significant is this photo?\n\n Tap on it!"
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
