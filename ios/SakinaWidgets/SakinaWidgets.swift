import WidgetKit
import SwiftUI

struct SakinaWidgetEntry: TimelineEntry {
    let date: Date
    let image: UIImage?
    let deepLinkUrl: URL?
}

struct SakinaWidgetProvider: TimelineProvider {
    let key: String
    let deepLinkScheme: String

    func placeholder(in context: Context) -> SakinaWidgetEntry {
        SakinaWidgetEntry(date: Date(), image: nil, deepLinkUrl: URL(string: deepLinkScheme))
    }

    func getSnapshot(in context: Context, completion: @escaping (SakinaWidgetEntry) -> Void) {
        let entry = loadEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SakinaWidgetEntry>) -> Void) {
        let entry = loadEntry()
        // Refresh every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadEntry() -> SakinaWidgetEntry {
        let userDefaults = UserDefaults(suiteName: "group.com.sakina.islamic")
        var image: UIImage? = nil

        if let imagePath = userDefaults?.string(forKey: key) {
            image = UIImage(contentsOfFile: imagePath)
        }

        return SakinaWidgetEntry(
            date: Date(),
            image: image,
            deepLinkUrl: URL(string: deepLinkScheme)
        )
    }
}

struct SakinaWidgetEntryView: View {
    var entry: SakinaWidgetEntry

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.08, blue: 0.12)
            if let image = entry.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                VStack(spacing: 8) {
                    Text("سَكِينَة")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.83, green: 0.69, blue: 0.22))
                    Text("جاري تحديث المحتوى...")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .widgetURL(entry.deepLinkUrl)
    }
}

// MARK: - Hadith Widget
struct HadithWidget: Widget {
    let kind: String = "HadithWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: SakinaWidgetProvider(key: "widget_hadith_medium", deepLinkScheme: "sakina://hadith")
        ) { entry in
            SakinaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("حديث اليوم")
        .description("حديث نبوي شريف متجدد يومياً من كتب السنة المعتمدة")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Prayer Times Widget
struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: SakinaWidgetProvider(key: "widget_prayer_large", deepLinkScheme: "sakina://prayer")
        ) { entry in
            SakinaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("مواقيت الصلاة")
        .description("متابعة دقيقة لمواقيت الصلوات الخمس والعد التنازلي للصلاة القادمة")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Quran Ayah Widget
struct QuranAyahWidget: Widget {
    let kind: String = "QuranAyahWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: SakinaWidgetProvider(key: "widget_quran_medium", deepLinkScheme: "sakina://quran")
        ) { entry in
            SakinaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("آية اليوم")
        .description("آية كريمة يومية بالرسم العثماني مع الوقفات التدبرية")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

// MARK: - Tasbeeh Widget
struct TasbeehWidget: Widget {
    let kind: String = "TasbeehWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: SakinaWidgetProvider(key: "widget_tasbeeh_small", deepLinkScheme: "sakina://tasbeeh")
        ) { entry in
            SakinaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("التسبيح اليومي")
        .description("أذكار واستغفار وتسبيح يومي متجدد")
        .supportedFamilies([.systemSmall])
    }
}

@main
struct SakinaWidgetsBundle: WidgetBundle {
    var body: some Widget {
        HadithWidget()
        PrayerTimesWidget()
        QuranAyahWidget()
        TasbeehWidget()
    }
}

