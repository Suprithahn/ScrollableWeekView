//
//  CustomScroll.m
//  WeekViewSample
//
//  Created by Suprithahn on 03/08/15.
// 
//

#import "CustomScroll.h"
#import "WeekView.h"

@interface CustomScroll ()<WeekViewDelegate>

@property (nonatomic, retain) NSCalendar *gregorianCal;
@property (nonatomic, retain) WeekView *weekOne;
@property (nonatomic, retain) WeekView *weekTwo;
@property (nonatomic, retain) WeekView *weekThree;
@property (nonatomic, retain) NSMutableArray *weekArray;

@end

@implementation CustomScroll

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        self.gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.pagingEnabled = YES;
    }
    return self;
}

- (void) buildWeekViewsWithSelectedDate:(NSDate *)date{
    
    
    for(WeekView *view in [self subviews]){
        [view removeFromSuperview];
    }
    if ([_weekArray count]>0) {
        [_weekArray removeAllObjects];
    }
    
    self.selectedDate = date;
    
    CGSize scrollViewSize = self.bounds.size;
    
    _weekOne = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height)];
    _weekOne.tag = 1;
    _weekOne.delegate = self;
    _weekOne.weekStartDate = [self starDateForPreviousWeekWithSelectedDate:date];
    [self addSubview:_weekOne];
    
    _weekTwo = [[WeekView alloc] initWithFrame:CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height)];
    _weekTwo.tag = 2;
    _weekTwo.delegate =self;
    _weekTwo.weekStartDate = [self dateByAddingDays:7 toDate:_weekOne.weekStartDate];
    [self addSubview:_weekTwo];
    
    _weekThree = [[WeekView alloc] initWithFrame:CGRectMake(scrollViewSize.width*2, 0, scrollViewSize.width, scrollViewSize.height)];
    _weekThree.tag = 3;
    _weekThree.delegate = self;
    _weekThree.weekStartDate = [self dateByAddingDays:7 toDate:_weekTwo.weekStartDate];
    [self addSubview:_weekThree];
    
    _weekArray =[NSMutableArray arrayWithObjects:_weekOne,_weekTwo,_weekThree ,nil];
}

- (void)rebuildViews{
    
    CGPoint currentContentOffset = [self contentOffset];
    if (currentContentOffset.x >= self.bounds.size.width*2) {
        
        for(WeekView *view in [self subviews]){
            CGRect frame;
            switch (view.tag) {
                    
                case 1:
                {
                    frame = view.frame;
                    frame.origin.x = self.bounds.size.width*2;
                    view.frame = frame;
                    view.tag = 3;
                    WeekView *weekView =_weekArray [2];
                    view.weekStartDate = [self dateByAddingDays:7 toDate:weekView.weekStartDate];
                }
                    
                    break;
                case 2:
                case 3:
                {
                    frame = view.frame;
                    frame.origin.x -= self.bounds.size.width;
                    view.frame = frame;
                    view.tag = view.tag - 1;

                }
                    break;
                default:
                    break;
            }
        }
        [self updateWeekArrayWithRotation:YES];
        
    }else if (currentContentOffset.x <= 0){
        
        for(WeekView *view in [self subviews]){
            CGRect frame;
            switch (view.tag) {
                    
                case 1:
                case 2:
                {
                    frame = view.frame;
                    frame.origin.x += self.bounds.size.width;
                    view.frame = frame;
                    view.tag = view.tag + 1;
                }
                    break;
            
                case 3:
                    
                {
                    frame = view.frame;
                    frame.origin.x = 0;
                    view.frame = frame;
                    view.tag = 1;
                    WeekView *weekView =_weekArray [0];
                    view.weekStartDate = [self dateByAddingDays:-7 toDate:weekView.weekStartDate];

                }
                
                    break;
                default:
                    break;
            }
        }

        [self updateWeekArrayWithRotation:NO];
    }
}

- (void)updateWeekArrayWithRotation:(BOOL)isClockWise{
    
    if (isClockWise) {
        WeekView *temp =_weekArray [0];
        _weekArray [0] = _weekArray [1];
        _weekArray [1] = _weekArray [2];
        _weekArray [2] = temp;
        
    }else{
        WeekView *temp = _weekArray [2];
        _weekArray [2] = _weekArray [1];
        _weekArray [1] = _weekArray [0];
        _weekArray [0] = temp;
    }
}

-(void)layoutSubviews{
    
    if (![[self subviews] count]) {
        [self buildWeekViewsWithSelectedDate:[NSDate date]];
        self.contentSize = CGSizeMake(self.bounds.size.width*3, self.contentSize.height);
        self.contentOffset = CGPointMake(self.bounds.size.width, 0);
    }
}

- (NSDate *)starDateForPreviousWeekWithSelectedDate:(NSDate *)selectedDate{

    NSDateComponents *currentDateComponents = [self.gregorianCal components:NSCalendarUnitWeekday fromDate:selectedDate];
    NSInteger daysToGoBack = 0;
    if ([currentDateComponents weekday] > DayTypeSunday) {
        
        daysToGoBack = ([currentDateComponents weekday] - DayTypeSunday)+7;
    }
  
    return [self dateByAddingDays:-daysToGoBack toDate:selectedDate];
}

-(NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate*)date{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    return [self.gregorianCal dateByAddingComponents:dateComponents toDate:date options:0];
}

- (void) weekViewScolledIndirection:(BOOL)isRight{
    
    if (isRight) {
        
        WeekView *week = _weekArray[1];
        [week setWeekViewWithSelectedDate:[self dateByAddingDays:-7 toDate:self.selectedDate]];
        week = _weekArray[2];
        [week clearSelection];
        
    }else{
        
        WeekView * week = _weekArray[1];
        [week setWeekViewWithSelectedDate:[self dateByAddingDays:7 toDate:self.selectedDate]];
        week = _weekArray[0];
        [week clearSelection];
    }
}

#pragma WeekViewDelegates

-(void)WeekView:(WeekView *)weekView didSelectDate:(NSDate *)dateSelecetd{
    
    self.selectedDate = dateSelecetd;
    if ([self.WeekSelectorDelegate respondsToSelector:@selector(weekSelectorDidSelectDate:)]) {
        [self.WeekSelectorDelegate weekSelectorDidSelectDate:dateSelecetd];
    }
}

@end
