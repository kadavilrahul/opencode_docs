#!/bin/bash

# Flowchart Generator Script
# Analyzes codebase and generates actual flowcharts showing data flow and execution paths

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Default values
PROJECT_DIR="${1:-.}"
OUTPUT_DIR="${2:-./diagrams}"
VERBOSE="${3:-false}"

# Functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${PURPLE}=== Codebase Flowchart Generator ===${NC}"
echo -e "Analyzing: ${GREEN}$PROJECT_DIR${NC}"
echo -e "Output to: ${GREEN}$OUTPUT_DIR${NC}"
echo ""

# Detect project type
detect_project_type() {
    if [ -f "$PROJECT_DIR/package.json" ]; then
        echo "javascript"
    elif [ -f "$PROJECT_DIR/requirements.txt" ] || [ -f "$PROJECT_DIR/setup.py" ]; then
        echo "python"
    elif [ -f "$PROJECT_DIR/go.mod" ]; then
        echo "go"
    elif [ -f "$PROJECT_DIR/Cargo.toml" ]; then
        echo "rust"
    else
        echo "unknown"
    fi
}

PROJECT_TYPE=$(detect_project_type)
info "Detected project type: $PROJECT_TYPE"

# Generate execution flow diagram
generate_execution_flow() {
    info "Generating execution flow diagram..."
    
    cat > "$OUTPUT_DIR/execution_flow.mmd" << 'EOF'
flowchart TD
    Start([Start])
EOF
    
    # Find entry points
    if [ "$PROJECT_TYPE" = "javascript" ]; then
        # Find main files
        ENTRY_FILES=$(find "$PROJECT_DIR" -name "index.js" -o -name "main.js" -o -name "app.js" | grep -v node_modules | head -5)
        
        for file in $ENTRY_FILES; do
            filename=$(basename "$file")
            echo "    Start --> $filename" >> "$OUTPUT_DIR/execution_flow.mmd"
            
            # Extract function calls
            functions=$(grep -oE "function [a-zA-Z_][a-zA-Z0-9_]*|const [a-zA-Z_][a-zA-Z0-9_]* = |class [a-zA-Z_][a-zA-Z0-9_]*" "$file" 2>/dev/null | \
                sed 's/function //' | sed 's/const //' | sed 's/ =$//' | sed 's/class //' | head -10)
            
            prev_func="$filename"
            for func in $functions; do
                echo "    $prev_func --> $func" >> "$OUTPUT_DIR/execution_flow.mmd"
                prev_func="$func"
            done
        done
    elif [ "$PROJECT_TYPE" = "python" ]; then
        # Find Python entry points
        ENTRY_FILES=$(find "$PROJECT_DIR" -name "__main__.py" -o -name "main.py" -o -name "app.py" | head -5)
        
        for file in $ENTRY_FILES; do
            filename=$(basename "$file")
            echo "    Start --> $filename" >> "$OUTPUT_DIR/execution_flow.mmd"
            
            # Extract function definitions
            functions=$(grep "^def " "$file" 2>/dev/null | sed 's/def //' | sed 's/(.*//' | head -10)
            
            prev_func="$filename"
            for func in $functions; do
                echo "    $prev_func --> $func" >> "$OUTPUT_DIR/execution_flow.mmd"
                prev_func="$func"
            done
        done
    fi
    
    success "Execution flow diagram created: $OUTPUT_DIR/execution_flow.mmd"
}

