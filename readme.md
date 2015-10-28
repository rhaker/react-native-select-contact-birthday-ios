# react-native-select-contact-birthday-ios

This is a module for react-native where you select a contact from the address book and a birthday is returned. The module uses async promises. This is for ios8 and higher.

# Add it to your project

npm install react-native-select-contact-birthday-ios --save

In XCode, in the project navigator, right click Libraries ➜ Add Files to [your project's name]

Go to node_modules ➜ react-native-select-contact-birthday-ios and add RNSelectContactBirthday.xcodeproj

In XCode, in the project navigator, select your project. Add libRNSelectContactBirthday.a to your project's Build Phases ➜ Link Binary With Libraries

Click RNSelectContactBirthday.xcodeproj in the project navigator and go the Build Settings tab. Make sure 'All' is toggled on (instead of 'Basic'). Look for Header Search Paths and make sure it contains both $(SRCROOT)/../react-native/React and $(SRCROOT)/../../React - mark both as recursive.

Run your project (Cmd+R)

Setup trouble?

If you get stuck, take a look at Brent Vatne's blog. His blog is my go to reference for this stuff.

# Api Setup

var React = require('react-native');

var { NativeModules } = React;

var { RNSelectContactBirthday } = NativeModules;

async _selectBirthday() {

  try {

    let value = await RNSelectContactBirthday.selectBirthday(true);

    console.log('Birthday: ' + value);

  } catch (error) {

    console.log('Error: ' + error.message);

  }
},

# Additional Notes

The birthday will be resolved even if it does not exist, so you should check for the case where value is null, empty, or undefined.

# Error Callback

The following will cause an error callback (use the console.log to see the specific message):

1) Ios8 or higher is not being used

2) User denies access to the addressbook

# Known Issues

Running in the simulator (especially on first install) sometimes causes an irreproducible crash before the Contacts Picker even appears.

This issue is described here: http://stackoverflow.com/questions/28592891/error-when-try-to-open-contacts

Try rebuilding the app if this occurs.

This module needs to be updated to support the new ios9 Contacts framework.

# Acknowledgements

Special thanks to James Ide for his post on async modules. Special thanks to spikef for his react-native-phone-picker. Thanks to Brent Vatne for his posts on creating a react native packager. Some portions of this code have been based on answers from stackoverflow. This package also owes a special thanks to the tutorial by Jay Garcia at Modus Create on how to create a custom react native module.
