#!/bin/bash
APP_PATH="/Applications/Vibcat.app"
cp -r "Vibcat.app" /Applications/
xattr -cr "$APP_PATH"
spctl --add --label "Vibcat" "$APP_PATH"
spctl --enable --label "Vibcat"
echo "✅ Vibcat 已安装并允许运行"