//
//  MainTableViewController.swift
//  Daimo
//
//  Created by sogih on 14/07/2019.
//  Copyright © 2019 sogih. All rights reserved.
//



import UIKit
import SnapKit
import CoreData
//import QuartzCore


class TodoTableViewController: UITableViewController {
    
    let refresh = UIRefreshControl()
    
    // MARK:- Properties
    fileprivate let cellId = "cell"
    fileprivate let headerId = "header"
    var todoList = [TodoList]()
    var currentDatilyTodoList = [TodoList]()
    var currentWeeklyTodoList = [TodoList]()
    var currentMonthlyTodoList = [TodoList]()
    var currentYearlyTodoList = [TodoList]()
    var swipeSection = 0 {
        didSet {
            tableView.reloadData()
            let transition = CATransition()
            transition.type = CATransitionType.fade
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.fillMode = CAMediaTimingFillMode.forwards
            transition.duration = 0.25
            transition.subtype = CATransitionSubtype.fromLeft
            tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        }
    }
    
    var addTodo = false
    var cancelTodo = false {
        didSet {
            let dateType = todoList.last!.dateType
            todoList.removeLast()
            tableView.deleteRows(at: [IndexPath(row: 0, section: dateType)], with: .left)
        }
    }
    
    let todayDate = Singleton.shared.todayDate
    let startDate = Singleton.shared.startDate
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////
        setCurrentDateToToday()
        /////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        retrieveData()

        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.sectionHeaderHeight = 164-26
        tableView.sectionFooterHeight = 0
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: cellId)
        navigationItem.title = "DAIMO"
        // Review: [Refactoring] 미리 스타일을 지정하는 건 어떤가요?
        /*UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrown,
            NSAttributedString.Key.font: UIFont.naviTitle
        ]
         */
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrown,
            NSAttributedString.Key.font: UIFont.naviTitle
        ]
        // Review: viewWillAppear 에서 하는건 어떤가요?
        // navigationController 는 child viewcontroller에서 공유하기 때문에
        // 다른 Child ViewController 에서도 네비바 경계선이 설정될 수 있습니다.
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .white
        //네비바 경계선
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        // ==== viewWillAppear 에서 하는건 어떤가요? 여기까지 ===
        
        tableView.separatorStyle = .none

        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
        refresh.addTarget(self, action: #selector(tappedLeftBarButton), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Move to today", attributes: nil)
    }
    
    // MARK:- TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderView(reuseIdentifier: headerId)
        header.delegate = self
        switch section {
        case 0: header.dateTypeLabel.text = "Daily"
        case 1: header.dateTypeLabel.text = "Weekly"
        case 2: header.dateTypeLabel.text = "Monthly"
        case 3: header.dateTypeLabel.text = "Yearly"
        default: break }
        
        header.sectionOfTableView = section
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            currentDatilyTodoList.removeAll()
            for i in 0..<todoList.count {
                if todoList[i].dateType == 0 && todoList[i].date == Singleton.shared.currentDate[0] {
                    count += 1
                    currentDatilyTodoList.append(todoList[i])
                }
            }
            
        case 1:
            currentWeeklyTodoList.removeAll()
            for i in 0..<todoList.count {
                if todoList[i].dateType == 1 && todoList[i].date == Singleton.shared.currentDate[1] {
                    count += 1
                    currentWeeklyTodoList.append(todoList[i])
                }
            }
            
        case 2:
            currentMonthlyTodoList.removeAll()
            for i in 0..<todoList.count {
                if todoList[i].dateType == 2 && todoList[i].date == Singleton.shared.currentDate[2] {
                    count += 1
                    currentMonthlyTodoList.append(todoList[i])
                }
            }
            
        case 3:
            currentYearlyTodoList.removeAll()
            for i in 0..<todoList.count {
                if todoList[i].dateType == 3 && todoList[i].date == Singleton.shared.currentDate[3] {
                    count += 1
                    currentYearlyTodoList.append(todoList[i])
                }
            }
            
        default:
            break
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TodoTableViewCell
        cell.todoTextField.delegate = self
        cell.cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        
        var isDone = false
        if addTodo == true {
            cell.todoTextField.text = todoList.last?.todo
            
            DispatchQueue.main.async {
                cell.todoTextField.becomeFirstResponder()
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            tableView.isUserInteractionEnabled = false
            addTodo = false
        } else {
            cell.todoTextField.isUserInteractionEnabled = false
            switch indexPath.section {
            case 0:
                cell.todoTextField.text = currentDatilyTodoList[currentDatilyTodoList.count-1-indexPath.row].todo
                isDone = currentDatilyTodoList[currentDatilyTodoList.count-1-indexPath.row].isDone
            case 1:
                cell.todoTextField.text = currentWeeklyTodoList[currentWeeklyTodoList.count-1-indexPath.row].todo
                isDone = currentWeeklyTodoList[currentWeeklyTodoList.count-1-indexPath.row].isDone
            case 2:
                cell.todoTextField.text = currentMonthlyTodoList[currentMonthlyTodoList.count-1-indexPath.row].todo
                isDone = currentMonthlyTodoList[currentMonthlyTodoList.count-1-indexPath.row].isDone
            case 3:
                cell.todoTextField.text = currentYearlyTodoList[currentYearlyTodoList.count-1-indexPath.row].todo
                isDone = currentYearlyTodoList[currentYearlyTodoList.count-1-indexPath.row].isDone
            default:
                break
            }
        }
        
        if isDone {
            cell.checkBoxButton.isSelected = false
            cell.todoTextField.attributedText = cell.todoTextField.text?.strikeThrough()
            cell.todoTextField.textColor = .lightGray
            cell.checkBoxButton.tintColor = .lightGray
        } else {
            cell.checkBoxButton.isSelected = true
            cell.todoTextField.textColor = .darkGray
            cell.checkBoxButton.tintColor = .darkGray
        }

        cell.checkBoxButton.isSelected = !cell.checkBoxButton.isSelected
        
//        // button animation
//        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
//            cell.checkBoxButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            cell.checkBoxButton.isSelected = !cell.checkBoxButton.isSelected
//        }) { (success) in
//            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
//                cell.checkBoxButton.transform = .identity
//            }, completion: nil)
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    // update isDone - select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update TodoList - Model
        let date = Singleton.shared.currentDate[indexPath.section]
        let dateType = indexPath.section
        let index = indexPath.row
        var count = 0
        var listIndex = 0
        for i in (0..<todoList.count).reversed() {
            if todoList[i].date == date && todoList[i].dateType == dateType {
                if count == index {
                    listIndex = i
                    if todoList[i].isDone == false { todoList[i].isDone = true } else { todoList[i].isDone = false }
                }
                count += 1
            }
        }
        
        // update TableView - View
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        // update TodoData - CoreData
        updateData(todoList[listIndex].isDone, listIndex)
    }
    
    // delete todo - swipe row
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let kk = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
            
            success(true)
            // update model
            let date = Singleton.shared.currentDate[indexPath.section]
            let dateType = indexPath.section
            let index = indexPath.row
            var count = 0
            var listIndex = 0
            for i in (0..<self.todoList.count).reversed() {
                if self.todoList[i].date == date && self.todoList[i].dateType == dateType {
                    if count == index {
                        listIndex = i
                        self.todoList.remove(at: i)
                    }
                    count += 1
                }
            }
            
            // update view
            tableView.deleteRows(at: [indexPath], with: .left)
            
            // update data
            self.deleteData(listIndex)
            
        }
        kk.backgroundColor = UIColor(red:0.95, green:0.49, blue:0.49, alpha:1.0)
        
        let kkk = UISwipeActionsConfiguration(actions: [kk])
        return kkk
    }
    
}


