package docscan.fiurthorn.software

import android.os.Bundle
import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val channel =
                MethodChannel(
                        flutterEngine!!.getDartExecutor().getBinaryMessenger(),
                        "flutter.native/helper"
                )

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getDownloadsDirectory" -> result.success(getDownloadsDirectory())
                "getLibraryDirectory" -> result.success(getLibraryDirectory())
                else -> result.notImplemented()
            }
        }
    }

    private fun getDownloadsDirectory(): String {
        return Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                .getAbsolutePath()
    }

    private fun getLibraryDirectory(): String {
        return getContext().getFilesDir().path
    }
}
