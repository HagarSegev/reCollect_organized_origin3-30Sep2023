//
//  ViewControllerHandler.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 21/06/2023.
//

import UIKit

protocol ViewControllerHandler: AnyObject {
    var delegate: ViewControllerHandlerDelegate? { get set }
    var view: UIView { get }
    func setupView()
    func teardownView()
    func executeLogic()
}

//protocol ViewControllerHandlerDelegate: AnyObject {
//    func handlerDidFinish(_ handler: ViewControllerHandler)
//}

protocol ViewControllerHandlerDelegate: AnyObject {
    func handler(_ handler: ViewControllerHandler, didFinishWithTransitionTo nextHandlerType: ViewControllerHandler.Type)
}
