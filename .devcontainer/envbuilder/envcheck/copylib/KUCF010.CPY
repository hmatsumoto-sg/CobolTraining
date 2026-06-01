000010******************************************************************
000020*    KUCF010 : îÑè„ÉtÉ@ÉCÉã                      LRECL=100
000030******************************************************************
000040     03  UF010-DATA-KBN              PIC  X(01).
000050     03  UF010-TOKU-COD              PIC  X(04).
000060     03  UF010-JUCHU-DATE.
000070       05  UF010-JUCHU-YY            PIC  9(04).
000080       05  UF010-JUCHU-MM            PIC  9(02).
000090       05  UF010-JUCHU-DD            PIC  9(02).
000100     03  UF010-JUCHU-NO              PIC  9(04).
000110     03  UF010-SHOHIN-NO             PIC  X(05).
000120     03  UF010-TOKU-MEI              PIC  X(20).
000130     03  UF010-SHOHIN-MEI            PIC  X(20).
000140     03  UF010-TANKA                 PIC S9(05)V9(2)
000150                                                PACKED-DECIMAL.
000160     03  UF010-SURYO                 PIC S9(05) PACKED-DECIMAL.
000170     03  UF010-KINGAKU               PIC S9(09) PACKED-DECIMAL.
000180     03  FILLER                      PIC  X(26).
