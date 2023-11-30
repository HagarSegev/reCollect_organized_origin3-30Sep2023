//
//  BackgroundScrollView.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 20/06/2023.
//

import UIKit

class BackgroundScrollView: UIScrollView {
    private var curScale: CGFloat
    private var curX: CGFloat
    private var curY: CGFloat
    private var curOpacity: CGFloat
    
    
    init(curScale: CGFloat, curX: CGFloat, curY: CGFloat, curOpacity: CGFloat) {
        self.curScale = curScale
        self.curX = curX
        self.curY = curY
        self.curOpacity = curOpacity
        
        super.init(frame: .zero)
        
        // Additional initialization code if needed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Getters
     */
    public func getCurrentScale() -> CGFloat {
        return curScale
    }
    
    func getCurrentX() -> CGFloat {
        return curX
    }
    
    func getCurrentY() -> CGFloat {
        return curY
    }
    
    func getCurrentOpacity() -> CGFloat {
        return curOpacity
    }
    
}

