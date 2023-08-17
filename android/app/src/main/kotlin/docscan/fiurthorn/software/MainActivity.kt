package docscan.fiurthorn.software

import android.content.ContentValues
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.net.URL

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
            try {
                handleMethodCall(call, result)
            } catch (e: Exception) {
                result.error(e.message!!, call.method, null)
            }
        }
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "saveFileInMediaStore" -> {
                Log.d("argument", "${call.arguments}")
                result.success(
                        saveFileInMediaStore(
                                call.argument<String>("input")!!,
                                call.argument<String>("folder")!!,
                                call.argument<String>("fileName")!!,
                        )
                )
            }
            "getTempDir" -> result.success(getTempDir())
            "getLibraryDirectory" -> result.success(getLibraryDirectory())
            else -> result.notImplemented()
        }
    }

    private fun getTempDir(): String {
        return getContext().getCacheDir().absolutePath
    }

    private fun getLibraryDirectory(): String {
        return getContext().getFilesDir().absolutePath
    }

    fun getMimeType(path: String): String {
        var type = "apllication/occtett-stream"

        val extension = MimeTypeMap.getFileExtensionFromUrl(path)
        if (extension != null) {
            val mimeMap = MimeTypeMap.getSingleton()
            if (mimeMap.hasExtension(extension)) {
                type = mimeMap.getMimeTypeFromExtension(extension)!!
            }
        }

        return type
    }

    private fun saveFileInMediaStore(
            inputUrl: String,
            folder: String,
            fileName: String,
    ): Boolean {
        val contentValues =
                ContentValues().apply {
                    put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                    put(MediaStore.MediaColumns.MIME_TYPE, getMimeType(fileName))
                    put(
                            MediaStore.MediaColumns.RELATIVE_PATH,
                            "${Environment.DIRECTORY_DOWNLOADS}/${folder}"
                    )
                }
        val resolver = getContext().contentResolver
        val outputUrl = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)

        Log.d("input", "${inputUrl}")
        Log.d("output", "${outputUrl}")

        if (outputUrl != null) {
            URL("file://${inputUrl}").openStream().use { input ->
                resolver.openOutputStream(outputUrl).use { output ->
                    input.copyTo(output!!, DEFAULT_BUFFER_SIZE)
                }
            }
        }

        return true
    }
}
