.PHONY: all configure build clean archive export-ipa

# 配置
CONFIG ?= ios-dev
BUILD_DIR = build/$(CONFIG)
PROJECT_NAME = MyApp
TEAM_ID = YOUR_TEAM_ID_HERE
PROFILE_NAME = "iOS Team Provisioning Profile: *"

all: build

configure:
	@echo "Configuring Xcode project..."
	cmake --preset $(CONFIG)

build: configure
	@echo "Building project..."
	cmake --build $(BUILD_DIR) --config Release

clean:
	@echo "Cleaning build..."
	rm -rf build
	@echo "Clean complete."

# 通过Xcode GUI归档
archive-ui:
	@echo "Opening Xcode for manual archive..."
	open $(BUILD_DIR)/$(PROJECT_NAME).xcodeproj
	@echo "In Xcode: Product > Archive > Distribute App"

# 命令行归档和导出
archive:
	@echo "Archiving for IPA export..."
	xcodebuild archive \
		-project $(BUILD_DIR)/$(PROJECT_NAME).xcodeproj \
		-scheme $(PROJECT_NAME) \
		-configuration Release \
		-archivePath $(BUILD_DIR)/$(PROJECT_NAME).xcarchive \
		DEVELOPMENT_TEAM=$(TEAM_ID)

export-dev:
	@echo "Exporting Development IPA..."
	xcodebuild -exportArchive \
		-archivePath $(BUILD_DIR)/$(PROJECT_NAME).xcarchive \
		-exportOptionsPlist ExportOptions-dev.plist \
		-exportPath $(BUILD_DIR)/IPA

export-appstore:
	@echo "Exporting App Store IPA..."
	xcodebuild -exportArchive \
		-archivePath $(BUILD_DIR)/$(PROJECT_NAME).xcarchive \
		-exportOptionsPlist ExportOptions-appstore.plist \
		-exportPath $(BUILD_DIR)/IPA

# 导出选项plist文件
ExportOptions-dev.plist:
	@echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	@echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $@
	@echo '<plist version="1.0">' >> $@
	@echo '<dict>' >> $@
	@echo '    <key>method</key>' >> $@
	@echo '    <string>development</string>' >> $@
	@echo '    <key>teamID</key>' >> $@
	@echo '    <string>$(TEAM_ID)</string>' >> $@
	@echo '</dict>' >> $@
	@echo '</plist>' >> $@

ExportOptions-appstore.plist:
	@echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	@echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $@
	@echo '<plist version="1.0">' >> $@
	@echo '<dict>' >> $@
	@echo '    <key>method</key>' >> $@
	@echo '    <string>app-store</string>' >> $@
	@echo '    <key>teamID</key>' >> $@
	@echo '    <string>$(TEAM_ID)</string>' >> $@
	@echo '</dict>' >> $@
	@echo '</plist>' >> $@

# 一键生成IPA
ipa: archive export-dev
	@echo "IPA created at: $(BUILD_DIR)/IPA/$(PROJECT_NAME).ipa"

# 上传到TestFlight
upload-testflight: export-appstore
	@echo "Uploading to TestFlight..."
	xcrun altool --upload-app \
		--type ios \
		--file $(BUILD_DIR)/IPA/$(PROJECT_NAME).ipa \
		--username "$(APPLE_ID)" \
		--password "$(APP_SPECIFIC_PASSWORD)"

help:
	@echo "Available targets:"
	@echo "  configure     - Configure Xcode project"
	@echo "  build         - Build the project"
	@echo "  archive-ui    - Open Xcode for manual archive"
	@echo "  archive       - Archive using xcodebuild"
	@echo "  export-dev    - Export development IPA"
	@echo "  export-appstore - Export App Store IPA"
	@echo "  ipa           - Build and export development IPA"
	@echo "  clean         - Clean build directory"