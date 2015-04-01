# WBTouchID
WBTouchID is easy drop in solution for using Touch ID in your iPhone application

Simply add email to MailChimp list

# Installation
1. Copy files to your project
2. Change kWBTouchIdReason if you want (it's text, which will be in Touch ID alert)
3. Call:
```obj-c
[WBTouchID validateTouchId:^(BOOL success,NSError *err){
    if (success) {
        NSLog(@"Autheticated successfully");
    } else {
        NSLog(@"Failed to authenticate: %@",err.localizedDescription);
    }
}];
```
