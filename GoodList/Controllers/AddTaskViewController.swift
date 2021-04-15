//
//  AddTaskViewController.swift
//  GoodList
//
//  Created by Myron Dulay on 4/15/21.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
  
  // MARK: - Properties
  
  private let taskSubject = PublishSubject<Task>()
  
  var taskSubjectObservable: Observable<Task> {
    return taskSubject.asObserver()
  }
  
  @IBOutlet weak var prioritySegmenetedControl: UISegmentedControl!
  @IBOutlet weak var taskTitleTextField: UITextField!
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
  }
  
  // MARK: - API
  
  // MARK: - Actions
  
  @IBAction func save() {
    guard let priority = Priority(rawValue: prioritySegmenetedControl.selectedSegmentIndex),
          let title = taskTitleTextField.text else { return }
    
    let task = Task(title: title, priority: priority)
    
    taskSubject.onNext(task)
    
    dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: - Helpers
}


// MARK: - Extensions
