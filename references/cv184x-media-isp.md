# CV184X Media, ISP, Sensor, Display, And TDL

Use this reference for CV184X MPI media pipelines, sensor bring-up, MIPI, ISP, PQ tuning, display, graphics, VENC, LDC, and TDL C API.

## Document Routing

- MPI pipeline and module API: `MediaProcessingSoftwareDevelopmentReference_zh.pdf`
- TDL C API: `c_interface_zh.pdf`
- ISP and 3A API: `ISPDevelopmentReference_zh.pdf`
- Image-quality tuning flow: `ISPTuningGuide_zh.pdf`
- PC-side tuning tool: `PQToolsUserGuide_zh.pdf`
- Sensor bring-up: `Sensor_Debugging_Guide_zh.pdf`
- MIPI RX/TX: `MIPIUserGuide_zh.pdf`
- LDC debugging: `LDCDebuggingGuide_zh.pdf`
- Screen integration: `ScreenDockingGuide_zh.pdf`
- Graphics framebuffer: `GFBGDevelopmentGuide_zh.pdf`
- 2D engine: `TDEUserGuide_zh.pdf`
- VENC smart coding: `SmartCodingUserGuide_zh.pdf`
- VENC rate control: `BitRateControlApplicationNotes_zh.pdf`

## MPI Media Pipeline

The media reference covers these modules:

- `SYS`, `VB`, and `LOG`
- `VI`
- `VO`
- `VPSS`
- `VENC`
- `VDEC`
- `RGN`
- audio `AI`, `AO`, `AENC`, `ADEC`, VQE, and resampler
- `GDC` and LDC
- per-module proc debug information

Core API families:

- `CVI_SYS_*`
- `CVI_VB_*`
- `CVI_VI_*`
- `CVI_VO_*`
- `CVI_VPSS_*`
- `CVI_VENC_*`
- `CVI_VDEC_*`
- `CVI_RGN_*`
- `CVI_AI_*`, `CVI_AO_*`, `CVI_AENC_*`, `CVI_ADEC_*`
- `CVI_GDC_*`

Pipeline rule:

1. Configure VB pools.
2. Initialize system with `CVI_SYS_Init`.
3. Bring up sensor, MIPI, and VI.
4. Start ISP and 3A as required by the chosen sample or app.
5. Configure VPSS.
6. Bind to consumers such as VENC, VO, TDL, GDC, or RGN.
7. Tear down in reverse order and release VB/SYS resources.

Typical chains:

- `VI -> VPSS -> VENC`
- `VI -> VPSS -> VO`
- `VI/VPSS -> GDC/LDC`
- `VPSS frame -> TDL`

Do not skip `VB + SYS` initialization when proposing an MPI sequence.

## Sensor Bring-Up

Relevant manual: `Sensor_Debugging_Guide_zh.pdf`.

Bring-up order:

1. Confirm SoC, sensor, lens, raw bit depth, resolution, fps, WDR mode, MIPI lane count, lane order, PN swap, clock, crop, reset GPIO, and I2C address.
2. Prepare sensor driver and init sequence.
3. Add the sensor type and sensor object to the SDK's sensor configuration code.
4. Adapt Linux sample common or AliOS media initialization.
5. Add sensor ini/cfg as required by the selected flow.
6. Build and run `sensor_test` or the closest repo sample.
7. Verify RAW/YUV output before PQ tuning.
8. Add ISP basics, AE, AWB, FPS control, flip/mirror, WDR/linear switch, and shutdown/sync handling.

Common paths and names seen in the manuals:

- `sample_common_vi.c`
- `components/cvi_platform/media/src/media_video.c`
- `build/media/cvi_sensor/sensor_cfg/sensor_cfg.h`
- `sensor_cfg.c`
- `SNS_TYPE_E`
- sensor init and default-register functions in the sensor driver

Debug order:

- I2C write fail: power, reset, I2C bus, I2C slave address, address/data width, and timeout.
- Decode/ECC/CRC/word-count errors: lane order, PN swap, data type, MIPI frequency, and signal quality.
- `vi_select timeout`: check sensor output, MIPI RX proc, VI size/crop, WDR VC, and whether frames are reaching VI.

## MIPI

Relevant manuals:

- `MIPIUserGuide_zh.pdf`
- `Sensor_Debugging_Guide_zh.pdf`

MIPI RX ioctl families:

