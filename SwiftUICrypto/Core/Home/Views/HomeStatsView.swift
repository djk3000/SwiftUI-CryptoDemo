//
//  HomeStatsView.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/13.
//

import SwiftUI

struct HomeStatsView: View {    
    @Binding var showProtfolio: Bool
    @EnvironmentObject private var vm : HomeViewModel
    
    var body: some View {
        HStack {
            ForEach(vm.statistics){ stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showProtfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showProtfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
