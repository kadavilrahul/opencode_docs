#!/bin/bash

# Integration Checking Script
# Validates integration points and detects potential issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Arguments
PROJECT_DIR="${1:-.}"
VERBOSE="${2:-false}"

echo -e "${BLUE}=== Integration Check ===${NC}"
echo -e "Checking: ${GREEN}$PROJECT_DIR${NC}"
echo ""

# Track issues
ISSUES_FOUND=0
WARNINGS_FOUND=0

# Function to log issues
log_issue() {
    echo -e "${RED}[ISSUE]${NC} $1"
    ((ISSUES_FOUND++))
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    ((WARNINGS_FOUND++))
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_info() {
    if [ "$VERBOSE" = "true" ]; then
        echo -e "${BLUE}[INFO]${NC} $1"
    fi
}

# 1. Check for Circular Dependencies
echo -e "${YELLOW}Checking for circular dependencies...${NC}"
if command -v npx > /dev/null 2>&1 && [ -f "$PROJECT_DIR/package.json" ]; then
    if npx madge --circular "$PROJECT_DIR/src" 2>/dev/null | grep -q "Found"; then
        log_issue "Circular dependencies detected"
        npx madge --circular "$PROJECT_DIR/src" 2>/dev/null
    else
        log_success "No circular dependencies found"
    fi
else
    log_info "Skipping circular dependency check (no Node.js project detected)"
fi

# 2. Check for Duplicate Function Names
echo -e "\n${YELLOW}Checking for duplicate function definitions...${NC}"
DUPLICATES=$(grep -r "^function \|^const.*=.*=>\|^def " "$PROJECT_DIR" \
    --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | \
    sed 's/.*function \([a-zA-Z0-9_]*\).*/\1/' | \
    sed 's/.*const \([a-zA-Z0-9_]*\).*/\1/' | \
    sed 's/.*def \([a-zA-Z0-9_]*\).*/\1/' | \
    sort | uniq -d)

if [ -n "$DUPLICATES" ]; then
    log_warning "Duplicate function names found:"
    echo "$DUPLICATES" | while read -r func; do
        echo "    - $func"
        if [ "$VERBOSE" = "true" ]; then
            grep -r "function $func\|const $func\|def $func" "$PROJECT_DIR" \
                --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | \
                head -3
        fi
    done
else
    log_success "No duplicate function names found"
fi

# 3. Check for Inconsistent Error Handling
echo -e "\n${YELLOW}Checking error handling consistency...${NC}"
THROW_COUNT=$(grep -r "throw new Error\|raise Exception" "$PROJECT_DIR" \
    --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | wc -l)
CATCH_COUNT=$(grep -r "catch\|except:" "$PROJECT_DIR" \
    --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | wc -l)

if [ $THROW_COUNT -gt $((CATCH_COUNT * 2)) ]; then
    log_warning "Many throws ($THROW_COUNT) but few catches ($CATCH_COUNT) - possible unhandled errors"
else
    log_success "Error handling appears balanced (throws: $THROW_COUNT, catches: $CATCH_COUNT)"
fi

# Check for different error formats
ERROR_FORMATS=$(grep -r "throw\|raise" "$PROJECT_DIR" \
    --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | \
    grep -oE "(Error|Exception|[A-Z][a-zA-Z]*Error|[A-Z][a-zA-Z]*Exception)" | \
    sort -u | wc -l)

if [ $ERROR_FORMATS -gt 5 ]; then
    log_warning "Multiple error types detected ($ERROR_FORMATS different types) - consider standardization"
else
    log_success "Error types appear consistent"
fi

# 4. Check for Broken Imports
echo -e "\n${YELLOW}Checking for broken imports...${NC}"
if [ -f "$PROJECT_DIR/package.json" ]; then
    # Check JavaScript/TypeScript imports
    IMPORTS=$(grep -r "import.*from\|require(" "$PROJECT_DIR" \
        --include="*.js" --include="*.ts" 2>/dev/null | \
        grep -oE "from ['\"]\..*['\"]|require\(['\"]\..*['\"]\)" | \
        sed "s/from ['\"]//g" | sed "s/['\"]//g" | sed "s/require(//g" | sed "s/)//g")
    
    BROKEN_IMPORTS=0
    echo "$IMPORTS" | while read -r import_path; do
        if [ -n "$import_path" ] && [ "$import_path" != "." ]; then
            # Resolve the import path
            if [[ ! -f "$PROJECT_DIR/$import_path" && \
                  ! -f "$PROJECT_DIR/$import_path.js" && \
                  ! -f "$PROJECT_DIR/$import_path.ts" && \
                  ! -f "$PROJECT_DIR/$import_path/index.js" && \
                  ! -f "$PROJECT_DIR/$import_path/index.ts" && \
                  ! -d "$PROJECT_DIR/$import_path" ]]; then
                log_info "Potentially broken import: $import_path"
                ((BROKEN_IMPORTS++))
            fi
        fi
    done
    
    if [ $BROKEN_IMPORTS -eq 0 ]; then
        log_success "All imports appear valid"
    else
        log_warning "$BROKEN_IMPORTS potentially broken imports detected"
    fi
fi

# 5. Check for Unused Dependencies
echo -e "\n${YELLOW}Checking for unused dependencies...${NC}"
if command -v npx > /dev/null 2>&1 && [ -f "$PROJECT_DIR/package.json" ]; then
    UNUSED=$(npx depcheck "$PROJECT_DIR" 2>/dev/null | grep "Unused dependencies" -A 10 | grep "^\*" | wc -l)
    if [ $UNUSED -gt 0 ]; then
        log_warning "$UNUSED unused dependencies found"
        if [ "$VERBOSE" = "true" ]; then
            npx depcheck "$PROJECT_DIR" 2>/dev/null | grep "Unused dependencies" -A 10
        fi
    else
        log_success "No unused dependencies detected"
    fi
else
    log_info "Skipping dependency check (no Node.js project detected)"
fi

# 6. Check for Missing Test Coverage
echo -e "\n${YELLOW}Checking test coverage...${NC}"
SRC_FILES=$(find "$PROJECT_DIR" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" \) \
    -not -path "*/node_modules/*" -not -path "*/test/*" -not -path "*/*test*" \
    -not -path "*/*spec*" 2>/dev/null | wc -l)
TEST_FILES=$(find "$PROJECT_DIR" -type f \( -name "*test*" -o -name "*spec*" \) \
    -not -path "*/node_modules/*" 2>/dev/null | wc -l)

if [ $TEST_FILES -eq 0 ] && [ $SRC_FILES -gt 10 ]; then
    log_issue "No test files found for $SRC_FILES source files"
elif [ $TEST_FILES -lt $((SRC_FILES / 4)) ]; then
    log_warning "Low test coverage: $TEST_FILES test files for $SRC_FILES source files"
else
    log_success "Test coverage appears adequate: $TEST_FILES test files for $SRC_FILES source files"
fi

# 7. Check for API Endpoint Consistency
echo -e "\n${YELLOW}Checking API endpoint consistency...${NC}"
API_PATTERNS=$(grep -r "router\.\|app\.\|@app.route\|@router" "$PROJECT_DIR" \
    --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | \
    grep -oE "['\"]/[a-zA-Z0-9/_-]*['\"]" | \
    sed "s/['\"]//g" | sort -u)

# Check for inconsistent naming patterns
CAMEL_CASE=$(echo "$API_PATTERNS" | grep -E "/[a-z]+[A-Z]" | wc -l)
SNAKE_CASE=$(echo "$API_PATTERNS" | grep -E "/_" | wc -l)
KEBAB_CASE=$(echo "$API_PATTERNS" | grep -E "/-" | wc -l)

if [ $CAMEL_CASE -gt 0 ] && [ $SNAKE_CASE -gt 0 ]; then
    log_warning "Mixed API naming conventions detected (camelCase and snake_case)"
elif [ $CAMEL_CASE -gt 0 ] && [ $KEBAB_CASE -gt 0 ]; then
    log_warning "Mixed API naming conventions detected (camelCase and kebab-case)"
elif [ $SNAKE_CASE -gt 0 ] && [ $KEBAB_CASE -gt 0 ]; then
    log_warning "Mixed API naming conventions detected (snake_case and kebab-case)"
else
    log_success "API naming conventions appear consistent"
fi

# 8. Check for Database Schema Consistency
echo -e "\n${YELLOW}Checking database schema consistency...${NC}"
MIGRATION_FILES=$(find "$PROJECT_DIR" -type f -path "*/migrations/*" 2>/dev/null | wc -l)
MODEL_FILES=$(find "$PROJECT_DIR" -type f \( -name "*model*" -o -name "*schema*" \) \
    -not -path "*/node_modules/*" 2>/dev/null | wc -l)

if [ $MODEL_FILES -gt 0 ] && [ $MIGRATION_FILES -eq 0 ]; then
    log_warning "Models found but no migrations - database schema might be out of sync"
elif [ $MIGRATION_FILES -gt 0 ] && [ $MODEL_FILES -eq 0 ]; then
    log_warning "Migrations found but no models - possible orphaned migrations"
else
    log_success "Database schema and migrations appear aligned"
fi

# 9. Check for Configuration Issues
echo -e "\n${YELLOW}Checking configuration consistency...${NC}"
ENV_EXAMPLE=$(find "$PROJECT_DIR" -name ".env.example" -o -name ".env.sample" 2>/dev/null | head -1)
ENV_FILE=$(find "$PROJECT_DIR" -name ".env" 2>/dev/null | head -1)

if [ -n "$ENV_EXAMPLE" ] && [ -n "$ENV_FILE" ]; then
    EXAMPLE_VARS=$(grep -E "^[A-Z_]+=?" "$ENV_EXAMPLE" | cut -d= -f1 | sort)
    ACTUAL_VARS=$(grep -E "^[A-Z_]+=?" "$ENV_FILE" | cut -d= -f1 | sort)
    
    MISSING_VARS=$(comm -23 <(echo "$EXAMPLE_VARS") <(echo "$ACTUAL_VARS"))
    if [ -n "$MISSING_VARS" ]; then
        log_warning "Variables in .env.example but missing in .env:"
        echo "$MISSING_VARS" | while read -r var; do
            echo "    - $var"
        done
    else
        log_success "Environment configuration appears complete"
    fi
elif [ -n "$ENV_EXAMPLE" ] && [ -z "$ENV_FILE" ]; then
    log_warning ".env.example exists but no .env file found"
else
    log_info "No environment configuration to check"
fi

# 10. Check for Documentation Freshness
echo -e "\n${YELLOW}Checking documentation freshness...${NC}"
if [ -f "$PROJECT_DIR/README.md" ]; then
    README_AGE=$(find "$PROJECT_DIR" -name "README.md" -mtime +30 | wc -l)
    if [ $README_AGE -gt 0 ]; then
        log_warning "README.md hasn't been updated in over 30 days"
    else
        log_success "README.md appears current"
    fi
fi

OUTDATED_DOCS=$(find "$PROJECT_DIR/docs" -name "*.md" -mtime +60 2>/dev/null | wc -l)
if [ $OUTDATED_DOCS -gt 0 ]; then
    log_warning "$OUTDATED_DOCS documentation files haven't been updated in over 60 days"
fi

# Summary
echo -e "\n${BLUE}=== Integration Check Summary ===${NC}"
echo -e "Issues found: ${RED}$ISSUES_FOUND${NC}"
echo -e "Warnings found: ${YELLOW}$WARNINGS_FOUND${NC}"

if [ $ISSUES_FOUND -eq 0 ] && [ $WARNINGS_FOUND -eq 0 ]; then
    echo -e "\n${GREEN}✓ Integration check passed with no issues!${NC}"
    exit 0
elif [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "\n${YELLOW}⚠ Integration check passed with warnings${NC}"
    exit 0
else
    echo -e "\n${RED}✗ Integration check failed with critical issues${NC}"
    exit 1
fi