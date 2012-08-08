package com.s3sol.pedcount;

import org.apache.cordova.*;
import android.os.Bundle;

public class MainActivity extends DroidGap {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        super.loadUrl("file:///android_asset/www/src/index.html");
    }
}
