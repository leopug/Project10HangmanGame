//
//  ViewController.swift
//  Project10HangmanGame
//
//  Created by Ana Caroline de Souza on 17/01/20.
//  Copyright © 2020 Ana e Leo Corp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var responseLabel : UILabel!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel : UILabel!
    var wordToGuess : String!
    var guessButton : UIButton!
    var userGuessResult : String!
    var guessLabelText : String!
    var wrongAnswer = 0
    

    override func loadView() {
        
        wordToGuess = getARandomWord()
        
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 21)
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        for (i,charater) in wordToGuess.enumerated() {
            print(charater)
            print(i)
        }
        
        guessLabelText = ""
        for _ in 0..<wordToGuess!.count {
            guessLabelText+="?"
        }
        
        responseLabel = UILabel()
        responseLabel.translatesAutoresizingMaskIntoConstraints = false
        responseLabel.text = guessLabelText
        responseLabel.backgroundColor = .red
        responseLabel.textAlignment = .center
        responseLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(responseLabel)
        
        guessButton = UIButton(type: .system)
        guessButton.translatesAutoresizingMaskIntoConstraints = false
        guessButton.setTitle("Guess a letter", for: .normal)
        guessButton.addTarget(self, action: #selector(guessButtonTapped), for: .touchUpInside)
        guessButton.layer.borderColor = UIColor.gray.cgColor
        guessButton.layer.borderWidth = 0.8
        guessButton.layer.cornerRadius = 5
        guessButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        guessButton.backgroundColor = .lightGray
        view.addSubview(guessButton)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            responseLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30),
            responseLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            responseLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            guessButton.topAnchor.constraint(equalTo: responseLabel.safeAreaLayoutGuide.bottomAnchor, constant: 30),
            guessButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            guessButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -100),
            guessButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            guessButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    @objc func guessButtonTapped(){
        let ac = UIAlertController(title: "Guess a Letter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let userGuessResult = ac?.textFields?[0].text else { return }
            if (self?.wordToGuess.firstIndex(of: Array(userGuessResult)[0]) != nil) {
                self?.userGuessResult = userGuessResult
                self?.updateResponseLabel()
            } else {
                var title = ""
                var message = ""
                
                self?.wrongAnswer+=1
                
                if self?.wrongAnswer == 7 {
                    title = "Game Over"
                    message = "Better luck next time"
                    self?.resetGame()
                } else {
                    title = "Try again!"
                    message = "You wrong"
                }
                
                let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self?.present(ac, animated: true)

            }

        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func updateResponseLabel() {
        for (i,letter) in wordToGuess.enumerated() {
            if letter == Array(userGuessResult!)[0] {
                var chars = Array(guessLabelText)
                chars[i] = letter
                guessLabelText = String(chars)
                score+=1
            }
        }
        responseLabel.text = guessLabelText
        if guessLabelText.firstIndex(of: "?") == nil {
            let ac = UIAlertController(title: "Congratulations", message: "You answered correctly the word \(wordToGuess!). A new word is waiting for you now!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true)
            resetGame()
        }
    }
    
    func getARandomWord() -> String {
        return ["car","abacate","latinha","pitbull","sabonete",
                "vinagre","raining","blood"].randomElement()!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    func resetGame(){
        wordToGuess = getARandomWord()
        guessLabelText = ""
        for _ in 0..<wordToGuess!.count {
            guessLabelText+="?"
        }
        responseLabel.text = guessLabelText
        score = 0
        wrongAnswer = 0
    }

}

