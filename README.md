# Glow Jam for Adobe After Effects (v0.12.0)

<p align="left">
  <img src="https://img.shields.io/badge/macOS-13.4+-blue?logo=apple" alt="macOS 13.4+">
  <img src="https://img.shields.io/badge/Apple-Silicon_%26_Intel-success?logo=apple" alt="Universal Binary">
  <img src="https://img.shields.io/badge/Apple_Notarized-Accepted-green?logo=apple" alt="Apple Notarized">
  <img src="https://img.shields.io/badge/License-Free-brightgreen" alt="Free">
  <a href="https://www.instagram.com/hyun2xyz/"><img src="https://img.shields.io/badge/Author-@hyun2xyz-E4405F?logo=instagram" alt="Instagram"></a>
</p>

2.5D AI 공간 조명 리라이팅 및 깊이(Depth) 추론 애프터이펙트 플러그인 **Glow Jam**입니다.  
2D 푸티지나 일러스트에서 AI가 자동으로 깊이감을 계산하고, 실시간 입체 조명 효과를 연출할 수 있습니다.

---

## 📥 다운로드 (Download)

* **macOS 최신 배포판:**  
  👉 [**Glow_Jam_macOS_0.12.0.dmg 다운로드**](https://github.com/hyun2xyz/Glowjam/releases/download/v0.12.0/Glow_Jam_macOS_0.12.0.dmg) (약 371MB)

*(Apple Notary Service 정식 공증 및 Developer ID 서명이 완료되어 별도의 보안 경고 없이 즉시 실행됩니다)*

---

## 🛠 설치 방법 (Installation)

### macOS
1. 상단 링크에서 `Glow_Jam_macOS_0.12.0.dmg`를 다운로드하여 엽니다.
2. DMG 안의 **`Install Glow Jam.app`**을 더블 클릭하여 실행합니다.
3. **[설치하기]** 버튼을 누르면 플러그인 2종과 AI 가중치 모델이 자동으로 After Effects에 설치됩니다.
4. 설치 완료 후 **[닫기]**를 누르고 After Effects를 실행합니다.

> 💡 **제거(Uninstall) 방법:** 언제든지 `Install Glow Jam.app`을 실행한 뒤 좌측 하단 **[제거...]** 버튼을 누르면 안전하게 원클릭으로 제거됩니다.

---

## 🎨 사용 방법 (How to Use)

Adobe After Effects를 실행한 후 레이어에 효과를 적용합니다:

* **상단 메뉴:** `Effect` → `glow_jam`
  * **`Glow Jam`**: 2.5D 공간 조명 리라이팅 (Point, Directional, Spot 조명 및 강도/색상 제어)
  * **`Depth Jam`**: AI 뎁스맵 생성 (AI 가중치 모델로 실시간 흑백 깊이맵 추출)

---

## ⚙️ 시스템 요구 사항 (System Requirements)

* **OS:** macOS 13.4 Ventura 이상 (Apple Silicon M1/M2/M3/M4 및 Intel Mac 지원)
* **호스트 앱:** Adobe After Effects CC (2023 이상 권장)
* **내장 구성 요소:**
  * Glow Jam Native AE Plugin
  * Depth Jam Native AE Plugin
  * Distill Any Depth Base ONNX AI Model (~340MB)
  * Universal ONNX Runtime C++ Engine

---

## 👤 제작자 (Creator)

* **Hyun Kim** ([@hyun2xyz](https://www.instagram.com/hyun2xyz/))
* Instagram: https://www.instagram.com/hyun2xyz/
