//
//  ViewController.swift
//  Smart Chef*
//
//  Created by Blair Bryant on 10/25/18.
//  Copyright © 2018 Blair Bryant. All rights reserved.
//

import UIKit
///////////
struct serverResponse: Decodable{
    let response : sensRead

}

struct sensRead: Decodable{
    let status: String
    let data: Int
}
////////////
struct stepResponse: Decodable{
    let resp : stepRead
    
}

struct stepRead: Decodable{
    let recipe_id: Int
    let job_ids: [Int]
    let current_step : step
    let prev_step : step
    let next_step : step
}

struct step: Decodable{
    let id : Int
    let data : String
    let step_number : Int
    let created_at : String
}



struct objectTrig{
    
}


class ViewController: UIViewController {
   
    @IBOutlet weak var previousStep: UITextView!
    @IBOutlet weak var currentStep: UITextView!
    @IBOutlet weak var nextStep: UITextView!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var top: UIView!
    @IBOutlet weak var paragraph: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let jsonUrlString = "http://10.231.190.149:8000/api/getTemp"
//        guard let url = URL(string: jsonUrlString) else { return }
//        URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//
//            do{
//                let job = try JSONDecoder().decode(tempRead.self, from: data)
//                print(job.data)
//                DispatchQueue.main.async {
//                    self.temp.text = String(job.data)
//                }
//            }
//            catch let jsonErr{
//                print("Error serializing json:", jsonErr)
//
//            }
//
//            }.resume()
        
        
        
        
        
        
        var helloWorldTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.updateStuff), userInfo: nil, repeats: true)
        
        
        
    }
    
    @objc func post(json: [String: Any]){
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // create post request
        let url = URL(string: "http://10.230.140.122:8001/api/increment-step")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
    
    @objc func updateStuff()
    {
        NSLog("hello World")
        let jsonUrlString = "http://10.230.140.122:8000/api/getTemp"
        let jsonUrlString1 = "http://10.230.140.122:8000/api/getWeight"
        let jsonUrlString2 = "http://10.230.140.122:8001/api/currentStep"
        guard let url = URL(string: jsonUrlString) else { return }
        guard let url1 = URL(string: jsonUrlString1) else { return }
        guard let url2 = URL(string: jsonUrlString2) else { return }
        
        
        //sensors
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }

            do{
                let job = try JSONDecoder().decode(sensRead.self, from: data)
                print(job)
                DispatchQueue.main.async {
                    self.temp.text = String(job.data)
                }
            }
            catch let jsonErr{
                print("Error serializing json:", jsonErr)

            }

            }.resume()
        URLSession.shared.dataTask(with: url1) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                let job1 = try JSONDecoder().decode(sensRead.self, from: data)
                print(job1)
                DispatchQueue.main.async {
                    self.weight.text = String(job1.data)
                }
            }
            catch let jsonErr{
                print("Error serializing json:", jsonErr)
                
            }
            
            }.resume()
        
        //steps
        URLSession.shared.dataTask(with: url2) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                let job2 = try JSONDecoder().decode(stepRead.self, from: data)
                print(job2.current_step.data)
                DispatchQueue.main.async {
                    self.currentStep.text = String(job2.current_step.data)
                    self.previousStep.text = String(job2.prev_step.data)
                    self.nextStep.text = String(job2.next_step.data)
                    
                }
            }
            catch let jsonErr{
                print("Error serializing json:", jsonErr)
                
            }
            
            }.resume()
        
    }

   
    
    
    @IBAction func prev(_ sender: UIButton) {
        print("previous step")
        paragraph.text = "previous step"
        
        let json: [String: Any] = ["increment_steps": -1]
        post(json: json)
        updateStuff()
    }
    
    
    
    @IBAction func next(_ sender: UIButton) {
        print("previous step")
        paragraph.text = "next step"
        
        let json: [String: Any] = ["increment_steps": 1]
        post(json: json)
        updateStuff()
    }
    
 }

