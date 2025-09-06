# SaeyahnTracker module file format

- This aims to document the binary module file format of SaeyahnTracker DEV VERSION.
- This document must have all format differences between the versions.

Unless otherwise mentioned, all byte orders are big-endian.

Unless otherwise mentioned, the order for the blocks literally follows the list below. 

Undefined bytes should be filled with `0x00`.

`Data length` is in byte.

## File Header

|Type|Index after `0x0000`|Data length|Variable in code|Description|Notes|
|:---:|:---:|:---:|:-----:|--------|--------|
|`char[]`|`0x0000`|4|*None*|Magic number|Is always `SYTM`, `0x53 0x59 0x54 0x4D`|
|`unsigned short`|`0x0004`|2|`SY_MODULE_FORMAT_VER`|Module format version|*None*|
|`unsigned char`|`0x0006`|1|`SYMODULE_ROWS`|The amount of the rows of the module|*None*|
|`unsigned char`|`0x0007`|1|`SYMODULE_TEMPO`|The tempo of the module|*None*|
|`unsigned short`|`0x0008`|2|`SYMODULE_HIGHLIGHT`|The length of `SYMODULE_FRAME`, The highlight position of the module|`LLLL LLLL LHHH HHH`, L = The length of `SYMODULE_FRAME`; H = The highlight position of the module|
|`unsigned char`|`0x000A`|1|`SAMPLE_COUNTER`|The amount of the samples that the module contains|*None*|
|`char[]`|`0x0010`|32|`SYMODULE_SONGTITLE`|The title of the module|*None*|
|`char[]`|`0x0030`|32|`SYMODULE_SONGAUTHOR`|The author of the module|*None*|
|`char[]`|`0x0050`|*Varies*|`SYMODULE_FRAME`|Frames|The length of the string is set by the header value described above|

## Frames
	
The data string that is stored from `0x0050` is a small string fragment listing the pattern IDs, is formatted in ASCII format.

They are separated by `;`, each item represents one frame.

The `;` should be attached at the end of the frame too.

## Patterns

The pattern data block serves as the core of the sequencer, storing all note, sample id, and effects and their parameters.

Each row is exactly 73 ASCII bytes long, representing the row data for 6 channels followed by a row delimiter.

A row consists of 6 channels, laid out contiguously without any delimiters between them.

A semicolon (;) character acts as a mandatory delimiter at the end of each row, including the final row in the sequence.

A single row is structured as follows:

`[Pattern ID] + [Channel 1 Data] + [Channel 2 Data] + ... + [Channel 6 Data] + ;`

A pattern ID, expressed as a single-byte binary number, is present at the beginning of each pattern. Channel data is then stored.

Each of the six channels uses an identical, fixed-width format of 12 ASCII bytes. The byte values are not raw binary, but rather ASCII representations of the intended numbers or characters.

The format for a single channel is `NNNSSVA12B34`:

- `NNN` (3 bytes): Represents the note. This is a standard three-character note notation, such as `C#3`, `D-5`, or `F-1`.

- `SS` (2 bytes): Represents the instrument number. This is a two-character number encoded in ASCII. For example, the number `42` is stored as the ASCII bytes for `0x34 0x32`, not the single hexadecimal byte `0x2A`.

- `V` (1 byte): The volume for the note.

- `A` (1 byte): The first note effect.

- `12` (2 bytes): The two-digit parameter for the effect `A`.

- `B` (1 byte): The second note effect.

- `34` (2 bytes): The two-digit parameter for the B effect `B`.

This structured format ensures that the data can be parsed predictably and consistently, regardless of the song's complexity.