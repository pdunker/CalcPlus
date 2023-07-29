//
//  HistoricViewController.swift
//  CalcPKD
//
//  Created by Philip Dunker on 16/07/23.
//

import SwiftUI

struct HistoricView: View
{
    var body: some View
    {
        List
        {
            Text("1+1=2")
            Text("1+2=3")
            Text("1+3=4")
        }
    }
}

struct HistoricViewController_Previews: PreviewProvider
{
    static var previews: some View
    {
        HistoricView()
    }
}
