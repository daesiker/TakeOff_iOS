//
//  PostUpload.swift
//  TakeOff
//
//  Created by Jun on 2021/09/06.
//

import Foundation
import RxDataSources




struct PostUpload {
    var number: Int
    var image: UIImage
}

struct PostUploadSectionModel {
    
    var header: [PostUpload]
    var items: [PostUpload]
    
    init() {
        self.header = []
        self.items = []
    }
}

extension PostUploadSectionModel: SectionModelType {
    init(original: PostUploadSectionModel, items: [PostUpload]) {
        self = original
        self.items = items
    }
}
