//
//  TTVViewController.m
//  TestTableView
//
//  Created by feibo on 3/6/14.
//  Copyright (c) 2014 feibo. All rights reserved.
//

#import "TTVViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface TTVViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
- (void)updateViewWithOffset:(float)pOffset;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

@implementation TTVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,165, self.view.frame.size.width,60)];
        view.backgroundColor = [UIColor clearColor];
		view.delegate = self;
		[self.view insertSubview:view belowSubview:self.dataTableView];
		_refreshHeaderView = view;
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    self.dataTableView.backgroundColor = [UIColor clearColor];
    self.dataTableView.backgroundView = nil;
    self.dataTableView.clipsToBounds = YES;
    self.dataTableView.scrollIndicatorInsets = UIEdgeInsetsMake(160, 0, 0, 0);
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,320, 160)];
    [tempView setBackgroundColor:[UIColor clearColor]];
    self.dataTableView.tableHeaderView = tempView;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y <= 96) {
        CGRect frame = self.topView.frame;
        frame.origin.y = -scrollView.contentOffset.y;
        if (scrollView.contentOffset.y < 0) {
            frame.origin.y = 0;
        }
        self.topView.frame = frame;
        [self updateViewWithOffset:(96-fabs(frame.origin.y))/96];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.dataTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - private method
- (void)updateViewWithOffset:(float)pOffset {
    NSLog(@"offset:%.2f",pOffset);
    CGRect frame = self.titleLabel.frame;
    frame.origin.y = 20 + 73 + 20 *(1-pOffset);
    self.titleLabel.frame = frame;
    [self.titleLabel setFont:[UIFont systemFontOfSize:22+8*pOffset]];
    
    frame = self.iconImageView.frame;
    frame.origin.y = 25;
    self.iconImageView.frame = frame;
    
    frame = self.subTitleLabel.frame;
    frame.origin.y = 127;
    self.subTitleLabel.frame = frame;
    [self.subTitleLabel setAlpha:pOffset - 0.5];
    
}



@end
