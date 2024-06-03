//
//  PostCellViewWithoutImage.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 3.06.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostCellViewWithoutImage: View {

    let title : String
    let index : String
    let pushed_by : String
    let delete : Bool
    
    init(title : String , index : String , pushed_by : String , delete : Bool){
        
        self.title = title
        self.index = index
        self.pushed_by = pushed_by
        self.delete = delete
    }
    
    var body: some View {
        
    
        VStack {
            
            Text(title)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .frame(width: 290)
                .background()
                .backgroundStyle(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .foregroundStyle(Color.white)
            
            Text(index)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .frame(width: 290)
                .background()
                .backgroundStyle(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(Color.white)
            
            Text(pushed_by)
                .italic()
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .frame(width: 290)
                .background()
                .backgroundStyle(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(Color.white)
                .foregroundStyle(Color.white)
        
            
            
        }
        .backgroundStyle(Color.clear)
        
    }
}

#Preview {
    PostCellViewWithoutImage( title: "test", index: "test", pushed_by: "test", delete: true)
}
