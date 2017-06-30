//
//  BaseCoordinator.swift
//  Coordinators-MVVM-Rx Example
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 Arthur Myronenko. All rights reserved.
//

import RxSwift

class BaseCoordinator<ResultType> {

    typealias CoordinationResult = ResultType

    let disposeBag = DisposeBag()

    private var identifier: String {
        return String(describing: type(of: self))
    }

    private var childCoordinators = [String: Any]()

    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }

    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
