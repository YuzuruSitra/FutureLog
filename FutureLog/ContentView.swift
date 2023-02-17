//
//  ContentView.swift
//  FutureLog
//
//  Created by 工藤柚樹 on 2022/07/31.
//

import SwiftUI
import UIKit
import Combine

struct ContentView: View {
    
    //やることリスト用
    @State private var Doits: [String] = []
    //やることリスト入れ替え用
    @State private var CnvTasks = ""
    //やること格納用
    @State private var Dotask = ""
    //休憩時間格納用
    @State private var RestTime = 0.5
    //開始時刻格納用
    @State private var StartTime = 1.0
    //終了時刻格納用
    @State private var EndTime = 24.0
    //最低終了時刻
    @State private var BegEnd = 0.0
    @State private var TaskCount = 0
    @State private var jugeScene = true
    //タスクの時間
    @State private var TaskTime = 0
    @State private var TaskSchedule: [Int] = []
    @State private var RestSchedule: [Int] = [0,0,0,0,0]
    @State private var TaskRatio: [Int] = [1,1,1,1,1]
    //計算用個別タスク時間
    @State private var IndividualTime: [Double] = [0.0,0.0,0.0,0.0,0.0]
    
    
    @State private var GeneCount = 0
    //出力要素計算用
    @State private var CalFirst = true
    private let TextLimit = 6 //最大文字数
    
    
    init() {
        UITableView.appearance().backgroundColor = .black
        
        //ピッカー背景色
        UISegmentedControl.appearance().backgroundColor = .black.withAlphaComponent(0.4)
        
    }
    
    
    var body: some View {
        
        VStack(alignment: .center){
            Text("Future-Log")
                .font(.title)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
            
            Form{
                if jugeScene{
                    //STEP1
                    Section(header: Text("STEP1")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .multilineTextAlignment(.leading)){
                            
                            HStack{

                                Text("Fill in Tasks：")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 5.0)
                                TextField("", text:
                                            $Dotask)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            HStack{
                                Spacer()
                            Button("Add.") {
                                //空じゃなければ
                                if !Dotask.isEmpty{
                                    
                                    //８文字以上なら８文字にセット
                                    if Dotask.count > TextLimit {
                                        Dotask = String(Dotask.prefix(TextLimit))
                                    }
                                        //五個以下なら配列に追加
                                    if Doits.count < 5{
                                        Doits.append(Dotask)
                                        Dotask = ""
                                    }
                                }
                            }
                            .padding(.trailing, 30.0)
                            }
                        }
                    
                    
                    
                    //STEP2
                    Section(header: Text("STEP2")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .multilineTextAlignment(.leading)){
                            HStack{
                                Text("RestTime:")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 2.0)
                                Stepper(value: $RestTime, in: 0.25...1 , step: 0.25)
                                {
                                    Text("\(RestTime * 60.0, specifier: "%.0f") min.")
                                }
                            }
                        }
                    
                    //時間範囲の指定
                    Section(header: Text("STEP3")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .multilineTextAlignment(.leading)){
                            
                            HStack{
                                Text("StartTime:")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.leading)
                                    .padding(0.0)
                                Stepper(value: $StartTime, in: 1...24 , step: 1.0)
                                {
                                    Text("\(StartTime, specifier: "%.1f") o'clock . .")
                                }
                            }
                            
                            HStack{
                                Text("EndTime:")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 8.0)
                                Stepper(value: $EndTime, in: StartTime...24 , step: 1)
                                {
                                    Text("\(EndTime, specifier: "%.1f") o'clock .")
                                }
                            }
                        }
                    HStack{
                        
                        Spacer()
                        
                    Button("Done.") {
                        if Doits.count > 0 {
                            if StartTime < EndTime{
                                
                            jugeScene = false
                            TaskCount = Doits.count
                            GeneCount = TaskCount * 2
                            TaskTime = TaskCalc(EndT: EndTime,StartT: StartTime, RestT: RestTime)
                            }
                        }
                    }
                    .padding(.trailing, 30.0)
                    }
                   
                    
                    
                    
                    
                    //やることリスト
                    //配列に何か要素が入ったとき
                    
                    if  !Doits.isEmpty {
                        Section(header: Text("To do")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.yellow)
                            .multilineTextAlignment(.leading))
                        {
                            
                            
                            ScrollView {
                                
                                VStack(alignment: .leading) {
                                    
                                    
                                    if Doits.count > 0{
                                        Spacer()
                                            .frame(height: 10.0)
                                        if !Doits[0].isEmpty{
                                            
                                            HStack{
                                                Text("Task １: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                                
                                                Text(Doits[0])
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                Spacer()
                                                
                                                Text("Ratio: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                Picker(selection: $TaskRatio[0], label: Text("TaskRatio")) {
                                                    Text("1").tag(1)
                                                    Text("2").tag(2)
                                                    Text("3").tag(3)
                                                    
                                                }
                                                
                                                Button("[↓]") {
                                                         changeTask(taskNum: 0)
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    if Doits.count > 1{
                                        Spacer()
                                            .frame(height: 10.0)
                                        
                                        if !Doits[1].isEmpty{
                                            
                                            HStack{
                                                Text("Task ２: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                                
                                                Text(Doits[1])
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                Spacer()
    
                                                Text("Ratio: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                Picker(selection: $TaskRatio[1], label: Text("TaskRatio")) {
                                                    Text("1").tag(1)
                                                    Text("2").tag(2)
                                                    Text("3").tag(3)
                                                }
                                                
                                                Button("[↑]") {
                                                         changeTask(taskNum: 1)
                                                }
                                                     
                                            }
                                        }
                                    }
                                    
                                    
                                    if Doits.count > 2{
                                        Spacer()
                                            .frame(height: 10.0)
                                        if !Doits[2].isEmpty{
                                            
                                            HStack{
                                                Text("Task ３: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                                
                                                Text(Doits[2])
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                
                                                Spacer()
                                                
                                                Text("Ratio: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                Picker(selection: $TaskRatio[2], label: Text("TaskRatio")) {
                                                    Text("1").tag(1)
                                                    Text("2").tag(2)
                                                    Text("3").tag(3)
                                                }
                                                
                                                Button("[↑]") {
                                                    changeTask(taskNum: 2)
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    
                                    if Doits.count > 3{
                                        Spacer()
                                            .frame(height: 10.0)
                                        if !Doits[3].isEmpty{
                                            HStack{
                                                Text("Task ４: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                                
                                                Text(Doits[3])
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                
                                                Spacer()
                                                
                                                Text("Ratio: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                Picker(selection: $TaskRatio[3], label: Text("TaskRatio")) {
                                                    Text("1").tag(1)
                                                    Text("2").tag(2)
                                                    Text("3").tag(3)
                                                }
                                                Button("[↑]") {
                                                    changeTask(taskNum: 3)
                                                }
                                            }
                                        }
                                    }
                                    
                                    if Doits.count > 4{
                                        Spacer()
                                            .frame(height: 10.0)
                                        if !Doits[4].isEmpty{
                                            HStack{
                                                Text("Task ５: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                                
                                                Text(Doits[4])
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                Spacer()
                                                
                                                Text("Ratio: ")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                
                                                Picker(selection: $TaskRatio[4], label: Text("TaskRatio")) {
                                                    Text("1").tag(1)
                                                    Text("2").tag(2)
                                                    Text("3").tag(3)
                                                }
                                                Button("[↑]") {
                                                    changeTask(taskNum: 4)
                                                }
                                            }
                                        }
                                    }
                                    
                                    HStack{

                                        Spacer()
                                        
                                    Button("Remove Task.") {
                                        if Doits.count > 0{
                                            Doits.removeLast()
                                        }
                                    }
                                    .padding([.top, .trailing], 10.0)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                
                
                //出力画面
                else{
                    Section(header: Text("Todo List")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 10.0))
                    {
                        let Hours = " : "
                        let CnvertCount = GeneCount
                        ForEach(0..<CnvertCount, id: \.self) {i in
                            
                            
                            if i == 0{
                                Text(outhour(number: i) + Hours + outminute(number: i)+"　　　" + Doits[0])
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.center)
                            }
                            else if i == 2{
                                
                                Text(outhour(number: i) + Hours + outminute(number: i)+"　　　" + Doits[1])
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.center)
                                
                            }
                            else if i == 4{
                                
                                Text(outhour(number: i) + Hours + outminute(number: i)+"　　　" + Doits[2])
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.center)
                                
                            }
                            else if i == 6{
                                
                                Text(outhour(number: i) + Hours + outminute(number: i)+"　　　" + Doits[3])
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.center)
                                
                            }
                            else if i == 8{
                                
                                Text(outhour(number: i) + Hours + outminute(number: i)+"　　　" + Doits[4])
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hue: 0.49, saturation: 0.756, brightness: 1.0))
                                    .multilineTextAlignment(.center)
                                
                            }
                            else{
                                Text(outhour(number: i) + Hours + outminute(number: i))
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                
                            }
                            
                        }
                    }
                    HStack{
                        
                        Spacer()

                    //テキストの表示
                    Button("Remake.") {
                        jugeScene = true
                        CalFirst = true
                        //タスクの時間格納用配列のリセット
                        TaskSchedule.removeAll()
                    }
                    .padding(.trailing, 30.0)
                    }
                    
                    
                }

                    
            }
            
            
        }
    }
    
    //タスク順番入れ替え用
    func changeTask(taskNum: Int ){
        if(taskNum == 0)
        {
            CnvTasks = Doits[Doits.count - 1]
            Doits[Doits.count - 1] = Doits[taskNum]
            Doits[taskNum] = CnvTasks
        }
        else
        {
            CnvTasks = Doits[taskNum-1]
            Doits[taskNum-1] = Doits[taskNum]
            Doits[taskNum] = CnvTasks
        }
    }
    
    
    //タスクタイムを計算
    func TaskCalc(EndT: Double, StartT: Double, RestT: Double) -> Int{
        
        var taskTime = 0.0
        
        var restTime = 0.0
        var startTime = 0.0
        var endTime = 0.0
        var totalRatio = TaskRatio.reduce(0,+)
        var Translation = 0.0
        totalRatio = totalRatio + TaskCount - 5
        
        taskTime = (EndT - StartT - (Double(TaskCount) - 1.0) * RestT) / Double(TaskCount)
        //それぞれのタスク時間を格納(分計算)
        for TaskNum in 0...TaskCount - 1 {
            Translation = taskTime * Double(TaskCount) / Double(totalRatio) * Double(TaskRatio[TaskNum])
            
            //分に変換して格納
            IndividualTime[TaskNum] = 60.0 * Translation
        }
    
        
        restTime = 60.0 * RestT
        startTime = 60.0 * StartT
        endTime = 60.0 * EndT
        //配列に追加用クッション
        var cushion = 0
        
        //配列に時間を格納(分)
        var i = 0
        //ここ処理の追加
        for count in 0 ..< GeneCount{
            let JugeCount = count % 2
            switch JugeCount{
                
            case 0:
                
                if CalFirst {
                    cushion = Int(startTime)
                    CalFirst = false
                }
                else{
                    cushion = TaskSchedule[count-1] + Int(restTime)
                }
                
                break;
                
            case 1:
                
                if count == GeneCount - 1 {
                    cushion = Int(endTime)
                }
                else{
                cushion = TaskSchedule[count-1] + Int(IndividualTime[i])
                i += 1
                }
                
                break;
            default:
                break;
            }
            TaskSchedule.append(cushion)
        }
        //適当なやつ
        return Int(taskTime)
    }
    
    func outhour(number:Int) -> String {
        let hour = TaskSchedule[number] / 60
        var CalcHour = hour.description
        if hour / 10 == 0{
            CalcHour = "0"+CalcHour
        }
        return CalcHour
    }
    
    func outminute(number:Int) -> String {
        let minute = TaskSchedule[number] % 60
        var CalcMinute = minute.description
        if minute / 10  == 0 {
            CalcMinute = "0"+CalcMinute
        }
        return CalcMinute
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//昼夜の色設定,機種ごとの画面比率
