import UIKit
import Alamofire
import PKHUD
import PlaygroundSupport

// MARK: - GitHub API から得たいデータのうち、必要最低限のものだけ列記
// Structs to get JSON data from GitHub API
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

// MARK: - Main View Controller
class FirstViewController : UIViewController {
    // UITableView に表示するデータ
    // didSet + reloadData() で tableView を自動更新
    // Variable with property observer
    var gitData: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // 検索文字列入力用
    // textField to enter query words
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.placeholder = "Project name, subtitle, etc..."
        tf.borderStyle = .line
        tf.backgroundColor = .white
        
        return tf
    }()
    
    // 検索結果の表示
    // tableView to display query result
    lazy var tableView: UITableView = {
        let tv = UITableView()
        //tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.dataSource = self
        // UITableView をドラッグさせると自動でキーボードが消える
        // Allow user to hide keybord by dragging table view
        tv.keyboardDismissMode = .onDrag
        
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
        
        // UITextField に対する制約(constraint)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        // UITableView に対する制約(constraint)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 6).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 効率を考えると dequeue させるべきだが、今回は標準セルのうち subtitle を使いたいので、あえてインスタンスを毎回生成している
        // Usually, we need to use dequeueReusableCell method to obtain cell instance,
        // but in this sample requires default cell with detail view so that  to display subtitle.
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
        
        // 入力値が空でない場合、検索を実行
        if let text = textField.text, !text.isEmpty {
            searchGitHub(text: text)
        }
        
        return true
    }
    
    // MARK: Search GitHub Repository
    func searchGitHub(text: String) {
        // 入力を空白で分解し、"+" で連結する
        // split query string by white space and join with "+"
        let query = text.split(separator: " ").joined(separator: "+")
        
        // 検索用文字列を連結し、必要に応じてパーセントエンコーディングを行う
        // conctinationg each strings, and do percent encoding if needed
        if let urlString = ["https://api.github.com/search/repositories?q=",
                            query,
                            "&sort=stars"]
                            .joined()
                            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
           
        let url = URL(string: urlString) {
            // show Head Up Display
            // 検索中のポップアップを表示
            HUD.show(.labeledProgress(title: "Searching...", subtitle: nil))
            
            AF.request(url).responseData { response in
                // dismiss HUD
                // 検索中のポップアップを消す
                HUD.hide()
                
                switch response.result {
                case .success(let data):
                    do {
                        let result = try
                            JSONDecoder().decode(Github.self, from: data)
                        self.gitData = result.items
                        
                        let count = result.items.count
                        
                        if count > 0 {
                            // in case that we can get results
                            HUD.flash(.labeledSuccess(title: "Success", subtitle: "\(count) respositories were found"), delay: 3)
                        } else {
                            // no matching 
                            HUD.flash(.labeledError(title: "Not found", subtitle: nil), delay: 3)
                        }
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

