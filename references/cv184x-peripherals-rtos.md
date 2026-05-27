# CV184X Peripherals, RTOS, Communication, And Crypto

Use this reference for CV184X Ethernet, USB, SD/MMC, I2C, SPI, GPIO, UART, watchdog, PWM, ADC, pinmux, DMA, thermal policy, Wi-Fi, RTC, audio quality, RT-Thread, AliOS, IPCM, and CIPHER.

## Driver Bring-Up Pattern

For peripheral questions, check four layers before proposing code changes:

1. SDK board config or kernel defconfig.
2. DTS node status and properties.
3. Pinmux or board-level U-Boot init.
4. Runtime device nodes, proc files, sysfs, or kernel logs.

Common board paths:

- `build/boards/cv184x/<board>/linux/*_defconfig`
- `build/boards/cv184x/<board>/dts_arm/*.dts`
- `build/boards/default/dts/cv184x/cv184x_base.dtsi`
- `build/boards/cv184x/<board>/u-boot/cvi_board_init.c`
- `u-boot-2021.10/board/cvitek/cv184x/board.c`

Runtime helpers and nodes:

- `cvi_pinmux -p`
- `cvi_pinmux -l`
- `cvi_pinmux -r <pin>`
- `cvi_pinmux -w <pin>/<func>`
- `/proc/cviusb/otg_role`
- `/etc/run_usb.sh`
- `/sys/class/gpio`
- `/sys/class/pwm`
- `/sys/bus/iio/devices/iio:device0/in_voltageN_raw`
- `/dev/i2c-*`
- `/dev/spidev*`
- `/dev/watchdog`
- `/dev/dma_memcpy`

## Peripheral Driver Manual

Relevant manual: `PeripheralDriver_zh.pdf`.

Covered modules:

- Ethernet
- USB Host and Device
- SD/MMC
- I2C
- SPI
- GPIO
- UART
- Watchdog
- PWM
- ADC
- CVI pinmux
- DMA
- thermal policy and tests

Config examples seen in the manual include:

- `CONFIG_I2C_CHARDEV`
- `CONFIG_I2C_GPIO`
- `CONFIG_SPI_SPIDEV`
- `CONFIG_SPI_DW_DMA`
- `CONFIG_WATCHDOG`
- `CONFIG_PWM`
- USB-related `CONFIG_USB_*`

USB rules:

- Decide Host or Device first.
- For Host, check U-Boot `usb start`, `usb tree`, Linux `dmesg`, and storage nodes such as `/dev/sdX`.
- For Device modes, confirm OTG role and switch GPIO, then use `/etc/run_usb.sh` flows such as `probe msc|acm|adb|rndis` and `start`.
- Do not assume USB defaults to Device mode.

I2C rules:

- Enable I2C character device support.
- Verify pinmux for SCL and SDA.
- Use `i2c-tools` for user-space validation where available.
- For GPIO-based I2C, check DTS and pinmux separately.
- I2C recovery has its own DTS/config path; do not treat it as normal transfer code.

SPI rules:

- Confirm SPI controller mode and `spidev`.
- Confirm DMA settings only if DMA is required.
- Check DTS `status = "okay"`, pinmux, and `spi-max-frequency`.
- The manual notes platform frequency constraints; do not exceed them without checking the chip and board.

GPIO rules:

- Calculate sysfs GPIO number from the documented group base plus offset.
- Prefer libgpiod or the repo's current GPIO interface if the SDK has moved away from legacy sysfs; otherwise follow the manual.

UART rules:

- Enable the UART node in DTS.
- Check DMA only if high-speed or DMA mode is required.
- Verify pinmux and baud-rate needs.

Watchdog rules:

- Use `/dev/watchdog` and standard watchdog ioctls such as timeout, keepalive, get timeout, and get time-left.
- Do not open the watchdog casually on a board you cannot reset.

## Wi-Fi

Relevant manual: `Wi-FiUserGuide_zh.pdf`.

Scope:

- SDIO Wi-Fi
- RTL8189FS flow
- STA mode
- SoftAP mode
- NAT through Ethernet
- throughput testing

Config and DTS items:

- `CONFIG_CVI_WIFI_PIN`
- `CONFIG_CP_EXT_WIRELESS`
- `CONFIG_WIRELESS`
- `CONFIG_WLAN_VENDOR_REALTEK`
- `CONFIG_RTL8189FS=m`
- `CONFIG_CFG80211*`
- `CONFIG_TARGET_PACKAGE_WIFI`
- `wifi-sd@4320000`
- `wifi_pin`
- `poweron-gpio`

Common commands:

