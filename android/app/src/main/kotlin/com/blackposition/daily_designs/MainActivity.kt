package com.blackposition.dailydesigns

import android.view.WindowManager;
import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle;


class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
        super.onCreate(savedInstanceState)
    }

}

