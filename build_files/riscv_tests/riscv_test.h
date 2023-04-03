// copied and modified from picorv32
#ifndef _ENV_PICORV32_TEST_H
#define _ENV_PICORV32_TEST_H

#include "encoding.h"

#ifndef TEST_FUNC_NAME
#  define TEST_FUNC_NAME mytest
#  define TEST_NUM	 1
#  define TEST_FUNC_TXT "mytest"
#  define TEST_FUNC_RET mytest_ret
#endif

#define RVTEST_RV32U
#define RVTEST_RV32M
#define TESTNUM x28

#define RVTEST_CODE_BEGIN		\
	.text;				\
	.global TEST_FUNC_NAME;		\
	.global TEST_FUNC_RET;		\
	.global uart_putchar;	\
TEST_FUNC_NAME:				\
	la sp, 0x00040000;		\
	sw ra, (sp);			\
.prname_next:				\
.test_name:				\
.prname_done:				\
	lw ra, (sp);			\

#define RVTEST_PASS			\
	la sp, 0x00040000;		\
	sw ra, (sp);			\
	addi a0, zero, TEST_NUM;	\
	jal uart_putchar;		\
	addi a0, zero, 'o';		\
	jal uart_putchar;		\
	addi a0, zero, 'k';		\
	jal uart_putchar;		\
	addi a0, zero, '\r';	\
	jal uart_putchar;		\
	addi a0, zero, '\n';	\
	jal uart_putchar;		\
	lw ra, (sp);			\
	jal zero, TEST_FUNC_RET;
	addi	a1,zero,'O';		\
	addi	a2,zero,'K';		\
	addi	a3,zero,'\n';		\
	sw	a1,0(a0);		\
	sw	a2,0(a0);		\
	sw	a3,0(a0);		\
	jal	zero,TEST_FUNC_RET;

#define RVTEST_FAIL			\
	la sp, 0x00040000;		\
	sw ra, (sp);			\
	addi a0, zero, TEST_NUM;	\
	jal uart_putchar;		\
	addi a0, zero, 'f';		\
	jal uart_putchar;		\
	addi a0, zero, 'a';		\
	jal uart_putchar;		\
	addi a0, zero, 'i';             \
        jal uart_putchar;               \
	addi a0, zero, 'l';             \
        jal uart_putchar;               \
	addi a0, zero, '\n';		\
	jal uart_putchar;		\
	lw ra, (sp);			\
	jal zero, TEST_FUNC_RET;
	addi	a1,zero,'E';		\
	addi	a2,zero,'R';		\
	addi	a3,zero,'O';		\
	addi	a4,zero,'\n';		\
	sw	a1,0(a0);		\
	sw	a2,0(a0);		\
	sw	a2,0(a0);		\
	sw	a3,0(a0);		\
	sw	a2,0(a0);		\
	sw	a4,0(a0);		\
	ebreak;

#define RVTEST_CODE_END
#define RVTEST_DATA_BEGIN .balign 4;
#define RVTEST_DATA_END

#endif