```sh
insmod 8189fs.ko
ifconfig wlan0 up
wpa_supplicant -i wlan0 -D nl80211 -c <config>
wpa_cli
udhcpc -i wlan0
hostapd <config>
udhcpd <config>
iptables -t nat ... MASQUERADE
```

Rules:

- Do not assume the Wi-Fi driver is built in. The manual explicitly shows module-style RTL8189FS usage.
- Do not delete or leave deleted the `wifi-sd@4320000` node when SDIO Wi-Fi is expected.
- Validate `wlan0` existence before debugging AP credentials.

## RTC

Relevant manual: `RTCApplicationGuide_zh.pdf`.

Runtime surface:

- `/dev/rtc0`
- `date`
- `hwclock -w`
- `hwclock -s`
- `ioctl(fd, RTC_RD_TIME)`
- `ioctl(fd, RTC_SET_TIME)`
- `ioctl(fd, RTC_ALM_SET)`
- `ioctl(fd, RTC_AIE_ON)`

DTS rules:

- RTC can be removed with a board DTS override such as `/delete-node/ rtc;` when the product does not need it.
- Check the actual SoC include and board DTS before editing.

Time-structure rule:

- `struct rtc_time.tm_year` is `year - 1900`.
- `struct rtc_time.tm_mon` is zero-based.

RTC auto-restart:

- The manual describes locating `auto_restart_after` under `/sys/devices` and writing a timeout value.
- Use the live sysfs path from the board.

## Audio Quality And VQE

Relevant manual: `AudioQualityTuningGuide_zh.pdf`.

Covered functions:

- AEC/AES
- NR/ANR
- AGC
- notch filter
- digital gain
- delay
- equalizer

Representative structures and fields:

- `AI_TALKVQE_CONFIG_S`
- `AI_AEC_CONFIG_S`
- `AUDIO_ANR_CONFIG_S`
- `AUDIO_AGC_CONFIG_S`
- `AUDIO_DELAY_CONFIG_S`
- `u32OpenMask`
- `LP_AEC_ENABLE`
- `NLP_AES_ENABLE`
- `NR_ENABLE`
- `AGC_ENABLE`
- `DCREMOVER_ENABLE`
- `DG_ENABLE`
- `DELAY_ENABLE`
- `AI_TALKVQE_MASK_*`

Rules:

- Check sample rate and channel assumptions before tuning.
- Keep capture/playback delay and echo path physical layout in the diagnosis.
- Do not solve echo or noise issues by one gain knob only.

## RT-Thread

Relevant manual: `RT-Thread_Compilation_and_Usage_Instructions_zh.pdf`.

Build environment:

```sh
pip3 install pyserial pyusb pyyaml
sudo apt-get install scons
```

Typical build flow:

```sh
source build/envsetup_soc.sh
defconfig cv184x
defconfig <board>
menuconfig_rtt
build_uboot
```

Artifacts:

- `install/soc_<board>/yoc.bin`
- `bsp/cvitek/c906_little/rtthread.elf`
- `bsp/cvitek/c906_little/rtthread.bin`
- `bsp/cvitek/c906_little/rtthread.map`

MSH command families:

- `help`
- `reboot`
- `clear`
- `devmem`
- `dumpmem`
- `free`
- `ps`
- `list`
- `backtrace`
- filesystem commands such as `ls`, `cd`, `cat`, `mkdir`, `rm`, `cp`, `mv`, `df`, `mount`, `umount`, `mkfs`
- `pin`
- `single_core_cache`

Rules:

- `yoc.bin` is a dual-system artifact; do not assume it exists for every board config.
- Do not mix RT-Thread MSH commands with Linux shell commands.

## AliOS

Relevant manual: `AliOS_Compilation_and_Usage_Instructions_zh.pdf`.

Build environment:

```sh
pip3 install pyserial pyusb pyyaml
sudo pip install yoctools -U
yoc -V
```

Typical build flow:

```sh
source build/envsetup_soc.sh
defconfig <board>
menuconfig
build_uboot
```

Important paths:

- `cvi_alios/solutions/normboot`
- `custom_sysparam.c`
- `custom_viparam.c`
- `custom_platform.c`
- `package.yaml`

CLI command families:

- system: `help`, `reboot`, `ccs`, `sysver`, `time`, `msleep`, `devname`, `err2cli`
- media proc: `proc_vb`, `proc_sys`, `proc_vi_dbg`, `proc_vi`, `proc_gdc`, `proc_mipi_rx`, `proc_vo`, `proc_rgn`, `proc_codec`, `proc_vdec`, `proc_rc`, `proc_jpege`, `proc_h264e`, `proc_h265e`, `proc_venc`, `proc_log`
- IPCM: `ipcm_dbg`, `pool_info`, `log0_on`, `log0_off`, `logall_on`, `logall_off`
- tasks and CPU: `tasklist`, `taskbt`, `taskbtn`, `cpuusage`
- memory/debug: `p`, `m`, `ddumpsys`, `dumpsys mm`, `mmlk`, `debug`

