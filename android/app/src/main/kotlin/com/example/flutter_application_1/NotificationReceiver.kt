package com.example.hafez_poems
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Color
import android.os.Build
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(
        context: Context,
        intent: Intent,
    ) {
        val title = intent.getStringExtra("title") ?: "یادآوری روزانه حافظ"
        val body = intent.getStringExtra("body") ?: "وقت خوندن چند بیت شعره!"
        val id = intent.getIntExtra("id", 1001)
        val hour = intent.getIntExtra("hour", 13)
        val minute = intent.getIntExtra("minute", 0)

        showRtlNotification(context, title, body, id)
        AlarmScheduler.scheduleNext(context, title, body, hour, minute, id)
    }

    private fun showRtlNotification(
        context: Context,
        title: String,
        body: String,
        id: Int,
    ) {
        val channelId = "daily_hafez_reminder"
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

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

        val remoteViews = RemoteViews(context.packageName, R.layout.notification_rtl)
        remoteViews.setTextViewText(R.id.notification_title, title)
        remoteViews.setTextViewText(R.id.notification_body, body)

        val openIntent =
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
        val pendingIntent =
            PendingIntent.getActivity(
                context,
                id,
                openIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )

        val notification =
            NotificationCompat
                .Builder(context, channelId)
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
