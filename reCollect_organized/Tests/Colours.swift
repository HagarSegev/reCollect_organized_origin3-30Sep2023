//
//  Colours.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 24/07/2023.
//
import UIKit

func UIColorFromHex(_ rgbValue: UInt, alpha: Double = 1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0

    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

let orangeGradient = UIColorFromHex(0xd02a08) // #de6600
let blueGradient = UIColorFromHex(0x044848) // #003f5a
let sandShady = UIColorFromHex(0xd37b41)
