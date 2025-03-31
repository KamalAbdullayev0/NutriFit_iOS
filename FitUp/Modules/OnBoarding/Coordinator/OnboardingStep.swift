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
enum GoalType: String {
    case weightLoss = "Похудение"
    case muscleGain = "Набор мышц"
    case maintenance = "Поддержание веса"
}

enum ActivityLevel: String {
    case sedentary = "Сидячий"
    case moderate = "Умеренный"
    case active = "Активный"
}

enum Gender: String {
    case male = "Мужской"
    case female = "Женский"
}
