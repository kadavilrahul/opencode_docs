# OpenCode Docs

Comprehensive documentation and AI agent suite for OpenCode, featuring specialized integration agents that solve integration blindness in AI code editors.

## ⚠️ **Important Configuration Notes**

**This repository contains tested and verified OpenCode agent configurations.**

- ✅ **All configuration issues resolved** - Boolean values properly set
- ✅ **OpenCode JSON validated** - Removed unsupported keys
- ✅ **Agent markdown files fixed** - YAML frontmatter corrected
- ✅ **Ready for immediate use** - No configuration errors

## 🚀 Installation & Setup

### Method 1: Clone and Use Directly

#### Clone the repository
```bash
git clone https://github.com/kadavilrahul/opencode_docs.git
```
```bash
cd opencode_docs
```

#### Start using agents immediately
```bash
opencode --agent integration-guardian
```

### Method 2: Add to Existing Project
```bash
# Clone to temporary directory
git clone https://github.com/kadavilrahul/opencode_docs.git /tmp/opencode_docs
# Remove git directory
cd opencode_docs
find . -name ".git" -type d -print0 | xargs -0 rm -rf


# Copy agents and config to your project
cp -r /tmp/opencode_docs/.opencode YOUR_PROJECT/
cp /tmp/opencode_docs/opencode.json YOUR_PROJECT/

# Copy scripts (optional but recommended)
mkdir -p YOUR_PROJECT/scripts
cp /tmp/opencode_docs/scripts/* YOUR_PROJECT/scripts/
chmod +x YOUR_PROJECT/scripts/*.sh

# Copy documentation (optional)
cp /tmp/opencode_docs/AGENTS.md YOUR_PROJECT/

# Navigate to your project and start using
cd YOUR_PROJECT
opencode --agent integration-guardian
```

### Method 3: Global Installation (All Projects)
```bash
# Clone the repository
git clone https://github.com/kadavilrahul/opencode_docs.git
cd opencode_docs

# Install agents globally
mkdir -p ~/.config/opencode/agent
cp .opencode/agent/* ~/.config/opencode/agent/

# Install global config
cp opencode.json ~/.config/opencode/

# Install scripts globally
mkdir -p ~/bin
cp scripts/* ~/bin/
chmod +x ~/bin/*.sh

# Now use in any project
cd ANY_PROJECT
opencode --agent integration-guardian
```

### Method 4: Selective Installation
```bash
# Clone the repository
git clone https://github.com/kadavilrahul/opencode_docs.git

# Choose what you need:

# Just the integration agents (7 agents)
cp opencode_docs/.opencode/agent/{integration-guardian,context-mapper,integration-validator,architectural-compliance,cross-component-tester,refactoring-coordinator,documentation-synchronizer}.md YOUR_PROJECT/.opencode/agent/

# Just the visualization agent
cp opencode_docs/.opencode/agent/flowchart-generator.md YOUR_PROJECT/.opencode/agent/

# Just the documentation agents
cp opencode_docs/.opencode/agent/{readme-generator,run-generator}.md YOUR_PROJECT/.opencode/agent/

# Just the analysis scripts
cp opencode_docs/scripts/{analyze_codebase.sh,check_integration.sh} YOUR_PROJECT/scripts/

# Just the flowchart generator
cp opencode_docs/scripts/generate_flowchart.sh YOUR_PROJECT/scripts/
```

### Method 5: Git Submodule (Keep Updated)
```bash
# In your project root
git submodule add https://github.com/kadavilrahul/opencode_docs.git .opencode_integration

# Create symbolic links
ln -s .opencode_integration/.opencode .opencode
ln -s .opencode_integration/opencode.json opencode.json
ln -s .opencode_integration/scripts scripts

# Update submodule when needed
git submodule update --remote

# Use the agents
opencode --agent integration-guardian
```

## 📦 What's Included

