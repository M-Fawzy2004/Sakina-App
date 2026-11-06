package com.sakina.islamic.widgets

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
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

// Hadith Widgets
class HadithLargeWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_hadith_large
    override val dataKey: String = "widget_hadith_large"
    override val deepLinkUri: String = "sakina://hadith"
}

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

// Prayer Times Widgets
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

// Quran Ayah Widgets
class QuranLargeWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_quran_large
    override val dataKey: String = "widget_quran_large"
    override val deepLinkUri: String = "sakina://quran"
}

class QuranMediumWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_quran_medium
    override val dataKey: String = "widget_quran_medium"
    override val deepLinkUri: String = "sakina://quran"
}

// Tasbeeh Widget
class TasbeehSmallWidgetProvider : SakinaBaseWidgetProvider() {
    override val layoutId: Int = R.layout.widget_tasbeeh_small
    override val dataKey: String = "widget_tasbeeh_small"
    override val deepLinkUri: String = "sakina://tasbeeh"
}

