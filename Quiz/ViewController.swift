//
//  ViewController.swift
//  Quiz
//
//  Created by Samuel Kanenwisher on 3/31/19.
//  Copyright © 2019 Samuel Kanenwisher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDataSource, UITableViewDelegate, ResultViewControllerProtocol {
    
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var model = QuizModel()
    var questions = [Question]()
    var questionIndex = 0
    var numCorrect = 0
    
    var resultVC: ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the result dialog view controller
        resultVC =
            storyboard?.instantiateViewController(withIdentifier:
            "ResultVC") as? ResultViewController
        resultVC?.delegate = self
        resultVC?.modalPresentationStyle = .overCurrentContext
        
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
        
        // Animate in the question
        slideInQuestion()
        
    }
    
    func slideInQuestion() {
        
        // Set the starting state
        rootStackView.alpha = 0
        stackViewLeadingConstraint.constant = 1000
        stackViewTrailingConstraint.constant = -1000
        view.layoutIfNeeded()
        
        // Animate to the ending state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.rootStackView.alpha = 1
            self.stackViewLeadingConstraint.constant = 0
            self.stackViewTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    func slideOutQuestion() {
        
        // Set the starting state
        rootStackView.alpha = 1
        stackViewLeadingConstraint.constant = 0
        stackViewTrailingConstraint.constant = 0
        view.layoutIfNeeded()
        
        // Animate to the ending state
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            
            self.rootStackView.alpha = 0
            self.stackViewLeadingConstraint.constant = -1000
            self.stackViewTrailingConstraint.constant = 1000
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }

    // MARK: - QuizProtocol methods
    
    func questionsRetrieved(questions: [Question]) {
        
        
        //Set our questions property with the questions from quiz model
        self.questions = questions
        
        // Check if there's a stored state
        let qIndex = StateManager.retrieveValue(key:
            StateManager.questionIndexKey) as? Int
        
        // Check if it's nil.  If not, check if it's a valid index
        if qIndex != nil && qIndex! < questions.count {
            
            // Set the current index to the restored index
            questionIndex = qIndex!
            
            //restore the num correct
            numCorrect = StateManager.retrieveValue(key:
                StateManager.numCorrectKey) as! Int
            
        }
        
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
        
        // Check against question index being out of bounds
        guard questionIndex < questions.count else {
            return
        }
        
        // Declare variables for the popup
        var title:String = ""
        let message:String = questions[questionIndex].feedback!
        let action:String = "Next"
        
        // User has selected an answer
        if questions[questionIndex].correctAnswerIndex! ==
            indexPath.row {
            
            // User has selected the correct answer
            numCorrect += 1
            
            // Set the title for the popup
            title = "Correct!"
        }
        else {
            // User has selected the wrong answer
            
            // Set the title for the popup
            title = "Wrong!"
        }
        
        // Slide out question
        slideOutQuestion()
        
        // Display the popup
        
        if resultVC != nil {
            
            // let the main thread display the popup
            // Fixes the issue Students encountered here: https://academy.codewithchris.com/courses/258388/lectures/4261621
            DispatchQueue.main.async {
                self.present(self.resultVC!, animated: true, completion: {
                    // Set the message for the popup:
                    self.resultVC!.setPopup(withTitle: title, withMessage: message, withAction: action)
                })
            }
        }
        
        // Increment the question index to advance to the next question
        questionIndex += 1
        
        // Save state
        StateManager.saveState(numCorrect: numCorrect, questionIndex: questionIndex)
    }
    
    // MARK: - ResultViewControllerProtocol methods
    
    func resultViewDismissed() {
        
        // Check the question index
        
        // If the question index == question count then we've finished the last question
        if questionIndex == questions.count {
            
            // Show summary
            if resultVC != nil {
                present(resultVC!, animated: true, completion: {
                    
                    self.resultVC?.setPopup(withTitle: "Summary", withMessage: "You got \(self.numCorrect) out of \(self.questions.count) correct.", withAction: "Restart")
                })
            }
            
            // Increment the question index so that the next time the user dismisses the dialog, we go into th next branch of this if statement
            questionIndex += 1
            
            // Clear state
            StateManager.clearState()
        }
        else if questionIndex > questions.count {
            
            // Restart the quiz
            numCorrect = 0
            questionIndex = 0
            displayQuestion()
        }
        else {
            
            // Display the next question when the result view has been dismissed
            displayQuestion()
        }
    }
    
}


