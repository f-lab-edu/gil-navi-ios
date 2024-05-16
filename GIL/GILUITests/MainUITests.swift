//
//  MainUITests.swift
//  GILUITests
//
//  Created by 송우진 on 5/16/24.
//

import XCTest

final class MainUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
         super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    func test_홈화면에서_장소를검색하고_경로지도화면까지이동() {
        // "HomeSearchBarViewSearchLabel" 레이블을 찾아 탭하여 검색 화면으로 이동합니다.
        app.staticTexts["HomeSearchBarViewSearchLabel"].tap()
        
        // 검색 화면의 첫 번째 검색 필드를 탭합니다.
        app.searchFields.firstMatch.tap()
        // 선택된 검색 필드에 쿼리를 입력합니다.
        app.searchFields.firstMatch.typeText("Cafe")
        
        // 컬렉션뷰의 첫 번째 셀을 찾습니다.
        let firstCell = app.collectionViews.cells.firstMatch
        // 5초 동안 요소의 존재를 기다립니다.
        let exists = firstCell.waitForExistence(timeout: 5)
        if exists {
            // 셀을 클릭하여 경로 지도 화면으로 이동합니다.
            firstCell.tap()
        } else {
            XCTFail("셀이 존재하지 않습니다.")
        }
        // "운전" 버튼을 찾아 클릭합니다.
        app.buttons["운전"].tap()
        // 2초 동안 대기합니다.
        sleep(2)
        app.buttons["도보"].tap()
        // 2초 동안 대기합니다.
        sleep(2)
        // "RouteMapViewBackButton" 버튼을 찾아 탭하여 검색 화면으로 돌아갑니다.
        app.buttons["RouteMapViewBackButton"].tap()
        // "PlaceSearchNavigationBarBackButton" 버튼을 찾아 탭하여 홈화면으로 돌아갑니다.
        app.buttons["PlaceSearchNavigationBarBackButton"].tap()
    }
}
