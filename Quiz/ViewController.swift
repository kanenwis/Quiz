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
    var numCorrect = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Conform to the table view protocols
        tableView.dataSource = self
        tableView.delegate = self
        
        // Configure the tableview for dynamic row height
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Set self as delegate for model and call get questions
        model.delegate = self
        model.getQuestions()
    }
    
    func displayQuestion() {
        
        // Check that the current questions index is not beyond the bounds of the questions array
        guard questionIndex < questions.count else {
            print("Trying to display a question index that is out of bounds")
            return
        }
        
        // Display the question
        questionLabel.text = questions[questionIndex].question!
        
        //Display the answers
        tableView.reloadData()
        
    }

    // MARK: - QuizProtocol methods
    
    func questionsRetrieved(questions: [Question]) {
        
        
        //Set our questions property with the questions from quiz model
        self.questions = questions
        
        // Display the first question
        displayQuestion()
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
        
        // Set the text for the label
        
        label.text = questions[questionIndex].answers![indexPath.row]
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // User has selected an answer
        if questions[questionIndex].correctAnswerIndex! ==
            indexPath.row {
            
            // User has selected the correct answer
            numCorrect += 1
        }
        else {
            // User has selected the wrong answer
        }
        
        // Increment the question index to advance to the next question
        questionIndex += 1
        displayQuestion()
        
        
    }
    
}

