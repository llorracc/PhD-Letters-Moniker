#!/bin/bash
# Generalized email generation script for recommendation letter outreach
# Usage: ./emails-make.sh [organization-name] [--preview]
# If no argument provided, processes all organizations in recipients/
# Use --preview flag to generate student-accessible previews

# Don't exit on error - continue processing remaining files even if one fails
set +e

# Detect non-interactive mode (no TTY or CI environment)
if [ ! -t 0 ] || [ -n "$CI" ] || [ -n "$NONINTERACTIVE" ]; then
    # Non-interactive mode: skip confirmations
    export NONINTERACTIVE=1
    # For zsh: disable rm confirmation prompts
    if [ -n "$ZSH_VERSION" ]; then
        setopt RM_STAR_SILENT 2>/dev/null || true
        unsetopt RM_STAR_WAIT 2>/dev/null || true
    fi
    # For bash: ensure no confirmation prompts
    # Use -f flag for rm to skip prompts
fi

# Check for preview mode
PREVIEW_MODE=false
ORG_ARGS=()
for arg in "$@"; do
    if [[ "$arg" == "--preview" ]]; then
        PREVIEW_MODE=true
    else
        ORG_ARGS+=("$arg")
    fi
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RECIPIENTS_DIR="$SCRIPT_DIR/recipients"
DEFAULTS_FILE="$SCRIPT_DIR/student-info.md"
TEMPLATE_BASE_DIR="$SCRIPT_DIR/recipients"

# Function to validate and sanitize content from files (prevent terminal output contamination)
validate_file_content() {
    local content="$1"
    local file_path="$2"
    
    # Check for common shell command patterns
    if echo "$content" | grep -qE '^(cd |echo |ls |cat |grep |sed |awk |find |git |\./|/bin/|/usr/bin/)'; then
        echo "Warning: Suspicious content detected in $file_path (starts with shell command)" >&2
        return 1
    fi
    
    # Check for shell command patterns anywhere
    # Note: Removed '; |' from pattern as semicolons are common in prose punctuation
    # Only flag actual shell metacharacters that indicate injection attempts
    if echo "$content" | grep -qE '(cd ["'\'']|echo ["'\'']|&& |\|\| |\$\(|`|\[OPTIONAL_[A-Z_]+\]\[OPTIONAL_[A-Z_]+\])'; then
        echo "Warning: Suspicious content detected in $file_path (contains shell command patterns)" >&2
        return 1
    fi
    
    # Check for terminal prompt patterns
    if echo "$content" | grep -qE '^\$ |^# |^> |^➜ |^✓ |^━━'; then
        echo "Warning: Suspicious content detected in $file_path (looks like terminal prompt/output)" >&2
        return 1
    fi
    
    # Check for file paths that look like commands
    if echo "$content" | grep -qE '^["'\'']?/Volumes/|^["'\'']?/Users/.*/PhD-.*/email-templates'; then
        echo "Warning: Suspicious content detected in $file_path (looks like file path from terminal output)" >&2
        return 1
    fi
    
    return 0
}

# Function to sanitize content from files (remove common terminal artifacts)
sanitize_file_content() {
    local content="$1"
    
    # Remove leading/trailing whitespace
    content=$(echo "$content" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    # Remove common terminal artifacts at the start
    content=$(echo "$content" | sed 's/^[[:space:]]*\$[[:space:]]*//')  # Remove "$ " prompt
    content=$(echo "$content" | sed 's/^[[:space:]]*#[[:space:]]*//')   # Remove "# " prompt
    content=$(echo "$content" | sed 's/^[[:space:]]*>[[:space:]]*//')   # Remove "> " prompt
    
    echo "$content"
}

# Function to load default values from student-info.md
load_defaults() {
    local defaults_file="$1"
    if [ ! -f "$defaults_file" ]; then
        echo "Warning: Defaults file not found: $defaults_file" >&2
        return 1
    fi
    
    # Parse student-info.md using awk and write to temp file, then source it
    # This avoids subshell issues with export
    # Supports both old format (### VARIABLE_NAME / **Default:** `"value"`)
    # and new simplified format (VARIABLE_NAME: "value")
    local temp_file=$(mktemp)
    awk '
        # Old format: ### VARIABLE_NAME
        /^### / {
            # Extract variable name from ### VARIABLE_NAME
            gsub(/^### +/, "")
            current_var = $0
        }
        # Old format: **Default:** `"value"`
        /^\*\*Default:\*\*/ && current_var != "" {
            # Extract value from **Default:** `"value"`
            # Match pattern: `"value"` where value is captured
            if (match($0, /`"[^"]*"`/)) {
                # Extract the value between the quotes
                match_str = substr($0, RSTART, RLENGTH)
                gsub(/`"/, "", match_str)
                gsub(/"`/, "", match_str)
                default_value = match_str
                # Only export if variable name is valid (contains only A-Z, 0-9, _)
                if (current_var ~ /^[A-Z_][A-Z0-9_]*$/) {
                    printf "export DEFAULT_%s=\"%s\"\n", current_var, default_value
                }
                current_var = ""
            }
        }
        # New simplified format: VARIABLE_NAME: "value"
        /^[A-Z_][A-Z0-9_]*: "/ {
            # Extract variable name and value
            var_name = $1
            gsub(/:$/, "", var_name)
            # Extract everything after the colon and space
            rest = substr($0, index($0, ":") + 1)
            gsub(/^ +/, "", rest)  # Remove leading spaces
            # Extract value between quotes
            if (match(rest, /"[^"]*"/)) {
                match_str = substr(rest, RSTART, RLENGTH)
                gsub(/"/, "", match_str)  # Remove quotes
                printf "export DEFAULT_%s=\"%s\"\n", var_name, match_str
            }
        }
    ' "$defaults_file" > "$temp_file"
    
    # Source the temp file to load the exports
    source "$temp_file"
    rm -f "$temp_file"
}

# Function to extract institution name from email domain (for THE_INSTITUTION field)
extract_institution_from_email() {
    local email="$1"
    local org_type="$2"
    
    # Extract domain
    local domain=$(echo "$email" | sed 's/.*@//')
    
    # Policy institution mappings (most specific first)
    case "$domain" in
        riksbank.se|*.riksbank.se) echo "the Riksbank" && return ;;
        norges-bank.no|*.norges-bank.no) echo "Norges Bank" && return ;;
        ec.europa.eu|*.ec.europa.eu) echo "the European Commission" && return ;;
        frb.gov|*.frb.gov) echo "the Federal Reserve Board" && return ;;
        cbo.gov|*.cbo.gov) echo "the Congressional Budget Office" && return ;;
        rba.gov.au|*.rba.gov.au) echo "the Reserve Bank of Australia" && return ;;
        bundesbank.de|*.bundesbank.de) echo "the Bundesbank" && return ;;
        ecb.europa.eu|*.ecb.europa.eu) echo "the ECB" && return ;;
    esac
    
    # Fallback: just return the domain as-is (with dots intact)
    local base_domain=$(echo "$domain" | sed 's/\.gov.*$//' | sed 's/\.europa\.eu$//')
    
    # Return the domain name with dots intact
    echo "$base_domain"
}

