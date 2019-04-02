//
//  ViewController.swift
//  Quiz
//
//  Created by Samuel Kanenwisher on 3/31/19.
//  Copyright © 2019 Samuel Kanenwisher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var model = QuizModel()
    var questions = [Question]()
    var questionIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Conform to the table view protocols
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set self as delegate for model and call get questions
        model.delegate = self
        model.getQuestions()
    }

    // MARK: - QuizProtocol methods
    
    func questionsRetrieved(questions: [Question]) {
        
        
        //Set our questions property with the questions from quiz model
        self.questions = questions
        
        // Tell the tableview to reload data
        tableView.reloadData()
    }
    
    // MARK: - TableView Protocol Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard questions.count > 0 && questions[questionIndex].answers != nil else {
            return 0
        }
        
        return questions[questionIndex].answers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // Get the label
        let label = cell.viewWithTag(1) as! UILabel
        
        // TODO: Set the text for the label
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // User has selected an answer
        
    }
    
}

