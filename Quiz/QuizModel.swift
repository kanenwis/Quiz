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
        
        // TODO: Go retrieve data
        
        // When it comes back, call the questionsRetrieved method of the delegate
        delegate?.questionsRetrieved(questions: [Question]())
        
    }
}
