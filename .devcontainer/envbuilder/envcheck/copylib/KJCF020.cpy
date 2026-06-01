000010******************************************************************
000020*    KJCF020 : 受注チェックファイル              LRECL=100
000030******************************************************************
000040     03  JF020-DATA-KBN              PIC  X(01).
000050     03  JF020-JUCHU-NO-X.
000060       05  JF020-JUCHU-NO            PIC  9(04).
000070     03  JF020-JUCHU-DATE.
000080       05  JF020-JUCHU-Y1            PIC  9(02).
000090       05  JF020-JUCHU-DATE6.
000100         07  JF020-JUCHU-Y2          PIC  9(02).
000110         07  JF020-JUCHU-MM          PIC  9(02).
000120         07  JF020-JUCHU-DD          PIC  9(02).
000130     03  JF020-TOKU-COD              PIC  X(04).
000140     03  JF020-SHOHIN-NO             PIC  X(05).
000150     03  JF020-SURYO-X.
000160       05  JF020-SURYO               PIC  9(05).
000170     03  FILLER                      PIC  X(03).
000180     03  JF020-ERR-KBN-TBL.
000190       05   JF020-ERR-KBN            PIC  X(01)
000200                                     OCCURS 10 TIMES.
000210     03  JF020-TOKU-MEI              PIC  X(20).
000220     03  JF020-SHOHIN-MEI            PIC  X(20).
000230     03  JF020-TANKA                 PIC S9(05)V9(2).
000240     03  JF020-KINGAKU               PIC S9(09).
000250     03  FILLER                      PIC  X(04).
