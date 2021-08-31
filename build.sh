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
ssh mp281x@mp281x.xyz "cd romLinks; rm -r -f web"
scp -r ./export/web mp281x@mp281x.xyz:/home/mp281x/romLinks/web
ssh mp281x@mp281x.xyz "cd romLinks; docker-compose down --remove-orphans; docker-compose up -d"