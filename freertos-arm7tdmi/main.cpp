/*
    FreeRTOS V7.1.0 - Copyright (C) 2011 Real Time Engineers Ltd.
	

    ***************************************************************************
     *                                                                       *
     *    FreeRTOS tutorial books are available in pdf and paperback.        *
     *    Complete, revised, and edited pdf reference manuals are also       *
     *    available.                                                         *
     *                                                                       *
     *    Purchasing FreeRTOS documentation will not only help you, by       *
     *    ensuring you get running as quickly as possible and with an        *
     *    in-depth knowledge of how to use FreeRTOS, it will also help       *
     *    the FreeRTOS project to continue with its mission of providing     *
     *    professional grade, cross platform, de facto standard solutions    *
     *    for microcontrollers - completely free of charge!                  *
     *                                                                       *
     *    >>> See http://www.FreeRTOS.org/Documentation for details. <<<     *
     *                                                                       *
     *    Thank you for using FreeRTOS, and thank you for your support!      *
     *                                                                       *
    ***************************************************************************


    This file is part of the FreeRTOS distribution.

    FreeRTOS is free software; you can redistribute it and/or modify it under
    the terms of the GNU General Public License (version 2) as published by the
    Free Software Foundation AND MODIFIED BY the FreeRTOS exception.
    >>>NOTE<<< The modification to the GPL is included to allow you to
    distribute a combined work that includes FreeRTOS without being obliged to
    provide the source code for proprietary components outside of the FreeRTOS
    kernel.  FreeRTOS is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
    more details. You should have received a copy of the GNU General Public
    License and the FreeRTOS license exception along with FreeRTOS; if not it
    can be viewed here: http://www.freertos.org/a00114.html and also obtained
    by writing to Richard Barry, contact details for whom are available on the
    FreeRTOS WEB site.

    1 tab == 4 spaces!

    http://www.FreeRTOS.org - Documentation, latest information, license and
    contact details.

    http://www.SafeRTOS.com - A version that is certified for use in safety
    critical systems.

    http://www.OpenRTOS.com - Commercial support, development, porting,
    licensing and training services.
*/

/* 
	NOTE : Tasks run in system mode and the scheduler runs in Supervisor mode.
	The processor MUST be in supervisor mode when vTaskStartScheduler is 
	called.  The demo applications included in the FreeRTOS.org download switch
	to supervisor mode prior to main being called.  If you are not using one of
	these demo application projects then ensure Supervisor mode is used.
*/


/*
 * Creates all the application tasks, then starts the scheduler.
 *
 * A task defined by the function vBasicWEBServer is created.  This executes 
 * the lwIP stack and basic WEB server sample.  A task defined by the function
 * vUSBCDCTask.  This executes the USB to serial CDC example.  All the other 
 * tasks are from the set of standard demo tasks.  The WEB documentation 
 * provides more details of the standard demo application tasks.
 *
 * Main.c also creates a task called "Check".  This only executes every three
 * seconds but has the highest priority so is guaranteed to get processor time.
 * Its main function is to check the status of all the other demo application
 * tasks.  LED mainCHECK_LED is toggled every three seconds by the check task
 * should no error conditions be detected in any of the standard demo tasks.
 * The toggle rate increasing to 500ms indicates that at least one error has
 * been detected.
 *
 * Main.c includes an idle hook function that simply periodically sends data
 * to the USB task for transmission.
 */

/*
	Changes from V3.2.2

	+ Modified the stack sizes used by some tasks to permit use of the 
	  command line GCC tools.
*/

/* Library includes. */
#include <string.h>
#include <stdio.h>

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "tasky.h"
#include "printk.h"

/* Demo application includes. */
#include "partest.h"
#include "flash.h"

/* Hardware specific headers. */
#include "Board.h"
#include "AT91SAM7X256.h"

/* Priorities/stacks for the various tasks within the demo application. */
#define mainQUEUE_POLL_PRIORITY		( tskIDLE_PRIORITY + 1 )
#define mainCHECK_TASK_PRIORITY		( tskIDLE_PRIORITY + 3 )
#define mainSEM_TEST_PRIORITY		( tskIDLE_PRIORITY + 1 )
#define mainFLASH_PRIORITY			( tskIDLE_PRIORITY + 2 )
#define mainBLOCK_Q_PRIORITY		( tskIDLE_PRIORITY + 1 )
#define mainWEBSERVER_PRIORITY      ( tskIDLE_PRIORITY + 2 )
#define mainUSB_PRIORITY			( tskIDLE_PRIORITY + 1 )
#define mainUSB_TASK_STACK			( 200 )

/* The rate at which the on board LED will toggle when there is/is not an
error. */
#define mainNO_ERROR_FLASH_PERIOD	( ( portTickType ) 3000 / portTICK_RATE_MS  )
#define mainERROR_FLASH_PERIOD		( ( portTickType ) 500 / portTICK_RATE_MS  )

/* The rate at which the idle hook sends data to the USB port. */
#define mainUSB_TX_FREQUENCY		( 100 / portTICK_RATE_MS )

/* The string that is transmitted down the USB port. */
#define mainFIRST_TX_CHAR			'a'
#define mainLAST_TX_CHAR			'z'

