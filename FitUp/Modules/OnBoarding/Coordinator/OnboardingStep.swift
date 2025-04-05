//
//  OnboardingStep.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
enum OnboardingStep {
    case goal
    case activity
    case age
    case height
    case weight
    case gender
    case completed
}

enum Goal: String {
    case weightLoss = "WEIGHT_LOSS"
    case maintainWeight = "MAINTAIN_WEIGHT"
    case weightGain = "WEIGHT_GAIN"
}

enum Gender: String {
    case male = "MALE"
    case female = "FEMALE"
}

enum ActivityLevel: String {
    case passive = "PASSIVE"
    case lowActive = "LOW_ACTIVE"
    case active = "ACTIVE"
    case veryActive = "VERY_ACTIVE"
}


func goalFromTitle(_ title: String) -> Goal? {
    switch title {
    case "Lose weight":
        return .weightLoss
    case "Manage a health condition":
        return .maintainWeight
    case "Increase weight":
        return .weightGain
    default:
        return nil
    }
}
func genderFromTitle(_ title: String) -> Gender? {
    switch title {
    case "👦🏻 Male":
        return .male
    case "👩🏻 Female":
        return .female
    default:
        return nil
    }
}

func activityLevelFromTitle(_ title: String) -> ActivityLevel? {
    switch title {
    case "Not very active":
        return .passive
    case "Moderately active":
        return .lowActive
    case "Highly active":
        return .active
    case "Extremely active":
        return .veryActive
    default:
        return nil
    }
}

