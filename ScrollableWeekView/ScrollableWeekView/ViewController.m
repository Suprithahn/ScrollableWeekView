//
//  ViewController.m
//  ScrollableWeekView
//
//  Created by Suprithahn on 04/08/15.
// 
//

#import "ViewController.h"
#import "CustomScroll.h"

@interface ViewController ()< WeekSelectorDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet CustomScroll *weekScrollView;
@property (weak, nonatomic) IBOutlet UILabel *dateDisplayBoard;
@property (weak, nonatomic) IBOutlet UILabel *monthdisplayLabel;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) CGPoint previousScrollOffset;

- (IBAction)todayPressed:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weekScrollView.delegate = self;
    
    self.weekScrollView.WeekSelectorDelegate = self;
    [self weekSelectorDidSelectDate: [NSDate date]];
    self.previousScrollOffset = CGPointMake(self.weekScrollView.bounds.size.width, 0);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)todayPressed:(id)sender {
    [_weekScrollView buildWeekViewsWithSelectedDate:[NSDate date]];
    [self weekSelectorDidSelectDate: [NSDate date]];
}

- (void)weekSelectorDidSelectDate:(NSDate *)selectedDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:selectedDate];
    [self.dateDisplayBoard setText:stringFromDate];
    
    [formatter setDateFormat:@"MM-YYYY"];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    [self.monthdisplayLabel setText:[formatter stringFromDate:selectedDate]];
    self.selectedDate = selectedDate;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));

    [self.weekScrollView rebuildViews];

    if (self.previousScrollOffset.x != scrollView.contentOffset.x) {

    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView];
    [self.weekScrollView weekViewScolledIndirection:(translation.x>0)];

    } else if (scrollView.contentOffset.x <= 0){

    [self.weekScrollView weekViewScolledIndirection:YES];

    } else if (scrollView.contentOffset.x >= scrollView.bounds.size.width*2){

    [self.weekScrollView weekViewScolledIndirection:NO];
        
    }
    scrollView.userInteractionEnabled = YES;
    self.previousScrollOffset=scrollView.contentOffset;
    self.weekScrollView.contentOffset = CGPointMake(self.weekScrollView.bounds.size.width, 0);
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    scrollView.userInteractionEnabled = NO;
}

@end
