#!/bin/bash
# Validation script for recipient files
# Checks that recipient files have required fields and proper format
# Usage: ./validate-recipients.sh [organization-name]
# If no argument provided, validates all organizations

set +e  # Don't exit on first error - check all files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RECIPIENTS_DIR="$SCRIPT_DIR/recipients"

# Colors for output (if supported)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

# Counters
TOTAL_FILES=0
VALID_FILES=0
INVALID_FILES=0
WARNINGS=0

# Function to validate a single recipient file
validate_recipient_file() {
    local file="$1"
    local errors=()
    local warnings=()
    
    # Check if file exists
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗${NC} File not found: $file"
        return 1
    fi
    
    TOTAL_FILES=$((TOTAL_FILES + 1))
    
    # Extract email from filename
    local email="${file##*/}"
    email="${email%.md}"
    
    # Check required fields
    if ! grep -q "^PERSONAL_NAME:" "$file"; then
        errors+=("Missing required field: PERSONAL_NAME")
    fi
    
    if ! grep -q "^FAMILY_NAME:" "$file"; then
        errors+=("Missing required field: FAMILY_NAME")
    fi
    
    # Check email format in file matches filename
    if grep -q "^email:" "$file"; then
        file_email=$(grep "^email:" "$file" | head -n 1 | sed -E 's/^email:[[:space:]]*//' | tr -d '\n')
        if [ -n "$file_email" ] && [ "$file_email" != "$email" ]; then
            warnings+=("Email in file ($file_email) doesn't match filename ($email)")
        fi
    fi
    
    # Check for old format (separate directory with .txt files)
    local recipient_dir="${file%.md}"
    if [ -d "$recipient_dir" ]; then
        if [ -f "$recipient_dir/institution_fit.txt" ] || [ -f "$recipient_dir/person_fit.txt" ]; then
            warnings+=("Old format detected: separate directory with .txt files. Consider migrating to new format.")
        fi
    fi
    
    # Check for OPTIONAL_INSTITUTION_FIT and OPTIONAL_PERSON_FIT in file
    if grep -q "^OPTIONAL_INSTITUTION_FIT:" "$file"; then
        local fit_line=$(grep "^OPTIONAL_INSTITUTION_FIT:" "$file" | head -n 1 | sed -E 's/^OPTIONAL_INSTITUTION_FIT:[[:space:]]*//')
        if [ -z "$fit_line" ]; then
            warnings+=("OPTIONAL_INSTITUTION_FIT field is empty")
        fi
    fi
    
    if grep -q "^OPTIONAL_PERSON_FIT:" "$file"; then
        local fit_line=$(grep "^OPTIONAL_PERSON_FIT:" "$file" | head -n 1 | sed -E 's/^OPTIONAL_PERSON_FIT:[[:space:]]*//')
        if [ -z "$fit_line" ]; then
            warnings+=("OPTIONAL_PERSON_FIT field is empty")
        fi
    fi
    
    # Check connection_type if connection_note is present
    if grep -q "^connection_note:" "$file" && ! grep -q "^connection_type:" "$file"; then
        warnings+=("connection_note present but connection_type missing")
    fi
    
    # Report results
    if [ ${#errors[@]} -eq 0 ] && [ ${#warnings[@]} -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $email"
        VALID_FILES=$((VALID_FILES + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $email"
        INVALID_FILES=$((INVALID_FILES + 1))
        
        if [ ${#errors[@]} -gt 0 ]; then
            for error in "${errors[@]}"; do
                echo "    ${RED}Error:${NC} $error"
            done
        fi
        
        if [ ${#warnings[@]} -gt 0 ]; then
            for warning in "${warnings[@]}"; do
                echo "    ${YELLOW}Warning:${NC} $warning"
                WARNINGS=$((WARNINGS + 1))
            done
        fi
        
        return 1
    fi
}

# Determine which directories to process
if [ $# -eq 0 ]; then
    # Process all directories
    DIRS=$(find "$RECIPIENTS_DIR" -mindepth 1 -maxdepth 1 -type d)
    echo "Validating all organizations..."
else
    # Process specified directory(ies)
    DIRS=()
    for org_arg in "$@"; do
        org_dir="$RECIPIENTS_DIR/$org_arg"
        if [ ! -d "$org_dir" ]; then
            echo "Error: Organization directory '$org_arg' not found in recipients/"
            echo "Available organizations:"
            ls -1 "$RECIPIENTS_DIR"
            exit 1
        fi
        DIRS+=("$org_dir")
    done
    echo "Validating organization(s): $*"
fi

# Convert DIRS to array if it's a string
if [ $# -eq 0 ]; then
    DIRS_ARRAY=($DIRS)
else
    DIRS_ARRAY=("${DIRS[@]}")
fi

# Process each organization directory
for org_dir in "${DIRS_ARRAY[@]}"; do
    org=$(basename "$org_dir")
    echo ""
    echo "=== Validating $org ==="
    
    cd "$org_dir"
    
    # Process each recipient file
    for recipient_file in *.md; do
        # Skip template files
        if [[ "$recipient_file" == "template.md" ]] || \
           [[ "$recipient_file" == "RECIPIENT-FILE-TEMPLATE.md" ]] || \
           [[ "$recipient_file" == "README.md" ]]; then
            continue
        fi
        
        validate_recipient_file "$recipient_file"
    done
    
    cd "$SCRIPT_DIR"
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Validation Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total files checked: $TOTAL_FILES"
echo -e "${GREEN}Valid:${NC} $VALID_FILES"
echo -e "${RED}Invalid:${NC} $INVALID_FILES"
if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
fi

if [ $INVALID_FILES -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ All recipient files are valid!${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}✗ Some recipient files have errors. Please fix them before generating emails.${NC}"
    exit 1
fi

