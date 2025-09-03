export const ReadmeGenerator = async ({ $, worktree, directory }) => {
  console.log("📝 README Generator Plugin: Loading...")
  
  const generateReadme = async () => {
    try {
      // Get GitHub URL using bash script
      console.log("🔍 Generating GitHub URL...")
      const urlResult = await $`cd ${worktree} && git remote -v | grep -o 'github\\.com[:/][^/]*\\/[^/ ]*' | head -1 | sed 's|github\\.com[:/]|https://github.com/|'`.quiet().text()
      
      let githubUrl = "https://github.com/username/repository"
      let repoPath = "username/repository"
      let repoName = "project"
      
      if (urlResult.trim()) {
        githubUrl = urlResult.trim()
        console.log(`✨ ${githubUrl}`)
        // Extract repo path and name from URL
        repoPath = githubUrl.replace("https://github.com/", "")
        repoName = repoPath.split('/')[1] || "project"
      } else {
        console.log("❌ No GitHub remote found")
      }
      
      // Get current directory name
      const dirName = directory.split('/').pop() || repoName
      
      // Generate README content based on template structure
      const readme = `# ${dirName.replace(/_/g, ' ').replace(/-/g, ' ').split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')}

Automated project setup and development tools.

## ⚠️ **IMPORTANT NOTICE**

**This project is under active development.**

- ✅ **Supported**: Check documentation for supported features
- ⚠️ **Experimental**: Some features may be unstable
- 📋 **Requirements**: Review system requirements before installation

## 🚀 Quick Start

### Clone Repository

\`\`\`bash
git clone https://github.com/${repoPath}.git
\`\`\`

\`\`\`bash
cd ${repoName}
\`\`\`

\`\`\`bash
# Run setup or main script
bash run.sh
\`\`\`

## 📦 What Gets Installed

### Core Components
- Main application services
- Required dependencies
- Configuration files
- Development tools

### Optional Features
- Additional tools and utilities
- Extended functionality
- Performance optimizations

## 🐧 Supported Platforms

- ✅ **Linux** - Full support
- ✅ **macOS** - Full support  
- ✅ **Windows** - Via WSL/WSL2
- ✅ **Docker** - Containerized deployment

## 📋 Available Tools

**Installation Tools:**
- **Main Setup** - Install core components
- **Dependencies** - Install required packages
- **Configuration** - Set up configuration files
- **Development Tools** - Install dev environment

**Maintenance Tools:**
- **Update** - Update all components
- **Backup** - Backup configuration
- **Reset** - Reset to defaults
- **Uninstall** - Remove all components

## 🔧 Troubleshooting

- **Permission denied**: Run with appropriate permissions
- **Dependencies missing**: Install required packages first
- **Configuration errors**: Check config files
- **Service not starting**: Check logs for errors

## 📁 Project Structure

\`\`\`
├── run.sh                 # Main entry point
├── src/                   # Source code
│   └── *.js              # JavaScript files
├── config/               # Configuration files
├── docs/                 # Documentation
├── tests/                # Test files
├── scripts/              # Utility scripts
└── README.md             # This file
\`\`\`

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: \`git checkout -b feature-name\`
3. Make changes and test
4. Commit: \`git commit -m "Add feature"\`
5. Push: \`git push origin feature-name\`
6. Create Pull Request

## 📞 Support

- Create GitHub issue for bugs
- Check documentation first
- Review troubleshooting section
- Test before reporting issues

---
Generated with README Generator Plugin`
      
      // Write the README file
      await $`echo ${readme} > ${worktree}/README.md`.quiet()
      
      console.log(`\n✅ README.md generated successfully!`)
      console.log(`📍 Location: ${worktree}/README.md`)
      console.log(`📋 GitHub URL: ${githubUrl}`)
      console.log(`📋 Based on template structure from README_SAMPLE.md\n`)
      
      return true
    } catch (error) {
      console.log(`\n❌ Failed to generate README: ${error.message}\n`)
      return false
    }
  }

  console.log(`✅ README Generator Plugin: Ready`)
  console.log(`💡 Type "generate-rm" to create a README.md file\n`)

  return {
    event: async ({ event }) => {
      if (event.type === "message" && event.data?.content?.includes("generate-rm")) {
        console.log("\n📝 Generating README.md...")
        await generateReadme()
      }
    }
  }
}