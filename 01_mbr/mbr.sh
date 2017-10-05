#!/bin/bash
# run with `sudo bash mbr.sh`

count=0
for i in $(seq 0 3); do
  mbr_type=$(dd if=/dev/sda count=1 bs=1 skip=$((446+4+i*16)) status=none |\
       od -A x -t x1z -v |\
       head -1 |\
       cut -d' ' -f2);

  [[ "$mbr_type" == '00' ]] && continue;
  let count=count+1

  grep -oP '(?<='"$mbr_type"'h\t).*' <<E\OF
00h  Пустая запись (свободное место)
01h  FAT-12 (если это логический раздел или раздел расположен в первых 32 мегабайтах диска, иначе используется код 06h)
02h  XENIX root
03h  XENIX usr
04h  FAT-16 до 32 Мбайт (если раздел первичный, то должен находиться в первых физических 32 Мб диска, иначе используется код 06h)
05h  Расширенный раздел
06h  FAT-16B, а также FAT-16, не попадающий под условия кода 04h и FAT-12, не попадающий под условия кода 01h
07h  IFS, HPFS, NTFS, exFAT (и некоторые другие — тип определяется по содержимому загрузочной записи)
08h  AIX
09h  AIX загрузочный
0Ah  OS/2 Boot менеджер, OPUS
0Bh  FAT-32
0Ch  FAT-32X (FAT-32 с использованием LBA)
0Dh  Зарезервирован
0Eh  FAT-16X (FAT-16 с использованием LBA) (VFAT)
0Fh  Расширенный раздел LBA (то же что и 05h, с использованием LBA)[1]
10h  OPUS
11h  Скрытый FAT (аналогичен коду 01h)
12h  Compaq, Сервисный раздел
14h  Скрытый FAT (аналогичен коду 04h)
15h  Скрытый Расширенный раздел (аналогичен коду 05h)
16h  Скрытый FAT (аналогичен коду 06h)
17h  Скрытый раздел HPFS/NTFS/IFS/exFAT
18h  AST SmartSleep
19h  OFS1
1Bh  Скрытый раздел FAT-32 (см. 0Bh)
1Ch  Скрытый раздел FAT-32X (см. 0Ch)
1Eh  Скрытый раздел FAT-16X (VFAT) (см. 0Eh)
1Fh  Скрытый Расширенный раздел LBA (см. 0Fh)
20h  OFS1
21h  FSo2
22h  Расширенный раздел FS02
24h  NEC DOS
25h  Windows Mobile IMGFS
27h  Скрытый NTFS (Раздел восстановления системы)
28h  Зарезервирован для FAT-16+
29h  Зарезервирован для FAT-32+
2Ah  AFS (AthFS)
35h  JFS
38h  THEOS 3.2
39h  Plan 9
3Ah  THEOS 4
3Bh  Расширенный раздел THEOS 4
3Ch  Partition Magic, NetWare
3Dh  Скрытый раздел NetWare
40h  Venix 80286, PICK R83
41h  Старый Linux/Minix, PPC PReP Boot
42h  Старый своп Linux, SFS
43h  Старый Linux
4Ah  ALFS
4Ch  A2 (Aos)
4Dh  QNX4.x
4Eh  QNX4.x 2-я часть
4Fh  QNX4.x 3-я часть
50h  OnTrack DM (только чтение)
51h  OnTrack DM6 (чтение и запись)
52h  CP/M
53h  OnTrack DM6 Aux3
54h  OnTrack DM6 DDO
55h  EZ-Drive
56h  Golden Bow
56h  Novell VNDI
5Ch  Priam Edisk
61h  SpeedStor
62h  GNU HURD
63h  UNIX
64h  NetWare
65h  NetWare
67h  NetWare
68h  NetWare
69h  NetWare
77h  VNDI, M2FS, M2CS
78h  XOSL
7Fh  Данный код зарезервирован для исследовательских или учебных проектов
80h  MINIX (старый)
81h  MINIX
82h  Linux swap, Sun Solaris (старый)
83h  Linux
85h  Linux extended (расширенный)
86h  Раздел FAT-16 stripe-массива Windows NT
87h  Раздел NTFS/HPFS stripe-массива Windows NT
8Eh  Раздел LVM
93h  Amoeba, Скрытый Linux (старый)
94h  Amoeba BBT
94h  ISO-9660
9Eh  ForthOS
A5h  Раздел гибернации
A5h  NetBSD (старый),FreeBSD,BSD/386
A6h  OpenBSD
A7h  NeXTSTEP
A8h  Apple Darwin, Mac OS X UFS
A9h  NetBSD
AFh  Mac OS X HFS и HFS+, ShangOS
B1h  QNX6.x
B2h  QNX6.x
B3h  QNX6.x
B6h  Зеркальный master-раздел FAT-16 Windows NT
B7h  Зеркальный master-раздел NTFS/HPFS Windows NT
BEh  Solaris 8 загрузочный
BFh  Solaris
С2h  Скрытый Linux
С3h  Скрытый своп Linux
С6h  Зеркальный slave-раздел FAT-16 Windows NT
С7h  Зеркальный slave-раздел NTFS Windows NT
СDh  Дамп памяти
D8h  CP/M-86
DAh  Данные — не файловая система
DBh  CP/M-86
DDh  Скрытый дамп памяти
DEh  Dell Utility
EBh  BFS
ECh  SkyOS
EDh  Гибридный GPT
EEh  GPT
EFh  Системный раздел UEFI
F7h  EFAT, SolidState
FBh  VMFS
FCh  Своп VMFS
FEh  LANstep, PS/2 IML
FFh  XENIX BBT
EOF

done

printf "\nTotal: %s partitions\n" "$count"