### Core Components
```
opencode_docs/
├── .opencode/
│   └── agent/                    # All 10 agent configurations
│       ├── integration-guardian.md
│       ├── context-mapper.md
│       ├── integration-validator.md
│       ├── architectural-compliance.md
│       ├── cross-component-tester.md
│       ├── refactoring-coordinator.md
│       ├── documentation-synchronizer.md
│       ├── flowchart-generator.md
│       ├── readme-generator.md
│       └── run-generator.md
├── scripts/                      # Analysis and utility scripts
│   ├── analyze_codebase.sh
│   ├── check_integration.sh
│   ├── generate_flowchart.sh
│   └── collect_functions.sh
├── opencode.json                 # Main configuration file
├── AGENTS.md                     # Detailed agent documentation
└── *.txt                         # OpenCode documentation files
```
## ⚠️ **IMPORTANT NOTICE**

**This project contains advanced AI agent configurations for OpenCode.**

- ✅ **Integration Agents**: Prevent and solve integration blindness in AI code editors
- ✅ **Documentation**: Complete OpenCode documentation and guides
- ✅ **Scripts**: Analysis and validation tools for codebases
- 📋 **Requirements**: OpenCode CLI installed

## 🎯 Key Features

### AI Agent Suite
A comprehensive collection of 10 specialized AI agents for OpenCode:

**Integration Agents** (8) - Solve integration blindness:
- **Integration Guardian** - Master orchestrator (primary agent)
- **Context Mapper** - Maps codebase structure and dependencies
- **Integration Validator** - Validates code before integration
- **Architectural Compliance** - Ensures design pattern adherence
- **Cross-Component Tester** - Generates integration tests
- **Refactoring Coordinator** - Manages multi-file refactoring
- **Documentation Synchronizer** - Keeps docs in sync with code
- **Flowchart Generator** - Creates actual flowcharts from code analysis

**Documentation Agents** (2):
- **README Generator** - Creates comprehensive project documentation
- **Run Generator** - Generates executable run.sh scripts

## 🛡️ Integration Blindness Solution

### The Problem
AI code editors excel at generating isolated code pieces but struggle to ensure those parts integrate smoothly within the broader architecture, leading to:
- ✅ Code works in isolation
- ❌ Code breaks when integrated
- ❌ Duplicate functionality
- ❌ Inconsistent patterns
- ❌ Misaligned interfaces

### The Solution
Our Integration Agent Suite provides:
1. **Context-first approach** - Understand before changing
2. **Validation before integration** - Catch issues early
3. **Pattern enforcement** - Maintain consistency
4. **Automated testing** - Verify integration points
5. **Documentation sync** - Keep docs current

## 📊 Usage Examples

### Example 1: Adding New Feature
```bash
# The Integration Guardian will:
# 1. Map existing codebase with @context-mapper
# 2. Validate against existing code with @integration-validator
# 3. Ensure architectural compliance
# 4. Generate integration tests
# 5. Update documentation
```

### Example 2: Refactoring
```bash
# Use the refactoring coordinator:
@refactoring-coordinator refactor the authentication system
```

### Example 3: Validation Check
```bash
# Run integration health check:
./scripts/check_integration.sh .
```

## 🔧 Utility Scripts

### Generate Flowcharts (NEW)
```bash
./scripts/generate_flowchart.sh [project_dir] [output_dir]
```
Creates actual flowcharts from code analysis:
- Execution flow diagrams
- Data flow visualizations  
- Component interaction graphs
- API sequence diagrams
- Function call graphs
- State transition diagrams

**This helps reduce integration blindness by visualizing actual code relationships**

### Analyze Codebase
```bash
./scripts/analyze_codebase.sh [project_dir]
```
Generates comprehensive analysis including:
- Project structure and type detection
- Architecture pattern identification
- Code statistics and metrics
- Integration points mapping
- Quality indicators