# Function to apply default values to a file
apply_defaults() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    # Start with original file
    cp "$file" "$temp_file"
    
    # Get all DEFAULT_* environment variables and apply them
    # Iterate through all environment variables
    for var in $(compgen -v | grep "^DEFAULT_"); do
        local var_name="${var#DEFAULT_}"
        local default_value="${!var}"
        
        # Skip recipient_personalname - it's handled separately (from personal_name field)
        if [ "$var_name" = "recipient_personalname" ]; then
            continue
        fi
        
        # Only replace if default is not empty
        # If empty, leave the placeholder intact - it will be handled by fill-email-fields.sh
        if [ -n "$default_value" ]; then
            # Replace [VAR_NAME] with default value
            # Use rpl if available (handles special characters better)
            if command -v rpl &> /dev/null; then
                rpl --fixed-strings "[${var_name}]" "$default_value" "$temp_file" 2>/dev/null
            else
                # Use sed with proper escaping for special characters
                # Escape the default value for sed (escape backslashes first, then other special chars)
                local escaped_value=$(printf '%s\n' "$default_value" | sed 's/\\/\\\\/g' | sed 's/[[\.*^$()+?{|]/\\&/g' | sed 's/|/\\|/g')
                # Use | as delimiter to avoid issues with / in paths
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    # macOS sed
                    sed -i '' "s|\[${var_name}\]|${escaped_value}|g" "$temp_file" 2>/dev/null
                else
                    # Linux sed
                    sed -i "s|\[${var_name}\]|${escaped_value}|g" "$temp_file" 2>/dev/null
                fi
            fi
        fi
    done
    
    # Move temp file back
    mv "$temp_file" "$file"
}

# Load defaults at script startup
load_defaults "$DEFAULTS_FILE"

# Both normal and preview modes output to preview-emails/ (shared repo)
# fill-email-fields.sh reads from preview-emails/ and adds private content (letter excerpt + full recommendation text)
OUTPUT_BASE_DIR="$SCRIPT_DIR/preview-emails"

if [ "$PREVIEW_MODE" = true ]; then
    # Student preview mode: recommendation text replaced with [saynicethings] placeholder
    echo "=== PREVIEW MODE: Generating student-accessible previews ==="
else
    # Normal mode: full recommendation text included
    # Workflow:
    # 1. emails-make.sh (normal) → generates to preview-emails/ (with full recommendation text)
    # 2. fill-email-fields.sh → reads from preview-emails/ → adds letter excerpt → creates filled versions → emails/generated/
    # 3. emails-make.sh (--preview) → generates to preview-emails/ (with [saynicethings] placeholder for student review)
    PRIVATE_DIR="$(cd "$SCRIPT_DIR/../../PhD-RecLetters-private" && pwd)"
    EXCERPT_FILE="$PRIVATE_DIR/emails/letter-excerpt.txt"
    echo "=== Generating emails to preview-emails/ (will be used by fill-email-fields.sh) ==="
fi

# Check if excerpt file exists (only in normal mode)
# Note: Letter excerpt is NOT added here - it's added by fill-email-fields.sh when copying to private repo
if [ "$PREVIEW_MODE" = false ]; then
    if [ ! -f "$EXCERPT_FILE" ]; then
        echo "Note: Letter excerpt file not found at $EXCERPT_FILE"
        echo "Letter excerpt will be skipped when fill-email-fields.sh processes emails."
    fi
