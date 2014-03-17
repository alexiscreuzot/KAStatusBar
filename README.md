#KAStatusBar

An ultra-light status bar status bar notification/alert library.

![KAStatusBar](http://i.imgur.com/UjfjjEm.gif)

##Install

###Normal install

* Just copy the `KAStatusBar/KAStatusBar` folder into your project.
* Import KAStatusBar.h from your .pch file

###Using [cocoapods](http://cocoapods.org)

add this line to your Podfile :
`pod 'KAStatusBar'`

##Usage

Here is the self-explanatory API. If you don't specify any delay to remove notification, it becomes indeterminate and displays an UIActivityIndicator on the left of your status.

```objective-c
+ (void)showWithStatus:(NSString*)status barColor:(UIColor*)color andRemoveAfterDelay:(NSNumber *) delay;
+ (void)showWithStatus:(NSString*)status andRemoveAfterDelay:(NSNumber *) delay;
+ (void)showWithStatus:(NSString*)status andBarColor:(UIColor*)color;
+ (void)showWithStatus:(NSString*)status;
+ (void)dismiss;
```

