<p align="center">
  <img src="assets/glowjam_banner.png" alt="Glow Jam After Effects relighting plug-in" width="600">
</p>

<p align="center">
  <a href="https://github.com/hyun2xyz/Glowjam/releases/latest"><img src="https://img.shields.io/badge/Release-v0.12.0-blue?style=flat-square" alt="Latest release"></a>
  <img src="https://img.shields.io/badge/macOS-13.4+-black?style=flat-square&logo=apple" alt="macOS 13.4 or later">
  <img src="https://img.shields.io/badge/Windows-10%20%2F%2011-0078D6?style=flat-square&logo=windows" alt="Windows 10 or 11">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License">
  <a href="https://hyun2.cloud"><img src="https://img.shields.io/badge/Website-hyun2.cloud-blueviolet?style=flat-square" alt="Website"></a>
  <a href="https://www.instagram.com/hyun2xyz/"><img src="https://img.shields.io/badge/Instagram-@hyun2xyz-E4405F?style=flat-square&logo=instagram" alt="Instagram"></a>
</p>

English | [한국어 README](README.ko.md)

# Glow Jam

> A lightweight 2.5D AI relighting plug-in for Adobe After Effects.

Glow Jam applies controllable light to 2D footage and images by using a local depth map. It is designed for quick, practical relighting inside After Effects without requiring a full 3D scene.

## Features

### Glow Jam

- Three practical light modes: `Spread`, `Directional`, and `Spot`
- On-screen position, radius, direction, and cone guides
- Color, intensity, size, softness, Z depth, and mix controls
- `Light Only` output for compositing the relighting pass separately
- `Parent Target` support for following a tracked Null or another layer

### Depth Jam

- Local depth estimation with the bundled Distill Any Depth Base runtime
- `256 px` for faster previews and `512 px` for higher-quality maps
- Invert, gamma, and contrast controls for shaping the depth map
- Designed to be used as the `Surface Layer` input for Glow Jam

## Download

| Platform | Download |
| --- | --- |
| macOS 13.4 or later | [Glow_Jam_macOS_0.12.0.dmg](https://github.com/hyun2xyz/Glowjam/releases/download/v0.12.0/Glow_Jam_macOS_0.12.0.dmg) |
| Windows 10/11 64-bit | [Glow_Jam_Windows_0.12.0.zip](https://github.com/hyun2xyz/Glowjam/releases/download/v0.12.0/Glow_Jam_Windows_0.12.0.zip) |

See the [v0.12.0 release page](https://github.com/hyun2xyz/Glowjam/releases/tag/v0.12.0) for release notes and checksums.

## Installation

Close After Effects completely before installing or updating the plug-in.

### macOS

1. Download and open `Glow_Jam_macOS_0.12.0.dmg`.
2. Launch `Install Glow Jam.app`.
3. Click **Install** and wait for the plug-ins and local runtime files to be copied.
4. Close the installer and relaunch After Effects.

### Windows

1. Extract `Glow_Jam_Windows_0.12.0.zip`.
2. Right-click `windows/원클릭_자동설치(우클릭후_관리자권한실행).bat` and choose **Run as administrator**.
3. Confirm the completion message, then relaunch After Effects.

The Windows installer detects the standard Adobe MediaCore and shared-data locations. If you install manually, copy the plug-in files to:

```text
C:\Program Files\Adobe\Common\Plug-ins\7.0\MediaCore\glow_jam\
```

and the bundled depth model to:

```text
C:\ProgramData\glow_jam\models\runtime\distill-any-depth-base\model.onnx
```

## Basic workflow

1. Import footage or an image and select the source layer.
2. Apply `Effect > glow_jam > Depth Jam` to create a depth-map layer.
3. Apply `Effect > glow_jam > Glow Jam` to the source layer.
4. Set `Surface Layer` to the Depth Jam layer.
5. Choose a `Light Mode`, then adjust the on-screen position and direction guide.
6. Tune `Z`, `Intensity`, `Size`, `Softness`, and `Mix` for the shot.
7. Use `Light Only` when you need the relighting pass without the original image.
8. Set `Parent Target` to a tracked Null or another layer when the light should follow motion.

For detailed controls and troubleshooting, see the [Korean user guide](docs/USER_GUIDE.ko.md).

## Controls at a glance

### Depth Jam

- **Quality:** `256 px` for previews or `512 px` for higher-quality output.
- **Invert Depth:** Reverses the foreground/background depth relationship.
- **Depth Gamma:** Shapes the distribution of mid-range depth values.
- **Depth Contrast:** Expands or compresses the black-and-white depth range.

### Glow Jam

- **Surface Layer:** Selects the layer containing depth information.
- **Parent Target:** Follows a Null or other layer, including tracked motion.
- **Position:** Sets the 2D light center.
- **Color:** Sets the light color.
- **Light Mode:** `Spread` radiates locally, `Directional` sends light in one direction, and `Spot` adds a cone-shaped direction to the light.
- **Z:** Places the light from back to front in the depth range.
- **Intensity:** Sets brightness from `0` to `100`.
- **Size:** Sets the light radius.
- **Softness:** Controls edge falloff.
- **Light Only:** Outputs the relighting contribution without the source image.
- **Mix:** Blends the relit result with the original layer.

## Troubleshooting

- If the on-screen guides are missing, enable `View > Show Layer Controls` in After Effects. The shortcut is `Ctrl+Shift+H` on Windows and `Cmd+Shift+H` on macOS.
- If the effects do not appear, close After Effects completely and run the installer again.
- For previews, use `Depth Jam` at `256 px` or pre-render the depth-map layer before working at `512 px`.

## License and third-party notices

- The Glow Jam plug-in code and packaging materials are provided under the [MIT License](LICENSE).
- ONNX Runtime is distributed under the MIT License by Microsoft. The exact pinned runtime release must retain its upstream `LICENSE` and `ThirdPartyNotices.txt` files.
- The bundled Distill Any Depth Base checkpoint is a third-party model. Confirm the exact checkpoint, model-card terms, commercial-use permission, and redistribution rights before shipping a paid product.

See [docs/THIRD_PARTY_NOTICES.md](docs/THIRD_PARTY_NOTICES.md) for the current notices and distribution checklist.

## Support

- Website: [hyun2.cloud](https://hyun2.cloud)
- Instagram: [@hyun2xyz](https://www.instagram.com/hyun2xyz/)
- Bug reports and feature requests: [GitHub Issues](https://github.com/hyun2xyz/Glowjam/issues)
