import Foundation

protocol Task {
    var priority: Int { get }
    var isCompleted: Bool { get set }
    var dependencies: [Task] { get set }

    func addDependency(_ task: Task)
    func execute()
}

enum TaskManagerError: Error {
    case cycleError
}

class TaskManager {
    var tasks: [Task] = []
    private let queue = DispatchQueue(label: "task manager", attributes: .concurrent)

    func add(_ task: Task) -> Void {
        queue.async(flags: .barrier) {
            self.tasks.append(task)
        }
    }

    func start() throws -> Void {
        while true {
            var taskToExecute: Task?
            queue.sync {
                for task in tasks.sorted(by: { task1, task2 in
                    task1.priority > task2.priority
                    || (task1.priority == task2.priority && task1.dependencies.count < task2.dependencies.count)
                }) {
                    guard !task.isCompleted else {
                        continue
                    }
                    let dependenciesCompleted = task.dependencies.allSatisfy { task in
                        task.isCompleted
                    }
                    if dependenciesCompleted {
                        taskToExecute = task
                        break
                    }
                }
            }
            guard var task = taskToExecute else {
                if !tasks.isEmpty {
                    throw TaskManagerError.cycleError
                }
                break
            }
            queue.async {
                task.execute()
                task.isCompleted = true
            }
            queue.async(flags: .barrier) {
                self.tasks.removeAll { task in
                    task.isCompleted
                }
            }
        }
    }
}
