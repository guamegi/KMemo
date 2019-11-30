//
//  Model.swift
//  KMemo
//
//  Created by 나미콘 on 2019/11/30.
//  Copyright © 2019 나미콘. All rights reserved.
//

import Foundation

class Memo {
    var content: String
    var insertDate: Date
    
    init(content: String) {
        self.content = content
        insertDate = Date()
    }
    
    static var dummyMemoList = [
        Memo(content: "Lorem Ipsum"),
        Memo(content: "테스트입니다. 하하핫 ^^~")
    ]
}
