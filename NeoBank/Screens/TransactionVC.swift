//
//  TransactionVC.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit
import CoreData

class TransactionVC: UIViewController {
  
  private let searchController = UISearchController()
  private let titleLabel = NBTitleLabel(text: "All Transactions", textAlignment: .left, fontSize: 20)
  private var tableView = UITableView()
  private let buttonStackView = UIStackView()
  
  private let dateButton = FilterButton(withTitle: "Date")
  private let amountButton = FilterButton(withTitle: "Amount")
  private let currencyButton = FilterButton(withTitle: "Currency")
  private let transactionsButton = FilterButton(withTitle: "Transactions")
  private let clearButton = FilterButton(withTitle: "Clear")

  
  var accountId: Int?
  var currentBalance: Double?
  var transactions: [Transaction] = []
  var filteredTransactions: [Transaction] = []
  var originalTransactions: [Transaction] = []
  
  var transactionDirectionFilter: TransactionDirection = .outgoing
  var sortingOrder: SortingOrder = .newestToOldest
  
  var userCurrency: String?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTransactionVC()
    configureSearchController()
    configureTitleLabel()
    configureButtonStack()
    configureTableView()
    clearButton.setImageWithTitle(image: UIImage(systemName: "x.circle"))
  }
  
  
  private func configureTransactionVC() {
    view.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
    tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let accountId = accountId { loadTransactions(forUserID: accountId ) }
  }
  
  @objc func buttonTapped(_ sender: UIButton) {
    
    if let buttonTitle = sender.titleLabel?.text {
      
      switch buttonTitle {
      case "Date":
        sortingOrder = sortingOrder == .newestToOldest ? .oldestToNewest : .newestToOldest
        sortTransactions()
      case "Amount":
        sortingOrder = sortingOrder == .smallestToBiggest ? .biggestToSmallest : .smallestToBiggest
        sortTransactions()
      case "Transactions":
        transactionDirectionFilter = transactionDirectionFilter == .outgoing ? .incoming : .outgoing
        filterTransactionsByDirection()
      default:
        print("Unknown button tapped")
      }

      tableView.reloadData()
    }
  }

  @objc private func clearFiltersTapped() {

    sortingOrder = .newestToOldest
    transactions = originalTransactions
    tableView.reloadData()
  }
  
  
  private func sortTransactions() {

    transactions = originalTransactions
    
    var sortedTransactions: [Transaction]
    
    switch sortingOrder {

    case .newestToOldest:
      sortedTransactions = transactions.sorted { transaction1, transaction2 in
        let date1 = Date(timeIntervalSince1970: TimeInterval(transaction1.transactionTime))
        let date2 = Date(timeIntervalSince1970: TimeInterval(transaction2.transactionTime))
        return date1 > date2
      }
    case .oldestToNewest:
      sortedTransactions = transactions.sorted { transaction1, transaction2 in
        let date1 = Date(timeIntervalSince1970: TimeInterval(transaction1.transactionTime))
        let date2 = Date(timeIntervalSince1970: TimeInterval(transaction2.transactionTime))
        return date1 < date2
      }
    case .smallestToBiggest:
      sortedTransactions = transactions.sorted(by: { $0.amount < $1.amount })
    case .biggestToSmallest:
      sortedTransactions = transactions.sorted(by: { $0.amount > $1.amount })
    }
    
    transactions = sortedTransactions
  }


  private func filterTransactionsByDirection() {
    if transactionDirectionFilter == .outgoing {
      transactions = originalTransactions.filter { $0.sendingAccountId == accountId }
    } else if transactionDirectionFilter == .incoming {
      transactions = originalTransactions.filter { $0.receivingAccountId == accountId }
    }
  }

  
  private func loadTransactions(forUserID userID: Int) {
    
    Task.init {
      do {
        let fetchedTransactions = try await NetworkManager.shared.fetchTransactions(forUserID: userID)
        
        DispatchQueue.main.async {
          self.originalTransactions = fetchedTransactions

          // Issaugo transactionus i Core Data
          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

          for transaction in fetchedTransactions {
            let transactionEntity = TransactionEntity(context: context)

            transactionEntity.sendingAccountId = Int64(transaction.sendingAccountId)
            transactionEntity.receivingAccountId = Int64(transaction.receivingAccountId)
            transactionEntity.receiverPhoneNumber = transaction.receiverPhoneNumber
            transactionEntity.comment = transaction.comment
            transactionEntity.amount = transaction.amount
            transactionEntity.transactionTime = Double(transaction.transactionTime)
          }

          // Issaugo context
          (UIApplication.shared.delegate as! AppDelegate).saveContext()


          self.fetchTransactionsFromCoreData()
          self.filterTransactionsByDirection()
          self.sortTransactions()
          self.tableView.reloadData()
        }
      } catch {
        print("Error fetching transactions: \(error)")
        
      }
    }
  }
  
  
  private func filterTransactions(for searchText: String) {
    filteredTransactions = transactions.filter { transaction in
      return transaction.receiverPhoneNumber.contains(searchText) || transaction.comment.lowercased().contains(searchText.lowercased())
    }
    tableView.reloadData()
  }


  private func fetchTransactionsFromCoreData() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")

    do {
      let fetchedTransactions = try context.fetch(fetchRequest)

      //Isprintina transanctionus is core data
      for transaction in fetchedTransactions {
        print("Sending Account ID: \(transaction.sendingAccountId)")
        print("Receiving Account ID: \(transaction.receivingAccountId)")
        print("Receiver Phone Number: \(transaction.receiverPhoneNumber ?? "")")
        print("Comment: \(transaction.comment ?? "")")
        print("Amount: \(transaction.amount)")
        print("Transaction Time: \(transaction.transactionTime)")
        print("------")
      }
    } catch {
      print("Error fetching transactions from Core Data: \(error)")
    }
  }

  
  private func configureSearchController() {
    
    searchController.searchResultsUpdater  = self
    searchController.searchBar.placeholder = "Search for a username"
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    
  }
  
  
  private func configureTitleLabel() {

    view.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
      titleLabel.heightAnchor.constraint(equalToConstant: 25)
    ])
  }
  
  
  private func configureButtonStack() {

    view.addSubview(buttonStackView)
    buttonStackView.axis = .horizontal
    buttonStackView.distribution = .fillEqually
    buttonStackView.spacing = 8
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    
    buttonStackView.addArrangedSubview(dateButton)
    buttonStackView.addArrangedSubview(amountButton)
    buttonStackView.addArrangedSubview(transactionsButton)
    buttonStackView.addArrangedSubview(clearButton)

    
    dateButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    amountButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    transactionsButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    clearButton.addTarget(self, action: #selector(clearFiltersTapped), for: .touchUpInside)
    
    
    NSLayoutConstraint.activate([
      buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      buttonStackView.heightAnchor.constraint(equalToConstant: 40)
    ])
  }

  
  private func configureTableView() {
    
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
    
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 8),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
  }
}


extension TransactionVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.isActive && !searchController.searchBar.text!.isEmpty {
      return filteredTransactions.count
    } else {
      return transactions.count
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
    
    let transaction: Transaction
    if searchController.isActive && !searchController.searchBar.text!.isEmpty {
      transaction = filteredTransactions[indexPath.row]
    } else {
      transaction = transactions[indexPath.row]
    }
    
    
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


extension TransactionVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}


extension TransactionVC: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
    filterTransactions(for: searchText)
  }
}
