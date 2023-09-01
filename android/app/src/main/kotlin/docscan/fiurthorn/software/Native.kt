package docscan.fiurthorn.software

import android.content.ContentValues
import android.content.Context
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.net.URL

class Native : AutoCloseable {
    var context: Context
    var channel: MethodChannel
    var flutterEngine: FlutterEngine

    constructor(context: Context, flutterEngine: FlutterEngine) {
        this.context = context
        this.flutterEngine = flutterEngine
        this.channel = initChannel()
    }

    private fun initChannel(): MethodChannel {
        var channel =
                MethodChannel(
                        flutterEngine.getDartExecutor().getBinaryMessenger(),
                        "flutter.native/helper"
                )
        channel.setMethodCallHandler { call, result ->
            try {
                handleMethodCall(call, result)
            } catch (e: Exception) {
                result.error(e.message!!, call.method, null)
            }
        }
        return channel
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "saveFileInMediaStore" -> {
                result.success(
                        saveFileInMediaStore(
                                call.argument<String>("input")!!,
                                call.argument<String>("folder")!!,
                                call.argument<String>("fileName")!!,
                        )
                )
            }
            "getAppConfigurationDir" -> result.success(getAppConfigurationDir())
            "flavor" -> result.success(BuildConfig.flavor)
            "getTempDir" -> result.success(getTempDir())
            else -> result.notImplemented()
        }
    }

    override fun close() {
        channel.setMethodCallHandler(null)
    }

    private fun getTempDir(): String {
        return context.getCacheDir().absolutePath
    }

    private fun getAppConfigurationDir(): String {
        return context.getFilesDir().absolutePath
    }

    private fun getMimeType(path: String): String {
        var type = "application/octet-stream"

        val extension = MimeTypeMap.getFileExtensionFromUrl(path)
        if (extension != null) {
            val mimeMap = MimeTypeMap.getSingleton()
            if (mimeMap.hasExtension(extension)) {
                type = mimeMap.getMimeTypeFromExtension(extension)!!
            }
        }

        return type
    }

    private fun saveFileInMediaStore(inputUrl: String, folder: String, fileName: String): Boolean {
        val contentValues =
                ContentValues().apply {
                    put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                    put(MediaStore.MediaColumns.MIME_TYPE, getMimeType(fileName))
                    put(
                            MediaStore.MediaColumns.RELATIVE_PATH,
                            "${Environment.DIRECTORY_DOWNLOADS}/${folder}"
                    )
                }
        val resolver = context.contentResolver
        val outputUrl = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)

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
