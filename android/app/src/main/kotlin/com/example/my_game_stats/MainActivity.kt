package com.example.my_game_stats

import android.app.AppOpsManager
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Process
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.ArrayList

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.my_game_stats/usage";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAppUsage") {
                val usageData = getAppUsage();
                if (usageData != null) {
                    result.success(usageData);
                } else {
                    result.error("UNAVAILABLE", "Usage data not available", null);
                }
            } else if (call.method == "checkUsagePermission") {
                result.success(hasUsageStatsPermission())
            } else {
                result.notImplemented();
            }
        }
    }

    private fun getAppUsage(): java.util.List<Map<String, Any>>? {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val packageManager = packageManager
            val endTime = System.currentTimeMillis()
            val startTime = endTime - 24 * 60 * 60 * 1000 // Last 24 hours

            val usageStatsList = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                startTime,
                endTime
            )

            if (usageStatsList != null) {
                val appUsageData = mutableMapOf<String, MutableMap<String, Any>>()

                for (usageStats in usageStatsList) {
                    try {
                        val appInfo = packageManager.getApplicationInfo(usageStats.packageName, 0)
                        val appName = packageManager.getApplicationLabel(appInfo).toString()
                        val appIconDrawable = packageManager.getApplicationIcon(appInfo)
                        val appIconBitmap = drawableToBitmap(appIconDrawable)

                        // Convert Bitmap to ByteArray
                        val outputStream = ByteArrayOutputStream()
                        appIconBitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                        val appIconByteArray = outputStream.toByteArray()

                        if (!appUsageData.containsKey(usageStats.packageName)) {
                            appUsageData[usageStats.packageName] = mutableMapOf(
                                "packageName" to usageStats.packageName,
                                "appName" to appName,
                                "timeInForeground" to usageStats.totalTimeInForeground,
                                "appIcon" to appIconByteArray
                            )
                        } else {
                            // Update time in foreground if already exists
                            val existingData = appUsageData[usageStats.packageName]!!
                            existingData["timeInForeground"] =
                                (existingData["timeInForeground"] as Long) + usageStats.totalTimeInForeground
                        }
                    } catch (e: PackageManager.NameNotFoundException) {
                        // Skip apps that are not found
                    }
                }

                return ArrayList<Map<String, Any>>(appUsageData.values.map { it.toMap() }) as java.util.List<Map<String, Any>>?
            }
        }
        return null
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        }
        val bitmap = Bitmap.createBitmap(
            drawable.intrinsicWidth.takeIf { it > 0 } ?: 1,
            drawable.intrinsicHeight.takeIf { it > 0 } ?: 1,
            Bitmap.Config.ARGB_8888
        )
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }

    private fun hasUsageStatsPermission(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val appOpsManager = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = appOpsManager.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                packageName
            )
            return mode == AppOpsManager.MODE_ALLOWED
        }
        return false
    }
}
