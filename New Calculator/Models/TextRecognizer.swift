//
//  TextRecognizer.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 20/03/25.
//

import UIKit
import Vision

struct TextRecognizer {
    
    func recognizeText(from image: UIImage, completion: @escaping (_ recognizedText: String) -> Void) {
        guard let cgImage = image.cgImage else { return }

        let request = VNRecognizeTextRequest { (request, error) in
            if let results = request.results as? [VNRecognizedTextObservation] {
                for observation in results {
                    if let candidate = observation.topCandidates(1).first {
                        completion(candidate.string)
                        print(candidate.string)
                    }
                }
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? requestHandler.perform([request])
    }
}
