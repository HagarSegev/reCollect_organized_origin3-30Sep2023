//
//  ExplainCompareVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 30/09/2023.
//

//
//  ExplainRateVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 30/09/2023.
//

import UIKit

class ExplainCompareVC: ExplainVC {
    
    override func labelForStage()-> String {
        return "Experiment"
    }
    
    override func textForState(_ state: State) -> String {
        switch state {
        case .stage0: return ""
        case .stage1: return "In this stage you will compare pairs of photos in different cognitive espects."
        case .stage2: return "You will be asked with a question and pairs of photos will be displayed on the screen. "
        case .stage3: return "For each question, tap on the right answer\n\nAre you ready? "
        case .finished: return ""
        }
    }
    
    override func imageForState(_ state: State) -> UIImage? {
        switch state {
        case .stage0: return nil
        case .stage1: return UIImage(named: "compare1")
        case .stage2: return UIImage(named: "compare2")
        case .stage3: return UIImage(named: "compare3")
        case .finished: return nil
        }
    }
    
    override func changeZoomToCurrentExplain() {
        Background.shared.changeZoom(newScale: 2.4, newX: 100, newY: -100, duration: 1)
    }
    
    override func advanceToNextVC(){
        self.delegate?.handler(self, didFinishWithTransitionTo: CompareVC.self)
    }
}