// MARK:- textField delegate
extension TodoTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.isUserInteractionEnabled = true
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
        todoList[todoList.count-1].todo = textField.text!
        createData(todoList.last!.dateType, todoList.last!.date, todoList.last!.isDone, todoList.last!.todo)
        switch todoList.last!.dateType{
        case 0: currentDatilyTodoList[currentDatilyTodoList.count-1].todo = textField.text!
        case 1: currentWeeklyTodoList[currentWeeklyTodoList.count-1].todo = textField.text!
        case 2: currentMonthlyTodoList[currentMonthlyTodoList.count-1].todo = textField.text!
        case 3: currentYearlyTodoList[currentYearlyTodoList.count-1].todo = textField.text!
        default:
            break
        }
        return true
    }
    @objc func tappedCancelButton() {
        tableView.isUserInteractionEnabled = true
        view.endEditing(true)
        cancelTodo = true
    }
    
    
}

// MARK:- action & event
extension TodoTableViewController {
    @objc func tappedLeftBarButton() {
        self.setCurrentDateToToday()
        for i in 0..<4 { Singleton.shared.firstLoadOfSectionHeader[i] = false }
        tableView.reloadData()
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.4
        transition.subtype = CATransitionSubtype.fromLeft
        refresh.endRefreshing()
    }
}


