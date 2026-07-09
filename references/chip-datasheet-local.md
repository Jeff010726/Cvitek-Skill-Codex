# Chip Datasheet Summary

Use this reference when the user asks chip-level hardware questions: pin descriptions, boot mode strap pins, package and ballout, power sequencing, electrical characteristics, timing, reset, clock, eFuse silicon capabilities, or peripheral limits that are below the SDK/manual layer.

## Source And Publication Rule

This reference distills chip-level facts from datasheets so the installed skill remains useful without the original PDFs. Datasheet PDFs are source material only. Do not commit them or copy their raw tables into this repository. Some source files may carry confidential, customer, or no-disclosure markings even when the filename sounds public.

The skill should still preserve compact derived facts that are needed by an installer who does not have the PDFs. Keep those facts summarized and operational; avoid long verbatim passages and avoid reproducing full datasheet tables.

## What Can Be Preserved In The Skill

It is acceptable to preserve:

- which chip family the distilled datasheet facts cover
- high-level module capabilities and family differences
- boot source support and boot-strap behavior that affects board bring-up
- interface counts and supported peripheral classes
- storage, security, CPU, TPU, video, ISP, and display capability summaries
- safety rules that require checking exact values in the original datasheet, board schematic, or HDK

It is not acceptable to preserve:

- full datasheet PDFs
- extracted pin tables, register maps, memory maps, electrical tables, timing tables, or power-consumption tables
- customer-marked text or confidential watermarks
- long verbatim passages
- exhaustive voltage, timing, package, or pin values that would recreate the datasheet

## Distilled Datasheet Coverage

This reference currently distills datasheet facts covering:

- `CV1842H-P` and `CV1843H-P`
- `CV1810H`, `CV1811H`, `CV1812H`, and `CV1813H`

Treat this as an embedded capability summary, not a complete datasheet replacement. If the exact filename, version, pin value, package value, electrical value, or timing value matters, inspect the original vendor datasheet or board hardware package.

## When To Use Datasheets Instead Of SDK Manuals

Use datasheets for:

- boot source strap behavior and silicon boot support
- package, pin, ball, and alternate-function questions
- voltage domains, power rails, power sequencing, and power-down behavior
- DC/AC electrical characteristics and timing budgets
- reset, clock, PLL, watchdog, timer, RTC, mailbox, DMA, and silicon controller behavior
- raw peripheral capability at the SoC level
- eFuse silicon organization and security-engine capability

Use SDK/BSP manuals and live repo files for:

- Linux DTS edits
- U-Boot board initialization
- `defconfig`, `menuconfig`, and `build_*`
- burning image layout and package generation
- MPI/ISP API usage
- driver commands, sysfs, proc, and sample applications

Use the board schematic or HDK for:

- actual pull-up or pull-down resistor population
- power-tree implementation
- connector pinout
- reset circuits
- sensor, panel, PMIC, PHY, Wi-Fi, and audio codec wiring

## CV1842H-P And CV1843H-P Routing

For CV1842H-P or CV1843H-P hardware questions, use the facts below first, then cross-check board files or schematics before suggesting an implementation.

### CV1842H-P / CV1843H-P Distilled Facts

Core processing:

- Main CPU: single Cortex-A53 class application core, ARMv8-A, supporting AArch32 and AArch64.
- Co-processor: RISC-V C906 class core.
- TPU: one integrated TPU core, intended for INT8 and BF16 AI workloads.
- MCU subsystem: integrated small MCU subsystem for low-power or BOM-reduction use cases.

Video, image, and AI:

- Target applications include endpoint AI IPC, face-recognition attendance devices, and smart-home vision products.
- Hardware video encoder supports H.264 and H.265 with 4K-class maximum encode resolution.
- VI supports MIPI RX camera input plus parallel formats such as BT.656, BT.601, BT.1120, and digital camera style inputs.
- MIPI RX supports combinations that include one 4-lane sensor or two 2-lane sensor inputs.
- ISP supports SDR and HDR modes, Bayer RAW and YUV input paths, 3A, bad-pixel correction, lens shading, lens distortion correction, denoise, sharpen, gamma, color management, local tone mapping, and wide-dynamic processing.
- Image/video processing includes rotation, mirror/flip, OSD overlay, scaling, lens distortion correction, and simple line drawing.
- TDL/TPU SDK work should still route through [tpu-sdk-common.md](tpu-sdk-common.md) and the relevant SDK sample packages.

