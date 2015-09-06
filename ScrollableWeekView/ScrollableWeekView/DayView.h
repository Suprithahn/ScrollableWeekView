//
//  DayView.h
//  ScrollableWeekView
//
//  Created by Suprithahn on 05/08/15.
//

#import <UIKit/UIKit.h>

@interface DayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (nonatomic, strong) NSDate *date;

@end
