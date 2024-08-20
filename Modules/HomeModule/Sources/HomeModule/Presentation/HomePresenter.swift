//
//  File.swift
//
//
//  Created by WDT on 19/08/24.
//

import Foundation
import Combine
import Core
import SwiftUI

public class HomePresenter<Request, Response, Interactor: UseCase, AddFavoriteUsecase: UseCase>: Presenter, ObservableObject where Interactor.Request == Request, Interactor.Response == [Response] {
  
  public typealias DetailRequest = Request
  public typealias DeleteFavoriteRequest = Any
  public typealias AddFavoriteRequest = Any
  public typealias Detail = Any
  
  private var cancellables: Set<AnyCancellable> = []
  private let _useCase: Interactor
  private let addFavoriteUsecase: AddFavoriteUsecase

  
  @Published public var list: [Response] = []
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false
  @Published public var selectedGame: Int? = nil
  
  public init(useCase: Interactor, addFavoriteUsecase: AddFavoriteUsecase) {
    _useCase = useCase
    self.addFavoriteUsecase = addFavoriteUsecase
  }
  
  public func getList(request: Request?) {
    isLoading = true
    _useCase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { list in
        self.list = list
      })
      .store(in: &cancellables)
  }
  
  public func getDetail(request: DetailRequest?) -> Detail {
    return []
  }
  
  public func deleteFavorite(request: DeleteFavoriteRequest?) {
    
  }
  
  public func addToFavorite(request: AddFavoriteRequest?) {
    isLoading = true 
    self.addFavoriteUsecase.execute(request: request as! AddFavoriteUsecase.Request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { _ in })
      .store(in: &cancellables)
  }
  
}
