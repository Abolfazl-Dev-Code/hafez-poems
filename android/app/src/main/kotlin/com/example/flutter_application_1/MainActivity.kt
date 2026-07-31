package com.example.hafez_poems
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Color
import android.media.AudioManager
import android.os.Build
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val AUDIO_CHANNEL = "hafez/audio"
    private val NOTIFICATION_CHANNEL = "hafez/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUDIO_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setSpeakerOn" -> {
                        try {
                            audioManager.mode = AudioManager.MODE_IN_CALL
                            audioManager.isSpeakerphoneOn = true
                            Thread.sleep(50)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("SPEAKER_ERROR", e.message, null)
                        }
                    }

                    "setSpeakerOff" -> {
                        try {
                            audioManager.isSpeakerphoneOn = false
                            audioManager.mode = AudioManager.MODE_NORMAL
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("SPEAKER_ERROR", e.message, null)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showRtlNotification" -> {
                        val title = call.argument<String>("title") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val id = call.argument<Int>("id") ?: 1001
                        try {
                            showRtlNotification(title, body, id)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("NOTIFICATION_ERROR", e.message, null)
                        }
                    }

                    "scheduleDailyRtlNotification" -> {
                        val title = call.argument<String>("title") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val hour = call.argument<Int>("hour") ?: 13
                        val minute = call.argument<Int>("minute") ?: 0
                        val id = call.argument<Int>("id") ?: 1001
                        try {
                            AlarmScheduler.persist(this, title, body, hour, minute, id, enabled = true)
                            AlarmScheduler.scheduleNext(this, title, body, hour, minute, id)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("SCHEDULE_ERROR", e.message, null)
                        }
                    }

                    "cancelDailyRtlNotification" -> {
                        val id = call.argument<Int>("id") ?: 1001
                        try {
                            AlarmScheduler.cancel(this, id)
                            AlarmScheduler.persist(this, "", "", 13, 0, id, enabled = false)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("CANCEL_ERROR", e.message, null)
                        }
                    }

                    "isDailyReminderScheduled" -> {
                        val id = call.argument<Int>("id") ?: 1001
                        try {
                            result.success(AlarmScheduler.isScheduled(this, id))
                        } catch (e: Exception) {
                            result.error("CHECK_ERROR", e.message, null)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun showRtlNotification(
        title: String,
        body: String,
        id: Int,
    ) {
        val channelId = "daily_hafez_reminder"
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                NotificationChannel(
                    channelId,
                    "یادآوری روزانه حافظ",
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply {
                    description = "اعلان یادآوری روزانه برای خواندن دیوان حافظ"
                    enableVibration(true)
                }
            notificationManager.createNotificationChannel(channel)
        }

        val remoteViews = RemoteViews(packageName, R.layout.notification_rtl)
        remoteViews.setTextViewText(R.id.notification_title, title)
        remoteViews.setTextViewText(R.id.notification_body, body)

        val intent =
            Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
        val pendingIntent =
            PendingIntent.getActivity(
                this,
                id,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )

        val notification =
            NotificationCompat
                .Builder(this, channelId)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setColor(Color.TRANSPARENT)
                .setCustomContentView(remoteViews)
                .setCustomBigContentView(remoteViews)
                .setStyle(NotificationCompat.DecoratedCustomViewStyle())
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .build()

        notificationManager.notify(id, notification)
    }
}
