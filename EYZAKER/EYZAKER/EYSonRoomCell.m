//
//  EYSonRoomCell.m
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYSonRoomCell.h"

@interface EYSonRoomCell ()

@property (nonatomic, strong)EYSonRoomModal *modal;

@end

@implementation EYSonRoomCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setCellWithModal:(EYSonRoomModal *)modal
{
    //避免cell复用的作用
    self.markButton.selected = NO;
    //遍历，判断用户是否订阅
    NSArray *customBlocks = [[NSArray alloc] initWithContentsOfFile:[self getCustomBlocksPath]];
    if (customBlocks.count > 0) {
        for (NSDictionary *block in customBlocks) {
            NSString *str = block[@"title"];
            if ([str isEqualToString:modal.title]) {
                self.markButton.selected = YES;
            }
        }
    }
    
    self.titleLable.text = modal.title;
    [self.markButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    self.modal = modal;
}

- (void)select:(UIButton *)sender
{
    self.markButton.selected = !self.markButton.selected;
    //判断是否存在customBlocks.plist文件
    NSMutableArray *customBlocks;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:[self getCustomBlocksPath]]) {
        customBlocks = [[NSMutableArray alloc] initWithContentsOfFile:[self getCustomBlocksPath]];
    }
    else {
        customBlocks = [NSMutableArray array];
    }
    if (self.markButton.selected) { //增加
        [customBlocks addObject:self.modal.blockInfo];
        [customBlocks writeToFile:[self getCustomBlocksPath] atomically:YES];
    } else {  //删除
        if (customBlocks.count > 0) {
            for (NSDictionary *block in customBlocks) {
                NSString *str = block[@"title"];
                if ([str isEqualToString:self.modal.blockInfo[@"title"]]) {
                    [customBlocks removeObject:block];
                    break;
                }
            }
        }
//        [customBlocks removeObject:self.modal.blockInfo];  //弃用，防止blockInfo与文件内容的键值对不一样
        [customBlocks writeToFile:[self getCustomBlocksPath] atomically:YES];
    }
}

#pragma mark - 获得customBlocks.plist的路径
- (NSString *)getCustomBlocksPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = pathArray[0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"customBlocks.plist"];
    return path;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
