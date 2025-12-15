# LanDunTest - iOS Build Automation Demo

## Overview
This repository demonstrates a **complete iOS development workflow** in a **sensitive-information-free** environment, covering:
- Version setting
- CMake project generation
- Xcode archiving
- IPA export

> ⚠️ **Note**: All commonly used keywords have been excluded from this demo to protect sensitive information.

## Environment
- **Current Setup**: BK-provided experience environment (see [Tencent BlueKing](https://bk.tencent.com/))
- **Production Deployment**: See [Implementation Guide](#implementation-guide) below

## Key Features
1. **End-to-End iOS Build Pipeline**
   - Version management
   - Cross-platform build configuration (CMake)
   - Xcode project archiving
   - IPA package export

2. **BlueKing Integration**
   - Leverages Tencent's enterprise-grade DevOps platform
   - Supports commercial-grade capabilities in production

## Implementation Guide

### Production Deployment Steps
1. **O&M Team Setup**
   - Deploy commercial BlueKing environment
     - Provides enhanced capabilities beyond demo environment
     - Includes full CI/CD and DevOps toolchain

2. **R&D Team Configuration**
   - Set up build pipeline on BlueKing's CI/CD platform
   - Pipeline architecture:
     - **Plugin-based system** for modular operations
     - **Extensible design**:
       - Develop custom plugins as needed
       - Future-proof architecture for additional requirements

### Technical Context
- **Demo Environment**: BK-provided sandbox (limited capabilities)
- **Production Environment**: BlueKing Enterprise Edition
  - Features:
    - Automated build pipelines
    - Plugin ecosystem
    - Scalable infrastructure

## Repository Structure