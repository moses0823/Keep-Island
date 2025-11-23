#!/bin/bash
# build_altstore_ipa.sh
# 用於 Keep Island 專案生成可用 AltStore 安裝的 .ipa
# 放在專案根目錄執行

set -e

# ===== 設定專案資訊 =====
# 注意：專案檔名含空格，需要用引號
PROJECT_NAME="Keep Island"                # 專案資料夾名稱
PROJECT_FILE="${PROJECT_NAME}.xcodeproj"  # Xcode 專案檔案
SCHEME_NAME="Keep Island"                  # Scheme 名稱
BUILD_DIR="./build"
ARCHIVE_PATH="${BUILD_DIR}/KeepIsland.xcarchive"
EXPORT_DIR="${BUILD_DIR}/ipa"

# ===== 建立 ExportOptions.plist =====
EXPORT_PLIST="${BUILD_DIR}/ExportOptions.plist"
mkdir -p "${BUILD_DIR}"

cat > "${EXPORT_PLIST}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string> <!-- AltStore 用 development -->
    <key>signingStyle</key>
    <string>automatic</string>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
EOF

echo "ExportOptions.plist 已生成"

# ===== 編譯並 archive =====
xcodebuild -scheme "${SCHEME_NAME}" -project "${PROJECT_FILE}" \
-configuration Release \
-destination "generic/platform=iOS" \
archive -archivePath "${ARCHIVE_PATH}"

echo "專案已 archive 成 ${ARCHIVE_PATH}"

# ===== 導出 .ipa =====
mkdir -p "${EXPORT_DIR}"
xcodebuild -exportArchive \
-archivePath "${ARCHIVE_PATH}" \
-exportOptionsPlist "${EXPORT_PLIST}" \
-exportPath "${EXPORT_DIR}"

IPA_FILE="${EXPORT_DIR}/${SCHEME_NAME}.ipa"
if [ -f "${IPA_FILE}" ]; then
    echo ".ipa 已生成: ${IPA_FILE}"
    echo "可直接用 AltStore 安裝到 iPhone"
    # 選擇性：自動打開 Finder 定位 .ipa
    open "${EXPORT_DIR}"
else
    echo ".ipa 生成失敗"
    exit 1
fi

