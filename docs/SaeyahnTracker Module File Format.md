# SaeyahnTracker module file format

- This aims to document the binary module file format of SaeyahnTracker DEV VERSION.
- This document must have all format differences between the versions.

Unless otherwise noted, all byte orders are big-endian.

Undefined bytes should be filled with `0x00`.

`Data length` is in byte.

## File Header

|Type|Index|Data length|Variable in code|Description|Notes|
|:---:|:---:|:---:|:-----:|--------|--------|
|`char[]`|`0x0000`|4|*None*|Magic number|Is always `SYTM`, `0x53 0x59 0x54 0x4D`|
|`unsigned short`|`0x0004`|2|`SY_MODULE_FORMAT_VER`|Module format version|*None*|
|`unsigned char`|`0x0006`|1|`SYMODULE_TEMPO`|The tempo of the module|*None*|
|`unsigned char`|`0x0007`|1|`SYMODULE_ROWS`|The amount of the rows of the module|*None*|
|`unsigned char`|`0x0008`|1|`SYMODULE_HIGHLIGHT`|The highlight position of the module|*None*|
|`char[]`|`0x0010`|32|`SYMODULE_SONGTITLE`|The title of the module|Is in the standard ASCII format|
|`char[]`|`0x0030`|32|`SYMODULE_SONGAUTHOR`|The author of the module|Is in the standard ASCII format|