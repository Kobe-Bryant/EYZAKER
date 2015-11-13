//
//  EYBestRowView.h
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYBestRowView : UIControl

//API
@property (strong, nonatomic) NSString *clickURL;

- (void)setRowViewWithDictionary:(NSDictionary *)best;

@end