Display and graphics:

- VO supports serial display through MIPI DSI and LVDS.
- VO also supports parallel display/output families such as BT.1120, BT.656, BT.601, I80/M68, serial RGB, and RGB formats.
- Screen bring-up must still use the screen and boot-logo manuals because U-Boot, Linux, and dual-system display paths differ.

Memory and boot storage:

- DDR interface is 16-bit DDR3 class for this family; board memory size is a board/SIP choice and must be checked against the board config.
- Boot/storage support includes SPI NOR, SPI NAND, and eMMC.
- SD card and USB device mode are supported for image burning/upgrade flows at the chip level; exact packaging comes from the SDK burning manuals.
- SPI NOR supports single-chip boot use and common single/dual/quad transfer modes.
- SPI NAND supports boot use and x1/x2/x4 transfer modes; bad-block and FIP duplication handling comes from the SPINAND programmer and burning manuals.

Boot strap summary:

- Boot source is latched from `EMMC_DAT3` and `EMMC_DAT0` at reset.
- The datasheet maps these strap states to SPI NOR boot, SPI NAND boot, and eMMC boot.
- Treat this as a silicon rule only. The actual board behavior depends on pull-up/pull-down resistor population and must be checked in the schematic or HDK before changing hardware or boot media.

Peripheral summary:

- Ethernet: one MAC with integrated 10/100M PHY support, with RMII external PHY option.
- I2C: multiple controllers, including always-on/no-die domain usage.
- UART: multiple UARTs, including always-on/no-die domain usage.
- SPI: multiple SPI controllers plus dedicated flash interfaces.
- SD/eMMC/SDIO: eMMC plus SD/SDIO controller families for card or SDIO peripherals.
- GPIO: large GPIO set with always-on/no-die domain pins.
- PWM: multi-channel PWM groups.
- ADC: multiple single-ended ADC inputs, including no-die domain inputs.
- USB: one USB dual-role device/host-capable interface.
- Audio: integrated audio codec plus external I2S/PCM/TDM style audio-codec connectivity.
- Other peripherals include DMA, timer, watchdog, RTC, mailbox, key scan, Wiegand, IR receiver, and temperature sensor.

Security:

- Security engine covers block-cipher acceleration, hash acceleration, true random number generation, secure boot/update capability, and eFuse-backed security configuration.
- eFuse exists at the silicon level, but production secure boot must follow [cv184x-system-burning-security.md](cv184x-system-burning-security.md) and current U-Boot command names.

Stable chapter-level routing:

- boot and upgrade: boot source, boot straps, secure boot support, and upgrade modes
- processor and accelerator: A-class CPU, RISC-V co-processor, TPU, and MCU subsystem capabilities
- video and image: VI, VO, ISP, VPSS, LDC, graphics, encoder, JPEG, panel outputs
- memory: DDR, SPI NOR, SPI NAND, eMMC, SD, and SDIO controller capabilities
- system control: clock, reset, interrupt, DMA, timer, watchdog, RTC, mailbox
- peripherals: Ethernet, I2C, UART, GPIO, PWM, USB DRD, ADC, temperature sensor, key scan, Wiegand, IRRX
- security: eFuse, crypto accelerator, TRNG, secure boot capability
- pins and power: pin descriptions, power domains, power sequencing, and electrical characteristics

Important boundaries:

- Boot strap behavior is a chip fact, but the board resistor population is a board fact.
- Peripheral capability in the datasheet does not prove the SDK board enables that peripheral.
- Electrical values must come from the original datasheet and board design review, not from memory.
- Secure boot requires both silicon capability and SDK image/eFuse flow; also load [cv184x-system-burning-security.md](cv184x-system-burning-security.md).

## CV1810H, CV1811H, CV1812H, And CV1813H Routing

