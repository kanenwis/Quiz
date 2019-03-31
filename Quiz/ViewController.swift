//
//  ViewController.swift
//  Quiz
//
//  Created by Samuel Kanenwisher on 3/31/19.
//  Copyright © 2019 Samuel Kanenwisher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol {
    
    var model = QuizModel()
    var question = [Question]()
    var questionIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        model.delegate = self
        model.getQuestions()
    }

    // MARK: - QuizProtocol methods
    
    func questionsRetrieved(questions: [Question]) {
        print("Hey Questions are returned!")
    }

}

