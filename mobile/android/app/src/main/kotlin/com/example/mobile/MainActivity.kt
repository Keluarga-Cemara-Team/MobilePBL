package com.example.mobile

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.mobile/app_usage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasUsageAccess" -> result.success(hasUsageAccess())
                    "openUsageSettings" -> {
                        try {
                            startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                            result.success(true)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }
                    "getMostUsedApps" -> {
                        if (!hasUsageAccess()) {
                            result.error("permission_required", "Usage access is not enabled", null)
                        } else {
                            val days = (call.argument<Int>("days") ?: 7).coerceIn(1, 30)
                            result.success(getMostUsedApps(days))
                        }
                    }
                    "getTotalUsageTime" -> {
                        if (!hasUsageAccess()) {
                            result.error("permission_required", "Usage access is not enabled", null)
                        } else {
                            val days = (call.argument<Int>("days") ?: 1).coerceIn(1, 30)
                            result.success(getTotalUsageTime(days))
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasUsageAccess(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName)
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun getMostUsedApps(days: Int): List<Map<String, Any?>> {
        val now = System.currentTimeMillis()
        val start = now - days * 24L * 60L * 60L * 1000L
        val manager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val stats = manager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, start, now)
        val totals = stats.asSequence()
            .filter { it.packageName != packageName && it.totalTimeInForeground > 0L }
            .groupBy { it.packageName }
            .mapValues { (_, entries) -> entries.sumOf { it.totalTimeInForeground } }
            .toList()
            .sortedByDescending { it.second }
            .take(5)
        val pm = packageManager
        return totals.map { (pkg, time) ->
            val appInfo = try { pm.getApplicationInfo(pkg, 0) } catch (_: Exception) { null }
            val label = try {
                if (appInfo != null) pm.getApplicationLabel(appInfo).toString() else pkg
            } catch (_: Exception) { pkg }
            val iconBytes = try {
                if (appInfo == null) null else {
                    val drawable = pm.getApplicationIcon(appInfo)
                    val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
                    val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96
                    val bitmap = Bitmap.createBitmap(width.coerceAtMost(192), height.coerceAtMost(192), Bitmap.Config.ARGB_8888)
                    val canvas = Canvas(bitmap)
                    drawable.setBounds(0, 0, canvas.width, canvas.height)
                    drawable.draw(canvas)
                    ByteArrayOutputStream().use { stream ->
                        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                        bitmap.recycle()
                        stream.toByteArray()
                    }
                }
            } catch (_: Exception) { null }
            mapOf("packageName" to pkg, "label" to label, "timeMs" to time, "icon" to iconBytes)
        }
    }

    private fun getTotalUsageTime(days: Int): Long {
        val now = System.currentTimeMillis()
        val start = now - days * 24L * 60L * 60L * 1000L
        val manager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val stats = manager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, start, now)
        return stats.asSequence()
            .filter { it.packageName != packageName && it.totalTimeInForeground > 0L }
            .groupBy { it.packageName }
            .map { (_, entries) -> entries.sumOf { it.totalTimeInForeground } }
            .sum()
    }
}
