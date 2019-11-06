//
//  ViewController.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit

enum Operator {
    case plus
    case minus
    case multiply
    case divide
    case equals
    case clear
    case plusOrMinus
    case percent
}


class CalculatorViewController: UIViewController {
        
    @IBOutlet weak var labelOutput: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func onNumeralPressed(_ sender: UIButton) {
        
        guard let numeral = sender.titleLabel?.text else { return }

        
        
    }
    


}

