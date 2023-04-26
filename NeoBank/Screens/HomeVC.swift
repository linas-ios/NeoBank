//
//  HomeVC.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class HomeVC: UIViewController {


  let avatarImage = BNAvatarImageView(frame: .zero)
  let userIdLabel = NBTitleLabel(text: "Hello", textAlignment: .left, fontSize: 20)
  let userSecondTitleLabel = NBSecondTitleLabel(text: "Have a nice day!", textAlignment: .left, fontSize: 12)

  let cardContainerView = ContainerView()
  let cardImage = UIImageView()
  let cardBalanceLabel = NBBodyLabel(text: "Balance ", textAlignment: .left, fontSize: 12)
  let currentBalanceLabel = NBTitleLabel(text: "€0.0", textAlignment: .left, fontSize: 25)

  let operationsLabel = NBSecondTitleLabel(text: "Quick Operations", textAlignment: .left, fontSize: 15)
  var hStack = UIStackView()
  let topUpContainerView = ContainerView()
  let topUpMoneyButton = UIButton()
  let topUpImage = UIImageView()
  let topUpMoneyTitle = NBSecondTitleLabel(text: "Top Up", textAlignment: .center, fontSize: 12)

  let sendContainerView = ContainerView()
  let sendMoneyButton = UIButton()
  let sendImage = UIImageView()
  let sendMoneyTitle = NBSecondTitleLabel(text: "Send", textAlignment: .center, fontSize: 12)

  let transactionsLabel = NBSecondTitleLabel(text: "Transactions", textAlignment: .left, fontSize: 15)

  let tableView = UITableView()

  var currentBalance: Double?
  var accountId: Int?
  var tokenExpirationTimer: Timer?
  var transactions: [Transaction] = []


  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubviews(avatarImage, userIdLabel, userSecondTitleLabel, cardContainerView, cardImage, cardBalanceLabel, currentBalanceLabel, operationsLabel, hStack, topUpContainerView, topUpMoneyButton, topUpImage, sendContainerView, sendMoneyButton, sendImage, transactionsLabel, tableView)

    topUpContainerView.addSubview(topUpMoneyTitle)
    sendContainerView.addSubview(sendMoneyTitle)
    configureBalance()
    configureHomeVC()
    configureAvatarImage()
    configureUserId()
    configureUserSecondTitleLabel()
    configureCard()

    configureOperationsLabel()

    configureHStack()
    configureTopUpContainerView()
    configureSendUpContainerView()

    configureTransactionsLabel()
    configureTableView()

    callActionAddMoney()
    callActionSendMoney()
  }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startTokenExpirationTimer()
    if let accountId = accountId { loadTransactions(forUserID: accountId ) }
  }

  func callActionAddMoney() {
    topUpMoneyButton.addTarget(self, action: #selector(topUpMoneyButtonTapped), for: .touchUpInside)
  }

  func callActionSendMoney() {
    sendMoneyButton.addTarget(self, action: #selector(sendMoneyButtonTapped), for: .touchUpInside)
  }


  @objc func topUpMoneyButtonTapped() {
    let topUpMoneyVC = TopUpMoneyVC()

    topUpMoneyVC.modalPresentationStyle = .pageSheet
    topUpMoneyVC.sheetPresentationController?.detents = [.medium()]
    topUpMoneyVC.sheetPresentationController?.prefersGrabberVisible = true

    topUpMoneyVC.completion = { [weak self] newBalance in
      self?.currentBalance = newBalance
      self?.configureBalance()
    }

    present(topUpMoneyVC, animated: true)
  }


  @objc func sendMoneyButtonTapped() {
    let sendMoneyVC = SendVC()

    sendMoneyVC.senderAccountId = accountId
    sendMoneyVC.senderBalance = currentBalance
    sendMoneyVC.accessToken = AuthenticationManager.shared.getToken().accessToken

    sendMoneyVC.modalPresentationStyle = .pageSheet
    sendMoneyVC.sheetPresentationController?.detents = [.custom(resolver: { context in return 500 })]
    sendMoneyVC.sheetPresentationController?.prefersGrabberVisible = true

    sendMoneyVC.completion = { [weak self] newBalance in
      self?.currentBalance = newBalance
      self?.configureBalance()
      self?.loadTransactions(forUserID: self?.accountId ?? 0)
      self?.tableView.reloadData()
    }
    present(sendMoneyVC, animated: true)
  }



  private func loadTransactions(forUserID userID: Int) {

    Task.init {
      do {
        let fetchedTransactions = try await NetworkManager.shared.fetchTransactions(forUserID: userID)

        DispatchQueue.main.async {
          self.transactions = fetchedTransactions.sorted(by: { transaction1, transaction2 in
            let date1 = Date(timeIntervalSince1970: TimeInterval(transaction1.transactionTime))
            let date2 = Date(timeIntervalSince1970: TimeInterval(transaction2.transactionTime))
            return date1 > date2
          })

          self.tableView.reloadData()
        }
      } catch {
        print("Error fetching transactions: \(error)")
      }
    }
  }


  func startTokenExpirationTimer() {
    tokenExpirationTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
      //accessToken - if API calls that require the access token for authorization, need to use accessToken instead _
      let (_, validUntil) = AuthenticationManager.shared.getToken()
      guard let validUntil = validUntil, !AuthenticationManager.shared.isTokenExpired(validUntil: validUntil) else {
        self?.stopTokenExpirationTimer()
        AuthenticationManager.shared.clearToken()

        // necessary actions to log out the user, such as navigating to the login screen.

        return
      }
    }
  }


  func stopTokenExpirationTimer() {
    tokenExpirationTimer?.invalidate()
    tokenExpirationTimer = nil
  }


  private func configureBalance() {
    if let currentBalance = currentBalance {
      currentBalanceLabel.text = String(format: "€%.2f", currentBalance)
    } else {
      cardBalanceLabel.text = "Balance not available"
    }
  }


  func configureHomeVC() {
    view.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
    tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
  }

  private func configureAvatarImage() {

    avatarImage.image = Images.placeholder
    avatarImage.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([

      avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
      avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
      avatarImage.widthAnchor.constraint(equalToConstant: 50),
      avatarImage.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  private func configureUserId() {

    NSLayoutConstraint.activate([
      userIdLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor),
      userIdLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),
      userIdLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
    ])
  }

  private func configureUserSecondTitleLabel() {

    NSLayoutConstraint.activate([
      userSecondTitleLabel.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 5),
      userSecondTitleLabel.leadingAnchor.constraint(equalTo: userIdLabel.leadingAnchor),
      userSecondTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
    ])
  }


  func configureCard() {

    cardImage.image = Images.card
    cardImage.contentMode = .scaleAspectFill
    cardImage.translatesAutoresizingMaskIntoConstraints = false
    cardBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
    currentBalanceLabel.translatesAutoresizingMaskIntoConstraints = false


    NSLayoutConstraint.activate([
      cardImage.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 45),
      cardImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cardImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cardImage.heightAnchor.constraint(equalToConstant: 200)
    ])

    NSLayoutConstraint.activate([
      cardBalanceLabel.topAnchor.constraint(equalTo: cardImage.topAnchor, constant: -5),
      cardBalanceLabel.leadingAnchor.constraint(equalTo: cardImage.leadingAnchor, constant: 25),
      cardBalanceLabel.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: -20),
      cardBalanceLabel.heightAnchor.constraint(equalToConstant: 12)
    ])

    NSLayoutConstraint.activate([
      currentBalanceLabel.topAnchor.constraint(equalTo: cardBalanceLabel.bottomAnchor, constant: 2),
      currentBalanceLabel.leadingAnchor.constraint(equalTo: cardImage.leadingAnchor, constant: 25),
      currentBalanceLabel.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: -20),

    ])
  }

  func configureOperationsLabel() {

    operationsLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      operationsLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 20),
      operationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      operationsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      operationsLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }


  private func configureHStack() {
    hStack = UIStackView(arrangedSubviews: [topUpContainerView, sendContainerView])
    hStack.axis = .horizontal
    hStack.distribution = .fillEqually
    hStack.spacing = 30
    hStack.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(hStack)

    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: operationsLabel.bottomAnchor, constant: 20),
      hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      hStack.heightAnchor.constraint(equalToConstant: 80)
    ])
  }

  
  private func configureTopUpContainerView() {

    topUpContainerView.addSubview(topUpImage)
    topUpContainerView.addSubview(topUpMoneyButton)

    topUpImage.image = UIImage(systemName: "plus")
    topUpImage.contentMode = .scaleAspectFit
    topUpImage.tintColor = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1.0)
    topUpImage.translatesAutoresizingMaskIntoConstraints = false

    topUpMoneyButton.setTitle("", for: .normal)
    topUpMoneyButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      topUpImage.centerXAnchor.constraint(equalTo: topUpContainerView.centerXAnchor),
      topUpImage.centerYAnchor.constraint(equalTo: topUpContainerView.centerYAnchor),

      topUpMoneyButton.topAnchor.constraint(equalTo: topUpImage.topAnchor, constant: 1),
      topUpMoneyButton.leadingAnchor.constraint(equalTo: topUpImage.leadingAnchor, constant: 1),
      topUpMoneyButton.trailingAnchor.constraint(equalTo: topUpImage.trailingAnchor, constant: 1),
      topUpMoneyButton.bottomAnchor.constraint(equalTo: topUpImage.bottomAnchor, constant: 1),

      topUpMoneyTitle.topAnchor.constraint(equalTo: topUpMoneyButton.bottomAnchor, constant: 5),
      topUpMoneyTitle.leadingAnchor.constraint(equalTo: topUpContainerView.leadingAnchor),
      topUpMoneyTitle.trailingAnchor.constraint(equalTo: topUpContainerView.trailingAnchor),
    ])
  }

  private func configureSendUpContainerView() {

    sendContainerView.addSubview(sendImage)
    sendContainerView.addSubview(sendMoneyButton)

    sendImage.image = UIImage(systemName: "arrow.right.to.line")
    sendImage.contentMode = .scaleAspectFit
    sendImage.tintColor = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1.0)
    sendImage.translatesAutoresizingMaskIntoConstraints = false

    sendMoneyButton.setTitle("", for: .normal)
    sendMoneyButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      sendImage.centerXAnchor.constraint(equalTo: sendContainerView.centerXAnchor),
      sendImage.centerYAnchor.constraint(equalTo: sendContainerView.centerYAnchor),

      sendMoneyButton.topAnchor.constraint(equalTo: sendImage.topAnchor),
      sendMoneyButton.leadingAnchor.constraint(equalTo: sendImage.leadingAnchor),
      sendMoneyButton.trailingAnchor.constraint(equalTo: sendImage.trailingAnchor),
      sendMoneyButton.bottomAnchor.constraint(equalTo: sendImage.bottomAnchor),

      sendMoneyTitle.topAnchor.constraint(equalTo: sendMoneyButton.bottomAnchor, constant: 5),
      sendMoneyTitle.leadingAnchor.constraint(equalTo: sendContainerView.leadingAnchor),
      sendMoneyTitle.trailingAnchor.constraint(equalTo: sendContainerView.trailingAnchor),
    ])
  }

  private func configureTransactionsLabel() {

    transactionsLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      transactionsLabel.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 20),
      transactionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      transactionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])
  }


  func configureTableView() {

    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(LastTransactionsCell.self, forCellReuseIdentifier: LastTransactionsCell.reuseIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 20),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return min(transactions.count, 5)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell

    let transaction = transactions[indexPath.row]

    cell.receiverNumberLabel.text = "Number: \(transaction.receiverPhoneNumber)"
    cell.commentLabel.text = "Comment: \(transaction.comment)"

    let date = Date(timeIntervalSince1970: TimeInterval(transaction.transactionTime / 1000 ))
    cell.dateLabel.text = "Date:\(DateFormatter.customDateFormatter.string(from: date))"

    if transaction.sendingAccountId == accountId {
      cell.amountLabel.text = "€\(transaction.amount)"
      cell.circleImageView.image = UIImage(named: "send")
      cell.amountLabel.textColor = .red
    } else if transaction.receivingAccountId == accountId {
      cell.amountLabel.text = "€\(transaction.amount)"
      cell.circleImageView.image = UIImage(named: "get")
      cell.amountLabel.textColor = .green
    }

    return cell
  }
}