- `CVI_MIPI_SET_HS_MODE`
- `CVI_MIPI_SET_DEV_ATTR`
- `CVI_MIPI_RESET_SENSOR`
- `CVI_MIPI_UNRESET_SENSOR`
- `CVI_MIPI_RESET_MIPI`
- `CVI_MIPI_ENABLE_SENSOR_CLOCK`
- `CVI_MIPI_DISABLE_SENSOR_CLOCK`
- `CVI_MIPI_SET_CROP_TOP`
- `CVI_MIPI_SET_WDR_MANUAL`
- `CVI_MIPI_SET_LVDS_FP_VS`

MIPI TX APIs:

- `mipi_tx_cfg`
- `mipi_tx_send_cmd`
- `mipi_tx_recv_cmd`
- `mipi_tx_enable`
- `mipi_tx_disable`
- `mipi_tx_set_hs_settle`
- `mipi_tx_get_hs_settle`
- `mipi_tx_suspend`
- `mipi_tx_resume`

Important rules:

- Enable sensor clock and handle sensor reset/unreset before expecting image output.
- Configure MIPI device attributes, lane id, PN swap, HS settle, raw data type, WDR VC, and crop consistently with the sensor.
- MIPI lane id maps sensor clock/data lanes to MIPI RX physical pads. Do not assume lane order from schematic labels without checking the manual and board DTS/config.
- The manual gives the relationship between VI MAC frequency, pixel width, lane count, and MIPI lane frequency. Recalculate before changing clocks.
- Use `/proc/mipi-rx` on Linux or the AliOS proc equivalent when debugging RX state.

## ISP And PQ

Relevant manuals:

- `ISPDevelopmentReference_zh.pdf`
- `ISPTuningGuide_zh.pdf`
- `PQToolsUserGuide_zh.pdf`

ISP API groups include:

- system control: `CVI_ISP_MemInit`, `CVI_ISP_Init`, `CVI_ISP_Run`, `CVI_ISP_RunOnce`, `CVI_ISP_Exit`
- public attributes and module control: `CVI_ISP_SetPubAttr`, `CVI_ISP_GetPubAttr`, `CVI_ISP_SetModuleControl`
- sensor and 3A callbacks: `CVI_ISP_SensorRegCallBack`, `CVI_ISP_AELibRegCallBack`, `CVI_ISP_AWBLibRegCallBack`, `CVI_ISP_AFLibRegCallBack`
- bin API: `CVI_BIN_SetBinName`, `CVI_BIN_GetBinName`, `CVI_BIN_ExportBinData`, `CVI_BIN_ImportBinData`, `CVI_BIN_SaveParamToBin`, `CVI_BIN_LoadParamFromBin`
- modules: BLC, DPC, LSC, RLSC, CCM, NoiseProfile, BNR, CNR, TNR, Crosstalk, Demosaic, Sharpen, Gamma, DCI, LDCI, FSHDR, DRC, CLUT, CSC, VC, stats, and debug

Tuning sequence:

1. Finish sensor RAW/YUV output first.
2. Establish basic AE stability.
3. Calibrate black level, LSC, AWB, and noise profile as needed.
4. For linear mode, tune brightness, color, contrast, sharpness, and noise.
5. For WDR mode, also handle merge-region motion tailing, dynamic range, and night strong-light suppression.
6. Use PQ Tools for online parameter read/write, curves, Raw/YUV capture, 3A analysis, focus helper, bracket exposure, continuous Raw, and bin import/export.
7. Persist parameters through bin export/import or `CVI_BIN_*`; do not assume online changes are permanently stored.

Known path fragment from the tools manual:

- `/mnt/data/bin/cvi_sdr_bin`

Rules:

- Do not tune ISP before MIPI and sensor output are correct.
- Separate linear and WDR tuning plans.
- Do not present PQ Tools online edits as final firmware changes unless a bin persistence step is included.

## LDC And GDC

Relevant manuals:

- `LDCDebuggingGuide_zh.pdf`
- `MediaProcessingSoftwareDevelopmentReference_zh.pdf`

LDC can appear through:

- VI or VPSS channel LDC attributes for realtime channel correction
- GDC mesh or job-style processing for generated/loaded correction meshes

Before giving instructions, clarify whether the task is realtime pipeline correction or offline/job-style mesh processing.

The LDC debugging manual discusses FOV, barrel correction, pincushion correction, data flow, and calibration tools.

## Display, Panels, GFBG, And TDE

Relevant manuals:

- `ScreenDockingGuide_zh.pdf`
- `StartupScreenUserGuide_zh.pdf`
- `GFBGDevelopmentGuide_zh.pdf`
- `TDEUserGuide_zh.pdf`

Panel integration layers:

- U-Boot panel and logo path
- Linux kernel panel path
- dual-system or AliOS panel path

