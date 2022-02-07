//
//  DetailsVC.swift
//  googlMapTutuorial2
//
//  Created by Muskan on 12/17/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import Firebase
import VerticalAlignmentLabel
import Presentr

class DetailsVC: UIViewController{
    
    var keyQuestion: String = ""
    var keyID: String = ""
    var distance: Double = 0.0
    var radius: Int = 200
    var permissionAsq: Bool = false
    var nameUserQuestionText: String = ""
    var titleQuestion: String = ""
    var textQuestion: String = ""
    var nameUser: String = ""
    var countAnswer: Int = 0
    var time: Date = Date(timeIntervalSince1970: 10)
    var answerQuestion: [Answer] = []

    //    var colorQuestion: UIColor = UIColor.red
    private var question = [QuestionModel]()
    private var answers = [Answer]()
    var user: User?{
        didSet{
            
            if let url = user?.avatarURL{
                if url != "" {
                    Storage.storage().loadUserProfileImage(url: url, completion: {(imageData) in
                        let image = UIImage(data: imageData)
                        self.imgView.setImage(image, for: .normal)
                    })
                }
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        fetchUser(idUser: keyID)
        tableView.register(AnswerViewTableCell.self, forCellReuseIdentifier: .tableId2)
        tableView.dataSource = self
        tableView.delegate = self
        //        var screenwidth = view.frame.width
        setupViewsContainers()
        if(textQuestion != ""){
            setupViewsWithTextQuestion()
        }
        if(countAnswer==0){
//            print("DEBAG \(countAnswer)")
            setupViewsWithoutAnswer()
        } else {
//            print("DEBAG \(countAnswer)")
            setupWithAnswer()
        }
        self.view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(refreshQuestion), name: Notification.Name("refreshQuestion"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkPostDelete), name: Notification.Name("checkPostDelete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(countAnswerPlus), name: Notification.Name("countAnswerPlus"), object: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshQuestion), for: .valueChanged)
        tableView.refreshControl = refreshControl
        setUpButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkRadius()
    }
    func loadData(){
        nameUserQuestion.text = nameUser
        firstTextQuestion.text = titleQuestion
        textQuestionTV.text = textQuestion
        timeText.text = time.timeAgoDisplay()
        
    }

    func checkRadius(){
        
        if(permissionAsq){
            titleButton.text = "answer"
            btnAnswerQuestion.layer.opacity = 1
        }else{
            titleButton.text = "out of radius"
            
        }
        if(keyQuestion != "" && keyID != ""){
            fetchQuestion(idUser: keyQuestion, idQuestion: keyID)
            fetchAllAnswer(idQuestion: keyQuestion)
        }
    }
    @objc func countAnswerPlus() {
        countAnswer+=1
        if(countAnswer==1){
            containerButton.removeFromSuperview()
            emptyContainer.removeFromSuperview()
            setupWithAnswer()
            setUpButton()
        }
    }
    
    func setupWithAnswer(){
        if(textQuestion == ""){
            view.addSubview(tableView)
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20).isActive=true
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive=true
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive=true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        }else{
            view.addSubview(tableView)
            tableView.topAnchor.constraint(equalTo: textQuestionTV.bottomAnchor, constant: 10).isActive=true
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive=true
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive=true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        }
    }
    
    func setupViewsWithoutAnswer(){
        if(textQuestion == ""){
            view.addSubview(emptyContainer)
            emptyContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20).isActive=true
            emptyContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive=true
            emptyContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive=true
            emptyContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        } else{
            view.addSubview(emptyContainer)
            emptyContainer.topAnchor.constraint(equalTo: textQuestionTV.bottomAnchor, constant: 10).isActive=true
            emptyContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive=true
            emptyContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive=true
            emptyContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        }
    }
    
    func setupViewsContainers() {
        view.addSubview(containerView)
        containerView.addSubview(imgView)
        containerView.addSubview(nameUserQuestion)
        containerView.addSubview(timeText)
        containerView.addSubview(firstTextQuestion)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            imgView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            imgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            imgView.widthAnchor.constraint(equalToConstant: 100),
            imgView.heightAnchor.constraint(equalToConstant: 100),
            //imgView.image = passedData.image
            nameUserQuestion.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 5),
            nameUserQuestion.topAnchor.constraint(equalTo: imgView.topAnchor, constant: -2),
            nameUserQuestion.heightAnchor.constraint(equalToConstant: 30),
            
            timeText.leftAnchor.constraint(equalTo: nameUserQuestion.rightAnchor, constant: 5),
            timeText.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            timeText.topAnchor.constraint(equalTo: nameUserQuestion.topAnchor),
            timeText.bottomAnchor.constraint(equalTo: nameUserQuestion.bottomAnchor),
            
            firstTextQuestion.topAnchor.constraint(equalTo: nameUserQuestion.bottomAnchor),
            firstTextQuestion.leftAnchor.constraint(equalTo: nameUserQuestion.leftAnchor, constant: 5),
            firstTextQuestion.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            firstTextQuestion.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10),
        ])
    }
    func setupViewsWithTextQuestion(){
        view.addSubview(textQuestionTV)
        textQuestionTV.isEditable = false
        textQuestionTV.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15).isActive=true
        textQuestionTV.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10).isActive=true
        textQuestionTV.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15).isActive=true
        textQuestionTV.heightAnchor.constraint(equalToConstant: 120).isActive=true
    }
    func setUpButton(){
        view.addSubview(containerButton)
        containerButton.addSubview(btnAnswerQuestion)
        containerButton.addSubview(titleButton)
        NSLayoutConstraint.activate([
            containerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -74),
            containerButton.widthAnchor.constraint(equalToConstant: 72),
            containerButton.heightAnchor.constraint(equalTo: containerButton.widthAnchor),
            
            btnAnswerQuestion.topAnchor.constraint(equalTo: containerButton.topAnchor),
            btnAnswerQuestion.leftAnchor.constraint(equalTo: containerButton.leftAnchor),
            btnAnswerQuestion.rightAnchor.constraint(equalTo: containerButton.rightAnchor),
            btnAnswerQuestion.bottomAnchor.constraint(equalTo: containerButton.bottomAnchor),
            
            titleButton.centerYAnchor.constraint(equalTo: containerButton.centerYAnchor),
            titleButton.leftAnchor.constraint(equalTo: containerButton.leftAnchor),
            titleButton.rightAnchor.constraint(equalTo: containerButton.rightAnchor)])
    }
    
    let containerView: UIView = {
        let v=UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let textQuestionTV: UITextView = {
        let textQuestion = UITextView()
        textQuestion.text = "ggggggggggggggg"
        //        containerTitle.layer.shadowColor = UIColor.black.cgColor
        //        containerTitle.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        //        containerTitle.layer.shadowRadius = 2.0
        //        containerTitle.layer.shadowOpacity = 0.5
        textQuestion.textAlignment = .left
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 1.2
        let attributes = [NSAttributedString.Key.paragraphStyle: style ]
        textQuestion.typingAttributes = attributes
        textQuestion.font = UIFont(name: "Kurale-Regular", size: 15)
        textQuestion.isEditable = false
        textQuestion.layer.masksToBounds = true
        textQuestion.usesStandardTextScaling = true
        textQuestion.translatesAutoresizingMaskIntoConstraints=false
        return textQuestion
    }()
    
    //    lazy var containerShadow: UIView = {
    //        containerShadow = UIView()
    //        //        containerTitle.layer.cornerRadius = 20
    //        var rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: containerShadow.frame.width, height: containerShadow.frame.height))
    //        var path = UIBezierPath(rect: rect);
    //        containerShadow.layer.shadowPath = path.cgPath
    //        containerShadow.layer.masksToBounds = false
    //        containerShadow.translatesAutoresizingMaskIntoConstraints=false
    //        return containerShadow
    //    }()
    let timeText: UILabel = {
        let text = UILabel()
        text.textColor = ThemeColors.secondaryColor
        text.font = UIFont(name: "Kurale-Regular", size: 16)
        text.text = ""
        text.translatesAutoresizingMaskIntoConstraints=false
        return text
    }()
    let nameUserQuestion: UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 15)
        text.translatesAutoresizingMaskIntoConstraints=false
        return text
    }()
    let imgView: UIButton = {
        let v=UIButton()
        v.setImage(UIImage(named: "avatar"), for: .normal)
        v.addTarget(self, action: #selector(imgTap(_:)), for: .touchUpInside)
        v.layer.cornerRadius = 25
        v.contentMode = .scaleAspectFill
        v.clipsToBounds=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    let firstTextQuestion: VerticalAlignmentLabel = {
        let text = VerticalAlignmentLabel()
        text.text = "Здеесь будет первичный вопрос"
        text.verticalTextAlignment = .top
        text.textAlignment = .left
        text.font = UIFont(name: "Kurale-Regular", size: 17)
        text.numberOfLines = 0
        text.sizeToFit()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
//    let UserQuestion: UILabel = {
//        let text = UILabel()
//        text.text = "Не загрузилось"
//        text.font = .systemFont(ofSize: 15)
//        text.textAlignment = .left
//        text.translatesAutoresizingMaskIntoConstraints = false
//        return text
//    }()
    
    let textQuestionLabel: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font = UIFont(name: "Kurale-Regular", size: 12)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblDescription: UILabel = {
        let lbl=UILabel()
        lbl.text = "Description"
        lbl.numberOfLines = 0
        lbl.font=UIFont.systemFont(ofSize: 20)
        lbl.textColor = UIColor.gray
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnAnswerQuestion: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        //        let config = UIImage.SymbolConfiguration(textStyle: .)
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        btn.clipsToBounds=true
        btn.tintColor = UIColor.white
        let squarePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 72, height: 72), byRoundingCorners:.allCorners, cornerRadii: CGSize(width: 20.0, height: 20.0))
        let squareLayer = CAShapeLayer()
        //        squarePath.move(to: CGPoint(x: 39, y: 0))
        //
        //        squarePath.addLine(to: CGPoint(x: 79, y: 39))
        //        squarePath.addLine(to: CGPoint(x: 39, y: 79))
        //        squarePath.addLine(to: CGPoint(x: 0, y: 39))
        //        squarePath.addLine(to: CGPoint(x: 39, y: 0))
        //        squarePath.addLine(to: CGPoint(x: 100, y: 0))
        //        squarePath.close()
        squareLayer.path = squarePath.cgPath
        //        squareLayer.transform = CATransform3DMakeRotation(CGFloat(45*Double.pi/180), 0, -49, 1)
        squareLayer.fillColor = ThemeColors.mainColor.cgColor
        btn.layer.addSublayer(squareLayer)
        btn.clipsToBounds=true
        btn.addTarget(self, action: #selector(btnAnswer(_:)), for: .touchUpInside)
        btn.layer.opacity = 0.3
        
        btn.isEnabled = true
        btn.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    let titleButton: UILabel = {
        let lbl=UILabel()
        lbl.text = "out of radius"
        lbl.numberOfLines = 0
        lbl.font=UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    lazy var tableView: UITableView = {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let emptyContainer: UILabel = {
        let text = UILabel()
        text.text = "Ответов пока нет. Будьте первым!"
        text.textAlignment = .center
        text.numberOfLines = 2
        text.font = .systemFont(ofSize: 20)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let containerButton: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    @objc func btnAnswer(_ sender: Any){
        if(permissionAsq){
            let addQuuestion: AddAnswerViewController = AddAnswerViewController()
            addQuuestion.questionID = keyQuestion
            addQuuestion.userQuestionID = keyID
            let presenter = Presentr(presentationType: .alert)
            presenter.presentationType = .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.5), center: .center) // custom(centerPoint: CGPoint(x: self.view.frame.width/2, y: 300)
            presenter.roundCorners = true
            presenter.cornerRadius = 30
            presenter.transitionType = .coverVerticalFromTop
            presenter.keyboardTranslationType = .moveUp
            presenter.dismissAnimated = true
            presenter.dismissTransitionType = .coverVertical
            addQuuestion.answerCount = countAnswer
            customPresentViewController(presenter, viewController: addQuuestion, animated: true, completion: nil)
        } else{
            let alert = UIAlertController(title: "Вы находитеть вне радиуса", message: "Radius = \(radius), distance = \(String(format: "%.1f", distance))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc private func didPullToRefresh() {
        tableView.refreshControl?.beginRefreshing()
        tableView.refreshControl?.endRefreshing()
    }
    private func fetchAllAnswer(idQuestion: String){
        Database.database().fetchAnswerForQuestion(withId: idQuestion, completion: { (answers) in
            self.answers = answers
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }) { (err) in
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func refreshQuestion() {
        question.removeAll()
        answers.removeAll()
        fetchQuestion(idUser: keyQuestion, idQuestion: keyID)
        fetchAllAnswer(idQuestion: keyQuestion)
    }
    @objc func imgTap(_ : Any){
        let id = Auth.auth().currentUser?.uid
        if(keyID == id){
            return
        }
        let rest = OtherProfileViewController()
//        print("user")
        rest.user = user
        self.navigationController?.pushViewController(rest, animated: false)
    }
    @objc func checkPostDelete(){
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func imgTapCell(_ sender: ButtonWithUser){
        let id = Auth.auth().currentUser?.uid
        if(sender.user == nil){
            return
        }
        if(sender.user!.uid == id){
            return
        }
//        print("\(sender.user!.uid)")
        let rest = OtherProfileViewController()
        rest.user = sender.user!
      
        self.navigationController?.pushViewController(rest, animated: false)
    }
    //    @objc func imgAnswerTap(_ sender: Any){
    //       let rest = OtherProfileViewController()
    //
    //        rest.currentUser = user
    //    }
    
    private func fetchQuestion(idUser: String, idQuestion: String){
        Database.database().fetchPost(withUID: idUser, postId: idQuestion, completion: { (question) in
            self.question.append(question)
            
        }, withCancel: { (err) in
            
        })
        
    }
        private func fetchUser(idUser: String){
            Database.database().fetchUser(withUID: idUser) { (user) in
                self.user = user
            }
        }
}

extension DetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers = answers.sorted {(ans1: Answer, ans2: Answer) in
            ans1.creationDate > ans2.creationDate
        }
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .tableId2, for: indexPath) as? AnswerViewTableCell else {
            print("OSHIBKA TUT \(String.tableId2)")
            fatalError()
        }
        let answer = answers[indexPath.row]
        answerQuestion.append(answer)
        if (answer.user.avatarURL != "" && answer.anonimState == false){
            Storage.storage().loadUserProfileImage(url: answer.user.avatarURL ?? "", completion: {(imageData) in
                let image = UIImage(data: imageData)
                cell.avatarView.setImage(image, for: .normal)
                
            })
        }else{
            cell.avatarView.setImage(UIImage(named: "avatar"), for: .normal)
        }
        if(answer.anonimState == false){
            cell.nameLabel.text = answer.user.name
            cell.avatarView.addTarget(self, action: #selector(imgTapCell(_:)), for: .touchUpInside)
        } else{
            cell.avatarView.setImage(UIImage(named: "anonim"), for: .normal)
            cell.nameLabel.text = "Anonim"
        }
        cell.questionLabel.text = answer.text
        cell.questionLabel.setLineHeight(lineHeight: 0.85)
        cell.avatarView.user = answer.user
        cell.dateLabel.text = answer.creationDate.timeAgoDisplay()
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

private extension String {
    static let tableId2 = "TableViewCellReuseID2"
}

class ButtonWithUser: UIButton{
    var user: User?
}
