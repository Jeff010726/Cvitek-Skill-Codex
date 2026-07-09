# Local Chip Datasheets

Use this reference when the user asks chip-level hardware questions: pin descriptions, boot mode strap pins, package and ballout, power sequencing, electrical characteristics, timing, reset, clock, eFuse silicon capabilities, or peripheral limits that are below the SDK/manual layer.

## Local-Only Source Rule

Local datasheets may exist under:

```text
/home/jeff/projects/cvitek-skill/.datasheet/
```

These PDFs are source material only. Do not commit them, copy their tables into this repository, or publish detailed extracted content. Some local files may carry confidential, customer, or no-disclosure markings even when the filename sounds public.

## What Can Be Preserved In The Skill

It is acceptable to preserve:

- which questions should route to datasheets instead of SDK manuals
- which chip family a local datasheet appears to cover
- high-level module routing, such as boot, power, pin, package, clock, reset, and peripheral chapters
- safety rules that require checking exact values in the local PDF

It is not acceptable to preserve:

- full datasheet PDFs
- extracted pin tables, register maps, memory maps, electrical tables, timing tables, or power-consumption tables
- customer-marked text or confidential watermarks
- long verbatim passages
- exact strap, voltage, timing, or package values unless the user specifically needs them and the answer remains local to the conversation

## Known Local Datasheet Coverage

The current local `.datasheet/` directory has been observed to contain datasheets covering:

- `CV1842H-P` and `CV1843H-P`
- `CV1810H`, `CV1811H`, `CV1812H`, and `CV1813H`

Treat this as a local workspace fact, not a public download catalog. If the exact filename or version matters, list `.datasheet/` locally and inspect the matching PDF.

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

For CV1842H-P or CV1843H-P hardware questions, inspect the local datasheet first for the relevant chapter, then cross-check board files or schematics before suggesting an implementation.

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
- Electrical values must come from the local PDF and board design review, not from memory.
- Secure boot requires both silicon capability and SDK image/eFuse flow; also load [cv184x-system-burning-security.md](cv184x-system-burning-security.md).

## CV1810H, CV1811H, CV1812H, And CV1813H Routing

For CV181x hardware questions, use the local datasheet only as a private verification source. Do not publish its detailed contents in committed skill files.

Stable chapter-level routing:

- product overview and family differences
- processor, TPU, video codec, VI/VO, ISP, audio, Ethernet, security, peripheral interfaces, and storage interface overviews
- address map, package, pin, power, electrical, and timing chapters

Important boundaries:

- CV181x public SDK references remain the primary public routing source. Use [family-180x-181x.md](family-180x-181x.md) for download and SDK document entrypoints.
- Do not infer CV181x build or board workflow from CV184X without probing the repo.
- Do not publish local confidential datasheet details to GitHub or generated docs.

## Answering Rules

- First classify whether the question is chip-level, board-level, SDK-level, or app/API-level.
- For chip-level facts, inspect the local datasheet in `.datasheet/`.
- For board-level facts, ask for or inspect the schematic/HDK/board DTS; do not use datasheet pin capability as proof of actual routing.
- For SDK-level facts, inspect the live repo and relevant SDK manual.
- For exact electrical, timing, pin, boot strap, or power values, answer only after checking the PDF page and say that the value is from the local datasheet.
- Keep public or committed skill content at routing-rule granularity.
- Never add `.datasheet/` or PDF originals to git history.