For MIPI DSI and LVDS panels, check:

- hardware wiring
- MIPI TX or LVDS attributes
- panel init sequence
- header references
- reset, power, and backlight GPIO/PWM
- U-Boot environment variables
- logo image format and packaging
- build and burning verification

GFBG is a Linux framebuffer workflow:

- `open`
- `mmap`
- framebuffer ioctls
- refresh/pan/show/color-key operations

Common GFBG ioctls include:

- `FBIOGET_VSCREENINFO`
- `FBIOPUT_VSCREENINFO`
- `FBIOGET_FSCREENINFO`
- `FBIOPAN_DISPLAY`
- `FBIOGET_SHOW_GFBG`
- `FBIOPUT_SHOW_GFBG`
- `FBIOGET_COLORKEY_GFBG`
- `FBIOPUT_COLORKEY_GFBG`
- `FBIOGET_CANVAS_BUF`
- `FBIO_REFRESH`

TDE is a 2D engine job workflow:

- `CVI_TDE_Open`
- `CVI_TDE_BeginJob`
- `CVI_TDE_Rotate`
- `CVI_TDE_DrawLine`
- `CVI_TDE_QuickCopy`
- `CVI_TDE_EndJob`
- `CVI_TDE_WaitAllDone`
- `CVI_TDE_CancelJob`
- `CVI_TDE_Close`

Do not use GFBG ioctl guidance for TDE jobs, or TDE guidance for VO/panel setup.

## VENC, Smart Coding, And Rate Control

Relevant manuals:

- `SmartCodingUserGuide_zh.pdf`
- `BitRateControlApplicationNotes_zh.pdf`
- VENC chapter in `MediaProcessingSoftwareDevelopmentReference_zh.pdf`

Smart coding topics:

- `NormalP`
- `SmartP`
- ROI
- SVC

Smart coding APIs:

- `CVI_VENC_SetRoiAttr`
- `CVI_VENC_GetRoiAttr`
- `CVI_VENC_EnableSvc`
- `CVI_VENC_SetSvcParam`
- `CVI_VENC_GetSvcParam`

Rate-control topics:

- CBR, VBR, and AVBR
- macroblock-level rate control
- frame dropping when bitrate is too high
- GOP structure
- bitrate stability
- image quality
- breathing effect
- I-frame amplitude
- motion smear
- chroma shift
- start QP
- low-bitrate scenes

Rule:

When diagnosing VENC quality or bitrate, inspect GOP, fps, `u32StatTime`, RC mode, target bitrate, QP bounds, I-frame limits, and frame-loss strategy. Do not change only target bitrate.

## TDL C API

Relevant manual: `c_interface_zh.pdf`.

TDL areas:

- model lists for detection, face, attribute, classification, audio classification, keypoint, lane, plate, segmentation, feature extraction
- structures such as `TDLObject`, `TDLFace`, `TDLClass`, `TDLKeypoint`, `TDLInstanceSeg`, `TDLLane`, `TDLTracker`, and `TDLOcr`
- image and VPSS frame wrapping
- model open/close
- detection, face detection, face attribute, landmark, classification, keypoint, segmentation, feature extraction, lane, stereo depth, tracking, OCR
- app helpers for capture and object counting

Representative APIs:

- `TDL_CreateHandle`
- `TDL_DestroyHandle`
- `TDL_WrapVPSSFrame`
- `TDL_ReadImage`
- `TDL_OpenModel`
- `TDL_CloseModel`
- `TDL_Detection`
- `TDL_FaceDetection`
- `TDL_Classfification`
- `TDL_KeypointDetection`
- `TDL_InstanceSegmentation`
- `TDL_FeatureExtraction`
- `TDL_Tracking`
- `TDL_APP_Init`
- `TDL_APP_SetFrame`
- `TDL_APP_Capture`
- `TDL_APP_ObjectCounting`

TDL usually consumes image buffers or VPSS frames, so check the media pipeline and buffer lifetime before focusing only on model API calls.

## Media-Specific Avoid List

- Do not classify every no-image problem as ISP. First locate sensor, MIPI, VI, ISP, VPSS, VO, or VENC.
- Do not start an MPI answer at `VI_Enable` or `VENC_CreateChn` without `VB + SYS`.
- Do not tune PQ before RAW/YUV output is proven.
- Do not confuse U-Boot panel logo, Linux VO, GFBG overlay, and TDE blit.
- Do not assume LDC has only one entrypoint.
- Do not hardcode board or sensor names; use live repo files and `defconfig` discovery.
