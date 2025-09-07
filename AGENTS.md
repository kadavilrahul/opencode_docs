# OpenCode Agent Suite

Comprehensive collection of specialized AI agents for OpenCode, including the Integration Agent Suite that solves integration blindness in AI code editors.

## 🎯 Integration Agent Suite

A powerful collection of 7 specialized agents that work together to prevent and solve integration blindness - AI's weakness in combining separate code fragments into a coherent, working system.

### Problem: Integration Blindness

AI code editors often produce code that:
- ✅ Works perfectly in isolation
- ❌ Breaks when integrated into the larger system
- ❌ Duplicates existing functionality
- ❌ Uses inconsistent patterns
- ❌ Has misaligned interfaces
- ❌ Creates silent logical mismatches

### Solution: Coordinated Agent System

Our agents work together to ensure every piece of code integrates seamlessly.

## 📋 Available Agents

### Primary Agent

#### 🛡️ Integration Guardian
**Mode**: Primary  
**Purpose**: Master orchestrator that coordinates all integration agents  
**Key Features**:
- Orchestrates workflow for new code development
- Coordinates complex refactoring operations
- Performs integration health checks
- Makes risk-based decisions on agent invocation

**Usage**:
```bash
opencode --agent integration-guardian
```

### Integration Subagents

#### 🗺️ Context Mapper
**Mode**: Subagent  
**Purpose**: Maps and maintains comprehensive understanding of codebase structure  
**Capabilities**:
- Scans and indexes all functions, classes, and modules
- Tracks dependencies and relationships
- Builds comprehensive knowledge graphs
- Identifies patterns and conventions
- Creates `.integration-map.json` knowledge base

**Invocation**:
```
@context-mapper analyze the current codebase structure
```

#### ✅ Integration Validator
**Mode**: Subagent  
**Purpose**: Validates new code against existing architecture before integration  
**Capabilities**:
- Checks for duplicate functionality
- Validates naming conventions
- Ensures API contract compatibility
- Verifies dependency compatibility
- Performs pre-flight checks before code creation

**Invocation**:
```
@integration-validator check this new service implementation
```

#### 🏛️ Architectural Compliance
**Mode**: Subagent  
**Purpose**: Ensures code follows established architectural patterns  
**Capabilities**:
- Enforces design patterns (MVC, Repository, Factory, etc.)
- Validates SOLID principles
- Checks layer boundaries
- Prevents circular dependencies
- Ensures separation of concerns

**Invocation**:
```
@architectural-compliance verify this refactoring follows our patterns
```

#### 🧪 Cross-Component Tester
**Mode**: Subagent  
**Purpose**: Generates and executes comprehensive integration tests  
**Capabilities**:
- Creates tests for component interactions
- Generates realistic test data
- Tests edge cases at boundaries
- Validates error propagation
- Builds regression tests

**Invocation**:
```
@cross-component-tester generate integration tests for the new API
```

#### 🔄 Refactoring Coordinator
**Mode**: Subagent  
**Purpose**: Manages complex refactoring across multiple files  
**Capabilities**:
- Plans incremental refactoring steps
- Updates all references automatically
- Maintains backward compatibility
- Creates migration scripts
- Handles rename, extract, and move operations

**Invocation**:
```
@refactoring-coordinator extract this service into separate modules
```

#### 📚 Documentation Synchronizer
**Mode**: Subagent  
**Purpose**: Keeps documentation synchronized with code changes  
**Capabilities**:
- Generates API documentation
- Updates architecture diagrams
- Maintains changelog
- Validates documentation accuracy
- Creates integration guides

**Invocation**:
```
@documentation-synchronizer update docs for the new features
```

### Documentation Subagents

#### 📝 README Generator
**Mode**: Subagent  
**Purpose**: Generates comprehensive README files for projects  
**Capabilities**:
- Analyzes project structure
- Detects project type and dependencies
- Creates appropriate sections
- Includes usage examples
- Adds installation instructions

**Invocation**:
```
@readme-generator create a README for this project
```

#### 🚀 Run Generator
**Mode**: Subagent  
**Purpose**: Generates run.sh scripts for executable projects  
**Capabilities**:
- Auto-detects project type
- Creates intelligent entry points
- Adds dependency checks
- Includes multiple commands (start, test, build)
- Provides help documentation

