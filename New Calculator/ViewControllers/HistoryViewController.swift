//
//  HistoryViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 14/03/25.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var didSelect: ((_ history: History) -> Void)?
        
    private var userDefaultsManager = UserDefaultsManager()
    private var historyList: [History] = []
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getHistory()
        addSubviews()
        setupBottomBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier)
        doneButton.addTarget(self, action: #selector(didPressDone), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(didPressEdit), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(didPressClear), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
        dismiss(animated: true)
    }
    
    @objc
    private func didPressEdit() {
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
    
    @objc
    private func didPressClear() {
        let actionSheet = UIAlertController(
            title: "All calculations will be deleted. This cannot be undone.",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let clear = UIAlertAction(title: "Clear History", style: .destructive) { [weak self] _ in
            self?.userDefaultsManager.clearHistory()
            self?.getHistory()
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(clear)
        
        present(actionSheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseIdentifier, for: indexPath) as! HistoryTableViewCell
        
        let history = historyList[indexPath.row]
        cell.configure(with: history)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            didSelect?(historyList[indexPath.row])
            dismiss(animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try userDefaultsManager.removeHistory(historyList[indexPath.row])
            } catch {
                print(error)
            }
            
            historyList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            getHistory()
        }
    }
    
    private func getHistory() {
        do {
            let result = try userDefaultsManager.getHistory()
            DispatchQueue.main.async { [weak self] in
                self?.historyList = result.reversed()
                
                if result.count > 0 {
                    self?.tableView.isHidden = false
                    self?.blurView.isHidden = false
                    self?.emptyView.isHidden = true
                } else {
                    self?.emptyView.isHidden = false
                    self?.tableView.isHidden = true
                    self?.blurView.isHidden = true
                }
                
                self?.setupBottomBar()
                self?.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
}
