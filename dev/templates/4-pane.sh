#!/usr/bin/env bash
# 4 equal terminal panes, all in project dir
SESSION="$1"
DIR="$2"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$SESSION"
  else
    tmux attach-session -t "$SESSION"
  fi
  exit 0
fi

tmux new-session -d -s "$SESSION" -c "$DIR"
tmux split-window -t "$SESSION" -c "$DIR"
tmux split-window -t "$SESSION" -c "$DIR"
tmux split-window -t "$SESSION" -c "$DIR"
tmux select-layout -t "$SESSION" tiled

if [[ -n "$TMUX" ]]; then
  tmux switch-client -t "$SESSION"
else
  tmux attach-session -t "$SESSION"
fi
