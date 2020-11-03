import UIKit
import PlaygroundSupport

// Playground supports presenting new view controller
// 画面遷移のデモ


// MARK: - Second view controller which is instantiated by First View Controller
// First View Controller からインスタンス化される View Controller
class SecondViewController: UIViewController {
    // MARK: Variable which is passed from First View Controller
    // First View Controller から渡される値
    var selectedValue: String?
    
    lazy var button: UIButton = {
        let bv = UIButton()
        bv.setTitle("Dismiss", for: .normal)
        bv.backgroundColor = .systemPink
        bv.tintColor = .white
        bv.layer.cornerRadius = 25
        bv.addTarget(self, action: #selector(dissmissButton(_:)), for: .touchUpInside)
        
        return bv
    }()
    
    lazy var label: UILabel = {
       return UILabel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .systemGreen
        
        view.addSubview(label)
        view.addSubview(button)
        self.view = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        label.text = "Selected value is " + (selectedValue ?? "not selected")
        // ラベルのサイズをテキストサイズに合わせて自動でリサイズさせる
        label.sizeToFit()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
    }
    
    // MARK: Dissmiss this view controller
    // ボタンを押すと現在表示している View Controller を破棄して元の画面に戻る
    @objc func dissmissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - First View Controller
class FirstViewController : UIViewController {
    var displayData = [Int](1...20).map { String($0) }
    
    // MARK: make instances of UI parts
    lazy var tableView: UITableView = {
        // tableView も作れる
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // 標準では仕切り線が出ない
        tv.separatorColor = .gray
        // 以下は指定できなかった
        //tv.layer.borderWidth = 1.0
        //tv.layer.borderColor = UIColor.systemGray.cgColor
        return tv
    }()
    
    lazy var button: UIButton = {
        let bv = UIButton()
        bv.setTitle("Change value", for: .normal)
        bv.backgroundColor = .systemPink
        bv.tintColor = .white
        bv.layer.cornerRadius = 25
        bv.addTarget(self, action: #selector(changeButton(_:)), for: .touchUpInside)
        
        return bv
    }()
    
    @objc func changeButton(_ sener: UIButton) {
        displayData = [Int](1...displayData.count).map { _ in
            Int.random(in: 1000...9999).description
        }
        
        tableView.reloadData()
    }
    
    override func loadView() {
        // base view - required
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        
        view.addSubview(tableView)
        view.addSubview(button)
        
        self.view = view
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(view.frame)
        
        // AutoLayout も効く
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -12).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
    }
}

// MARK: - dataSource for UITableView
extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = displayData[indexPath.row]
        
        return cell
    }
}

// MARK: - delegates for UITableView
extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // MARK: instantiate new view controller
        let vc = SecondViewController()
        
        // pass a value related to selected cell to new instance
        // 選択したセルに表示されている値を新しいインスタンスに渡す（いわゆる値渡し）
        vc.selectedValue = displayData[indexPath.row]
        
        // set transition and display style
        // トランジッションと表示方法の設定
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        // present new view controller
        // 新規作成した View Controller を表示させる
        present(vc, animated: true, completion: nil)
    }
}

PlaygroundPage.current.liveView = FirstViewController()