**Invocation**:
```
@run-generator create a run script for this project
```

### Visualization Subagent

#### 📊 Flowchart Generator
**Mode**: Subagent  
**Purpose**: Generates actual flowcharts and diagrams from code analysis  
**Capabilities**:
- Analyzes real code structure (not generic templates)
- Creates execution flow diagrams
- Maps data flow through the system
- Visualizes component interactions
- Generates API sequence diagrams
- Creates function call graphs
- Maps state transitions

**Diagram Types Generated**:
- Execution flow (Mermaid)
- Data flow diagrams (Mermaid)
- Component interaction (GraphViz DOT)
- API sequences (Mermaid)
- Call graphs (GraphViz DOT)
- State diagrams (Mermaid)

**Invocation**:
```
@flowchart-generator analyze and create flowcharts for this codebase
```

**Why This Reduces Integration Blindness**:
- Makes implicit code relationships explicit
- Visualizes hidden dependencies
- Shows actual execution paths
- Helps humans explain system to AI
- Reveals integration points clearly

## 🔧 Supporting Scripts

### analyze_codebase.sh
Performs comprehensive codebase analysis:
```bash
./scripts/analyze_codebase.sh [project_dir] [output_file]
```

**Analyzes**:
- Project type and structure
- Architecture patterns
- Code statistics
- API endpoints
- Testing infrastructure
- Database usage
- Documentation status
- Integration points
- Code quality indicators

**Output**: JSON report with integration health score

### check_integration.sh
Validates integration health:
```bash
./scripts/check_integration.sh [project_dir] [verbose]
```

**Checks**:
- Circular dependencies
- Duplicate functions
- Inconsistent error handling
- Broken imports
- Unused dependencies
- Missing test coverage
- API endpoint consistency
- Database schema consistency
- Configuration issues
- Documentation freshness

**Output**: Detailed report with issues and warnings

### generate_flowchart.sh
Generates actual flowcharts from code analysis:
```bash
./scripts/generate_flowchart.sh [project_dir] [output_dir] [verbose]
```

**Generates**:
- Execution flow diagrams
- Data flow visualizations
- Component interaction graphs
- API sequence diagrams
- Function call graphs
- State transition diagrams

**Output**: Mermaid (.mmd) and GraphViz (.dot) diagram files

### collect_functions.sh
Extracts function definitions from code:
```bash
./scripts/collect_functions.sh
```

**Methods**:
- grep for quick extraction
- ctags for comprehensive indexing
- AST parsing for Python

**Output**: functions.txt with all function definitions

## 🎯 Integration Workflows

### New Code Development
```
1. Context Analysis (context-mapper)
   ↓
2. Validation (integration-validator)
   ↓
3. Compliance Check (architectural-compliance)
   ↓
4. Implementation
   ↓
5. Testing (cross-component-tester)
   ↓
6. Documentation (documentation-synchronizer)
```

### Code Modifications
```
1. Impact Analysis (context-mapper)
   ↓
2. Refactoring Plan (refactoring-coordinator)
   ↓
3. Validation (integration-validator)
   ↓
4. Testing (cross-component-tester)
   ↓
5. Documentation Update (documentation-synchronizer)
```

## 📊 Integration Health Metrics

The suite tracks:
- **Code Duplication Rate**: < 5% acceptable
- **Test Coverage**: > 80% required
- **Circular Dependencies**: 0 tolerated
- **Documentation Staleness**: < 30 days
- **API Breaking Changes**: 0 without versioning
- **Integration Test Pass Rate**: 100% required

## 🚦 Risk Assessment Matrix

| Change Type | Risk Level | Required Agents | Approval |
|------------|------------|-----------------|----------|
| New isolated module | Low | Validator, Documenter | No |
| API endpoint change | High | ALL agents | Yes |
| Database schema change | Critical | ALL agents + review | Yes |
| Core refactoring | High | Refactoring, Testing, Compliance | Yes |
| Documentation only | Low | Documentation Synchronizer | No |

## 💡 Usage Examples

