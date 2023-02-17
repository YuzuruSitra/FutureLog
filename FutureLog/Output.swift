//
//  Output.swift
//  FutureLog
//
//  Created by 工藤柚樹 on 2022/08/05.
//

import SwiftUI

struct Output: View {
    
    var EachTime: [Int] = [0,0,0,0,0]
    var TaskTime = 0.0
    
    var body: some View {
        
        ScrollView {
            VStack{
            Text("あ")
            Text("あ")
            }
        }
    }
/*
func TimeCalc() -> Double{
    //EndTime
    //TaskTime = (終了時刻 - 開始時刻 - (TaskCount-1) ＊ 休憩時間) / TaskCount
    
    TaskTime = EndTime - StartTime - Double((Doits.count)) * RestTime
    return TaskTime
     */
}




struct Output_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Output()
            Output()
        }
    }
}



