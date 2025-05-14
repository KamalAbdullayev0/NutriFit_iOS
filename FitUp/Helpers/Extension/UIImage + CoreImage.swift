//
//  UIImage + CoreImage.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 14.05.25.
//
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

extension UIImage {
    /// Возвращает копию картинки, в которой все непрозрачные пиксели “утолщены” на radius точек.
    func thickened(radius: Float = 1) -> UIImage? {
        guard let cg = cgImage else { return nil }
        let ciInput = CIImage(cgImage: cg)
        
        // 1) Clamp — чтобы морфология работала у краёв
        let clamp = CIFilter.affineClamp()
        clamp.inputImage = ciInput
        clamp.transform = CGAffineTransform.identity
        
        // 2) Морфологическое расширение
        let morph = CIFilter.morphologyMaximum()
        morph.inputImage = clamp.outputImage
        morph.radius = radius
        
        guard let morphed = morph.outputImage else { return nil }
        
        // 3) Обрезаем результат по исходному extent
        let cropped = morphed.cropped(to: ciInput.extent)
        
        // 4) Рендерим в CGImage и в UIImage
        let context = CIContext(options: nil)
        guard let outCG = context.createCGImage(cropped, from: ciInput.extent) else { return nil }
        return UIImage(cgImage: outCG, scale: scale, orientation: imageOrientation)
    }
}
