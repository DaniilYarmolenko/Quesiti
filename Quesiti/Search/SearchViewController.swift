//
//  SearchViewController.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 13.11.2021.
//

import UIKit
import Firebase
import CoreLocation

protocol SearchViewProtocol: AnyObject {
    
}

class SearchViewController: UIViewController {
    
    var user: User?
    var locationManager = CLLocationManager()
    var presenter: SearchViewPresenter!
    var search: String = ""
    
    var searchUsers: [User] = []
    var users: [User] = []
    
    var questions: [QuestionModel] = []
    var searchQuestions: [QuestionModel] = []
    
    
    lazy var searchView: SearchView = {
        searchView = SearchView()
        searchView.textField.addTarget(self, action: #selector(searchField(_:)), for: .editingChanged)
        searchView.clearButton.addTarget(self, action: #selector(clickClearButton(_:)), for: .touchUpInside)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        return searchView
    }()
    
    let btnAddQuestion: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        btn.backgroundColor = ThemeColors.mainColor
        btn.setImage(UIImage(systemName: "plus.circle", withConfiguration: config), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.white
        btn.imageView?.sizeToFit()
        btn.addTarget(self, action: #selector(btnAddQuestionAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    lazy var tableView: UITableView = {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        //collectionView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllQuestions()
        navigationController?.navigationBar.isHidden = true
        presenter.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didPullToRefresh), name: Notification.Name("didPullToRefresh"), object: nil)
        view.addSubview(searchView)
        view.addSubview(tableView)
        view.addSubview(btnAddQuestion)
        setupProfileView()
        setupLayoutWithTable()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: .tableId)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: .colId)
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let tableRefreshControl = UIRefreshControl()
        tableRefreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = tableRefreshControl
        
