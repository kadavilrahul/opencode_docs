#!/bin/bash

# Comprehensive Codebase Analysis Script
# Used by integration agents to understand codebase structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PROJECT_DIR="${1:-.}"
OUTPUT_FILE="${2:-.integration-map.json}"

echo -e "${BLUE}=== Codebase Integration Analysis ===${NC}"
echo -e "Analyzing: ${GREEN}$PROJECT_DIR${NC}"
echo ""

# Function to count occurrences
count_patterns() {
    local pattern="$1"
    local file_pattern="$2"
    find "$PROJECT_DIR" -type f -name "$file_pattern" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | xargs grep -l "$pattern" 2>/dev/null | wc -l
}

# Function to find files
find_files() {
    local pattern="$1"
    find "$PROJECT_DIR" -type f -name "$pattern" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | head -20
}

# Initialize JSON output
cat > "$OUTPUT_FILE" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "projectPath": "$PROJECT_DIR",
  "analysis": {
EOF

# 1. Project Type Detection
echo -e "${YELLOW}Detecting project type...${NC}"
PROJECT_TYPE="unknown"
if [ -f "$PROJECT_DIR/package.json" ]; then
    PROJECT_TYPE="node"
    echo "  → Node.js/JavaScript project detected"
elif [ -f "$PROJECT_DIR/requirements.txt" ] || [ -f "$PROJECT_DIR/setup.py" ]; then
    PROJECT_TYPE="python"
    echo "  → Python project detected"
elif [ -f "$PROJECT_DIR/go.mod" ]; then
    PROJECT_TYPE="go"
    echo "  → Go project detected"
elif [ -f "$PROJECT_DIR/pom.xml" ]; then
    PROJECT_TYPE="java"
    echo "  → Java/Maven project detected"
elif [ -f "$PROJECT_DIR/Cargo.toml" ]; then
    PROJECT_TYPE="rust"
    echo "  → Rust project detected"
fi

echo "    \"projectType\": \"$PROJECT_TYPE\"," >> "$OUTPUT_FILE"

# 2. File Statistics
echo -e "\n${YELLOW}Analyzing file structure...${NC}"
TOTAL_FILES=$(find "$PROJECT_DIR" -type f -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | wc -l)
JS_FILES=$(find "$PROJECT_DIR" -type f \( -name "*.js" -o -name "*.jsx" \) -not -path "*/node_modules/*" 2>/dev/null | wc -l)
TS_FILES=$(find "$PROJECT_DIR" -type f \( -name "*.ts" -o -name "*.tsx" \) -not -path "*/node_modules/*" 2>/dev/null | wc -l)
PY_FILES=$(find "$PROJECT_DIR" -type f -name "*.py" -not -path "*/node_modules/*" 2>/dev/null | wc -l)
TEST_FILES=$(find "$PROJECT_DIR" -type f \( -name "*test*" -o -name "*spec*" \) -not -path "*/node_modules/*" 2>/dev/null | wc -l)

echo "  → Total files: $TOTAL_FILES"
echo "  → JavaScript files: $JS_FILES"
echo "  → TypeScript files: $TS_FILES"
echo "  → Python files: $PY_FILES"
echo "  → Test files: $TEST_FILES"

cat >> "$OUTPUT_FILE" << EOF
    "fileStatistics": {
      "totalFiles": $TOTAL_FILES,
      "javascriptFiles": $JS_FILES,
      "typescriptFiles": $TS_FILES,
      "pythonFiles": $PY_FILES,
      "testFiles": $TEST_FILES
    },
EOF

# 3. Architecture Pattern Detection
echo -e "\n${YELLOW}Detecting architecture patterns...${NC}"
CONTROLLERS=$(find "$PROJECT_DIR" -type f -name "*controller*" -o -name "*Controller*" 2>/dev/null | wc -l)
SERVICES=$(find "$PROJECT_DIR" -type f -name "*service*" -o -name "*Service*" 2>/dev/null | wc -l)
MODELS=$(find "$PROJECT_DIR" -type f -name "*model*" -o -name "*Model*" 2>/dev/null | wc -l)
REPOSITORIES=$(find "$PROJECT_DIR" -type f -name "*repository*" -o -name "*Repository*" 2>/dev/null | wc -l)
VIEWS=$(find "$PROJECT_DIR" -type f \( -name "*.html" -o -name "*.jsx" -o -name "*.vue" \) -not -path "*/node_modules/*" 2>/dev/null | wc -l)

ARCHITECTURE="unknown"
if [ $CONTROLLERS -gt 0 ] && [ $MODELS -gt 0 ]; then
    ARCHITECTURE="mvc"
    echo "  → MVC pattern detected"
elif [ $SERVICES -gt 0 ] && [ $REPOSITORIES -gt 0 ]; then
    ARCHITECTURE="layered"
    echo "  → Layered architecture detected"
elif [ $SERVICES -gt 0 ]; then
    ARCHITECTURE="service-oriented"
    echo "  → Service-oriented architecture detected"
fi

cat >> "$OUTPUT_FILE" << EOF
    "architecturePatterns": {
      "detected": "$ARCHITECTURE",
      "controllers": $CONTROLLERS,
      "services": $SERVICES,
      "models": $MODELS,
      "repositories": $REPOSITORIES,
      "views": $VIEWS
    },
EOF

# 4. Code Patterns Analysis
echo -e "\n${YELLOW}Analyzing code patterns...${NC}"
if [ "$PROJECT_TYPE" = "node" ]; then
    CLASSES=$(grep -r "^class " "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | wc -l)
    FUNCTIONS=$(grep -r "^function \|^const.*=.*=>" "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | wc -l)
    ASYNC_FUNCTIONS=$(grep -r "async function\|async.*=>" "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | wc -l)
    EXPORTS=$(grep -r "^export \|module.exports" "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | wc -l)
    IMPORTS=$(grep -r "^import \|require(" "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | wc -l)
elif [ "$PROJECT_TYPE" = "python" ]; then
    CLASSES=$(grep -r "^class " "$PROJECT_DIR" --include="*.py" 2>/dev/null | wc -l)
    FUNCTIONS=$(grep -r "^def " "$PROJECT_DIR" --include="*.py" 2>/dev/null | wc -l)
    ASYNC_FUNCTIONS=$(grep -r "^async def " "$PROJECT_DIR" --include="*.py" 2>/dev/null | wc -l)
    EXPORTS=0
    IMPORTS=$(grep -r "^import \|^from .* import" "$PROJECT_DIR" --include="*.py" 2>/dev/null | wc -l)
else
    CLASSES=0
    FUNCTIONS=0
    ASYNC_FUNCTIONS=0
    EXPORTS=0
    IMPORTS=0
fi

echo "  → Classes found: $CLASSES"
echo "  → Functions found: $FUNCTIONS"
echo "  → Async functions: $ASYNC_FUNCTIONS"
echo "  → Exports: $EXPORTS"
echo "  → Imports: $IMPORTS"

cat >> "$OUTPUT_FILE" << EOF
    "codePatterns": {
      "classes": $CLASSES,
      "functions": $FUNCTIONS,
      "asyncFunctions": $ASYNC_FUNCTIONS,
      "exports": $EXPORTS,
      "imports": $IMPORTS
    },
EOF

# 5. API Endpoints Detection
echo -e "\n${YELLOW}Detecting API endpoints...${NC}"
GET_ENDPOINTS=$(grep -r "\.get(\|@app.route.*GET\|@router.get" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | wc -l)
POST_ENDPOINTS=$(grep -r "\.post(\|@app.route.*POST\|@router.post" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | wc -l)
PUT_ENDPOINTS=$(grep -r "\.put(\|@app.route.*PUT\|@router.put" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | wc -l)
DELETE_ENDPOINTS=$(grep -r "\.delete(\|@app.route.*DELETE\|@router.delete" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | wc -l)

TOTAL_ENDPOINTS=$((GET_ENDPOINTS + POST_ENDPOINTS + PUT_ENDPOINTS + DELETE_ENDPOINTS))
echo "  → Total API endpoints: $TOTAL_ENDPOINTS"
echo "    - GET: $GET_ENDPOINTS"
echo "    - POST: $POST_ENDPOINTS"
echo "    - PUT: $PUT_ENDPOINTS"
echo "    - DELETE: $DELETE_ENDPOINTS"

cat >> "$OUTPUT_FILE" << EOF
    "apiEndpoints": {
      "total": $TOTAL_ENDPOINTS,
      "get": $GET_ENDPOINTS,
      "post": $POST_ENDPOINTS,
      "put": $PUT_ENDPOINTS,
      "delete": $DELETE_ENDPOINTS
    },
EOF

# 6. Testing Infrastructure
echo -e "\n${YELLOW}Analyzing testing infrastructure...${NC}"
TEST_FRAMEWORK="none"
if grep -q "jest" "$PROJECT_DIR/package.json" 2>/dev/null; then
    TEST_FRAMEWORK="jest"
elif grep -q "mocha" "$PROJECT_DIR/package.json" 2>/dev/null; then
    TEST_FRAMEWORK="mocha"
elif grep -q "vitest" "$PROJECT_DIR/package.json" 2>/dev/null; then
    TEST_FRAMEWORK="vitest"
elif grep -q "pytest" "$PROJECT_DIR/requirements.txt" 2>/dev/null || [ -f "$PROJECT_DIR/pytest.ini" ]; then
    TEST_FRAMEWORK="pytest"
elif grep -q "unittest" "$PROJECT_DIR"/*.py 2>/dev/null; then
    TEST_FRAMEWORK="unittest"
fi

UNIT_TESTS=$(find "$PROJECT_DIR" -type f -name "*test*" -o -name "*spec*" | grep -v integration | wc -l)
INTEGRATION_TESTS=$(find "$PROJECT_DIR" -type f -name "*integration*" -o -name "*e2e*" | wc -l)

echo "  → Test framework: $TEST_FRAMEWORK"
echo "  → Unit tests: $UNIT_TESTS"
echo "  → Integration tests: $INTEGRATION_TESTS"

cat >> "$OUTPUT_FILE" << EOF
    "testing": {
      "framework": "$TEST_FRAMEWORK",
      "unitTests": $UNIT_TESTS,
      "integrationTests": $INTEGRATION_TESTS
    },
EOF

# 7. Database Detection
echo -e "\n${YELLOW}Detecting database usage...${NC}"
DATABASE="none"
if grep -r "mongodb\|mongoose" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.json" 2>/dev/null | head -1 > /dev/null; then
    DATABASE="mongodb"
elif grep -r "postgresql\|pg\|postgres" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.json" 2>/dev/null | head -1 > /dev/null; then
    DATABASE="postgresql"
elif grep -r "mysql" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.json" 2>/dev/null | head -1 > /dev/null; then
    DATABASE="mysql"
elif grep -r "sqlite" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.json" --include="*.py" 2>/dev/null | head -1 > /dev/null; then
    DATABASE="sqlite"
elif grep -r "redis" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.json" 2>/dev/null | head -1 > /dev/null; then
    DATABASE="redis"
fi

MIGRATIONS=$(find "$PROJECT_DIR" -type f -path "*/migrations/*" 2>/dev/null | wc -l)
SCHEMAS=$(find "$PROJECT_DIR" -type f -name "*schema*" -o -name "*model*" 2>/dev/null | wc -l)

echo "  → Database: $DATABASE"
echo "  → Migration files: $MIGRATIONS"
echo "  → Schema/Model files: $SCHEMAS"

cat >> "$OUTPUT_FILE" << EOF
    "database": {
      "type": "$DATABASE",
      "migrations": $MIGRATIONS,
      "schemas": $SCHEMAS
    },
EOF

# 8. Documentation Status
echo -e "\n${YELLOW}Checking documentation...${NC}"
README_EXISTS="false"
if [ -f "$PROJECT_DIR/README.md" ] || [ -f "$PROJECT_DIR/README.rst" ] || [ -f "$PROJECT_DIR/README.txt" ]; then
    README_EXISTS="true"
fi

DOCS_DIR_EXISTS="false"
if [ -d "$PROJECT_DIR/docs" ] || [ -d "$PROJECT_DIR/documentation" ]; then
    DOCS_DIR_EXISTS="true"
fi

API_DOCS=$(find "$PROJECT_DIR" -type f -name "*api*.md" -o -name "*swagger*" -o -name "*openapi*" 2>/dev/null | wc -l)
MARKDOWN_FILES=$(find "$PROJECT_DIR" -type f -name "*.md" -not -path "*/node_modules/*" 2>/dev/null | wc -l)

echo "  → README exists: $README_EXISTS"
echo "  → Docs directory exists: $DOCS_DIR_EXISTS"
echo "  → API documentation files: $API_DOCS"
echo "  → Total markdown files: $MARKDOWN_FILES"

cat >> "$OUTPUT_FILE" << EOF
    "documentation": {
      "readmeExists": $README_EXISTS,
      "docsDirectoryExists": $DOCS_DIR_EXISTS,
      "apiDocs": $API_DOCS,
      "markdownFiles": $MARKDOWN_FILES
    },
EOF

# 9. Integration Points
echo -e "\n${YELLOW}Identifying integration points...${NC}"
ENV_FILES=$(find "$PROJECT_DIR" -type f -name ".env*" -not -name ".env.example" 2>/dev/null | wc -l)
CONFIG_FILES=$(find "$PROJECT_DIR" -type f \( -name "*config*" -o -name "*settings*" \) 2>/dev/null | wc -l)
EXTERNAL_APIS=$(grep -r "fetch(\|axios\|requests\|http.get\|http.post" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | wc -l)
WEBHOOKS=$(grep -r "webhook\|hook" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | wc -l)

echo "  → Environment files: $ENV_FILES"
echo "  → Config files: $CONFIG_FILES"
echo "  → External API calls: $EXTERNAL_APIS"
echo "  → Webhooks: $WEBHOOKS"

cat >> "$OUTPUT_FILE" << EOF
    "integrationPoints": {
      "envFiles": $ENV_FILES,
      "configFiles": $CONFIG_FILES,
      "externalAPIs": $EXTERNAL_APIS,
      "webhooks": $WEBHOOKS
    },
EOF

# 10. Code Quality Indicators
echo -e "\n${YELLOW}Assessing code quality indicators...${NC}"
ESLINT_CONFIG="false"
if [ -f "$PROJECT_DIR/.eslintrc.js" ] || [ -f "$PROJECT_DIR/.eslintrc.json" ] || [ -f "$PROJECT_DIR/.eslintrc.yml" ]; then
    ESLINT_CONFIG="true"
fi

PRETTIER_CONFIG="false"
if [ -f "$PROJECT_DIR/.prettierrc" ] || [ -f "$PROJECT_DIR/.prettierrc.js" ] || [ -f "$PROJECT_DIR/.prettierrc.json" ]; then
    PRETTIER_CONFIG="true"
fi

GITIGNORE_EXISTS="false"
if [ -f "$PROJECT_DIR/.gitignore" ]; then
    GITIGNORE_EXISTS="true"
fi

CI_CONFIG="false"
if [ -f "$PROJECT_DIR/.github/workflows/"*.yml ] || [ -f "$PROJECT_DIR/.gitlab-ci.yml" ] || [ -f "$PROJECT_DIR/.travis.yml" ]; then
    CI_CONFIG="true"
fi

echo "  → ESLint configured: $ESLINT_CONFIG"
echo "  → Prettier configured: $PRETTIER_CONFIG"
echo "  → .gitignore exists: $GITIGNORE_EXISTS"
echo "  → CI/CD configured: $CI_CONFIG"

cat >> "$OUTPUT_FILE" << EOF
    "codeQuality": {
      "eslint": $ESLINT_CONFIG,
      "prettier": $PRETTIER_CONFIG,
      "gitignore": $GITIGNORE_EXISTS,
      "cicd": $CI_CONFIG
    }
EOF

# Close JSON structure
cat >> "$OUTPUT_FILE" << EOF
  }
}
EOF

# Final summary
echo -e "\n${GREEN}=== Analysis Complete ===${NC}"
echo -e "Results saved to: ${BLUE}$OUTPUT_FILE${NC}"
echo ""
echo -e "${YELLOW}Integration Health Summary:${NC}"

# Calculate integration health score
HEALTH_SCORE=0
[ "$README_EXISTS" = "true" ] && ((HEALTH_SCORE+=10))
[ "$TEST_FRAMEWORK" != "none" ] && ((HEALTH_SCORE+=20))
[ $INTEGRATION_TESTS -gt 0 ] && ((HEALTH_SCORE+=20))
[ "$DOCS_DIR_EXISTS" = "true" ] && ((HEALTH_SCORE+=10))
[ "$ESLINT_CONFIG" = "true" ] && ((HEALTH_SCORE+=10))
[ "$CI_CONFIG" = "true" ] && ((HEALTH_SCORE+=15))
[ $TEST_FILES -gt 0 ] && ((HEALTH_SCORE+=15))

if [ $HEALTH_SCORE -ge 80 ]; then
    echo -e "  Integration Health: ${GREEN}Excellent ($HEALTH_SCORE/100)${NC}"
elif [ $HEALTH_SCORE -ge 60 ]; then
    echo -e "  Integration Health: ${YELLOW}Good ($HEALTH_SCORE/100)${NC}"
elif [ $HEALTH_SCORE -ge 40 ]; then
    echo -e "  Integration Health: ${YELLOW}Fair ($HEALTH_SCORE/100)${NC}"
else
    echo -e "  Integration Health: ${RED}Poor ($HEALTH_SCORE/100)${NC}"
fi

echo ""
echo "Next steps:"
echo "  1. Review the analysis in $OUTPUT_FILE"
echo "  2. Run integration validation on critical components"
echo "  3. Generate integration tests for uncovered areas"
echo "  4. Update documentation for integration points"

exit 0