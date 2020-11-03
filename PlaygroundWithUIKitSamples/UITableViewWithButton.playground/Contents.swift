import UIKit
import PlaygroundSupport

class FirstViewController : UIViewController {
    // TableView に表示させる初期データ
    var displayData = [Int](1...20).map { String($0) }
    
    // MARK: - make instance of UITableView
    lazy var tableView: UITableView = {
        let tv = UITableView()

        tv.dataSource = self
        
        // register default Cell class
        // 標準のセルを登録する
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // separator
        // 標準では仕切り線が出ないので色をつける
        tv.separatorColor = .gray
        
        // I don't know why but I couldn't set these parameters
        // 以下は指定できなかった
        //tv.layer.borderWidth = 1.0
        //tv.layer.borderColor = UIColor.systemGray.cgColor
        return tv
    }()
    
    // MARK: - make instance of UIButton
    lazy var button: UIButton = {
        let bv = UIButton()
        
        bv.setTitle("Change value", for: .normal)
        bv.backgroundColor = .systemPink
        bv.tintColor = .white
        
        // with rounded corner
        bv.layer.cornerRadius = 25
        
        // add target
        bv.addTarget(self, action: #selector(changeButton(_:)), for: .touchUpInside)
        
        return bv
    }()
    
    // whis function will be called when user touchs up inside the button
    // ボタンをタップした際に呼び出されるメソッド
    @objc func changeButton(_ sener: UIButton) {
        // make random value and map it to String
        // テービュルビューと関連づけている配列の数だけ Int のインスタンスを作り、1000から9999までの乱数と置き換える
        displayData = [Int](1...displayData.count).map { _ in
            Int.random(in: 1000...9999).description
        }
        
        tableView.reloadData()
    }
    
    override func loadView() {
        // required. Base view
        // ベースとなるビューを作る
        // これは最低限必要となる
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        // UITableView や UIButton を追加する
        view.addSubview(tableView)
        view.addSubview(button)
        
        // AutoLayout は viewWillLayoutSubviews() で行う
        
        self.view = view
    }
    
    // MARK: - add code related to AutoLayout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // we can get actual view size here.
        // ここで view のサイズが確定する
        // frame 基準でレイアウトする際にも、ここでレイアウトを行う
        print(view.frame)
        
        // Autolayout for views are also able to use with Playground
        // AutoLayout も効く
        // Button の制約 (constraints)
        // - view の両端と下端を基準に 12 ポイント
        // - button の高さは 50 ポイント
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        
        // TableView の制約 (constraints)
        // - view の両端と上端を基準に内側 12 ポイント
        // - 下端は button の上端を基準に内側 12 ポイント
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -12).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
    }
}

// MARK: - dataSource
extension FirstViewController: UITableViewDataSource {
    // TableView に表示させるデータの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }
    
    // TableView に表示させるセルの生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = displayData[indexPath.row]
        
        return cell
    }
}

// Make instance of view controller and run it.
// ビューコントローラを作り実行させる。
PlaygroundPage.current.liveView = FirstViewController()
