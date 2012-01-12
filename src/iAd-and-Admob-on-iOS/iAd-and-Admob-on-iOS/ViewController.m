//
//  ViewController.m
//  iAd-and-Admob-on-iOS
//
//  Created by Luc Wollants on 11/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Init Banners

-(void)initAdMobBanner
{
    if (!adMobBannerView)
    {
        // Create a view of the standard size at the bottom of the screen.
        adMobBannerView = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0.0,
                                                    self.view.frame.size.height -
                                                    GAD_SIZE_320x50.height,
                                                    GAD_SIZE_320x50.width,
                                                    GAD_SIZE_320x50.height)];
        
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        adMobBannerView.adUnitID = @"YOUR_ID";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        adMobBannerView.rootViewController = self;
        [self.view addSubview:adMobBannerView];
    }
}

-(void)initiAdBanner
{
    if (!iAdBannerView)
    {
        // Get the size of the banner in portrait mode
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        // Create a new bottom banner, will be slided into view
        iAdBannerView = [[ADBannerView alloc]initWithFrame:CGRectMake(0.0,
                                                                      self.view.frame.size.height,
                                                                      bannerSize.width,
                                                                      bannerSize.height)];
        iAdBannerView.delegate = self;
        iAdBannerView.hidden = TRUE;
        [self.view addSubview:iAdBannerView];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initiAdBanner];
    [self initAdMobBanner];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [iAdBannerView release];
    [adMobBannerView release];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Animation

-(void)hideBanner:(UIView*)banner
{
    if (banner &&
        ![banner isHidden])
    {
        [UIView beginAnimations:@"animatedBannerOff" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = TRUE;
    }
}

-(void)showBanner:(UIView*)banner
{
    if (banner &&
        [banner isHidden])
    {
        [UIView beginAnimations:@"animatedBannerOn" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = FALSE;
    }
}

#pragma mark - AdMob Banner

- (void)adViewDidReceiveAd:(GADBannerView *)banner
{
    NSLog(@"AdMob banner received");
    
    if ([iAdBannerView isHidden]) {
        [self showBanner:banner];
    }
}

- (void)adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error;
{
    NSLog(@"AdMob banner failed");
    
    [self hideBanner:banner];
}

- (void)adMobRequest
{
    // Initiate a generic request to load it with an ad.
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID, // Simulator
                           nil];
    [adMobBannerView loadRequest:[GADRequest request]];
}

#pragma mark - iAd Banner

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAdBanner loaded");
    
    [self hideBanner:adMobBannerView];
    [self showBanner:iAdBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAdBanner failed");
    
    // Only request adMob when iAd did fail
    [self adMobRequest];
    [self hideBanner:iAdBannerView];
    [self showBanner:adMobBannerView];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view action begins");
    
    return YES;
    
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"Banner view action did finish");
    
}

@end
