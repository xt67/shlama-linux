#!/bin/bash
# Build script for shlama .deb package

set -e

VERSION="1.0.0"
PACKAGE_NAME="shlama"
BUILD_DIR="debian"

echo "🦙 Building shlama .deb package v${VERSION}..."

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Clean previous builds
rm -f ${PACKAGE_NAME}_*.deb

# Copy shlama binary to package
cp shlama ${BUILD_DIR}/usr/local/bin/
chmod +x ${BUILD_DIR}/usr/local/bin/shlama

# Set correct permissions
chmod 755 ${BUILD_DIR}/DEBIAN
chmod 644 ${BUILD_DIR}/DEBIAN/control
chmod 755 ${BUILD_DIR}/DEBIAN/postinst

# Fix line endings (Windows to Unix)
sed -i 's/\r$//' ${BUILD_DIR}/usr/local/bin/shlama
sed -i 's/\r$//' ${BUILD_DIR}/DEBIAN/postinst
sed -i 's/\r$//' ${BUILD_DIR}/DEBIAN/control

# Build the package
dpkg-deb --build ${BUILD_DIR} ${PACKAGE_NAME}_${VERSION}_all.deb

echo ""
echo "✅ Package built: ${PACKAGE_NAME}_${VERSION}_all.deb"
echo ""
echo "To install locally: sudo dpkg -i ${PACKAGE_NAME}_${VERSION}_all.deb"
echo "To install deps:    sudo apt-get install -f"
