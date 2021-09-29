//
//  PostUpload.swift
//  TakeOff
//
//  Created by Jun on 2021/09/06.
//

import Foundation
import RxDataSources

struct PostUploadSectionModel {
    
    var header: [UIImage]
    var items: [UIImage]
    
    init() {
        self.header = []
        self.items = []
    }
    
}

extension PostUploadSectionModel: SectionModelType {
    init(original: PostUploadSectionModel, items: [UIImage]) {
        self = original
        self.items = items
    }
}
