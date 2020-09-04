//**********************************************************************
//*       DSNHCOB2 - COMPILE AND LINKEDIT A COBOL PROGRAM
//*
//DSNHCOB2 PROC WSPC=500,MEM=TEMPNAME,USER=USER,
// COMPDSN='COB2.COB2COMP',
// CICSDSN='CICS410.SDFHCOB',
// DB2QUAL='DSN410',
// CICSQUAL='CICS410'
//*
//*            PRECOMPILE THE COBOL PROGRAM
//**********************************************************************
//PC      EXEC PGM=DSNHPC,PARM='HOST(COB2)',REGION=4096K
//DBRMLIB  DD  DSN=&USER..DBRMLIB.DATA(&MEM),DISP=SHR
//STEPLIB  DD  DSN=&DB2QUAL..DSNEXIT,DISP=SHR
//         DD  DSN=&DB2QUAL..DSNLOAD,DISP=SHR
//SYSCIN   DD  DSN=&&DSNHOUT,DISP=(MOD,PASS),UNIT=SYSDA,
//             SPACE=(800,(&WSPC,&WSPC))
//SYSLIB   DD  DSN=&USER..SRCLIB.DATA,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSTERM  DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSUT1   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA
//SYSUT2   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA
//*
//*            COMPILE THE COBOL PROGRAM IF THE PRECOMPILE
//*            RETURN CODE IS 4 OR LESS
//*
//COB     EXEC PGM=IGYCRCTL,COND=(4,LT,PC)
//SYSIN    DD  DSN=&&DSNHOUT,DISP=(OLD,DELETE)
//STEPLIB  DD  DSN=&COMPDSN,DISP=SHR
//SYSLIB   DD  DSN=&CICSDSN,DISP=SHR
//SYSLIN   DD  DSN=&&LOADSET,DISP=(MOD,PASS),UNIT=SYSDA,
//             SPACE=(800,(&WSPC,&WSPC))
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSUT1   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA
//SYSUT2   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA
//SYSUT3   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA
//SYSUT4   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA
//SYSUT5   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA
//SYSUT6   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA  COB2 V1R3
//SYSUT7   DD  SPACE=(800,(&WSPC,&WSPC),,,ROUND),UNIT=SYSDA  COB2 V1R3
//*
//*            LINKEDIT IF THE PRECOMPILE AND COMPILE
//*            RETURN CODES ARE 4 OR LESS
//*
//LKED    EXEC PGM=IEWL,PARM='XREF',
//             COND=((4,LT,COB),(4,LT,PC))
//SYSLIB   DD  DSN=SYS1.COB2LIB,DISP=SHR
//         DD  DSN=&DB2QUAL..DSNLOAD,DISP=SHR
//         DD  DSN=&CICSQUAL..SDFHLOAD,DISP=SHR
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DSN=&USER..RUNLIB.LOAD(&MEM),DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSUT1   DD  SPACE=(1024,(50,50)),UNIT=SYSDA
//*DSNHCOB2 PEND        REMOVE * FOR USE AS INSTREAM PROCEDURE