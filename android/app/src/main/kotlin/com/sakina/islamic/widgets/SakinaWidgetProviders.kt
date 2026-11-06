package com.sakina.islamic.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import com.sakina.islamic.MainActivity
import com.sakina.islamic.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

abstract class SakinaBaseWidgetProvider : HomeWidgetProvider() {
    abstract val layoutId: Int
    abstract val dataKey: String
    abstract val deepLinkUri: String

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, layoutId)

            val imagePath = widgetData.getString(dataKey, null)
            if (imagePath != null && File(imagePath).exists()) {
                val bitmap = BitmapFactory.decodeFile(imagePath)
                if (bitmap != null) {
                    views.setImageViewBitmap(R.id.widget_image, bitmap)
                    views.setViewVisibility(R.id.widget_image, View.VISIBLE)
                    views.setViewVisibility(R.id.widget_fallback, View.GONE)
                } else {
                    views.setViewVisibility(R.id.widget_fallback, View.VISIBLE)
                }
            } else {
                views.setViewVisibility(R.id.widget_fallback, View.VISIBLE)
            }

            val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse(deepLinkUri)
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

// Hadith Widgets (Medium 4×2, Small 2×2)
class HadithMediumWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_hadith_medium
    override val dataKey: String = "widget_hadith_medium"
    override val deepLinkUri: String = "sakina://hadith"
}

class HadithSmallWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_hadith_small
    override val dataKey: String = "widget_hadith_small"
    override val deepLinkUri: String = "sakina://hadith"
}

// Prayer Times Widgets (Large 4×4, Medium 4×2, Small 2×2)
class PrayerLargeWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_prayer_large
    override val dataKey: String = "widget_prayer_large"
    override val deepLinkUri: String = "sakina://prayer"
}

class PrayerMediumWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_prayer_medium
    override val dataKey: String = "widget_prayer_medium"
    override val deepLinkUri: String = "sakina://prayer"
}

class PrayerSmallWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_prayer_small
    override val dataKey: String = "widget_prayer_small"
    override val deepLinkUri: String = "sakina://prayer"
}

// Quran Ayah Widgets (Medium 4×2, Small 2×2)
class QuranMediumWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_quran_medium
    override val dataKey: String = "widget_quran_medium"
    override val deepLinkUri: String = "sakina://quran"
}

class QuranSmallWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_quran_small
    override val dataKey: String = "widget_quran_small"
    override val deepLinkUri: String = "sakina://quran"
}

// Tasbeeh Widget: Native instantaneous click counter & auto-rotation
class TasbeehSmallWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_tasbeeh_small
    override val dataKey: String = "widget_tasbeeh_small"
    override val deepLinkUri: String = "sakina://tasbeeh"

    companion object {
        const val ACTION_TASBEEH_COUNT = "com.sakina.islamic.ACTION_TASBEEH_COUNT"

        val DHIKR_ITEMS = listOf(
            Pair("أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ", "الاستغفار"),
            Pair("سُبْحَانَ اللَّهِ", "التسبيح"),
            Pair("الْحَمْدُ لِلَّهِ", "التحميد"),
            Pair("لَا إِلَهَ إِلَّا اللَّهُ", "التهليل"),
            Pair("اللَّهُ أَكْبَرُ", "التكبير"),
            Pair("سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ", "حبيبتان للرحمن"),
            Pair("لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ", "الحوقلة"),
            Pair("اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ", "الصلاة على النبي")
        )
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == ACTION_TASBEEH_COUNT) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            var count = prefs.getInt("flutter.widget_tasbeeh_count", 0)
            var index = prefs.getInt("flutter.widget_tasbeeh_index", 0)

            count++
            if (count >= 33) {
                count = 0
                index = (index + 1) % DHIKR_ITEMS.size
            }

            prefs.edit()
                .putInt("flutter.widget_tasbeeh_count", count)
                .putInt("flutter.widget_tasbeeh_index", index)
                .apply()

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = ComponentName(context, TasbeehSmallWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

            for (appWidgetId in appWidgetIds) {
                val views = RemoteViews(context.packageName, R.layout.widget_tasbeeh_small)
                val currentItem = DHIKR_ITEMS[index % DHIKR_ITEMS.size]

                views.setTextViewText(R.id.tasbeeh_title, currentItem.second)
                views.setTextViewText(R.id.tasbeeh_phrase, currentItem.first)
                views.setTextViewText(R.id.tasbeeh_counter_text, "$count / 33")

                views.setViewVisibility(R.id.widget_fallback, View.VISIBLE)
                views.setViewVisibility(R.id.widget_image, View.GONE)

                val clickIntent = Intent(context, TasbeehSmallWidgetProvider::class.java).apply {
                    action = ACTION_TASBEEH_COUNT
                }
                val flags = if (Build.VERSION.SDK_INT >= 23) {
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                } else {
                    PendingIntent.FLAG_UPDATE_CURRENT
                }
                val pendingIntent = PendingIntent.getBroadcast(context, 0, clickIntent, flags)
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                appWidgetManager.updateAppWidget(appWidgetId, views)
            }
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val count = prefs.getInt("flutter.widget_tasbeeh_count", 0)
        val index = prefs.getInt("flutter.widget_tasbeeh_index", 0)
        val currentItem = DHIKR_ITEMS[index % DHIKR_ITEMS.size]

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, layoutId)

            val imagePath = widgetData.getString(dataKey, null)
            if (imagePath != null && File(imagePath).exists()) {
                val bitmap = BitmapFactory.decodeFile(imagePath)
                if (bitmap != null) {
                    views.setImageViewBitmap(R.id.widget_image, bitmap)
                    views.setViewVisibility(R.id.widget_image, View.VISIBLE)
                    views.setViewVisibility(R.id.widget_fallback, View.GONE)
                } else {
                    views.setViewVisibility(R.id.widget_fallback, View.VISIBLE)
                }
            } else {
                views.setTextViewText(R.id.tasbeeh_title, currentItem.second)
                views.setTextViewText(R.id.tasbeeh_phrase, currentItem.first)
                views.setTextViewText(R.id.tasbeeh_counter_text, "$count / 33")
                views.setViewVisibility(R.id.widget_fallback, View.VISIBLE)
                views.setViewVisibility(R.id.widget_image, View.GONE)
            }

            val clickIntent = Intent(context, TasbeehSmallWidgetProvider::class.java).apply {
                action = ACTION_TASBEEH_COUNT
            }
            val flags = if (Build.VERSION.SDK_INT >= 23) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
            val pendingIntent = PendingIntent.getBroadcast(context, 0, clickIntent, flags)
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
