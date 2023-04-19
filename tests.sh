#!/bin/bash

TARGET_NAME="Logger"
BUNDLE_ID="ir.fanap.${TARGET_NAME}"
BUNDLE_VERSION="1.0.1"
DOCC_FILE_PATH="${pwd}/Sources/${TARGET_NAME}/${TARGET_NAME}.docc"
DOCC_HOST_BASE_PATH="async"
DOCC_OUTPUT_FOLDER="./.docs"
DOCC_SYMBOL_GRAPHS=".build/symbol-graphs/"
DOCC_SYMBOL_GRAPHS_OUTPUT=".build/swift-docc-symbol-graphs"
BRANCH_NAME="gl-pages"


swift test \
    --enable-code-coverage \
    --parallel --num-workers 2 \

xcrun llvm-cov export \
.build/x86_64-apple-macosx/debug/LoggerPackageTests.xctest/Contents/MacOS/LoggerPackageTests \
-instr-profile=.build/x86_64-apple-macosx/debug/codecov/default.profdata \
-format=lcov \
-ignore-filename-regex=".build|Tests" \
.build/debug/LoggerPackageTests.xctest/Contents/MacOS/LoggerPackageTests > info.lcov


# If you want to make an html pages for code coverage uncomment line below.
# xcrun lcov genhtml info.lcov  --output-directory ./coverage/

bash <(curl -s https://codecov.io/bash)
