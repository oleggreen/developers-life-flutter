package com.marchelo.developerslife_flutter;

import io.flutter.app.FlutterApplication;

public class DevLifeFlutterApp extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();

        if (BuildConfig.DEBUG) {
            com.facebook.stetho.Stetho.initializeWithDefaults(this);
        }
    }
}