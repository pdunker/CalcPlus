//
//  AppStoreReviewManager.swift
//  CalcPKD
//
//  Created by Philip Dunker on 25/07/23.
//

import StoreKit

// Requesting App Ratings and Reviews Tutorial for iOS
// https://www.kodeco.com/9009-requesting-app-ratings-and-reviews-tutorial-for-ios
enum AppStoreReviewManager
{
    static func requestReviewIfAppropriate ()
    {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
}

extension SKStoreReviewController
{
    public static func requestReviewInCurrentScene ()
    {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        {
            DispatchQueue.main.async
            {
                requestReview(in: scene)
            }
        }
    }
}

