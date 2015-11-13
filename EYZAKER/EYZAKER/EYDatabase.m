

#import "EYDatabase.h"
#import "FMDatabase.h"

@interface EYDatabase ()

@property (nonatomic, strong)FMDatabase *myDatabase;

@end

@implementation EYDatabase

static EYDatabase *database = nil;

- (id)init
{
    if (self = [super init]) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@"myDatabase.db"];
        NSLog(@"%@",path);
        self.myDatabase = [FMDatabase databaseWithPath:path];
        if (![self.myDatabase open]) {
            return nil;
        }
        NSString *sql = @"create table if not exists HotArticles(Id integer primary key autoincrement, title text, autherName text, iconURL text, date text, clickURL text, singleImageURL text, oneImageURL text, twoImageURL text, threeImageURL text, titleLableHight float, showOneImage boolean, noneImage boolean)";
        [self.myDatabase executeUpdate:sql];
    }
    return self;
}

- (void)insertData:(EYDailyHotModal *)article
{
    if (article.noneImage) {
        NSString *sql = @"insert into HotArticles (title, autherName, iconURL, date, clickURL, titleLableHight, showOneImage boolean, noneImage boolean) values (?,?)";
    }
    NSString *sql = @"insert into Movies (title text, autherName text, iconURL text, date text, clickURL text, singleImageURL text, oneImageURL text, twoImageURL text, threeImageURL text, float titleLableHight, showOneImage boolean, noneImage boolean) values (?,?)";
//    [self.myDatabase executeUpdate:sql,article.title,article.imageURL];
}

- (void)closeDatabase
{
    [self.myDatabase close];
}

+ (EYDatabase *)sharedEYDatabase
{
    @synchronized(self)
    {
        if (database == nil) {
            database = [[EYDatabase alloc] init];
        }
        return database;
    }
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (database == nil) {
        database = [super allocWithZone:zone];
    }
    return database;
}

@end
