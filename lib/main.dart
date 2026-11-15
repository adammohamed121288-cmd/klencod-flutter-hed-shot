import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const HeadshotApp());
}

class HeadshotApp extends StatelessWidget {
  const HeadshotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isOverlayActive = false;

  @override
  void initState() {
    super.initState();
    // إعدادات الشاشة الكاملة
    windowManager.ensureInitialized().then((_) async {
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setFullScreen(true);
      await windowManager.setSize(ui.Size(400, 800)); // حجم افتراضي
      await windowManager.setAlignment(Alignment.centerRight);
    });
  }

  void startOverlay() {
    setState(() {
      isOverlayActive = true;
    });
  }

  void stopOverlay() {
    setState(() {
      isOverlayActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isOverlayActive) {
      return const OverlayScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Free Fire Headshot Pro")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("اضغط على الزر التالي لتفعيل الهيدشوت"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startOverlay,
              child: const Text("تفعيل وضع اللعب"),
            ),
          ],
        ),
      ),
    );
  }
}

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  // متغيرات لتحديد مواقع الأزرار
  double moveButtonX = 50.0;
  double moveButtonY = 300.0;
  double fireButtonX = 250.0;
  double fireButtonY = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // زر الخروج
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),

          // زر التحرك (WASD) - متعدد اللمس
          Positioned(
            left: moveButtonX,
            top: moveButtonY,
            child: GestureDetector(
              onPanStart: (details) {
                // محاكاة ضغط WASD
                debugPrint("WASD Pressed");
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.keyboard_arrow_up, size: 50, color: Colors.white),
              ),
            ),
          ),

          // زر التصويب (Fire) - متعدد اللمس أيضاً
          Positioned(
            left: fireButtonX,
            top: fireButtonY,
            child: GestureDetector(
              onPanStart: (details) {
                // محاكاة ضغط زر التصويب
                debugPrint("FIRE Button Pressed");
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)
                  ]
                ),
                child: const Icon(Icons.fingerprint, size: 50, color: Colors.white),
              ),
            ),
          ),

          // أزرار التحكم في الموقع
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.move_down_to_line_outlined),
                  onPressed: () {
                    setState(() {
                      fireButtonY += 20;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.move_up_to_line_outlined),
                  onPressed: () {
                    setState(() {
                      fireButtonY -= 20;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}