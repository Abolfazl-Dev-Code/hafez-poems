package com.example.hafez_poems

import android.media.AudioManager
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val CHANNEL = "hafez/audio"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setSpeakerOn" -> {
                    try {
                        audioManager.mode = AudioManager.MODE_IN_CALL  // ← نه MODE_IN_COMMUNICATION
                        audioManager.isSpeakerphoneOn = true
                        Thread.sleep(50)  // ← کمی صبر کن
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
                else -> result.notImplemented()
            }
        }
    }
}