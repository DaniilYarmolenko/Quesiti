//
//  otherProfileViewController.swift
//  Quesiti
//
//  Created by Дмитрий Голубев on 08.12.2021.
//

import UIKit
import Firebase

class OtherProfileViewController: UIViewController {
    
    var questionsOfUser: [QuestionModel] = []
    var isFol: Bool = false
    
    var user: User?{
        didSet{
            otherProfileView.nameLabel.text = user?.name
            otherProfileView.cityLabel.text = user?.city
            otherProfileView.aboutYouText.text = user?.aboutYou
            if let url = user?.avatarURL{
                if url != "" {
                    Storage.storage().loadUserProfileImage(url: url, completion: {(imageData) in
                        let image = UIImage(data: imageData)
                        self.otherProfileView.avatarView.image = image
                    })
                }
            }
        }
    }
    
    var currentUser: User?
    
    lazy var tableView: UITableView = {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var btnAddQuestion: UIButton = {
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
    
    lazy var emptyViewLabel: UILabel = {
        emptyViewLabel = UILabel()
        emptyViewLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyViewLabel.textAlignment = .center
        emptyViewLabel.numberOfLines = 2
        emptyViewLabel.font = .systemFont(ofSize: 20)
        
        return emptyViewLabel
    }()
    
    lazy var emptyView: UIView = {
        emptyView = UIView()
        emptyView.backgroundColor = .clear
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(emptyViewLabel)
        NSLayoutConstraint.activate([
            emptyViewLabel.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor),
            emptyViewLabel.topAnchor.constraint(equalTo: emptyView.topAnchor),
            emptyViewLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor),
            emptyViewLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor),
        ])
        
        return emptyView
    }()
    
    lazy var otherProfileView: OtherProfileView = {
        let otherProfileView = OtherProfileView()
        otherProfileView.nameLabel.text = user?.name
        otherProfileView.cityLabel.text = user?.city
        
        return otherProfileView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStats()
        navigationController?.navigationBar.isHidden = false
//        otherProfileView.checkFollow.addTarget(self, action: #selector(checkFollow), for: .touchUpInside)
        view.addSubview(otherProfileView)
        view.addSubview(tableView)
        view.addSubview(btnAddQuestion)
        
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: .tableId)
        tableView.dataSource = self
        tableView.delegate = self
        setupLayoutHomePageView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        fetchQuestionsOfUsers()
    }
    
    private func setupLayoutHomePageView(){
        otherProfileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otherProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            otherProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            otherProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            otherProfileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            
            tableView.topAnchor.constraint(equalTo: otherProfileView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            btnAddQuestion.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            btnAddQuestion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAddQuestion.widthAnchor.constraint(equalToConstant: 50),
            btnAddQuestion.heightAnchor.constraint(equalTo: btnAddQuestion.widthAnchor),
         ])
    }
    
    private func fetchQuestionsOfUsers(){
        guard let us = user else {return}
        //print(us.uid)
        Database.database().fetchAllPostsOfUser(withUID: us.uid) { questions, count in
            self.otherProfileView.questionsCount.text = String(questions.count)
            if questions.count != 0{
                self.questionsOfUser = questions
                self.tableView.reloadData()
            } else {
                self.tableView.reloadData()
                //self.checkEmpty = true
                self.addEmptyView(title: "Этот пользователь ещё не задавал вопросы")
            }
            self.tableView.reloadData()
        } withCancel: { _ in
            return
        }
    }
    
    private func addEmptyView(title: String){
        view.addSubview(emptyView)
        emptyViewLabel.text = title
        view.bringSubviewToFront(btnAddQuestion)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: otherProfileView.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupStats(){
        guard let us = user else {return}
        //print(isFol)
        Database.database().checkCountOfSubs(withUID: us.uid) { subs in
            self.otherProfileView.folCount.text = subs
        }
        Database.database().checkCountOfFolls(withUID: us.uid) { folls in
            self.otherProfileView.subsCount.text = folls
        }
        Database.database().isFollowingUser(withUID: us.uid) { bool in
            if bool{
                self.otherProfileView.followButton.backgroundColor = .systemPink
                self.otherProfileView.followButton.setTitle("Unfollow", for: .normal)
                self.isFol = true
            } else {
                self.isFol = false
            }
            self.otherProfileView.followButton.addTarget(self, action: #selector(self.follow), for: .touchUpInside)
        } withCancel: { _ in
            print("error")
        }
    }
    
    @objc
        private func didPullToRefresh() {
            tableView.refreshControl?.beginRefreshing()
            setupStats()
            fetchQuestionsOfUsers()
            tableView.refreshControl?.endRefreshing()
    }
    
    @objc func btnAddQuestionAction() {
        let addQuuestion: AddQuestionViewController = AddQuestionViewController()
        addQuuestion.modalPresentationStyle = .fullScreen
        self.present(addQuuestion, animated: true, completion: nil)
    }
}

extension OtherProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsOfUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .tableId, for: indexPath) as? TableViewCell else {
            fatalError()
        }
        let ques = questionsOfUser[indexPath.row]
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
//        let rest = DetailsVC()
//        self.navigationController?.pushViewController(rest, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
    }
    
    @objc func follow() {
        guard let us = user else {return}
        if !isFol{
            self.otherProfileView.followButton.backgroundColor = .systemPink
            self.otherProfileView.followButton.setTitle("Unfollow", for: .normal)
            Database.database().followUser(withUID: us.uid) { _ in }
            isFol = !isFol
        } else {
            self.otherProfileView.followButton.backgroundColor = .blue
            self.otherProfileView.followButton.setTitle("Follow", for: .normal)
            Database.database().unfollowUser(withUID: us.uid) { _ in }
            isFol = !isFol
        }
    }
}

private extension String {
    static let tableId = "TableViewCellReuseID"
}
