//
//  CoinLoginView.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/14.
//

import SwiftUI

struct CoinLoginView: View {
    let coin: CoinModel
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLoginView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}
