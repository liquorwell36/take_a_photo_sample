// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';
import 'package:take_a_photo_sample/main.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final cameras = await availableCameras();
  final camera = CameraDescription(
      name: "1",
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 270);
  // final firstCamera = cameras.first;
  testWidgets(
    '画面遷移テスト',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          child: MyApp(
            camera: camera,
          ),
        ),
      );
      final add_photo_icon = find.byIcon(Icons.add_a_photo);

      //写真追加アイコンが表示されているか
      expect(add_photo_icon, findsOneWidget);

      //写真撮影画面(TakePictureScreen)に遷移できるか
      await tester.tap(find.byIcon(Icons.add_a_photo));
      await tester.pumpWidget(
        TakePictureScreen(
          camera: camera,
        ),
      );

      expect(find.byIcon(Icons.photo_camera), findsOneWidget);
    },
  );
}
