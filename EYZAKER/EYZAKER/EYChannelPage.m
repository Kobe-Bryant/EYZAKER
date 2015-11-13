//
//  EYChannelPage.m
//  EYZAKER
//
//  Created by mac on 14-9-30.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYChannelPage.h"
#import "UIImageView+WebCache.h"
#import "EYChannelPageModal.h"

@interface EYChannelPage ()

@property (nonatomic, strong)UILabel *pageLable;

@end

@implementation EYChannelPage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)finishView
{
    [self addSubview:[self createNavigationBar]];
    [self createMainView];
}

#pragma mark - 创建导航
- (UIImageView *)createNavigationBar
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"toolbar_bg"];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 32, 32)];
    backImage.image = [UIImage imageNamed:@"addRootBlock_toolbar_return"];
    [view addSubview:backImage];
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [backImage addGestureRecognizer:tap];
    
    UIImageView *mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
    [mainImageView sd_setImageWithURL:[NSURL URLWithString:self.mainImageURL]];
    [view addSubview:mainImageView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, 310, 20)];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentRight;
    lable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:13];
    lable.text = self.name;
    [view addSubview:lable];
    
    return view;
}

- (void)createMainView
{
    //第一个有图的block
    EYChannelPageModal *modal1 = self.pageData[0];
    EYPageBlock *firstBlock = [[EYPageBlock alloc] initWithFrame:CGRectMake(0, 64, 320, 160)];
    firstBlock.url = modal1.clickURL;
    NSLog(@"modal1 url   %@", modal1.clickURL);
    [firstBlock addTarget:self action:@selector(pushWeb:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *firstItem= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    if (modal1.imageURL) {
        [firstItem sd_setImageWithURL:[NSURL URLWithString:modal1.imageURL]];
        firstItem.contentMode = UIViewContentModeScaleAspectFill;
        firstItem.clipsToBounds = YES;
        UILabel *firstTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 135, 300, 20)];
        firstTitleLable.text = modal1.title;
        firstTitleLable.textColor = [UIColor whiteColor];
        firstTitleLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:15];
        [firstItem addSubview:firstTitleLable];
    }
    else {
        firstItem.backgroundColor = self.bgColor;
        UILabel *firstTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 300, 80)];
        firstTitleLable.text = modal1.title;
        firstTitleLable.numberOfLines = 0;
        firstTitleLable.textColor = [UIColor whiteColor];
        firstTitleLable.font = [UIFont fontWithName:@"FZLanTingHei-DB-GBK" size:18];
        [firstItem addSubview:firstTitleLable];
    }
    [firstBlock addSubview:firstItem];
    [self addSubview:firstBlock];
    
    for (NSInteger i = 1; i < 5; i ++) {
        EYChannelPageModal *modal = self.pageData[i];
        EYPageBlock *block = [[EYPageBlock alloc] initWithFrame:CGRectMake(0, 0, 149.5, 80)];
        block.url = modal.clickURL;
        [block addTarget:self action:@selector(pushWeb:) forControlEvents:UIControlEventTouchUpInside];
        //标题
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 129.5, 10)];
        titleLable.text = modal.title;
        titleLable.numberOfLines = 0;
        titleLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:14];
        titleLable.adjustsFontSizeToFitWidth = YES;
        CGFloat hight = [self getHightWith:titleLable.text font:titleLable.font width:129];
        CGRect rect = titleLable.frame;
        rect.size.height = hight;
        titleLable.frame = rect;
//        CGPoint point = CGPointMake(149.5 / 2, 35 - (hight / 2));
        [block addSubview:titleLable];
        //小标题
        UILabel *fromLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLable.frame), 120, 10)];
        fromLable.textColor = [UIColor darkGrayColor];
        fromLable.font = [UIFont systemFontOfSize:10];
        fromLable.text = modal.autherName;
        [block addSubview:fromLable];
        
        switch (i) {
            case 1:
                block.frame = CGRectMake(10, 224, 149.5, 80);
                break;
            case 2:
                block.frame = CGRectMake(160.5, 224, 149.5, 80);
                break;
            case 3:
                block.frame = CGRectMake(0, 304, 149.5, 80);
                break;
            case 4:
                block.frame = CGRectMake(160.5, 304, 149.5, 80);
                break;
                
            default:
                break;
        }
        [self addSubview:block];
    }
    EYChannelPageModal *modal2 = self.pageData[5];
    EYPageBlock *lastBlock = [[EYPageBlock alloc] initWithFrame:CGRectMake(10, 384, 320, 80)];
    lastBlock.url = modal2.clickURL;
    [lastBlock addTarget:self action:@selector(pushWeb:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastBlock];

    UILabel *lastTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 10)];
    lastTitleLable.text = modal2.title;
    lastTitleLable.numberOfLines = 0;
    lastTitleLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:14];
    lastTitleLable.adjustsFontSizeToFitWidth = YES;
    CGFloat hight = [self getHightWith:lastTitleLable.text font:lastTitleLable.font width:300];
    CGRect rect = lastTitleLable.frame;
    rect.size.height = hight;
    lastTitleLable.frame = rect;
    [lastBlock addSubview:lastTitleLable];
    
    UILabel *lastFromLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastTitleLable.frame), 120, 10)];
    lastFromLable.textColor = [UIColor darkGrayColor];
    lastFromLable.font = [UIFont systemFontOfSize:10];
    lastFromLable.text = modal2.autherName;
    [lastBlock addSubview:lastFromLable];
    
    UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(159.5, 229, 0.5, 155)];
    vline.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self addSubview:vline];
    
    UIView *hline1 = [[UIView alloc] initWithFrame:CGRectMake(5, 304, 310, 0.5)];
    hline1.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self addSubview:hline1];
    
    UIView *hline2 = [[UIView alloc] initWithFrame:CGRectMake(5, 384, 310, 0.5)];
    hline2.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self addSubview:hline2];
    
    UIView *hline3 = [[UIView alloc] initWithFrame:CGRectMake(5, 464, 310, 0.5)];
    hline3.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self addSubview:hline3];
    
    self.pageLable = [[UILabel alloc] initWithFrame:CGRectMake(235, 459, 50, 10)];
    self.pageLable.backgroundColor = [UIColor whiteColor];
    self.pageLable.tag = 10;
    self.pageLable.font = [UIFont systemFontOfSize:10];
    self.pageLable.textColor = [UIColor darkGrayColor];
    self.pageLable.text = @"$$$$$";
    self.pageLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.pageLable];

}
//设置当前页数
- (void)setPageWithPageCount:(NSInteger)count
{
    self.pageLable.text = [NSString stringWithFormat:@"%d/%d", self.currentPage, count];

}

- (CGFloat)getHightWith:(NSString *)text font:(UIFont *)font width:(CGFloat)width
{
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {
        CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
        return rect.size.height;
    }
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 60)];
    return size.height;
}

- (void)back
{
    if ([self.delegate respondsToSelector:@selector(responseBack)]) {
        [self.delegate responseBack];
    }
}

- (void)pushWeb:(EYPageBlock *)block
{
    if ([self.delegate respondsToSelector:@selector(didSelectedBlock:)]) {
        [self.delegate didSelectedBlock:block];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
