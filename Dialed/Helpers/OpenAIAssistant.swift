//
//  OpenAIAssistant.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/19/24.
//

import Foundation

class DialAI: Observable {

    func fetchAISuggestions(shots: [Shot], bean: Beans, completion: @escaping (String) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        let apiKey = "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" // Replace with your OpenAI API key

        // Convert shot data to a readable format for the prompt
        let shotData = shots.map { shot in
            """
            Grind Size: \(shot.grind.notes), Dose: \(shot.dose)g, Extraction Time: \(shot.extractionTime)s, Yield: \(shot.yield)g, Dialed: \(shot.dialed ? "Yes" : "No")
            """
        }.joined(separator: "\n")
        
        let beanData = """
        Origin: \(bean.advanced.origin.isEmpty ? "Unknown" : bean.advanced.origin)
        Varietal: \(bean.advanced.varietal.rawValue.isEmpty ? "Unknown" : bean.advanced.varietal.rawValue)
        Process: \(bean.advanced.process.rawValue.isEmpty ? "Unknown" : bean.advanced.process.rawValue)
        Altitude: \(bean.advanced.altitude.rawValue.isEmpty ? "Unknown" : bean.advanced.altitude.rawValue)
        Roaster: \(bean.roaster.isEmpty ? "Unknown" : bean.roaster)
        Roast Strength: \(bean.roast.rawValue.isEmpty ? "Unknown" : bean.roast.rawValue)
        Roast Date: \(formatDate(bean.roastedOn))
        """

        
        let tastingNotes = shots.map { shot in
            """
            Acidity: \(shot.tastingNotes.acidity), Bitterness: \(shot.tastingNotes.bitterness), Crema: \(shot.tastingNotes.crema), Satisfaction: \(shot.tastingNotes.satisfaction))
            """
        }.joined(separator: "\n")

        let prompt = """
        The user is dialing in these new coffee beans for espresso:
        \(beanData)
        Based on the following espresso shot data, suggest adjustments for the next shot:
        \(shotData)
        Provide parameters such as grind size, dose, and extraction time considering the user's personal tasting assesment (0 = bad, 1 = best):
        \(tastingNotes).
        """

        // Prepare the request body
        let parameters: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": "You are an expert barista and espresso technician."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        guard let requestBody = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion("Error: Unable to serialize request body.")
            return
        }

        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making API request: \(error)")
                completion("Error: Unable to fetch suggestions.")
                return
            }

            guard let data = data else {
                print("No data received.")
                completion("Error: No response data.")
                return
            }

            // Parse the response
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let suggestion = choices.first?["message"] as? [String: Any],
                   let content = suggestion["content"] as? String {
                    completion(content)
                } else {
                    completion("Error: Unexpected response format.")
                }
            } catch {
                print("Error parsing response: \(error)")
                completion("Error: Unable to parse response.")
            }
        }.resume()
    }

}
