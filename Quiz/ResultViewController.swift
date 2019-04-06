//
//  ResultViewController.swift
//  Quiz
//
//  Created by Samuel Kanenwisher on 4/3/19.
//  Copyright © 2019 Samuel Kanenwisher. All rights reserved.
//

import UIKit

protocol ResultViewControllerProtocol {
    func resultViewDismissed()
}

class ResultViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate:ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set rounded corners for the dialog view
        dialogView.layer.cornerRadius = 10
        
        // Set the alpha for the dim view and elements to zero
        dimView.alpha = 0
        resultLabel.alpha = 0
        feedbackLabel.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Animate the dim in
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            
            self.dimView.alpha = 1
            
        }, completion: nil)
    }
    
    func setPopup(withTitle:String, withMessage:String, withAction:String) {
        
        resultLabel.text = withTitle
        feedbackLabel.text = withMessage
        dismissButton.setTitle(withAction, for: .normal)
        
        // Fade in the labels
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.resultLabel.alpha = 1
            self.feedbackLabel.alpha = 1
            
        }, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.dimView.alpha = 0
            
        }) { (completed) in
            
            // Only dismiss after dim view faded out
            self.dismiss(animated: true, completion: {
                
                // Clear the labels
                self.resultLabel.text = ""
                self.feedbackLabel.text = ""
            
        })
        self.delegate?.resultViewDismissed()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

}
