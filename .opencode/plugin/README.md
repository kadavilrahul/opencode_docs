# OpenCode Plugins

Simple plugins for OpenCode CLI.

## Available Plugins

### 1. GitHub URL Generator (`github-url.js`)
**Command:** Type message containing `generate-url`  
**Action:** Displays GitHub repository URL from git remote

### 2. README Generator (`readme-generator.js`)
**Command:** Type message containing `generate-rm`  
**Action:** Creates README.md file with:
- Extracts GitHub URL from git remote
- Auto-formats project name
- Adds standard sections
- Professional markdown structure

## Installation

Plugins are automatically loaded from `.opencode/plugin/` when OpenCode starts.

## Usage

1. Start OpenCode in your project directory
2. Type the command in any message:
   - `generate-url` - Shows GitHub URL
   - `generate-rm` - Creates README.md

## Plugin Structure

```javascript
export const PluginName = async ({ $, worktree, directory }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "message" && event.data?.content?.includes("command")) {
        // Plugin action here
      }
    }
  }
}
```

## Notes

- Restart OpenCode after adding/modifying plugins
- Plugins run in OpenCode's process
- Console output appears in terminal