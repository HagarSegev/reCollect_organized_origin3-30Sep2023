//
//  Coordinator.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 21/06/2023.
//

import UIKit

class Coordinator: ViewControllerHandlerDelegate {
    internal var currentHandler: ViewControllerHandler?
    
    func transitionTo(handler: ViewControllerHandler) {
        currentHandler?.teardownView()
        print("Tore down view of previous handler")
        
        currentHandler = handler
        currentHandler?.delegate = self
        print("Transitioned to new handler")
        
        currentHandler?.setupView()
        print("Set up view of new handler")
        
        currentHandler?.executeLogic()
        print("Executed logic of new handler")
    }
    
    

    func handler(_ handler: ViewControllerHandler, didFinishWithTransitionTo nextHandlerType: ViewControllerHandler.Type) {
        
        // TODO: DELETE PRINT
        print("Handler \(type(of: handler)) did finish, transitioning to \(nextHandlerType)")
        //
        
        if nextHandlerType is StartVC.Type {
            transitionTo(handler: StartVC(view: handler.view, viewController: (handler as! StartVC).viewController!))
        } else if nextHandlerType is LoginVC.Type {
            transitionTo(handler: LoginVC(view: handler.view, viewController: (handler as! StartVC).viewController!))
        } else if nextHandlerType is ExplainGeneralVC.Type {
            transitionTo(handler: ExplainGeneralVC(view: handler.view))
        } else if nextHandlerType is InfoVC.Type {
            transitionTo(handler: InfoVC(view: handler.view))
        } else if nextHandlerType is ExplainChooseVC.Type {
            transitionTo(handler: ExplainChooseVC(view: handler.view))
        } else if nextHandlerType is ChooseVC.Type {
            transitionTo(handler: ChooseVC(view: handler.view))
        } else if nextHandlerType is ExplainRateVC.Type {
            transitionTo(handler: ExplainRateVC(view: handler.view))
        } else if nextHandlerType is RateVC.Type {
            transitionTo(handler: RateVC(view: handler.view))
        } else if nextHandlerType is ExplainCompareVC.Type {
            transitionTo(handler: ExplainCompareVC(view: handler.view))
        }  else if nextHandlerType is CompareVC.Type {
            transitionTo(handler: CompareVC(view: handler.view))
        } else if nextHandlerType is TestLogicVC2.Type {
            transitionTo(handler: TestLogicVC2(view: handler.view))
        } else if nextHandlerType is TestLogicVC3.Type {
            transitionTo(handler: TestLogicVC3(view: handler.view))
        }
    }
    
    
    //    func handlerDidFinish(_ handler: ViewControllerHandler) {
    //        if let handler = handler as? StartVC {
    //            transitionTo(handler: TestLogicVC2(view: handler.view))
    //        } else if let handler = handler as? TestLogicVC2 {
    //            transitionTo(handler: TestLogicVC3(view: handler.view))
    //        }
    //    }
    //
}