fi

# Determine which directories to process
if [ ${#ORG_ARGS[@]} -eq 0 ]; then
    # Process all directories
    DIRS=$(find "$RECIPIENTS_DIR" -mindepth 1 -maxdepth 1 -type d)
    echo "Processing all organizations..."
else
    # Process specified directory(ies)
    DIRS=()
    for org_arg in "${ORG_ARGS[@]}"; do
        org_dir="$RECIPIENTS_DIR/$org_arg"
        if [ ! -d "$org_dir" ]; then
            echo "Error: Organization directory '$org_arg' not found in recipients/"
            echo "Available organizations:"
            ls -1 "$RECIPIENTS_DIR"
            exit 1
        fi
        DIRS+=("$org_dir")
    done
    echo "Processing organization(s): ${ORG_ARGS[*]}"
fi

# Convert DIRS to array if it's a string (from find command)
if [ ${#ORG_ARGS[@]} -eq 0 ]; then
    # DIRS is result of find command (space-separated string)
    DIRS_ARRAY=($DIRS)
else
    # DIRS is already an array
    DIRS_ARRAY=("${DIRS[@]}")
fi

# Process each organization directory
for org_dir in "${DIRS_ARRAY[@]}"; do
    org=$(basename "$org_dir")
    echo ""
    echo "=== Processing $org ==="
    
    cd "$org_dir"
    
    # Create output directory
    output_dir="$OUTPUT_BASE_DIR/$org"
    mkdir -p "$output_dir"
    
    # Template file matches directory name (e.g., academic-position/ → academic-position.md)
    template_path="$TEMPLATE_BASE_DIR/$org.md"
    
    # Check if template exists
    if [ ! -f "$template_path" ]; then
        echo "  Error: Template not found: $template_path"
        continue
    fi
    
    # Check if there are any actual recipient files in this directory
    # Count .md files (will be at least 1 if glob doesn't expand - the literal "*.md")
    recipient_files=(*.md)
    if [ ! -e "${recipient_files[0]}" ]; then
        echo "  No recipient files found, skipping"
        continue
    fi
    
    # Process each recipient file
    recipient_count=0
    for recipient_file in *.md; do
        
        # Note: We generate emails for ALL recipients, including those that have been
        # marked for omission in fill-email-fields.sh. This is intentional because:
        # 1. These are template messages that serve as the source for fill-email-fields.sh
        # 2. The fill-email-fields.sh script reads from preview-emails/ and creates filled
        #    versions in emails/generated/ (or emails/omitted/ if the user chooses to omit)
        # 3. Having the template available allows the user to change their mind and move
        #    a recipient from omitted/ back to generated/ if needed
        # The actual decision to omit is made interactively in fill-email-fields.sh, not here.
        
        echo "  - Generating email for $recipient_file"
        
        # Extract email address
        # Default: extract from filename
        email="${recipient_file%.md}"
        
        # Initialize variables to empty for each recipient
        # This ensures no values persist from previous recipients
        institution_fit=""
        person_fit=""
        people_at_institution=""
        nickname=""
        personal_name=""
        family_name=""
        email=""
        Personalname=""
        
        # NEW FORMAT: Extract all fields from recipient file
        # All recipient files should now use the new format with required fields
        
        # Extract email from file (required field, fallback to filename if missing)
        email_line=$(grep -i "^email:" "$recipient_file" | head -n 1)
        if [ -n "$email_line" ]; then
            email=$(echo "$email_line" | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
        fi
        # If email not found in file, use filename (backward compatibility)
        if [ -z "$email" ]; then
            email="${recipient_file%.md}"
        fi
        
        # Extract PERSONAL_NAME (REQUIRED - appears in email)
        personal_name_line=$(grep -i "^PERSONAL_NAME:" "$recipient_file" | head -n 1)
        if [ -n "$personal_name_line" ]; then
            personal_name=$(echo "$personal_name_line" | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
        else
            echo "    Error: Missing required field 'PERSONAL_NAME' in $recipient_file"
            continue
        fi
        
        # Extract FAMILY_NAME (REQUIRED - appears in email)
        family_name_line=$(grep -i "^FAMILY_NAME:" "$recipient_file" | head -n 1)
        if [ -n "$family_name_line" ]; then
            family_name=$(echo "$family_name_line" | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
        else
            echo "    Error: Missing required field 'FAMILY_NAME' in $recipient_file"
            continue
        fi
        
        # Extract NICKNAME (optional - used in salutation)
        nickname_line=$(grep -i "^NICKNAME:" "$recipient_file" | head -n 1)
        if [ -n "$nickname_line" ]; then
            nickname=$(echo "$nickname_line" | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
        fi
        
        # Extract OPTIONAL_INSTITUTION_FIT from file (optional)
        institution_fit_line=$(grep -i "^OPTIONAL_INSTITUTION_FIT:" "$recipient_file" | head -n 1)
        if [ -n "$institution_fit_line" ]; then
            raw_fit=$(echo "$institution_fit_line" | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
            institution_fit=$(sanitize_file_content "$raw_fit")
            if ! validate_file_content "$institution_fit" "$recipient_file"; then
                echo "    Warning: Skipping suspicious content in OPTIONAL_INSTITUTION_FIT for $email"
                institution_fit=""
            fi
        fi
        
        # Extract OPTIONAL_PERSON_FIT from file (optional)
        person_fit_line=$(grep -i "^OPTIONAL_PERSON_FIT:" "$recipient_file" | head -n 1)
        if [ -n "$person_fit_line" ]; then
            raw_fit=$(echo "$person_fit_line" | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
            person_fit=$(sanitize_file_content "$raw_fit")
            if ! validate_file_content "$person_fit" "$recipient_file"; then
                echo "    Warning: Skipping suspicious content in OPTIONAL_PERSON_FIT for $email"
                person_fit=""
            fi
        fi
        
        # Extract OPTIONAL_PEOPLE_AT_THE_INSTITUTION from file (optional)
        people_at_institution_line=$(grep -i "^OPTIONAL_PEOPLE_AT_THE_INSTITUTION:" "$recipient_file" | head -n 1)
        if [ -n "$people_at_institution_line" ]; then
            raw_people=$(echo "$people_at_institution_line" | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
            people_at_institution=$(sanitize_file_content "$raw_people")
            if ! validate_file_content "$people_at_institution" "$recipient_file"; then
                echo "    Warning: Skipping suspicious content in OPTIONAL_PEOPLE_AT_THE_INSTITUTION for $email"
                people_at_institution=""
            fi
        fi
        
        # Extract CUSTOM_CONTENT from file (optional)
        custom_content=""
        custom_content_line=$(grep -i "^CUSTOM_CONTENT:" "$recipient_file" | head -n 1)
        if [ -n "$custom_content_line" ]; then
            raw_content=$(echo "$custom_content_line" | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
            custom_content=$(sanitize_file_content "$raw_content")
            if ! validate_file_content "$custom_content" "$recipient_file"; then
                echo "    Warning: Skipping suspicious content in CUSTOM_CONTENT for $email"
                custom_content=""
            fi
        fi
        
        # Determine Personalname for salutation
        # Priority 1: nickname (if present)
        if [ -n "$nickname" ]; then
            Personalname="$(tr '[:lower:]' '[:upper:]' <<< ${nickname:0:1})${nickname:1}"
        # Priority 2: personal_name (REQUIRED, so always present)
        else
            Personalname="$(tr '[:lower:]' '[:upper:]' <<< ${personal_name:0:1})${personal_name:1}"
        fi
        
        # Output file
        output_file="$output_dir/$email.eml"
        
        # Start with template (remove comment lines starting with %)
        grep -v '^%' "$template_path" > "$output_file"
        
        # Apply default values from student-info.md first
        apply_defaults "$output_file"
        
        # Replace basic placeholders (these are always filled from email/name, not defaults)
        if command -v rpl &> /dev/null; then
            rpl --fixed-strings '[recipient_personalname]' "$Personalname" "$output_file" 2>/dev/null
            rpl --fixed-strings 'recipient@place.dom' "$email" "$output_file" 2>/dev/null
        else
            # Fallback to sed if rpl not available (macOS-compatible)
            sed -i '' "s/\[recipient_personalname\]/$Personalname/g" "$output_file" 2>/dev/null || \
            sed -i.bak "s/\[recipient_personalname\]/$Personalname/g" "$output_file" 2>/dev/null
            sed -i '' "s/recipient@place\.dom/$email/g" "$output_file" 2>/dev/null || \
            sed -i.bak "s/recipient@place\.dom/$email/g" "$output_file" 2>/dev/null
            rm -f "$output_file.bak"
        fi
        
        # Clean up empty parentheses from optional URL fields (e.g., if JOBMARKET_PAPER_URL is empty)
        # Remove patterns like " ()" or " ( )" that result from empty optional URLs
        # This handles cases like: "Title" () or "Title" ( )
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' 's/" ([ ]*)/"/g' "$output_file" 2>/dev/null || \
            sed -i.bak 's/" ([ ]*)/"/g' "$output_file" 2>/dev/null
            sed -i '' 's/ ([ ]*),/,/g' "$output_file" 2>/dev/null || \
            sed -i.bak 's/ ([ ]*),/,/g' "$output_file" 2>/dev/null
            rm -f "$output_file.bak"
        else
            sed -i 's/" ([ ]*)/"/g' "$output_file" 2>/dev/null
            sed -i 's/ ([ ]*),/,/g' "$output_file" 2>/dev/null
        fi
        
        # Replace institution_fit if present
        if [ -n "$institution_fit" ]; then
            # Escape special characters for sed
            escaped_fit=$(printf '%s\n' "$institution_fit" | sed 's/[[\.*^$()+?{|]/\\&/g')
            if command -v rpl &> /dev/null; then
                rpl --fixed-strings '[OPTIONAL_INSTITUTION_FIT]' "$institution_fit" "$output_file" 2>/dev/null
            else
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    sed -i '' "s|\[OPTIONAL_INSTITUTION_FIT\]|${escaped_fit}|g" "$output_file" 2>/dev/null || \
                    sed -i.bak "s|\[OPTIONAL_INSTITUTION_FIT\]|${escaped_fit}|g" "$output_file" 2>/dev/null
                else
                    sed -i "s|\[OPTIONAL_INSTITUTION_FIT\]|${escaped_fit}|g" "$output_file" 2>/dev/null
                fi
                rm -f "$output_file.bak"
            fi
        fi
        
        # Replace person_fit if present
        if [ -n "$person_fit" ]; then
            # Escape special characters for sed
            escaped_fit=$(printf '%s\n' "$person_fit" | sed 's/[[\.*^$()+?{|]/\\&/g')
            if command -v rpl &> /dev/null; then
                rpl --fixed-strings '[OPTIONAL_PERSON_FIT]' "$person_fit" "$output_file" 2>/dev/null
            else
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    sed -i '' "s|\[OPTIONAL_PERSON_FIT\]|${escaped_fit}|g" "$output_file" 2>/dev/null || \
                    sed -i.bak "s|\[OPTIONAL_PERSON_FIT\]|${escaped_fit}|g" "$output_file" 2>/dev/null
                else
                    sed -i "s|\[OPTIONAL_PERSON_FIT\]|${escaped_fit}|g" "$output_file" 2>/dev/null
                fi
                rm -f "$output_file.bak"
            fi
        fi
        
        # Replace people_at_institution if present
        if [ -n "$people_at_institution" ]; then
            # Escape special characters for sed
            escaped_people=$(printf '%s\n' "$people_at_institution" | sed 's/[[\.*^$()+?{|]/\\&/g')
            if command -v rpl &> /dev/null; then
                rpl --fixed-strings '[OPTIONAL_PEOPLE_AT_THE_INSTITUTION]' "$people_at_institution" "$output_file" 2>/dev/null
            else
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    sed -i '' "s|\[OPTIONAL_PEOPLE_AT_THE_INSTITUTION\]|${escaped_people}|g" "$output_file" 2>/dev/null || \
                    sed -i.bak "s|\[OPTIONAL_PEOPLE_AT_THE_INSTITUTION\]|${escaped_people}|g" "$output_file" 2>/dev/null
                else
                    sed -i "s|\[OPTIONAL_PEOPLE_AT_THE_INSTITUTION\]|${escaped_people}|g" "$output_file" 2>/dev/null
                fi
                rm -f "$output_file.bak"
            fi
        fi
        
        # Replace THE_INSTITUTION if template uses it (policy templates)
        # Check if template contains [THE_INSTITUTION] placeholder
        if grep -q "\[THE_INSTITUTION\]" "$output_file" 2>/dev/null; then
            # Determine institution name
            the_institution=""
            
            # Priority 1: Check for organization-specific default
            case "$org" in
                FedBoard) the_institution="the Federal Reserve Board" ;;
                ECB) the_institution="the ECB" ;;
                Bundesbank) the_institution="the Bundesbank" ;;
                Other)
                    # For "Other" organizations, extract from email domain
                    the_institution=$(extract_institution_from_email "$email" "$org")
                    ;;
            esac
            
            # Priority 2: If still empty, try to extract from email domain
            if [ -z "$the_institution" ]; then
                the_institution=$(extract_institution_from_email "$email" "$org")
            fi
            
            # Replace placeholder if we have a value
            if [ -n "$the_institution" ]; then
                escaped_institution=$(printf '%s\n' "$the_institution" | sed 's/[[\.*^$()+?{|]/\\&/g')
                if command -v rpl &> /dev/null; then
                    rpl --fixed-strings '[THE_INSTITUTION]' "$the_institution" "$output_file" 2>/dev/null
                else
                    if [[ "$OSTYPE" == "darwin"* ]]; then
                        sed -i '' "s|\[THE_INSTITUTION\]|${escaped_institution}|g" "$output_file" 2>/dev/null || \
                        sed -i.bak "s|\[THE_INSTITUTION\]|${escaped_institution}|g" "$output_file" 2>/dev/null
                    else
                        sed -i "s|\[THE_INSTITUTION\]|${escaped_institution}|g" "$output_file" 2>/dev/null
                    fi
                    rm -f "$output_file.bak"
                fi
            fi
        fi
        
        # In preview mode, replace recommendation text with [saynicethings] placeholder
        if [ "$PREVIEW_MODE" = true ]; then
            # Replace the opening recommendation sentence with "[saynicethings]"
            # This shows the student where personalized content will go (advisor will fill in the actual recommendation text)
            # Match the full sentence from "I am writing" to "outstanding addition to your department."
            # Use perl for more flexible matching, or sed with a simpler pattern
            if command -v perl &> /dev/null; then
                perl -i -pe 's/I am writing to enthusiastically recommend.*?outstanding addition to your department\./[saynicethings]/s' "$output_file"
            else
                # Fallback: use sed with a pattern that matches the sentence
                # The sentence ends with "outstanding addition to your department."
                sed 's/I am writing to enthusiastically recommend.*outstanding addition to your department\./[saynicethings]/' "$output_file" > "${output_file}.tmp"
                mv "${output_file}.tmp" "$output_file"
            fi
        fi
        
        # Insert custom content if file is non-empty
        if [ -s "$recipient_file" ]; then
            # DEBUG: set DEBUG_EMAIL=<address> to log how one recipient file is processed
            DEBUG_MICHAEL=false
            if [[ -n "${DEBUG_EMAIL:-}" && "$email" == "$DEBUG_EMAIL" ]]; then
                DEBUG_MICHAEL=true
                DEBUG_LOG="/tmp/debug_michael_$(date +%s).log"
                echo "=== DEBUG: Processing $email ===" > "$DEBUG_LOG"
                echo "Recipient file: $recipient_file" >> "$DEBUG_LOG"
                echo "Output file: $output_file" >> "$DEBUG_LOG"
                echo "Timestamp: $(date)" >> "$DEBUG_LOG"
                echo "" >> "$DEBUG_LOG"
            fi
            
            # Extract content to insert (filter out comments, metadata fields, and fit fields)
            temp_content_file=$(mktemp)
            if [ "$DEBUG_MICHAEL" = true ]; then
                echo "=== DEBUG: Extracting custom content ===" >> "$DEBUG_LOG"
                echo "Temp content file: $temp_content_file" >> "$DEBUG_LOG"
                echo "Recipient file path: $recipient_file" >> "$DEBUG_LOG"
                echo "" >> "$DEBUG_LOG"
            fi
            
            # Filter out: comment lines (starting with % or # but not ##), metadata fields, section headers
            # This extracts only the actual custom content paragraphs that should be inserted into the email
            grep -v "^%" "$recipient_file" | \
                grep -v "^# " | \
                grep -v "^## " | \
                grep -v -i "^email:" | \
                grep -v -i "^PERSONAL_NAME:" | \
                grep -v -i "^FAMILY_NAME:" | \
                grep -v -i "^name:" | \
                grep -v -i "^NICKNAME:" | \
                grep -v -i "^optional_private_comment_to_advisor:" | \
                grep -v -i "^OPTIONAL_INSTITUTION_FIT:" | \
                grep -v -i "^OPTIONAL_PERSON_FIT:" | \
                grep -v -i "^OPTIONAL_PEOPLE_AT_THE_INSTITUTION:" | \
                grep -v -i "^CUSTOM_CONTENT:" | \
                grep -v "^$" > "$temp_content_file" 2>&1
            
            if [ "$DEBUG_MICHAEL" = true ]; then
                echo "=== DEBUG: After grep pipeline ===" >> "$DEBUG_LOG"
                echo "Exit code: $?" >> "$DEBUG_LOG"
                echo "Temp file size: $(wc -c < "$temp_content_file" 2>/dev/null || echo 0) bytes" >> "$DEBUG_LOG"
                echo "Temp file exists: $([ -f "$temp_content_file" ] && echo yes || echo no)" >> "$DEBUG_LOG"
                echo "" >> "$DEBUG_LOG"
                echo "=== DEBUG: Contents of temp_content_file ===" >> "$DEBUG_LOG"
                if [ -f "$temp_content_file" ]; then
                    cat "$temp_content_file" >> "$DEBUG_LOG" || echo "(error reading file)" >> "$DEBUG_LOG"
                else
                    echo "(file does not exist)" >> "$DEBUG_LOG"
                fi
                echo "" >> "$DEBUG_LOG"
                echo "=== DEBUG: Checking if temp file is non-empty ===" >> "$DEBUG_LOG"
                [ -s "$temp_content_file" ] && echo "File is non-empty" >> "$DEBUG_LOG" || echo "File is empty or doesn't exist" >> "$DEBUG_LOG"
                echo "" >> "$DEBUG_LOG"
            fi
            
            # Only insert if there's actual content (not just metadata/comments)
            # Also validate that it doesn't contain file paths or error messages
            if [ -s "$temp_content_file" ] && ! grep -qE "(^at |/Volumes/|/Users/|error|Error)" "$temp_content_file" 2>/dev/null; then
                if [ "$DEBUG_MICHAEL" = true ]; then
                    echo "=== DEBUG: About to insert custom content ===" >> "$DEBUG_LOG"
                    echo "Validation passed: file is non-empty and doesn't contain file paths" >> "$DEBUG_LOG"
                fi
                echo "    (includes custom content)"
                # Insert after "[saynicethings]", "[CDC_NICE_THINGS]", "I'm reaching out", or "Dear" line
                if [ "$PREVIEW_MODE" = true ]; then
                    # Try [saynicethings] first (base-recommendation template), then [CDC_NICE_THINGS] (academic-position template)
                    if grep -q "\[saynicethings\]" "$output_file"; then
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "=== DEBUG: Inserting after [saynicethings] ===" >> "$DEBUG_LOG"
                            echo "Command: sed \"/\[saynicethings\]/r $temp_content_file\" \"$output_file\" > \"${output_file}.tmp\"" >> "$DEBUG_LOG"
                        fi
                        sed "/\[saynicethings\]/r $temp_content_file" "$output_file" > "${output_file}.tmp" 2>&1
                        SED_EXIT=$?
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "Sed exit code: $SED_EXIT" >> "$DEBUG_LOG"
                            if [ $SED_EXIT -ne 0 ]; then
                                echo "=== DEBUG: SED ERROR OUTPUT ===" >> "$DEBUG_LOG"
                                cat "${output_file}.tmp" >> "$DEBUG_LOG" 2>&1 || echo "(error reading tmp file)" >> "$DEBUG_LOG"
                            fi
                        fi
                        if [ $SED_EXIT -eq 0 ]; then
                            mv "${output_file}.tmp" "$output_file"
                        else
                            rm -f "${output_file}.tmp"
                        fi
                    elif grep -q "\[CDC_NICE_THINGS\]" "$output_file"; then
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "=== DEBUG: Inserting after [CDC_NICE_THINGS] ===" >> "$DEBUG_LOG"
                            echo "Command: sed \"/\[CDC_NICE_THINGS\]/r $temp_content_file\" \"$output_file\" > \"${output_file}.tmp\"" >> "$DEBUG_LOG"
                        fi
                        sed "/\[CDC_NICE_THINGS\]/r $temp_content_file" "$output_file" > "${output_file}.tmp" 2>&1
                        SED_EXIT=$?
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "Sed exit code: $SED_EXIT" >> "$DEBUG_LOG"
                        fi
                        if [ $SED_EXIT -eq 0 ]; then
                            mv "${output_file}.tmp" "$output_file"
                        else
                            rm -f "${output_file}.tmp"
                        fi
                    elif grep -q "^Dear " "$output_file"; then
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "=== DEBUG: Inserting after 'Dear ' ===" >> "$DEBUG_LOG"
                            echo "Command: sed \"/^Dear /r $temp_content_file\" \"$output_file\" > \"${output_file}.tmp\"" >> "$DEBUG_LOG"
                        fi
                        sed "/^Dear /r $temp_content_file" "$output_file" > "${output_file}.tmp" 2>&1
                        SED_EXIT=$?
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "Sed exit code: $SED_EXIT" >> "$DEBUG_LOG"
                        fi
                        if [ $SED_EXIT -eq 0 ]; then
                            mv "${output_file}.tmp" "$output_file"
                        else
                            rm -f "${output_file}.tmp"
                        fi
                    else
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "=== DEBUG: Inserting after MIME-Version (last resort) ===" >> "$DEBUG_LOG"
                            echo "Command: sed \"/^MIME-Version:/r $temp_content_file\" \"$output_file\" > \"${output_file}.tmp\"" >> "$DEBUG_LOG"
                        fi
                        sed "/^MIME-Version:/r $temp_content_file" "$output_file" > "${output_file}.tmp" 2>&1
                        SED_EXIT=$?
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "Sed exit code: $SED_EXIT" >> "$DEBUG_LOG"
                        fi
                        if [ $SED_EXIT -eq 0 ]; then
                            mv "${output_file}.tmp" "$output_file"
                        else
                            rm -f "${output_file}.tmp"
                        fi
                    fi
                else
                    # Normal mode: insert after "I'm reaching out", "[CDC_NICE_THINGS]", or "Dear" line
                    if grep -q "I'm reaching out" "$output_file"; then
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "=== DEBUG: Inserting after 'I'\''m reaching out' ===" >> "$DEBUG_LOG"
                            echo "Command: sed \"/I'\''m reaching out/r $temp_content_file\" \"$output_file\" > \"${output_file}.tmp\"" >> "$DEBUG_LOG"
                            echo "=== DEBUG: State of output_file BEFORE sed ===" >> "$DEBUG_LOG"
                            head -15 "$output_file" >> "$DEBUG_LOG" 2>&1 || echo "(error reading file)" >> "$DEBUG_LOG"
                            echo "" >> "$DEBUG_LOG"
                        fi
                        sed "/I'm reaching out/r $temp_content_file" "$output_file" > "${output_file}.tmp" 2>&1
                        SED_EXIT=$?
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "Sed exit code: $SED_EXIT" >> "$DEBUG_LOG"
                            if [ $SED_EXIT -ne 0 ]; then
                                echo "=== DEBUG: SED ERROR - tmp file contents ===" >> "$DEBUG_LOG"
                                head -20 "${output_file}.tmp" >> "$DEBUG_LOG" 2>&1 || echo "(error reading tmp file)" >> "$DEBUG_LOG"
                            fi
                            echo "=== DEBUG: State of output_file AFTER sed (before mv) ===" >> "$DEBUG_LOG"
                            if [ -f "${output_file}.tmp" ]; then
                                head -15 "${output_file}.tmp" >> "$DEBUG_LOG" 2>&1 || echo "(error reading tmp file)" >> "$DEBUG_LOG"
                            else
                                echo "(tmp file does not exist)" >> "$DEBUG_LOG"
                            fi
                            echo "" >> "$DEBUG_LOG"
                        fi
                        if [ $SED_EXIT -eq 0 ]; then
                            mv "${output_file}.tmp" "$output_file"
                            if [ "$DEBUG_MICHAEL" = true ]; then
                                echo "=== DEBUG: State of output_file AFTER mv ===" >> "$DEBUG_LOG"
                                head -15 "$output_file" >> "$DEBUG_LOG" 2>&1 || echo "(error reading file)" >> "$DEBUG_LOG"
                                echo "" >> "$DEBUG_LOG"
                            fi
                        else
                            rm -f "${output_file}.tmp"
                            if [ "$DEBUG_MICHAEL" = true ]; then
                                echo "=== DEBUG: Sed failed, tmp file removed ===" >> "$DEBUG_LOG"
                            fi
                        fi
                    elif grep -q "\[CDC_NICE_THINGS\]" "$output_file"; then
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "=== DEBUG: Inserting after [CDC_NICE_THINGS] ===" >> "$DEBUG_LOG"
                            echo "Command: sed \"/\[CDC_NICE_THINGS\]/r $temp_content_file\" \"$output_file\" > \"${output_file}.tmp\"" >> "$DEBUG_LOG"
                        fi
                        sed "/\[CDC_NICE_THINGS\]/r $temp_content_file" "$output_file" > "${output_file}.tmp" 2>&1
                        SED_EXIT=$?
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "Sed exit code: $SED_EXIT" >> "$DEBUG_LOG"
                        fi
                        if [ $SED_EXIT -eq 0 ]; then
                            mv "${output_file}.tmp" "$output_file"
                        else
                            rm -f "${output_file}.tmp"
                        fi
                    elif grep -q "^Dear " "$output_file"; then
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "=== DEBUG: Inserting after 'Dear ' ===" >> "$DEBUG_LOG"
                            echo "Command: sed \"/^Dear /r $temp_content_file\" \"$output_file\" > \"${output_file}.tmp\"" >> "$DEBUG_LOG"
                        fi
                        sed "/^Dear /r $temp_content_file" "$output_file" > "${output_file}.tmp" 2>&1
                        SED_EXIT=$?
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "Sed exit code: $SED_EXIT" >> "$DEBUG_LOG"
                        fi
                        if [ $SED_EXIT -eq 0 ]; then
                            mv "${output_file}.tmp" "$output_file"
                        else
                            rm -f "${output_file}.tmp"
                        fi
                    else
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "=== DEBUG: Inserting after MIME-Version (last resort) ===" >> "$DEBUG_LOG"
                            echo "Command: sed \"/^MIME-Version:/r $temp_content_file\" \"$output_file\" > \"${output_file}.tmp\"" >> "$DEBUG_LOG"
                        fi
                        sed "/^MIME-Version:/r $temp_content_file" "$output_file" > "${output_file}.tmp" 2>&1
                        SED_EXIT=$?
                        if [ "$DEBUG_MICHAEL" = true ]; then
                            echo "Sed exit code: $SED_EXIT" >> "$DEBUG_LOG"
                        fi
                        if [ $SED_EXIT -eq 0 ]; then
                            mv "${output_file}.tmp" "$output_file"
                        else
                            rm -f "${output_file}.tmp"
                        fi
                    fi
                fi
            else
                if [ "$DEBUG_MICHAEL" = true ]; then
                    echo "=== DEBUG: Skipping custom content insertion ===" >> "$DEBUG_LOG"
                    [ -s "$temp_content_file" ] && echo "Reason: File is empty or contains file paths/errors" >> "$DEBUG_LOG" || echo "Reason: File is empty" >> "$DEBUG_LOG"
                    if [ -f "$temp_content_file" ]; then
                        echo "Temp file contents:" >> "$DEBUG_LOG"
                        cat "$temp_content_file" >> "$DEBUG_LOG" || echo "(error reading)" >> "$DEBUG_LOG"
                    fi
                fi
            fi
            
            if [ "$DEBUG_MICHAEL" = true ]; then
                echo "" >> "$DEBUG_LOG"
                echo "=== DEBUG: Final state of output_file ===" >> "$DEBUG_LOG"
                head -15 "$output_file" >> "$DEBUG_LOG" 2>&1 || echo "(error reading file)" >> "$DEBUG_LOG"
                echo "" >> "$DEBUG_LOG"
                echo "=== DEBUG: End of processing ===" >> "$DEBUG_LOG"
                echo "Debug log saved to: $DEBUG_LOG" >&2
            fi
            
            rm -f "$temp_content_file"
        fi
        
        # Note: Letter excerpt is NOT added here - it's added by fill-email-fields.sh when copying to private repo
        # This keeps preview-emails/ student-accessible (no private content)
        # Note: Empty placeholders are NOT removed here - fill-email-fields.sh will handle that as the final step
        
        recipient_count=$((recipient_count + 1))
    done
    
    echo "  Generated $recipient_count email(s) for $org"
    
    # Fill in institution placeholders if fill-institutions.sh exists
    if [ -f "$SCRIPT_DIR/fill-institutions.sh" ]; then
        echo "  Filling in [DEPARTMENT], [UNIVERSITY], and [INSTITUTION] placeholders..."
        "$SCRIPT_DIR/fill-institutions.sh" --batch "$output_dir" "$org" 2>/dev/null || echo "    (fill-institutions.sh not available or failed)"
    fi
    
    cd "$SCRIPT_DIR"
done

echo ""
echo "=== Email generation complete ==="
if [ "$PREVIEW_MODE" = true ]; then
    echo "Output directory: $OUTPUT_BASE_DIR/"
    echo ""
    echo "PREVIEW MODE: These are student-accessible previews"
    echo "Next steps:"
    echo "1. Review generated .eml files in preview-emails/"
    echo "2. Student can review these previews (recommendation text replaced with [saynicethings] placeholder)"
else
    echo "Output directory: $OUTPUT_BASE_DIR/"
    echo ""
    echo "Next steps:"
    echo "1. Review generated .eml files in preview-emails/"
    echo "2. Run fill-email-fields.sh (in private repo) to fill optional fields and create emails in emails/generated/"
    echo "3. The fill-email-fields.sh script (in private repo) will add private content (letter excerpt + full recommendation text)"
fi

