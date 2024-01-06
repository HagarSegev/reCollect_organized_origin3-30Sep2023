//
//  ExplainChooseVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 30/09/2023.
//

import UIKit

class ExplainChooseVC: ExplainVC {
    
    override func labelForStage()-> String {
        return "Choose photos for your task"
    }
    
    override func textForState(_ state: State) -> String {
        switch state {
        case .stage0: return ""
        case .stage1: return "In this step, photos from your gallery will be dispayed randomally.\n No worries, All photos will remain private and will only be used by you."
        case .stage2: return "Swipe RIGHT for photos you like and LEFT for one’s you don’t"
        case .stage3: return "Pick at least 70 photos.\n\nLet's start!"
        case .finished: return ""
        }
    }
    
    override func imageForState(_ state: State) -> UIImage? {
        switch state {
        case .stage0: return nil
        case .stage1: return UIImage(named: "choose1")
        case .stage2: return UIImage(named: "choose2")
        case .stage3: return UIImage(named: "choose3")
        case .finished: return nil
        }
    }
    
    override func changeZoomToCurrentExplain() {
        Background.shared.changeZoom(newScale: 2.2, newX: 125, newY: 0, duration: 1)
    }
    
    override func advanceToNextVC(){
        self.delegate?.handler(self, didFinishWithTransitionTo: ChooseVC.self)
    }
    

}
