package com.kyf.flutter.wan_android

import android.os.Bundle
import android.view.KeyEvent
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    var isQuit = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
//        if (keyCode == KeyEvent.KEYCODE_BACK) {
//            return if (!isQuit) {
//                isQuit = true
//                Toast.makeText(this, "再按一次退出程序", Toast.LENGTH_SHORT).show()
//                val timer = Timer()
//                timer.schedule(timerTask { isQuit = false }, 2000)
//                false
//            } else {
//                super.onKeyDown(keyCode, event)
//            }
//        }
        return super.onKeyDown(keyCode, event)
    }
}