Rules:

- Do not mix AliOS CLI with RT-Thread MSH or Linux shell.
- For dual-system media issues, check IPCM and boot-state commands before assuming the Linux side failed.

## IPCM

Relevant manual: `IPCM_Customized_Communication_Introduction_zh.pdf`.

API groups:

- lifecycle: `CVI_IPCM_Init`, `CVI_IPCM_Uninit`
- cache/data: `CVI_IPCM_InvData`, `CVI_IPCM_FlushData`
- buffer locking: `CVI_IPCM_DataLock`, `CVI_IPCM_DataUnlock`
- buffer access: `CVI_IPCM_GetBuff`, `CVI_IPCM_ReleaseBuff`, `CVI_IPCM_GetUserAddr`
- parameter buffers: `CVI_IPCM_GetParamBinAddr`, `CVI_IPCM_GetParamBakBinAddr`, `CVI_IPCM_GetPQBinAddr`
- custom ports: `CVI_IPCM_CustInit`, `CVI_IPCM_CustUninit`, `CVI_IPCM_CustPoolReset`
- callbacks: `CVI_IPCM_RegisterCustHandle`, `CVI_IPCM_DeregisterCustHandle`
- messaging: `CVI_IPCM_CustSendMsg`, `CVI_IPCM_CustSendParam`
- RTOS state: `CVI_IPCM_SetRtosSysBootStat`, `CVI_IPCM_ClrRtosSysBootStat`, `CVI_IPCM_GetRtosBootStat`, `CVI_IPCM_GetRtosIpcmStat`
- boot logo state: `CVI_IPCM_SetRtosBootLogoStat`, `CVI_IPCM_ClrRtosBootLogoStat`, `CVI_IPCM_GetRtosBootLogoStat`

Types:

- `IPCM_MSG_TYPE_E`
- `IPCM_CUST_SHM_DATA_S`
- `IPCM_CUST_MSG_S`
- `IPCM_CUST_MSGPROC_FN`

Common error codes in the manual:

- `-200` queue full
- `-201` queue empty
- `-202` memory lock issue
- `-203` busy
- `-204` null queue

Rules:

- Pair initialization and uninitialization.
- Check buffer ownership, cache maintenance, locks, addresses, and lengths before blaming transport.

## CIPHER

Relevant manual: `CIPHERAPIReference_zh.pdf`.

Covered algorithms:

- AES ECB/CBC/CTR/CCM/GCM
- DES ECB/CBC/CTR/CFB/OFB
- SM4 ECB/CBC/CTR
- RSA 1024/2048/3072/4096
- HASH SHA1/SHA2/SHA512/SM3
- HMAC
- RNG
- KLAD

Typical cipher flow:

```text
CVI_UNF_CIPHER_Init
CVI_UNF_CIPHER_CreateHandle
CVI_UNF_CIPHER_ConfigHandle or CVI_UNF_CIPHER_ConfigHandleEx
CVI_UNF_CIPHER_Encrypt or CVI_UNF_CIPHER_Decrypt
CVI_UNF_CIPHER_GetTag when using CCM/GCM
CVI_UNF_CIPHER_DestroyHandle
CVI_UNF_CIPHER_Deinit
```

Other API families:

- HASH: `CVI_UNF_CIPHER_HashInit`, `CVI_UNF_CIPHER_HashUpdate`, `CVI_UNF_CIPHER_HashFinal`
- RNG: `CVI_UNF_CIPHER_GetRandomNumber`
- RSA: `CVI_UNF_CIPHER_RsaPublicEncrypt`, `CVI_UNF_CIPHER_RsaPrivateDecrypt`, `CVI_UNF_CIPHER_RsaPublicDecrypt`, `CVI_UNF_CIPHER_RsaSign`, `CVI_UNF_CIPHER_RsaVerify`
- KLAD: `CVI_UNF_CIPHER_KladEncryptKey`

Rules:

- Keep handle lifecycle explicit.
- For authenticated modes, include tag retrieval/verification.
- Do not confuse CIPHER API guidance with secure-boot eFuse programming.

## Avoid List

- Do not assume a peripheral problem is only a driver config issue; check DTS and pinmux.
- Do not assume USB Device mode is active by default.
- Do not assume Wi-Fi is built in; module loading may be required.
- Do not assume RTC `tm_year` and `tm_mon` are natural year/month values.
- Do not assume RT-Thread, AliOS, Linux, and U-Boot commands are interchangeable.
- Do not recommend `build_all` as the first peripheral debug step.
