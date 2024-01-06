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
        case .stage1: return "This is the main and last step. The stage consists of 10 questions, for each question 10 pairs of photos will appear."
        case .stage2: return "For each pair of photos, tap on the photo that answers the question. For example - 'which photo is more aesthetic?'"
        case .stage3: return "If there is no correct answe, tap the 'skip' button to display an alternative comparison. \n\nAre you ready? "
        case .finished: return ""
        }
    }
    // after level4 , tapping will restart the sig. level to 1 again
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
