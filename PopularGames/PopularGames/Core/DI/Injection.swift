//
//  Injection.swift
//  PopularGames
//
//  Created by WDT on 07/08/24.
//

import Foundation
import RealmSwift
import Core
import HomeModule
import DetailGameModule

final class Injection: NSObject {
  
  private let realm = try? Realm()
  
  func provideHomeUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == [GameEntity] {
    let remote = GetPopularGameRemoteDataSource(endpoint: "https://rawg-mirror.vercel.app/api/games")
    let mapper = GameTransformer()
    
    let repository = GetPopularGameRepository(
      remoteDataSource: remote,
      mapper: mapper)
    
    return Interactor(repository: repository) as! U
  }
  
  func provideDetailUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == DetailGameEntity {
    let remote = GetDetailGameRemoteDataSource(endpoint: "https://rawg-mirror.vercel.app/api/games/3498")
    let mapper = DetailGameTransformer()
    
    let repository = GetDetailGameRepository(
      remoteDataSource: remote,
      mapper: mapper)
    
    return Interactor(repository: repository) as! U
  }
  
    
}