### Check Integration Health
```bash
./scripts/check_integration.sh [project_dir] [verbose]
```
Validates:
- Circular dependencies
- Duplicate functions
- Broken imports
- Inconsistent patterns
- Test coverage
- Documentation freshness

### Generate Architecture Diagrams
```bash
./scripts/flowchart.sh [project_dir]
```
Creates visual architecture diagrams:
- GraphViz flowcharts
- PlantUML diagrams
- ASCII architecture views
- Component relationships

### Collect Function Names
```bash
./scripts/collect_functions.sh
```
Extracts function definitions using:
- grep for quick search
- ctags for comprehensive indexing
- AST parsing for Python projects

## 📈 Integration Health Metrics

The suite tracks:
- **Code Duplication**: < 5% acceptable
- **Test Coverage**: > 80% required
- **Circular Dependencies**: 0 tolerated
- **Documentation Age**: < 30 days
- **API Breaking Changes**: 0 without versioning
- **Integration Pass Rate**: 100% required

## 🎯 Workflow

### New Code Development
```
Context Analysis → Validation → Compliance → Implementation → Testing → Documentation
```

### Code Modifications
```
Impact Analysis → Refactoring Plan → Validation → Testing → Documentation Update
```

## 📁 Project Structure

```
├── .opencode/agent/              # All 9 agent configurations
├── scripts/                      # Utility and analysis scripts
│   ├── analyze_codebase.sh      # Comprehensive codebase analysis
│   ├── check_integration.sh     # Integration health validation
│   ├── generate_flowchart.sh    # Real flowchart generation from code
│   └── collect_functions.sh     # Function collection utility
├── opencode.json                 # Main configuration file
├── AGENTS.md                     # Detailed agent documentation
├── README.md                     # This file
└── *.txt                         # OpenCode documentation files
```

## 🔍 Available Agents

| Agent | Type | Purpose |
|-------|------|---------|
| integration-guardian | Primary | Master orchestrator for integration |
| context-mapper | Subagent | Maps codebase structure |
| integration-validator | Subagent | Validates before integration |
| architectural-compliance | Subagent | Ensures pattern compliance |
| cross-component-tester | Subagent | Generates integration tests |
| refactoring-coordinator | Subagent | Manages refactoring |
| documentation-synchronizer | Subagent | Syncs documentation |
| flowchart-generator | Subagent | Creates actual flowcharts from code |
| readme-generator | Subagent | Creates README files |
| run-generator | Subagent | Creates run documentation |

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Add new agents or improve existing ones
4. Test with OpenCode
5. Commit: `git commit -m "Add feature"`
6. Push: `git push origin feature-name`
7. Create Pull Request

## 🔧 Troubleshooting

### Configuration Errors
If you encounter configuration errors:

1. **Boolean values**: Ensure all `tools` values are `true` or `false`, not strings like `"ask"`
2. **Unrecognized keys**: Only use supported OpenCode JSON keys (`$schema`, `agent`, `permission`)
3. **Missing files**: Ensure all referenced agent `.md` files exist in `.opencode/agent/`
4. **YAML frontmatter**: Check agent markdown files have proper YAML syntax

### Common Fixes
```bash
# Test configuration validity
opencode --version

# Check agent file format
head -20 .opencode/agent/integration-validator.md
```

## 📞 Support

- Create GitHub issue for bugs
- Check integration-agents/README.md for detailed documentation
- Review agent files in .opencode/agent/
- Test agents before reporting issues

## 📚 Documentation

- [Complete Agent Documentation](./AGENTS.md)
- [OpenCode Agents Guide](./opencode_agents.txt)
- [OpenCode Configuration](./opencode_config.txt)
- [Integration Blindness Problem](./integration_blindness.txt)
- [OpenCode Commands](./opencode_commands.txt)
- [OpenCode Permissions](./opencode_permissions.txt)

---
*Solving Integration Blindness in AI Code Editors*