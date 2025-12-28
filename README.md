# CS2 FPS Optimization Autoexec 🚀

High-performance **Counter-Strike 2 autoexec** focused on maximum FPS, low latency, and smooth gameplay.  
Safe for matchmaking, FACEIT, and Premier.

---

## 📂 Installation

1. Navigate to:

Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg\


2. Copy `autoexec.cfg` into the directory above.

3. Open **Steam → CS2 → Properties → Launch Options**
4. Add:

+exec autoexec -novid



---

## ⚡ FPS Stability Recommendation

If you experience stutters or inconsistent frame times, limit FPS manually:

| Monitor Refresh Rate | Recommended Setting |
|----------------------|---------------------|
| 144 Hz               | `fps_max 240`       |
| 240 Hz               | `fps_max 300`       |
| 360 Hz               | `fps_max 360`       |

Stable FPS is always better than unlimited FPS.

---

## 🔧 Features

- Optimized FPS and menu FPS limits
- Stable network configuration
- Raw mouse input enabled
- Clean and minimal viewmodel
- Reduced camera bob for better aim stability
- Scroll wheel jump bind
- Competitive-ready configuration
- No cheat or exploit commands

---

## 🎯 Pro Crosshair (Optional)

Example professional-style crosshair configuration:

cl_crosshairsize 2
cl_crosshairthickness 0.5
cl_crosshairgap -3
cl_crosshairdot 0
cl_crosshair_drawoutline 0
cl_crosshairalpha 255
cl_crosshaircolor 1


You can paste this directly into `autoexec.cfg` or execute it in console.

---

## 🎮 Utility & QoL Binds (Optional)

### Jumpthrow Bind

alias "+jumpthrow" "+jump;-attack"
alias "-jumpthrow" "-jump"
bind "V" "+jumpthrow"


### Clear Decals (Blood & Bullet Holes)

bind "F" "r_cleardecals"


### Quick Grenade Slots

bind "4" "slot4" // Grenades
bind "5" "slot5" // Bomb


---

## 🛡️ Anti-Cheat Safety

✔ VAC  
✔ FACEIT  
✔ Premier  
✔ Community Servers  

No banned or experimental commands included.

---

## 🎛️ Customization

You should customize these values inside `autoexec.cfg`:
- `sensitivity`
- `volume`
- `fps_max`
- Crosshair settings (optional)

---

## 📦 Project Structure

cs2-fps-optimization/
│
├── cfg/
│ └── autoexec.cfg
│
├── README.md
├── CHANGELOG.md
└── LICENSE


---

## 📝 CHANGELOG

### v1.0.0 – Initial Release
- FPS & latency optimized autoexec
- Stable network configuration
- Scroll wheel jump
- Clean viewmodel
- Anti-cheat safe

---

## 🚀 Release Notes

**CS2 FPS Optimization Autoexec v1.0.0**

- Competitive-ready configuration
- Designed for high-refresh-rate monitors
- Zero cheats or exploits
- Plug & play setup

---

## ⭐ Contributing

Pull requests are welcome.  
If you have optimization ideas, feel free to open an issue or submit a PR.

---

## 📜 License

MIT License