// MARK:- init
extension TodoTableViewController {
    func setCurrentDateToToday() {
        var weeklyDate = Date()
        var monthlyDate = Date()
        var yearlyDate = Date()
        var index = 0
        
        switch Calendar.current.dateComponents([.weekday], from: todayDate).weekday! {
        case 1: weeklyDate = Calendar.current.date(byAdding: .day, value: -6, to: todayDate)!
        case 2: weeklyDate = Calendar.current.date(byAdding: .day, value: 0, to: todayDate)!
        case 3: weeklyDate = Calendar.current.date(byAdding: .day, value: -1, to: todayDate)!
        case 4: weeklyDate = Calendar.current.date(byAdding: .day, value: -2, to: todayDate)!
        case 5: weeklyDate = Calendar.current.date(byAdding: .day, value: -3, to: todayDate)!
        case 6: weeklyDate = Calendar.current.date(byAdding: .day, value: -4, to: todayDate)!
        case 7: weeklyDate = Calendar.current.date(byAdding: .day, value: -5, to: todayDate)!
        default: break
        }
        
        index = Calendar.current.dateComponents([.month], from: startDate, to: todayDate).month!
        monthlyDate = Calendar.current.date(byAdding: .month, value: index, to: startDate)!
        
        index = Calendar.current.dateComponents([.year], from: startDate, to: todayDate).year!
        yearlyDate = Calendar.current.date(byAdding: .year, value: index, to: startDate)!
        
        Singleton.shared.currentDate[0] = todayDate
        Singleton.shared.currentDate[1] = weeklyDate
        Singleton.shared.currentDate[2] = monthlyDate
        Singleton.shared.currentDate[3] = yearlyDate
        
    }
}

// MARK:- Core Data
extension TodoTableViewController {
    
    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoData> = TodoData.fetchRequest()
        do {
            let todoData = try managedContext.fetch(fetchRequest)
            for data in todoData {
                todoList.append(TodoList(dateType: Int(data.dateType), date: data.date!, isDone: data.isDone, todo: data.todo!))
            }
        } catch  {
            print("Failed")
        }
    }
    
    
    func createData(_ dateType: Int, _ date: Date, _ isDone: Bool, _ todo: String) {
        // Review: [Refactoring] Data protocol을 설계하는건 어떤가요?
        /*
        protocol DataAcessProtocol {
            associatedtype T
            func insert(t: T)
            func delete(t: T)
            func update(t: T)
        }
         */
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "TodoData", in: managedContext)!
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(dateType, forKey: "dateType")
        user.setValue(date, forKey: "date")
        user.setValue(isDone, forKey: "isDone")
        user.setValue(todo, forKey: "todo")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateData(_ isDone: Bool, _ index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoData> = NSFetchRequest.init(entityName: "TodoData")
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = test[index] as NSManagedObject
            objectUpdate.setValue(isDone, forKey: "isDone")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteData(_ index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoData> = NSFetchRequest.init(entityName: "TodoData")
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[index] as NSManagedObject
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    
}


protocol DeliveryDataProtocol: class {
    func deliveryData(_ dateType: Int, _ date: Date)
    func swipeSignal(_ signal: Int)
}
extension TodoTableViewController: DeliveryDataProtocol {
    func deliveryData(_ dateType: Int, _ date: Date) {
        todoList.append(TodoList(dateType: dateType, date: date, isDone: false, todo: ""))
        addTodo = true
        tableView.insertRows(at: [IndexPath(row: 0, section: todoList.last!.dateType)], with: .left)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: dateType), at: .top, animated: true)
        }
    }
    func swipeSignal(_ signal: Int) {
        swipeSection = signal
    }
}
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
