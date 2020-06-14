package com.jideguru.restaurant_ui_kit

import android.os.Build
import android.os.Bundle
import android.view.ViewTreeObserver
import android.view.WindowManager
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class MainActivity : FlutterActivity(), PluginRegistrantCallback {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    FlutterFirebaseMessagingService.setPluginRegistrant(this)
    val flutter_native_splash = true
    var originalStatusBarColor = 1
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        originalStatusBarColor = window.statusBarColor
        window.statusBarColor = 0xffeaeaea.toInt()
    }
    val originalStatusBarColorFinal = originalStatusBarColor

    GeneratedPluginRegistrant.registerWith(this)
    val vto = flutterView.viewTreeObserver
    vto.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
      override fun onGlobalLayout() {
        flutterView.viewTreeObserver.removeOnGlobalLayoutListener(this)
        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
          window.statusBarColor = originalStatusBarColorFinal
        }
      }
    })
  }
  override fun registerWith(registry: PluginRegistry) {
    FirebaseCloudMessagingPluginRegistrant.registerWith(registry)
}
}
