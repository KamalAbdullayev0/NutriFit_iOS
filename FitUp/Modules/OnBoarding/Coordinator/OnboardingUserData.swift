//
//  OnboardingUserData.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
class OnboardingUserData {
    var goal: GoalType?
    var activityLevel: ActivityLevel?
    var age: Int?
    var height: Int?
    var weight: Int?
    var gender: Gender?
    
    var isComplete: Bool {
        return goal != nil &&
               activityLevel != nil &&
               age != nil &&
               height != nil &&
               weight != nil &&
               gender != nil
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "goal": goal?.rawValue ?? "",
            "activityLevel": activityLevel?.rawValue ?? "",
            "age": age ?? 0,
            "height": height ?? 0,
            "weight": weight ?? 0,
            "gender": gender?.rawValue ?? ""
        ]
    }
}
