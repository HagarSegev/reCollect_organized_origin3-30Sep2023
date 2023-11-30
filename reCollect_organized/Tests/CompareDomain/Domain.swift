//
//  Domain.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 07/09/2023.
//

import Foundation

enum Domain: String {
    case recency = "Recency"
    case frequency = "Frequency"
    case significance1 = "Significance1"
    case significance2 = "Significance2"
    case significance3 = "Significance3"
    case significance4 = "Significance4"
    case emotional = "Emotional"
    case aesthetics = "Aesthetics"
    case vividness = "Vividness"
    case selfrelevance = "Self-Relevance"

    
    var svgFileName: String {
        switch self {
        case .recency: return "recency.svg"
        case .frequency: return "frequency.svg"
        case .significance1: return "significance1.svg"
        case .significance2: return "significance2.svg"
        case .significance3: return "significance3.svg"
        case .significance4: return "significance4.svg"
        case .selfrelevance: return "selfrelevance.svg"
        case .emotional: return "emotional.svg"
        case .aesthetics: return "aesthetics.svg"
        case .vividness: return "vividness.svg"
        }
    }
    
    var caption: String {
        switch self {
        case .recency: return "   Which event happened more recently  "
        case .frequency: return "   Which experience do you think about more often?  "
        case .significance1: return "   Which photo is more significant?  "
        case .significance2: return "   Which event is more significant?  "
        case .significance3: return "   Which place is more significant?  "
        case .significance4: return "   Which person is more significant?  "
        case .selfrelevance: return " Which event is more personally relevant for you? "
        case .emotional: return "   Which event was more emotional?  "
        case .aesthetics: return "   Which photo is more aethetic?  "
        case .vividness: return "   Which event do you remember more vividly?  "
        }
    }
}
