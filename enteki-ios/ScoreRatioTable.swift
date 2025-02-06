import SwiftUI

struct ScoreRatioTable: View {
    @EnvironmentObject var arrowData: ArrowData
    
    var body: some View {
        
        GeometryReader { geometry in
            let width = geometry.size.width * 0.5  // **左半分にフィット**
            let hitRatios: [Double] = getHitRatio(scores: arrowData.scores)
            let scoreRatios: [Int] = getPlayersScore(scores: arrowData.scores)
            let fontSize : CGFloat =  UIDevice.current.userInterfaceIdiom == .pad ? 50 : 21
            VStack(spacing: 5) { // 行間の間隔を調整
                HStack {
                    Text("　　")
                        .font(.system(size: fontSize))
                    Spacer()
                    Text("的中率")
                        .font(.system(size: fontSize))
                    Spacer()
                    Text("得点")
                        .font(.system(size: fontSize))
                }
                .font(.headline)
                .padding(.bottom, 5)
                .overlay(
                    Rectangle()
                        .frame(height: 1) // 線の太さ
                        .foregroundColor(.black), // 線の色
                    alignment: .bottom
                )
                
                HStack {
                    Text("大前")
                        .font(.system(size: fontSize))
                    Spacer()
                    Text("\(String(format: "%.0f", hitRatios[0]))%")
                        .font(.system(size: fontSize))
                    Spacer()
                    Text("\(scoreRatios[0])点")
                        .font(.system(size: fontSize))
                }
                
                HStack {
                    Text("中　")
                        .font(.system(size: fontSize))
                    Spacer()
                    Text("\(String(format: "%.0f", hitRatios[1]))%")
                        .font(.system(size: fontSize))
                    Spacer()
                    Text("\(scoreRatios[1])点")
                        .font(.system(size: fontSize))
                }
                
                HStack {
                    Text("落ち")
                        .font(.system(size: fontSize))
                    Spacer()
                    Text("\(String(format: "%.0f", hitRatios[2]))%")
                        .font(.system(size: fontSize))
                    Spacer()
                    Text("\(scoreRatios[2])点")
                        .font(.system(size: fontSize))
                }
            }
            .position(x:width)
            .padding()
        }
    }
    func getHitRatio(scores: [Int]) -> [Double] {
        var hitRatios: [Double] = [0,0,0]
        var oomaeHitCount: Double = 0
        var nakaHitCount: Double = 0
        var otiHitCount: Double = 0
        var oomaeCount: Double = 0
        var nakaCount: Double = 0
        var otiCount: Double = 0
        if scores.count == 0 {return hitRatios}
        scores.enumerated().forEach{ (index,score) in
            if index % 3 == 0{ // 大前の場合
                oomaeCount += 1
                if score != 0 {oomaeHitCount += 1}
            }else if index % 3 == 1{
                nakaCount += 1
                if score != 0 {nakaHitCount += 1}
            }else{
                otiCount += 1
                if score != 0 {otiHitCount += 1}
            }
        }
        // カウントが揃ったので割って返す
        hitRatios[0] = Double(oomaeHitCount)/Double(oomaeCount)*100
        hitRatios[1] = Double(nakaHitCount)/Double(nakaCount)*100
        hitRatios[2] = Double(otiHitCount)/Double(otiCount)*100
        
        return hitRatios
    }
    func getScoreRatio(scores: [Int]) -> [Double] {
        var hitRatios: [Double] = [0,0,0]
        var oomaeHitCount: Double = 0
        var nakaHitCount: Double = 0
        var otiHitCount: Double = 0
        var oomaeCount: Double = 0
        var nakaCount: Double = 0
        var otiCount: Double = 0
        // 空なら0をそのまま返す
        if scores.count == 0 {return hitRatios}
        scores.enumerated().forEach{ (index,score) in
            if index % 3 == 0{ // 大前の場合
                oomaeCount += 10
                oomaeHitCount += Double(score)
            }else if index % 3 == 1{
                nakaCount += 10
                nakaHitCount += Double(score)
            }else{
                otiCount += 10
                otiHitCount += Double(score)
            }
        }
        // カウントが揃ったので割って返す
        hitRatios[0] = Double(oomaeHitCount)/Double(oomaeCount)*100
        hitRatios[1] = Double(nakaHitCount)/Double(nakaCount)*100
        hitRatios[2] = Double(otiHitCount)/Double(otiCount)*100
        
        return hitRatios
    }
    func getPlayersScore(scores: [Int]) -> [Int] {
        var playersScore: [Int] = [0,0,0]
        var oomaeCount: Int = 0
        var nakaCount: Int = 0
        var otiCount: Int = 0
        // 空なら0をそのまま返す
        if scores.count == 0 {return playersScore}
        scores.enumerated().forEach{ (index,score) in
            if index % 3 == 0{ // 大前の場合
                oomaeCount += Int(score)
            }else if index % 3 == 1{
                nakaCount += Int(score)
            }else{
                otiCount += Int(score)
            }
        }
        // カウントが揃ったので割って返す
        playersScore[0] = oomaeCount
        playersScore[1] = nakaCount
        playersScore[2] = otiCount
        
        return playersScore
    }
}
