import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
        
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @State var showFullDes: Bool = false
    private let column: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel){
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack (spacing: 20) {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                Text("Overview")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                ZStack {
                    if let coinDescription = vm.coinDescription,
                       !coinDescription.isEmpty {
                        VStack {
                            Text(coinDescription)
                                .lineLimit(showFullDes ? nil : 3)
                                .font(.callout)
                                .foregroundColor(Color.theme.secondaryText)
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    showFullDes.toggle()
                                }
                            } label: {
                                Text(showFullDes ? "less" : "Read More..")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 4)
                            }
                            .accentColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                LazyVGrid(columns: column,
                          alignment: .leading,
                          spacing: spacing,
                          pinnedViews: []) {
                    ForEach(vm.overviewStat) { stat in
                        StatisticView(stat: stat)
                    }
                }
                
                Text("Additional Detail")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                LazyVGrid(columns: column,
                          alignment: .leading,
                          spacing: spacing,
                          pinnedViews: []) {
                    ForEach(vm.additionalStat) { stat in
                        StatisticView(stat: stat)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    if let websiteString = vm.webUrl,
                       let url = URL(string: websiteString){
                        Link("Website",destination: url)
                    }
                    
                    if let redditString = vm.redditUrl,
                       let url = URL(string: redditString){
                        Link("Reddit",destination: url)
                    }
                }
                .accentColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                    .foregroundColor(Color.theme.secondaryText)
                    CoinImageView(coin: vm.coin)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
                .environmentObject(dev.homeVM)
        }
    }
}
