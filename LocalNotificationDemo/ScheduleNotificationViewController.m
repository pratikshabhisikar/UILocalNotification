//
//  ScheduleNotificationViewController.m
//  LocalNotificationDemo

#import "ScheduleNotificationViewController.h"

@implementation ScheduleNotificationViewController

#pragma mark - View controller life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    rootView.backgroundColor = [UIColor whiteColor];
    
    // Create the input accessory view for the text field.
    UIToolbar *datePickerAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, rootView.bounds.size.width, 40)];
    datePickerAccessoryView.barStyle = UIBarStyleBlack;
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [datePickerAccessoryView setItems:[NSArray arrayWithObject:doneButtonItem]];
    
    // Create the input view for the text field.
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker addTarget:self action:@selector(valueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // Create the text field.
    scheduleTextField = [[UITextField alloc] initWithFrame:CGRectMake(rootView.bounds.size.width/2 - 100, rootView.bounds.size.height/2 - 15 - 50, 200, 30)];
    scheduleTextField.borderStyle = UITextBorderStyleRoundedRect;
    scheduleTextField.textAlignment = UITextAlignmentCenter;
    scheduleTextField.placeholder = @"Enter here";
    scheduleTextField.inputView = datePicker;
    scheduleTextField.inputAccessoryView = datePickerAccessoryView;
    
    [rootView addSubview:scheduleTextField];
    
    self.view = rootView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    // Release any cached data, images, etc that aren't in use.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];
}

#pragma mark - Action Events

-(void) doneButtonPressed:(id) sender {
    // Get the fire date.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSDate *fireDate = [dateFormatter dateFromString:scheduleTextField.text];
    
    // Cancel the previously scheduled notification, if any.
    if (localNotification != nil) {
    	[[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        localNotification.applicationIconBadgeNumber--;
    }
    
    // Schedule new local notification.
    localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"This is notification demo";
    localNotification.alertAction = @"See Me";
    localNotification.fireDate = fireDate;
    localNotification.soundName = @"bark.wav";
    localNotification.applicationIconBadgeNumber++;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [scheduleTextField resignFirstResponder];
}

-(void)valueDidChange:(id) sender {
    UIDatePicker *datePicker = (UIDatePicker *) sender;
    
    // Format the date.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *pickerDateString = [dateFormatter stringFromDate:datePicker.date];
    scheduleTextField.text = pickerDateString;
}

@end
