# Project Issues

> These issues are written to be standalone — each one can be handed to an AI coding assistant (e.g. Claude Code) on its own, without needing extra context from this file or from a conversation. Update the "Context / Files" section in each issue with real paths once you point the AI tool at your repo.

---

## Issue #1: Add Download Feature

### Summary
Users need a way to download media (video/audio) from within the app for offline access. Currently there is no download functionality anywhere in the UI or backend.

### Problem
There is no button, menu option, or backend endpoint that lets a user save a file/media item to their device or local storage.

### Requirements
- [ ] Add a "Download" button/icon in the player UI (and/or list/detail view) for each media item.
- [ ] On tap/click, fetch the media file and save it to the device's local storage / downloads folder (respect platform conventions — browser download, mobile file system, or desktop file save dialog depending on the stack).
- [ ] Show download progress (progress bar or percentage) while the file is downloading.
- [ ] Handle and surface errors (no network, insufficient storage, server error) with a user-facing message.
- [ ] Prevent duplicate/parallel downloads of the same file; if already downloading, show progress instead of starting again.
- [ ] If the item is already downloaded, change the button state to "Downloaded" / show a delete-download option.
- [ ] Respect file naming (avoid overwriting unrelated files) and store metadata (title, size, date downloaded) if the app has a local database.

### Acceptance Criteria
- Tapping "Download" on any media item downloads the correct file with no corruption.
- Progress indicator updates smoothly and completes at 100% when done.
- Downloaded items are accessible/playable offline (if the app supports offline playback) or accessible in the OS's download location.
- Errors are caught and shown to the user, not silently swallowed or crashing the app.

### Context / Files
- Identify the media player component (e.g. `Player.*`, `VideoScreen.*`) and the network/API layer used to fetch media.
- Identify if the app already has permission handling for storage (mobile) — add if missing.

### Suggested Priority
High

---

## Issue #2: Side Swipe Gesture for Brightness (Left) and Volume (Right) Not Working Correctly

### Summary
The player is supposed to support the common video-player gesture pattern: swiping vertically on the **left side** of the screen adjusts **screen brightness**, and swiping vertically on the **right side** of the screen adjusts **volume**. This gesture control is either missing, broken, or behaving inconsistently.

### Problem
Swipe gestures on the left/right halves of the video screen do not reliably increase or decrease brightness/volume. Possible symptoms to verify and fix:
- Swipe up/down does nothing.
- Swipe works but direction is inverted (up decreases instead of increases, or vice versa).
- Swipe works only on one side, not both.
- No visual feedback (no on-screen brightness/volume indicator/slider shown during swipe).
- Gesture conflicts with other controls (e.g. seek bar, tap-to-pause) causing jitter or misfires.

### Requirements
- [ ] Detect vertical swipe/pan gestures separately on the left half and right half of the video surface.
- [ ] Left-side swipe up → increase screen brightness; swipe down → decrease screen brightness.
- [ ] Right-side swipe up → increase volume; swipe down → decrease volume.
- [ ] Show a temporary on-screen overlay/indicator (icon + level bar or percentage) while swiping, which fades out after a short delay (e.g. 800ms–1s) once the gesture ends.
- [ ] Clamp brightness/volume between 0% and 100% (or the platform's min/max).
- [ ] Make the swipe sensitivity reasonable — full swipe from top to bottom of the screen should roughly go from 100% to 0% (or a configurable sensitivity constant).
- [ ] Ensure the gesture doesn't interfere with existing tap-to-play/pause, double-tap-to-seek, or horizontal-swipe-to-seek gestures.
- [ ] Persist volume changes through the normal system/app volume state (so it stays in sync with hardware volume buttons if applicable).
- [ ] Brightness changes should only affect the app/screen brightness while the player is open (not permanently override system brightness), unless the app is explicitly designed to change system brightness permanently.

### Acceptance Criteria
- Swiping up/down on the left side smoothly and predictably changes brightness with visible feedback.
- Swiping up/down on the right side smoothly and predictably changes volume with visible feedback.
- No conflicts with other player gestures (seeking, play/pause, double-tap).
- Works consistently across repeated gestures (no drift, no getting "stuck").

### Context / Files
- Identify the gesture handler currently attached to the video view (e.g. `PanResponder`, `GestureDetector`, touch event listeners, or platform-specific gesture recognizers).
- Identify existing brightness/volume control APIs already used in the codebase, if any.

### Suggested Priority
Medium-High

---

## Issue #3: Video Equalizer Not Working Properly

### Summary
The video/audio equalizer feature is present in the app but is not functioning correctly — it does not properly alter the audio output when adjusted.

### Problem
Symptoms to investigate and confirm (test each explicitly, since the exact failure mode isn't clear yet):
- Equalizer sliders/presets have no audible effect on playback.
- Equalizer settings reset when the video is paused/resumed or when switching media.
- Equalizer applies incorrectly (e.g. wrong frequency bands affected, distortion/clipping introduced, or gain applied inconsistently).
- Equalizer UI and actual audio pipeline are out of sync (UI shows a value, but the underlying audio filter isn't updated).
- Crash or audio glitch (pop, stutter, mute) when adjusting bands in real time.

### Requirements
- [ ] Reproduce the current bug(s) and document exact steps + observed vs expected behavior before fixing.
- [ ] Verify the audio pipeline/engine used (e.g. ExoPlayer, AVAudioEngine, ffmpeg-based filter, Web Audio API `BiquadFilterNode`, etc.) and confirm equalizer nodes/filters are actually inserted into the active audio graph — not just being visually presented.
- [ ] Ensure each band's gain/frequency/Q value updates the audio graph in real time without needing to restart playback.
- [ ] Ensure equalizer settings persist correctly per session (and optionally per-user preference) across pause/resume/track change, unless intentionally reset.
- [ ] Fix any distortion/clipping by ensuring gain values are properly clamped and normalized.
- [ ] Sync UI state with actual applied audio parameters (single source of truth — don't let UI state and audio engine state diverge).
- [ ] Verify presets (if any, e.g. "Bass Boost", "Treble", "Flat") apply the correct band values.
- [ ] Add basic tests or a manual QA checklist confirming audible difference is heard for typical use (bass boost noticeably increases low frequencies, etc.).

### Acceptance Criteria
- Moving any equalizer band produces an audible, correct change in the audio output in real time.
- Settings don't unexpectedly reset or desync from the UI.
- No crashes, pops, or glitches when adjusting the equalizer during playback.
- Presets apply the expected frequency/gain configuration.

### Context / Files
- Identify the equalizer component/UI and the underlying audio engine/library it's supposed to control.
- Check whether the equalizer nodes are actually attached to the playback audio session, or only to a decoupled/test audio graph.

### Suggested Priority
High (existing broken feature affecting current users)

---

## How to Use These Issues With an AI Coding Tool

1. Open your project in Claude Code (or a similar AI coding tool).
2. Paste one issue at a time (they're self-contained) along with: "Here's the issue, here's my repo — find the relevant files and implement this."
3. Ask the AI tool to first locate the relevant files/components (player, gesture handlers, audio engine, download manager) before writing code, since the exact file paths depend on your project structure.
4. Review each fix/feature against the Acceptance Criteria listed above before merging.