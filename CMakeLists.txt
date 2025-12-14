cmake_minimum_required(VERSION 3.20)
project(MyApp
    VERSION 1.0.0
    DESCRIPTION "iOS/macOS App with IPA export support"
    LANGUAGES C CXX OBJC OBJCXX
)

if(IOS)
    set(CMAKE_SYSTEM_NAME iOS)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "13.0" CACHE STRING "Minimum iOS version")
    set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "13.0")
    set(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2")  # iPhone & iPad
elseif(APPLE)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "Minimum macOS version")
endif()

set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC "YES")
set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_WEAK "YES")

set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "YES")
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development" CACHE STRING "Code Sign Identity")
set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "" CACHE STRING "Apple Developer Team ID")

if(IOS)
    set(CMAKE_XCODE_ATTRIBUTE_PROVISIONING_PROFILE_SPECIFIER "" CACHE STRING "Provisioning Profile")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(IOS)
    set(SOURCES
        src/main.m
    )
    
    add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCES})
    
    target_link_libraries(${PROJECT_NAME}
        "-framework UIKit"
        "-framework Foundation"
    )
    
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER "com.yourcompany.${PROJECT_NAME}"
        MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}"
    )
    
    # Info.plist for iOS
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
        ${CMAKE_CURRENT_BINARY_DIR}/Info.plist
        @ONLY
    ) 
    
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_BINARY_DIR}/Info.plist
    )
    
elseif(APPLE)
    set(SOURCES
        src/main.cpp
    )
    
    add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCES})
    
    target_link_libraries(${PROJECT_NAME}
        "-framework AppKit"
        "-framework Foundation"
    )
    
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER "com.yourcompany.${PROJECT_NAME}"
        MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}"
        MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/macOS/Info.plist
    )
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES
    XCODE_ATTRIBUTE_INSTALL_PATH "/Applications"
)

target_include_directories(${PROJECT_NAME} PRIVATE
    include
    src
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Assets.xcassets")
    set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/Assets.xcassets
        PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources"
    )
    target_sources(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/Assets.xcassets)
endif()

if(IOS)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E echo "Build complete. Use Xcode to export IPA: Product > Archive > Distribute App"
        COMMENT "Build complete. Archive in Xcode to create IPA."
    )
endif()