### Example 1: Adding New Feature
```markdown
User: "Add user authentication to the application"

Integration Guardian will:
1. @context-mapper - Map existing auth (if any)
2. @integration-validator - Check for existing auth code
3. Implement following discovered patterns
4. @cross-component-tester - Generate tests
5. @documentation-synchronizer - Update docs
```

### Example 2: Fixing Integration Issues
```markdown
User: "The new payment service isn't working with orders"

Integration Guardian will:
1. @context-mapper - Map both systems
2. @integration-validator - Identify integration points
3. @architectural-compliance - Check patterns
4. Fix integration issues
5. @cross-component-tester - Test fixes
6. @documentation-synchronizer - Update docs
```

### Example 3: Major Refactoring
```markdown
User: "Refactor the monolithic service into microservices"

Integration Guardian will:
1. @context-mapper - Map entire system
2. @refactoring-coordinator - Plan refactoring
3. @architectural-compliance - Ensure compliance
4. Implement incrementally
5. @cross-component-tester - Test each step
6. @documentation-synchronizer - Update all docs
```

## 🔍 Integration Problem Patterns

| Problem | Detection Agent | Resolution Agent |
|---------|----------------|------------------|
| Duplicate Code | Context Mapper | Refactoring Coordinator |
| Inconsistent Errors | Architectural Compliance | Integration Validator |
| Breaking Changes | Integration Validator | Documentation Synchronizer |
| Circular Dependencies | Context Mapper | Refactoring Coordinator |
| Test Coverage Gaps | Cross-Component Tester | Cross-Component Tester |

## 📦 Installation

### For All Projects (Global)
```bash
# Copy agents to global config
cp -r .opencode/agent/* ~/.config/opencode/agent/
cp opencode.json ~/.config/opencode/opencode.json

# Make scripts available globally
cp scripts/*.sh ~/bin/
chmod +x ~/bin/*.sh
```

### For Current Project Only
```bash
# Agents are already in .opencode/agent/
# Just ensure opencode.json is in project root

# Use scripts directly
./scripts/analyze_codebase.sh .
./scripts/check_integration.sh .
```

## ⚙️ Configuration

The `opencode.json` file contains:
- All agent definitions with relative paths
- Tool permissions and settings
- Integration thresholds
- Script references

Key settings:
```json
{
  "settings": {
    "autoAnalyze": true,
    "preCommitValidation": true,
    "integrationTestGeneration": true,
    "documentationSync": true,
    "architecturalCompliance": true,
    "duplicateDetection": true,
    "refactoringAssistance": true
  },
  "thresholds": {
    "codeDuplication": 5,
    "testCoverage": 80,
    "documentationAge": 30,
    "complexityLimit": 10,
    "dependencyDepth": 5
  }
}
```

## 🏆 Best Practices

1. **Always Context First**: Never make changes without understanding context
2. **Validate Early**: Check for issues before writing code
3. **Test at Boundaries**: Focus on integration points
4. **Document Changes**: Keep documentation synchronized
5. **Incremental Changes**: Small, tested changes over big bang
6. **Monitor Health**: Regular integration health checks
7. **Team Communication**: Keep team informed of integration status

## 🤝 Contributing

To improve the agent suite:
1. Identify new integration blindness patterns
2. Propose new validation rules
3. Enhance existing agents
4. Add new test generation templates
5. Improve documentation synchronization

## 📚 Key Concepts

### Integration Blindness
The phenomenon where AI-generated code works in isolation but fails when integrated into the larger system due to lack of context about the entire codebase.

### Context-First Development
Always understanding the existing system before making changes, enabled by the Context Mapper agent.

### Validation-Driven Integration
Checking for potential issues before code is written, not after, using the Integration Validator.

### Architectural Consistency
Maintaining patterns and principles across the entire codebase through the Architectural Compliance agent.

### Continuous Documentation
Keeping documentation in sync with code changes automatically via the Documentation Synchronizer.

## 🎓 Learning Resources

- Review agent implementations in `.opencode/agent/`
- Study the analysis scripts for understanding codebase analysis
- Examine `opencode.json` for configuration patterns
- Read `integration_blindness.txt` for problem details

---

**Remember**: Integration blindness is prevented, not fixed after the fact. Every piece of code must integrate perfectly into the larger system, maintaining consistency, reliability, and maintainability.