//
//  HistoryViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 14/03/25.
//

import UIKit

protocol HistoryDisplayLogic: AnyObject {
    func displayFetchedHistory(list: [HistoryModels.History])
    func returnAndDismiss(history: HistoryModels.History)
    func deleteAndUpdate(at indexPath: IndexPath)
    func changeTableEditMode()
    func dismiss()
    func updateTableView()
}

class HistoryViewController: UIViewController {
    
    var onSelect: ((_ history: HistoryModels.History) -> Void)?
    
    var interactor: HistoryBusinessLogic?
    private var router: HistoryRoutingLogic?
    
    private var historyList: [HistoryModels.History] = []
    private let emptyView = HistoryEmptyView()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.backgroundColor = .secondarySystemBackground
        return table
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVIP()
        interactor?.fetchHistory()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            HistoryTableViewCell.self,
            forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier
        )
        
        setupBottomBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(didPressDone), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(didPressEdit), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(didPressClear), for: .touchUpInside)
    }
    
    private func setupVIP() {
        let viewController = self
        let interactor = HistoryInteractor()
        let presenter = HistoryPresenter()
        let router = HistoryRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        
        self.interactor = interactor
        self.router = router
    }
    
    private func setupBottomBar() {
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.heightAnchor.constraint(equalToConstant: 90)
        ])
        view.bringSubviewToFront(blurView)
        
        blurView.contentView.addSubview(editButton)
        blurView.contentView.addSubview(clearButton)
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 10),
            editButton.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 20),
            
            clearButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 10),
            clearButton.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc
    private func didPressDone() {
        interactor?.didPressDone()
    }
    
    @objc
    private func didPressEdit() {
        interactor?.changeTableEditMode()
    }
    
    @objc
    private func didPressClear() {
        let actionSheet = UIAlertController(
            title: "All calculations will be deleted. This cannot be undone.",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let clear = UIAlertAction(title: "Clear History", style: .destructive) { [weak self] _ in
            self?.interactor?.clearHistory()
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(clear)
        
        present(actionSheet, animated: true)
    }
}

//MARK: - HistoryDisplayLogic
extension HistoryViewController: HistoryDisplayLogic {
    func displayFetchedHistory(list: [HistoryModels.History]) {
        historyList = list
        if list.count > 0 {
            tableView.isHidden = false
            blurView.isHidden = false
            emptyView.isHidden = true
        } else {
            emptyView.isHidden = false
            tableView.isHidden = true
            blurView.isHidden = true
        }
        tableView.reloadData()
    }
    
    func returnAndDismiss(history: HistoryModels.History) {
        onSelect?(history)
        router?.dismiss()
    }
    
    func deleteAndUpdate(at indexPath: IndexPath) {
        historyList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        interactor?.fetchHistory()
    }
    
    func dismiss() {
        router?.dismiss()
    }
    
    func changeTableEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            editButton.setTitle("Done", for: .normal)
            clearButton.isEnabled = false
            doneButton.isHidden = true
        } else {
            editButton.setTitle("Edit", for: .normal)
            clearButton.isEnabled = true
            doneButton.isHidden = false
        }
    }
    
    func updateTableView() {
        interactor?.fetchHistory()
    }
}

//MARK: - TableView Delegate and DataSource
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! HistoryTableViewCell
        
        let model = historyList[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !tableView.isEditing {
            let model = historyList[indexPath.row]
            interactor?.selectHistory(model: model)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        interactor?.deleteHistory(at: indexPath)
    }
}
