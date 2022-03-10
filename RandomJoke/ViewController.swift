//
//  ViewController.swift
//  RandomJoke
//
//  Created by Павел Богданов on 10.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var getJokeButton: UIButton!
    @IBOutlet weak var jokeLabel: UILabel!
   
    @IBAction func getJokeButtonPressed(_ sender: Any) {
        getJoke() { result in
            self.jokeLabel.text = result
        }
    }
    
    private func getJoke(onComplete: @escaping (String) -> Void ) {
        var request = URLRequest(url: URL(string: "https://api.jokes.one/jod")!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                print("data = \(data!)")
                print("response = \(response!)")
                let jsonDecoder = JSONDecoder()
                let fullResponce = try jsonDecoder.decode(JokeStruct.self, from: data!)
                let jokeText = fullResponce.contents?.jokes?[0].joke?.text
                DispatchQueue.main.async {
                    guard let jokeText = jokeText else {
                        return
                    }
                    onComplete(jokeText)
                }
                print(fullResponce)
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

