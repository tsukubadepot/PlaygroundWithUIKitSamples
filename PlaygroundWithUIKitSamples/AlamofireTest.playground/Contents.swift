import UIKit
import Alamofire
import PlaygroundSupport

struct Github: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Item: Codable {
    let name: String
    let htmlURL: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case htmlURL = "html_url"
        case description
    }
}

class FirstViewController : UIViewController {
    var gitData: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.placeholder = "input here"
        tf.borderStyle = .line
        
        return tf
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        //tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.dataSource = self
        
        return tv
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        
        view.addSubview(tableView)
        view.addSubview(textField)
        self.view = view
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 6).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = gitData[indexPath.row].name
        cell.detailTextLabel?.text = gitData[indexPath.row].description
        
        return cell
    }
}

extension FirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            searchGitHub(text: text)
        }
        return true
    }
    
    func searchGitHub(text: String) {
        let query = text.split(separator: " ").joined(separator: "+")
        if let urlString = ["https://api.github.com/search/repositories?q=",
                            query,
                            "&sort=stars"]
                            .joined()
                            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
           
           let url = URL(string: urlString) {
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let result = try
                            JSONDecoder().decode(Github.self, from: data)
                        self.gitData = result.items
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = FirstViewController()

