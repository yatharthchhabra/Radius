//
//  NewFile.swift
//  Gaucho Libre
//
//  Created by Aditya Sharma on 9/26/20.
//  Copyright © 2020 Aditya Sharma. All rights reserved.
//

import SwiftUI

struct NewFile: View {
    @State var date = Date()
    @State var time = Date()
    var body : some View{
//        Text("HI")
        NavigationView{
            Form{
//                DatePicker(selection: $date)
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Selected Date")
                }
                DatePicker(selection: $time, displayedComponents: .hourAndMinute) {
                    Text("Selected Time")
                }
//                Spacer(minLength: 0)
                Text("Notify Me")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .navigationBarTitle("Date and Time")
        }
    }
}

struct NewFile_Previews: PreviewProvider{
    static var previews: some View{
        NewFile()
    }
}
