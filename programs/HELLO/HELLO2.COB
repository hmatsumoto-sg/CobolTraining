       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO2.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WK-NAME             PIC X(10) VALUE 'Mutti'.

       PROCEDURE DIVISION.
       MAIN-PARA.
           DISPLAY '==========================='.
           DISPLAY 'HELLO, ' WK-NAME '!'.
           DISPLAY '==========================='.
           STOP RUN.