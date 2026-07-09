# CV184X BSP And MPI Distilled Document Index

Use this reference when a CV184X question spans more than one BSP, MPI, ISP, peripheral, RTOS, burning, or security manual. It is an installed index of distilled document coverage; original vendor PDFs are not required for normal use.

## Source Material

This reference was distilled from the CV184X BSP + MPI SDK document collection. The specific topic summaries live in the linked references so installers can use the skill without the original documents.

When an exact command, board path, option, register value, electrical value, or API signature matters, verify against the selected SDK repo, HDK, schematic, datasheet, or original vendor document.

## Topic Routing

- Chip-level hardware questions such as pins, boot straps, package, voltage domains, electrical characteristics, power sequencing, clocks, resets, or silicon peripheral capabilities:
  load [chip-datasheet-local.md](chip-datasheet-local.md).
- Linux BSP, SDK build, rootfs, U-Boot, partitions, boot logo, burning, secure boot, eFuse, and release hardening:
  load [cv184x-system-burning-security.md](cv184x-system-burning-security.md).
- MPI media pipelines, sensor, MIPI, ISP, PQ, display, VENC, LDC, GFBG, TDE, and TDL C API:
  load [cv184x-media-isp.md](cv184x-media-isp.md).
- Peripheral drivers, Wi-Fi, RTC, audio quality, RT-Thread, AliOS, IPCM, and CIPHER:
  load [cv184x-peripherals-rtos.md](cv184x-peripherals-rtos.md).
- Repo commands, board selection, and build target discovery:
  load [local-cv184x-build.md](local-cv184x-build.md) and use the live repo as source of truth.

## PDF Catalog

### BSP, Build, Burning, And Security

- `LinuxDevelopmentEnvironmentUserGuide_zh.pdf`
  Linux BSP basics: kernel, DTS, kernel config, rootfs, and BusyBox.
- `SDKCompilationandUsageGuide_zh.pdf`
  SDK acquisition, build environment, board config, full and partial builds, partitions, memory map, SD burning, rootfs, and NFS.
- `U-bootPortingDevelopmentGuide_zh.pdf`
  U-Boot porting, board init, pinmux, build flow, and FIP artifacts.
- `StartupScreenUserGuide_zh.pdf`
  U-Boot and AliOS boot logo, panel integration, and logo packaging.
- `CvitekFlashPartitionToolUserGuide_zh.pdf`
  Flash partition XML, generated partition config, SPINOR/SPINAND/eMMC rules.
- `ProductionBurningUserGuide_zh.pdf`
  Production burning by USB, UART, SD card, TFTP, and programmer.
- `SPINANDProgrammerBurn-inUserGuide_zh.pdf`
  SPINAND programmer pre-burn rules, raw images, FIP duplication, and bad-block handling.
- `CvitekBareandNon-BareProcessorBurningUpgradeOperationGuide_zh.pdf`
  SD bare burning, `upgrade.zip`, and USB upgrade flows.
- `SecureBootUserGuide_zh.pdf`
  FIP secure boot, FIT secure boot, SquashFS RootFS signature, DATA signature, and eFuse flow.
- `eFuseUserGuide_zh.pdf`
  eFuse areas, U-Boot `efuser` and `efusew`, and `CVI_EFUSE_*` API.
- `CyberSecurityPrecautionsforSDKSecondaryDevelopment_zh.pdf`
  Release hardening checklist for U-Boot, Linux, drivers, app development, removable media, JTAG, and AliOS.

### Media, ISP, Sensor, Display, And AI API

- `MediaProcessingSoftwareDevelopmentReference_zh.pdf`
  MPI media API reference: `SYS/VB/LOG`, `VI`, `VO`, `VPSS`, `VENC`, `VDEC`, `RGN`, audio, `GDC/LDC`, and proc debug.
- `c_interface_zh.pdf`
  TDL C API reference for detection, face, classification, keypoint, segmentation, feature extraction, lane, depth, tracking, OCR, and app-level helpers.
