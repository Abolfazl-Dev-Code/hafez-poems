package com.example.hafez_poems

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_MY_PACKAGE_REPLACED
        ) return

        val prefs = context.getSharedPreferences("hafez_reminder_prefs", Context.MODE_PRIVATE)
        val enabled = prefs.getBoolean("enabled", false)
        if (!enabled) return

        val title = prefs.getString("title", null) ?: return
        val body = prefs.getString("body", null) ?: return
        val hour = prefs.getInt("hour", 13)
        val minute = prefs.getInt("minute", 0)
        val id = prefs.getInt("id", 1001)

        AlarmScheduler.scheduleNext(context, title, body, hour, minute, id)
    }
}
