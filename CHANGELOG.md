# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/)
and this project follows semantic versioning.

## [2.0.1] – 2026-01-14 – Stability & UX Update
- Added system status screen
- Improved FPS benchmark validation
- Added CS2 path pre-run checks
- Minor UX improvements and clearer warnings

---
## [2.0.0] – 2026-01-06 - Big update

### Added
- Console-based frontend application
- Modular `/scripts` engine architecture
- SAFE / PERFORMANCE / BENCHMARK optimization modes
- Automatic hardware detection (GPU / CPU / RAM)
- GPU-specific optimizers for NVIDIA and AMD
- Timer Resolution launcher with fallback logic
- FPS benchmark runner using CS2 `-condebug`
- Automatic FPS parser (AVG / MIN)
- Full system revert functionality
- First-run setup script (`install_all.bat`)
- Logging system for runs and benchmarks

### Technical
- No PowerShell dependency
- No persistent background services
- No auto-close behavior
- Fully portable (no installer required)

### Safety
- All tweaks reversible
- Revert script restores Windows defaults
- No driver-level modifications

---

## Planned
- FPS history export (CSV)
- EXE build with icon
- Auto-update mechanism
- Optional GUI frontend

---

## [1.2.0] – 2025-12-29
### Added
- One-click CS2 + Windows optimizer installer
- Automatic CPU and GPU hardware detection
- Full Windows optimization revert script
- NVIDIA-specific FPS and latency optimizer
- AMD-specific FPS and latency optimizer
- Timer Resolution launcher for reduced input latency
- Modular scripts directory for better project structure

### Improved
- Overall FPS stability and frame-time consistency
- Input latency handling on Windows systems
- Network responsiveness and reliability
- Safety and reversibility of system optimizations
- Installation flow and ease of use

---

## [1.1.0] – 2025-11-20
### Added
- Windows FPS & latency optimizer batch script - draft
- Optional utility binds documentation
- Pro crosshair preset - deprecated

### Improved
- Documentation clarity
- Competitive stability recommendations

---

## [1.0.0] – 2025-01-23
### Added
- Initial CS2 autoexec release
- FPS and menu FPS optimization
- Network stability configuration
- Raw mouse input
- Clean viewmodel configuration
- Scroll wheel jump bind
- Anti-cheat safe setup (VAC, FACEIT, Premier)

---

## [Unreleased]
- NVIDIA / AMD specific optimizations
- Per-CPU tuning presets
- Automatic FPS cap detection