- `ISPDevelopmentReference_zh.pdf`
  ISP and 3A API reference: ISP control, AE, AWB, AF, sensor callbacks, bin import/export, image modules, stats, debug, and proc.
- `ISPTuningGuide_zh.pdf`
  Image-quality tuning flow for linear and WDR modes, calibration, brightness, color, contrast, sharpness, and noise.
- `PQToolsUserGuide_zh.pdf`
  PC-side PQ tool, online parameter read/write, Raw/YUV capture, 3A analysis, bin import/export, and helper tools.
- `Sensor_Debugging_Guide_zh.pdf`
  Sensor bring-up for Linux normal boot and AliOS fast boot, `sensor_test`, RAW/YUV dump, AE, FPS, and MIPI error triage.
- `MIPIUserGuide_zh.pdf`
  MIPI RX/TX ioctl and API reference, lane mapping, HS settle, WDR, crop, and proc info.
- `LDCDebuggingGuide_zh.pdf`
  LDC model, barrel and pincushion correction, data flow, and calibration tool.
- `ScreenDockingGuide_zh.pdf`
  MIPI DSI and LVDS panel integration in U-Boot, kernel, and dual-system flows.
- `GFBGDevelopmentGuide_zh.pdf`
  Graphics framebuffer module, VRAM parameters, mmap/ioctl workflow, and GFBG ioctls.
- `TDEUserGuide_zh.pdf`
  2D engine API: open, job, wait, cancel, rotate, line draw, and quick copy.
- `SmartCodingUserGuide_zh.pdf`
  VENC smart coding: NormalP, SmartP, ROI, and SVC.
- `BitRateControlApplicationNotes_zh.pdf`
  VENC rate-control notes for CBR, VBR, AVBR, macroblock RC, frame drop, GOP, QP, and low bitrate.

### Peripherals, RTOS, Communication, And Crypto

- `PeripheralDriver_zh.pdf`
  Ethernet, USB, SD/MMC, I2C, SPI, GPIO, UART, watchdog, PWM, ADC, pinmux, DMA, and thermal policy.
- `Wi-FiUserGuide_zh.pdf`
  SDIO Wi-Fi, RTL8189FS flow, STA, SoftAP, NAT, and throughput tests.
- `RTCApplicationGuide_zh.pdf`
  `/dev/rtc0`, `ioctl`, `date`, `hwclock`, RTC node removal, alarm, and auto restart.
- `AudioQualityTuningGuide_zh.pdf`
  VQE audio tuning: AEC/AES, NR, AGC, notch, digital gain, delay, and EQ.
- `RT-Thread_Compilation_and_Usage_Instructions_zh.pdf`
  RT-Thread build, `menuconfig_rtt`, `yoc.bin`, and MSH commands.
- `AliOS_Compilation_and_Usage_Instructions_zh.pdf`
  AliOS build, `yoctools`, `yoc.bin`, media/proc CLI, IPCM debug, memory, and task commands.
- `IPCM_Customized_Communication_Introduction_zh.pdf`
  Linux/RTOS custom communication API, shared buffers, custom messages, and boot-state helpers.
- `CIPHERAPIReference_zh.pdf`
  CIPHER API: AES, DES, SM4, HASH, HMAC, RNG, RSA, and KLAD.

## Working Rules

- Do not answer a CV184X documentation question from only one generic family page when a distilled topic reference exists for the topic.
- Do not answer chip electrical or pinout questions from SDK manuals alone. Route to the datasheet summary, then cross-check with board files or schematics.
- Do not promote examples from one boot mode or OS to another without checking the manual. Linux shell, RT-Thread MSH, AliOS CLI, and U-Boot commands are different command surfaces.
- Do not mix media layers: `VO`, `GFBG`, `TDE`, panel configuration, and boot logo are related but separate.
- Do not mix burning formats: SD, USB, TFTP, programmer, raw images, `upgrade.zip`, signed FIP, encrypted FIP, and SPINAND preprocessed FIP have different handling rules.
- For exact paths under `build/boards/cv184x/<board>/...`, inspect the selected board in the live SDK repo before giving a final command.
