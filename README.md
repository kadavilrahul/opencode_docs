# OpenCode Docs

Comprehensive documentation and AI agent suite for OpenCode, featuring specialized integration agents that solve integration blindness in AI code editors.

## ⚠️ **IMPORTANT NOTICE**

**This project contains advanced AI agent configurations for OpenCode.**

- ✅ **Integration Agents**: Prevent and solve integration blindness in AI code editors
- ✅ **Documentation**: Complete OpenCode documentation and guides
- ✅ **Scripts**: Analysis and validation tools for codebases
- 📋 **Requirements**: OpenCode CLI installed

## 🎯 Key Features

### AI Agent Suite
A comprehensive collection of 9 specialized AI agents for OpenCode:

**Integration Agents** (7) - Solve integration blindness:
- **Integration Guardian** - Master orchestrator (primary agent)
- **Context Mapper** - Maps codebase structure and dependencies
- **Integration Validator** - Validates code before integration
- **Architectural Compliance** - Ensures design pattern adherence
- **Cross-Component Tester** - Generates integration tests
- **Refactoring Coordinator** - Manages multi-file refactoring
- **Documentation Synchronizer** - Keeps docs in sync with code

**Documentation Agents** (2):
- **README Generator** - Creates comprehensive project documentation
- **Run Generator** - Generates executable run.sh scripts

## 🚀 Quick Start

### Clone Repository

```bash
git clone https://github.com/kadavilrahul/opencode_docs.git
cd opencode_docs
```

### Using Integration Agents with OpenCode

1. **For all projects (global installation):**
```bash
cp -r .opencode/agent/* ~/.config/opencode/agent/
cp opencode.json ~/.config/opencode/
```

2. **For current project only:**
```bash
# The agents are already in .opencode/agent/ directory
# Just use the opencode.json configuration
```

3. **Start using the Integration Guardian:**
```bash
opencode --agent integration-guardian
```

## 📦 What's Included

### Core Components
```
opencode_docs/
├── .opencode/
│   └── agent/                    # All agent configurations
│       ├── integration-guardian.md
│       ├── context-mapper.md
│       ├── integration-validator.md
│       ├── architectural-compliance.md
│       ├── cross-component-tester.md
│       ├── refactoring-coordinator.md
│       ├── documentation-synchronizer.md
│       ├── readme-generator.md
│       └── run-generator.md
├── scripts/                      # Analysis and validation scripts
│   ├── analyze_codebase.sh      # Comprehensive codebase analysis
│   └── check_integration.sh     # Integration health validation
├── opencode.json                 # Main configuration file
└── *.txt                         # OpenCode documentation files
```

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
│   ├── collect_functions.sh     # Function collection utility
│   └── flowchart.sh             # Architecture diagram generator
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