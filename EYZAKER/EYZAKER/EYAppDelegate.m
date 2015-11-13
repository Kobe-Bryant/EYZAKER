//
//  EYAppDelegate.m
//  EYZAKER
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYAppDelegate.h"
#import "EYSubscriptionViewController.h"
#import "EYDailyHotViewController.h"
#import "EYExploreViewController.h"
#import "EYProfileViewController.h"
#import "EYRequest.h"

@interface EYAppDelegate ()<EYRequestDelegate>

@end

@implementation EYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self createRequest];
    
    
#warning 时间
    NSTimeInterval timeri = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%lf",timeri);
    
    
    EYSubscriptionViewController *subscription = [[EYSubscriptionViewController alloc] init];
    EYDailyHotViewController *dailyHot = [[EYDailyHotViewController alloc] init];
    EYExploreViewController *explore = [[EYExploreViewController alloc] init];
    EYProfileViewController *profile = [[EYProfileViewController alloc] init];
    
    UINavigationController *subscriptionNav = [[UINavigationController alloc] initWithRootViewController:subscription];
    UINavigationController *dailyHotNav = [[UINavigationController alloc] initWithRootViewController:dailyHot];
    UINavigationController *exploreNav = [[UINavigationController alloc] initWithRootViewController:explore];
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profile];
    subscriptionNav.navigationBar.hidden = YES;
    dailyHotNav.navigationBar.hidden = YES;
    exploreNav.navigationBar.hidden = YES;
    profileNav.navigationBar.hidden = YES;
     
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UITabBarController *tabBarcontrolller = [[UITabBarController alloc] init];
    tabBarcontrolller.viewControllers = @[subscriptionNav, dailyHotNav, exploreNav, profileNav];
    tabBarcontrolller.tabBar.translucent = NO;
    
    
    tabBarcontrolller.tabBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar_bg"]];
    
    self.window.rootViewController = tabBarcontrolller;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)createRequest
{
    
    EYRequest *request = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:@"http://sns.myzaker.com/global_message.php?_appid=AndroidPhone&_version=4.51"]];
    request.delagate = self;
    [request startAsynchronous];
}

- (void)requestDidFinish:(EYRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *promotionDic = dic[@"data"][@"messages"][2];
    NSString *promotion = promotionDic[@"refresh_key"];
    
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:promotion forKey:@"promotion"];
    [userDefaults synchronize];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