/* The LED used by the check task to indicate the system status. */
#define mainCHECK_LED 				( 3 )
/*-----------------------------------------------------------*/

/*
 * Configure the processor for use with the Atmel demo board.  This is very
 * minimal as most of the setup is performed in the startup code.
 */
static void prvSetupHardware( void );

/*
 * The idle hook is just used to stream data to the USB port.
 */
extern "C" void vApplicationIdleHook( void );
/*-----------------------------------------------------------*/

static void init_dbgu()
{
    AT91PS_PIO pioa = AT91C_BASE_PIOA;
    pioa->PIO_ASR = AT91C_PA27_DRXD | AT91C_PA28_DTXD;
    pioa->PIO_PDR = AT91C_PA27_DRXD | AT91C_PA28_DTXD;

    AT91PS_DBGU dbgu = AT91C_BASE_DBGU;
    dbgu->DBGU_CR = 0xac; // reset and disable tx/rx
    dbgu->DBGU_BRGR = 26; // 115200 bps
    dbgu->DBGU_MR = (4 << 9); // no parity
    //dbgu->DBGU_MR = (3 << 14) | (4 << 9); // no parity
    dbgu->DBGU_CR = 0x50; // enable tx/rx
}


struct Foo
{
    Foo(int x)
        :
            x_(x)
    {
        printk("Foo!\r\n");
    }
    ~Foo()
    {
        printk("~Foo!\r\n");
    }
private:
    int x_;
};

/*
 * Setup hardware then start all the demo application tasks.
 */
extern "C" int main( void )
{
	/* Setup the ports. */
	prvSetupHardware();

	/* Setup the IO required for the LED's. */
	vParTestInitialise();
        init_dbgu();
        printk("Creating tasks\r\n");
        xTaskCreate(tasky, (signed char*) "tasky", 400, NULL, tskIDLE_PRIORITY + 1, NULL);
	vStartLEDFlashTasks( mainFLASH_PRIORITY );
#if 1
        {
            Foo foo(103);
        }
#endif
#if 0
	/* Setup lwIP. */
    vlwIPInit();

	/* Create the lwIP task.  This uses the lwIP RTOS abstraction layer.*/
    sys_thread_new( vBasicWEBServer, ( void * ) NULL, mainWEBSERVER_PRIORITY );

	/* Create the demo USB CDC task. */
	xTaskCreate( vUSBCDCTask, ( signed char * ) "USB", mainUSB_TASK_STACK, NULL, mainUSB_PRIORITY, NULL );

	/* Create the standard demo application tasks. */
	vStartPolledQueueTasks( mainQUEUE_POLL_PRIORITY );
	vStartSemaphoreTasks( mainSEM_TEST_PRIORITY );
	vStartIntegerMathTasks( tskIDLE_PRIORITY );
	vStartBlockingQueueTasks( mainBLOCK_Q_PRIORITY );

	/* Start the check task - which is defined in this file. */	
    xTaskCreate( vErrorChecks, ( signed char * ) "Check", configMINIMAL_STACK_SIZE, NULL, mainCHECK_TASK_PRIORITY, NULL );

#endif
	/* Finally, start the scheduler. 

	NOTE : Tasks run in system mode and the scheduler runs in Supervisor mode.
	The processor MUST be in supervisor mode when vTaskStartScheduler is 
	called.  The demo applications included in the FreeRTOS.org download switch
	to supervisor mode prior to main being called.  If you are not using one of
	these demo application projects then ensure Supervisor mode is used here. */
        printk("starting scheduler\r\n");
	vTaskStartScheduler();

	/* Should never get here! */
	return 0;
}
/*-----------------------------------------------------------*/


static void prvSetupHardware( void )
{
	/* When using the JTAG debugger the hardware is not always initialised to
	the correct default state.  This line just ensures that this does not
	cause all interrupts to be masked at the start. */
	AT91C_BASE_AIC->AIC_EOICR = 0;
	
	/* Most setup is performed by the low level init function called from the
	startup asm file.

	Configure the PIO Lines corresponding to LED1 to LED4 to be outputs as
	well as the UART Tx line. */
	AT91C_BASE_PIOB->PIO_PER = LED_MASK; // Set in PIO mode
	AT91C_BASE_PIOB->PIO_OER = LED_MASK; // Configure in Output


	/* Enable the peripheral clock. */
    AT91C_BASE_PMC->PMC_PCER = 1 << AT91C_ID_PIOA;
    AT91C_BASE_PMC->PMC_PCER = 1 << AT91C_ID_PIOB;
	AT91C_BASE_PMC->PMC_PCER = 1 << AT91C_ID_EMAC;
}
/*-----------------------------------------------------------*/

extern "C" void vApplicationIdleHook( void )
{
static portTickType xLastTx = 0;
char cTxByte;

	/* The idle hook simply sends a string of characters to the USB port.
	The characters will be buffered and sent once the port is connected. */
	if( ( xTaskGetTickCount() - xLastTx ) > mainUSB_TX_FREQUENCY )
	{
		xLastTx = xTaskGetTickCount();
		for( cTxByte = mainFIRST_TX_CHAR; cTxByte <= mainLAST_TX_CHAR; cTxByte++ )
		{
			//vUSBSendByte( cTxByte );
		}		
	}
}


