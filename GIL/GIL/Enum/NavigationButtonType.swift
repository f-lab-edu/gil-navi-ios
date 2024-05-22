//
//  NavigationButtonType.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import Foundation

/// 네비게이션 버튼의 종류를 정의하는 열거형입니다
/// - close : 닫기 버튼 타입
/// - back: 뒤로 가기 버튼 타입
enum NavigationButtonType {
    case close
    case back
    
    /// 버튼의 시스템 이미지 이름을 반환합니다
    /// - Returns: 각 버튼 타입에 맞는 시스템 이미지 이름
    var systemImageName: String {
        switch self {
        case .close: return "xmark"
        case .back: return "chevron.backward"
        }
    }
    
    /// 버튼의 아이콘 너비를 반환합니다
    /// - Returns: 각 버튼 타입에 맞는 아이콘의 너비
    var iconWidth: CGFloat {
        switch self {
        case .close: return 26
        case .back: return 18
        }
    }
}