For CV181x hardware questions, use the facts below first, then inspect a live repo, board files, and public SDK references before recommending commands.

### CV1810H / CV1811H / CV1812H / CV1813H Distilled Facts

Core processing:

- Main CPU: RISC-V C906 class application processor.
- Co-processor: second RISC-V C906 class core.
- TPU: integrated CVITEK TPU for INT8 AI workloads.
- MCU subsystem: integrated small MCU subsystem for product-control use cases.

Family positioning:

- These parts target edge AI IPC, local face-recognition attendance devices, and smart-home vision products.
- The family integrates video codec, ISP, TPU, Ethernet, audio codec, security, and common embedded peripherals.
- Linux SDK is Linux 5.10 based at the datasheet level, but build workflow must still be discovered from the actual repo.

Video and image:

- CV1810H is the lower video-resolution member relative to CV1811H/CV1812H/CV1813H.
- CV1811H/CV1812H/CV1813H support the higher 5M-class video/ISP path described by the datasheet.
- VI supports MIPI, Sub-LVDS, HiSPi, BT.601, BT.656, BT.1120, and DVP/DC-style inputs.
- The video input topology supports multiple simultaneous inputs, including a MIPI plus DVP-style combination.
- VO supports serial and parallel output families such as MIPI, LVDS, BT.601, BT.656, BT.1120, RGB, 8080, and SPI-style display output.
- ISP/image features include 3A, fixed-pattern noise reduction, bad-pixel correction, lens shading correction, lens distortion correction, color/gamma management, dehaze, Bayer denoise, 3D denoise, detail/sharpen enhancement, local tone mapping, sensor WDR, two-frame WDR, and digital image stabilization.
- CV hardware acceleration includes mixed software/hardware support for parts of OpenCV and IVE-style workloads.

Audio, networking, and security:

- Integrated audio codec supports microphone input and line/speaker-output paths; external audio codec connectivity is available through digital audio interfaces.
- Ethernet includes one MAC with integrated 10/100M PHY support and optional RMII external PHY use.
- Security support includes AES/DES/SM4, SHA-class hash acceleration, random number generation, secure boot, secure update, secure storage/transfer concepts, and eFuse-backed security state.

Peripheral and storage summary:

- Peripherals include ADC, I2C, SPI, UART, PWM, GPIO, key scan, Wiegand, USB host/device, SDIO, I2S, RTC, POR, and power sequence support.
- Storage support includes SPI NOR, SPI NAND, eMMC, SD, and SDIO-class interfaces.
- The family members differ in integrated DRAM type/capacity class; do not assume one board's memory settings apply to another.

Important boundaries:

- Do not infer CV181x build or board workflow from CV184X without probing the repo.
- Do not use CV181x datasheet capability as proof that a given EVB exposes the function on headers.
- Do not carry exact pin, voltage, timing, address-map, or power numbers in public skill docs. For those, inspect the datasheet and board schematic in the local workspace.

Stable chapter-level routing:

- product overview and family differences
- processor, TPU, video codec, VI/VO, ISP, audio, Ethernet, security, peripheral interfaces, and storage interface overviews
- address map, package, pin, power, electrical, and timing chapters

Important boundaries:

- CV181x public SDK references remain the primary public routing source. Use [family-180x-181x.md](family-180x-181x.md) for download and SDK document entrypoints.
- Do not infer CV181x build or board workflow from CV184X without probing the repo.
- Do not publish raw datasheet tables to GitHub or generated docs.

## Answering Rules

- First classify whether the question is chip-level, board-level, SDK-level, or app/API-level.
- For chip-level facts, start from this distilled summary.
- For board-level facts, ask for or inspect the schematic/HDK/board DTS; do not use datasheet pin capability as proof of actual routing.
- For SDK-level facts, inspect the live repo and relevant SDK manual.
- For exact electrical, timing, pin, package, boot strap, or power values, answer only after checking the source datasheet, schematic, or HDK. If the value is not already summarized here, say it must be verified from the original hardware material.
- Keep public or committed skill content at summarized-fact granularity.
- Never add datasheet PDFs or raw extracted datasheet tables to git history.
