//
//  MainViewModel.swift
//  CompositionalLayouts
//
//  Created by kou yamamoto on 2021/12/02.
//

import Foundation
import RxSwift
import RxRelay

protocol MainViewModelInputs {
    func viewDidLoad()
    func fetchData(shouldRefresh: Bool)
    func tappedTownImageView()
    func tappedShopImageView(indexPath: IndexPath)
}

protocol MainViewModelOutputs {
    var loading: Observable<Bool> { get }
    var result: Observable<[SectionModel]> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

final class MainViewModel: MainViewModelInputs, MainViewModelOutputs, MainViewModelType {

    private let disposeBag = DisposeBag()

    private let towns: [Town] = [Town(name: "新宿", location: "東京都", pupulation: "6,000,000人")]
    private let shops: [Shop] = [
        Shop(name: "ルミネエストルミネエストルミネエストルミネエストルミネエストルミネエストルミネエストルミネエストルミネエスト", location: "東京都新宿区高田馬場3-6-5"),
        Shop(name: "ユニクロ", location: "東京都新宿区東新宿5-28-5"),
        Shop(name: "GUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGUGU", location: "東京都新宿区早稲田5-28-5"),
        Shop(name: "ユニクロ", location: "東京都新宿区代々木5-28-5"),
        Shop(name: "ルミネエスト", location: "東京都新宿区高田馬場3-6-5"),
        Shop(name: "ユニクロ", location: "東京都新宿区東新宿5-28-5"),
        Shop(name: "GU", location: "東京都新宿区早稲田5-28-5"),
        Shop(name: "ユニクロ", location: "東京都新宿区代々木5-28-5")
    ]

    // ViewControllerは以下を経由してViewModelを扱う
    var inputs: MainViewModelInputs { return self }
    var outputs: MainViewModelOutputs { return self }

    // ViewControllerが購読する
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    var loading: Observable<Bool> { return loadingRelay.asObservable() }

    private let resultRelay = BehaviorRelay<[SectionModel]>(value: [])
    var result: Observable<[SectionModel]> { return resultRelay.asObservable() }

    func viewDidLoad() {
        fetchData(shouldRefresh: true)
    }

    func fetchData(shouldRefresh: Bool) {

        loadingRelay.accept(true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingRelay.accept(false)
            switch shouldRefresh {
            case true:
                let towns: [SectionItem] = self.towns.map { .main(town: $0 ) }
                let shops: [SectionItem] = self.shops.map { .sub(shop: $0 ) }
                let result: [SectionModel] = [.main(title: "町名", items: towns), .sub(title: "店名", items: shops)]
                self.resultRelay.accept(result)
            case false:
                print()
//                let previousTowns = self.resultRelay.value[0].items
//                let previousShops = self.resultRelay.value[1].items
//                let towns: [SectionItem] = previousTowns + self.towns.map { .main(town: $0 ) }
//                let shops: [SectionItem] = previousShops + self.shops.map { .sub(shop: $0 ) }
//                let result: [SectionModel] = [.main(title: "町名", items: towns), .sub(title: "店名", items: shops)]
//                self.resultRelay.accept(result)
            }
        }
    }

    func tappedTownImageView() {
        print("----------------")
        let towns: [SectionItem] = [.main(town: Town(name: "あああ", location: "ああああああ", pupulation: "あああああ"))]
        let shops: [SectionItem] = self.shops.map { .sub(shop: $0 ) }
        let result: [SectionModel] = [.main(title: "町名", items: towns), .sub(title: "店名", items: shops)]
        self.resultRelay.accept(result)
    }

    func tappedShopImageView(indexPath: IndexPath) {
        print("========================")
        let townSectionModel = resultRelay.value[0]
        var shops: [SectionItem] = self.shops.map { .sub(shop: $0 ) }
        shops[indexPath.row] = .sub(shop: Shop(name: "ああああああ", location: "いいいいい"))
        let result: [SectionModel] = [townSectionModel, .sub(title: "店名", items: shops)]
        self.resultRelay.accept(result)
    }
}
