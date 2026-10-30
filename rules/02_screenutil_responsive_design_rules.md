# SCREENUTIL & ADAPTIVE GEOMETRY SPECIFICATION
**Engine:** `flutter_screenutil`  
**Base Design Canvas:** 393 x 852 (Standard iPhone 16 / Modern Flagship Reference)  
**Tablet Breakpoint:** >= 600dp width

---

## 1. THE GEOMETRY CONVERSION MANDATE
Every numeric metric in the visual layer **MUST** be scaled through `flutter_screenutil` extension methods. Raw integers or doubles are strictly forbidden in UI widget trees.

| Purpose | Extension | Correct Example | Forbidden Example |
| :--- | :--- | :--- | :--- |
| **Width & Horizontal Padding** | `.w` | `padding: EdgeInsets.symmetric(horizontal: 16.w)` | `EdgeInsets.symmetric(horizontal: 16)` |
| **Height & Vertical Gaps** | `.h` | `SizedBox(height: 24.h)` | `SizedBox(height: 24)` |
| **Font Sizes** | `.sp` | `fontSize: 18.sp` | `fontSize: 18` |
| **Radius & Uniform Margins** | `.r` | `BorderRadius.circular(16.r)` | `BorderRadius.circular(16)` |
| **Icons & Square Dimensions** | `.r` or `.w` | `Icon(Icons.bookmark, size: 24.r)` | `Icon(Icons.bookmark, size: 24)` |

---

## 2. APP INITIALIZATION & SAFE STARTUP
To avoid runtime crashes when static getters or early services access ScreenUtil metrics, `main()` must await `ScreenUtil.ensureScreenSize()` before executing `runApp()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  
  runApp(const SakinaApp());
}
```

And in the root widget:
```dart
ScreenUtilInit(
  designSize: const Size(393, 852),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, child) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  },
)
```

---

## 3. SPACING TOKENS CATALOG (`AppSpacing`)
Do not use arbitrary magic numbers. All padding, gaps, and margins must utilize standardized design system tokens:

```dart
abstract final class AppSpacing {
  // Raw token metrics (Scaled safely via getters)
  static double get xxs => 4.r;
  static double get xs  => 8.r;
  static double get sm  => 12.r;
  static double get md  => 16.r;
  static double get lg  => 24.r;
  static double get xl  => 32.r;
  static double get xxl => 48.r;

  // Pre-built vertical gap widgets
  static Widget get verticalXs  => SizedBox(height: 8.h);
  static Widget get verticalSm  => SizedBox(height: 12.h);
  static Widget get verticalMd  => SizedBox(height: 16.h);
  static Widget get verticalLg  => SizedBox(height: 24.h);
  static Widget get verticalXl  => SizedBox(height: 32.h);

  // Pre-built horizontal gap widgets
  static Widget get horizontalSm => SizedBox(width: 12.w);
  static Widget get horizontalMd => SizedBox(width: 16.w);
  static Widget get horizontalLg => SizedBox(width: 24.w);

  // Unified padding presets
  static EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
  static EdgeInsets get cardPadding   => EdgeInsets.all(16.r);
}
```

---

## 4. RESPONSIVE BREAKPOINTS & TABLET CONSTRAINTS
- **Max Content Width Constraint:** On tablets and large screens (width >= 600dp), full-width Quran text and reading pages must NOT stretch horizontally across the entire screen. Center the content and constrain it:
  ```dart
  class ResponsiveContentContainer extends StatelessWidget {
    final Widget child;
    const ResponsiveContentContainer({super.key, required this.child});

    @override
    Widget build(BuildContext context) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 680.w),
          child: child,
        ),
      );
    }
  }
  ```
- **Text Scaling Accessibility Guard:** Prevent extreme system font scaling from destroying sacred Quranic layout lines:
  ```dart
  Text(
    surahName,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    textScaler: TextScaler.linear(
      MediaQuery.textScalerOf(context).scale(1.0).clamp(0.85, 1.25),
    ),
  )
  ```
- **Safe Area Inset Awareness:** Every screen must respect device camera cutouts, dynamic islands, and home indicator gesture bars using `SafeArea`.

