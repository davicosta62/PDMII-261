// Import will depend on App ID.
package com.mydomain.homescreen_widgets

import android.graphics.BitmapFactory
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

import es.antonborri.home_widget.HomeWidgetPlugin

class NewsWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {

        for (appWidgetId in appWidgetIds) {

            val widgetData = HomeWidgetPlugin.getData(context)

            val views = RemoteViews(
                context.packageName,
                R.layout.news_widget
            ).apply {
                setTextViewText(
               R.id.student_name,
                "Davi"
                )
                val title = widgetData.getString(
                    "headline_title",
                    null
                )

                setTextViewText(
                    R.id.headline_title,
                    title ?: "No title set"
                )

                val description = widgetData.getString(
                    "headline_description",
                    null
                )

                setTextViewText(
                    R.id.headline_description,
                    description ?: "No description set"
                )

                // IMAGEM

                val imagePath = widgetData.getString(
                    "line_chart",
                    null
                )

                if (imagePath != null) {

                    val bitmap = BitmapFactory.decodeFile(
                        imagePath
                    )

                    setImageViewBitmap(
                        R.id.widget_chart,
                        bitmap
                    )
                }
            }

            appWidgetManager.updateAppWidget(
                appWidgetId,
                views
            )
        }
    }
}