# Generate data flow diagram
generate_data_flow() {
    info "Generating data flow diagram..."
    
    cat > "$OUTPUT_DIR/data_flow.mmd" << 'EOF'
graph LR
    Input[User Input]
EOF
    
    # Find API endpoints
    if [ "$PROJECT_TYPE" = "javascript" ]; then
        endpoints=$(grep -r "router\.\|app\." "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | \
            grep -E "get|post|put|delete|patch" | \
            grep -oE "'\/.+?'|\"/.+?\"" | \
            tr -d "'\""" | sort -u | head -10)
        
        for endpoint in $endpoints; do
            echo "    Input --> API$endpoint[API: $endpoint]" >> "$OUTPUT_DIR/data_flow.mmd"
        done
    fi
    
    # Find database operations
    db_ops=$(grep -r "SELECT\|INSERT\|UPDATE\|DELETE\|find\|save\|create" "$PROJECT_DIR" \
        --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | \
        grep -v node_modules | head -5)
    
    if [ -n "$db_ops" ]; then
        echo "    API --> Database[(Database)]" >> "$OUTPUT_DIR/data_flow.mmd"
        echo "    Database --> Response[Response]" >> "$OUTPUT_DIR/data_flow.mmd"
    fi
    
    success "Data flow diagram created: $OUTPUT_DIR/data_flow.mmd"
}

# Generate component interaction diagram
generate_component_diagram() {
    info "Generating component interaction diagram..."
    
    cat > "$OUTPUT_DIR/components.dot" << EOF
digraph Components {
    rankdir=TB;
    node [shape=box, style=filled];
    
    // Detect and add components
EOF
    
    # Find major directories (potential components)
    COMPONENTS=$(find "$PROJECT_DIR" -maxdepth 2 -type d -not -path '*/\.*' \
        -not -name node_modules -not -name __pycache__ -not -name dist -not -name build | \
        xargs -n1 basename | sort -u | grep -v "^$(basename "$PROJECT_DIR")$" | head -15)
    
    for comp in $COMPONENTS; do
        echo "    \"$comp\" [fillcolor=lightblue];" >> "$OUTPUT_DIR/components.dot"
        
        # Find imports/dependencies
        if [ -d "$PROJECT_DIR/$comp" ]; then
            deps=$(grep -r "import\|require" "$PROJECT_DIR/$comp" 2>/dev/null | \
                grep -oE "from ['\"].+?['\"]|from [a-zA-Z_][a-zA-Z0-9_]*" | \
                sed "s/from ['\"]//g" | sed "s/['\"]//g" | sed "s/from //g" | \
                grep -v "^\." | sort -u | head -5)
            
            for dep in $deps; do
                dep_name=$(echo "$dep" | cut -d'/' -f1)
                if [ "$dep_name" != "$comp" ]; then
                    echo "    \"$comp\" -> \"$dep_name\";" >> "$OUTPUT_DIR/components.dot"
                fi
            done
        fi
    done
    
    echo "}" >> "$OUTPUT_DIR/components.dot"
    
    # Try to generate PNG if dot is available
    if command -v dot > /dev/null 2>&1; then
        dot -Tpng "$OUTPUT_DIR/components.dot" -o "$OUTPUT_DIR/components.png" 2>/dev/null && \
            success "Component diagram PNG generated: $OUTPUT_DIR/components.png" || \
            warning "Could not generate PNG, DOT file saved"
    else
        warning "Graphviz not installed. Install with: sudo apt-get install graphviz"
    fi
    
    success "Component diagram created: $OUTPUT_DIR/components.dot"
}

# Generate API sequence diagram
generate_api_sequence() {
    info "Generating API sequence diagram..."
    
    cat > "$OUTPUT_DIR/api_sequence.mmd" << 'EOF'
sequenceDiagram
    participant Client
    participant API
    participant Service
    participant Database
EOF
    
    # Find API routes and their handlers
    if [ "$PROJECT_TYPE" = "javascript" ]; then
        routes=$(grep -r "router\.\|app\." "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | \
            grep -E "get|post|put|delete" | head -5)
        
        if [ -n "$routes" ]; then
            echo "    Client->>API: HTTP Request" >> "$OUTPUT_DIR/api_sequence.mmd"
            echo "    API->>Service: Process Request" >> "$OUTPUT_DIR/api_sequence.mmd"
            echo "    Service->>Database: Query Data" >> "$OUTPUT_DIR/api_sequence.mmd"
            echo "    Database-->>Service: Return Results" >> "$OUTPUT_DIR/api_sequence.mmd"
            echo "    Service-->>API: Format Response" >> "$OUTPUT_DIR/api_sequence.mmd"
            echo "    API-->>Client: HTTP Response" >> "$OUTPUT_DIR/api_sequence.mmd"
        fi
    fi
    
    success "API sequence diagram created: $OUTPUT_DIR/api_sequence.mmd"
}

# Generate call graph
generate_call_graph() {
    info "Generating function call graph..."
    
    echo "digraph CallGraph {" > "$OUTPUT_DIR/callgraph.dot"
    echo "    rankdir=LR;" >> "$OUTPUT_DIR/callgraph.dot"
    echo "    node [shape=box];" >> "$OUTPUT_DIR/callgraph.dot"
    
    # Extract functions and their calls
    if [ "$PROJECT_TYPE" = "javascript" ]; then
        FILES=$(find "$PROJECT_DIR" -name "*.js" -o -name "*.ts" | grep -v node_modules | head -20)
        
        for file in $FILES; do
            # Extract function names
            functions=$(grep -E "function [a-zA-Z_]|const [a-zA-Z_][a-zA-Z0-9_]* = async|const [a-zA-Z_][a-zA-Z0-9_]* = \(" "$file" 2>/dev/null | \
                sed 's/function //' | sed 's/const //' | sed 's/ =.*//' | head -5)
            
            for func in $functions; do
                # Find function calls within this function
                calls=$(grep -A 10 "$func" "$file" 2>/dev/null | \
                    grep -oE "[a-zA-Z_][a-zA-Z0-9_]*\(" | \
                    sed 's/($//' | sort -u | head -5)
                
                for call in $calls; do
                    if [ "$call" != "$func" ]; then
                        echo "    \"$func\" -> \"$call\";" >> "$OUTPUT_DIR/callgraph.dot"
                    fi
                done
            done
        done
    elif [ "$PROJECT_TYPE" = "python" ]; then
        FILES=$(find "$PROJECT_DIR" -name "*.py" | head -20)
        
        for file in $FILES; do
            functions=$(grep "^def " "$file" 2>/dev/null | sed 's/def //' | sed 's/(.*//' | head -5)
            
            for func in $functions; do
                calls=$(grep -A 10 "^def $func" "$file" 2>/dev/null | \
                    grep -oE "[a-zA-Z_][a-zA-Z0-9_]*\(" | \
                    sed 's/($//' | sort -u | head -5)
                
                for call in $calls; do
                    if [ "$call" != "$func" ]; then
                        echo "    \"$func\" -> \"$call\";" >> "$OUTPUT_DIR/callgraph.dot"
                    fi
                done
            done
        done
    fi
    
    echo "}" >> "$OUTPUT_DIR/callgraph.dot"
    
    # Try to generate PNG
    if command -v dot > /dev/null 2>&1; then
        dot -Tpng "$OUTPUT_DIR/callgraph.dot" -o "$OUTPUT_DIR/callgraph.png" 2>/dev/null && \
            success "Call graph PNG generated: $OUTPUT_DIR/callgraph.png" || \
            warning "Could not generate PNG, DOT file saved"
    fi
    
    success "Call graph created: $OUTPUT_DIR/callgraph.dot"
}

# Generate state diagram
generate_state_diagram() {
    info "Generating state diagram..."
    
    cat > "$OUTPUT_DIR/states.mmd" << 'EOF'
stateDiagram-v2
    [*] --> Initial
EOF
    
    # Look for state-related patterns
    states=$(grep -r "state\|State\|STATE\|status\|Status" "$PROJECT_DIR" \
        --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | \
        grep -oE "state.*=.*['\"][a-zA-Z_]+['\"]|status.*=.*['\"][a-zA-Z_]+['\"]" | \
        grep -oE "['\"][a-zA-Z_]+['\"]" | tr -d "'\""" | sort -u | head -10)
    
    prev_state="Initial"
    for state in $states; do
        echo "    $prev_state --> $state" >> "$OUTPUT_DIR/states.mmd"
        prev_state="$state"
    done
    
    if [ -n "$states" ]; then
        echo "    $prev_state --> [*]" >> "$OUTPUT_DIR/states.mmd"
    fi
    
    success "State diagram created: $OUTPUT_DIR/states.mmd"
}

# Main execution
main() {
    generate_execution_flow
    generate_data_flow
    generate_component_diagram
    generate_api_sequence
    generate_call_graph
    generate_state_diagram
    
    echo ""
    echo -e "${GREEN}=== Flowchart Generation Complete ===${NC}"
    echo -e "Generated diagrams in: ${BLUE}$OUTPUT_DIR${NC}"
    echo ""
    echo "Files created:"
    ls -la "$OUTPUT_DIR"/*.mmd "$OUTPUT_DIR"/*.dot 2>/dev/null | awk '{print "  - " $9}'
    
    echo ""
    echo "To view Mermaid diagrams:"
    echo "  1. Copy the .mmd file contents to https://mermaid.live"
    echo "  2. Or install mermaid-cli: npm install -g @mermaid-js/mermaid-cli"
    echo "     Then run: mmdc -i $OUTPUT_DIR/execution_flow.mmd -o $OUTPUT_DIR/execution_flow.png"
    echo ""
    echo "To view DOT diagrams:"
    echo "  1. Install graphviz: sudo apt-get install graphviz"
    echo "  2. Generate PNG: dot -Tpng $OUTPUT_DIR/components.dot -o $OUTPUT_DIR/components.png"
    echo ""
    echo -e "${YELLOW}TIP:${NC} Share these diagrams with AI to reduce integration blindness!"
}

# Run main function
main