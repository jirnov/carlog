@echo off

echo Google Play (AAB)
fvm flutter build appbundle --release --dart-define=STORE_NAME=googleplay

echo RuStore (APK)
fvm flutter build apk --release --dart-define=STORE_NAME=rustore
