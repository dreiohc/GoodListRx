//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Myron Dulay on 4/15/21.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "TaskTableViewCell"

class TaskListViewController: UIViewController {
  
  // MARK: - Properties
  
  private let tasks = BehaviorRelay<[Task]>(value: [])
  
  private var filteredTasks = [Task]() {
    didSet { tableView.reloadData() }
  }
  
  let disposeBag = DisposeBag()
  
  @IBOutlet weak var prioritySegmenetedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navC = segue.destination as? UINavigationController,
          let addTVC = navC.viewControllers.first as? AddTaskViewController else {
      fatalError()
    }
    
    addTVC.taskSubjectObservable
      .subscribe(onNext: { [unowned self] task in
        
        let priority = Priority(rawValue: self.prioritySegmenetedControl.selectedSegmentIndex - 1)
    
        var existingTasks = tasks.value // append tasks
        existingTasks.append(task)
        self.tasks.accept(existingTasks)
        
        self.filterTasks(by: priority) // filtered all tasks
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - API
  
  // MARK: - Actions
  
  @IBAction func priorityValueChanges(segmentedControl: UISegmentedControl) {
    let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
    filterTasks(by: priority)
  }
  
  
  // MARK: - Helpers
  
  private func filterTasks(by priority: Priority?) {
    guard let priority = priority else { // segment index < 0 will result to nil.
      filteredTasks = tasks.value
      return
    }
    
    tasks.map { $0.filter { $0.priority == priority } } // Filter out values if equal to priority param.
      .subscribe(onNext: { [weak self] in self?.filteredTasks = $0
        print($0)
      })
      .disposed(by: disposeBag)
  }
  
}


// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
    cell.textLabel?.text = filteredTasks[indexPath.row].title
    
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredTasks.count
  }
  
}

// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
  
}
