#!/bin/bash
echo "🔍 Generating GitHub URL..."
url=$(git remote -v | grep -o 'github\.com[:/][^/]*\/[^/ ]*' | head -1 | sed 's|github\.com[:/]|https://github.com/|')
if [ -n "$url" ]; then
  echo "✨ $url"
else
  echo "❌ No GitHub remote found"
fi