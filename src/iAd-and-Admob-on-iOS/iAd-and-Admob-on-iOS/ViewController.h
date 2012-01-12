//
//  ViewController.h
//  iAd-and-Admob-on-iOS
//
//  Created by Luc Wollants on 11/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <iAd/iAd.h>

#import "GADBannerView.h"

@interface ViewController : UIViewController<ADBannerViewDelegate, GADBannerViewDelegate>
{
    ADBannerView *iAdBannerView;
    GADBannerView *adMobBannerView;
}

@end
