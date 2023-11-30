//
//  ZoomTestButton.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 20/06/2023.
//

import UIKit

class ZoomTestButton1: UIButton {
    private weak var background: Background?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        background?.changeZoom(newScale: 3, duration: 1)
    }

    func setBackgroundInstance(_ background: Background) {
        self.background = background
    }
}

class ZoomTestButton2: UIButton {
    private weak var background: Background?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        background?.changeZoom(moveRight: 50, duration: 1)
    }

    func setBackgroundInstance(_ background: Background) {
        self.background = background
    }
}
