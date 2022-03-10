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
    @IBOutlet weak var getQuoteButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteCollectionView: UICollectionView!
    
    @IBAction func getQuoteButtonPressed(_ sender: Any) {
        getQuote() { result in
            self.quoteLabel.text = result
        }
    }
   
    @IBAction func getJokeButtonPressed(_ sender: Any) {
        getJoke() { result in
            self.jokeLabel.text = result
        }
    }
    
    var quotes: [String] = []

    private func getQuote(onComplete: @escaping (String) -> Void ) {
            let randomNumber = Int.random(in: 0..<100)
            var requestQuote = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/\(randomNumber)")!)
        requestQuote.httpMethod = "GET"
        URLSession.shared.dataTask(with: requestQuote) { (data, response, error) in
                do {
                    print("data = \(data!)")
                    print("response = \(response!)")
                    let jsonDecoder = JSONDecoder()
                    let fullResponce = try jsonDecoder.decode(QuoteStruct.self, from: data!)
                    guard let title = fullResponce.title else { return }
                    let quoteText = title
                    self.quotes.append(title)
                    DispatchQueue.main.async {
                        onComplete(quoteText)
                        self.quoteCollectionView.reloadData()
                    }
                    print(fullResponce)
                } catch {
                    print("JSON Serialization error")
                }
        }.resume()
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
        quoteCollectionView.register(UINib(nibName: "QuoteCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "QuoteCollectionViewCell")
    }

    }


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuoteCollectionViewCell", for: indexPath) as? QuoteCollectionViewCell else { fatalError() }
        let quote = quotes[indexPath.item]
        cell.setup(quote)
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? QuoteCollectionViewCell else { return }
        cell.quoteLabel.textColor = .red
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? QuoteCollectionViewCell else { return }
        cell.quoteLabel.textColor = .black
    }
}
