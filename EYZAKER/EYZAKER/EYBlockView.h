//
//  EYBlockView.h
//  EYZAKER
//
//  Created by mac on 14-9-28.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYBlockView : UIControl


@property (nonatomic, strong)NSString *clickURL;

- (void)setViewWithTitle:(NSString *)title image:(NSString *)imgURL color:(NSString *)color;

@end
