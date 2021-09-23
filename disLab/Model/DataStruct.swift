//
//  DataStruct.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/08/31.
//

import Foundation


struct  DataSetDocuments {
    let userID:String
    let userName:String
    let postID:String
    let title:String
    let discription:String
    let category:String
    let createdAt:Double
    let isOpen:Bool
}

struct DataSetsComments {
    let userID:String
    let userName:String
    let postID:String
    let commentID:String
    let comment:String
    let createdAt:Double
    var cellisOpen:Bool
}

struct UserInfo{
    let userID:String
    let userName:String
    let introduction:String
}