        let collectionRefreshControl = UIRefreshControl()
        collectionRefreshControl.addTarget(self, action: #selector(didPullToRefresh1), for: .valueChanged)
        collectionView.refreshControl = collectionRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupProfileView(){
        self.searchView.peopleButton.addTarget(self, action: #selector(clickPeopleButton(_:)), for: .touchUpInside)
        self.searchView.questionButton.addTarget(self, action: #selector(clickQuestionButton(_:)), for: .touchUpInside)
    }

    private func setupLayoutWithTable(){
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 160),
            
            btnAddQuestion.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            btnAddQuestion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAddQuestion.widthAnchor.constraint(equalToConstant: 50),
            btnAddQuestion.heightAnchor.constraint(equalTo: btnAddQuestion.widthAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupLayoutWithCollection(){
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 160),
            
            btnAddQuestion.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            btnAddQuestion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAddQuestion.widthAnchor.constraint(equalToConstant: 50),
            btnAddQuestion.heightAnchor.constraint(equalTo: btnAddQuestion.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    func measure(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double{  // generally used geo measurement function
        let R = 6378.137; // Radius of earth in M
        let pi = 3.1415926
        let dLat = abs(lat2 * pi/180 - lat1 * pi/180)
        let latPlus = lat2 * pi/180 + lat1 * pi/180
        let dLon = abs(lon2 * pi/180 - lon1 * pi/180)
        let conv = sqrt(sin(dLat/2)*sin(dLat/2)+(1-sin(dLat/2)*sin(dLat/2)-sin(latPlus/2)*sin(latPlus/2))*sin(dLon/2)*sin(dLon/2))
        let rez = 2*R*asin(conv)*1000
        return rez // meters
    }
    
    private func fetchAllUsers() {
        
        Database.database().fetchAllUsers(includeCurrentUser: false, completion: { (users) in
            self.users = users
            if self.search != ""{
                self.searchUsers = users.filter({ user in
                    user.name.lowercased().contains(self.search.lowercased())
                })
            } else {
                self.searchUsers = users
            }
            
            self.collectionView.reloadData()
            
            self.collectionView.reloadData()
        }) { (_) in
        }
    }
    
    private func fetchAllQuestions(){
        Database.database().fetchAllPosts { posts in
            self.questions = posts //здесь полная инфа по всем постам
            if self.search != ""{
                self.searchQuestions = posts.filter({ question in
                    question.titleQuestion.lowercased().contains(self.search.lowercased())
                })
            } else {
                self.searchQuestions = posts
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func clickPeopleButton(_: Any){
        fetchAllUsers()
        tableView.removeFromSuperview()
        btnAddQuestion.removeFromSuperview()
        view.addSubview(collectionView)
        view.addSubview(btnAddQuestion)
        setupLayoutWithCollection()
    }
    
    @objc func clickQuestionButton(_: Any){
        fetchAllQuestions()
        collectionView.removeFromSuperview()
        btnAddQuestion.removeFromSuperview()
        view.addSubview(tableView)
        view.addSubview(btnAddQuestion)
        setupLayoutWithTable()
    }
    
    @objc func btnAddQuestionAction() {
        let addQuuestion: AddQuestionViewController = AddQuestionViewController()
        addQuuestion.modalPresentationStyle = .fullScreen
        self.present(addQuuestion, animated: true, completion: nil)
    }
    
    @objc func searchField(_ textField: UITextField){
        guard let text = textField.text else { return }
        search = text
            //print(users)
        
        if search != ""{
            searchQuestions = questions.filter({ question in
                question.titleQuestion.lowercased().contains(search.lowercased())
            })
            searchUsers = users.filter({ user in
                user.name.lowercased().contains(search.lowercased())
            })
        } else {
            searchQuestions = questions
            searchUsers = users
        }
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    @objc func clickClearButton(_: Any){
        searchView.textField.text = ""
        search = ""
        searchUsers = users
        searchQuestions = questions
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    @objc
        private func didPullToRefresh() {
            tableView.refreshControl?.beginRefreshing()
            fetchAllQuestions()
            guard let text = searchView.textField.text else { return }
            search = text
            //print(users)
            
            tableView.refreshControl?.endRefreshing()
    }
    
    @objc
        private func didPullToRefresh1() {
            collectionView.refreshControl?.beginRefreshing()
            fetchAllUsers()
            collectionView.refreshControl?.endRefreshing()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchQuestions = searchQuestions.sorted {(ques1: QuestionModel, ques2: QuestionModel) in ques1.creationDate > ques2.creationDate}
        return searchQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .tableId, for: indexPath) as? TableViewCell else {
            fatalError()
        }
        //print(questions)
        let ques = searchQuestions[indexPath.row]
        if ques.user.avatarURL != "" {
            Storage.storage().loadUserProfileImage(url: ques.user.avatarURL ?? "", completion: {(imageData) in
                let image = UIImage(data: imageData)
                cell.avatarView.image = image
            })
        }else{
            cell.avatarView.image = UIImage(named: "avatar")
        }
        //cell.avatarView.image = UIImage(named: ques.user.avatarURL)
        cell.nameLabel.text = ques.user.name
        cell.questionLabel.text = ques.titleQuestion
        cell.questionLabel.setLineHeight(lineHeight: 0.85)
        cell.dateLabel.text = ques.creationDate.timeAgoDisplay()
        cell.countOfComsView.text = "\(ques.answerCount)"
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let ques = searchQuestions[indexPath.row]
        let distance = measure(lat1: ques.latitude, lon1: ques.longitude, lat2: locationManager.location?.coordinate.latitude ?? 0.0, lon2: locationManager.location?.coordinate.longitude ?? 0.0)
        let rest = DetailsVC()
        if(distance < ques.radius.doubleValue){
            rest.permissionAsq = true
        } else{
            rest.permissionAsq = false
        }
        rest.keyID = ques.user.uid
        rest.keyQuestion = ques.id
        rest.distance = distance
        rest.radius = ques.radius
        rest.countAnswer = ques.answerCount
        rest.nameUser = ques.user.name
        rest.time = ques.creationDate
        rest.titleQuestion = ques.titleQuestion
        rest.textQuestion = ques.textQuestion
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(rest, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
    }
}



private extension String {
    static let tableId = "TableViewCellReuseID"
    static let colId = "CollectionViewCellReuseID"
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .colId, for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        let user = searchUsers[indexPath.row]
        if user.avatarURL != "" {
            Storage.storage().loadUserProfileImage(url: user.avatarURL ?? "", completion: {(imageData) in
                let image = UIImage(data: imageData)
                cell.avatarView.image = image
            })
        }else{
            cell.avatarView.image = UIImage(named: "avatar")
        }
        cell.nameLabel.text = user.name
        cell.cityLabel.text = user.city
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rest = OtherProfileViewController()
        navigationController?.navigationBar.isHidden = false
        rest.user = searchUsers[indexPath.row]
        rest.currentUser = user
      
        self.navigationController?.pushViewController(rest, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 10, height: collectionView.frame.height/3)
    }
}

