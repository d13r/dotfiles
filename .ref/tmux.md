┌──────────────────┬─────────────────────────┬──────────────────┬─────────────────────┐
│                  │ Pane                    │ Window (Tab)     │ Session             │
├──────────────────┼─────────────────────────┼──────────────────┼─────────────────────┤
│ New              │ Ctrl-A, H/V             │ Ctrl-A, C        │ Ctrl-A, Shift-C     │
├──────────────────┼─────────────────────────┼──────────────────┼─────────────────────┤
│ Previous         │ Alt-Left/Up             │ Alt-Shift-Left   │ Alt-Shift-Up        │
│                  │ Ctrl-A, Left/Up         │ Alt-PageUp       │ Ctrl-A, Shift-(     │
│                  │                         │ Ctrl-A, P        │                     │
│                  │                         │                  │                     │
│ Next             │ Alt-Right/Down          │ Alt-Shift-Right  │ Alt-Shift-Down      │
│                  │ Ctrl-A, Right/Down      │ Alt-PageDown     │ Ctrl-A, Shift-)     │
│                  │ Ctrl-A, O               │ Ctrl-A, N        │                     │
├──────────────────┼─────────────────────────┼──────────────────┼─────────────────────┤
│ Toggle           │ Ctrl-A, ;               │ Ctrl-A, L        │ Ctrl-A, Shift-L     │
│ Jump to          │                         │ Ctrl-A, 1-9      │                     │
├──────────────────┼─────────────────────────┼──────────────────┼─────────────────────┤
│ Move left        │ Ctrl-A, Shift-{         │ Ctrl-A, Shift-<  │                     │
│ Move right       │ Ctrl-A, Shift-}         │ Ctrl-A, Shift->  │                     │
│ Rotate           │ Ctrl-A, Ctrl-O          │                  │                     │
├──────────────────┼─────────────────────────┼──────────────────┼─────────────────────┤
│ Resize           │ Ctrl-A, Alt-Arrows      │                  │                     │
│ Automatic layout │ Ctrl-A, Space           │                  │                     │
├──────────────────┼─────────────────────────┼──────────────────┼─────────────────────┤
│ Rename           │                         │ Ctrl-A, ,        │ Ctrl-A, Shift-4 ($) │
│ Kill             │ Ctrl-A, X               │ Ctrl-A, K        │ Ctrl-A, Shift-X     │
└──────────────────┴─────────────────────────┴──────────────────┴─────────────────────┘

  COPY BUFFER
┌──────────────────┬──────────────────────────────────────────────────────────────────┐
│ Enter copy mode  │ Ctrl-A, [       (cursor stays put)                               │
│                  │ Ctrl-A, PageUp  (jump back one page)                             │
│                  │ Shift-PageUp    (jump back one page)                             │
├──────────────────┼──────────────────────────────────────────────────────────────────┤
│ Begin selection  │ Space                                                            │
│ Copy selection   │ Enter                                                            │
│ Clear selection  │ Escape                                                           │
│ Cancel           │ Q / Ctrl-C                                                       │
├──────────────────┼──────────────────────────────────────────────────────────────────┤
│ Paste            │ Ctrl-A, ]  (latest buffer)                                       │
│                  │ Ctrl-A, =  (select buffer)                                       │
└──────────────────┴──────────────────────────────────────────────────────────────────┘

  MISCELLANEOUS
┌──────────────────────────────┬──────────────────────────────────────────────────────┐
│ Jump to session/window/pane  │ Ctrl-A, W                                            │
├──────────────────────────────┼──────────────────────────────────────────────────────┤
│ Synchronise panes            │ Ctrl-A, S  (type into all panes simultaneously)      │
├──────────────────────────────┼──────────────────────────────────────────────────────┤
│ Disconnect                   │ Ctrl-A, D                                            │
│ Disconnect another client    │ Ctrl-A, Shift-D                                      │
│ Disconnect all other clients │ Ctrl-A, Alt-D                                        │
├──────────────────────────────┼──────────────────────────────────────────────────────┤
│ Reload configuration         │ Ctrl-A, Shift-R                                      │
└──────────────────────────────┴──────────────────────────────────────────────────────┘

  HELP
┌──────────────────────────────┬──────────────────────────────────────────────────────┐
│ This reference file          │ Ctrl-A, /                                            │
│ Manual                       │ Ctrl-A, Alt-/                                        │
│ List key bindings            │ Ctrl-A, Shift-?                                      │
└──────────────────────────────┴──────────────────────────────────────────────────────┘

To install & configure tmuxinator:

    agi tmuxinator
    mux new <name>
    mux <name>

To get the layout string for use in tmuxinator:

    Ctrl-A, :list-windows
