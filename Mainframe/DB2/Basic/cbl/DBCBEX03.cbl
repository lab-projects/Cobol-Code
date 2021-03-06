      **********************************************************
      * Program name:    DBCBEX03
      * Original author: David Stagowski
      *
      *    Description: Example 03: DB2 Processing: Read one record.
      *
      *    This program will read and display 1 record from a DB2 Table.
      *
      *    There are some differences between the GnuCOBOL and
      *       ZOS DB2 programs.
      *
      *    The biggest difference is the 9800-Connect-to-DB1 paragraph.
      *
      *    On ZOS, the JCL makes the connection so there is no need for
      *       passing the username and password for the database.
      *
      *    That is required with GnuCOBOL.
      *    These GnuCOBOL programs use GETDBID, a very simple called
      *    module that has the username and password embedded in it.
      *    When called, it passes them up to the calling program which
      *    then uses them to make the connection to the server.
      *
      *
      * Maintenance Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-29 dastagg       Created to learn.
      * 20XX-XX-XX               If you change me, change this.
      *
      **********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DBCBEX03.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER.   IBM WITH DEBUGGING MODE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

           EXEC SQL DECLARE EMPLOYEE TABLE
           ( EMPNO                          CHAR(6) NOT NULL,
             FIRSTNME                       VARCHAR(12) NOT NULL,
             MIDINIT                        CHAR(1),
             LASTNAME                       VARCHAR(15) NOT NULL,
             WORKDEPT                       CHAR(3),
             PHONENO                        CHAR(4),
             HIREDATE                       DATE,
             JOB                            CHAR(8),
             EDLEVEL                        SMALLINT,
             SEX                            CHAR(1),
             BIRTHDATE                      DATE,
             SALARY                         DECIMAL(9, 2),
             BONUS                          DECIMAL(9, 2),
             COMM                           DECIMAL(9, 2)
           )
           END-EXEC.

       01  HV-Employee-Row.
           12 HV-Emp-Number           PIC X(06).
           12 HV-First-Name           PIC X(12).
           12 HV-Middle-Init          PIC X(01).
           12 HV-Last-Name            PIC X(15).
           12 HV-Work-Dept            PIC X(03).
           12 HV-Phone-Number         PIC X(04).
           12 HV-Hire-Date            PIC X(10).
           12 HV-Job-Title            PIC X(08).
           12 HV-Edu-Level            PIC S9(04) COMP-5.
           12 HV-Gender               PIC X(01).
           12 HV-Birth-Date           PIC x(10).
           12 HV-Salary               PIC S9(7)V99 COMP-3.
           12 HV-Bonus                PIC S9(7)V99 COMP-3.
           12 HV-Commission           PIC S9(7)V99 COMP-3.

       01 WS-SQL-STATUS                PIC S9(9) COMP-5.
          88 SQL-STATUS-OK             VALUE    0.
          88 SQL-STATUS-NOT-FOUND      VALUE  100.
          88 SQL-STATUS-DUP            VALUE -803.

       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program DCBCEX03 - End of Run Messages".

       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
           SET SQL-STATUS-OK TO TRUE.

       2000-Process.
           IF SQL-STATUS-OK
              PERFORM 2100-Process-Data
           END-IF.

       2100-Process-Data.
           PERFORM 5000-Read-DB1.

           IF SQL-STATUS-OK
              DISPLAY "It worked!"
              DISPLAY "Data: " HV-Employee-Row
           END-IF.

       3000-End-Job.
           EXEC SQL CONNECT RESET END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.
           DISPLAY EOJ-End-Message.
           DISPLAY "SQLCODE at 3000-End-Job: " SQLCODE.

       5000-Read-DB1.
           MOVE '000010' TO HV-Emp-Number.
           EXEC SQL
              SELECT
                     EMPNO, FIRSTNME,
                     MIDINIT, LASTNAME
              INTO
                     :HV-Emp-Number, :HV-First-Name,
                     :HV-Middle-Init, :HV-Last-Name
              FROM EMPLOYEE
              WHERE EMPNO = :HV-Emp-Number
           END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.
           IF SQL-STATUS-OK
              NEXT SENTENCE
           ELSE
              DISPLAY "*** WARNING ***"
              DISPLAY "There was a problem Selecting the record."
              DISPLAY "SQLCODE = " SQLCODE
              PERFORM 3000-End-Job
              MOVE 8 TO RETURN-CODE
              GOBACK
           END-IF.

