//
//  postCellView.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 2.06.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostCellView: View {
    let imageURL : URL?
    let title : String
    let index : String
    let pushed_by : String
    let delete : Bool
    
    init(imageURL : URL , title : String , index : String , pushed_by : String , delete : Bool){
        self.imageURL = imageURL
        self.title = title
        self.index = index
        self.pushed_by = pushed_by
        self.delete = delete
    }
    
    var body: some View {
        
    
        VStack {
            
                
            WebImage(url: imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
            
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
    PostCellView(imageURL: URL(string: "https://res.cloudinary.com/dahnnnwts/image/upload/images/benjamin/260")!, title: "test", index: "test", pushed_by: "test", delete: true)
}
