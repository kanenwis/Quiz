//
//  QuizModel.swift
//  Quiz
//
//  Created by Samuel Kanenwisher on 3/31/19.
//  Copyright © 2019 Samuel Kanenwisher. All rights reserved.
//

import Foundation

protocol QuizProtocol {
    func questionsRetrieved(questions:[Question])
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions() {
        
        // Go retrieve data
        getLocalJsonFile()
        
    }
    
    func getLocalJsonFile() {
        
        // Get a path to the json file in our app bundle
        let path = Bundle.main.path(forResource: "QuestionData", ofType: ".json")
        
        guard path != nil else {
            print("Can't find the json file")
            return
        }
        
        // Create a URL object from the string path
        let url = URL(fileURLWithPath: path!)
        
        
        // Decode that data instances of the Question Struct
        do {
            // Get the data from that URL
            let data = try Data(contentsOf: url)
            
            // Decode the json data
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            // Return the question structs to the view controller
            delegate?.questionsRetrieved(questions: array)
            
        }
        catch {
            print("Couldn't create Data object from file")
        }
        
    }
    
    func getRemoteJsonFile() {
        
    }
    
}


