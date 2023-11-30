//
//  ViewController.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 20/06/2023.
//

import UIKit

class ViewController: UIViewController {
    private var background: Background?
    private var scrollView: BackgroundScrollView!
    var coordinator: Coordinator!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the background image
//        let backgroundImage = UIImage(named: "BackgroundImg")
//        background = Background(image: backgroundImage!)

        // Set up the background image view
        let backgroundImageView = Background.shared.imageView
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill

        // Add the background image view to the view hierarchy
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        let topBarManager = TopBarManager.shared
        
        // Add the top bar to the view hierarchy
        topBarManager.addToView(view)

        // Set up the coordinator
        coordinator = Coordinator()
        
        PhotoLoader.shared.loadPhotos()

        // Transition to StartVC
        coordinator.transitionTo(handler: StartVC(view: view, viewController: self))
//        // TODO: delete - * Change the VC hanler to generate it first
//        topBarManager.extendBar()
//        coordinator.transitionTo(handler: ChooseVC(view: view))
//        backgroundImageView.alpha = 1
//        topBarManager.animateOpacity(to: 1)

        // TODO: till here
//        background?.changeZoom(newScale: 3, duration: 1)
//
//        // Set up the scroll view
////        let scrollView1 = UIScrollView(frame: view.bounds)
//
//        let curScale = background?.getCurrentScale()
//        let curX = background?.getCurrentX()
//        let curY = background?.getCurrentY()
//        let curOpacity = background?.getCurrentOpacity()
//
//        scrollView = BackgroundScrollView(curScale: curScale!, curX: curX!, curY: curY!, curOpacity: curOpacity!)
//
//
//        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
//        scrollView.delegate = background
//        scrollView.frame = view.bounds
//        view.addSubview(scrollView)
//
//
//        // Add the desired effect (Effect1)
//        let effect = Effect2()
//        background?.addEffect(to: scrollView, effect: effect)
    }
    
}
