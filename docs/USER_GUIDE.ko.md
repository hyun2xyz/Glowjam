# Glow Jam 사용자 가이드 (User Guide)

Adobe After Effects를 위한 2.5D AI 공간 조명 리라이팅 플러그인 **Glow Jam**과 AI 깊이 추론 플러그인 **Depth Jam**의 공식 사용 가이드입니다.

---

## 1. 지원 환경 및 설치

### 시스템 요구 사항
- **macOS**: macOS 13.4 Ventura 이상 (Apple Silicon M1/M2/M3/M4 및 Intel Mac 지원)
- **Windows**: Windows 10 / 11 (64-bit)
- **호스트 프로그램**: Adobe After Effects CC (2022, 2023, 2024, 2025, 2026 호환)

### 설치 방법
* **macOS:**
  1. 다운로드받은 `Glow_Jam_macOS_0.12.0.dmg`를 엽니다.
  2. `Install Glow Jam.app`을 실행하고 **[설치하기]**를 클릭합니다.
  3. 완료 후 After Effects를 실행합니다.
* **Windows:**
  1. 배포 패키지 압축을 해제합니다.
  2. `windows/원클릭_자동설치(우클릭후_관리자권한실행).bat`을 마우스 우클릭 후 **[관리자 권한으로 실행]**합니다.
  3. 완료 팝업 확인 후 After Effects를 실행합니다.

---

## 2. 기본 작업 흐름 (Workflow)

1. **컴포지션 준비:** After Effects에서 효과를 적용할 비디오 푸티지 또는 이미지 레이어를 준비합니다.
2. **Depth Jam 적용 (깊이 맵 생성):**
   - 상단 메뉴 `Effect` → `glow_jam` → **`Depth Jam`**을 선택합니다.
   - AI가 자동으로 영상의 전후 깊이를 계산하여 흑백 뎁스맵을 실시간 렌더링합니다.
   - *팁: 작업 속도를 위해 프리뷰 단계에서는 Quality를 256으로 두고, 최종 렌더링 시 512로 설정하거나 사전 렌더링(Pre-render)을 권장합니다.*
3. **Glow Jam 적용 (조명 연출):**
   - 원본 레이어에 상단 메뉴 `Effect` → `glow_jam` → **`Glow Jam`**을 적용합니다.
   - `Surface Layer` 옵션에서 앞서 생성한 Depth Jam 레이어를 지정합니다.
   - 화면 위의 조명 중심점(Position)과 반경 핸들을 조절하여 원하는 위치에 3D 조명을 비춥니다.

---

## 3. 세부 컨트롤 설명

### Depth Jam
* **Quality (해상도):** 256 px(고속 프리뷰용) 또는 512 px(고품질 최종 렌더링용)
* **Invert Depth (반전):** 전경과 배경의 흑백 깊이 반전
* **Depth Gamma (감마):** 중간 깊이 영역의 명암 분포 조절
* **Depth Contrast (대비):** 흑백의 경계를 벌리거나 압축하여 입체감 강도 조절

### Glow Jam
* **Surface Layer:** 깊이 데이터를 참조할 뎁스 맵 레이어
* **Parent Target:** 추적(Tracking) 데이터가 있는 Null 오브젝트나 다른 레이어를 지정하여 조명이 타겟을 따라다니게 설정
* **Position:** 화면 상의 조명 2D 중심 좌표
* **Color:** 조명의 색상
* **Light Only:** 원본 영상을 숨기고 리라이팅 성분(빛과 그림자)만 단독 출력 (Screen/Add 블렌딩 모드로 합성 시 유용)
* **Z (Depth Back <-> Front):** 빛이 비추는 3차원 전후 깊이 위치 (-1: 뒷배경, +1: 맨 앞)
* **Intensity:** 조명의 밝기 강도 (0 ~ 100)
* **Size:** 조명의 반경(크기)
* **Softness:** 조명 가장자리의 부드러운 감쇄 정도
* **Mix:** 원본 영상과 리라이팅 결과물의 합성 비율

---

## 4. 자주 묻는 질문 및 문제 해결 (FAQ & Troubleshooting)

* **Q. 조명 조절 핸들이 컴포지션 패널에서 보이지 않아요.**
  - After Effects 상단 메뉴 `View` → `Show Layer Controls`를 켜주세요. (단축키: Mac `Cmd+Shift+H` / Win `Ctrl+Shift+H`)
* **Q. 창(Window) 메뉴에 스크립트 패널이 없어요.**
  - 최신 Glow Jam v0.12.0은 번거로운 스크립트 창 없이 **오직 `Effect` 메뉴의 네이티브 플러그인**으로만 가볍고 안정적으로 동작하도록 통합되었습니다.
* **Q. 플러그인이 After Effects 효과 메뉴에 나타나지 않아요.**
  - After Effects가 켜져 있는 상태에서 설치하지 않았는지 확인해 주세요. After Effects를 완전히 종료한 후 설치 앱(또는 Windows bat)을 다시 실행해 주시기 바랍니다.
