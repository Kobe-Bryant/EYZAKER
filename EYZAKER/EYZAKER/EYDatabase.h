

#import <Foundation/Foundation.h>
#import "EYDailyHotModal.h"

@interface EYDatabase : NSObject
//单例
+ (EYDatabase *)sharedEYDatabase;
//写入一条数据
- (void)insertData:(EYDailyHotModal *)article;
//得到所有数据
- (NSArray *)getArticles;
- (void)closeDatabase;
@end
