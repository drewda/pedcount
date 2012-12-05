PedCount
========

Smartphone app for counting pedestrians, which connects to an instance of [the hosted Web application PedCount/PedPlus](https://github.com/s3sol/pedplus). Built using [PhoneGap](http://www.phonegap.com) (also known as Apache Cordova), which generates native apps for iPhone and Android.

This repo includes three different pieces:

- HTML/CSS/JavaScript files generated by a Middleman application in `/source`
- iPhone native application project in `/project-ios`
- Android native application project in `/project-android`

The HTML/CSS/JavaScript is symlinked into the iOS and Android projects following instructions at:
http://www.tricedesigns.com/2012/02/16/linked-source-files-across-phonegap-projects-on-osx/

**NOTE**: This software is not entirely finished or polished. It's never actually been compiled and posted to the App Store (for iPhone) or Google Play (for Android).

General Prerequisites
---------------------

- Have Ruby 1.9.3 installed on your computer (most easily done using [RVM](https://rvm.io/rvm/install/) **or** [rbenv](https://github.com/sstephenson/rbenv) and [ruby-build](https://github.com/sstephenson/ruby-build)). Middleman requires Ruby to build the final package of HTML, CSS, and JavaScript files.

- You'll need to run your own instance of the PedCount/PedPlus Web application. Put its URL in `source/javascripts/smartphone.coffee` as the "host" so that your version of the mobile app(s) will try to connect with the right server.


iPhone Prerequisites
--------------------

- Sign up for the [Apple iOS Developer Program](https://developer.apple.com/programs/ios/).

- Install [the Apple XCode](https://developer.apple.com/xcode/) integrated development environment] and afterwards use XCode to download its optional components, including the "command line tools."

Android Prerequisites
---------------------

- Download and install [the entire Android SDK package for beginners](http://developer.android.com/sdk/index.html), which includes a copy of [Eclipse](http://eclipse.org/) (its default integrated development environment).

- Sign up as a [developer for the Google Play store](https://play.google.com/apps/publish/signup).
