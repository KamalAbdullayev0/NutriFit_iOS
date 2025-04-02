//
//  OnboardingUserData.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//

class OnboardingUserData {
    var goal: String?
    var activityLevel: String?
    var age: Int?
    var height: Int?
    var weight: Int?
    var gender: String?
    
    var isComplete: Bool {
        return goal != nil &&
               activityLevel != nil &&
               age != nil &&
               height != nil &&
               weight != nil &&
               gender != nil
    }
    
    // 🚀 Функция для обновления данных с логами
    @discardableResult
    func setData(step: OnboardingStep, value: Any) -> OnboardingUserData {
        switch step {
        case .goal:
            goal = value as? String
        case .activity:
            activityLevel = value as? String
        case .age:
            age = value as? Int
        case .height:
            height = value as? Int
        case .weight:
            weight = value as? Int
        case .gender:
            gender = value as? String
        case .completed:
            break
        }
        
        print("✅ Данные обновлены: \(step) -> \(value)")
        print("📊 Текущие данные: \(toDictionary())\n")
        
        return self
    }
    
    // 🔥 Метод для получения готовых данных
    func build() -> [String: Any]? {
        guard isComplete else {
            print("⚠️ Данные не заполнены полностью!")
            return nil
        }
        print("🚀 Все данные собраны, можно отправлять!")
        return toDictionary()
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "goal": goal ?? "",
            "activityLevel": activityLevel ?? "",
            "age": age ?? 0,
            "height": height ?? 0,
            "weight": weight ?? 0,
            "gender": gender ?? ""
        ]
    }
}
