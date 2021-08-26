#! /bin/bash
rm -r ./export/*
flutter clean
flutter pub get
flutter build apk
flutter build appbundle
flutter build web
mv ./build/web ./export
mv ./build/app/outputs/flutter-apk/app-release.apk ./export/romLinks.apk
mv ./build/app/outputs/bundle/release/app-release.aab ./export/romLinks.aab