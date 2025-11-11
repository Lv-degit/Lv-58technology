
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

00000000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
   0:	000011b7          	lui	gp,0x1
        addi    gp, gp, %lo(__global_pointer$)
   4:	97018193          	add	gp,gp,-1680 # 970 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
   8:	00002237          	lui	tp,0x2
        addi    tp, tp, %lo(__thread_pointer$)
   c:	97020213          	add	tp,tp,-1680 # 1970 <__thread_pointer$>
        .option pop

        csrw    mstatus, zero
  10:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
  14:	34201073          	csrw	mcause,zero
    la t0, _stack_safe
    mv sp, t0
    call _init_ext_ram
#endif

        lui     t0,     %hi(__stack_end__)
  18:	002402b7          	lui	t0,0x240
        addi    sp, t0, %lo(__stack_end__)
  1c:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
  20:	228020ef          	jal	2248 <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
  24:	1f0020ef          	jal	2214 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
  28:	747040ef          	jal	4f6e <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
  2c:	29d040ef          	jal	4ac8 <_init>

00000030 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
  30:	00007437          	lui	s0,0x7
  34:	fa040413          	add	s0,s0,-96 # 6fa0 <.L155+0x4>

00000038 <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
  38:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
  3a:	0411                	add	s0,s0,4
        jalr    a0                              // Call initialization function
  3c:	9502                	jalr	a0
        j       L(RunInit)
  3e:	bfed                	j	38 <.L_start_RunInit>

00000040 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
  40:	712010ef          	jal	1752 <_clean_up>

00000044 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
  44:	a9018293          	add	t0,gp,-1392 # 400 <__vector_table>
    csrw mtvec, t0
  48:	30529073          	csrw	mtvec,t0
#if defined (USE_S_MODE_IRQ)
    la t0, __vector_s_table
    csrw stvec, t0
#endif
    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
  4c:	7d016073          	csrs	0x7d0,2

00000050 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
  50:	261040ef          	jal	4ab0 <reset_handler>
        tail    exit
  54:	a009                	j	56 <exit>

00000056 <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
  56:	a001                	j	56 <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
  58:	4501                	li	a0,0
        li      a1, 0
  5a:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
  5c:	255040ef          	jal	4ab0 <reset_handler>
        tail    exit
  60:	bfdd                	j	56 <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

00000142 <__SEGGER_RTL_SIGNAL_SIG_DFL>:
 142:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

00000146 <__SEGGER_RTL_SIGNAL_SIG_IGN>:
 146:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

000003fa <__SEGGER_RTL_SIGNAL_SIG_ERR>:
 3fa:	8082                	ret

Disassembly of section .isr_vector:

0000068c <irq_handler_trap>:
#if defined(__ICCRISCV__) && (IRQ_HANDLER_TRAP_AS_ISR == 1)
extern int __vector_table[];
HPM_ATTR_MACHINE_INTERRUPT
#endif
void irq_handler_trap(void)
{
 68c:	7175                	add	sp,sp,-144
 68e:	c706                	sw	ra,140(sp)
 690:	c516                	sw	t0,136(sp)
 692:	c31a                	sw	t1,132(sp)
 694:	c11e                	sw	t2,128(sp)
 696:	deaa                	sw	a0,124(sp)
 698:	dcae                	sw	a1,120(sp)
 69a:	dab2                	sw	a2,116(sp)
 69c:	d8b6                	sw	a3,112(sp)
 69e:	d6ba                	sw	a4,108(sp)
 6a0:	d4be                	sw	a5,104(sp)
 6a2:	d2c2                	sw	a6,100(sp)
 6a4:	d0c6                	sw	a7,96(sp)
 6a6:	cef2                	sw	t3,92(sp)
 6a8:	ccf6                	sw	t4,88(sp)
 6aa:	cafa                	sw	t5,84(sp)
 6ac:	c8fe                	sw	t6,80(sp)

000006ae <.LBB28>:
    long mcause = read_csr(CSR_MCAUSE);
 6ae:	342027f3          	csrr	a5,mcause
 6b2:	c4be                	sw	a5,72(sp)
 6b4:	47a6                	lw	a5,72(sp)

000006b6 <.LBE28>:
 6b6:	c2be                	sw	a5,68(sp)

000006b8 <.LBB29>:
    long mepc = read_csr(CSR_MEPC);
 6b8:	341027f3          	csrr	a5,mepc
 6bc:	c0be                	sw	a5,64(sp)
 6be:	4786                	lw	a5,64(sp)

000006c0 <.LBE29>:
 6c0:	c6be                	sw	a5,76(sp)

000006c2 <.LBB30>:
    long mstatus = read_csr(CSR_MSTATUS);
 6c2:	300027f3          	csrr	a5,mstatus
 6c6:	de3e                	sw	a5,60(sp)
 6c8:	57f2                	lw	a5,60(sp)

000006ca <.LBE30>:
 6ca:	dc3e                	sw	a5,56(sp)

000006cc <.LBB31>:
    int ucode = read_csr(CSR_UCODE);
#endif
#ifdef __riscv_flen
    int fcsr = read_fcsr();
#endif
    int mcctlbeginaddr = read_csr(CSR_MCCTLBEGINADDR);
 6cc:	7cb027f3          	csrr	a5,0x7cb
 6d0:	da3e                	sw	a5,52(sp)
 6d2:	57d2                	lw	a5,52(sp)

000006d4 <.LBE31>:
 6d4:	d83e                	sw	a5,48(sp)

000006d6 <.LBB32>:
    int mcctldata = read_csr(CSR_MCCTLDATA);
 6d6:	7cd027f3          	csrr	a5,0x7cd
 6da:	d63e                	sw	a5,44(sp)
 6dc:	57b2                	lw	a5,44(sp)

000006de <.LBE32>:
 6de:	d43e                	sw	a5,40(sp)
#else
    __asm volatile("" : : : "a7", "a0", "a1", "a2", "a3");
#endif

    /* Do your trap handling */
    if ((mcause & CSR_MCAUSE_INTERRUPT_MASK) && ((mcause & CSR_MCAUSE_EXCEPTION_CODE_MASK) == IRQ_M_TIMER)) {
 6e0:	4796                	lw	a5,68(sp)
 6e2:	0007dc63          	bgez	a5,6fa <.L29>
 6e6:	4716                	lw	a4,68(sp)
 6e8:	6785                	lui	a5,0x1
 6ea:	17fd                	add	a5,a5,-1 # fff <__SEGGER_RTL_Moeller_inverse_lut+0x11b>
 6ec:	8f7d                	and	a4,a4,a5
 6ee:	479d                	li	a5,7
 6f0:	00f71563          	bne	a4,a5,6fa <.L29>
        /* Machine timer interrupt */
        mchtmr_isr();
 6f4:	3d8040ef          	jal	4acc <mchtmr_isr>
 6f8:	a879                	j	796 <.L30>

000006fa <.L29>:
            __plic_complete_irq(HPM_PLIC_BASE, HPM_PLIC_TARGET_M_MODE, irq_index);
        }
    }
#endif

    else if ((mcause & CSR_MCAUSE_INTERRUPT_MASK) && ((mcause & CSR_MCAUSE_EXCEPTION_CODE_MASK) == IRQ_M_SOFT)) {
 6fa:	4796                	lw	a5,68(sp)
 6fc:	0607d263          	bgez	a5,760 <.L31>
 700:	4716                	lw	a4,68(sp)
 702:	6785                	lui	a5,0x1
 704:	17fd                	add	a5,a5,-1 # fff <__SEGGER_RTL_Moeller_inverse_lut+0x11b>
 706:	8f7d                	and	a4,a4,a5
 708:	478d                	li	a5,3
 70a:	04f71b63          	bne	a4,a5,760 <.L31>
 70e:	e64007b7          	lui	a5,0xe6400
 712:	ca3e                	sw	a5,20(sp)
 714:	c802                	sw	zero,16(sp)

00000716 <.LBB33>:
 */
ATTR_ALWAYS_INLINE static inline uint32_t __plic_claim_irq(uint32_t base, uint32_t target)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
 716:	47c2                	lw	a5,16(sp)
 718:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
 71c:	47d2                	lw	a5,20(sp)
 71e:	973e                	add	a4,a4,a5
 720:	002007b7          	lui	a5,0x200
 724:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_start__+0x4>
 726:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
 728:	c63e                	sw	a5,12(sp)
    return *claim_addr;
 72a:	47b2                	lw	a5,12(sp)
 72c:	439c                	lw	a5,0(a5)

0000072e <.LBE35>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_m_claim_swi(void)
{
    __plic_claim_irq(HPM_PLICSW_BASE, 0);
}
 72e:	0001                	nop

00000730 <.LBE33>:
        /* Machine SWI interrupt */
        intc_m_claim_swi();
        swi_isr();
 730:	3a0040ef          	jal	4ad0 <swi_isr>
 734:	e64007b7          	lui	a5,0xe6400
 738:	d23e                	sw	a5,36(sp)
 73a:	d002                	sw	zero,32(sp)
 73c:	4785                	li	a5,1
 73e:	ce3e                	sw	a5,28(sp)

00000740 <.LBB37>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
 740:	5782                	lw	a5,32(sp)
 742:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
 746:	5792                	lw	a5,36(sp)
 748:	973e                	add	a4,a4,a5
 74a:	002007b7          	lui	a5,0x200
 74e:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_start__+0x4>
 750:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
 752:	cc3e                	sw	a5,24(sp)
    *claim_addr = irq;
 754:	47e2                	lw	a5,24(sp)
 756:	4772                	lw	a4,28(sp)
 758:	c398                	sw	a4,0(a5)
}
 75a:	0001                	nop

0000075c <.LBE39>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_m_complete_swi(void)
{
    __plic_complete_irq(HPM_PLICSW_BASE, HPM_PLIC_TARGET_M_MODE, PLICSWI);
}
 75c:	0001                	nop

0000075e <.LBE37>:
        intc_m_complete_swi();
 75e:	a825                	j	796 <.L30>

00000760 <.L31>:
    } else if (!(mcause & CSR_MCAUSE_INTERRUPT_MASK) && ((mcause & CSR_MCAUSE_EXCEPTION_CODE_MASK) == MCAUSE_ECALL_FROM_MACHINE_MODE)) {
 760:	4796                	lw	a5,68(sp)
 762:	0207c563          	bltz	a5,78c <.L33>
 766:	4716                	lw	a4,68(sp)
 768:	6785                	lui	a5,0x1
 76a:	17fd                	add	a5,a5,-1 # fff <__SEGGER_RTL_Moeller_inverse_lut+0x11b>
 76c:	8f7d                	and	a4,a4,a5
 76e:	47ad                	li	a5,11
 770:	00f71e63          	bne	a4,a5,78c <.L33>
        /* Machine Syscal call */
        __asm volatile(
 774:	e9a20793          	add	a5,tp,-358 # fffffe9a <__AHB_SRAM_segment_end__+0xfdf7e9a>
 778:	8736                	mv	a4,a3
 77a:	86b2                	mv	a3,a2
 77c:	862e                	mv	a2,a1
 77e:	85aa                	mv	a1,a0
 780:	8546                	mv	a0,a7
 782:	9782                	jalr	a5
        "mv a0, a7\n"
        #endif
        "jalr %0\n"
        : : "r"(syscall_handler) : "a4"
        );
        mepc += 4;
 784:	47b6                	lw	a5,76(sp)
 786:	0791                	add	a5,a5,4
 788:	c6be                	sw	a5,76(sp)
 78a:	a031                	j	796 <.L30>

0000078c <.L33>:
    } else {
        mepc = exception_handler(mcause, mepc);
 78c:	45b6                	lw	a1,76(sp)
 78e:	4516                	lw	a0,68(sp)
 790:	344040ef          	jal	4ad4 <exception_handler>
 794:	c6aa                	sw	a0,76(sp)

00000796 <.L30>:
    }

    /* Restore CSR */
    write_csr(CSR_MSTATUS, mstatus);
 796:	57e2                	lw	a5,56(sp)
 798:	30079073          	csrw	mstatus,a5
    write_csr(CSR_MEPC, mepc);
 79c:	47b6                	lw	a5,76(sp)
 79e:	34179073          	csrw	mepc,a5
    write_csr(CSR_UCODE, ucode);
#endif
#ifdef __riscv_flen
    write_fcsr(fcsr);
#endif
    write_csr(CSR_MCCTLDATA, mcctldata);
 7a2:	57a2                	lw	a5,40(sp)
 7a4:	7cd79073          	csrw	0x7cd,a5
    write_csr(CSR_MCCTLBEGINADDR, mcctlbeginaddr);
 7a8:	57c2                	lw	a5,48(sp)
 7aa:	7cb79073          	csrw	0x7cb,a5
}
 7ae:	0001                	nop
 7b0:	40ba                	lw	ra,140(sp)
 7b2:	42aa                	lw	t0,136(sp)
 7b4:	431a                	lw	t1,132(sp)
 7b6:	438a                	lw	t2,128(sp)
 7b8:	5576                	lw	a0,124(sp)
 7ba:	55e6                	lw	a1,120(sp)
 7bc:	5656                	lw	a2,116(sp)
 7be:	56c6                	lw	a3,112(sp)
 7c0:	5736                	lw	a4,108(sp)
 7c2:	57a6                	lw	a5,104(sp)
 7c4:	5816                	lw	a6,100(sp)
 7c6:	5886                	lw	a7,96(sp)
 7c8:	4e76                	lw	t3,92(sp)
 7ca:	4ee6                	lw	t4,88(sp)
 7cc:	4f56                	lw	t5,84(sp)
 7ce:	4fc6                	lw	t6,80(sp)
 7d0:	6149                	add	sp,sp,144
 7d2:	30200073          	mret

Disassembly of section .isr_vector:

000007d8 <nmi_handler>:
#endif

    .section .isr_vector, "ax"
    .weak nmi_handler
nmi_handler:
1:    j 1b
 7d8:	a001                	j	7d8 <nmi_handler>

000007da <default_irq_handler>:
#else

.weak default_irq_handler
.align 2
default_irq_handler:
1:    j 1b
 7da:	a001                	j	7da <default_irq_handler>

Disassembly of section .isr_vector:

000007dc <board_timer_isr>:

#if !defined(NO_BOARD_TIMER_SUPPORT) || !NO_BOARD_TIMER_SUPPORT
static board_timer_cb timer_cb;
SDK_DECLARE_EXT_ISR_M(BOARD_CALLBACK_TIMER_IRQ, board_timer_isr)
void board_timer_isr(void)
{
 7dc:	1141                	add	sp,sp,-16
 7de:	c606                	sw	ra,12(sp)
    if (gptmr_check_status(BOARD_CALLBACK_TIMER, GPTMR_CH_RLD_STAT_MASK(BOARD_CALLBACK_TIMER_CH))) {
 7e0:	45c1                	li	a1,16
 7e2:	f000c537          	lui	a0,0xf000c
 7e6:	0a9040ef          	jal	508e <gptmr_check_status>
 7ea:	87aa                	mv	a5,a0
 7ec:	cb99                	beqz	a5,802 <.L63>
        gptmr_clear_status(BOARD_CALLBACK_TIMER, GPTMR_CH_RLD_STAT_MASK(BOARD_CALLBACK_TIMER_CH));
 7ee:	45c1                	li	a1,16
 7f0:	f000c537          	lui	a0,0xf000c
 7f4:	0bf040ef          	jal	50b2 <gptmr_clear_status>
        timer_cb();
 7f8:	012017b7          	lui	a5,0x1201
 7fc:	1907a783          	lw	a5,400(a5) # 1201190 <timer_cb>
 800:	9782                	jalr	a5

00000802 <.L63>:
    }
}
 802:	0001                	nop
 804:	40b2                	lw	ra,12(sp)
 806:	0141                	add	sp,sp,16
 808:	8082                	ret

0000080a <default_isr_26>:
SDK_DECLARE_EXT_ISR_M(BOARD_CALLBACK_TIMER_IRQ, board_timer_isr)
 80a:	711d                	add	sp,sp,-96
 80c:	c006                	sw	ra,0(sp)
 80e:	c216                	sw	t0,4(sp)
 810:	c41a                	sw	t1,8(sp)
 812:	c61e                	sw	t2,12(sp)
 814:	c826                	sw	s1,16(sp)
 816:	ca2a                	sw	a0,20(sp)
 818:	cc2e                	sw	a1,24(sp)
 81a:	ce32                	sw	a2,28(sp)
 81c:	d036                	sw	a3,32(sp)
 81e:	d23a                	sw	a4,36(sp)
 820:	d43e                	sw	a5,40(sp)
 822:	d642                	sw	a6,44(sp)
 824:	d846                	sw	a7,48(sp)
 826:	da4a                	sw	s2,52(sp)
 828:	dc4e                	sw	s3,56(sp)
 82a:	de52                	sw	s4,60(sp)
 82c:	c0d6                	sw	s5,64(sp)
 82e:	c2da                	sw	s6,68(sp)
 830:	c4f2                	sw	t3,72(sp)
 832:	c6f6                	sw	t4,76(sp)
 834:	c8fa                	sw	t5,80(sp)
 836:	cafe                	sw	t6,84(sp)
 838:	34102973          	csrr	s2,mepc
 83c:	300029f3          	csrr	s3,mstatus
 840:	7cb02af3          	csrr	s5,0x7cb
 844:	7cd02b73          	csrr	s6,0x7cd
 848:	30046073          	csrs	mstatus,8
 84c:	e6c18313          	add	t1,gp,-404 # 7dc <board_timer_isr>
 850:	9302                	jalr	t1
 852:	30047073          	csrc	mstatus,8
 856:	e4200737          	lui	a4,0xe4200
 85a:	46e9                	li	a3,26
 85c:	c354                	sw	a3,4(a4)
 85e:	30099073          	csrw	mstatus,s3
 862:	34191073          	csrw	mepc,s2
 866:	7cdb1073          	csrw	0x7cd,s6
 86a:	7cba9073          	csrw	0x7cb,s5
 86e:	4082                	lw	ra,0(sp)
 870:	4292                	lw	t0,4(sp)
 872:	4322                	lw	t1,8(sp)
 874:	43b2                	lw	t2,12(sp)
 876:	44c2                	lw	s1,16(sp)
 878:	4552                	lw	a0,20(sp)
 87a:	45e2                	lw	a1,24(sp)
 87c:	4672                	lw	a2,28(sp)
 87e:	5682                	lw	a3,32(sp)
 880:	5712                	lw	a4,36(sp)
 882:	57a2                	lw	a5,40(sp)
 884:	5832                	lw	a6,44(sp)
 886:	58c2                	lw	a7,48(sp)
 888:	5952                	lw	s2,52(sp)
 88a:	59e2                	lw	s3,56(sp)
 88c:	5a72                	lw	s4,60(sp)
 88e:	4a86                	lw	s5,64(sp)
 890:	4b16                	lw	s6,68(sp)
 892:	4e26                	lw	t3,72(sp)
 894:	4eb6                	lw	t4,76(sp)
 896:	4f46                	lw	t5,80(sp)
 898:	4fd6                	lw	t6,84(sp)
 89a:	6125                	add	sp,sp,96
 89c:	0cc0000f          	fence	io,io
 8a0:	30200073          	mret

000008a4 <.LFE587>:
	...

Disassembly of section .text.norflash_init:

000014a0 <norflash_init>:
#include "hpm_clock_drv.h"
#include "flashstress_lib.h"

static xpi_nor_config_t s_xpi_nor_config;
int norflash_init(void)
{
    14a0:	7179                	add	sp,sp,-48
    14a2:	d606                	sw	ra,44(sp)
    xpi_nor_config_option_t option;
    option.header.U = BOARD_APP_XPI_NOR_CFG_OPT_HDR;
    14a4:	fcf907b7          	lui	a5,0xfcf90
    14a8:	0785                	add	a5,a5,1 # fcf90001 <__AHB_SRAM_segment_end__+0xcd88001>
    14aa:	c43e                	sw	a5,8(sp)
    option.option0.U = BOARD_APP_XPI_NOR_CFG_OPT_OPT0;
    14ac:	4795                	li	a5,5
    14ae:	c63e                	sw	a5,12(sp)
    option.option1.U = BOARD_APP_XPI_NOR_CFG_OPT_OPT1;
    14b0:	6785                	lui	a5,0x1
    14b2:	c83e                	sw	a5,16(sp)

    hpm_stat_t status = rom_xpi_nor_auto_config(BOARD_APP_XPI_NOR_XPI_BASE, &s_xpi_nor_config, &option);
    14b4:	003c                	add	a5,sp,8
    14b6:	863e                	mv	a2,a5
    14b8:	012017b7          	lui	a5,0x1201
    14bc:	07878593          	add	a1,a5,120 # 1201078 <s_xpi_nor_config>
    14c0:	f3000537          	lui	a0,0xf3000
    14c4:	c51fe0ef          	jal	114 <rom_xpi_nor_auto_config>
    14c8:	ce2a                	sw	a0,28(sp)
    if (status != status_success) {
    14ca:	47f2                	lw	a5,28(sp)
    14cc:	c791                	beqz	a5,14d8 <.L14>
        printf("Error: rom_xpi_nor_auto_config\n");
    14ce:	f4020513          	add	a0,tp,-192 # ffffff40 <__AHB_SRAM_segment_end__+0xfdf7f40>
    14d2:	213020ef          	jal	3ee4 <printf>

000014d6 <.L15>:
        while (1);
    14d6:	a001                	j	14d6 <.L15>

000014d8 <.L14>:
    }
    return 0;
    14d8:	4781                	li	a5,0
}
    14da:	853e                	mv	a0,a5
    14dc:	50b2                	lw	ra,44(sp)
    14de:	6145                	add	sp,sp,48
    14e0:	8082                	ret

Disassembly of section .text.norflash_read:

00001502 <norflash_read>:

int norflash_read(uint32_t offset, void *buf, uint32_t size_bytes)
{
    1502:	7179                	add	sp,sp,-48
    1504:	d606                	sw	ra,44(sp)
    1506:	c62a                	sw	a0,12(sp)
    1508:	c42e                	sw	a1,8(sp)
    150a:	c232                	sw	a2,4(sp)
    hpm_stat_t status = rom_xpi_nor_read(BOARD_APP_XPI_NOR_XPI_BASE, xpi_xfer_channel_auto,
    150c:	4792                	lw	a5,4(sp)
    150e:	4732                	lw	a4,12(sp)
    1510:	46a2                	lw	a3,8(sp)
    1512:	01201637          	lui	a2,0x1201
    1516:	07860613          	add	a2,a2,120 # 1201078 <s_xpi_nor_config>
    151a:	4591                	li	a1,4
    151c:	f3000537          	lui	a0,0xf3000
    1520:	25d020ef          	jal	3f7c <rom_xpi_nor_read>
    1524:	ce2a                	sw	a0,28(sp)
                        &s_xpi_nor_config, (uint32_t *)buf, offset, size_bytes);
    if (status != status_success) {
    1526:	47f2                	lw	a5,28(sp)
    1528:	c399                	beqz	a5,152e <.L18>
        return -1;
    152a:	57fd                	li	a5,-1
    152c:	a011                	j	1530 <.L19>

0000152e <.L18>:
    }

    return 0;
    152e:	4781                	li	a5,0

00001530 <.L19>:
}
    1530:	853e                	mv	a0,a5
    1532:	50b2                	lw	ra,44(sp)
    1534:	6145                	add	sp,sp,48
    1536:	8082                	ret

Disassembly of section .text.norflash_write:

00001538 <norflash_write>:
    memcpy(buf, (void *)flash_addr, size_bytes);
    return 0;
}

int norflash_write(uint32_t offset, const void *buf, uint32_t size_bytes)
{
    1538:	7179                	add	sp,sp,-48
    153a:	d606                	sw	ra,44(sp)
    153c:	c62a                	sw	a0,12(sp)
    153e:	c42e                	sw	a1,8(sp)
    1540:	c232                	sw	a2,4(sp)
    hpm_stat_t status = rom_xpi_nor_program(BOARD_APP_XPI_NOR_XPI_BASE, xpi_xfer_channel_auto,
    1542:	4792                	lw	a5,4(sp)
    1544:	4732                	lw	a4,12(sp)
    1546:	46a2                	lw	a3,8(sp)
    1548:	01201637          	lui	a2,0x1201
    154c:	07860613          	add	a2,a2,120 # 1201078 <s_xpi_nor_config>
    1550:	4591                	li	a1,4
    1552:	f3000537          	lui	a0,0xf3000
    1556:	b7dfe0ef          	jal	d2 <rom_xpi_nor_program>
    155a:	ce2a                	sw	a0,28(sp)
                                 &s_xpi_nor_config, (const uint32_t *)buf, offset, size_bytes);
    if (status != status_success) {
    155c:	47f2                	lw	a5,28(sp)
    155e:	c399                	beqz	a5,1564 <.L23>
        return -1;
    1560:	57fd                	li	a5,-1
    1562:	a011                	j	1566 <.L24>

00001564 <.L23>:
    }
    return 0;
    1564:	4781                	li	a5,0

00001566 <.L24>:
}
    1566:	853e                	mv	a0,a5
    1568:	50b2                	lw	ra,44(sp)
    156a:	6145                	add	sp,sp,48
    156c:	8082                	ret

Disassembly of section .text.norflash_erase_chip:

0000156e <norflash_erase_chip>:

int norflash_erase_chip(void)
{
    156e:	1101                	add	sp,sp,-32
    1570:	ce06                	sw	ra,28(sp)
    hpm_stat_t status = rom_xpi_nor_erase_chip(BOARD_APP_XPI_NOR_XPI_BASE, xpi_xfer_channel_auto, &s_xpi_nor_config);
    1572:	012017b7          	lui	a5,0x1201
    1576:	07878613          	add	a2,a5,120 # 1201078 <s_xpi_nor_config>
    157a:	4591                	li	a1,4
    157c:	f3000537          	lui	a0,0xf3000
    1580:	b1dfe0ef          	jal	9c <rom_xpi_nor_erase_chip>
    1584:	c62a                	sw	a0,12(sp)
    if (status != status_success) {
    1586:	47b2                	lw	a5,12(sp)
    1588:	c399                	beqz	a5,158e <.L26>
        return -1;
    158a:	57fd                	li	a5,-1
    158c:	a011                	j	1590 <.L27>

0000158e <.L26>:
    }
    return 0;
    158e:	4781                	li	a5,0

00001590 <.L27>:
}
    1590:	853e                	mv	a0,a5
    1592:	40f2                	lw	ra,28(sp)
    1594:	6105                	add	sp,sp,32
    1596:	8082                	ret

Disassembly of section .text.norflash_erase_block:

000015d2 <norflash_erase_block>:

int norflash_erase_block(uint32_t offset)
{
    15d2:	7179                	add	sp,sp,-48
    15d4:	d606                	sw	ra,44(sp)
    15d6:	c62a                	sw	a0,12(sp)
    hpm_stat_t status = rom_xpi_nor_erase_block(BOARD_APP_XPI_NOR_XPI_BASE, xpi_xfer_channel_auto, &s_xpi_nor_config, offset);
    15d8:	46b2                	lw	a3,12(sp)
    15da:	012017b7          	lui	a5,0x1201
    15de:	07878613          	add	a2,a5,120 # 1201078 <s_xpi_nor_config>
    15e2:	4591                	li	a1,4
    15e4:	f3000537          	lui	a0,0xf3000
    15e8:	a7bfe0ef          	jal	62 <rom_xpi_nor_erase_block>
    15ec:	ce2a                	sw	a0,28(sp)
    if (status != status_success) {
    15ee:	47f2                	lw	a5,28(sp)
    15f0:	c399                	beqz	a5,15f6 <.L29>
        return -1;
    15f2:	57fd                	li	a5,-1
    15f4:	a011                	j	15f8 <.L30>

000015f6 <.L29>:
    }
    return 0;
    15f6:	4781                	li	a5,0

000015f8 <.L30>:
}
    15f8:	853e                	mv	a0,a5
    15fa:	50b2                	lw	ra,44(sp)
    15fc:	6145                	add	sp,sp,48
    15fe:	8082                	ret

Disassembly of section .text.mchtmr_get_count:

0000166e <mchtmr_get_count>:
 * @brief mchtmr get counter value
 *
 * @param [in] ptr MCHTMR base address
 */
static inline uint64_t mchtmr_get_count(MCHTMR_Type *ptr)
{
    166e:	1141                	add	sp,sp,-16
    1670:	c62a                	sw	a0,12(sp)
    return (ptr->MTIME & MCHTMR_MTIME_MTIME_MASK) >> MCHTMR_MTIME_MTIME_SHIFT;
    1672:	47b2                	lw	a5,12(sp)
    1674:	4398                	lw	a4,0(a5)
    1676:	43dc                	lw	a5,4(a5)
}
    1678:	853a                	mv	a0,a4
    167a:	85be                	mv	a1,a5
    167c:	0141                	add	sp,sp,16
    167e:	8082                	ret

Disassembly of section .text.flashstress_context_alloc:

00001682 <flashstress_context_alloc>:
};

static struct flashstress_context flashstress_ctxs[CONFIG_CONTEXT_NUM];

static struct flashstress_context *flashstress_context_alloc(void)
{
    1682:	1141                	add	sp,sp,-16
    struct flashstress_context *ctx = NULL;
    1684:	c602                	sw	zero,12(sp)

00001686 <.LBB2>:

    for (int i = 0; i < CONFIG_CONTEXT_NUM; i++) {
    1686:	c402                	sw	zero,8(sp)
    1688:	a899                	j	16de <.L13>

0000168a <.L16>:
        if (!flashstress_ctxs[i].is_used) {
    168a:	012007b7          	lui	a5,0x1200
    168e:	01478713          	add	a4,a5,20 # 1200014 <flashstress_ctxs>
    1692:	46a2                	lw	a3,8(sp)
    1694:	6785                	lui	a5,0x1
    1696:	06478793          	add	a5,a5,100 # 1064 <__SEGGER_RTL_Moeller_inverse_lut+0x180>
    169a:	02f687b3          	mul	a5,a3,a5
    169e:	97ba                	add	a5,a5,a4
    16a0:	439c                	lw	a5,0(a5)
    16a2:	eb9d                	bnez	a5,16d8 <.L14>
            flashstress_ctxs[i].is_used = 1;
    16a4:	012007b7          	lui	a5,0x1200
    16a8:	01478713          	add	a4,a5,20 # 1200014 <flashstress_ctxs>
    16ac:	46a2                	lw	a3,8(sp)
    16ae:	6785                	lui	a5,0x1
    16b0:	06478793          	add	a5,a5,100 # 1064 <__SEGGER_RTL_Moeller_inverse_lut+0x180>
    16b4:	02f687b3          	mul	a5,a3,a5
    16b8:	97ba                	add	a5,a5,a4
    16ba:	4705                	li	a4,1
    16bc:	c398                	sw	a4,0(a5)
            ctx = &flashstress_ctxs[i];
    16be:	4722                	lw	a4,8(sp)
    16c0:	6785                	lui	a5,0x1
    16c2:	06478793          	add	a5,a5,100 # 1064 <__SEGGER_RTL_Moeller_inverse_lut+0x180>
    16c6:	02f70733          	mul	a4,a4,a5
    16ca:	012007b7          	lui	a5,0x1200
    16ce:	01478793          	add	a5,a5,20 # 1200014 <flashstress_ctxs>
    16d2:	97ba                	add	a5,a5,a4
    16d4:	c63e                	sw	a5,12(sp)
            break;
    16d6:	a039                	j	16e4 <.L15>

000016d8 <.L14>:
    for (int i = 0; i < CONFIG_CONTEXT_NUM; i++) {
    16d8:	47a2                	lw	a5,8(sp)
    16da:	0785                	add	a5,a5,1
    16dc:	c43e                	sw	a5,8(sp)

000016de <.L13>:
    16de:	47a2                	lw	a5,8(sp)
    16e0:	faf055e3          	blez	a5,168a <.L16>

000016e4 <.L15>:
        }
    }

    return ctx;
    16e4:	47b2                	lw	a5,12(sp)
}
    16e6:	853e                	mv	a0,a5
    16e8:	0141                	add	sp,sp,16
    16ea:	8082                	ret

Disassembly of section .text.flashstress_context_free:

0000171e <flashstress_context_free>:

static void flashstress_context_free(struct flashstress_context *ctx)
{
    171e:	1141                	add	sp,sp,-16
    1720:	c62a                	sw	a0,12(sp)
    if (!ctx) {
    1722:	47b2                	lw	a5,12(sp)
    1724:	c789                	beqz	a5,172e <.L21>
        return;
    }

    ctx->is_used = 0;
    1726:	47b2                	lw	a5,12(sp)
    1728:	0007a023          	sw	zero,0(a5)
    172c:	a011                	j	1730 <.L18>

0000172e <.L21>:
        return;
    172e:	0001                	nop

00001730 <.L18>:
}
    1730:	0141                	add	sp,sp,16
    1732:	8082                	ret

Disassembly of section .text._clean_up:

00001752 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
    1752:	7139                	add	sp,sp,-64

00001754 <.LBB18>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
    1754:	28b01793          	bset	a5,zero,0xb
    1758:	3047b073          	csrc	mie,a5
}
    175c:	0001                	nop
    175e:	da02                	sw	zero,52(sp)
    1760:	d802                	sw	zero,48(sp)
    1762:	e40007b7          	lui	a5,0xe4000
    1766:	d63e                	sw	a5,44(sp)
    1768:	57d2                	lw	a5,52(sp)
    176a:	d43e                	sw	a5,40(sp)
    176c:	57c2                	lw	a5,48(sp)
    176e:	d23e                	sw	a5,36(sp)

00001770 <.LBB20>:
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
    1770:	57a2                	lw	a5,40(sp)
    1772:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
    1776:	57b2                	lw	a5,44(sp)
    1778:	973e                	add	a4,a4,a5
    177a:	002007b7          	lui	a5,0x200
    177e:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
    1780:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
    1782:	5782                	lw	a5,32(sp)
    1784:	5712                	lw	a4,36(sp)
    1786:	c398                	sw	a4,0(a5)
}
    1788:	0001                	nop

0000178a <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
    178a:	0001                	nop

0000178c <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
    178c:	de02                	sw	zero,60(sp)
    178e:	a82d                	j	17c8 <.L2>

00001790 <.L3>:
    1790:	ce02                	sw	zero,28(sp)
    1792:	57f2                	lw	a5,60(sp)
    1794:	cc3e                	sw	a5,24(sp)
    1796:	e40007b7          	lui	a5,0xe4000
    179a:	ca3e                	sw	a5,20(sp)
    179c:	47f2                	lw	a5,28(sp)
    179e:	c83e                	sw	a5,16(sp)
    17a0:	47e2                	lw	a5,24(sp)
    17a2:	c63e                	sw	a5,12(sp)

000017a4 <.LBB25>:
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
    17a4:	47c2                	lw	a5,16(sp)
    17a6:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
    17aa:	47d2                	lw	a5,20(sp)
    17ac:	973e                	add	a4,a4,a5
    17ae:	002007b7          	lui	a5,0x200
    17b2:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_start__+0x4>
    17b4:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
    17b6:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
    17b8:	47a2                	lw	a5,8(sp)
    17ba:	4732                	lw	a4,12(sp)
    17bc:	c398                	sw	a4,0(a5)
}
    17be:	0001                	nop

000017c0 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
    17c0:	0001                	nop

000017c2 <.LBE25>:
    17c2:	57f2                	lw	a5,60(sp)
    17c4:	0785                	add	a5,a5,1
    17c6:	de3e                	sw	a5,60(sp)

000017c8 <.L2>:
    17c8:	5772                	lw	a4,60(sp)
    17ca:	07f00793          	li	a5,127
    17ce:	fce7f1e3          	bgeu	a5,a4,1790 <.L3>

000017d2 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
    17d2:	dc02                	sw	zero,56(sp)
    17d4:	a821                	j	17ec <.L4>

000017d6 <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
    17d6:	57e2                	lw	a5,56(sp)
    17d8:	00279713          	sll	a4,a5,0x2
    17dc:	e40027b7          	lui	a5,0xe4002
    17e0:	97ba                	add	a5,a5,a4
    17e2:	0007a023          	sw	zero,0(a5) # e4002000 <_extram_size+0xe2002000>
    for (uint32_t i = 0; i < 4; i++) {
    17e6:	57e2                	lw	a5,56(sp)
    17e8:	0785                	add	a5,a5,1
    17ea:	dc3e                	sw	a5,56(sp)

000017ec <.L4>:
    17ec:	5762                	lw	a4,56(sp)
    17ee:	478d                	li	a5,3
    17f0:	fee7f3e3          	bgeu	a5,a4,17d6 <.L5>

000017f4 <.LBE29>:
    }
}
    17f4:	0001                	nop
    17f6:	0001                	nop
    17f8:	6121                	add	sp,sp,64
    17fa:	8082                	ret

Disassembly of section .text.syscall_handler:

0000180a <syscall_handler>:
{
    180a:	1101                	add	sp,sp,-32
    180c:	ce2a                	sw	a0,28(sp)
    180e:	cc2e                	sw	a1,24(sp)
    1810:	ca32                	sw	a2,20(sp)
    1812:	c836                	sw	a3,16(sp)
    1814:	c63a                	sw	a4,12(sp)
}
    1816:	0001                	nop
    1818:	6105                	add	sp,sp,32
    181a:	8082                	ret

Disassembly of section .text.system_init:

00001826 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
    1826:	7179                	add	sp,sp,-48
    1828:	d606                	sw	ra,44(sp)

0000182a <.LBB16>:
#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
    182a:	306027f3          	csrr	a5,mcounteren
    182e:	ce3e                	sw	a5,28(sp)
    1830:	47f2                	lw	a5,28(sp)

00001832 <.LBE16>:
    1832:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
    1834:	47e2                	lw	a5,24(sp)
    1836:	0017e793          	or	a5,a5,1
    183a:	30679073          	csrw	mcounteren,a5
    183e:	47a1                	li	a5,8
    1840:	c83e                	sw	a5,16(sp)

00001842 <.LBB17>:
 * @param[in] mask interrupt mask to be disabled
 * @retval current mstatus value before irq mask is disabled
 */
ATTR_ALWAYS_INLINE static inline uint32_t disable_global_irq(uint32_t mask)
{
    return read_clear_csr(CSR_MSTATUS, mask);
    1842:	c602                	sw	zero,12(sp)
    1844:	47c2                	lw	a5,16(sp)
    1846:	3007b7f3          	csrrc	a5,mstatus,a5
    184a:	c63e                	sw	a5,12(sp)
    184c:	47b2                	lw	a5,12(sp)

0000184e <.LBE19>:
    184e:	0001                	nop

00001850 <.LBB20>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
    1850:	28b01793          	bset	a5,zero,0xb
    1854:	3047b073          	csrc	mie,a5
}
    1858:	0001                	nop

0000185a <.LBE20>:
    disable_irq_from_intc();
#ifdef USE_S_MODE_IRQ
    disable_s_irq_from_intc();
#endif

    enable_plic_feature();
    185a:	2a2030ef          	jal	4afc <enable_plic_feature>

0000185e <.LBB22>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
    185e:	28b01793          	bset	a5,zero,0xb
    1862:	3047a073          	csrs	mie,a5
}
    1866:	0001                	nop
    1868:	47a1                	li	a5,8
    186a:	ca3e                	sw	a5,20(sp)

0000186c <.LBB24>:
    set_csr(CSR_MSTATUS, mask);
    186c:	47d2                	lw	a5,20(sp)
    186e:	3007a073          	csrs	mstatus,a5
}
    1872:	0001                	nop

00001874 <.LBE24>:
#endif

#if defined(CONFIG_ENABLE_BPOR_RETENTION) && CONFIG_ENABLE_BPOR_RETENTION
    bpor_enable_reg_value_retention(HPM_BPOR);
#endif
}
    1874:	0001                	nop
    1876:	50b2                	lw	ra,44(sp)
    1878:	6145                	add	sp,sp,48
    187a:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

00001886 <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
    1886:	1141                	add	sp,sp,-16
    1888:	c62a                	sw	a0,12(sp)
    188a:	87ae                	mv	a5,a1
    188c:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
    1890:	00a15783          	lhu	a5,10(sp)
    1894:	4732                	lw	a4,12(sp)
    1896:	078a                	sll	a5,a5,0x2
    1898:	97ba                	add	a5,a5,a4
    189a:	4398                	lw	a4,0(a5)
    189c:	400007b7          	lui	a5,0x40000
    18a0:	8ff9                	and	a5,a5,a4
    18a2:	00f037b3          	snez	a5,a5
    18a6:	0ff7f793          	zext.b	a5,a5
}
    18aa:	853e                	mv	a0,a5
    18ac:	0141                	add	sp,sp,16
    18ae:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

00001f3c <sysctl_config_clock>:
    }
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node_index, clock_source_t source, uint32_t divide_by)
{
    1f3c:	7179                	add	sp,sp,-48
    1f3e:	d606                	sw	ra,44(sp)
    1f40:	c62a                	sw	a0,12(sp)
    1f42:	87ae                	mv	a5,a1
    1f44:	8732                	mv	a4,a2
    1f46:	c236                	sw	a3,4(sp)
    1f48:	00f105a3          	sb	a5,11(sp)
    1f4c:	87ba                	mv	a5,a4
    1f4e:	00f10523          	sb	a5,10(sp)
    uint32_t node = (uint32_t) node_index;
    1f52:	00b14783          	lbu	a5,11(sp)
    1f56:	ce3e                	sw	a5,28(sp)
    if (node >= clock_node_adc_start) {
    1f58:	4772                	lw	a4,28(sp)
    1f5a:	04800793          	li	a5,72
    1f5e:	00e7f463          	bgeu	a5,a4,1f66 <.L103>
        return status_invalid_argument;
    1f62:	4789                	li	a5,2
    1f64:	a095                	j	1fc8 <.L104>

00001f66 <.L103>:
    }

    if (source >= clock_source_general_source_end) {
    1f66:	00a14703          	lbu	a4,10(sp)
    1f6a:	479d                	li	a5,7
    1f6c:	00e7f463          	bgeu	a5,a4,1f74 <.L105>
        return status_invalid_argument;
    1f70:	4789                	li	a5,2
    1f72:	a899                	j	1fc8 <.L104>

00001f74 <.L105>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
    1f74:	4732                	lw	a4,12(sp)
    1f76:	47f2                	lw	a5,28(sp)
    1f78:	60078793          	add	a5,a5,1536 # 40000600 <_extram_size+0x3e000600>
    1f7c:	078a                	sll	a5,a5,0x2
    1f7e:	97ba                	add	a5,a5,a4
    1f80:	439c                	lw	a5,0(a5)
    1f82:	8007f713          	and	a4,a5,-2048
        (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
    1f86:	00a14783          	lbu	a5,10(sp)
    1f8a:	07a2                	sll	a5,a5,0x8
    1f8c:	7007f693          	and	a3,a5,1792
    1f90:	4792                	lw	a5,4(sp)
    1f92:	17fd                	add	a5,a5,-1
    1f94:	0ff7f793          	zext.b	a5,a5
    1f98:	8fd5                	or	a5,a5,a3
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
    1f9a:	8f5d                	or	a4,a4,a5
    1f9c:	46b2                	lw	a3,12(sp)
    1f9e:	47f2                	lw	a5,28(sp)
    1fa0:	60078793          	add	a5,a5,1536
    1fa4:	078a                	sll	a5,a5,0x2
    1fa6:	97b6                	add	a5,a5,a3
    1fa8:	c398                	sw	a4,0(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
    1faa:	0001                	nop

00001fac <.L106>:
    1fac:	45f2                	lw	a1,28(sp)
    1fae:	4532                	lw	a0,12(sp)
    1fb0:	379020ef          	jal	4b28 <sysctl_clock_target_is_busy>
    1fb4:	87aa                	mv	a5,a0
    1fb6:	fbfd                	bnez	a5,1fac <.L106>
    }
    if ((node == clock_node_cpu0) || (node == clock_node_cpu1)) {
    1fb8:	47f2                	lw	a5,28(sp)
    1fba:	c789                	beqz	a5,1fc4 <.L107>
    1fbc:	4772                	lw	a4,28(sp)
    1fbe:	4789                	li	a5,2
    1fc0:	00f71363          	bne	a4,a5,1fc6 <.L108>

00001fc4 <.L107>:
        clock_update_core_clock();
    1fc4:	22d1                	jal	2188 <clock_update_core_clock>

00001fc6 <.L108>:
    }
    return status_success;
    1fc6:	4781                	li	a5,0

00001fc8 <.L104>:
}
    1fc8:	853e                	mv	a0,a5
    1fca:	50b2                	lw	ra,44(sp)
    1fcc:	6145                	add	sp,sp,48
    1fce:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

00001fd0 <get_frequency_for_source>:
    }
    return clk_freq;
}

uint32_t get_frequency_for_source(clock_source_t source)
{
    1fd0:	7179                	add	sp,sp,-48
    1fd2:	d606                	sw	ra,44(sp)
    1fd4:	87aa                	mv	a5,a0
    1fd6:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
    1fda:	ce02                	sw	zero,28(sp)
    switch (source) {
    1fdc:	00f14783          	lbu	a5,15(sp)
    1fe0:	471d                	li	a4,7
    1fe2:	08f76763          	bltu	a4,a5,2070 <.L35>
    1fe6:	00279713          	sll	a4,a5,0x2
    1fea:	90018793          	add	a5,gp,-1792 # 270 <.L37>
    1fee:	97ba                	add	a5,a5,a4
    1ff0:	439c                	lw	a5,0(a5)
    1ff2:	8782                	jr	a5

00001ff4 <.L44>:
    case clock_source_osc0_clk0:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
    1ff4:	016e37b7          	lui	a5,0x16e3
    1ff8:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
    1ffc:	ce3e                	sw	a5,28(sp)
        break;
    1ffe:	a89d                	j	2074 <.L45>

00002000 <.L43>:
    case clock_source_pll0_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0);
    2000:	4601                	li	a2,0
    2002:	4581                	li	a1,0
    2004:	f40c0537          	lui	a0,0xf40c0
    2008:	7be030ef          	jal	57c6 <pllctlv2_get_pll_postdiv_freq_in_hz>
    200c:	ce2a                	sw	a0,28(sp)
        break;
    200e:	a09d                	j	2074 <.L45>

00002010 <.L42>:
    case clock_source_pll0_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1);
    2010:	4605                	li	a2,1
    2012:	4581                	li	a1,0
    2014:	f40c0537          	lui	a0,0xf40c0
    2018:	7ae030ef          	jal	57c6 <pllctlv2_get_pll_postdiv_freq_in_hz>
    201c:	ce2a                	sw	a0,28(sp)
        break;
    201e:	a899                	j	2074 <.L45>

00002020 <.L41>:
    case clock_source_pll1_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk0);
    2020:	4601                	li	a2,0
    2022:	4585                	li	a1,1
    2024:	f40c0537          	lui	a0,0xf40c0
    2028:	79e030ef          	jal	57c6 <pllctlv2_get_pll_postdiv_freq_in_hz>
    202c:	ce2a                	sw	a0,28(sp)
        break;
    202e:	a099                	j	2074 <.L45>

00002030 <.L40>:
    case clock_source_pll1_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk1);
    2030:	4605                	li	a2,1
    2032:	4585                	li	a1,1
    2034:	f40c0537          	lui	a0,0xf40c0
    2038:	78e030ef          	jal	57c6 <pllctlv2_get_pll_postdiv_freq_in_hz>
    203c:	ce2a                	sw	a0,28(sp)
        break;
    203e:	a81d                	j	2074 <.L45>

00002040 <.L39>:
    case clock_source_pll1_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk2);
    2040:	4609                	li	a2,2
    2042:	4585                	li	a1,1
    2044:	f40c0537          	lui	a0,0xf40c0
    2048:	77e030ef          	jal	57c6 <pllctlv2_get_pll_postdiv_freq_in_hz>
    204c:	ce2a                	sw	a0,28(sp)
        break;
    204e:	a01d                	j	2074 <.L45>

00002050 <.L38>:
    case clock_source_pll2_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll2, pllctlv2_clk0);
    2050:	4601                	li	a2,0
    2052:	4589                	li	a1,2
    2054:	f40c0537          	lui	a0,0xf40c0
    2058:	76e030ef          	jal	57c6 <pllctlv2_get_pll_postdiv_freq_in_hz>
    205c:	ce2a                	sw	a0,28(sp)
        break;
    205e:	a819                	j	2074 <.L45>

00002060 <.L36>:
    case clock_source_pll2_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll2, pllctlv2_clk1);
    2060:	4605                	li	a2,1
    2062:	4589                	li	a1,2
    2064:	f40c0537          	lui	a0,0xf40c0
    2068:	75e030ef          	jal	57c6 <pllctlv2_get_pll_postdiv_freq_in_hz>
    206c:	ce2a                	sw	a0,28(sp)
        break;
    206e:	a019                	j	2074 <.L45>

00002070 <.L35>:
    default:
        clk_freq = 0UL;
    2070:	ce02                	sw	zero,28(sp)
        break;
    2072:	0001                	nop

00002074 <.L45>:
    }

    return clk_freq;
    2074:	47f2                	lw	a5,28(sp)
}
    2076:	853e                	mv	a0,a5
    2078:	50b2                	lw	ra,44(sp)
    207a:	6145                	add	sp,sp,48
    207c:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

0000207e <get_frequency_for_ip_in_common_group>:

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
    207e:	7139                	add	sp,sp,-64
    2080:	de06                	sw	ra,60(sp)
    2082:	87aa                	mv	a5,a0
    2084:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
    2088:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
    208a:	00f14783          	lbu	a5,15(sp)
    208e:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
    2090:	5722                	lw	a4,40(sp)
    2092:	04e00793          	li	a5,78
    2096:	04e7e563          	bltu	a5,a4,20e0 <.L48>

0000209a <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
    209a:	57a2                	lw	a5,40(sp)
    209c:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
    209e:	f4000737          	lui	a4,0xf4000
    20a2:	5792                	lw	a5,36(sp)
    20a4:	60078793          	add	a5,a5,1536
    20a8:	078a                	sll	a5,a5,0x2
    20aa:	97ba                	add	a5,a5,a4
    20ac:	439c                	lw	a5,0(a5)
    20ae:	0ff7f793          	zext.b	a5,a5
    20b2:	0785                	add	a5,a5,1
    20b4:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
    20b6:	f4000737          	lui	a4,0xf4000
    20ba:	5792                	lw	a5,36(sp)
    20bc:	60078793          	add	a5,a5,1536
    20c0:	078a                	sll	a5,a5,0x2
    20c2:	97ba                	add	a5,a5,a4
    20c4:	439c                	lw	a5,0(a5)
    20c6:	83a1                	srl	a5,a5,0x8
    20c8:	8b9d                	and	a5,a5,7
    20ca:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
    20ce:	01f14783          	lbu	a5,31(sp)
    20d2:	853e                	mv	a0,a5
    20d4:	3df5                	jal	1fd0 <get_frequency_for_source>
    20d6:	872a                	mv	a4,a0
    20d8:	5782                	lw	a5,32(sp)
    20da:	02f757b3          	divu	a5,a4,a5
    20de:	d63e                	sw	a5,44(sp)

000020e0 <.L48>:
    }
    return clk_freq;
    20e0:	57b2                	lw	a5,44(sp)
}
    20e2:	853e                	mv	a0,a5
    20e4:	50f2                	lw	ra,60(sp)
    20e6:	6121                	add	sp,sp,64
    20e8:	8082                	ret

Disassembly of section .text.get_frequency_for_i2s:

000020ea <get_frequency_for_i2s>:
    }
    return clk_freq;
}

static uint32_t get_frequency_for_i2s(uint32_t instance)
{
    20ea:	7179                	add	sp,sp,-48
    20ec:	d606                	sw	ra,44(sp)
    20ee:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
    20f0:	ce02                	sw	zero,28(sp)
    clock_node_t node;
    uint32_t mux_in_reg;

    if (instance < I2S_INSTANCE_NUM) {
    20f2:	4732                	lw	a4,12(sp)
    20f4:	4785                	li	a5,1
    20f6:	04e7e763          	bltu	a5,a4,2144 <.L56>
        mux_in_reg = SYSCTL_I2SCLK_MUX_GET(HPM_SYSCTL->I2SCLK[instance]);
    20fa:	f4000737          	lui	a4,0xf4000
    20fe:	47b2                	lw	a5,12(sp)
    2100:	70478793          	add	a5,a5,1796
    2104:	078a                	sll	a5,a5,0x2
    2106:	97ba                	add	a5,a5,a4
    2108:	439c                	lw	a5,0(a5)
    210a:	83a1                	srl	a5,a5,0x8
    210c:	8b85                	and	a5,a5,1
    210e:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg == 0) {
    2110:	47d2                	lw	a5,20(sp)
    2112:	eb89                	bnez	a5,2124 <.L57>
            node = clock_node_aud0 + instance;
    2114:	47b2                	lw	a5,12(sp)
    2116:	0ff7f793          	zext.b	a5,a5
    211a:	03578793          	add	a5,a5,53
    211e:	00f10da3          	sb	a5,27(sp)
    2122:	a821                	j	213a <.L58>

00002124 <.L57>:
        } else if (instance == 0) {
    2124:	47b2                	lw	a5,12(sp)
    2126:	e791                	bnez	a5,2132 <.L59>
            node = clock_node_aud1;
    2128:	03600793          	li	a5,54
    212c:	00f10da3          	sb	a5,27(sp)
    2130:	a029                	j	213a <.L58>

00002132 <.L59>:
        } else {
            node = clock_node_aud0;
    2132:	03500793          	li	a5,53
    2136:	00f10da3          	sb	a5,27(sp)

0000213a <.L58>:
        }
        clk_freq = get_frequency_for_ip_in_common_group(node);
    213a:	01b14783          	lbu	a5,27(sp)
    213e:	853e                	mv	a0,a5
    2140:	3f3d                	jal	207e <get_frequency_for_ip_in_common_group>
    2142:	ce2a                	sw	a0,28(sp)

00002144 <.L56>:
    }

    return clk_freq;
    2144:	47f2                	lw	a5,28(sp)
}
    2146:	853e                	mv	a0,a5
    2148:	50b2                	lw	ra,44(sp)
    214a:	6145                	add	sp,sp,48
    214c:	8082                	ret

Disassembly of section .text.clock_add_to_group:

0000214e <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
    214e:	7179                	add	sp,sp,-48
    2150:	d606                	sw	ra,44(sp)
    2152:	c62a                	sw	a0,12(sp)
    2154:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
    2156:	47b2                	lw	a5,12(sp)
    2158:	83c1                	srl	a5,a5,0x10
    215a:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
    215c:	4772                	lw	a4,28(sp)
    215e:	17b00793          	li	a5,379
    2162:	00e7ef63          	bltu	a5,a4,2180 <.L155>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
    2166:	47a2                	lw	a5,8(sp)
    2168:	0ff7f793          	zext.b	a5,a5
    216c:	4772                	lw	a4,28(sp)
    216e:	08074733          	zext.h	a4,a4
    2172:	4685                	li	a3,1
    2174:	863a                	mv	a2,a4
    2176:	85be                	mv	a1,a5
    2178:	f4000537          	lui	a0,0xf4000
    217c:	1d5020ef          	jal	4b50 <sysctl_enable_group_resource>

00002180 <.L155>:
    }
}
    2180:	0001                	nop
    2182:	50b2                	lw	ra,44(sp)
    2184:	6145                	add	sp,sp,48
    2186:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

00002188 <clock_update_core_clock>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_update_core_clock(void)
{
    2188:	1101                	add	sp,sp,-32
    218a:	ce06                	sw	ra,28(sp)

0000218c <.LBB14>:
    uint32_t hart_id = read_csr(CSR_MHARTID);
    218c:	f14027f3          	csrr	a5,mhartid
    2190:	c63e                	sw	a5,12(sp)
    2192:	47b2                	lw	a5,12(sp)

00002194 <.LBE14>:
    2194:	c43e                	sw	a5,8(sp)
    clock_name_t cpu_clk_name = (hart_id == 1U) ? clock_cpu1 : clock_cpu0;
    2196:	4722                	lw	a4,8(sp)
    2198:	4785                	li	a5,1
    219a:	00f71663          	bne	a4,a5,21a6 <.L183>
    219e:	000807b7          	lui	a5,0x80
    21a2:	0789                	add	a5,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
    21a4:	a011                	j	21a8 <.L184>

000021a6 <.L183>:
    21a6:	4781                	li	a5,0

000021a8 <.L184>:
    21a8:	c23e                	sw	a5,4(sp)
    hpm_core_clock = clock_get_frequency(cpu_clk_name);
    21aa:	4512                	lw	a0,4(sp)
    21ac:	2cd020ef          	jal	4c78 <clock_get_frequency>
    21b0:	872a                	mv	a4,a0
    21b2:	012017b7          	lui	a5,0x1201
    21b6:	18e7ac23          	sw	a4,408(a5) # 1201198 <hpm_core_clock>
}
    21ba:	0001                	nop
    21bc:	40f2                	lw	ra,28(sp)
    21be:	6105                	add	sp,sp,32
    21c0:	8082                	ret

Disassembly of section .text.l1c_op:

000021c2 <l1c_op>:
                                             assert(address % HPM_L1C_CACHELINE_SIZE == 0); \
                                             assert(size % HPM_L1C_CACHELINE_SIZE == 0); \
                                        } while (0)

static void l1c_op(uint8_t opcode, uint32_t address, uint32_t size)
{
    21c2:	7179                	add	sp,sp,-48
    21c4:	d622                	sw	s0,44(sp)
    21c6:	87aa                	mv	a5,a0
    21c8:	c42e                	sw	a1,8(sp)
    21ca:	c232                	sw	a2,4(sp)
    21cc:	00f107a3          	sb	a5,15(sp)
        l1c_cctl_address_cmd(opcode, address + i * HPM_L1C_CACHELINE_SIZE);
        tmp += HPM_L1C_CACHELINE_SIZE;
    }
#else
    register uint32_t next_address;
    next_address = address;
    21d0:	4422                	lw	s0,8(sp)
    21d2:	ce22                	sw	s0,28(sp)

000021d4 <.LBB41>:
    (uint32_t)(((x) << HPM_MCCTLBEGINADDR_WAY_SHIFT) & HPM_MCCTLBEGINADDR_WAY_MASK)

/* send IX command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_address(uint32_t address)
{
    write_csr(CSR_MCCTLBEGINADDR, address);
    21d4:	47f2                	lw	a5,28(sp)
    21d6:	7cb79073          	csrw	0x7cb,a5
}
    21da:	0001                	nop

000021dc <.LBE41>:
    l1c_cctl_address(next_address);
    while ((next_address < (address + size)) && (next_address >= address)) {
    21dc:	a005                	j	21fc <.L2>

000021de <.L5>:
    21de:	00f14783          	lbu	a5,15(sp)
    21e2:	00f10ba3          	sb	a5,23(sp)

000021e6 <.LBB43>:

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
    21e6:	01714783          	lbu	a5,23(sp)
    21ea:	7cc79073          	csrw	0x7cc,a5
}
    21ee:	0001                	nop

000021f0 <.LBB45>:

ATTR_ALWAYS_INLINE static inline uint32_t l1c_cctl_get_address(void)
{
    return read_csr(CSR_MCCTLBEGINADDR);
    21f0:	7cb027f3          	csrr	a5,0x7cb
    21f4:	cc3e                	sw	a5,24(sp)
    21f6:	47e2                	lw	a5,24(sp)

000021f8 <.LBE47>:
    21f8:	0001                	nop

000021fa <.LBE45>:
        l1c_cctl_cmd(opcode);
        next_address = l1c_cctl_get_address();
    21fa:	843e                	mv	s0,a5

000021fc <.L2>:
    while ((next_address < (address + size)) && (next_address >= address)) {
    21fc:	4722                	lw	a4,8(sp)
    21fe:	4792                	lw	a5,4(sp)
    2200:	97ba                	add	a5,a5,a4
    2202:	00f47563          	bgeu	s0,a5,220c <.L6>
    2206:	47a2                	lw	a5,8(sp)
    2208:	fcf47be3          	bgeu	s0,a5,21de <.L5>

0000220c <.L6>:
    }
#endif
}
    220c:	0001                	nop
    220e:	5432                	lw	s0,44(sp)
    2210:	6145                	add	sp,sp,48
    2212:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

00002214 <l1c_dc_enable>:

void l1c_dc_enable(void)
{
    2214:	1101                	add	sp,sp,-32
    2216:	ce06                	sw	ra,28(sp)

00002218 <.LBB48>:
    return read_csr(CSR_MCACHE_CTL);
    2218:	7ca027f3          	csrr	a5,0x7ca
    221c:	c63e                	sw	a5,12(sp)
    221e:	47b2                	lw	a5,12(sp)

00002220 <.LBE52>:
    2220:	0001                	nop

00002222 <.LBE50>:
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
    2222:	8b89                	and	a5,a5,2
    2224:	00f037b3          	snez	a5,a5
    2228:	0ff7f793          	zext.b	a5,a5

0000222c <.LBE48>:
    if (!l1c_dc_is_enabled()) {
    222c:	0017c793          	xor	a5,a5,1
    2230:	0ff7f793          	zext.b	a5,a5
    2234:	c791                	beqz	a5,2240 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
    2236:	2061                	jal	22be <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
    2238:	40200793          	li	a5,1026
    223c:	7ca7a073          	csrs	0x7ca,a5

00002240 <.L11>:
    }
}
    2240:	0001                	nop
    2242:	40f2                	lw	ra,28(sp)
    2244:	6105                	add	sp,sp,32
    2246:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

00002248 <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
    2248:	1141                	add	sp,sp,-16

0000224a <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
    224a:	7ca027f3          	csrr	a5,0x7ca
    224e:	c63e                	sw	a5,12(sp)
    2250:	47b2                	lw	a5,12(sp)

00002252 <.LBE62>:
    2252:	0001                	nop

00002254 <.LBE60>:
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
    2254:	8b85                	and	a5,a5,1
    2256:	00f037b3          	snez	a5,a5
    225a:	0ff7f793          	zext.b	a5,a5

0000225e <.LBE58>:
    if (!l1c_ic_is_enabled()) {
    225e:	0017c793          	xor	a5,a5,1
    2262:	0ff7f793          	zext.b	a5,a5
    2266:	c789                	beqz	a5,2270 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
    2268:	30100793          	li	a5,769
    226c:	7ca7a073          	csrs	0x7ca,a5

00002270 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
    2270:	0001                	nop
    2272:	0141                	add	sp,sp,16
    2274:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate:

00002276 <l1c_dc_invalidate>:
    ASSERT_ADDR_SIZE(address, size);
    l1c_op(HPM_L1C_CCTL_CMD_L1D_VA_UNLOCK, address, size);
}

void l1c_dc_invalidate(uint32_t address, uint32_t size)
{
    2276:	1101                	add	sp,sp,-32
    2278:	ce06                	sw	ra,28(sp)
    227a:	c62a                	sw	a0,12(sp)
    227c:	c42e                	sw	a1,8(sp)
    ASSERT_ADDR_SIZE(address, size);
    227e:	47b2                	lw	a5,12(sp)
    2280:	03f7f793          	and	a5,a5,63
    2284:	cb89                	beqz	a5,2296 <.L38>
    2286:	06900613          	li	a2,105
    228a:	04020593          	add	a1,tp,64 # 40 <__SEGGER_init_done>
    228e:	08820513          	add	a0,tp,136 # 88 <rom_xpi_nor_erase_block+0x26>
    2292:	7b6030ef          	jal	5a48 <__SEGGER_RTL_X_assert>

00002296 <.L38>:
    2296:	47a2                	lw	a5,8(sp)
    2298:	03f7f793          	and	a5,a5,63
    229c:	cb89                	beqz	a5,22ae <.L39>
    229e:	06900613          	li	a2,105
    22a2:	04020593          	add	a1,tp,64 # 40 <__SEGGER_init_done>
    22a6:	0b020513          	add	a0,tp,176 # b0 <rom_xpi_nor_erase_chip+0x14>
    22aa:	79e030ef          	jal	5a48 <__SEGGER_RTL_X_assert>

000022ae <.L39>:
    l1c_op(HPM_L1C_CCTL_CMD_L1D_VA_INVAL, address, size);
    22ae:	4622                	lw	a2,8(sp)
    22b0:	45b2                	lw	a1,12(sp)
    22b2:	4501                	li	a0,0
    22b4:	3739                	jal	21c2 <l1c_op>
}
    22b6:	0001                	nop
    22b8:	40f2                	lw	ra,28(sp)
    22ba:	6105                	add	sp,sp,32
    22bc:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

000022be <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
    22be:	6799                	lui	a5,0x6
    22c0:	7ca7a073          	csrs	0x7ca,a5
}
    22c4:	0001                	nop
    22c6:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

000022c8 <sysctl_clock_set_preset>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr, sysctl_preset_t preset)
{
    22c8:	1141                	add	sp,sp,-16
    22ca:	c62a                	sw	a0,12(sp)
    22cc:	87ae                	mv	a5,a1
    22ce:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_MUX_MASK) | SYSCTL_GLOBAL00_MUX_SET(preset);
    22d2:	4732                	lw	a4,12(sp)
    22d4:	6789                	lui	a5,0x2
    22d6:	97ba                	add	a5,a5,a4
    22d8:	439c                	lw	a5,0(a5)
    22da:	f007f713          	and	a4,a5,-256
    22de:	00b14783          	lbu	a5,11(sp)
    22e2:	8f5d                	or	a4,a4,a5
    22e4:	46b2                	lw	a3,12(sp)
    22e6:	6789                	lui	a5,0x2
    22e8:	97b6                	add	a5,a5,a3
    22ea:	c398                	sw	a4,0(a5)
}
    22ec:	0001                	nop
    22ee:	0141                	add	sp,sp,16
    22f0:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_set_rampup_time:

000022f2 <pllctlv2_xtal_set_rampup_time>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] rc24m_cycles Number of RC24M clock cycles for the ramp-up period
 * @note The ramp-up time affects how quickly the crystal oscillator reaches stable operation
 */
static inline void pllctlv2_xtal_set_rampup_time(PLLCTLV2_Type *ptr, uint32_t rc24m_cycles)
{
    22f2:	1141                	add	sp,sp,-16
    22f4:	c62a                	sw	a0,12(sp)
    22f6:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTLV2_XTAL_RAMP_TIME_MASK) | PLLCTLV2_XTAL_RAMP_TIME_SET(rc24m_cycles);
    22f8:	47b2                	lw	a5,12(sp)
    22fa:	4398                	lw	a4,0(a5)
    22fc:	fff007b7          	lui	a5,0xfff00
    2300:	8f7d                	and	a4,a4,a5
    2302:	46a2                	lw	a3,8(sp)
    2304:	001007b7          	lui	a5,0x100
    2308:	17fd                	add	a5,a5,-1 # fffff <__AXI_SRAM_segment_size__+0x7ffff>
    230a:	8ff5                	and	a5,a5,a3
    230c:	8f5d                	or	a4,a4,a5
    230e:	47b2                	lw	a5,12(sp)
    2310:	c398                	sw	a4,0(a5)
}
    2312:	0001                	nop
    2314:	0141                	add	sp,sp,16
    2316:	8082                	ret

Disassembly of section .text.board_print_banner:

00002318 <board_print_banner>:
{
    2318:	d8010113          	add	sp,sp,-640
    231c:	26112e23          	sw	ra,636(sp)
    const uint8_t banner[] = { "\n\
    2320:	1c820713          	add	a4,tp,456 # 1c8 <__SEGGER_RTL_ipow10+0x80>
    2324:	878a                	mv	a5,sp
    2326:	86ba                	mv	a3,a4
    2328:	26f00713          	li	a4,623
    232c:	863a                	mv	a2,a4
    232e:	85b6                	mv	a1,a3
    2330:	853e                	mv	a0,a5
    2332:	231010ef          	jal	3d62 <memcpy>
    printf("%s", banner);
    2336:	878a                	mv	a5,sp
    2338:	85be                	mv	a1,a5
    233a:	1c420513          	add	a0,tp,452 # 1c4 <__SEGGER_RTL_ipow10+0x7c>
    233e:	3a7010ef          	jal	3ee4 <printf>
}
    2342:	0001                	nop
    2344:	27c12083          	lw	ra,636(sp)
    2348:	28010113          	add	sp,sp,640
    234c:	8082                	ret

Disassembly of section .text.board_init_pmp:

0000234e <board_init_pmp>:
        }
    }
}

void board_init_pmp(void)
{
    234e:	712d                	add	sp,sp,-288
    2350:	10112e23          	sw	ra,284(sp)
    uint32_t start_addr;
    uint32_t end_addr;
    uint32_t length;
    pmp_entry_t pmp_entry[16];
    uint8_t index = 0;
    2354:	100107a3          	sb	zero,271(sp)

    /* Init noncachable memory */
    extern uint32_t __noncacheable_start__[];
    extern uint32_t __noncacheable_end__[];
    start_addr = (uint32_t) __noncacheable_start__;
    2358:	012807b7          	lui	a5,0x1280
    235c:	00078793          	mv	a5,a5
    2360:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t) __noncacheable_end__;
    2364:	012c07b7          	lui	a5,0x12c0
    2368:	00078793          	mv	a5,a5
    236c:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
    2370:	10412703          	lw	a4,260(sp)
    2374:	10812783          	lw	a5,264(sp)
    2378:	40f707b3          	sub	a5,a4,a5
    237c:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
    2380:	10012783          	lw	a5,256(sp)
    2384:	cbe1                	beqz	a5,2454 <.L124>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
    2386:	10012783          	lw	a5,256(sp)
    238a:	fff78713          	add	a4,a5,-1 # 12bffff <__AXI_SRAM_segment_end__+0x3ffff>
    238e:	10012783          	lw	a5,256(sp)
    2392:	8ff9                	and	a5,a5,a4
    2394:	cb89                	beqz	a5,23a6 <.L125>
    2396:	1fe00613          	li	a2,510
    239a:	4d420593          	add	a1,tp,1236 # 4d4 <__vector_table+0xd4>
    239e:	51820513          	add	a0,tp,1304 # 518 <__vector_table+0x118>
    23a2:	6a6030ef          	jal	5a48 <__SEGGER_RTL_X_assert>

000023a6 <.L125>:
        assert((start_addr & (length - 1U)) == 0U);
    23a6:	10012783          	lw	a5,256(sp)
    23aa:	fff78713          	add	a4,a5,-1
    23ae:	10812783          	lw	a5,264(sp)
    23b2:	8ff9                	and	a5,a5,a4
    23b4:	cb89                	beqz	a5,23c6 <.L126>
    23b6:	1ff00613          	li	a2,511
    23ba:	4d420593          	add	a1,tp,1236 # 4d4 <__vector_table+0xd4>
    23be:	53820513          	add	a0,tp,1336 # 538 <__vector_table+0x138>
    23c2:	686030ef          	jal	5a48 <__SEGGER_RTL_X_assert>

000023c6 <.L126>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
    23c6:	10812783          	lw	a5,264(sp)
    23ca:	0027d713          	srl	a4,a5,0x2
    23ce:	10012783          	lw	a5,256(sp)
    23d2:	17fd                	add	a5,a5,-1
    23d4:	838d                	srl	a5,a5,0x3
    23d6:	00f766b3          	or	a3,a4,a5
    23da:	10012783          	lw	a5,256(sp)
    23de:	838d                	srl	a5,a5,0x3
    23e0:	fff7c713          	not	a4,a5
    23e4:	10f14783          	lbu	a5,271(sp)
    23e8:	8f75                	and	a4,a4,a3
    23ea:	0792                	sll	a5,a5,0x4
    23ec:	11078793          	add	a5,a5,272
    23f0:	978a                	add	a5,a5,sp
    23f2:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
    23f6:	10f14783          	lbu	a5,271(sp)
    23fa:	0792                	sll	a5,a5,0x4
    23fc:	11078793          	add	a5,a5,272
    2400:	978a                	add	a5,a5,sp
    2402:	477d                	li	a4,31
    2404:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
    2408:	10812783          	lw	a5,264(sp)
    240c:	0027d713          	srl	a4,a5,0x2
    2410:	10012783          	lw	a5,256(sp)
    2414:	17fd                	add	a5,a5,-1
    2416:	838d                	srl	a5,a5,0x3
    2418:	00f766b3          	or	a3,a4,a5
    241c:	10012783          	lw	a5,256(sp)
    2420:	838d                	srl	a5,a5,0x3
    2422:	fff7c713          	not	a4,a5
    2426:	10f14783          	lbu	a5,271(sp)
    242a:	8f75                	and	a4,a4,a3
    242c:	0792                	sll	a5,a5,0x4
    242e:	11078793          	add	a5,a5,272
    2432:	978a                	add	a5,a5,sp
    2434:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
    2438:	10f14783          	lbu	a5,271(sp)
    243c:	0792                	sll	a5,a5,0x4
    243e:	11078793          	add	a5,a5,272
    2442:	978a                	add	a5,a5,sp
    2444:	473d                	li	a4,15
    2446:	eee78c23          	sb	a4,-264(a5)
        index++;
    244a:	10f14783          	lbu	a5,271(sp)
    244e:	0785                	add	a5,a5,1
    2450:	10f107a3          	sb	a5,271(sp)

00002454 <.L124>:
    }

    /* Init share memory */
    extern uint32_t __share_mem_start__[];
    extern uint32_t __share_mem_end__[];
    start_addr = (uint32_t)__share_mem_start__;
    2454:	012fc7b7          	lui	a5,0x12fc
    2458:	00078793          	mv	a5,a5
    245c:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t)__share_mem_end__;
    2460:	013007b7          	lui	a5,0x1300
    2464:	00078793          	mv	a5,a5
    2468:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
    246c:	10412703          	lw	a4,260(sp)
    2470:	10812783          	lw	a5,264(sp)
    2474:	40f707b3          	sub	a5,a4,a5
    2478:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
    247c:	10012783          	lw	a5,256(sp)
    2480:	cbe1                	beqz	a5,2550 <.L127>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
    2482:	10012783          	lw	a5,256(sp)
    2486:	fff78713          	add	a4,a5,-1 # 12fffff <__SHARE_RAM_segment_start__+0x3fff>
    248a:	10012783          	lw	a5,256(sp)
    248e:	8ff9                	and	a5,a5,a4
    2490:	cb89                	beqz	a5,24a2 <.L128>
    2492:	20f00613          	li	a2,527
    2496:	4d420593          	add	a1,tp,1236 # 4d4 <__vector_table+0xd4>
    249a:	51820513          	add	a0,tp,1304 # 518 <__vector_table+0x118>
    249e:	5aa030ef          	jal	5a48 <__SEGGER_RTL_X_assert>

000024a2 <.L128>:
        assert((start_addr & (length - 1U)) == 0U);
    24a2:	10012783          	lw	a5,256(sp)
    24a6:	fff78713          	add	a4,a5,-1
    24aa:	10812783          	lw	a5,264(sp)
    24ae:	8ff9                	and	a5,a5,a4
    24b0:	cb89                	beqz	a5,24c2 <.L129>
    24b2:	21000613          	li	a2,528
    24b6:	4d420593          	add	a1,tp,1236 # 4d4 <__vector_table+0xd4>
    24ba:	53820513          	add	a0,tp,1336 # 538 <__vector_table+0x138>
    24be:	58a030ef          	jal	5a48 <__SEGGER_RTL_X_assert>

000024c2 <.L129>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
    24c2:	10812783          	lw	a5,264(sp)
    24c6:	0027d713          	srl	a4,a5,0x2
    24ca:	10012783          	lw	a5,256(sp)
    24ce:	17fd                	add	a5,a5,-1
    24d0:	838d                	srl	a5,a5,0x3
    24d2:	00f766b3          	or	a3,a4,a5
    24d6:	10012783          	lw	a5,256(sp)
    24da:	838d                	srl	a5,a5,0x3
    24dc:	fff7c713          	not	a4,a5
    24e0:	10f14783          	lbu	a5,271(sp)
    24e4:	8f75                	and	a4,a4,a3
    24e6:	0792                	sll	a5,a5,0x4
    24e8:	11078793          	add	a5,a5,272
    24ec:	978a                	add	a5,a5,sp
    24ee:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
    24f2:	10f14783          	lbu	a5,271(sp)
    24f6:	0792                	sll	a5,a5,0x4
    24f8:	11078793          	add	a5,a5,272
    24fc:	978a                	add	a5,a5,sp
    24fe:	477d                	li	a4,31
    2500:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
    2504:	10812783          	lw	a5,264(sp)
    2508:	0027d713          	srl	a4,a5,0x2
    250c:	10012783          	lw	a5,256(sp)
    2510:	17fd                	add	a5,a5,-1
    2512:	838d                	srl	a5,a5,0x3
    2514:	00f766b3          	or	a3,a4,a5
    2518:	10012783          	lw	a5,256(sp)
    251c:	838d                	srl	a5,a5,0x3
    251e:	fff7c713          	not	a4,a5
    2522:	10f14783          	lbu	a5,271(sp)
    2526:	8f75                	and	a4,a4,a3
    2528:	0792                	sll	a5,a5,0x4
    252a:	11078793          	add	a5,a5,272
    252e:	978a                	add	a5,a5,sp
    2530:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
    2534:	10f14783          	lbu	a5,271(sp)
    2538:	0792                	sll	a5,a5,0x4
    253a:	11078793          	add	a5,a5,272
    253e:	978a                	add	a5,a5,sp
    2540:	473d                	li	a4,15
    2542:	eee78c23          	sb	a4,-264(a5)
        index++;
    2546:	10f14783          	lbu	a5,271(sp)
    254a:	0785                	add	a5,a5,1
    254c:	10f107a3          	sb	a5,271(sp)

00002550 <.L127>:
    }

    pmp_config(&pmp_entry[0], index);
    2550:	10f14703          	lbu	a4,271(sp)
    2554:	878a                	mv	a5,sp
    2556:	85ba                	mv	a1,a4
    2558:	853e                	mv	a0,a5
    255a:	2791                	jal	2c9e <pmp_config>
}
    255c:	0001                	nop
    255e:	11c12083          	lw	ra,284(sp)
    2562:	6115                	add	sp,sp,288
    2564:	8082                	ret

Disassembly of section .text.board_init_clock:

00002566 <board_init_clock>:

void board_init_clock(void)
{
    2566:	1101                	add	sp,sp,-32
    2568:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
    256a:	4501                	li	a0,0
    256c:	70c020ef          	jal	4c78 <clock_get_frequency>
    2570:	c62a                	sw	a0,12(sp)
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
    2572:	4732                	lw	a4,12(sp)
    2574:	016e37b7          	lui	a5,0x16e3
    2578:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
    257c:	00f71d63          	bne	a4,a5,2596 <.L131>
        /* Configure the External OSC ramp-up time: ~9ms */
        pllctlv2_xtal_set_rampup_time(HPM_PLLCTLV2, 32ul * 1000ul * 9u);
    2580:	000467b7          	lui	a5,0x46
    2584:	50078593          	add	a1,a5,1280 # 46500 <__DLM_segment_size__+0x6500>
    2588:	f40c0537          	lui	a0,0xf40c0
    258c:	339d                	jal	22f2 <pllctlv2_xtal_set_rampup_time>

        /* select clock setting preset1 */
        sysctl_clock_set_preset(HPM_SYSCTL, 2);
    258e:	4589                	li	a1,2
    2590:	f4000537          	lui	a0,0xf4000
    2594:	3b15                	jal	22c8 <sysctl_clock_set_preset>

00002596 <.L131>:
    }
    /* Add Clocks to group 0 */
    clock_add_to_group(clock_cpu0, 0);
    2596:	4581                	li	a1,0
    2598:	4501                	li	a0,0
    259a:	3e55                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
    259c:	4581                	li	a1,0
    259e:	010607b7          	lui	a5,0x1060
    25a2:	00178513          	add	a0,a5,1 # 1060001 <_flash_size+0x60001>
    25a6:	3665                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_ahb0, 0);
    25a8:	4581                	li	a1,0
    25aa:	010007b7          	lui	a5,0x1000
    25ae:	00478513          	add	a0,a5,4 # 1000004 <_flash_size+0x4>
    25b2:	3e71                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_axif, 0);
    25b4:	4581                	li	a1,0
    25b6:	77c1                	lui	a5,0xffff0
    25b8:	00578513          	add	a0,a5,5 # ffff0005 <__AHB_SRAM_segment_end__+0xfde8005>
    25bc:	3e49                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_axis, 0);
    25be:	4581                	li	a1,0
    25c0:	010107b7          	lui	a5,0x1010
    25c4:	00678513          	add	a0,a5,6 # 1010006 <_flash_size+0x10006>
    25c8:	3659                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_axic, 0);
    25ca:	4581                	li	a1,0
    25cc:	010207b7          	lui	a5,0x1020
    25d0:	00778513          	add	a0,a5,7 # 1020007 <_flash_size+0x20007>
    25d4:	3ead                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_axin, 0);
    25d6:	4581                	li	a1,0
    25d8:	010307b7          	lui	a5,0x1030
    25dc:	00878513          	add	a0,a5,8 # 1030008 <_flash_size+0x30008>
    25e0:	36bd                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_rom0, 0);
    25e2:	4581                	li	a1,0
    25e4:	010407b7          	lui	a5,0x1040
    25e8:	60678513          	add	a0,a5,1542 # 1040606 <_flash_size+0x40606>
    25ec:	368d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
    25ee:	4581                	li	a1,0
    25f0:	016f07b7          	lui	a5,0x16f0
    25f4:	03f78513          	add	a0,a5,63 # 16f003f <__SHARE_RAM_segment_end__+0x3f003f>
    25f8:	3e99                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
    25fa:	4581                	li	a1,0
    25fc:	010517b7          	lui	a5,0x1051
    2600:	b0078513          	add	a0,a5,-1280 # 1050b00 <_flash_size+0x50b00>
    2604:	36a9                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_lmm1, 0);
    2606:	4581                	li	a1,0
    2608:	010517b7          	lui	a5,0x1051
    260c:	c0078513          	add	a0,a5,-1024 # 1050c00 <_flash_size+0x50c00>
    2610:	3e3d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_ram0, 0);
    2612:	4581                	li	a1,0
    2614:	017107b7          	lui	a5,0x1710
    2618:	50078513          	add	a0,a5,1280 # 1710500 <__SHARE_RAM_segment_end__+0x410500>
    261c:	3e0d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_ram1, 0);
    261e:	4581                	li	a1,0
    2620:	017207b7          	lui	a5,0x1720
    2624:	50178513          	add	a0,a5,1281 # 1720501 <__SHARE_RAM_segment_end__+0x420501>
    2628:	361d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
    262a:	4581                	li	a1,0
    262c:	013b07b7          	lui	a5,0x13b0
    2630:	40078513          	add	a0,a5,1024 # 13b0400 <__SHARE_RAM_segment_end__+0xb0400>
    2634:	3e29                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_xdma, 0);
    2636:	4581                	li	a1,0
    2638:	017307b7          	lui	a5,0x1730
    263c:	60478513          	add	a0,a5,1540 # 1730604 <__SHARE_RAM_segment_end__+0x430604>
    2640:	3639                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
    2642:	4581                	li	a1,0
    2644:	013907b7          	lui	a5,0x1390
    2648:	40078513          	add	a0,a5,1024 # 1390400 <__SHARE_RAM_segment_end__+0x90400>
    264c:	3609                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
    264e:	4581                	li	a1,0
    2650:	015107b7          	lui	a5,0x1510
    2654:	40078513          	add	a0,a5,1024 # 1510400 <__SHARE_RAM_segment_end__+0x210400>
    2658:	3cdd                	jal	214e <clock_add_to_group>
    /* Motor Related */
    clock_add_to_group(clock_qei0, 0);
    265a:	4581                	li	a1,0
    265c:	015207b7          	lui	a5,0x1520
    2660:	40078513          	add	a0,a5,1024 # 1520400 <__SHARE_RAM_segment_end__+0x220400>
    2664:	34ed                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_qei1, 0);
    2666:	4581                	li	a1,0
    2668:	015307b7          	lui	a5,0x1530
    266c:	40078513          	add	a0,a5,1024 # 1530400 <__SHARE_RAM_segment_end__+0x230400>
    2670:	3cf9                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_qei2, 0);
    2672:	4581                	li	a1,0
    2674:	015407b7          	lui	a5,0x1540
    2678:	40078513          	add	a0,a5,1024 # 1540400 <__SHARE_RAM_segment_end__+0x240400>
    267c:	3cc9                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_qei3, 0);
    267e:	4581                	li	a1,0
    2680:	015507b7          	lui	a5,0x1550
    2684:	40078513          	add	a0,a5,1024 # 1550400 <__SHARE_RAM_segment_end__+0x250400>
    2688:	34d9                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_qeo0, 0);
    268a:	4581                	li	a1,0
    268c:	015607b7          	lui	a5,0x1560
    2690:	40078513          	add	a0,a5,1024 # 1560400 <__SHARE_RAM_segment_end__+0x260400>
    2694:	3c6d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_qeo1, 0);
    2696:	4581                	li	a1,0
    2698:	015707b7          	lui	a5,0x1570
    269c:	40078513          	add	a0,a5,1024 # 1570400 <__SHARE_RAM_segment_end__+0x270400>
    26a0:	347d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_qeo2, 0);
    26a2:	4581                	li	a1,0
    26a4:	015807b7          	lui	a5,0x1580
    26a8:	40078513          	add	a0,a5,1024 # 1580400 <__SHARE_RAM_segment_end__+0x280400>
    26ac:	344d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_qeo3, 0);
    26ae:	4581                	li	a1,0
    26b0:	015907b7          	lui	a5,0x1590
    26b4:	40078513          	add	a0,a5,1024 # 1590400 <__SHARE_RAM_segment_end__+0x290400>
    26b8:	3c59                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_pwm0, 0);
    26ba:	4581                	li	a1,0
    26bc:	015a07b7          	lui	a5,0x15a0
    26c0:	40078513          	add	a0,a5,1024 # 15a0400 <__SHARE_RAM_segment_end__+0x2a0400>
    26c4:	3469                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_pwm1, 0);
    26c6:	4581                	li	a1,0
    26c8:	015b07b7          	lui	a5,0x15b0
    26cc:	40078513          	add	a0,a5,1024 # 15b0400 <__SHARE_RAM_segment_end__+0x2b0400>
    26d0:	3cbd                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_pwm2, 0);
    26d2:	4581                	li	a1,0
    26d4:	015c07b7          	lui	a5,0x15c0
    26d8:	40078513          	add	a0,a5,1024 # 15c0400 <__SHARE_RAM_segment_end__+0x2c0400>
    26dc:	3c8d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_pwm3, 0);
    26de:	4581                	li	a1,0
    26e0:	015d07b7          	lui	a5,0x15d0
    26e4:	40078513          	add	a0,a5,1024 # 15d0400 <__SHARE_RAM_segment_end__+0x2d0400>
    26e8:	349d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_rdc0, 0);
    26ea:	4581                	li	a1,0
    26ec:	015e07b7          	lui	a5,0x15e0
    26f0:	40078513          	add	a0,a5,1024 # 15e0400 <__SHARE_RAM_segment_end__+0x2e0400>
    26f4:	3ca9                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_rdc1, 0);
    26f6:	4581                	li	a1,0
    26f8:	015f07b7          	lui	a5,0x15f0
    26fc:	40078513          	add	a0,a5,1024 # 15f0400 <__SHARE_RAM_segment_end__+0x2f0400>
    2700:	34b9                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_plb0, 0);
    2702:	4581                	li	a1,0
    2704:	016207b7          	lui	a5,0x1620
    2708:	40078513          	add	a0,a5,1024 # 1620400 <__SHARE_RAM_segment_end__+0x320400>
    270c:	3489                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_sei0, 0);
    270e:	4581                	li	a1,0
    2710:	016307b7          	lui	a5,0x1630
    2714:	40078513          	add	a0,a5,1024 # 1630400 <__SHARE_RAM_segment_end__+0x330400>
    2718:	3c1d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_mtg0, 0);
    271a:	4581                	li	a1,0
    271c:	016407b7          	lui	a5,0x1640
    2720:	40078513          	add	a0,a5,1024 # 1640400 <__SHARE_RAM_segment_end__+0x340400>
    2724:	342d                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_mtg1, 0);
    2726:	4581                	li	a1,0
    2728:	016507b7          	lui	a5,0x1650
    272c:	40078513          	add	a0,a5,1024 # 1650400 <__SHARE_RAM_segment_end__+0x350400>
    2730:	3c39                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_vsc0, 0);
    2732:	4581                	li	a1,0
    2734:	016607b7          	lui	a5,0x1660
    2738:	40078513          	add	a0,a5,1024 # 1660400 <__SHARE_RAM_segment_end__+0x360400>
    273c:	3c09                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_vsc1, 0);
    273e:	4581                	li	a1,0
    2740:	016707b7          	lui	a5,0x1670
    2744:	40078513          	add	a0,a5,1024 # 1670400 <__SHARE_RAM_segment_end__+0x370400>
    2748:	3419                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_clc0, 0);
    274a:	4581                	li	a1,0
    274c:	016807b7          	lui	a5,0x1680
    2750:	40078513          	add	a0,a5,1024 # 1680400 <__SHARE_RAM_segment_end__+0x380400>
    2754:	3aed                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_clc1, 0);
    2756:	4581                	li	a1,0
    2758:	016907b7          	lui	a5,0x1690
    275c:	40078513          	add	a0,a5,1024 # 1690400 <__SHARE_RAM_segment_end__+0x390400>
    2760:	32fd                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_emds, 0);
    2762:	4581                	li	a1,0
    2764:	016a07b7          	lui	a5,0x16a0
    2768:	40078513          	add	a0,a5,1024 # 16a0400 <__SHARE_RAM_segment_end__+0x3a0400>
    276c:	32cd                	jal	214e <clock_add_to_group>
    /* Connect Group0 to CPU0 */
    clock_connect_group_to_cpu(0, 0);
    276e:	4581                	li	a1,0
    2770:	4501                	li	a0,0
    2772:	7ac020ef          	jal	4f1e <clock_connect_group_to_cpu>

    /* Add the CPU1 clock to Group1 */
    clock_add_to_group(clock_cpu1, 1);
    2776:	4585                	li	a1,1
    2778:	000807b7          	lui	a5,0x80
    277c:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
    2780:	32f9                	jal	214e <clock_add_to_group>
    clock_add_to_group(clock_mchtmr1, 1);
    2782:	4585                	li	a1,1
    2784:	010807b7          	lui	a5,0x1080
    2788:	00378513          	add	a0,a5,3 # 1080003 <_flash_size+0x80003>
    278c:	32c9                	jal	214e <clock_add_to_group>
    /* Connect Group1 to CPU1 */
    clock_connect_group_to_cpu(1, 1);
    278e:	4585                	li	a1,1
    2790:	4505                	li	a0,1
    2792:	78c020ef          	jal	4f1e <clock_connect_group_to_cpu>

    /* Bump up DCDC voltage to 1275mv */
    pcfg_dcdc_set_voltage(HPM_PCFG, 1275);
    2796:	4fb00593          	li	a1,1275
    279a:	f4104537          	lui	a0,0xf4104
    279e:	0b4030ef          	jal	5852 <pcfg_dcdc_set_voltage>

    /* Set CPU clock to 600MHz */
    clock_set_source_divider(clock_cpu0, clk_src_pll0_clk0, 1);
    27a2:	4605                	li	a2,1
    27a4:	4585                	li	a1,1
    27a6:	4501                	li	a0,0
    27a8:	692020ef          	jal	4e3a <clock_set_source_divider>
    clock_set_source_divider(clock_cpu1, clk_src_pll0_clk0, 1);
    27ac:	4605                	li	a2,1
    27ae:	4585                	li	a1,1
    27b0:	000807b7          	lui	a5,0x80
    27b4:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
    27b8:	682020ef          	jal	4e3a <clock_set_source_divider>

    /* Configure mchtmr to 24MHz */
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
    27bc:	4605                	li	a2,1
    27be:	4581                	li	a1,0
    27c0:	010607b7          	lui	a5,0x1060
    27c4:	00178513          	add	a0,a5,1 # 1060001 <_flash_size+0x60001>
    27c8:	672020ef          	jal	4e3a <clock_set_source_divider>
    clock_set_source_divider(clock_mchtmr1, clk_src_osc24m, 1);
    27cc:	4605                	li	a2,1
    27ce:	4581                	li	a1,0
    27d0:	010807b7          	lui	a5,0x1080
    27d4:	00378513          	add	a0,a5,3 # 1080003 <_flash_size+0x80003>
    27d8:	662020ef          	jal	4e3a <clock_set_source_divider>

    clock_update_core_clock();
    27dc:	3275                	jal	2188 <clock_update_core_clock>
}
    27de:	0001                	nop
    27e0:	40f2                	lw	ra,28(sp)
    27e2:	6105                	add	sp,sp,32
    27e4:	8082                	ret

Disassembly of section .text.uart_init:

000027e6 <uart_init>:
    }
    return false;
}

hpm_stat_t uart_init(UART_Type *ptr, uart_config_t *config)
{
    27e6:	7179                	add	sp,sp,-48
    27e8:	d606                	sw	ra,44(sp)
    27ea:	c62a                	sw	a0,12(sp)
    27ec:	c42e                	sw	a1,8(sp)
    uint32_t tmp;
    uint8_t osc;
    uint16_t div;

    /* disable all interrupts */
    ptr->IER = 0;
    27ee:	47b2                	lw	a5,12(sp)
    27f0:	0207a223          	sw	zero,36(a5)
    /* Set DLAB to 1 */
    ptr->LCR |= UART_LCR_DLAB_MASK;
    27f4:	47b2                	lw	a5,12(sp)
    27f6:	57dc                	lw	a5,44(a5)
    27f8:	0807e713          	or	a4,a5,128
    27fc:	47b2                	lw	a5,12(sp)
    27fe:	d7d8                	sw	a4,44(a5)

    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
    2800:	47a2                	lw	a5,8(sp)
    2802:	4398                	lw	a4,0(a5)
    2804:	47a2                	lw	a5,8(sp)
    2806:	43dc                	lw	a5,4(a5)
    2808:	01b10693          	add	a3,sp,27
    280c:	0830                	add	a2,sp,24
    280e:	85be                	mv	a1,a5
    2810:	853a                	mv	a0,a4
    2812:	395020ef          	jal	53a6 <uart_calculate_baudrate>
    2816:	87aa                	mv	a5,a0
    2818:	0017c793          	xor	a5,a5,1
    281c:	0ff7f793          	zext.b	a5,a5
    2820:	c781                	beqz	a5,2828 <.L26>
        return status_uart_no_suitable_baudrate_parameter_found;
    2822:	3e900793          	li	a5,1001
    2826:	a251                	j	29aa <.L43>

00002828 <.L26>:
    }

    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
    2828:	47b2                	lw	a5,12(sp)
    282a:	4bdc                	lw	a5,20(a5)
    282c:	fe07f713          	and	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
    2830:	01b14783          	lbu	a5,27(sp)
    2834:	8bfd                	and	a5,a5,31
    2836:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
    2838:	47b2                	lw	a5,12(sp)
    283a:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
    283c:	01815783          	lhu	a5,24(sp)
    2840:	0ff7f713          	zext.b	a4,a5
    2844:	47b2                	lw	a5,12(sp)
    2846:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
    2848:	01815783          	lhu	a5,24(sp)
    284c:	83a1                	srl	a5,a5,0x8
    284e:	0807c7b3          	zext.h	a5,a5
    2852:	0ff7f713          	zext.b	a4,a5
    2856:	47b2                	lw	a5,12(sp)
    2858:	d3d8                	sw	a4,36(a5)

    /* DLAB bit needs to be cleared once baudrate is configured */
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
    285a:	47b2                	lw	a5,12(sp)
    285c:	57dc                	lw	a5,44(a5)
    285e:	f7f7f793          	and	a5,a5,-129
    2862:	ce3e                	sw	a5,28(sp)

    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
    2864:	47f2                	lw	a5,28(sp)
    2866:	fc77f793          	and	a5,a5,-57
    286a:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
    286c:	47a2                	lw	a5,8(sp)
    286e:	00a7c783          	lbu	a5,10(a5)
    2872:	4711                	li	a4,4
    2874:	02f76d63          	bltu	a4,a5,28ae <.L28>
    2878:	00279713          	sll	a4,a5,0x2
    287c:	95818793          	add	a5,gp,-1704 # 2c8 <.L30>
    2880:	97ba                	add	a5,a5,a4
    2882:	439c                	lw	a5,0(a5)
    2884:	8782                	jr	a5

00002886 <.L33>:
    case parity_none:
        break;
    case parity_odd:
        tmp |= UART_LCR_PEN_MASK;
    2886:	47f2                	lw	a5,28(sp)
    2888:	0087e793          	or	a5,a5,8
    288c:	ce3e                	sw	a5,28(sp)
        break;
    288e:	a01d                	j	28b4 <.L35>

00002890 <.L32>:
    case parity_even:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
    2890:	47f2                	lw	a5,28(sp)
    2892:	0187e793          	or	a5,a5,24
    2896:	ce3e                	sw	a5,28(sp)
        break;
    2898:	a831                	j	28b4 <.L35>

0000289a <.L31>:
    case parity_always_1:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
    289a:	47f2                	lw	a5,28(sp)
    289c:	0287e793          	or	a5,a5,40
    28a0:	ce3e                	sw	a5,28(sp)
        break;
    28a2:	a809                	j	28b4 <.L35>

000028a4 <.L29>:
    case parity_always_0:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
    28a4:	47f2                	lw	a5,28(sp)
    28a6:	0387e793          	or	a5,a5,56
    28aa:	ce3e                	sw	a5,28(sp)
            | UART_LCR_SPS_MASK;
        break;
    28ac:	a021                	j	28b4 <.L35>

000028ae <.L28>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
    28ae:	4789                	li	a5,2
    28b0:	a8ed                	j	29aa <.L43>

000028b2 <.L44>:
        break;
    28b2:	0001                	nop

000028b4 <.L35>:
    }

    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
    28b4:	47f2                	lw	a5,28(sp)
    28b6:	9be1                	and	a5,a5,-8
    28b8:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
    28ba:	47a2                	lw	a5,8(sp)
    28bc:	0087c783          	lbu	a5,8(a5)
    28c0:	4709                	li	a4,2
    28c2:	00e78e63          	beq	a5,a4,28de <.L36>
    28c6:	4709                	li	a4,2
    28c8:	02f74663          	blt	a4,a5,28f4 <.L37>
    28cc:	c795                	beqz	a5,28f8 <.L45>
    28ce:	4705                	li	a4,1
    28d0:	02e79263          	bne	a5,a4,28f4 <.L37>
    case stop_bits_1:
        break;
    case stop_bits_1_5:
        tmp |= UART_LCR_STB_MASK;
    28d4:	47f2                	lw	a5,28(sp)
    28d6:	0047e793          	or	a5,a5,4
    28da:	ce3e                	sw	a5,28(sp)
        break;
    28dc:	a839                	j	28fa <.L40>

000028de <.L36>:
    case stop_bits_2:
        if (config->word_length < word_length_6_bits) {
    28de:	47a2                	lw	a5,8(sp)
    28e0:	0097c783          	lbu	a5,9(a5)
    28e4:	e399                	bnez	a5,28ea <.L41>
            /* invalid configuration */
            return status_invalid_argument;
    28e6:	4789                	li	a5,2
    28e8:	a0c9                	j	29aa <.L43>

000028ea <.L41>:
        }
        tmp |= UART_LCR_STB_MASK;
    28ea:	47f2                	lw	a5,28(sp)
    28ec:	0047e793          	or	a5,a5,4
    28f0:	ce3e                	sw	a5,28(sp)
        break;
    28f2:	a021                	j	28fa <.L40>

000028f4 <.L37>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
    28f4:	4789                	li	a5,2
    28f6:	a855                	j	29aa <.L43>

000028f8 <.L45>:
        break;
    28f8:	0001                	nop

000028fa <.L40>:
    }

    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
    28fa:	47a2                	lw	a5,8(sp)
    28fc:	0097c783          	lbu	a5,9(a5)
    2900:	0037f713          	and	a4,a5,3
    2904:	47f2                	lw	a5,28(sp)
    2906:	8f5d                	or	a4,a4,a5
    2908:	47b2                	lw	a5,12(sp)
    290a:	d7d8                	sw	a4,44(a5)

#if defined(HPM_IP_FEATURE_UART_FINE_FIFO_THRLD) && (HPM_IP_FEATURE_UART_FINE_FIFO_THRLD == 1)
    /* reset TX and RX fifo */
    ptr->FCRR = UART_FCRR_TFIFORST_MASK | UART_FCRR_RFIFORST_MASK;
    290c:	47b2                	lw	a5,12(sp)
    290e:	4719                	li	a4,6
    2910:	cf98                	sw	a4,24(a5)
    /* Enable FIFO */
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
        | UART_FCRR_FIFOE_SET(config->fifo_enable)
    2912:	47a2                	lw	a5,8(sp)
    2914:	00e7c783          	lbu	a5,14(a5)
    2918:	86be                	mv	a3,a5
        | UART_FCRR_TFIFOT4_SET(config->tx_fifo_level)
    291a:	47a2                	lw	a5,8(sp)
    291c:	00b7c783          	lbu	a5,11(a5)
    2920:	01079713          	sll	a4,a5,0x10
    2924:	001f07b7          	lui	a5,0x1f0
    2928:	8ff9                	and	a5,a5,a4
    292a:	00f6e733          	or	a4,a3,a5
        | UART_FCRR_RFIFOT4_SET(config->rx_fifo_level)
    292e:	47a2                	lw	a5,8(sp)
    2930:	00c7c783          	lbu	a5,12(a5) # 1f000c <__AXI_SRAM_segment_size__+0x17000c>
    2934:	00879693          	sll	a3,a5,0x8
    2938:	6789                	lui	a5,0x2
    293a:	f0078793          	add	a5,a5,-256 # 1f00 <__SEGGER_RTL_c_locale_month_names+0x1c>
    293e:	8ff5                	and	a5,a5,a3
    2940:	8f5d                	or	a4,a4,a5
#if defined(HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT) && (HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT == 1)
        | UART_FCRR_TMOUT_RXDMA_DIS_MASK /**< disable RX timeout trigger dma */
#endif
        | UART_FCRR_DMAE_SET(config->dma_enable);
    2942:	47a2                	lw	a5,8(sp)
    2944:	00d7c783          	lbu	a5,13(a5)
    2948:	078e                	sll	a5,a5,0x3
    294a:	8ba1                	and	a5,a5,8
    294c:	8f5d                	or	a4,a4,a5
    294e:	008007b7          	lui	a5,0x800
    2952:	8f5d                	or	a4,a4,a5
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
    2954:	47b2                	lw	a5,12(sp)
    2956:	cf98                	sw	a4,24(a5)
    ptr->FCR = tmp;
    /* store FCR register value */
    ptr->GPR = tmp;
#endif

    uart_modem_config(ptr, &config->modem_config);
    2958:	47a2                	lw	a5,8(sp)
    295a:	07bd                	add	a5,a5,15 # 80000f <__DLM_segment_end__+0x5c000f>
    295c:	85be                	mv	a1,a5
    295e:	4532                	lw	a0,12(sp)
    2960:	143020ef          	jal	52a2 <uart_modem_config>

#if defined(HPM_IP_FEATURE_UART_RX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_RX_IDLE_DETECT == 1)
    uart_init_rxline_idle_detection(ptr, config->rxidle_config);
    2964:	47a2                	lw	a5,8(sp)
    2966:	0127d703          	lhu	a4,18(a5)
    296a:	0147d783          	lhu	a5,20(a5)
    296e:	07c2                	sll	a5,a5,0x10
    2970:	8fd9                	or	a5,a5,a4
    2972:	873e                	mv	a4,a5
    2974:	85ba                	mv	a1,a4
    2976:	4532                	lw	a0,12(sp)
    2978:	53b020ef          	jal	56b2 <uart_init_rxline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
    uart_init_txline_idle_detection(ptr, config->txidle_config);
    297c:	47a2                	lw	a5,8(sp)
    297e:	0167d703          	lhu	a4,22(a5)
    2982:	0187d783          	lhu	a5,24(a5)
    2986:	07c2                	sll	a5,a5,0x10
    2988:	8fd9                	or	a5,a5,a4
    298a:	873e                	mv	a4,a5
    298c:	85ba                	mv	a1,a4
    298e:	4532                	lw	a0,12(sp)
    2990:	2885                	jal	2a00 <uart_init_txline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    if (config->rx_enable) {
    2992:	47a2                	lw	a5,8(sp)
    2994:	01a7c783          	lbu	a5,26(a5)
    2998:	cb81                	beqz	a5,29a8 <.L42>
        ptr->IDLE_CFG |= UART_IDLE_CFG_RXEN_MASK;
    299a:	47b2                	lw	a5,12(sp)
    299c:	43d8                	lw	a4,4(a5)
    299e:	28b01793          	bset	a5,zero,0xb
    29a2:	8f5d                	or	a4,a4,a5
    29a4:	47b2                	lw	a5,12(sp)
    29a6:	c3d8                	sw	a4,4(a5)

000029a8 <.L42>:
    }
#endif
    return status_success;
    29a8:	4781                	li	a5,0

000029aa <.L43>:
}
    29aa:	853e                	mv	a0,a5
    29ac:	50b2                	lw	ra,44(sp)
    29ae:	6145                	add	sp,sp,48
    29b0:	8082                	ret

Disassembly of section .text.uart_send_byte:

000029b2 <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
    29b2:	1101                	add	sp,sp,-32
    29b4:	c62a                	sw	a0,12(sp)
    29b6:	87ae                	mv	a5,a1
    29b8:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
    29bc:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
    29be:	a811                	j	29d2 <.L51>

000029c0 <.L54>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
    29c0:	4772                	lw	a4,28(sp)
    29c2:	6785                	lui	a5,0x1
    29c4:	38878793          	add	a5,a5,904 # 1388 <.L45+0x60>
    29c8:	00e7eb63          	bltu	a5,a4,29de <.L57>
            break;
        }
        retry++;
    29cc:	47f2                	lw	a5,28(sp)
    29ce:	0785                	add	a5,a5,1
    29d0:	ce3e                	sw	a5,28(sp)

000029d2 <.L51>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
    29d2:	47b2                	lw	a5,12(sp)
    29d4:	5bdc                	lw	a5,52(a5)
    29d6:	0207f793          	and	a5,a5,32
    29da:	d3fd                	beqz	a5,29c0 <.L54>
    29dc:	a011                	j	29e0 <.L53>

000029de <.L57>:
            break;
    29de:	0001                	nop

000029e0 <.L53>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
    29e0:	4772                	lw	a4,28(sp)
    29e2:	6785                	lui	a5,0x1
    29e4:	38878793          	add	a5,a5,904 # 1388 <.L45+0x60>
    29e8:	00e7f463          	bgeu	a5,a4,29f0 <.L55>
        return status_timeout;
    29ec:	478d                	li	a5,3
    29ee:	a031                	j	29fa <.L56>

000029f0 <.L55>:
    }

    ptr->THR = UART_THR_THR_SET(c);
    29f0:	00b14703          	lbu	a4,11(sp)
    29f4:	47b2                	lw	a5,12(sp)
    29f6:	d398                	sw	a4,32(a5)
    return status_success;
    29f8:	4781                	li	a5,0

000029fa <.L56>:
}
    29fa:	853e                	mv	a0,a5
    29fc:	6105                	add	sp,sp,32
    29fe:	8082                	ret

Disassembly of section .text.uart_init_txline_idle_detection:

00002a00 <uart_init_txline_idle_detection>:
}
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
hpm_stat_t uart_init_txline_idle_detection(UART_Type *ptr, uart_rxline_idle_config_t txidle_config)
{
    2a00:	1101                	add	sp,sp,-32
    2a02:	ce06                	sw	ra,28(sp)
    2a04:	c62a                	sw	a0,12(sp)
    2a06:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_TX_IDLE_EN_MASK
    2a08:	47b2                	lw	a5,12(sp)
    2a0a:	43d8                	lw	a4,4(a5)
    2a0c:	fc0107b7          	lui	a5,0xfc010
    2a10:	17fd                	add	a5,a5,-1 # fc00ffff <__AHB_SRAM_segment_end__+0xbe07fff>
    2a12:	8f7d                	and	a4,a4,a5
    2a14:	47b2                	lw	a5,12(sp)
    2a16:	c3d8                	sw	a4,4(a5)
                    | UART_IDLE_CFG_TX_IDLE_THR_MASK
                    | UART_IDLE_CFG_TX_IDLE_COND_MASK);
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
    2a18:	47b2                	lw	a5,12(sp)
    2a1a:	43d8                	lw	a4,4(a5)
    2a1c:	00814783          	lbu	a5,8(sp)
    2a20:	01879693          	sll	a3,a5,0x18
    2a24:	010007b7          	lui	a5,0x1000
    2a28:	8efd                	and	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_THR_SET(txidle_config.threshold)
    2a2a:	00b14783          	lbu	a5,11(sp)
    2a2e:	01079613          	sll	a2,a5,0x10
    2a32:	00ff07b7          	lui	a5,0xff0
    2a36:	8ff1                	and	a5,a5,a2
    2a38:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_COND_SET(txidle_config.idle_cond);
    2a3a:	00a14783          	lbu	a5,10(sp)
    2a3e:	01979613          	sll	a2,a5,0x19
    2a42:	020007b7          	lui	a5,0x2000
    2a46:	8ff1                	and	a5,a5,a2
    2a48:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
    2a4a:	8f5d                	or	a4,a4,a5
    2a4c:	47b2                	lw	a5,12(sp)
    2a4e:	c3d8                	sw	a4,4(a5)

    if (txidle_config.detect_irq_enable) {
    2a50:	00914783          	lbu	a5,9(sp)
    2a54:	c799                	beqz	a5,2a62 <.L96>
        uart_enable_irq(ptr, uart_intr_tx_line_idle);
    2a56:	400005b7          	lui	a1,0x40000
    2a5a:	4532                	lw	a0,12(sp)
    2a5c:	09f020ef          	jal	52fa <uart_enable_irq>
    2a60:	a031                	j	2a6c <.L97>

00002a62 <.L96>:
    } else {
        uart_disable_irq(ptr, uart_intr_tx_line_idle);
    2a62:	400005b7          	lui	a1,0x40000
    2a66:	4532                	lw	a0,12(sp)
    2a68:	077020ef          	jal	52de <uart_disable_irq>

00002a6c <.L97>:
    }

    return status_success;
    2a6c:	4781                	li	a5,0
}
    2a6e:	853e                	mv	a0,a5
    2a70:	40f2                	lw	ra,28(sp)
    2a72:	6105                	add	sp,sp,32
    2a74:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

00002a76 <read_pmp_cfg>:

#define PMP_ENTRY_MAX 16
#define PMA_ENTRY_MAX 16

uint32_t read_pmp_cfg(uint32_t idx)
{
    2a76:	7179                	add	sp,sp,-48
    2a78:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
    2a7a:	d602                	sw	zero,44(sp)
    switch (idx) {
    2a7c:	4732                	lw	a4,12(sp)
    2a7e:	478d                	li	a5,3
    2a80:	04f70763          	beq	a4,a5,2ace <.L2>
    2a84:	4732                	lw	a4,12(sp)
    2a86:	478d                	li	a5,3
    2a88:	04e7e963          	bltu	a5,a4,2ada <.L9>
    2a8c:	4732                	lw	a4,12(sp)
    2a8e:	4789                	li	a5,2
    2a90:	02f70963          	beq	a4,a5,2ac2 <.L4>
    2a94:	4732                	lw	a4,12(sp)
    2a96:	4789                	li	a5,2
    2a98:	04e7e163          	bltu	a5,a4,2ada <.L9>
    2a9c:	47b2                	lw	a5,12(sp)
    2a9e:	c791                	beqz	a5,2aaa <.L5>
    2aa0:	4732                	lw	a4,12(sp)
    2aa2:	4785                	li	a5,1
    2aa4:	00f70963          	beq	a4,a5,2ab6 <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
    2aa8:	a80d                	j	2ada <.L9>

00002aaa <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
    2aaa:	3a0027f3          	csrr	a5,pmpcfg0
    2aae:	ce3e                	sw	a5,28(sp)
    2ab0:	47f2                	lw	a5,28(sp)

00002ab2 <.LBE2>:
    2ab2:	d63e                	sw	a5,44(sp)
        break;
    2ab4:	a025                	j	2adc <.L7>

00002ab6 <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
    2ab6:	3a1027f3          	csrr	a5,pmpcfg1
    2aba:	d03e                	sw	a5,32(sp)
    2abc:	5782                	lw	a5,32(sp)

00002abe <.LBE3>:
    2abe:	d63e                	sw	a5,44(sp)
        break;
    2ac0:	a831                	j	2adc <.L7>

00002ac2 <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
    2ac2:	3a2027f3          	csrr	a5,pmpcfg2
    2ac6:	d23e                	sw	a5,36(sp)
    2ac8:	5792                	lw	a5,36(sp)

00002aca <.LBE4>:
    2aca:	d63e                	sw	a5,44(sp)
        break;
    2acc:	a801                	j	2adc <.L7>

00002ace <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
    2ace:	3a3027f3          	csrr	a5,pmpcfg3
    2ad2:	d43e                	sw	a5,40(sp)
    2ad4:	57a2                	lw	a5,40(sp)

00002ad6 <.LBE5>:
    2ad6:	d63e                	sw	a5,44(sp)
        break;
    2ad8:	a011                	j	2adc <.L7>

00002ada <.L9>:
        break;
    2ada:	0001                	nop

00002adc <.L7>:
    }
    return pmp_cfg;
    2adc:	57b2                	lw	a5,44(sp)
}
    2ade:	853e                	mv	a0,a5
    2ae0:	6145                	add	sp,sp,48
    2ae2:	8082                	ret

Disassembly of section .text.write_pmp_addr:

00002ae4 <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
    2ae4:	1141                	add	sp,sp,-16
    2ae6:	c62a                	sw	a0,12(sp)
    2ae8:	c42e                	sw	a1,8(sp)
    switch (idx) {
    2aea:	4722                	lw	a4,8(sp)
    2aec:	47bd                	li	a5,15
    2aee:	08e7ea63          	bltu	a5,a4,2b82 <.L38>
    2af2:	47a2                	lw	a5,8(sp)
    2af4:	00279713          	sll	a4,a5,0x2
    2af8:	96c18793          	add	a5,gp,-1684 # 2dc <.L21>
    2afc:	97ba                	add	a5,a5,a4
    2afe:	439c                	lw	a5,0(a5)
    2b00:	8782                	jr	a5

00002b02 <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
    2b02:	47b2                	lw	a5,12(sp)
    2b04:	3b079073          	csrw	pmpaddr0,a5
        break;
    2b08:	a8b5                	j	2b84 <.L37>

00002b0a <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
    2b0a:	47b2                	lw	a5,12(sp)
    2b0c:	3b179073          	csrw	pmpaddr1,a5
        break;
    2b10:	a895                	j	2b84 <.L37>

00002b12 <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
    2b12:	47b2                	lw	a5,12(sp)
    2b14:	3b279073          	csrw	pmpaddr2,a5
        break;
    2b18:	a0b5                	j	2b84 <.L37>

00002b1a <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
    2b1a:	47b2                	lw	a5,12(sp)
    2b1c:	3b379073          	csrw	pmpaddr3,a5
        break;
    2b20:	a095                	j	2b84 <.L37>

00002b22 <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
    2b22:	47b2                	lw	a5,12(sp)
    2b24:	3b479073          	csrw	pmpaddr4,a5
        break;
    2b28:	a8b1                	j	2b84 <.L37>

00002b2a <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
    2b2a:	47b2                	lw	a5,12(sp)
    2b2c:	3b579073          	csrw	pmpaddr5,a5
        break;
    2b30:	a891                	j	2b84 <.L37>

00002b32 <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
    2b32:	47b2                	lw	a5,12(sp)
    2b34:	3b679073          	csrw	pmpaddr6,a5
        break;
    2b38:	a0b1                	j	2b84 <.L37>

00002b3a <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
    2b3a:	47b2                	lw	a5,12(sp)
    2b3c:	3b779073          	csrw	pmpaddr7,a5
        break;
    2b40:	a091                	j	2b84 <.L37>

00002b42 <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
    2b42:	47b2                	lw	a5,12(sp)
    2b44:	3b879073          	csrw	pmpaddr8,a5
        break;
    2b48:	a835                	j	2b84 <.L37>

00002b4a <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
    2b4a:	47b2                	lw	a5,12(sp)
    2b4c:	3b979073          	csrw	pmpaddr9,a5
        break;
    2b50:	a815                	j	2b84 <.L37>

00002b52 <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
    2b52:	47b2                	lw	a5,12(sp)
    2b54:	3ba79073          	csrw	pmpaddr10,a5
        break;
    2b58:	a035                	j	2b84 <.L37>

00002b5a <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
    2b5a:	47b2                	lw	a5,12(sp)
    2b5c:	3bb79073          	csrw	pmpaddr11,a5
        break;
    2b60:	a015                	j	2b84 <.L37>

00002b62 <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
    2b62:	47b2                	lw	a5,12(sp)
    2b64:	3bc79073          	csrw	pmpaddr12,a5
        break;
    2b68:	a831                	j	2b84 <.L37>

00002b6a <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
    2b6a:	47b2                	lw	a5,12(sp)
    2b6c:	3bd79073          	csrw	pmpaddr13,a5
        break;
    2b70:	a811                	j	2b84 <.L37>

00002b72 <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
    2b72:	47b2                	lw	a5,12(sp)
    2b74:	3be79073          	csrw	pmpaddr14,a5
        break;
    2b78:	a031                	j	2b84 <.L37>

00002b7a <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
    2b7a:	47b2                	lw	a5,12(sp)
    2b7c:	3bf79073          	csrw	pmpaddr15,a5
        break;
    2b80:	a011                	j	2b84 <.L37>

00002b82 <.L38>:
    default:
        /* Do nothing */
        break;
    2b82:	0001                	nop

00002b84 <.L37>:
    }
}
    2b84:	0001                	nop
    2b86:	0141                	add	sp,sp,16
    2b88:	8082                	ret

Disassembly of section .text.read_pma_cfg:

00002b8a <read_pma_cfg>:
    return status_success;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
    2b8a:	7179                	add	sp,sp,-48
    2b8c:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
    2b8e:	d602                	sw	zero,44(sp)
    switch (idx) {
    2b90:	4732                	lw	a4,12(sp)
    2b92:	478d                	li	a5,3
    2b94:	04f70763          	beq	a4,a5,2be2 <.L72>
    2b98:	4732                	lw	a4,12(sp)
    2b9a:	478d                	li	a5,3
    2b9c:	04e7e963          	bltu	a5,a4,2bee <.L79>
    2ba0:	4732                	lw	a4,12(sp)
    2ba2:	4789                	li	a5,2
    2ba4:	02f70963          	beq	a4,a5,2bd6 <.L74>
    2ba8:	4732                	lw	a4,12(sp)
    2baa:	4789                	li	a5,2
    2bac:	04e7e163          	bltu	a5,a4,2bee <.L79>
    2bb0:	47b2                	lw	a5,12(sp)
    2bb2:	c791                	beqz	a5,2bbe <.L75>
    2bb4:	4732                	lw	a4,12(sp)
    2bb6:	4785                	li	a5,1
    2bb8:	00f70963          	beq	a4,a5,2bca <.L76>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
    2bbc:	a80d                	j	2bee <.L79>

00002bbe <.L75>:
        pma_cfg = read_csr(CSR_PMACFG0);
    2bbe:	bc0027f3          	csrr	a5,0xbc0
    2bc2:	ce3e                	sw	a5,28(sp)
    2bc4:	47f2                	lw	a5,28(sp)

00002bc6 <.LBE24>:
    2bc6:	d63e                	sw	a5,44(sp)
        break;
    2bc8:	a025                	j	2bf0 <.L77>

00002bca <.L76>:
        pma_cfg = read_csr(CSR_PMACFG1);
    2bca:	bc1027f3          	csrr	a5,0xbc1
    2bce:	d03e                	sw	a5,32(sp)
    2bd0:	5782                	lw	a5,32(sp)

00002bd2 <.LBE25>:
    2bd2:	d63e                	sw	a5,44(sp)
        break;
    2bd4:	a831                	j	2bf0 <.L77>

00002bd6 <.L74>:
        pma_cfg = read_csr(CSR_PMACFG2);
    2bd6:	bc2027f3          	csrr	a5,0xbc2
    2bda:	d23e                	sw	a5,36(sp)
    2bdc:	5792                	lw	a5,36(sp)

00002bde <.LBE26>:
    2bde:	d63e                	sw	a5,44(sp)
        break;
    2be0:	a801                	j	2bf0 <.L77>

00002be2 <.L72>:
        pma_cfg = read_csr(CSR_PMACFG3);
    2be2:	bc3027f3          	csrr	a5,0xbc3
    2be6:	d43e                	sw	a5,40(sp)
    2be8:	57a2                	lw	a5,40(sp)

00002bea <.LBE27>:
    2bea:	d63e                	sw	a5,44(sp)
        break;
    2bec:	a011                	j	2bf0 <.L77>

00002bee <.L79>:
        break;
    2bee:	0001                	nop

00002bf0 <.L77>:
    }
    return pma_cfg;
    2bf0:	57b2                	lw	a5,44(sp)
}
    2bf2:	853e                	mv	a0,a5
    2bf4:	6145                	add	sp,sp,48
    2bf6:	8082                	ret

Disassembly of section .text.write_pma_addr:

00002bf8 <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
    2bf8:	1141                	add	sp,sp,-16
    2bfa:	c62a                	sw	a0,12(sp)
    2bfc:	c42e                	sw	a1,8(sp)
    switch (idx) {
    2bfe:	4722                	lw	a4,8(sp)
    2c00:	47bd                	li	a5,15
    2c02:	08e7ea63          	bltu	a5,a4,2c96 <.L108>
    2c06:	47a2                	lw	a5,8(sp)
    2c08:	00279713          	sll	a4,a5,0x2
    2c0c:	9ac18793          	add	a5,gp,-1620 # 31c <.L91>
    2c10:	97ba                	add	a5,a5,a4
    2c12:	439c                	lw	a5,0(a5)
    2c14:	8782                	jr	a5

00002c16 <.L106>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
    2c16:	47b2                	lw	a5,12(sp)
    2c18:	bd079073          	csrw	0xbd0,a5
        break;
    2c1c:	a8b5                	j	2c98 <.L107>

00002c1e <.L105>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
    2c1e:	47b2                	lw	a5,12(sp)
    2c20:	bd179073          	csrw	0xbd1,a5
        break;
    2c24:	a895                	j	2c98 <.L107>

00002c26 <.L104>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
    2c26:	47b2                	lw	a5,12(sp)
    2c28:	bd279073          	csrw	0xbd2,a5
        break;
    2c2c:	a0b5                	j	2c98 <.L107>

00002c2e <.L103>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
    2c2e:	47b2                	lw	a5,12(sp)
    2c30:	bd379073          	csrw	0xbd3,a5
        break;
    2c34:	a095                	j	2c98 <.L107>

00002c36 <.L102>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
    2c36:	47b2                	lw	a5,12(sp)
    2c38:	bd479073          	csrw	0xbd4,a5
        break;
    2c3c:	a8b1                	j	2c98 <.L107>

00002c3e <.L101>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
    2c3e:	47b2                	lw	a5,12(sp)
    2c40:	bd579073          	csrw	0xbd5,a5
        break;
    2c44:	a891                	j	2c98 <.L107>

00002c46 <.L100>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
    2c46:	47b2                	lw	a5,12(sp)
    2c48:	bd679073          	csrw	0xbd6,a5
        break;
    2c4c:	a0b1                	j	2c98 <.L107>

00002c4e <.L99>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
    2c4e:	47b2                	lw	a5,12(sp)
    2c50:	bd779073          	csrw	0xbd7,a5
        break;
    2c54:	a091                	j	2c98 <.L107>

00002c56 <.L98>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
    2c56:	47b2                	lw	a5,12(sp)
    2c58:	bd879073          	csrw	0xbd8,a5
        break;
    2c5c:	a835                	j	2c98 <.L107>

00002c5e <.L97>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
    2c5e:	47b2                	lw	a5,12(sp)
    2c60:	bd979073          	csrw	0xbd9,a5
        break;
    2c64:	a815                	j	2c98 <.L107>

00002c66 <.L96>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
    2c66:	47b2                	lw	a5,12(sp)
    2c68:	bda79073          	csrw	0xbda,a5
        break;
    2c6c:	a035                	j	2c98 <.L107>

00002c6e <.L95>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
    2c6e:	47b2                	lw	a5,12(sp)
    2c70:	bdb79073          	csrw	0xbdb,a5
        break;
    2c74:	a015                	j	2c98 <.L107>

00002c76 <.L94>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
    2c76:	47b2                	lw	a5,12(sp)
    2c78:	bdc79073          	csrw	0xbdc,a5
        break;
    2c7c:	a831                	j	2c98 <.L107>

00002c7e <.L93>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
    2c7e:	47b2                	lw	a5,12(sp)
    2c80:	bdd79073          	csrw	0xbdd,a5
        break;
    2c84:	a811                	j	2c98 <.L107>

00002c86 <.L92>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
    2c86:	47b2                	lw	a5,12(sp)
    2c88:	bde79073          	csrw	0xbde,a5
        break;
    2c8c:	a031                	j	2c98 <.L107>

00002c8e <.L90>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
    2c8e:	47b2                	lw	a5,12(sp)
    2c90:	bdf79073          	csrw	0xbdf,a5
        break;
    2c94:	a011                	j	2c98 <.L107>

00002c96 <.L108>:
    default:
        /* Do nothing */
        break;
    2c96:	0001                	nop

00002c98 <.L107>:
    }
}
    2c98:	0001                	nop
    2c9a:	0141                	add	sp,sp,16
    2c9c:	8082                	ret

Disassembly of section .text.pmp_config:

00002c9e <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
    2c9e:	7139                	add	sp,sp,-64
    2ca0:	de06                	sw	ra,60(sp)
    2ca2:	c62a                	sw	a0,12(sp)
    2ca4:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
    2ca6:	4789                	li	a5,2
    2ca8:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > 15U));
    2caa:	47b2                	lw	a5,12(sp)
    2cac:	cfcd                	beqz	a5,2d66 <.L140>
    2cae:	47a2                	lw	a5,8(sp)
    2cb0:	cbdd                	beqz	a5,2d66 <.L140>
    2cb2:	4722                	lw	a4,8(sp)
    2cb4:	47bd                	li	a5,15
    2cb6:	0ae7e863          	bltu	a5,a4,2d66 <.L140>

00002cba <.LBB47>:

        for (uint32_t i = 0; i < num_of_entries; i++) {
    2cba:	d402                	sw	zero,40(sp)
    2cbc:	a871                	j	2d58 <.L141>

00002cbe <.L142>:
            uint32_t idx = i / 4;
    2cbe:	57a2                	lw	a5,40(sp)
    2cc0:	8389                	srl	a5,a5,0x2
    2cc2:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
    2cc4:	57a2                	lw	a5,40(sp)
    2cc6:	078e                	sll	a5,a5,0x3
    2cc8:	8be1                	and	a5,a5,24
    2cca:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
    2ccc:	5512                	lw	a0,36(sp)
    2cce:	3365                	jal	2a76 <read_pmp_cfg>
    2cd0:	ce2a                	sw	a0,28(sp)
            pmp_cfg &= ~(0xFFUL << offset);
    2cd2:	5782                	lw	a5,32(sp)
    2cd4:	0ff00713          	li	a4,255
    2cd8:	00f717b3          	sll	a5,a4,a5
    2cdc:	fff7c793          	not	a5,a5
    2ce0:	4772                	lw	a4,28(sp)
    2ce2:	8ff9                	and	a5,a5,a4
    2ce4:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t)entry->pmp_cfg.val) << offset;
    2ce6:	47b2                	lw	a5,12(sp)
    2ce8:	0007c783          	lbu	a5,0(a5) # 2000000 <_extram_size>
    2cec:	873e                	mv	a4,a5
    2cee:	5782                	lw	a5,32(sp)
    2cf0:	00f717b3          	sll	a5,a4,a5
    2cf4:	4772                	lw	a4,28(sp)
    2cf6:	8fd9                	or	a5,a5,a4
    2cf8:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
    2cfa:	47b2                	lw	a5,12(sp)
    2cfc:	43dc                	lw	a5,4(a5)
    2cfe:	55a2                	lw	a1,40(sp)
    2d00:	853e                	mv	a0,a5
    2d02:	33cd                	jal	2ae4 <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
    2d04:	5592                	lw	a1,36(sp)
    2d06:	4572                	lw	a0,28(sp)
    2d08:	207020ef          	jal	570e <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
    2d0c:	5512                	lw	a0,36(sp)
    2d0e:	3db5                	jal	2b8a <read_pma_cfg>
    2d10:	cc2a                	sw	a0,24(sp)
            pma_cfg &= ~(0xFFUL << offset);
    2d12:	5782                	lw	a5,32(sp)
    2d14:	0ff00713          	li	a4,255
    2d18:	00f717b3          	sll	a5,a4,a5
    2d1c:	fff7c793          	not	a5,a5
    2d20:	4762                	lw	a4,24(sp)
    2d22:	8ff9                	and	a5,a5,a4
    2d24:	cc3e                	sw	a5,24(sp)
            pma_cfg |= ((uint32_t)entry->pma_cfg.val) << offset;
    2d26:	47b2                	lw	a5,12(sp)
    2d28:	0087c783          	lbu	a5,8(a5)
    2d2c:	873e                	mv	a4,a5
    2d2e:	5782                	lw	a5,32(sp)
    2d30:	00f717b3          	sll	a5,a4,a5
    2d34:	4762                	lw	a4,24(sp)
    2d36:	8fd9                	or	a5,a5,a4
    2d38:	cc3e                	sw	a5,24(sp)
            write_pma_cfg(pma_cfg, idx);
    2d3a:	5592                	lw	a1,36(sp)
    2d3c:	4562                	lw	a0,24(sp)
    2d3e:	22d020ef          	jal	576a <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
    2d42:	47b2                	lw	a5,12(sp)
    2d44:	47dc                	lw	a5,12(a5)
    2d46:	55a2                	lw	a1,40(sp)
    2d48:	853e                	mv	a0,a5
    2d4a:	357d                	jal	2bf8 <write_pma_addr>
#endif
            ++entry;
    2d4c:	47b2                	lw	a5,12(sp)
    2d4e:	07c1                	add	a5,a5,16
    2d50:	c63e                	sw	a5,12(sp)

00002d52 <.LBE48>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
    2d52:	57a2                	lw	a5,40(sp)
    2d54:	0785                	add	a5,a5,1
    2d56:	d43e                	sw	a5,40(sp)

00002d58 <.L141>:
    2d58:	5722                	lw	a4,40(sp)
    2d5a:	47a2                	lw	a5,8(sp)
    2d5c:	f6f761e3          	bltu	a4,a5,2cbe <.L142>

00002d60 <.LBE47>:
        }
        fencei();
    2d60:	0000100f          	fence.i

        status = status_success;
    2d64:	d602                	sw	zero,44(sp)

00002d66 <.L140>:

    } while (false);

    return status;
    2d66:	57b2                	lw	a5,44(sp)
}
    2d68:	853e                	mv	a0,a5
    2d6a:	50f2                	lw	ra,60(sp)
    2d6c:	6121                	add	sp,sp,64
    2d6e:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_freq_in_hz:

00002d70 <pllctlv2_get_pll_freq_in_hz>:
        }
    }
}

uint32_t pllctlv2_get_pll_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
    2d70:	7139                	add	sp,sp,-64
    2d72:	de06                	sw	ra,60(sp)
    2d74:	c62a                	sw	a0,12(sp)
    2d76:	87ae                	mv	a5,a1
    2d78:	00f105a3          	sb	a5,11(sp)
    uint32_t freq = 0;
    2d7c:	d602                	sw	zero,44(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
    2d7e:	47b2                	lw	a5,12(sp)
    2d80:	10078e63          	beqz	a5,2e9c <.L36>
    2d84:	00b14703          	lbu	a4,11(sp)
    2d88:	4789                	li	a5,2
    2d8a:	10e7e963          	bltu	a5,a4,2e9c <.L36>

00002d8e <.LBB3>:
        uint32_t mfi = PLLCTLV2_PLL_MFI_MFI_GET(ptr->PLL[pll].MFI);
    2d8e:	00b14783          	lbu	a5,11(sp)
    2d92:	4732                	lw	a4,12(sp)
    2d94:	0785                	add	a5,a5,1
    2d96:	079e                	sll	a5,a5,0x7
    2d98:	97ba                	add	a5,a5,a4
    2d9a:	439c                	lw	a5,0(a5)
    2d9c:	07f7f793          	and	a5,a5,127
    2da0:	d23e                	sw	a5,36(sp)
        uint32_t mfn = PLLCTLV2_PLL_MFN_MFN_GET(ptr->PLL[pll].MFN);
    2da2:	00b14783          	lbu	a5,11(sp)
    2da6:	4732                	lw	a4,12(sp)
    2da8:	0785                	add	a5,a5,1
    2daa:	079e                	sll	a5,a5,0x7
    2dac:	97ba                	add	a5,a5,a4
    2dae:	43d8                	lw	a4,4(a5)
    2db0:	400007b7          	lui	a5,0x40000
    2db4:	17fd                	add	a5,a5,-1 # 3fffffff <_extram_size+0x3dffffff>
    2db6:	8ff9                	and	a5,a5,a4
    2db8:	d03e                	sw	a5,32(sp)
        uint32_t mfd = PLLCTLV2_PLL_MFD_MFD_GET(ptr->PLL[pll].MFD);
    2dba:	00b14783          	lbu	a5,11(sp)
    2dbe:	4732                	lw	a4,12(sp)
    2dc0:	0785                	add	a5,a5,1
    2dc2:	079e                	sll	a5,a5,0x7
    2dc4:	97ba                	add	a5,a5,a4
    2dc6:	4798                	lw	a4,8(a5)
    2dc8:	400007b7          	lui	a5,0x40000
    2dcc:	17fd                	add	a5,a5,-1 # 3fffffff <_extram_size+0x3dffffff>
    2dce:	8ff9                	and	a5,a5,a4
    2dd0:	ce3e                	sw	a5,28(sp)
        /* Trade-off for avoiding the float computing.
         * Ensure both `mfd` and `PLLCTLV2_PLL_XTAL_FREQ` are n * `FREQ_1MHz`, n is a positive integer
         */
        assert((mfd / FREQ_1MHz) * FREQ_1MHz == mfd);
    2dd2:	4772                	lw	a4,28(sp)
    2dd4:	000f47b7          	lui	a5,0xf4
    2dd8:	24078793          	add	a5,a5,576 # f4240 <__AXI_SRAM_segment_size__+0x74240>
    2ddc:	02f777b3          	remu	a5,a4,a5
    2de0:	cb89                	beqz	a5,2df2 <.L37>
    2de2:	07400613          	li	a2,116
    2de6:	c9020593          	add	a1,tp,-880 # fffffc90 <__AHB_SRAM_segment_end__+0xfdf7c90>
    2dea:	cd820513          	add	a0,tp,-808 # fffffcd8 <__AHB_SRAM_segment_end__+0xfdf7cd8>
    2dee:	45b020ef          	jal	5a48 <__SEGGER_RTL_X_assert>

00002df2 <.L37>:
        assert((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * FREQ_1MHz == PLLCTLV2_PLL_XTAL_FREQ);

        uint32_t scaled_num;
        uint32_t scaled_denom;
        uint32_t shifted_mfn;
        uint32_t max_mfn = 0xFFFFFFFF / (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz);
    2df2:	0aaab7b7          	lui	a5,0xaaab
    2df6:	aaa78793          	add	a5,a5,-1366 # aaaaaaa <_extram_size+0x8aaaaaa>
    2dfa:	cc3e                	sw	a5,24(sp)
        if (mfn < max_mfn) {
    2dfc:	5702                	lw	a4,32(sp)
    2dfe:	47e2                	lw	a5,24(sp)
    2e00:	02f77e63          	bgeu	a4,a5,2e3c <.L38>
            scaled_num =  (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * mfn;
    2e04:	5702                	lw	a4,32(sp)
    2e06:	87ba                	mv	a5,a4
    2e08:	0786                	sll	a5,a5,0x1
    2e0a:	97ba                	add	a5,a5,a4
    2e0c:	078e                	sll	a5,a5,0x3
    2e0e:	c83e                	sw	a5,16(sp)
            scaled_denom = mfd / FREQ_1MHz;
    2e10:	4772                	lw	a4,28(sp)
    2e12:	000f47b7          	lui	a5,0xf4
    2e16:	24078793          	add	a5,a5,576 # f4240 <__AXI_SRAM_segment_size__+0x74240>
    2e1a:	02f757b3          	divu	a5,a4,a5
    2e1e:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + scaled_num / scaled_denom;
    2e20:	5712                	lw	a4,36(sp)
    2e22:	016e37b7          	lui	a5,0x16e3
    2e26:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
    2e2a:	02f70733          	mul	a4,a4,a5
    2e2e:	46c2                	lw	a3,16(sp)
    2e30:	47d2                	lw	a5,20(sp)
    2e32:	02f6d7b3          	divu	a5,a3,a5
    2e36:	97ba                	add	a5,a5,a4
    2e38:	d63e                	sw	a5,44(sp)
    2e3a:	a08d                	j	2e9c <.L36>

00002e3c <.L38>:
        } else {
            shifted_mfn = mfn;
    2e3c:	5782                	lw	a5,32(sp)
    2e3e:	d43e                	sw	a5,40(sp)
            while (shifted_mfn > max_mfn) {
    2e40:	a021                	j	2e48 <.L39>

00002e42 <.L40>:
                shifted_mfn >>= 1;
    2e42:	57a2                	lw	a5,40(sp)
    2e44:	8385                	srl	a5,a5,0x1
    2e46:	d43e                	sw	a5,40(sp)

00002e48 <.L39>:
            while (shifted_mfn > max_mfn) {
    2e48:	5722                	lw	a4,40(sp)
    2e4a:	47e2                	lw	a5,24(sp)
    2e4c:	fee7ebe3          	bltu	a5,a4,2e42 <.L40>
            }
            scaled_denom = mfd / FREQ_1MHz;
    2e50:	4772                	lw	a4,28(sp)
    2e52:	000f47b7          	lui	a5,0xf4
    2e56:	24078793          	add	a5,a5,576 # f4240 <__AXI_SRAM_segment_size__+0x74240>
    2e5a:	02f757b3          	divu	a5,a4,a5
    2e5e:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * shifted_mfn) / scaled_denom +  ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * (mfn - shifted_mfn)) / scaled_denom;
    2e60:	5712                	lw	a4,36(sp)
    2e62:	016e37b7          	lui	a5,0x16e3
    2e66:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
    2e6a:	02f706b3          	mul	a3,a4,a5
    2e6e:	5722                	lw	a4,40(sp)
    2e70:	87ba                	mv	a5,a4
    2e72:	0786                	sll	a5,a5,0x1
    2e74:	97ba                	add	a5,a5,a4
    2e76:	078e                	sll	a5,a5,0x3
    2e78:	873e                	mv	a4,a5
    2e7a:	47d2                	lw	a5,20(sp)
    2e7c:	02f757b3          	divu	a5,a4,a5
    2e80:	96be                	add	a3,a3,a5
    2e82:	5702                	lw	a4,32(sp)
    2e84:	57a2                	lw	a5,40(sp)
    2e86:	8f1d                	sub	a4,a4,a5
    2e88:	87ba                	mv	a5,a4
    2e8a:	0786                	sll	a5,a5,0x1
    2e8c:	97ba                	add	a5,a5,a4
    2e8e:	078e                	sll	a5,a5,0x3
    2e90:	873e                	mv	a4,a5
    2e92:	47d2                	lw	a5,20(sp)
    2e94:	02f757b3          	divu	a5,a4,a5
    2e98:	97b6                	add	a5,a5,a3
    2e9a:	d63e                	sw	a5,44(sp)

00002e9c <.L36>:
        }
    }
    return freq;
    2e9c:	57b2                	lw	a5,44(sp)
}
    2e9e:	853e                	mv	a0,a5
    2ea0:	50f2                	lw	ra,60(sp)
    2ea2:	6121                	add	sp,sp,64
    2ea4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

00002ea6 <__SEGGER_RTL_xltoa>:
    2ea6:	882a                	mv	a6,a0
    2ea8:	88ae                	mv	a7,a1
    2eaa:	852e                	mv	a0,a1
    2eac:	ca89                	beqz	a3,2ebe <.L2>
    2eae:	02d00793          	li	a5,45
    2eb2:	00158893          	add	a7,a1,1 # 40000001 <_extram_size+0x3e000001>
    2eb6:	00f58023          	sb	a5,0(a1)
    2eba:	41000833          	neg	a6,a6

00002ebe <.L2>:
    2ebe:	8746                	mv	a4,a7
    2ec0:	4325                	li	t1,9

00002ec2 <.L5>:
    2ec2:	02c876b3          	remu	a3,a6,a2
    2ec6:	85c2                	mv	a1,a6
    2ec8:	0ff6f793          	zext.b	a5,a3
    2ecc:	02c85833          	divu	a6,a6,a2
    2ed0:	02d37d63          	bgeu	t1,a3,2f0a <.L3>
    2ed4:	05778793          	add	a5,a5,87

00002ed8 <.L11>:
    2ed8:	0ff7f793          	zext.b	a5,a5
    2edc:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3df8000>
    2ee0:	00170693          	add	a3,a4,1
    2ee4:	02c5f163          	bgeu	a1,a2,2f06 <.L8>
    2ee8:	000700a3          	sb	zero,1(a4)

00002eec <.L6>:
    2eec:	0008c683          	lbu	a3,0(a7)
    2ef0:	00074783          	lbu	a5,0(a4)
    2ef4:	0885                	add	a7,a7,1
    2ef6:	177d                	add	a4,a4,-1
    2ef8:	00d700a3          	sb	a3,1(a4)
    2efc:	fef88fa3          	sb	a5,-1(a7)
    2f00:	fee8e6e3          	bltu	a7,a4,2eec <.L6>
    2f04:	8082                	ret

00002f06 <.L8>:
    2f06:	8736                	mv	a4,a3
    2f08:	bf6d                	j	2ec2 <.L5>

00002f0a <.L3>:
    2f0a:	03078793          	add	a5,a5,48
    2f0e:	b7e9                	j	2ed8 <.L11>

Disassembly of section .text.libc.itoa:

00002f10 <itoa>:
    2f10:	46a9                	li	a3,10
    2f12:	87aa                	mv	a5,a0
    2f14:	882e                	mv	a6,a1
    2f16:	8732                	mv	a4,a2
    2f18:	00d61563          	bne	a2,a3,2f22 <.L301>
    2f1c:	4685                	li	a3,1
    2f1e:	00054663          	bltz	a0,2f2a <.L302>

00002f22 <.L301>:
    2f22:	4681                	li	a3,0
    2f24:	863a                	mv	a2,a4
    2f26:	85c2                	mv	a1,a6
    2f28:	853e                	mv	a0,a5

00002f2a <.L302>:
    2f2a:	bfb5                	j	2ea6 <__SEGGER_RTL_xltoa>

Disassembly of section .text.libc.fwrite:

00002f2c <fwrite>:
    2f2c:	1101                	add	sp,sp,-32
    2f2e:	c64e                	sw	s3,12(sp)
    2f30:	89aa                	mv	s3,a0
    2f32:	8536                	mv	a0,a3
    2f34:	cc22                	sw	s0,24(sp)
    2f36:	ca26                	sw	s1,20(sp)
    2f38:	c84a                	sw	s2,16(sp)
    2f3a:	ce06                	sw	ra,28(sp)
    2f3c:	84ae                	mv	s1,a1
    2f3e:	8432                	mv	s0,a2
    2f40:	8936                	mv	s2,a3
    2f42:	23d020ef          	jal	597e <__SEGGER_RTL_X_file_stat>
    2f46:	02054463          	bltz	a0,2f6e <.L43>
    2f4a:	02848633          	mul	a2,s1,s0
    2f4e:	4501                	li	a0,0
    2f50:	00966863          	bltu	a2,s1,2f60 <.L41>
    2f54:	85ce                	mv	a1,s3
    2f56:	854a                	mv	a0,s2
    2f58:	1a9020ef          	jal	5900 <__SEGGER_RTL_X_file_write>
    2f5c:	02955533          	divu	a0,a0,s1

00002f60 <.L41>:
    2f60:	40f2                	lw	ra,28(sp)
    2f62:	4462                	lw	s0,24(sp)
    2f64:	44d2                	lw	s1,20(sp)
    2f66:	4942                	lw	s2,16(sp)
    2f68:	49b2                	lw	s3,12(sp)
    2f6a:	6105                	add	sp,sp,32
    2f6c:	8082                	ret

00002f6e <.L43>:
    2f6e:	4501                	li	a0,0
    2f70:	bfc5                	j	2f60 <.L41>

Disassembly of section .text.libc.__subsf3:

00002f72 <__subsf3>:
    2f72:	80000637          	lui	a2,0x80000
    2f76:	8db1                	xor	a1,a1,a2
    2f78:	a009                	j	2f7a <__addsf3>

Disassembly of section .text.libc.__addsf3:

00002f7a <__addsf3>:
    2f7a:	80000637          	lui	a2,0x80000
    2f7e:	00b546b3          	xor	a3,a0,a1
    2f82:	0806ca63          	bltz	a3,3016 <.L__addsf3_subtract>
    2f86:	00b57563          	bgeu	a0,a1,2f90 <.L__addsf3_add_already_ordered>
    2f8a:	86aa                	mv	a3,a0
    2f8c:	852e                	mv	a0,a1
    2f8e:	85b6                	mv	a1,a3

00002f90 <.L__addsf3_add_already_ordered>:
    2f90:	00151713          	sll	a4,a0,0x1
    2f94:	8361                	srl	a4,a4,0x18
    2f96:	00159693          	sll	a3,a1,0x1
    2f9a:	82e1                	srl	a3,a3,0x18
    2f9c:	0ff00293          	li	t0,255
    2fa0:	06570563          	beq	a4,t0,300a <.L__addsf3_add_inf_or_nan>
    2fa4:	c325                	beqz	a4,3004 <.L__addsf3_zero>
    2fa6:	ceb1                	beqz	a3,3002 <.L__addsf3_add_done>
    2fa8:	40d706b3          	sub	a3,a4,a3
    2fac:	42e1                	li	t0,24
    2fae:	04d2ca63          	blt	t0,a3,3002 <.L__addsf3_add_done>
    2fb2:	05a2                	sll	a1,a1,0x8
    2fb4:	8dd1                	or	a1,a1,a2
    2fb6:	01755713          	srl	a4,a0,0x17
    2fba:	0522                	sll	a0,a0,0x8
    2fbc:	8d51                	or	a0,a0,a2
    2fbe:	47e5                	li	a5,25
    2fc0:	8f95                	sub	a5,a5,a3
    2fc2:	00f59633          	sll	a2,a1,a5
    2fc6:	821d                	srl	a2,a2,0x7
    2fc8:	00d5d5b3          	srl	a1,a1,a3
    2fcc:	00b507b3          	add	a5,a0,a1
    2fd0:	00a7f463          	bgeu	a5,a0,2fd8 <.L__addsf3_add_no_normalization>
    2fd4:	8385                	srl	a5,a5,0x1
    2fd6:	0709                	add	a4,a4,2

00002fd8 <.L__addsf3_add_no_normalization>:
    2fd8:	177d                	add	a4,a4,-1
    2fda:	0ff77593          	zext.b	a1,a4
    2fde:	f0158593          	add	a1,a1,-255
    2fe2:	cd91                	beqz	a1,2ffe <.L__addsf3_inf>
    2fe4:	075e                	sll	a4,a4,0x17
    2fe6:	0087d513          	srl	a0,a5,0x8
    2fea:	07e2                	sll	a5,a5,0x18
    2fec:	8fd1                	or	a5,a5,a2
    2fee:	0007d663          	bgez	a5,2ffa <.L__addsf3_no_tie>
    2ff2:	0786                	sll	a5,a5,0x1
    2ff4:	0505                	add	a0,a0,1 # f4104001 <__AHB_SRAM_segment_end__+0x3efc001>
    2ff6:	e391                	bnez	a5,2ffa <.L__addsf3_no_tie>
    2ff8:	9979                	and	a0,a0,-2

00002ffa <.L__addsf3_no_tie>:
    2ffa:	953a                	add	a0,a0,a4
    2ffc:	8082                	ret

00002ffe <.L__addsf3_inf>:
    2ffe:	01771513          	sll	a0,a4,0x17

00003002 <.L__addsf3_add_done>:
    3002:	8082                	ret

00003004 <.L__addsf3_zero>:
    3004:	817d                	srl	a0,a0,0x1f
    3006:	057e                	sll	a0,a0,0x1f
    3008:	8082                	ret

0000300a <.L__addsf3_add_inf_or_nan>:
    300a:	00951613          	sll	a2,a0,0x9
    300e:	da75                	beqz	a2,3002 <.L__addsf3_add_done>

00003010 <.L__addsf3_return_nan>:
    3010:	7fc00537          	lui	a0,0x7fc00
    3014:	8082                	ret

00003016 <.L__addsf3_subtract>:
    3016:	8db1                	xor	a1,a1,a2
    3018:	40b506b3          	sub	a3,a0,a1
    301c:	00b57563          	bgeu	a0,a1,3026 <.L__addsf3_sub_already_ordered>
    3020:	8eb1                	xor	a3,a3,a2
    3022:	8d15                	sub	a0,a0,a3
    3024:	95b6                	add	a1,a1,a3

00003026 <.L__addsf3_sub_already_ordered>:
    3026:	00159693          	sll	a3,a1,0x1
    302a:	82e1                	srl	a3,a3,0x18
    302c:	00151713          	sll	a4,a0,0x1
    3030:	8361                	srl	a4,a4,0x18
    3032:	05a2                	sll	a1,a1,0x8
    3034:	8dd1                	or	a1,a1,a2
    3036:	0ff00293          	li	t0,255
    303a:	0c570c63          	beq	a4,t0,3112 <.L__addsf3_sub_inf_or_nan>
    303e:	c2f5                	beqz	a3,3122 <.L__addsf3_sub_zero>
    3040:	40d706b3          	sub	a3,a4,a3
    3044:	c695                	beqz	a3,3070 <.L__addsf3_exponents_equal>
    3046:	4285                	li	t0,1
    3048:	08569063          	bne	a3,t0,30c8 <.L__addsf3_exponents_differ_by_more_than_1>
    304c:	01755693          	srl	a3,a0,0x17
    3050:	0526                	sll	a0,a0,0x9
    3052:	00b532b3          	sltu	t0,a0,a1
    3056:	8d0d                	sub	a0,a0,a1
    3058:	02029263          	bnez	t0,307c <.L__addsf3_normalization_steps>
    305c:	06de                	sll	a3,a3,0x17
    305e:	01751593          	sll	a1,a0,0x17
    3062:	8125                	srl	a0,a0,0x9
    3064:	0005d463          	bgez	a1,306c <.L__addsf3_sub_no_tie_single>
    3068:	0505                	add	a0,a0,1 # 7fc00001 <_extram_size+0x7dc00001>
    306a:	9979                	and	a0,a0,-2

0000306c <.L__addsf3_sub_no_tie_single>:
    306c:	9536                	add	a0,a0,a3

0000306e <.L__addsf3_sub_done>:
    306e:	8082                	ret

00003070 <.L__addsf3_exponents_equal>:
    3070:	01755693          	srl	a3,a0,0x17
    3074:	0526                	sll	a0,a0,0x9
    3076:	0586                	sll	a1,a1,0x1
    3078:	8d0d                	sub	a0,a0,a1
    307a:	d975                	beqz	a0,306e <.L__addsf3_sub_done>

0000307c <.L__addsf3_normalization_steps>:
    307c:	4581                	li	a1,0
    307e:	01055793          	srl	a5,a0,0x10
    3082:	e399                	bnez	a5,3088 <.L1^B1>
    3084:	0542                	sll	a0,a0,0x10
    3086:	05c1                	add	a1,a1,16

00003088 <.L1^B1>:
    3088:	01855793          	srl	a5,a0,0x18
    308c:	e399                	bnez	a5,3092 <.L2^B1>
    308e:	0522                	sll	a0,a0,0x8
    3090:	05a1                	add	a1,a1,8

00003092 <.L2^B1>:
    3092:	01c55793          	srl	a5,a0,0x1c
    3096:	e399                	bnez	a5,309c <.L3^B1>
    3098:	0512                	sll	a0,a0,0x4
    309a:	0591                	add	a1,a1,4

0000309c <.L3^B1>:
    309c:	01e55793          	srl	a5,a0,0x1e
    30a0:	e399                	bnez	a5,30a6 <.L4^B1>
    30a2:	050a                	sll	a0,a0,0x2
    30a4:	0589                	add	a1,a1,2

000030a6 <.L4^B1>:
    30a6:	00054463          	bltz	a0,30ae <.L5^B1>
    30aa:	0506                	sll	a0,a0,0x1
    30ac:	0585                	add	a1,a1,1

000030ae <.L5^B1>:
    30ae:	0585                	add	a1,a1,1
    30b0:	0506                	sll	a0,a0,0x1
    30b2:	00e5f763          	bgeu	a1,a4,30c0 <.L__addsf3_underflow>
    30b6:	8e8d                	sub	a3,a3,a1
    30b8:	06de                	sll	a3,a3,0x17
    30ba:	8125                	srl	a0,a0,0x9
    30bc:	9536                	add	a0,a0,a3
    30be:	8082                	ret

000030c0 <.L__addsf3_underflow>:
    30c0:	0086d513          	srl	a0,a3,0x8
    30c4:	057e                	sll	a0,a0,0x1f
    30c6:	8082                	ret

000030c8 <.L__addsf3_exponents_differ_by_more_than_1>:
    30c8:	42e5                	li	t0,25
    30ca:	fad2e2e3          	bltu	t0,a3,306e <.L__addsf3_sub_done>
    30ce:	0685                	add	a3,a3,1
    30d0:	40d00733          	neg	a4,a3
    30d4:	00e59733          	sll	a4,a1,a4
    30d8:	00d5d5b3          	srl	a1,a1,a3
    30dc:	00e03733          	snez	a4,a4
    30e0:	95ae                	add	a1,a1,a1
    30e2:	95ba                	add	a1,a1,a4
    30e4:	01755693          	srl	a3,a0,0x17
    30e8:	0522                	sll	a0,a0,0x8
    30ea:	8d51                	or	a0,a0,a2
    30ec:	40b50733          	sub	a4,a0,a1
    30f0:	00074463          	bltz	a4,30f8 <.L__addsf3_sub_already_normalized>
    30f4:	070a                	sll	a4,a4,0x2
    30f6:	8305                	srl	a4,a4,0x1

000030f8 <.L__addsf3_sub_already_normalized>:
    30f8:	16fd                	add	a3,a3,-1
    30fa:	06de                	sll	a3,a3,0x17
    30fc:	00875513          	srl	a0,a4,0x8
    3100:	0762                	sll	a4,a4,0x18
    3102:	00075663          	bgez	a4,310e <.L__addsf3_sub_no_tie>
    3106:	0706                	sll	a4,a4,0x1
    3108:	0505                	add	a0,a0,1
    310a:	e311                	bnez	a4,310e <.L__addsf3_sub_no_tie>
    310c:	9979                	and	a0,a0,-2

0000310e <.L__addsf3_sub_no_tie>:
    310e:	9536                	add	a0,a0,a3
    3110:	8082                	ret

00003112 <.L__addsf3_sub_inf_or_nan>:
    3112:	0ff00293          	li	t0,255
    3116:	ee568de3          	beq	a3,t0,3010 <.L__addsf3_return_nan>
    311a:	00951593          	sll	a1,a0,0x9
    311e:	d9a1                	beqz	a1,306e <.L__addsf3_sub_done>
    3120:	bdc5                	j	3010 <.L__addsf3_return_nan>

00003122 <.L__addsf3_sub_zero>:
    3122:	f731                	bnez	a4,306e <.L__addsf3_sub_done>
    3124:	4501                	li	a0,0
    3126:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

00003128 <__ltsf2>:
    3128:	ff000637          	lui	a2,0xff000
    312c:	00151693          	sll	a3,a0,0x1
    3130:	02d66763          	bltu	a2,a3,315e <.L__ltsf2_zero>
    3134:	00159693          	sll	a3,a1,0x1
    3138:	02d66363          	bltu	a2,a3,315e <.L__ltsf2_zero>
    313c:	00b56633          	or	a2,a0,a1
    3140:	00161693          	sll	a3,a2,0x1
    3144:	ce89                	beqz	a3,315e <.L__ltsf2_zero>
    3146:	00064763          	bltz	a2,3154 <.L__ltsf2_negative>
    314a:	00b53533          	sltu	a0,a0,a1
    314e:	40a00533          	neg	a0,a0
    3152:	8082                	ret

00003154 <.L__ltsf2_negative>:
    3154:	00a5b533          	sltu	a0,a1,a0
    3158:	40a00533          	neg	a0,a0
    315c:	8082                	ret

0000315e <.L__ltsf2_zero>:
    315e:	4501                	li	a0,0
    3160:	8082                	ret

Disassembly of section .text.libc.__lesf2:

00003162 <__lesf2>:
    3162:	ff000637          	lui	a2,0xff000
    3166:	00151693          	sll	a3,a0,0x1
    316a:	02d66363          	bltu	a2,a3,3190 <.L__lesf2_nan>
    316e:	00159693          	sll	a3,a1,0x1
    3172:	00d66f63          	bltu	a2,a3,3190 <.L__lesf2_nan>
    3176:	00b56633          	or	a2,a0,a1
    317a:	00161693          	sll	a3,a2,0x1
    317e:	ca99                	beqz	a3,3194 <.L__lesf2_zero>
    3180:	00064563          	bltz	a2,318a <.L__lesf2_negative>
    3184:	00a5b533          	sltu	a0,a1,a0
    3188:	8082                	ret

0000318a <.L__lesf2_negative>:
    318a:	00b53533          	sltu	a0,a0,a1
    318e:	8082                	ret

00003190 <.L__lesf2_nan>:
    3190:	4505                	li	a0,1
    3192:	8082                	ret

00003194 <.L__lesf2_zero>:
    3194:	4501                	li	a0,0
    3196:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

00003198 <__gtsf2>:
    3198:	ff000637          	lui	a2,0xff000
    319c:	00151693          	sll	a3,a0,0x1
    31a0:	02d66363          	bltu	a2,a3,31c6 <.L__gtsf2_zero>
    31a4:	00159693          	sll	a3,a1,0x1
    31a8:	00d66f63          	bltu	a2,a3,31c6 <.L__gtsf2_zero>
    31ac:	00b56633          	or	a2,a0,a1
    31b0:	00161693          	sll	a3,a2,0x1
    31b4:	ca89                	beqz	a3,31c6 <.L__gtsf2_zero>
    31b6:	00064563          	bltz	a2,31c0 <.L__gtsf2_negative>
    31ba:	00a5b533          	sltu	a0,a1,a0
    31be:	8082                	ret

000031c0 <.L__gtsf2_negative>:
    31c0:	00b53533          	sltu	a0,a0,a1
    31c4:	8082                	ret

000031c6 <.L__gtsf2_zero>:
    31c6:	4501                	li	a0,0
    31c8:	8082                	ret

Disassembly of section .text.libc.__gesf2:

000031ca <__gesf2>:
    31ca:	ff000637          	lui	a2,0xff000
    31ce:	00151693          	sll	a3,a0,0x1
    31d2:	02d66763          	bltu	a2,a3,3200 <.L__gesf2_nan>
    31d6:	00159693          	sll	a3,a1,0x1
    31da:	02d66363          	bltu	a2,a3,3200 <.L__gesf2_nan>
    31de:	00b56633          	or	a2,a0,a1
    31e2:	00161693          	sll	a3,a2,0x1
    31e6:	ce99                	beqz	a3,3204 <.L__gesf2_zero>
    31e8:	00064763          	bltz	a2,31f6 <.L__gesf2_negative>
    31ec:	00b53533          	sltu	a0,a0,a1
    31f0:	40a00533          	neg	a0,a0
    31f4:	8082                	ret

000031f6 <.L__gesf2_negative>:
    31f6:	00a5b533          	sltu	a0,a1,a0
    31fa:	40a00533          	neg	a0,a0
    31fe:	8082                	ret

00003200 <.L__gesf2_nan>:
    3200:	557d                	li	a0,-1
    3202:	8082                	ret

00003204 <.L__gesf2_zero>:
    3204:	4501                	li	a0,0
    3206:	8082                	ret

Disassembly of section .text.libc.__floatunsisf:

00003208 <__floatunsisf>:
    3208:	c931                	beqz	a0,325c <.L__floatunsisf_done>
    320a:	09d00613          	li	a2,157
    320e:	01055693          	srl	a3,a0,0x10
    3212:	e299                	bnez	a3,3218 <.L1^B8>
    3214:	0542                	sll	a0,a0,0x10
    3216:	1641                	add	a2,a2,-16 # fefffff0 <__AHB_SRAM_segment_end__+0xedf7ff0>

00003218 <.L1^B8>:
    3218:	01855693          	srl	a3,a0,0x18
    321c:	e299                	bnez	a3,3222 <.L2^B8>
    321e:	0522                	sll	a0,a0,0x8
    3220:	1661                	add	a2,a2,-8

00003222 <.L2^B8>:
    3222:	01c55693          	srl	a3,a0,0x1c
    3226:	e299                	bnez	a3,322c <.L3^B6>
    3228:	0512                	sll	a0,a0,0x4
    322a:	1671                	add	a2,a2,-4

0000322c <.L3^B6>:
    322c:	01e55693          	srl	a3,a0,0x1e
    3230:	e299                	bnez	a3,3236 <.L4^B8>
    3232:	050a                	sll	a0,a0,0x2
    3234:	1679                	add	a2,a2,-2

00003236 <.L4^B8>:
    3236:	00054463          	bltz	a0,323e <.L5^B6>
    323a:	0506                	sll	a0,a0,0x1
    323c:	167d                	add	a2,a2,-1

0000323e <.L5^B6>:
    323e:	065e                	sll	a2,a2,0x17
    3240:	01751593          	sll	a1,a0,0x17
    3244:	8121                	srl	a0,a0,0x8
    3246:	0005a333          	sltz	t1,a1
    324a:	95ae                	add	a1,a1,a1
    324c:	959a                	add	a1,a1,t1
    324e:	0005d663          	bgez	a1,325a <.L__floatunsisf_round_down>
    3252:	95ae                	add	a1,a1,a1
    3254:	00b035b3          	snez	a1,a1
    3258:	952e                	add	a0,a0,a1

0000325a <.L__floatunsisf_round_down>:
    325a:	9532                	add	a0,a0,a2

0000325c <.L__floatunsisf_done>:
    325c:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

0000325e <__floatundisf>:
    325e:	c5bd                	beqz	a1,32cc <.L__floatundisf_high_word_zero>
    3260:	4701                	li	a4,0
    3262:	0105d693          	srl	a3,a1,0x10
    3266:	e299                	bnez	a3,326c <.L8^B3>
    3268:	0741                	add	a4,a4,16
    326a:	05c2                	sll	a1,a1,0x10

0000326c <.L8^B3>:
    326c:	0185d693          	srl	a3,a1,0x18
    3270:	e299                	bnez	a3,3276 <.L4^B10>
    3272:	0721                	add	a4,a4,8
    3274:	05a2                	sll	a1,a1,0x8

00003276 <.L4^B10>:
    3276:	01c5d693          	srl	a3,a1,0x1c
    327a:	e299                	bnez	a3,3280 <.L2^B10>
    327c:	0711                	add	a4,a4,4
    327e:	0592                	sll	a1,a1,0x4

00003280 <.L2^B10>:
    3280:	01e5d693          	srl	a3,a1,0x1e
    3284:	e299                	bnez	a3,328a <.L1^B10>
    3286:	0709                	add	a4,a4,2
    3288:	058a                	sll	a1,a1,0x2

0000328a <.L1^B10>:
    328a:	0005c463          	bltz	a1,3292 <.L0^B3>
    328e:	0705                	add	a4,a4,1
    3290:	0586                	sll	a1,a1,0x1

00003292 <.L0^B3>:
    3292:	fff74613          	not	a2,a4
    3296:	00c556b3          	srl	a3,a0,a2
    329a:	8285                	srl	a3,a3,0x1
    329c:	8dd5                	or	a1,a1,a3
    329e:	00e51533          	sll	a0,a0,a4
    32a2:	0be60613          	add	a2,a2,190
    32a6:	00a03533          	snez	a0,a0
    32aa:	8dc9                	or	a1,a1,a0

000032ac <.L__floatundisf_round_and_pack>:
    32ac:	065e                	sll	a2,a2,0x17
    32ae:	0085d513          	srl	a0,a1,0x8
    32b2:	05de                	sll	a1,a1,0x17
    32b4:	0005a333          	sltz	t1,a1
    32b8:	95ae                	add	a1,a1,a1
    32ba:	959a                	add	a1,a1,t1
    32bc:	0005d663          	bgez	a1,32c8 <.L__floatundisf_round_down>
    32c0:	95ae                	add	a1,a1,a1
    32c2:	00b035b3          	snez	a1,a1
    32c6:	952e                	add	a0,a0,a1

000032c8 <.L__floatundisf_round_down>:
    32c8:	9532                	add	a0,a0,a2

000032ca <.L__floatundisf_done>:
    32ca:	8082                	ret

000032cc <.L__floatundisf_high_word_zero>:
    32cc:	dd7d                	beqz	a0,32ca <.L__floatundisf_done>
    32ce:	09d00613          	li	a2,157
    32d2:	01055693          	srl	a3,a0,0x10
    32d6:	e299                	bnez	a3,32dc <.L1^B11>
    32d8:	0542                	sll	a0,a0,0x10
    32da:	1641                	add	a2,a2,-16

000032dc <.L1^B11>:
    32dc:	01855693          	srl	a3,a0,0x18
    32e0:	e299                	bnez	a3,32e6 <.L2^B11>
    32e2:	0522                	sll	a0,a0,0x8
    32e4:	1661                	add	a2,a2,-8

000032e6 <.L2^B11>:
    32e6:	01c55693          	srl	a3,a0,0x1c
    32ea:	e299                	bnez	a3,32f0 <.L3^B8>
    32ec:	0512                	sll	a0,a0,0x4
    32ee:	1671                	add	a2,a2,-4

000032f0 <.L3^B8>:
    32f0:	01e55693          	srl	a3,a0,0x1e
    32f4:	e299                	bnez	a3,32fa <.L4^B11>
    32f6:	050a                	sll	a0,a0,0x2
    32f8:	1679                	add	a2,a2,-2

000032fa <.L4^B11>:
    32fa:	00054463          	bltz	a0,3302 <.L5^B8>
    32fe:	0506                	sll	a0,a0,0x1
    3300:	167d                	add	a2,a2,-1

00003302 <.L5^B8>:
    3302:	85aa                	mv	a1,a0
    3304:	4501                	li	a0,0
    3306:	b75d                	j	32ac <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__extendsfdf2:

00003308 <__extendsfdf2>:
    3308:	00151293          	sll	t0,a0,0x1
    330c:	010006b7          	lui	a3,0x1000
    3310:	02d2ea63          	bltu	t0,a3,3344 <.L__extendsfdf2_subnormal>
    3314:	0042d593          	srl	a1,t0,0x4
    3318:	38000637          	lui	a2,0x38000
    331c:	95b2                	add	a1,a1,a2
    331e:	01f55693          	srl	a3,a0,0x1f
    3322:	06fe                	sll	a3,a3,0x1f
    3324:	8dd5                	or	a1,a1,a3
    3326:	0576                	sll	a0,a0,0x1d
    3328:	ff0006b7          	lui	a3,0xff000
    332c:	00d2f363          	bgeu	t0,a3,3332 <.L__extendsfdf2_inf_nan>
    3330:	8082                	ret

00003332 <.L__extendsfdf2_inf_nan>:
    3332:	38000637          	lui	a2,0x38000
    3336:	95b2                	add	a1,a1,a2
    3338:	00d28563          	beq	t0,a3,3342 <.L__extendsfdf2_ret>
    333c:	00080637          	lui	a2,0x80
    3340:	8dd1                	or	a1,a1,a2

00003342 <.L__extendsfdf2_ret>:
    3342:	8082                	ret

00003344 <.L__extendsfdf2_subnormal>:
    3344:	01f55593          	srl	a1,a0,0x1f
    3348:	05fe                	sll	a1,a1,0x1f
    334a:	4501                	li	a0,0
    334c:	8082                	ret

Disassembly of section .text.libc.__truncdfsf2:

0000334e <__truncdfsf2>:
    334e:	00159693          	sll	a3,a1,0x1
    3352:	82d5                	srl	a3,a3,0x15
    3354:	7ff00613          	li	a2,2047
    3358:	04c68663          	beq	a3,a2,33a4 <.L__truncdfsf2_inf_nan>
    335c:	c8068693          	add	a3,a3,-896 # fefffc80 <__AHB_SRAM_segment_end__+0xedf7c80>
    3360:	02d05e63          	blez	a3,339c <.L__truncdfsf2_underflow>
    3364:	0ff00613          	li	a2,255
    3368:	04c6f263          	bgeu	a3,a2,33ac <.L__truncdfsf2_inf>
    336c:	06de                	sll	a3,a3,0x17
    336e:	01f5d613          	srl	a2,a1,0x1f
    3372:	067e                	sll	a2,a2,0x1f
    3374:	8ed1                	or	a3,a3,a2
    3376:	05b2                	sll	a1,a1,0xc
    3378:	01455613          	srl	a2,a0,0x14
    337c:	8dd1                	or	a1,a1,a2
    337e:	81a5                	srl	a1,a1,0x9
    3380:	00251613          	sll	a2,a0,0x2
    3384:	00062733          	sltz	a4,a2
    3388:	9632                	add	a2,a2,a2
    338a:	000627b3          	sltz	a5,a2
    338e:	9632                	add	a2,a2,a2
    3390:	963a                	add	a2,a2,a4
    3392:	c211                	beqz	a2,3396 <.L__truncdfsf2_no_round_tie>
    3394:	95be                	add	a1,a1,a5

00003396 <.L__truncdfsf2_no_round_tie>:
    3396:	00d58533          	add	a0,a1,a3
    339a:	8082                	ret

0000339c <.L__truncdfsf2_underflow>:
    339c:	01f5d513          	srl	a0,a1,0x1f
    33a0:	057e                	sll	a0,a0,0x1f
    33a2:	8082                	ret

000033a4 <.L__truncdfsf2_inf_nan>:
    33a4:	00c59693          	sll	a3,a1,0xc
    33a8:	8ec9                	or	a3,a3,a0
    33aa:	ea81                	bnez	a3,33ba <.L__truncdfsf2_nan>

000033ac <.L__truncdfsf2_inf>:
    33ac:	81fd                	srl	a1,a1,0x1f
    33ae:	05fe                	sll	a1,a1,0x1f
    33b0:	7f800537          	lui	a0,0x7f800
    33b4:	8d4d                	or	a0,a0,a1
    33b6:	4581                	li	a1,0
    33b8:	8082                	ret

000033ba <.L__truncdfsf2_nan>:
    33ba:	800006b7          	lui	a3,0x80000
    33be:	00d5f633          	and	a2,a1,a3
    33c2:	058e                	sll	a1,a1,0x3
    33c4:	8175                	srl	a0,a0,0x1d
    33c6:	8d4d                	or	a0,a0,a1
    33c8:	0506                	sll	a0,a0,0x1
    33ca:	8105                	srl	a0,a0,0x1
    33cc:	8d51                	or	a0,a0,a2
    33ce:	82a5                	srl	a3,a3,0x9
    33d0:	8d55                	or	a0,a0,a3
    33d2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

000033d4 <__SEGGER_RTL_ldouble_to_double>:
    33d4:	4158                	lw	a4,4(a0)
    33d6:	451c                	lw	a5,8(a0)
    33d8:	4554                	lw	a3,12(a0)
    33da:	1141                	add	sp,sp,-16
    33dc:	c23a                	sw	a4,4(sp)
    33de:	c43e                	sw	a5,8(sp)
    33e0:	7771                	lui	a4,0xffffc
    33e2:	00169793          	sll	a5,a3,0x1
    33e6:	83c5                	srl	a5,a5,0x11
    33e8:	40070713          	add	a4,a4,1024 # ffffc400 <__AHB_SRAM_segment_end__+0xfdf4400>
    33ec:	c636                	sw	a3,12(sp)
    33ee:	97ba                	add	a5,a5,a4
    33f0:	00f04a63          	bgtz	a5,3404 <.L27>
    33f4:	800007b7          	lui	a5,0x80000
    33f8:	4701                	li	a4,0
    33fa:	8ff5                	and	a5,a5,a3

000033fc <.L28>:
    33fc:	853a                	mv	a0,a4
    33fe:	85be                	mv	a1,a5
    3400:	0141                	add	sp,sp,16
    3402:	8082                	ret

00003404 <.L27>:
    3404:	6711                	lui	a4,0x4
    3406:	3ff70713          	add	a4,a4,1023 # 43ff <.L30+0x11>
    340a:	00e78c63          	beq	a5,a4,3422 <.L29>
    340e:	7ff00713          	li	a4,2047
    3412:	00f75a63          	bge	a4,a5,3426 <.L30>
    3416:	4781                	li	a5,0
    3418:	4801                	li	a6,0
    341a:	c43e                	sw	a5,8(sp)
    341c:	c642                	sw	a6,12(sp)
    341e:	c03e                	sw	a5,0(sp)
    3420:	c242                	sw	a6,4(sp)

00003422 <.L29>:
    3422:	7ff00793          	li	a5,2047

00003426 <.L30>:
    3426:	45a2                	lw	a1,8(sp)
    3428:	4732                	lw	a4,12(sp)
    342a:	80000637          	lui	a2,0x80000
    342e:	01c5d513          	srl	a0,a1,0x1c
    3432:	8e79                	and	a2,a2,a4
    3434:	0712                	sll	a4,a4,0x4
    3436:	4692                	lw	a3,4(sp)
    3438:	8f49                	or	a4,a4,a0
    343a:	0732                	sll	a4,a4,0xc
    343c:	8331                	srl	a4,a4,0xc
    343e:	8e59                	or	a2,a2,a4
    3440:	82f1                	srl	a3,a3,0x1c
    3442:	0592                	sll	a1,a1,0x4
    3444:	07d2                	sll	a5,a5,0x14
    3446:	00b6e733          	or	a4,a3,a1
    344a:	8fd1                	or	a5,a5,a2
    344c:	bf45                	j	33fc <.L28>

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

0000344e <__SEGGER_RTL_float32_isnan>:
    344e:	ff0007b7          	lui	a5,0xff000
    3452:	0785                	add	a5,a5,1 # ff000001 <__AHB_SRAM_segment_end__+0xedf8001>
    3454:	0506                	sll	a0,a0,0x1
    3456:	00f53533          	sltu	a0,a0,a5
    345a:	00154513          	xor	a0,a0,1
    345e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

00003460 <__SEGGER_RTL_float32_isinf>:
    3460:	010007b7          	lui	a5,0x1000
    3464:	0506                	sll	a0,a0,0x1
    3466:	953e                	add	a0,a0,a5
    3468:	00153513          	seqz	a0,a0
    346c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

0000346e <__SEGGER_RTL_float32_isnormal>:
    346e:	ff0007b7          	lui	a5,0xff000
    3472:	0506                	sll	a0,a0,0x1
    3474:	953e                	add	a0,a0,a5
    3476:	fe0007b7          	lui	a5,0xfe000
    347a:	00f53533          	sltu	a0,a0,a5
    347e:	8082                	ret

Disassembly of section .text.libc.floorf:

00003480 <floorf>:
    3480:	00151693          	sll	a3,a0,0x1
    3484:	82e1                	srl	a3,a3,0x18
    3486:	01755793          	srl	a5,a0,0x17
    348a:	16fd                	add	a3,a3,-1 # 7fffffff <_extram_size+0x7dffffff>
    348c:	0fd00613          	li	a2,253
    3490:	872a                	mv	a4,a0
    3492:	0ff7f793          	zext.b	a5,a5
    3496:	00d67963          	bgeu	a2,a3,34a8 <.L1240>
    349a:	e789                	bnez	a5,34a4 <.L1241>
    349c:	800007b7          	lui	a5,0x80000
    34a0:	00f57733          	and	a4,a0,a5

000034a4 <.L1241>:
    34a4:	853a                	mv	a0,a4
    34a6:	8082                	ret

000034a8 <.L1240>:
    34a8:	f8178793          	add	a5,a5,-127 # 7fffff81 <_extram_size+0x7dffff81>
    34ac:	0007d963          	bgez	a5,34be <.L1243>
    34b0:	00000513          	li	a0,0
    34b4:	02075863          	bgez	a4,34e4 <.L1242>
    34b8:	b2c22503          	lw	a0,-1236(tp) # fffffb2c <__AHB_SRAM_segment_end__+0xfdf7b2c>
    34bc:	8082                	ret

000034be <.L1243>:
    34be:	46d9                	li	a3,22
    34c0:	02f6c263          	blt	a3,a5,34e4 <.L1242>
    34c4:	008006b7          	lui	a3,0x800
    34c8:	fff68613          	add	a2,a3,-1 # 7fffff <__DLM_segment_end__+0x5bffff>
    34cc:	00f65633          	srl	a2,a2,a5
    34d0:	fff64513          	not	a0,a2
    34d4:	8d79                	and	a0,a0,a4
    34d6:	8f71                	and	a4,a4,a2
    34d8:	c711                	beqz	a4,34e4 <.L1242>
    34da:	00055563          	bgez	a0,34e4 <.L1242>
    34de:	00f6d6b3          	srl	a3,a3,a5
    34e2:	9536                	add	a0,a0,a3

000034e4 <.L1242>:
    34e4:	8082                	ret

Disassembly of section .text.libc.__ashldi3:

000034e6 <__ashldi3>:
    34e6:	02067793          	and	a5,a2,32
    34ea:	ef89                	bnez	a5,3504 <.L__ashldi3LongShift>
    34ec:	00155793          	srl	a5,a0,0x1
    34f0:	fff64713          	not	a4,a2
    34f4:	00e7d7b3          	srl	a5,a5,a4
    34f8:	00c595b3          	sll	a1,a1,a2
    34fc:	8ddd                	or	a1,a1,a5
    34fe:	00c51533          	sll	a0,a0,a2
    3502:	8082                	ret

00003504 <.L__ashldi3LongShift>:
    3504:	00c515b3          	sll	a1,a0,a2
    3508:	4501                	li	a0,0
    350a:	8082                	ret

Disassembly of section .text.libc.__udivdi3:

0000350c <__udivdi3>:
    350c:	1101                	add	sp,sp,-32
    350e:	cc22                	sw	s0,24(sp)
    3510:	ca26                	sw	s1,20(sp)
    3512:	c84a                	sw	s2,16(sp)
    3514:	c64e                	sw	s3,12(sp)
    3516:	ce06                	sw	ra,28(sp)
    3518:	c452                	sw	s4,8(sp)
    351a:	c256                	sw	s5,4(sp)
    351c:	c05a                	sw	s6,0(sp)
    351e:	842a                	mv	s0,a0
    3520:	892e                	mv	s2,a1
    3522:	89b2                	mv	s3,a2
    3524:	84b6                	mv	s1,a3
    3526:	2e069063          	bnez	a3,3806 <.L47>
    352a:	ed99                	bnez	a1,3548 <.L48>
    352c:	02c55433          	divu	s0,a0,a2

00003530 <.L49>:
    3530:	40f2                	lw	ra,28(sp)
    3532:	8522                	mv	a0,s0
    3534:	4462                	lw	s0,24(sp)
    3536:	44d2                	lw	s1,20(sp)
    3538:	49b2                	lw	s3,12(sp)
    353a:	4a22                	lw	s4,8(sp)
    353c:	4a92                	lw	s5,4(sp)
    353e:	4b02                	lw	s6,0(sp)
    3540:	85ca                	mv	a1,s2
    3542:	4942                	lw	s2,16(sp)
    3544:	6105                	add	sp,sp,32
    3546:	8082                	ret

00003548 <.L48>:
    3548:	010007b7          	lui	a5,0x1000
    354c:	12f67863          	bgeu	a2,a5,367c <.L50>
    3550:	4791                	li	a5,4
    3552:	08c7e763          	bltu	a5,a2,35e0 <.L52>
    3556:	470d                	li	a4,3
    3558:	02e60263          	beq	a2,a4,357c <.L54>
    355c:	06f60a63          	beq	a2,a5,35d0 <.L55>
    3560:	4785                	li	a5,1
    3562:	fcf607e3          	beq	a2,a5,3530 <.L49>
    3566:	4789                	li	a5,2
    3568:	3af61c63          	bne	a2,a5,3920 <.L88>
    356c:	01f59793          	sll	a5,a1,0x1f
    3570:	00155413          	srl	s0,a0,0x1
    3574:	8c5d                	or	s0,s0,a5
    3576:	0015d913          	srl	s2,a1,0x1
    357a:	bf5d                	j	3530 <.L49>

0000357c <.L54>:
    357c:	555557b7          	lui	a5,0x55555
    3580:	55578793          	add	a5,a5,1365 # 55555555 <_extram_size+0x53555555>
    3584:	02b7b6b3          	mulhu	a3,a5,a1
    3588:	02a7b633          	mulhu	a2,a5,a0
    358c:	02a78733          	mul	a4,a5,a0
    3590:	02b787b3          	mul	a5,a5,a1
    3594:	97b2                	add	a5,a5,a2
    3596:	00c7b633          	sltu	a2,a5,a2
    359a:	9636                	add	a2,a2,a3
    359c:	00f706b3          	add	a3,a4,a5
    35a0:	00e6b733          	sltu	a4,a3,a4
    35a4:	9732                	add	a4,a4,a2
    35a6:	97ba                	add	a5,a5,a4
    35a8:	00e7b5b3          	sltu	a1,a5,a4
    35ac:	9736                	add	a4,a4,a3
    35ae:	00d736b3          	sltu	a3,a4,a3
    35b2:	0705                	add	a4,a4,1
    35b4:	97b6                	add	a5,a5,a3
    35b6:	00173713          	seqz	a4,a4
    35ba:	00d7b6b3          	sltu	a3,a5,a3
    35be:	962e                	add	a2,a2,a1
    35c0:	97ba                	add	a5,a5,a4
    35c2:	00c68933          	add	s2,a3,a2
    35c6:	00e7b733          	sltu	a4,a5,a4
    35ca:	843e                	mv	s0,a5
    35cc:	993a                	add	s2,s2,a4
    35ce:	b78d                	j	3530 <.L49>

000035d0 <.L55>:
    35d0:	01e59793          	sll	a5,a1,0x1e
    35d4:	00255413          	srl	s0,a0,0x2
    35d8:	8c5d                	or	s0,s0,a5
    35da:	0025d913          	srl	s2,a1,0x2
    35de:	bf89                	j	3530 <.L49>

000035e0 <.L52>:
    35e0:	67c1                	lui	a5,0x10
    35e2:	02c5d6b3          	divu	a3,a1,a2
    35e6:	01055713          	srl	a4,a0,0x10
    35ea:	02f67a63          	bgeu	a2,a5,361e <.L62>
    35ee:	01051413          	sll	s0,a0,0x10
    35f2:	8041                	srl	s0,s0,0x10
    35f4:	02c687b3          	mul	a5,a3,a2
    35f8:	40f587b3          	sub	a5,a1,a5
    35fc:	07c2                	sll	a5,a5,0x10
    35fe:	97ba                	add	a5,a5,a4
    3600:	02c7d933          	divu	s2,a5,a2
    3604:	02c90733          	mul	a4,s2,a2
    3608:	0942                	sll	s2,s2,0x10
    360a:	8f99                	sub	a5,a5,a4
    360c:	07c2                	sll	a5,a5,0x10
    360e:	943e                	add	s0,s0,a5
    3610:	02c45433          	divu	s0,s0,a2
    3614:	944a                	add	s0,s0,s2
    3616:	01243933          	sltu	s2,s0,s2
    361a:	9936                	add	s2,s2,a3
    361c:	bf11                	j	3530 <.L49>

0000361e <.L62>:
    361e:	02c687b3          	mul	a5,a3,a2
    3622:	01855613          	srl	a2,a0,0x18
    3626:	0ff77713          	zext.b	a4,a4
    362a:	0ff47413          	zext.b	s0,s0
    362e:	8936                	mv	s2,a3
    3630:	40f587b3          	sub	a5,a1,a5
    3634:	07a2                	sll	a5,a5,0x8
    3636:	963e                	add	a2,a2,a5
    3638:	033657b3          	divu	a5,a2,s3
    363c:	033785b3          	mul	a1,a5,s3
    3640:	07a2                	sll	a5,a5,0x8
    3642:	8e0d                	sub	a2,a2,a1
    3644:	0622                	sll	a2,a2,0x8
    3646:	9732                	add	a4,a4,a2
    3648:	033755b3          	divu	a1,a4,s3
    364c:	97ae                	add	a5,a5,a1
    364e:	07a2                	sll	a5,a5,0x8
    3650:	03358633          	mul	a2,a1,s3
    3654:	8f11                	sub	a4,a4,a2
    3656:	00855613          	srl	a2,a0,0x8
    365a:	0ff67613          	zext.b	a2,a2
    365e:	0722                	sll	a4,a4,0x8
    3660:	9732                	add	a4,a4,a2
    3662:	03375633          	divu	a2,a4,s3
    3666:	97b2                	add	a5,a5,a2
    3668:	07a2                	sll	a5,a5,0x8
    366a:	03360533          	mul	a0,a2,s3
    366e:	8f09                	sub	a4,a4,a0
    3670:	0722                	sll	a4,a4,0x8
    3672:	943a                	add	s0,s0,a4
    3674:	03345433          	divu	s0,s0,s3
    3678:	943e                	add	s0,s0,a5
    367a:	bd5d                	j	3530 <.L49>

0000367c <.L50>:
    367c:	57418a93          	add	s5,gp,1396 # ee4 <__SEGGER_RTL_Moeller_inverse_lut>
    3680:	0cc5f063          	bgeu	a1,a2,3740 <.L64>
    3684:	10000737          	lui	a4,0x10000
    3688:	87b2                	mv	a5,a2
    368a:	00e67563          	bgeu	a2,a4,3694 <.L65>
    368e:	00461793          	sll	a5,a2,0x4
    3692:	4491                	li	s1,4

00003694 <.L65>:
    3694:	40000737          	lui	a4,0x40000
    3698:	00e7f463          	bgeu	a5,a4,36a0 <.L66>
    369c:	0489                	add	s1,s1,2
    369e:	078a                	sll	a5,a5,0x2

000036a0 <.L66>:
    36a0:	0007c363          	bltz	a5,36a6 <.L67>
    36a4:	0485                	add	s1,s1,1

000036a6 <.L67>:
    36a6:	8626                	mv	a2,s1
    36a8:	8522                	mv	a0,s0
    36aa:	85ca                	mv	a1,s2
    36ac:	3d2d                	jal	34e6 <__ashldi3>
    36ae:	009994b3          	sll	s1,s3,s1
    36b2:	0164d793          	srl	a5,s1,0x16
    36b6:	e0078793          	add	a5,a5,-512 # fe00 <__AHB_SRAM_segment_size__+0x7e00>
    36ba:	0786                	sll	a5,a5,0x1
    36bc:	97d6                	add	a5,a5,s5
    36be:	0007d783          	lhu	a5,0(a5)
    36c2:	00b4d813          	srl	a6,s1,0xb
    36c6:	0014f713          	and	a4,s1,1
    36ca:	02f78633          	mul	a2,a5,a5
    36ce:	0792                	sll	a5,a5,0x4
    36d0:	0014d693          	srl	a3,s1,0x1
    36d4:	0805                	add	a6,a6,1
    36d6:	03063633          	mulhu	a2,a2,a6
    36da:	8f91                	sub	a5,a5,a2
    36dc:	96ba                	add	a3,a3,a4
    36de:	17fd                	add	a5,a5,-1
    36e0:	c319                	beqz	a4,36e6 <.L68>
    36e2:	0017d713          	srl	a4,a5,0x1

000036e6 <.L68>:
    36e6:	02f686b3          	mul	a3,a3,a5
    36ea:	8f15                	sub	a4,a4,a3
    36ec:	02e7b733          	mulhu	a4,a5,a4
    36f0:	07be                	sll	a5,a5,0xf
    36f2:	8305                	srl	a4,a4,0x1
    36f4:	97ba                	add	a5,a5,a4
    36f6:	8726                	mv	a4,s1
    36f8:	029786b3          	mul	a3,a5,s1
    36fc:	9736                	add	a4,a4,a3
    36fe:	00d736b3          	sltu	a3,a4,a3
    3702:	8726                	mv	a4,s1
    3704:	9736                	add	a4,a4,a3
    3706:	0297b6b3          	mulhu	a3,a5,s1
    370a:	9736                	add	a4,a4,a3
    370c:	8f99                	sub	a5,a5,a4
    370e:	02b7b733          	mulhu	a4,a5,a1
    3712:	02b787b3          	mul	a5,a5,a1
    3716:	00a786b3          	add	a3,a5,a0
    371a:	00f6b7b3          	sltu	a5,a3,a5
    371e:	95be                	add	a1,a1,a5
    3720:	00b707b3          	add	a5,a4,a1
    3724:	00178413          	add	s0,a5,1
    3728:	02848733          	mul	a4,s1,s0
    372c:	8d19                	sub	a0,a0,a4
    372e:	00a6f463          	bgeu	a3,a0,3736 <.L69>
    3732:	9526                	add	a0,a0,s1
    3734:	843e                	mv	s0,a5

00003736 <.L69>:
    3736:	00956363          	bltu	a0,s1,373c <.L109>
    373a:	0405                	add	s0,s0,1

0000373c <.L109>:
    373c:	4901                	li	s2,0
    373e:	bbcd                	j	3530 <.L49>

00003740 <.L64>:
    3740:	02c5da33          	divu	s4,a1,a2
    3744:	10000737          	lui	a4,0x10000
    3748:	87b2                	mv	a5,a2
    374a:	02ca05b3          	mul	a1,s4,a2
    374e:	40b905b3          	sub	a1,s2,a1
    3752:	00e67563          	bgeu	a2,a4,375c <.L71>
    3756:	00461793          	sll	a5,a2,0x4
    375a:	4491                	li	s1,4

0000375c <.L71>:
    375c:	40000737          	lui	a4,0x40000
    3760:	00e7f463          	bgeu	a5,a4,3768 <.L72>
    3764:	0489                	add	s1,s1,2
    3766:	078a                	sll	a5,a5,0x2

00003768 <.L72>:
    3768:	0007c363          	bltz	a5,376e <.L73>
    376c:	0485                	add	s1,s1,1

0000376e <.L73>:
    376e:	8626                	mv	a2,s1
    3770:	8522                	mv	a0,s0
    3772:	3b95                	jal	34e6 <__ashldi3>
    3774:	009994b3          	sll	s1,s3,s1
    3778:	0164d793          	srl	a5,s1,0x16
    377c:	e0078793          	add	a5,a5,-512
    3780:	0786                	sll	a5,a5,0x1
    3782:	9abe                	add	s5,s5,a5
    3784:	000ad783          	lhu	a5,0(s5)
    3788:	00b4d813          	srl	a6,s1,0xb
    378c:	0014f713          	and	a4,s1,1
    3790:	02f78633          	mul	a2,a5,a5
    3794:	0792                	sll	a5,a5,0x4
    3796:	0014d693          	srl	a3,s1,0x1
    379a:	0805                	add	a6,a6,1
    379c:	03063633          	mulhu	a2,a2,a6
    37a0:	8f91                	sub	a5,a5,a2
    37a2:	96ba                	add	a3,a3,a4
    37a4:	17fd                	add	a5,a5,-1
    37a6:	c319                	beqz	a4,37ac <.L74>
    37a8:	0017d713          	srl	a4,a5,0x1

000037ac <.L74>:
    37ac:	02f686b3          	mul	a3,a3,a5
    37b0:	8f15                	sub	a4,a4,a3
    37b2:	02e7b733          	mulhu	a4,a5,a4
    37b6:	07be                	sll	a5,a5,0xf
    37b8:	8305                	srl	a4,a4,0x1
    37ba:	97ba                	add	a5,a5,a4
    37bc:	8726                	mv	a4,s1
    37be:	029786b3          	mul	a3,a5,s1
    37c2:	9736                	add	a4,a4,a3
    37c4:	00d736b3          	sltu	a3,a4,a3
    37c8:	8726                	mv	a4,s1
    37ca:	9736                	add	a4,a4,a3
    37cc:	0297b6b3          	mulhu	a3,a5,s1
    37d0:	9736                	add	a4,a4,a3
    37d2:	8f99                	sub	a5,a5,a4
    37d4:	02b7b733          	mulhu	a4,a5,a1
    37d8:	02b787b3          	mul	a5,a5,a1
    37dc:	00a786b3          	add	a3,a5,a0
    37e0:	00f6b7b3          	sltu	a5,a3,a5
    37e4:	95be                	add	a1,a1,a5
    37e6:	00b707b3          	add	a5,a4,a1
    37ea:	00178413          	add	s0,a5,1
    37ee:	02848733          	mul	a4,s1,s0
    37f2:	8d19                	sub	a0,a0,a4
    37f4:	00a6f463          	bgeu	a3,a0,37fc <.L75>
    37f8:	9526                	add	a0,a0,s1
    37fa:	843e                	mv	s0,a5

000037fc <.L75>:
    37fc:	00956363          	bltu	a0,s1,3802 <.L76>
    3800:	0405                	add	s0,s0,1

00003802 <.L76>:
    3802:	8952                	mv	s2,s4
    3804:	b335                	j	3530 <.L49>

00003806 <.L47>:
    3806:	67c1                	lui	a5,0x10
    3808:	8ab6                	mv	s5,a3
    380a:	4a01                	li	s4,0
    380c:	00f6f563          	bgeu	a3,a5,3816 <.L77>
    3810:	01069493          	sll	s1,a3,0x10
    3814:	4a41                	li	s4,16

00003816 <.L77>:
    3816:	010007b7          	lui	a5,0x1000
    381a:	00f4f463          	bgeu	s1,a5,3822 <.L78>
    381e:	0a21                	add	s4,s4,8
    3820:	04a2                	sll	s1,s1,0x8

00003822 <.L78>:
    3822:	100007b7          	lui	a5,0x10000
    3826:	00f4f463          	bgeu	s1,a5,382e <.L79>
    382a:	0a11                	add	s4,s4,4
    382c:	0492                	sll	s1,s1,0x4

0000382e <.L79>:
    382e:	400007b7          	lui	a5,0x40000
    3832:	00f4f463          	bgeu	s1,a5,383a <.L80>
    3836:	0a09                	add	s4,s4,2
    3838:	048a                	sll	s1,s1,0x2

0000383a <.L80>:
    383a:	0004c363          	bltz	s1,3840 <.L81>
    383e:	0a05                	add	s4,s4,1

00003840 <.L81>:
    3840:	01f91793          	sll	a5,s2,0x1f
    3844:	8652                	mv	a2,s4
    3846:	00145493          	srl	s1,s0,0x1
    384a:	854e                	mv	a0,s3
    384c:	85d6                	mv	a1,s5
    384e:	8cdd                	or	s1,s1,a5
    3850:	3959                	jal	34e6 <__ashldi3>
    3852:	0165d613          	srl	a2,a1,0x16
    3856:	e0060613          	add	a2,a2,-512 # 7ffffe00 <_extram_size+0x7dfffe00>
    385a:	0606                	sll	a2,a2,0x1
    385c:	57418793          	add	a5,gp,1396 # ee4 <__SEGGER_RTL_Moeller_inverse_lut>
    3860:	97b2                	add	a5,a5,a2
    3862:	0007d783          	lhu	a5,0(a5) # 40000000 <_extram_size+0x3e000000>
    3866:	00b5d513          	srl	a0,a1,0xb
    386a:	0015f713          	and	a4,a1,1
    386e:	02f78633          	mul	a2,a5,a5
    3872:	0792                	sll	a5,a5,0x4
    3874:	0015d693          	srl	a3,a1,0x1
    3878:	0505                	add	a0,a0,1 # 7f800001 <_extram_size+0x7d800001>
    387a:	02a63633          	mulhu	a2,a2,a0
    387e:	8f91                	sub	a5,a5,a2
    3880:	00195b13          	srl	s6,s2,0x1
    3884:	96ba                	add	a3,a3,a4
    3886:	17fd                	add	a5,a5,-1
    3888:	c319                	beqz	a4,388e <.L82>
    388a:	0017d713          	srl	a4,a5,0x1

0000388e <.L82>:
    388e:	02f686b3          	mul	a3,a3,a5
    3892:	8f15                	sub	a4,a4,a3
    3894:	02e7b733          	mulhu	a4,a5,a4
    3898:	07be                	sll	a5,a5,0xf
    389a:	8305                	srl	a4,a4,0x1
    389c:	97ba                	add	a5,a5,a4
    389e:	872e                	mv	a4,a1
    38a0:	02b786b3          	mul	a3,a5,a1
    38a4:	9736                	add	a4,a4,a3
    38a6:	00d736b3          	sltu	a3,a4,a3
    38aa:	872e                	mv	a4,a1
    38ac:	9736                	add	a4,a4,a3
    38ae:	02b7b6b3          	mulhu	a3,a5,a1
    38b2:	9736                	add	a4,a4,a3
    38b4:	8f99                	sub	a5,a5,a4
    38b6:	0367b733          	mulhu	a4,a5,s6
    38ba:	036787b3          	mul	a5,a5,s6
    38be:	009786b3          	add	a3,a5,s1
    38c2:	00f6b7b3          	sltu	a5,a3,a5
    38c6:	97da                	add	a5,a5,s6
    38c8:	973e                	add	a4,a4,a5
    38ca:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
    38ce:	02f58633          	mul	a2,a1,a5
    38d2:	8c91                	sub	s1,s1,a2
    38d4:	0096f463          	bgeu	a3,s1,38dc <.L83>
    38d8:	94ae                	add	s1,s1,a1
    38da:	87ba                	mv	a5,a4

000038dc <.L83>:
    38dc:	00b4e363          	bltu	s1,a1,38e2 <.L84>
    38e0:	0785                	add	a5,a5,1

000038e2 <.L84>:
    38e2:	477d                	li	a4,31
    38e4:	41470733          	sub	a4,a4,s4
    38e8:	00e7d633          	srl	a2,a5,a4
    38ec:	c211                	beqz	a2,38f0 <.L85>
    38ee:	167d                	add	a2,a2,-1

000038f0 <.L85>:
    38f0:	02ca87b3          	mul	a5,s5,a2
    38f4:	03360733          	mul	a4,a2,s3
    38f8:	033636b3          	mulhu	a3,a2,s3
    38fc:	40e40733          	sub	a4,s0,a4
    3900:	00e43433          	sltu	s0,s0,a4
    3904:	97b6                	add	a5,a5,a3
    3906:	40f907b3          	sub	a5,s2,a5
    390a:	40878433          	sub	s0,a5,s0
    390e:	01546763          	bltu	s0,s5,391c <.L86>
    3912:	008a9463          	bne	s5,s0,391a <.L95>
    3916:	01376363          	bltu	a4,s3,391c <.L86>

0000391a <.L95>:
    391a:	0605                	add	a2,a2,1

0000391c <.L86>:
    391c:	8432                	mv	s0,a2
    391e:	bd39                	j	373c <.L109>

00003920 <.L88>:
    3920:	4401                	li	s0,0
    3922:	bd29                	j	373c <.L109>

Disassembly of section .text.libc.__umoddi3:

00003924 <__umoddi3>:
    3924:	1101                	add	sp,sp,-32
    3926:	cc22                	sw	s0,24(sp)
    3928:	ca26                	sw	s1,20(sp)
    392a:	c84a                	sw	s2,16(sp)
    392c:	c64e                	sw	s3,12(sp)
    392e:	c452                	sw	s4,8(sp)
    3930:	ce06                	sw	ra,28(sp)
    3932:	c256                	sw	s5,4(sp)
    3934:	c05a                	sw	s6,0(sp)
    3936:	892a                	mv	s2,a0
    3938:	84ae                	mv	s1,a1
    393a:	8432                	mv	s0,a2
    393c:	89b6                	mv	s3,a3
    393e:	8a36                	mv	s4,a3
    3940:	2e069c63          	bnez	a3,3c38 <.L111>
    3944:	e589                	bnez	a1,394e <.L112>
    3946:	02c557b3          	divu	a5,a0,a2

0000394a <.L174>:
    394a:	4701                	li	a4,0
    394c:	a815                	j	3980 <.L113>

0000394e <.L112>:
    394e:	010007b7          	lui	a5,0x1000
    3952:	16f67163          	bgeu	a2,a5,3ab4 <.L114>
    3956:	4791                	li	a5,4
    3958:	0cc7e063          	bltu	a5,a2,3a18 <.L116>
    395c:	470d                	li	a4,3
    395e:	04e60d63          	beq	a2,a4,39b8 <.L118>
    3962:	0af60363          	beq	a2,a5,3a08 <.L119>
    3966:	4785                	li	a5,1
    3968:	3ef60363          	beq	a2,a5,3d4e <.L152>
    396c:	4789                	li	a5,2
    396e:	3ef61363          	bne	a2,a5,3d54 <.L153>
    3972:	01f59713          	sll	a4,a1,0x1f
    3976:	00155793          	srl	a5,a0,0x1
    397a:	8fd9                	or	a5,a5,a4
    397c:	0015d713          	srl	a4,a1,0x1

00003980 <.L113>:
    3980:	02870733          	mul	a4,a4,s0
    3984:	40f2                	lw	ra,28(sp)
    3986:	4a22                	lw	s4,8(sp)
    3988:	4a92                	lw	s5,4(sp)
    398a:	4b02                	lw	s6,0(sp)
    398c:	02f989b3          	mul	s3,s3,a5
    3990:	02f40533          	mul	a0,s0,a5
    3994:	99ba                	add	s3,s3,a4
    3996:	02f43433          	mulhu	s0,s0,a5
    399a:	40a90533          	sub	a0,s2,a0
    399e:	00a935b3          	sltu	a1,s2,a0
    39a2:	4942                	lw	s2,16(sp)
    39a4:	99a2                	add	s3,s3,s0
    39a6:	4462                	lw	s0,24(sp)
    39a8:	413484b3          	sub	s1,s1,s3
    39ac:	40b485b3          	sub	a1,s1,a1
    39b0:	49b2                	lw	s3,12(sp)
    39b2:	44d2                	lw	s1,20(sp)
    39b4:	6105                	add	sp,sp,32
    39b6:	8082                	ret

000039b8 <.L118>:
    39b8:	555557b7          	lui	a5,0x55555
    39bc:	55578793          	add	a5,a5,1365 # 55555555 <_extram_size+0x53555555>
    39c0:	02b7b6b3          	mulhu	a3,a5,a1
    39c4:	02a7b633          	mulhu	a2,a5,a0
    39c8:	02a78733          	mul	a4,a5,a0
    39cc:	02b787b3          	mul	a5,a5,a1
    39d0:	97b2                	add	a5,a5,a2
    39d2:	00c7b633          	sltu	a2,a5,a2
    39d6:	9636                	add	a2,a2,a3
    39d8:	00f706b3          	add	a3,a4,a5
    39dc:	00e6b733          	sltu	a4,a3,a4
    39e0:	9732                	add	a4,a4,a2
    39e2:	97ba                	add	a5,a5,a4
    39e4:	00e7b5b3          	sltu	a1,a5,a4
    39e8:	9736                	add	a4,a4,a3
    39ea:	00d736b3          	sltu	a3,a4,a3
    39ee:	0705                	add	a4,a4,1
    39f0:	97b6                	add	a5,a5,a3
    39f2:	00173713          	seqz	a4,a4
    39f6:	00d7b6b3          	sltu	a3,a5,a3
    39fa:	962e                	add	a2,a2,a1
    39fc:	97ba                	add	a5,a5,a4
    39fe:	96b2                	add	a3,a3,a2
    3a00:	00e7b733          	sltu	a4,a5,a4
    3a04:	9736                	add	a4,a4,a3
    3a06:	bfad                	j	3980 <.L113>

00003a08 <.L119>:
    3a08:	01e59713          	sll	a4,a1,0x1e
    3a0c:	00255793          	srl	a5,a0,0x2
    3a10:	8fd9                	or	a5,a5,a4
    3a12:	0025d713          	srl	a4,a1,0x2
    3a16:	b7ad                	j	3980 <.L113>

00003a18 <.L116>:
    3a18:	67c1                	lui	a5,0x10
    3a1a:	02c5d733          	divu	a4,a1,a2
    3a1e:	01055693          	srl	a3,a0,0x10
    3a22:	02f67b63          	bgeu	a2,a5,3a58 <.L126>
    3a26:	02c707b3          	mul	a5,a4,a2
    3a2a:	40f587b3          	sub	a5,a1,a5
    3a2e:	07c2                	sll	a5,a5,0x10
    3a30:	97b6                	add	a5,a5,a3
    3a32:	02c7d633          	divu	a2,a5,a2
    3a36:	028606b3          	mul	a3,a2,s0
    3a3a:	0642                	sll	a2,a2,0x10
    3a3c:	8f95                	sub	a5,a5,a3
    3a3e:	01079693          	sll	a3,a5,0x10
    3a42:	01051793          	sll	a5,a0,0x10
    3a46:	83c1                	srl	a5,a5,0x10
    3a48:	97b6                	add	a5,a5,a3
    3a4a:	0287d7b3          	divu	a5,a5,s0
    3a4e:	97b2                	add	a5,a5,a2
    3a50:	00c7b633          	sltu	a2,a5,a2
    3a54:	9732                	add	a4,a4,a2
    3a56:	b72d                	j	3980 <.L113>

00003a58 <.L126>:
    3a58:	02c707b3          	mul	a5,a4,a2
    3a5c:	01855613          	srl	a2,a0,0x18
    3a60:	0ff6f693          	zext.b	a3,a3
    3a64:	40f587b3          	sub	a5,a1,a5
    3a68:	07a2                	sll	a5,a5,0x8
    3a6a:	963e                	add	a2,a2,a5
    3a6c:	028657b3          	divu	a5,a2,s0
    3a70:	028785b3          	mul	a1,a5,s0
    3a74:	07a2                	sll	a5,a5,0x8
    3a76:	8e0d                	sub	a2,a2,a1
    3a78:	0622                	sll	a2,a2,0x8
    3a7a:	96b2                	add	a3,a3,a2
    3a7c:	0286d5b3          	divu	a1,a3,s0
    3a80:	97ae                	add	a5,a5,a1
    3a82:	07a2                	sll	a5,a5,0x8
    3a84:	02858633          	mul	a2,a1,s0
    3a88:	8e91                	sub	a3,a3,a2
    3a8a:	00855613          	srl	a2,a0,0x8
    3a8e:	0ff67613          	zext.b	a2,a2
    3a92:	06a2                	sll	a3,a3,0x8
    3a94:	96b2                	add	a3,a3,a2
    3a96:	0286d633          	divu	a2,a3,s0
    3a9a:	97b2                	add	a5,a5,a2
    3a9c:	07a2                	sll	a5,a5,0x8
    3a9e:	02860533          	mul	a0,a2,s0
    3aa2:	0ff97613          	zext.b	a2,s2
    3aa6:	8e89                	sub	a3,a3,a0
    3aa8:	06a2                	sll	a3,a3,0x8
    3aaa:	96b2                	add	a3,a3,a2
    3aac:	0286d6b3          	divu	a3,a3,s0
    3ab0:	97b6                	add	a5,a5,a3
    3ab2:	b5f9                	j	3980 <.L113>

00003ab4 <.L114>:
    3ab4:	57418b13          	add	s6,gp,1396 # ee4 <__SEGGER_RTL_Moeller_inverse_lut>
    3ab8:	0ac5fe63          	bgeu	a1,a2,3b74 <.L128>
    3abc:	10000737          	lui	a4,0x10000
    3ac0:	87b2                	mv	a5,a2
    3ac2:	00e67563          	bgeu	a2,a4,3acc <.L129>
    3ac6:	00461793          	sll	a5,a2,0x4
    3aca:	4a11                	li	s4,4

00003acc <.L129>:
    3acc:	40000737          	lui	a4,0x40000
    3ad0:	00e7f463          	bgeu	a5,a4,3ad8 <.L130>
    3ad4:	0a09                	add	s4,s4,2
    3ad6:	078a                	sll	a5,a5,0x2

00003ad8 <.L130>:
    3ad8:	0007c363          	bltz	a5,3ade <.L131>
    3adc:	0a05                	add	s4,s4,1

00003ade <.L131>:
    3ade:	8652                	mv	a2,s4
    3ae0:	854a                	mv	a0,s2
    3ae2:	85a6                	mv	a1,s1
    3ae4:	3409                	jal	34e6 <__ashldi3>
    3ae6:	01441a33          	sll	s4,s0,s4
    3aea:	016a5793          	srl	a5,s4,0x16
    3aee:	e0078793          	add	a5,a5,-512 # fe00 <__AHB_SRAM_segment_size__+0x7e00>
    3af2:	0786                	sll	a5,a5,0x1
    3af4:	97da                	add	a5,a5,s6
    3af6:	0007d783          	lhu	a5,0(a5)
    3afa:	00ba5813          	srl	a6,s4,0xb
    3afe:	001a7713          	and	a4,s4,1
    3b02:	02f78633          	mul	a2,a5,a5
    3b06:	0792                	sll	a5,a5,0x4
    3b08:	001a5693          	srl	a3,s4,0x1
    3b0c:	0805                	add	a6,a6,1
    3b0e:	03063633          	mulhu	a2,a2,a6
    3b12:	8f91                	sub	a5,a5,a2
    3b14:	96ba                	add	a3,a3,a4
    3b16:	17fd                	add	a5,a5,-1
    3b18:	c319                	beqz	a4,3b1e <.L132>
    3b1a:	0017d713          	srl	a4,a5,0x1

00003b1e <.L132>:
    3b1e:	02f686b3          	mul	a3,a3,a5
    3b22:	8f15                	sub	a4,a4,a3
    3b24:	02e7b733          	mulhu	a4,a5,a4
    3b28:	07be                	sll	a5,a5,0xf
    3b2a:	8305                	srl	a4,a4,0x1
    3b2c:	97ba                	add	a5,a5,a4
    3b2e:	8752                	mv	a4,s4
    3b30:	034786b3          	mul	a3,a5,s4
    3b34:	9736                	add	a4,a4,a3
    3b36:	00d736b3          	sltu	a3,a4,a3
    3b3a:	8752                	mv	a4,s4
    3b3c:	9736                	add	a4,a4,a3
    3b3e:	0347b6b3          	mulhu	a3,a5,s4
    3b42:	9736                	add	a4,a4,a3
    3b44:	8f99                	sub	a5,a5,a4
    3b46:	02b7b733          	mulhu	a4,a5,a1
    3b4a:	02b787b3          	mul	a5,a5,a1
    3b4e:	00a786b3          	add	a3,a5,a0
    3b52:	00f6b7b3          	sltu	a5,a3,a5
    3b56:	95be                	add	a1,a1,a5
    3b58:	972e                	add	a4,a4,a1
    3b5a:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
    3b5e:	02fa0633          	mul	a2,s4,a5
    3b62:	8d11                	sub	a0,a0,a2
    3b64:	00a6f463          	bgeu	a3,a0,3b6c <.L133>
    3b68:	9552                	add	a0,a0,s4
    3b6a:	87ba                	mv	a5,a4

00003b6c <.L133>:
    3b6c:	dd456fe3          	bltu	a0,s4,394a <.L174>

00003b70 <.L160>:
    3b70:	0785                	add	a5,a5,1
    3b72:	bbe1                	j	394a <.L174>

00003b74 <.L128>:
    3b74:	02c5dab3          	divu	s5,a1,a2
    3b78:	10000737          	lui	a4,0x10000
    3b7c:	87b2                	mv	a5,a2
    3b7e:	02ca85b3          	mul	a1,s5,a2
    3b82:	40b485b3          	sub	a1,s1,a1
    3b86:	00e67563          	bgeu	a2,a4,3b90 <.L135>
    3b8a:	00461793          	sll	a5,a2,0x4
    3b8e:	4a11                	li	s4,4

00003b90 <.L135>:
    3b90:	40000737          	lui	a4,0x40000
    3b94:	00e7f463          	bgeu	a5,a4,3b9c <.L136>
    3b98:	0a09                	add	s4,s4,2
    3b9a:	078a                	sll	a5,a5,0x2

00003b9c <.L136>:
    3b9c:	0007c363          	bltz	a5,3ba2 <.L137>
    3ba0:	0a05                	add	s4,s4,1

00003ba2 <.L137>:
    3ba2:	8652                	mv	a2,s4
    3ba4:	854a                	mv	a0,s2
    3ba6:	3281                	jal	34e6 <__ashldi3>
    3ba8:	01441a33          	sll	s4,s0,s4
    3bac:	016a5793          	srl	a5,s4,0x16
    3bb0:	e0078793          	add	a5,a5,-512
    3bb4:	0786                	sll	a5,a5,0x1
    3bb6:	9b3e                	add	s6,s6,a5
    3bb8:	000b5783          	lhu	a5,0(s6)
    3bbc:	00ba5813          	srl	a6,s4,0xb
    3bc0:	001a7713          	and	a4,s4,1
    3bc4:	02f78633          	mul	a2,a5,a5
    3bc8:	0792                	sll	a5,a5,0x4
    3bca:	001a5693          	srl	a3,s4,0x1
    3bce:	0805                	add	a6,a6,1
    3bd0:	03063633          	mulhu	a2,a2,a6
    3bd4:	8f91                	sub	a5,a5,a2
    3bd6:	96ba                	add	a3,a3,a4
    3bd8:	17fd                	add	a5,a5,-1
    3bda:	c319                	beqz	a4,3be0 <.L138>
    3bdc:	0017d713          	srl	a4,a5,0x1

00003be0 <.L138>:
    3be0:	02f686b3          	mul	a3,a3,a5
    3be4:	8f15                	sub	a4,a4,a3
    3be6:	02e7b733          	mulhu	a4,a5,a4
    3bea:	07be                	sll	a5,a5,0xf
    3bec:	8305                	srl	a4,a4,0x1
    3bee:	97ba                	add	a5,a5,a4
    3bf0:	8752                	mv	a4,s4
    3bf2:	034786b3          	mul	a3,a5,s4
    3bf6:	9736                	add	a4,a4,a3
    3bf8:	00d736b3          	sltu	a3,a4,a3
    3bfc:	8752                	mv	a4,s4
    3bfe:	9736                	add	a4,a4,a3
    3c00:	0347b6b3          	mulhu	a3,a5,s4
    3c04:	9736                	add	a4,a4,a3
    3c06:	8f99                	sub	a5,a5,a4
    3c08:	02b7b733          	mulhu	a4,a5,a1
    3c0c:	02b787b3          	mul	a5,a5,a1
    3c10:	00a786b3          	add	a3,a5,a0
    3c14:	00f6b7b3          	sltu	a5,a3,a5
    3c18:	95be                	add	a1,a1,a5
    3c1a:	972e                	add	a4,a4,a1
    3c1c:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
    3c20:	02fa0633          	mul	a2,s4,a5
    3c24:	8d11                	sub	a0,a0,a2
    3c26:	00a6f463          	bgeu	a3,a0,3c2e <.L139>
    3c2a:	9552                	add	a0,a0,s4
    3c2c:	87ba                	mv	a5,a4

00003c2e <.L139>:
    3c2e:	01456363          	bltu	a0,s4,3c34 <.L140>
    3c32:	0785                	add	a5,a5,1

00003c34 <.L140>:
    3c34:	8756                	mv	a4,s5
    3c36:	b3a9                	j	3980 <.L113>

00003c38 <.L111>:
    3c38:	67c1                	lui	a5,0x10
    3c3a:	4a81                	li	s5,0
    3c3c:	00f6f563          	bgeu	a3,a5,3c46 <.L141>
    3c40:	01069a13          	sll	s4,a3,0x10
    3c44:	4ac1                	li	s5,16

00003c46 <.L141>:
    3c46:	010007b7          	lui	a5,0x1000
    3c4a:	00fa7463          	bgeu	s4,a5,3c52 <.L142>
    3c4e:	0aa1                	add	s5,s5,8
    3c50:	0a22                	sll	s4,s4,0x8

00003c52 <.L142>:
    3c52:	100007b7          	lui	a5,0x10000
    3c56:	00fa7463          	bgeu	s4,a5,3c5e <.L143>
    3c5a:	0a91                	add	s5,s5,4
    3c5c:	0a12                	sll	s4,s4,0x4

00003c5e <.L143>:
    3c5e:	400007b7          	lui	a5,0x40000
    3c62:	00fa7463          	bgeu	s4,a5,3c6a <.L144>
    3c66:	0a89                	add	s5,s5,2
    3c68:	0a0a                	sll	s4,s4,0x2

00003c6a <.L144>:
    3c6a:	000a4363          	bltz	s4,3c70 <.L145>
    3c6e:	0a85                	add	s5,s5,1

00003c70 <.L145>:
    3c70:	01f49793          	sll	a5,s1,0x1f
    3c74:	8656                	mv	a2,s5
    3c76:	00195a13          	srl	s4,s2,0x1
    3c7a:	8522                	mv	a0,s0
    3c7c:	85ce                	mv	a1,s3
    3c7e:	0147ea33          	or	s4,a5,s4
    3c82:	3095                	jal	34e6 <__ashldi3>
    3c84:	0165d613          	srl	a2,a1,0x16
    3c88:	e0060613          	add	a2,a2,-512
    3c8c:	0606                	sll	a2,a2,0x1
    3c8e:	57418793          	add	a5,gp,1396 # ee4 <__SEGGER_RTL_Moeller_inverse_lut>
    3c92:	97b2                	add	a5,a5,a2
    3c94:	0007d783          	lhu	a5,0(a5) # 40000000 <_extram_size+0x3e000000>
    3c98:	00b5d513          	srl	a0,a1,0xb
    3c9c:	0015f713          	and	a4,a1,1
    3ca0:	02f78633          	mul	a2,a5,a5
    3ca4:	0792                	sll	a5,a5,0x4
    3ca6:	0015d693          	srl	a3,a1,0x1
    3caa:	0505                	add	a0,a0,1
    3cac:	02a63633          	mulhu	a2,a2,a0
    3cb0:	8f91                	sub	a5,a5,a2
    3cb2:	0014db13          	srl	s6,s1,0x1
    3cb6:	96ba                	add	a3,a3,a4
    3cb8:	17fd                	add	a5,a5,-1
    3cba:	c319                	beqz	a4,3cc0 <.L146>
    3cbc:	0017d713          	srl	a4,a5,0x1

00003cc0 <.L146>:
    3cc0:	02f686b3          	mul	a3,a3,a5
    3cc4:	8f15                	sub	a4,a4,a3
    3cc6:	02e7b733          	mulhu	a4,a5,a4
    3cca:	07be                	sll	a5,a5,0xf
    3ccc:	8305                	srl	a4,a4,0x1
    3cce:	97ba                	add	a5,a5,a4
    3cd0:	872e                	mv	a4,a1
    3cd2:	02b786b3          	mul	a3,a5,a1
    3cd6:	9736                	add	a4,a4,a3
    3cd8:	00d736b3          	sltu	a3,a4,a3
    3cdc:	872e                	mv	a4,a1
    3cde:	9736                	add	a4,a4,a3
    3ce0:	02b7b6b3          	mulhu	a3,a5,a1
    3ce4:	9736                	add	a4,a4,a3
    3ce6:	8f99                	sub	a5,a5,a4
    3ce8:	0367b733          	mulhu	a4,a5,s6
    3cec:	036787b3          	mul	a5,a5,s6
    3cf0:	014786b3          	add	a3,a5,s4
    3cf4:	00f6b7b3          	sltu	a5,a3,a5
    3cf8:	97da                	add	a5,a5,s6
    3cfa:	973e                	add	a4,a4,a5
    3cfc:	00170793          	add	a5,a4,1
    3d00:	02f58633          	mul	a2,a1,a5
    3d04:	40ca0a33          	sub	s4,s4,a2
    3d08:	0146f463          	bgeu	a3,s4,3d10 <.L147>
    3d0c:	9a2e                	add	s4,s4,a1
    3d0e:	87ba                	mv	a5,a4

00003d10 <.L147>:
    3d10:	00ba6363          	bltu	s4,a1,3d16 <.L148>
    3d14:	0785                	add	a5,a5,1

00003d16 <.L148>:
    3d16:	477d                	li	a4,31
    3d18:	41570733          	sub	a4,a4,s5
    3d1c:	00e7d7b3          	srl	a5,a5,a4
    3d20:	c391                	beqz	a5,3d24 <.L149>
    3d22:	17fd                	add	a5,a5,-1

00003d24 <.L149>:
    3d24:	0287b633          	mulhu	a2,a5,s0
    3d28:	02f98733          	mul	a4,s3,a5
    3d2c:	028786b3          	mul	a3,a5,s0
    3d30:	9732                	add	a4,a4,a2
    3d32:	40e48733          	sub	a4,s1,a4
    3d36:	40d906b3          	sub	a3,s2,a3
    3d3a:	00d93633          	sltu	a2,s2,a3
    3d3e:	8f11                	sub	a4,a4,a2
    3d40:	c13765e3          	bltu	a4,s3,394a <.L174>
    3d44:	e2e996e3          	bne	s3,a4,3b70 <.L160>
    3d48:	c086e1e3          	bltu	a3,s0,394a <.L174>
    3d4c:	b515                	j	3b70 <.L160>

00003d4e <.L152>:
    3d4e:	87aa                	mv	a5,a0
    3d50:	872e                	mv	a4,a1
    3d52:	b13d                	j	3980 <.L113>

00003d54 <.L153>:
    3d54:	4781                	li	a5,0
    3d56:	bed5                	j	394a <.L174>

Disassembly of section .text.libc.abs:

00003d58 <abs>:
    3d58:	41f55793          	sra	a5,a0,0x1f
    3d5c:	8d3d                	xor	a0,a0,a5
    3d5e:	8d1d                	sub	a0,a0,a5
    3d60:	8082                	ret

Disassembly of section .text.libc.memcpy:

00003d62 <memcpy>:
    3d62:	c251                	beqz	a2,3de6 <.Lmemcpy_done>
    3d64:	87aa                	mv	a5,a0
    3d66:	00b546b3          	xor	a3,a0,a1
    3d6a:	06fa                	sll	a3,a3,0x1e
    3d6c:	e2bd                	bnez	a3,3dd2 <.Lmemcpy_byte_copy>
    3d6e:	01e51693          	sll	a3,a0,0x1e
    3d72:	ce81                	beqz	a3,3d8a <.Lmemcpy_aligned>

00003d74 <.Lmemcpy_word_align>:
    3d74:	00058683          	lb	a3,0(a1)
    3d78:	00d50023          	sb	a3,0(a0)
    3d7c:	0585                	add	a1,a1,1
    3d7e:	0505                	add	a0,a0,1
    3d80:	167d                	add	a2,a2,-1
    3d82:	c22d                	beqz	a2,3de4 <.Lmemcpy_memcpy_end>
    3d84:	01e51693          	sll	a3,a0,0x1e
    3d88:	f6f5                	bnez	a3,3d74 <.Lmemcpy_word_align>

00003d8a <.Lmemcpy_aligned>:
    3d8a:	02000693          	li	a3,32
    3d8e:	02d66763          	bltu	a2,a3,3dbc <.Lmemcpy_word_copy>

00003d92 <.Lmemcpy_aligned_block_copy_loop>:
    3d92:	4198                	lw	a4,0(a1)
    3d94:	c118                	sw	a4,0(a0)
    3d96:	41d8                	lw	a4,4(a1)
    3d98:	c158                	sw	a4,4(a0)
    3d9a:	4598                	lw	a4,8(a1)
    3d9c:	c518                	sw	a4,8(a0)
    3d9e:	45d8                	lw	a4,12(a1)
    3da0:	c558                	sw	a4,12(a0)
    3da2:	4998                	lw	a4,16(a1)
    3da4:	c918                	sw	a4,16(a0)
    3da6:	49d8                	lw	a4,20(a1)
    3da8:	c958                	sw	a4,20(a0)
    3daa:	4d98                	lw	a4,24(a1)
    3dac:	cd18                	sw	a4,24(a0)
    3dae:	4dd8                	lw	a4,28(a1)
    3db0:	cd58                	sw	a4,28(a0)
    3db2:	9536                	add	a0,a0,a3
    3db4:	95b6                	add	a1,a1,a3
    3db6:	8e15                	sub	a2,a2,a3
    3db8:	fcd67de3          	bgeu	a2,a3,3d92 <.Lmemcpy_aligned_block_copy_loop>

00003dbc <.Lmemcpy_word_copy>:
    3dbc:	c605                	beqz	a2,3de4 <.Lmemcpy_memcpy_end>
    3dbe:	4691                	li	a3,4
    3dc0:	00d66963          	bltu	a2,a3,3dd2 <.Lmemcpy_byte_copy>

00003dc4 <.Lmemcpy_word_copy_loop>:
    3dc4:	4198                	lw	a4,0(a1)
    3dc6:	c118                	sw	a4,0(a0)
    3dc8:	9536                	add	a0,a0,a3
    3dca:	95b6                	add	a1,a1,a3
    3dcc:	8e15                	sub	a2,a2,a3
    3dce:	fed67be3          	bgeu	a2,a3,3dc4 <.Lmemcpy_word_copy_loop>

00003dd2 <.Lmemcpy_byte_copy>:
    3dd2:	ca09                	beqz	a2,3de4 <.Lmemcpy_memcpy_end>

00003dd4 <.Lmemcpy_byte_copy_loop>:
    3dd4:	00058703          	lb	a4,0(a1)
    3dd8:	00e50023          	sb	a4,0(a0)
    3ddc:	0585                	add	a1,a1,1
    3dde:	0505                	add	a0,a0,1
    3de0:	167d                	add	a2,a2,-1
    3de2:	fa6d                	bnez	a2,3dd4 <.Lmemcpy_byte_copy_loop>

00003de4 <.Lmemcpy_memcpy_end>:
    3de4:	853e                	mv	a0,a5

00003de6 <.Lmemcpy_done>:
    3de6:	8082                	ret

Disassembly of section .text.libc.strncpy:

00003de8 <strncpy>:
    3de8:	87aa                	mv	a5,a0

00003dea <.L512>:
    3dea:	ce01                	beqz	a2,3e02 <.L518>
    3dec:	0005c703          	lbu	a4,0(a1)
    3df0:	0585                	add	a1,a1,1
    3df2:	0785                	add	a5,a5,1
    3df4:	fee78fa3          	sb	a4,-1(a5)
    3df8:	e711                	bnez	a4,3e04 <.L514>
    3dfa:	963e                	add	a2,a2,a5

00003dfc <.L515>:
    3dfc:	0785                	add	a5,a5,1
    3dfe:	00c79563          	bne	a5,a2,3e08 <.L516>

00003e02 <.L518>:
    3e02:	8082                	ret

00003e04 <.L514>:
    3e04:	167d                	add	a2,a2,-1
    3e06:	b7d5                	j	3dea <.L512>

00003e08 <.L516>:
    3e08:	fe078fa3          	sb	zero,-1(a5)
    3e0c:	bfc5                	j	3dfc <.L515>

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

00003e0e <__SEGGER_RTL_pow10f>:
    3e0e:	1101                	add	sp,sp,-32
    3e10:	cc22                	sw	s0,24(sp)
    3e12:	c64e                	sw	s3,12(sp)
    3e14:	ce06                	sw	ra,28(sp)
    3e16:	ca26                	sw	s1,20(sp)
    3e18:	c84a                	sw	s2,16(sp)
    3e1a:	842a                	mv	s0,a0
    3e1c:	4981                	li	s3,0
    3e1e:	00055563          	bgez	a0,3e28 <.L17>
    3e22:	40a00433          	neg	s0,a0
    3e26:	4985                	li	s3,1

00003e28 <.L17>:
    3e28:	b1822503          	lw	a0,-1256(tp) # fffffb18 <__AHB_SRAM_segment_end__+0xfdf7b18>
    3e2c:	9ec18493          	add	s1,gp,-1556 # 35c <__SEGGER_RTL_aPower2f>

00003e30 <.L18>:
    3e30:	ec19                	bnez	s0,3e4e <.L20>
    3e32:	00098763          	beqz	s3,3e40 <.L16>
    3e36:	85aa                	mv	a1,a0
    3e38:	b1822503          	lw	a0,-1256(tp) # fffffb18 <__AHB_SRAM_segment_end__+0xfdf7b18>
    3e3c:	4f3010ef          	jal	5b2e <__divsf3>

00003e40 <.L16>:
    3e40:	40f2                	lw	ra,28(sp)
    3e42:	4462                	lw	s0,24(sp)
    3e44:	44d2                	lw	s1,20(sp)
    3e46:	4942                	lw	s2,16(sp)
    3e48:	49b2                	lw	s3,12(sp)
    3e4a:	6105                	add	sp,sp,32
    3e4c:	8082                	ret

00003e4e <.L20>:
    3e4e:	00147793          	and	a5,s0,1
    3e52:	c781                	beqz	a5,3e5a <.L19>
    3e54:	408c                	lw	a1,0(s1)
    3e56:	429010ef          	jal	5a7e <__mulsf3>

00003e5a <.L19>:
    3e5a:	8405                	sra	s0,s0,0x1
    3e5c:	0491                	add	s1,s1,4
    3e5e:	bfc9                	j	3e30 <.L18>

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

00003e60 <__SEGGER_RTL_prin_flush>:
    3e60:	4950                	lw	a2,20(a0)
    3e62:	ce19                	beqz	a2,3e80 <.L20>
    3e64:	511c                	lw	a5,32(a0)
    3e66:	1141                	add	sp,sp,-16
    3e68:	c422                	sw	s0,8(sp)
    3e6a:	c606                	sw	ra,12(sp)
    3e6c:	842a                	mv	s0,a0
    3e6e:	c399                	beqz	a5,3e74 <.L12>
    3e70:	490c                	lw	a1,16(a0)
    3e72:	9782                	jalr	a5

00003e74 <.L12>:
    3e74:	40b2                	lw	ra,12(sp)
    3e76:	00042a23          	sw	zero,20(s0)
    3e7a:	4422                	lw	s0,8(sp)
    3e7c:	0141                	add	sp,sp,16
    3e7e:	8082                	ret

00003e80 <.L20>:
    3e80:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

00003e82 <__SEGGER_RTL_pre_padding>:
    3e82:	0105f793          	and	a5,a1,16
    3e86:	eb91                	bnez	a5,3e9a <.L40>
    3e88:	2005f793          	and	a5,a1,512
    3e8c:	02000593          	li	a1,32
    3e90:	c399                	beqz	a5,3e96 <.L42>
    3e92:	03000593          	li	a1,48

00003e96 <.L42>:
    3e96:	38c0206f          	j	6222 <__SEGGER_RTL_print_padding>

00003e9a <.L40>:
    3e9a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin_l:

00003e9c <__SEGGER_RTL_init_prin_l>:
    3e9c:	1141                	add	sp,sp,-16
    3e9e:	c226                	sw	s1,4(sp)
    3ea0:	02400613          	li	a2,36
    3ea4:	84ae                	mv	s1,a1
    3ea6:	4581                	li	a1,0
    3ea8:	c422                	sw	s0,8(sp)
    3eaa:	c606                	sw	ra,12(sp)
    3eac:	842a                	mv	s0,a0
    3eae:	164020ef          	jal	6012 <memset>
    3eb2:	40b2                	lw	ra,12(sp)
    3eb4:	cc44                	sw	s1,28(s0)
    3eb6:	4422                	lw	s0,8(sp)
    3eb8:	4492                	lw	s1,4(sp)
    3eba:	0141                	add	sp,sp,16
    3ebc:	8082                	ret

Disassembly of section .text.libc.vfprintf:

00003ebe <vfprintf>:
    3ebe:	1101                	add	sp,sp,-32
    3ec0:	cc22                	sw	s0,24(sp)
    3ec2:	ca26                	sw	s1,20(sp)
    3ec4:	ce06                	sw	ra,28(sp)
    3ec6:	84ae                	mv	s1,a1
    3ec8:	842a                	mv	s0,a0
    3eca:	c632                	sw	a2,12(sp)
    3ecc:	0be030ef          	jal	6f8a <__SEGGER_RTL_current_locale>
    3ed0:	85aa                	mv	a1,a0
    3ed2:	8522                	mv	a0,s0
    3ed4:	4462                	lw	s0,24(sp)
    3ed6:	46b2                	lw	a3,12(sp)
    3ed8:	40f2                	lw	ra,28(sp)
    3eda:	8626                	mv	a2,s1
    3edc:	44d2                	lw	s1,20(sp)
    3ede:	6105                	add	sp,sp,32
    3ee0:	36c0206f          	j	624c <vfprintf_l>

Disassembly of section .text.libc.printf:

00003ee4 <printf>:
    3ee4:	7139                	add	sp,sp,-64
    3ee6:	da3e                	sw	a5,52(sp)
    3ee8:	012017b7          	lui	a5,0x1201
    3eec:	d22e                	sw	a1,36(sp)
    3eee:	85aa                	mv	a1,a0
    3ef0:	1b07a503          	lw	a0,432(a5) # 12011b0 <stdout>
    3ef4:	d432                	sw	a2,40(sp)
    3ef6:	1050                	add	a2,sp,36
    3ef8:	ce06                	sw	ra,28(sp)
    3efa:	d636                	sw	a3,44(sp)
    3efc:	d83a                	sw	a4,48(sp)
    3efe:	dc42                	sw	a6,56(sp)
    3f00:	de46                	sw	a7,60(sp)
    3f02:	c632                	sw	a2,12(sp)
    3f04:	3f6d                	jal	3ebe <vfprintf>
    3f06:	40f2                	lw	ra,28(sp)
    3f08:	6121                	add	sp,sp,64
    3f0a:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

00003f0c <__SEGGER_init_heap>:
    3f0c:	00200537          	lui	a0,0x200
    3f10:	00050513          	mv	a0,a0
    3f14:	002045b7          	lui	a1,0x204
    3f18:	00058593          	mv	a1,a1
    3f1c:	8d89                	sub	a1,a1,a0
    3f1e:	a009                	j	3f20 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

00003f20 <__SEGGER_RTL_init_heap>:
    3f20:	479d                	li	a5,7
    3f22:	00b7f963          	bgeu	a5,a1,3f34 <.L68>
    3f26:	012017b7          	lui	a5,0x1201
    3f2a:	1aa7a623          	sw	a0,428(a5) # 12011ac <__SEGGER_RTL_heap_globals>
    3f2e:	00052023          	sw	zero,0(a0) # 200000 <__DLM_segment_start__>
    3f32:	c14c                	sw	a1,4(a0)

00003f34 <.L68>:
    3f34:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

00003f36 <__SEGGER_RTL_ascii_toupper>:
    3f36:	f9f50713          	add	a4,a0,-97
    3f3a:	47e5                	li	a5,25
    3f3c:	00e7e363          	bltu	a5,a4,3f42 <.L5>
    3f40:	1501                	add	a0,a0,-32

00003f42 <.L5>:
    3f42:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

00003f44 <__SEGGER_RTL_ascii_towupper>:
    3f44:	f9f50713          	add	a4,a0,-97
    3f48:	47e5                	li	a5,25
    3f4a:	00e7e363          	bltu	a5,a4,3f50 <.L12>
    3f4e:	1501                	add	a0,a0,-32

00003f50 <.L12>:
    3f50:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

00003f52 <__SEGGER_RTL_ascii_mbtowc>:
    3f52:	87aa                	mv	a5,a0
    3f54:	4501                	li	a0,0
    3f56:	c195                	beqz	a1,3f7a <.L55>
    3f58:	c20d                	beqz	a2,3f7a <.L55>
    3f5a:	0005c703          	lbu	a4,0(a1) # 204000 <__heap_end__>
    3f5e:	07f00613          	li	a2,127
    3f62:	5579                	li	a0,-2
    3f64:	00e66b63          	bltu	a2,a4,3f7a <.L55>
    3f68:	c391                	beqz	a5,3f6c <.L57>
    3f6a:	c398                	sw	a4,0(a5)

00003f6c <.L57>:
    3f6c:	0006a023          	sw	zero,0(a3)
    3f70:	0006a223          	sw	zero,4(a3)
    3f74:	00e03533          	snez	a0,a4
    3f78:	8082                	ret

00003f7a <.L55>:
    3f7a:	8082                	ret

Disassembly of section .text.rom_xpi_nor_read:

00003f7c <rom_xpi_nor_read>:
                                          xpi_xfer_channel_t channel,
                                          const xpi_nor_config_t *nor_config,
                                          uint32_t *dst,
                                          uint32_t start,
                                          uint32_t length)
{
    3f7c:	7179                	add	sp,sp,-48
    3f7e:	d606                	sw	ra,44(sp)
    3f80:	ce2a                	sw	a0,28(sp)
    3f82:	ca32                	sw	a2,20(sp)
    3f84:	c836                	sw	a3,16(sp)
    3f86:	c63a                	sw	a4,12(sp)
    3f88:	c43e                	sw	a5,8(sp)
    3f8a:	87ae                	mv	a5,a1
    3f8c:	00f10da3          	sb	a5,27(sp)
    return ROM_API_TABLE_ROOT->xpi_nor_driver_if->read(base, channel, nor_config, dst, start, length);
    3f90:	200207b7          	lui	a5,0x20020
    3f94:	f0078793          	add	a5,a5,-256 # 2001ff00 <_extram_size+0x1e01ff00>
    3f98:	4bdc                	lw	a5,20(a5)
    3f9a:	02c7a803          	lw	a6,44(a5)
    3f9e:	01b14583          	lbu	a1,27(sp)
    3fa2:	47a2                	lw	a5,8(sp)
    3fa4:	4732                	lw	a4,12(sp)
    3fa6:	46c2                	lw	a3,16(sp)
    3fa8:	4652                	lw	a2,20(sp)
    3faa:	4572                	lw	a0,28(sp)
    3fac:	9802                	jalr	a6
    3fae:	87aa                	mv	a5,a0
}
    3fb0:	853e                	mv	a0,a5
    3fb2:	50b2                	lw	ra,44(sp)
    3fb4:	6145                	add	sp,sp,48
    3fb6:	8082                	ret

Disassembly of section .text.rom_xpi_nor_get_property:

00003fb8 <rom_xpi_nor_get_property>:
 */
static inline hpm_stat_t rom_xpi_nor_get_property(XPI_Type *base,
                                                  xpi_nor_config_t *nor_cfg,
                                                  uint32_t property_id,
                                                  uint32_t *value)
{
    3fb8:	1101                	add	sp,sp,-32
    3fba:	ce06                	sw	ra,28(sp)
    3fbc:	c62a                	sw	a0,12(sp)
    3fbe:	c42e                	sw	a1,8(sp)
    3fc0:	c232                	sw	a2,4(sp)
    3fc2:	c036                	sw	a3,0(sp)
    return ROM_API_TABLE_ROOT->xpi_nor_driver_if->get_property(base, nor_cfg, property_id, value);
    3fc4:	200207b7          	lui	a5,0x20020
    3fc8:	f0078793          	add	a5,a5,-256 # 2001ff00 <_extram_size+0x1e01ff00>
    3fcc:	4bdc                	lw	a5,20(a5)
    3fce:	4bbc                	lw	a5,80(a5)
    3fd0:	4682                	lw	a3,0(sp)
    3fd2:	4612                	lw	a2,4(sp)
    3fd4:	45a2                	lw	a1,8(sp)
    3fd6:	4532                	lw	a0,12(sp)
    3fd8:	9782                	jalr	a5
    3fda:	87aa                	mv	a5,a0
}
    3fdc:	853e                	mv	a0,a5
    3fde:	40f2                	lw	ra,28(sp)
    3fe0:	6105                	add	sp,sp,32
    3fe2:	8082                	ret

Disassembly of section .text.norflash_read_mem:

00003fe4 <norflash_read_mem>:
{
    3fe4:	7179                	add	sp,sp,-48
    3fe6:	d606                	sw	ra,44(sp)
    3fe8:	c62a                	sw	a0,12(sp)
    3fea:	c42e                	sw	a1,8(sp)
    3fec:	c232                	sw	a2,4(sp)
    uint32_t flash_addr = 0x80000000 + offset;
    3fee:	4732                	lw	a4,12(sp)
    3ff0:	800007b7          	lui	a5,0x80000
    3ff4:	97ba                	add	a5,a5,a4
    3ff6:	ce3e                	sw	a5,28(sp)
    uint32_t aligned_start = HPM_L1C_CACHELINE_ALIGN_DOWN(flash_addr);
    3ff8:	47f2                	lw	a5,28(sp)
    3ffa:	fc07f793          	and	a5,a5,-64
    3ffe:	cc3e                	sw	a5,24(sp)
    uint32_t aligned_end = HPM_L1C_CACHELINE_ALIGN_UP(flash_addr + size_bytes);
    4000:	4772                	lw	a4,28(sp)
    4002:	4792                	lw	a5,4(sp)
    4004:	97ba                	add	a5,a5,a4
    4006:	03f78793          	add	a5,a5,63 # 8000003f <_extram_size+0x7e00003f>
    400a:	fc07f793          	and	a5,a5,-64
    400e:	ca3e                	sw	a5,20(sp)
    uint32_t aligned_size = aligned_end - aligned_start;
    4010:	4752                	lw	a4,20(sp)
    4012:	47e2                	lw	a5,24(sp)
    4014:	40f707b3          	sub	a5,a4,a5
    4018:	c83e                	sw	a5,16(sp)
    l1c_dc_invalidate(aligned_start, aligned_size);
    401a:	45c2                	lw	a1,16(sp)
    401c:	4562                	lw	a0,24(sp)
    401e:	a58fe0ef          	jal	2276 <l1c_dc_invalidate>
    memcpy(buf, (void *)flash_addr, size_bytes);
    4022:	47f2                	lw	a5,28(sp)
    4024:	4612                	lw	a2,4(sp)
    4026:	85be                	mv	a1,a5
    4028:	4522                	lw	a0,8(sp)
    402a:	3b25                	jal	3d62 <memcpy>
    return 0;
    402c:	4781                	li	a5,0
}
    402e:	853e                	mv	a0,a5
    4030:	50b2                	lw	ra,44(sp)
    4032:	6145                	add	sp,sp,48
    4034:	8082                	ret

Disassembly of section .text.norflash_get_chip_size:

00004036 <norflash_get_chip_size>:

uint32_t norflash_get_chip_size(void)
{
    4036:	1101                	add	sp,sp,-32
    4038:	ce06                	sw	ra,28(sp)
    uint32_t flash_size;
    rom_xpi_nor_get_property(BOARD_APP_XPI_NOR_XPI_BASE, &s_xpi_nor_config, 
    403a:	007c                	add	a5,sp,12
    403c:	86be                	mv	a3,a5
    403e:	4601                	li	a2,0
    4040:	012017b7          	lui	a5,0x1201
    4044:	07878593          	add	a1,a5,120 # 1201078 <s_xpi_nor_config>
    4048:	f3000537          	lui	a0,0xf3000
    404c:	37b5                	jal	3fb8 <rom_xpi_nor_get_property>
            xpi_nor_property_total_size, &flash_size);
    return flash_size;
    404e:	47b2                	lw	a5,12(sp)
}
    4050:	853e                	mv	a0,a5
    4052:	40f2                	lw	ra,28(sp)
    4054:	6105                	add	sp,sp,32
    4056:	8082                	ret

Disassembly of section .text.norflash_get_block_size:

00004058 <norflash_get_block_size>:

uint32_t norflash_get_block_size(void)
{
    4058:	1101                	add	sp,sp,-32
    405a:	ce06                	sw	ra,28(sp)
    uint32_t block_size;
    rom_xpi_nor_get_property(BOARD_APP_XPI_NOR_XPI_BASE, &s_xpi_nor_config, 
    405c:	007c                	add	a5,sp,12
    405e:	86be                	mv	a3,a5
    4060:	460d                	li	a2,3
    4062:	012017b7          	lui	a5,0x1201
    4066:	07878593          	add	a1,a5,120 # 1201078 <s_xpi_nor_config>
    406a:	f3000537          	lui	a0,0xf3000
    406e:	37a9                	jal	3fb8 <rom_xpi_nor_get_property>
            xpi_nor_property_block_size, &block_size);
    return block_size;
    4070:	47b2                	lw	a5,12(sp)
}
    4072:	853e                	mv	a0,a5
    4074:	40f2                	lw	ra,28(sp)
    4076:	6105                	add	sp,sp,32
    4078:	8082                	ret

Disassembly of section .text.norflash_get_erase_value:

0000407a <norflash_get_erase_value>:

uint8_t norflash_get_erase_value(void)
{
    return 0xffu;
    407a:	0ff00793          	li	a5,255
}
    407e:	853e                	mv	a0,a5
    4080:	8082                	ret

Disassembly of section .text.main:

00004082 <main>:

int main(void)
{
    4082:	7139                	add	sp,sp,-64
    4084:	de06                	sw	ra,60(sp)
    struct flashstress_driver drv;
    struct flashstress_context *nor_ctx;
    board_init();
    4086:	1fe010ef          	jal	5284 <board_init>
    408a:	47a1                	li	a5,8
    408c:	d23e                	sw	a5,36(sp)

0000408e <.LBB18>:
    return read_clear_csr(CSR_MSTATUS, mask);
    408e:	c002                	sw	zero,0(sp)
    4090:	5792                	lw	a5,36(sp)
    4092:	3007b7f3          	csrrc	a5,mstatus,a5
    4096:	c03e                	sw	a5,0(sp)
    4098:	4782                	lw	a5,0(sp)

0000409a <.LBE20>:
    409a:	0001                	nop

0000409c <.LBE18>:
    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    norflash_init();
    409c:	c04fd0ef          	jal	14a0 <norflash_init>

000040a0 <.LBB21>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
    40a0:	7ca027f3          	csrr	a5,0x7ca
    40a4:	d43e                	sw	a5,40(sp)
    40a6:	57a2                	lw	a5,40(sp)

000040a8 <.LBE25>:
    40a8:	0001                	nop

000040aa <.LBE23>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
    40aa:	8b89                	and	a5,a5,2
    40ac:	00f037b3          	snez	a5,a5
    40b0:	0ff7f793          	zext.b	a5,a5

000040b4 <.LBE21>:

    if (!l1c_dc_is_enabled()) {
    40b4:	0017c793          	xor	a5,a5,1
    40b8:	0ff7f793          	zext.b	a5,a5
    40bc:	c789                	beqz	a5,40c6 <.L41>
        l1c_dc_enable();
    40be:	956fe0ef          	jal	2214 <l1c_dc_enable>
        l1c_dc_invalidate_all();
    40c2:	6ad000ef          	jal	4f6e <l1c_dc_invalidate_all>

000040c6 <.L41>:
    }
    __asm volatile("fence rw, rw");
    40c6:	0330000f          	fence	rw,rw

    drv.get_flash_chip_size_bytes = norflash_get_chip_size;
    40ca:	000047b7          	lui	a5,0x4
    40ce:	03678793          	add	a5,a5,54 # 4036 <norflash_get_chip_size>
    40d2:	c23e                	sw	a5,4(sp)
    drv.get_flash_block_size_bytes = norflash_get_block_size;
    40d4:	000047b7          	lui	a5,0x4
    40d8:	05878793          	add	a5,a5,88 # 4058 <norflash_get_block_size>
    40dc:	c43e                	sw	a5,8(sp)
    drv.get_flash_erase_value = norflash_get_erase_value;
    40de:	000047b7          	lui	a5,0x4
    40e2:	07a78793          	add	a5,a5,122 # 407a <norflash_get_erase_value>
    40e6:	c63e                	sw	a5,12(sp)
    drv.erase_chip = norflash_erase_chip;
    40e8:	bfe20793          	add	a5,tp,-1026 # fffffbfe <__AHB_SRAM_segment_end__+0xfdf7bfe>
    40ec:	c83e                	sw	a5,16(sp)
    drv.erase_block = norflash_erase_block;
    40ee:	c6220793          	add	a5,tp,-926 # fffffc62 <__AHB_SRAM_segment_end__+0xfdf7c62>
    40f2:	ca3e                	sw	a5,20(sp)
    drv.read = norflash_read;
    40f4:	b9220793          	add	a5,tp,-1134 # fffffb92 <__AHB_SRAM_segment_end__+0xfdf7b92>
    40f8:	cc3e                	sw	a5,24(sp)
    drv.write = norflash_write;
    40fa:	bc820793          	add	a5,tp,-1080 # fffffbc8 <__AHB_SRAM_segment_end__+0xfdf7bc8>
    40fe:	ce3e                	sw	a5,28(sp)
    nor_ctx = flashstress_create(&drv, "read api(dcache enable)");
    4100:	0058                	add	a4,sp,4
    4102:	f6020593          	add	a1,tp,-160 # ffffff60 <__AHB_SRAM_segment_end__+0xfdf7f60>
    4106:	853a                	mv	a0,a4
    4108:	2ac1                	jal	42d8 <flashstress_create>
    410a:	d62a                	sw	a0,44(sp)
    if (flashstress_run(nor_ctx) < 0) {
    410c:	5532                	lw	a0,44(sp)
    410e:	103000ef          	jal	4a10 <flashstress_run>
    4112:	87aa                	mv	a5,a0
    4114:	0007d363          	bgez	a5,411a <.L42>

00004118 <.L43>:
        while (1);
    4118:	a001                	j	4118 <.L43>

0000411a <.L42>:
    }
    flashstress_destroy(nor_ctx);
    411a:	5532                	lw	a0,44(sp)
    411c:	2cb1                	jal	4378 <flashstress_destroy>


    drv.read = norflash_read_mem;
    411e:	000047b7          	lui	a5,0x4
    4122:	fe478793          	add	a5,a5,-28 # 3fe4 <norflash_read_mem>
    4126:	cc3e                	sw	a5,24(sp)
    nor_ctx = flashstress_create(&drv, "read mem(dcache enable)");
    4128:	0058                	add	a4,sp,4
    412a:	f7820593          	add	a1,tp,-136 # ffffff78 <__AHB_SRAM_segment_end__+0xfdf7f78>
    412e:	853a                	mv	a0,a4
    4130:	2265                	jal	42d8 <flashstress_create>
    4132:	d62a                	sw	a0,44(sp)
    if (flashstress_run(nor_ctx) < 0) {
    4134:	5532                	lw	a0,44(sp)
    4136:	0db000ef          	jal	4a10 <flashstress_run>
    413a:	87aa                	mv	a5,a0
    413c:	0007d363          	bgez	a5,4142 <.L44>

00004140 <.L45>:
        while (1);
    4140:	a001                	j	4140 <.L45>

00004142 <.L44>:
    }
    flashstress_destroy(nor_ctx);
    4142:	5532                	lw	a0,44(sp)
    4144:	2c15                	jal	4378 <flashstress_destroy>

00004146 <.LBB26>:
    return read_csr(CSR_MCACHE_CTL);
    4146:	7ca027f3          	csrr	a5,0x7ca
    414a:	d03e                	sw	a5,32(sp)
    414c:	5782                	lw	a5,32(sp)

0000414e <.LBE30>:
    414e:	0001                	nop

00004150 <.LBE28>:
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
    4150:	8b89                	and	a5,a5,2
    4152:	00f037b3          	snez	a5,a5
    4156:	0ff7f793          	zext.b	a5,a5

0000415a <.LBE26>:

    if (l1c_dc_is_enabled()) {
    415a:	c799                	beqz	a5,4168 <.L48>
        l1c_dc_writeback_all();
    415c:	62b000ef          	jal	4f86 <l1c_dc_writeback_all>
        __asm volatile("fence rw, rw");
    4160:	0330000f          	fence	rw,rw
        l1c_dc_disable();
    4164:	5e7000ef          	jal	4f4a <l1c_dc_disable>

00004168 <.L48>:
    }
    __asm volatile("fence rw, rw");
    4168:	0330000f          	fence	rw,rw

    drv.read = norflash_read;
    416c:	b9220793          	add	a5,tp,-1134 # fffffb92 <__AHB_SRAM_segment_end__+0xfdf7b92>
    4170:	cc3e                	sw	a5,24(sp)
    nor_ctx = flashstress_create(&drv, "read api(dcache disable)");
    4172:	0058                	add	a4,sp,4
    4174:	f9020593          	add	a1,tp,-112 # ffffff90 <__AHB_SRAM_segment_end__+0xfdf7f90>
    4178:	853a                	mv	a0,a4
    417a:	2ab9                	jal	42d8 <flashstress_create>
    417c:	d62a                	sw	a0,44(sp)
    if (flashstress_run(nor_ctx) < 0) {
    417e:	5532                	lw	a0,44(sp)
    4180:	091000ef          	jal	4a10 <flashstress_run>
    4184:	87aa                	mv	a5,a0
    4186:	0007d363          	bgez	a5,418c <.L49>

0000418a <.L50>:
        while (1);
    418a:	a001                	j	418a <.L50>

0000418c <.L49>:
    }
    flashstress_destroy(nor_ctx);
    418c:	5532                	lw	a0,44(sp)
    418e:	22ed                	jal	4378 <flashstress_destroy>


    drv.read = norflash_read_mem;
    4190:	000047b7          	lui	a5,0x4
    4194:	fe478793          	add	a5,a5,-28 # 3fe4 <norflash_read_mem>
    4198:	cc3e                	sw	a5,24(sp)
    nor_ctx = flashstress_create(&drv, "read mem(dcache disable)");
    419a:	0058                	add	a4,sp,4
    419c:	fac20593          	add	a1,tp,-84 # ffffffac <__AHB_SRAM_segment_end__+0xfdf7fac>
    41a0:	853a                	mv	a0,a4
    41a2:	2a1d                	jal	42d8 <flashstress_create>
    41a4:	d62a                	sw	a0,44(sp)
    if (flashstress_run(nor_ctx) < 0) {
    41a6:	5532                	lw	a0,44(sp)
    41a8:	069000ef          	jal	4a10 <flashstress_run>
    41ac:	87aa                	mv	a5,a0
    41ae:	0007d363          	bgez	a5,41b4 <.L51>

000041b2 <.L52>:
        while (1);
    41b2:	a001                	j	41b2 <.L52>

000041b4 <.L51>:
    }
    flashstress_destroy(nor_ctx);
    41b4:	5532                	lw	a0,44(sp)
    41b6:	22c9                	jal	4378 <flashstress_destroy>

    printf("\n=============================================\n");
    41b8:	fc820513          	add	a0,tp,-56 # ffffffc8 <__AHB_SRAM_segment_end__+0xfdf7fc8>
    41bc:	3325                	jal	3ee4 <printf>
    printf("All cases are PASSED\n");
    41be:	ff820513          	add	a0,tp,-8 # fffffff8 <__AHB_SRAM_segment_end__+0xfdf7ff8>
    41c2:	330d                	jal	3ee4 <printf>
    printf("=============================================\n");
    41c4:	01020513          	add	a0,tp,16 # 10 <_start+0x10>
    41c8:	3b31                	jal	3ee4 <printf>

000041ca <.L53>:

    while (1);
    41ca:	a001                	j	41ca <.L53>

Disassembly of section .text.interface_get_tick_us:

000041cc <interface_get_tick_us>:
{
    41cc:	1101                	add	sp,sp,-32
    41ce:	ce06                	sw	ra,28(sp)
    41d0:	cc22                	sw	s0,24(sp)
    41d2:	ca26                	sw	s1,20(sp)
    uint32_t freq = 0;
    41d4:	c602                	sw	zero,12(sp)
    if (!is_inited) {
    41d6:	012017b7          	lui	a5,0x1201
    41da:	1947a783          	lw	a5,404(a5) # 1201194 <is_inited.1>
    41de:	eb95                	bnez	a5,4212 <.L4>
        is_inited = 1;
    41e0:	012017b7          	lui	a5,0x1201
    41e4:	4705                	li	a4,1
    41e6:	18e7aa23          	sw	a4,404(a5) # 1201194 <is_inited.1>
        board_ungate_mchtmr_at_lp_mode();
    41ea:	040010ef          	jal	522a <board_ungate_mchtmr_at_lp_mode>
        freq = clock_get_frequency(clock_mchtmr0);
    41ee:	010607b7          	lui	a5,0x1060
    41f2:	00178513          	add	a0,a5,1 # 1060001 <_flash_size+0x60001>
    41f6:	283000ef          	jal	4c78 <clock_get_frequency>
    41fa:	c62a                	sw	a0,12(sp)
        div = freq / 1000000;
    41fc:	4732                	lw	a4,12(sp)
    41fe:	000f47b7          	lui	a5,0xf4
    4202:	24078793          	add	a5,a5,576 # f4240 <__AXI_SRAM_segment_size__+0x74240>
    4206:	02f75733          	divu	a4,a4,a5
    420a:	012017b7          	lui	a5,0x1201
    420e:	1ae7a023          	sw	a4,416(a5) # 12011a0 <div.0>

00004212 <.L4>:
    tick_us = mchtmr_get_count(HPM_MCHTMR) / div;
    4212:	e6000537          	lui	a0,0xe6000
    4216:	c58fd0ef          	jal	166e <mchtmr_get_count>
    421a:	872a                	mv	a4,a0
    421c:	87ae                	mv	a5,a1
    421e:	012016b7          	lui	a3,0x1201
    4222:	1a06a683          	lw	a3,416(a3) # 12011a0 <div.0>
    4226:	8436                	mv	s0,a3
    4228:	4481                	li	s1,0
    422a:	8622                	mv	a2,s0
    422c:	86a6                	mv	a3,s1
    422e:	853a                	mv	a0,a4
    4230:	85be                	mv	a1,a5
    4232:	adaff0ef          	jal	350c <__udivdi3>
    4236:	872a                	mv	a4,a0
    4238:	87ae                	mv	a5,a1
    423a:	c03a                	sw	a4,0(sp)
    423c:	c23e                	sw	a5,4(sp)
    return tick_us;
    423e:	4702                	lw	a4,0(sp)
    4240:	4792                	lw	a5,4(sp)
}
    4242:	853a                	mv	a0,a4
    4244:	85be                	mv	a1,a5
    4246:	40f2                	lw	ra,28(sp)
    4248:	4462                	lw	s0,24(sp)
    424a:	44d2                	lw	s1,20(sp)
    424c:	6105                	add	sp,sp,32
    424e:	8082                	ret

Disassembly of section .text.tick_elapesd:

00004250 <tick_elapesd>:
{
    4250:	1101                	add	sp,sp,-32
    4252:	c42a                	sw	a0,8(sp)
    4254:	c62e                	sw	a1,12(sp)
    4256:	c032                	sw	a2,0(sp)
    4258:	c236                	sw	a3,4(sp)
    if (start >= current) {
    425a:	4712                	lw	a4,4(sp)
    425c:	47b2                	lw	a5,12(sp)
    425e:	02e7eb63          	bltu	a5,a4,4294 <.L7>
    4262:	4712                	lw	a4,4(sp)
    4264:	47b2                	lw	a5,12(sp)
    4266:	00f71663          	bne	a4,a5,4272 <.L11>
    426a:	4702                	lw	a4,0(sp)
    426c:	47a2                	lw	a5,8(sp)
    426e:	02e7e363          	bltu	a5,a4,4294 <.L7>

00004272 <.L11>:
        tick = start - current;
    4272:	4622                	lw	a2,8(sp)
    4274:	46b2                	lw	a3,12(sp)
    4276:	4502                	lw	a0,0(sp)
    4278:	4592                	lw	a1,4(sp)
    427a:	40a60733          	sub	a4,a2,a0
    427e:	883a                	mv	a6,a4
    4280:	01063833          	sltu	a6,a2,a6
    4284:	40b687b3          	sub	a5,a3,a1
    4288:	410786b3          	sub	a3,a5,a6
    428c:	87b6                	mv	a5,a3
    428e:	cc3a                	sw	a4,24(sp)
    4290:	ce3e                	sw	a5,28(sp)
    4292:	a82d                	j	42cc <.L9>

00004294 <.L7>:
        tick = current + (0xffffffffffffffffull - start);
    4294:	4702                	lw	a4,0(sp)
    4296:	4792                	lw	a5,4(sp)
    4298:	4522                	lw	a0,8(sp)
    429a:	45b2                	lw	a1,12(sp)
    429c:	40a70633          	sub	a2,a4,a0
    42a0:	8832                	mv	a6,a2
    42a2:	01073833          	sltu	a6,a4,a6
    42a6:	40b786b3          	sub	a3,a5,a1
    42aa:	410687b3          	sub	a5,a3,a6
    42ae:	86be                	mv	a3,a5
    42b0:	557d                	li	a0,-1
    42b2:	55fd                	li	a1,-1
    42b4:	00a60733          	add	a4,a2,a0
    42b8:	883a                	mv	a6,a4
    42ba:	00c83833          	sltu	a6,a6,a2
    42be:	00b687b3          	add	a5,a3,a1
    42c2:	00f806b3          	add	a3,a6,a5
    42c6:	87b6                	mv	a5,a3
    42c8:	cc3a                	sw	a4,24(sp)
    42ca:	ce3e                	sw	a5,28(sp)

000042cc <.L9>:
    return tick;
    42cc:	4762                	lw	a4,24(sp)
    42ce:	47f2                	lw	a5,28(sp)
}
    42d0:	853a                	mv	a0,a4
    42d2:	85be                	mv	a1,a5
    42d4:	6105                	add	sp,sp,32
    42d6:	8082                	ret

Disassembly of section .text.flashstress_create:

000042d8 <flashstress_create>:

struct flashstress_context *flashstress_create(struct flashstress_driver *drv, const char *name)
{
    42d8:	7179                	add	sp,sp,-48
    42da:	d606                	sw	ra,44(sp)
    42dc:	c62a                	sw	a0,12(sp)
    42de:	c42e                	sw	a1,8(sp)
    struct flashstress_context *ctx = NULL;
    42e0:	ce02                	sw	zero,28(sp)

    if (!drv || !name || !drv->erase_block || !drv->read ||
    42e2:	47b2                	lw	a5,12(sp)
    42e4:	c78d                	beqz	a5,430e <.L23>
    42e6:	47a2                	lw	a5,8(sp)
    42e8:	c39d                	beqz	a5,430e <.L23>
    42ea:	47b2                	lw	a5,12(sp)
    42ec:	4b9c                	lw	a5,16(a5)
    42ee:	c385                	beqz	a5,430e <.L23>
    42f0:	47b2                	lw	a5,12(sp)
    42f2:	4bdc                	lw	a5,20(a5)
    42f4:	cf89                	beqz	a5,430e <.L23>
        !drv->write || !drv->read ||
    42f6:	47b2                	lw	a5,12(sp)
    42f8:	4f9c                	lw	a5,24(a5)
    if (!drv || !name || !drv->erase_block || !drv->read ||
    42fa:	cb91                	beqz	a5,430e <.L23>
        !drv->write || !drv->read ||
    42fc:	47b2                	lw	a5,12(sp)
    42fe:	4bdc                	lw	a5,20(a5)
    4300:	c799                	beqz	a5,430e <.L23>
        !drv->get_flash_block_size_bytes ||
    4302:	47b2                	lw	a5,12(sp)
    4304:	43dc                	lw	a5,4(a5)
        !drv->write || !drv->read ||
    4306:	c781                	beqz	a5,430e <.L23>
        !drv->get_flash_chip_size_bytes) {
    4308:	47b2                	lw	a5,12(sp)
    430a:	439c                	lw	a5,0(a5)
        !drv->get_flash_block_size_bytes ||
    430c:	e791                	bnez	a5,4318 <.L24>

0000430e <.L23>:
        FLASHSTRESS_LOG("FLASHSTRESS: ERR: drv is invalid!!!\n");
    430e:	f3818513          	add	a0,gp,-200 # 8a8 <.LC0>
    4312:	3ec9                	jal	3ee4 <printf>
        return ctx;
    4314:	47f2                	lw	a5,28(sp)
    4316:	a8a9                	j	4370 <.L25>

00004318 <.L24>:
    }

    if (!drv->erase_chip) {
    4318:	47b2                	lw	a5,12(sp)
    431a:	47dc                	lw	a5,12(a5)
    431c:	e789                	bnez	a5,4326 <.L26>
        FLASHSTRESS_LOG("[%s]: WARNNING: <erase chip> api invalid!\n", name);
    431e:	45a2                	lw	a1,8(sp)
    4320:	f6018513          	add	a0,gp,-160 # 8d0 <.LC1>
    4324:	36c1                	jal	3ee4 <printf>

00004326 <.L26>:
    }

    ctx = flashstress_context_alloc();
    4326:	b5cfd0ef          	jal	1682 <flashstress_context_alloc>
    432a:	ce2a                	sw	a0,28(sp)
    if (!ctx) {
    432c:	47f2                	lw	a5,28(sp)
    432e:	e789                	bnez	a5,4338 <.L27>
        FLASHSTRESS_LOG("FLASHSTRESS: ERROR: [%s] context alloc failed!!!\n", name);
    4330:	45a2                	lw	a1,8(sp)
    4332:	f8c18513          	add	a0,gp,-116 # 8fc <.LC2>
    4336:	367d                	jal	3ee4 <printf>

00004338 <.L27>:
    }

    ctx->drv = *drv;
    4338:	47f2                	lw	a5,28(sp)
    433a:	4732                	lw	a4,12(sp)
    433c:	00072883          	lw	a7,0(a4)
    4340:	00472803          	lw	a6,4(a4)
    4344:	4708                	lw	a0,8(a4)
    4346:	474c                	lw	a1,12(a4)
    4348:	4b10                	lw	a2,16(a4)
    434a:	4b54                	lw	a3,20(a4)
    434c:	4f18                	lw	a4,24(a4)
    434e:	0517a423          	sw	a7,72(a5)
    4352:	0507a623          	sw	a6,76(a5)
    4356:	cba8                	sw	a0,80(a5)
    4358:	cbec                	sw	a1,84(a5)
    435a:	cfb0                	sw	a2,88(a5)
    435c:	cff4                	sw	a3,92(a5)
    435e:	d3b8                	sw	a4,96(a5)
    strncpy(ctx->name, name, CONFIG_NAME_LEN);
    4360:	47f2                	lw	a5,28(sp)
    4362:	0791                	add	a5,a5,4
    4364:	04000613          	li	a2,64
    4368:	45a2                	lw	a1,8(sp)
    436a:	853e                	mv	a0,a5
    436c:	3cb5                	jal	3de8 <strncpy>

    return ctx;
    436e:	47f2                	lw	a5,28(sp)

00004370 <.L25>:
}
    4370:	853e                	mv	a0,a5
    4372:	50b2                	lw	ra,44(sp)
    4374:	6145                	add	sp,sp,48
    4376:	8082                	ret

Disassembly of section .text.flashstress_destroy:

00004378 <flashstress_destroy>:

void flashstress_destroy(struct flashstress_context *ctx)
{
    4378:	1101                	add	sp,sp,-32
    437a:	ce06                	sw	ra,28(sp)
    437c:	c62a                	sw	a0,12(sp)
    flashstress_context_free(ctx);
    437e:	4532                	lw	a0,12(sp)
    4380:	b9efd0ef          	jal	171e <flashstress_context_free>
}
    4384:	0001                	nop
    4386:	40f2                	lw	ra,28(sp)
    4388:	6105                	add	sp,sp,32
    438a:	8082                	ret

Disassembly of section .text.flashstress_erase_chip:

0000438c <flashstress_erase_chip>:

int flashstress_erase_chip(struct flashstress_context *ctx)
{
    438c:	715d                	add	sp,sp,-80
    438e:	c686                	sw	ra,76(sp)
    4390:	c4a2                	sw	s0,72(sp)
    4392:	c62a                	sw	a0,12(sp)
    struct flashstress_driver *drv = &ctx->drv;
    4394:	47b2                	lw	a5,12(sp)
    4396:	04878793          	add	a5,a5,72
    439a:	d63e                	sw	a5,44(sp)
    uint32_t chip_size_bytes = drv->get_flash_chip_size_bytes();
    439c:	57b2                	lw	a5,44(sp)
    439e:	439c                	lw	a5,0(a5)
    43a0:	9782                	jalr	a5
    43a2:	d42a                	sw	a0,40(sp)
    uint32_t block_size_bytes = drv->get_flash_block_size_bytes();
    43a4:	57b2                	lw	a5,44(sp)
    43a6:	43dc                	lw	a5,4(a5)
    43a8:	9782                	jalr	a5
    43aa:	d22a                	sw	a0,36(sp)
    uint8_t erase_value = drv->get_flash_erase_value();
    43ac:	57b2                	lw	a5,44(sp)
    43ae:	479c                	lw	a5,8(a5)
    43b0:	9782                	jalr	a5
    43b2:	87aa                	mv	a5,a0
    43b4:	02f101a3          	sb	a5,35(sp)
    uint32_t i;
    uint64_t erase_time_us;
    uint64_t start_time_us;
    float erase_time_s;

    if (drv->erase_chip) {
    43b8:	57b2                	lw	a5,44(sp)
    43ba:	47dc                	lw	a5,12(a5)
    43bc:	cb8d                	beqz	a5,43ee <.L30>
        start_time_us = interface_get_tick_us();
    43be:	3539                	jal	41cc <interface_get_tick_us>
    43c0:	cc2a                	sw	a0,24(sp)
    43c2:	ce2e                	sw	a1,28(sp)
        if (drv->erase_chip()) {
    43c4:	57b2                	lw	a5,44(sp)
    43c6:	47dc                	lw	a5,12(a5)
    43c8:	9782                	jalr	a5
    43ca:	87aa                	mv	a5,a0
    43cc:	c791                	beqz	a5,43d8 <.L31>
            FLASHSTRESS_LOG("[%s]: ERROR: <erase_chip> FAILED!!!\n");
    43ce:	fc018513          	add	a0,gp,-64 # 930 <.LC3>
    43d2:	3e09                	jal	3ee4 <printf>
            return -1;
    43d4:	57fd                	li	a5,-1
    43d6:	aa89                	j	4528 <.L32>

000043d8 <.L31>:
        }
        erase_time_us = tick_elapesd(start_time_us, interface_get_tick_us());
    43d8:	3bd5                	jal	41cc <interface_get_tick_us>
    43da:	872a                	mv	a4,a0
    43dc:	87ae                	mv	a5,a1
    43de:	863a                	mv	a2,a4
    43e0:	86be                	mv	a3,a5
    43e2:	4562                	lw	a0,24(sp)
    43e4:	45f2                	lw	a1,28(sp)
    43e6:	35ad                	jal	4250 <tick_elapesd>
    43e8:	d82a                	sw	a0,48(sp)
    43ea:	da2e                	sw	a1,52(sp)
    43ec:	a8a9                	j	4446 <.L33>

000043ee <.L30>:
    } else {
        FLASHSTRESS_LOG("[%s]: WARNNING: <erase chip> api invalid, <erase block> api to be used!\n", ctx->name);
    43ee:	47b2                	lw	a5,12(sp)
    43f0:	0791                	add	a5,a5,4
    43f2:	85be                	mv	a1,a5
    43f4:	fe818513          	add	a0,gp,-24 # 958 <.LC4>
    43f8:	34f5                	jal	3ee4 <printf>
        offset = 0;
    43fa:	de02                	sw	zero,60(sp)
        start_time_us = interface_get_tick_us();
    43fc:	3bc1                	jal	41cc <interface_get_tick_us>
    43fe:	cc2a                	sw	a0,24(sp)
    4400:	ce2e                	sw	a1,28(sp)
        while (offset < chip_size_bytes) {
    4402:	a025                	j	442a <.L34>

00004404 <.L36>:
            if (drv->erase_block(offset)) {
    4404:	57b2                	lw	a5,44(sp)
    4406:	4b9c                	lw	a5,16(a5)
    4408:	5572                	lw	a0,60(sp)
    440a:	9782                	jalr	a5
    440c:	87aa                	mv	a5,a0
    440e:	cb91                	beqz	a5,4422 <.L35>
                FLASHSTRESS_LOG("[%s]: ERROR: <erase_block> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    4410:	47b2                	lw	a5,12(sp)
    4412:	0791                	add	a5,a5,4
    4414:	5672                	lw	a2,60(sp)
    4416:	85be                	mv	a1,a5
    4418:	03418513          	add	a0,gp,52 # 9a4 <.LC5>
    441c:	34e1                	jal	3ee4 <printf>
                return -1;
    441e:	57fd                	li	a5,-1
    4420:	a221                	j	4528 <.L32>

00004422 <.L35>:
            }
            offset += block_size_bytes;
    4422:	5772                	lw	a4,60(sp)
    4424:	5792                	lw	a5,36(sp)
    4426:	97ba                	add	a5,a5,a4
    4428:	de3e                	sw	a5,60(sp)

0000442a <.L34>:
        while (offset < chip_size_bytes) {
    442a:	5772                	lw	a4,60(sp)
    442c:	57a2                	lw	a5,40(sp)
    442e:	fcf76be3          	bltu	a4,a5,4404 <.L36>
        }
        erase_time_us = tick_elapesd(start_time_us, interface_get_tick_us());
    4432:	3b69                	jal	41cc <interface_get_tick_us>
    4434:	872a                	mv	a4,a0
    4436:	87ae                	mv	a5,a1
    4438:	863a                	mv	a2,a4
    443a:	86be                	mv	a3,a5
    443c:	4562                	lw	a0,24(sp)
    443e:	45f2                	lw	a1,28(sp)
    4440:	3d01                	jal	4250 <tick_elapesd>
    4442:	d82a                	sw	a0,48(sp)
    4444:	da2e                	sw	a1,52(sp)

00004446 <.L33>:
    }

    /*
     * verify erase
     */
    offset = 0;
    4446:	de02                	sw	zero,60(sp)
    while (offset < chip_size_bytes) {
    4448:	a859                	j	44de <.L37>

0000444a <.L42>:
        memset(ctx->data_buf, !erase_value, CONFIG_DATA_BUF_SIZE);
    444a:	47b2                	lw	a5,12(sp)
    444c:	06478713          	add	a4,a5,100
    4450:	02314783          	lbu	a5,35(sp)
    4454:	0017b793          	seqz	a5,a5
    4458:	0ff7f793          	zext.b	a5,a5
    445c:	6605                	lui	a2,0x1
    445e:	85be                	mv	a1,a5
    4460:	853a                	mv	a0,a4
    4462:	3b1010ef          	jal	6012 <memset>
        if (drv->read(offset, ctx->data_buf, CONFIG_DATA_BUF_SIZE)) {
    4466:	57b2                	lw	a5,44(sp)
    4468:	4bdc                	lw	a5,20(a5)
    446a:	4732                	lw	a4,12(sp)
    446c:	06470713          	add	a4,a4,100
    4470:	6605                	lui	a2,0x1
    4472:	85ba                	mv	a1,a4
    4474:	5572                	lw	a0,60(sp)
    4476:	9782                	jalr	a5
    4478:	87aa                	mv	a5,a0
    447a:	cb91                	beqz	a5,448e <.L38>
            FLASHSTRESS_LOG("[%s]: ERROR: <erase verify read api> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    447c:	47b2                	lw	a5,12(sp)
    447e:	0791                	add	a5,a5,4
    4480:	5672                	lw	a2,60(sp)
    4482:	85be                	mv	a1,a5
    4484:	06818513          	add	a0,gp,104 # 9d8 <.LC6>
    4488:	3cb1                	jal	3ee4 <printf>
            return -1;
    448a:	57fd                	li	a5,-1
    448c:	a871                	j	4528 <.L32>

0000448e <.L38>:
        }

        for (i = 0; i < CONFIG_DATA_BUF_SIZE; i++) {
    448e:	dc02                	sw	zero,56(sp)
    4490:	a83d                	j	44ce <.L39>

00004492 <.L41>:
            if (ctx->data_buf[i] != erase_value) {
    4492:	4732                	lw	a4,12(sp)
    4494:	57e2                	lw	a5,56(sp)
    4496:	97ba                	add	a5,a5,a4
    4498:	0647c783          	lbu	a5,100(a5)
    449c:	02314703          	lbu	a4,35(sp)
    44a0:	02f70463          	beq	a4,a5,44c8 <.L40>
                FLASHSTRESS_LOG("[%s]: ERROR: <ease verify data> 0x%X!= 0x%X FAILED!!!\n", ctx->name, ctx->data_buf[i], erase_value);
    44a4:	47b2                	lw	a5,12(sp)
    44a6:	00478593          	add	a1,a5,4
    44aa:	4732                	lw	a4,12(sp)
    44ac:	57e2                	lw	a5,56(sp)
    44ae:	97ba                	add	a5,a5,a4
    44b0:	0647c783          	lbu	a5,100(a5)
    44b4:	873e                	mv	a4,a5
    44b6:	02314783          	lbu	a5,35(sp)
    44ba:	86be                	mv	a3,a5
    44bc:	863a                	mv	a2,a4
    44be:	0a818513          	add	a0,gp,168 # a18 <.LC7>
    44c2:	340d                	jal	3ee4 <printf>
                return -1;
    44c4:	57fd                	li	a5,-1
    44c6:	a08d                	j	4528 <.L32>

000044c8 <.L40>:
        for (i = 0; i < CONFIG_DATA_BUF_SIZE; i++) {
    44c8:	57e2                	lw	a5,56(sp)
    44ca:	0785                	add	a5,a5,1
    44cc:	dc3e                	sw	a5,56(sp)

000044ce <.L39>:
    44ce:	5762                	lw	a4,56(sp)
    44d0:	6785                	lui	a5,0x1
    44d2:	fcf760e3          	bltu	a4,a5,4492 <.L41>
            }
        }
        offset += CONFIG_DATA_BUF_SIZE;
    44d6:	5772                	lw	a4,60(sp)
    44d8:	6785                	lui	a5,0x1
    44da:	97ba                	add	a5,a5,a4
    44dc:	de3e                	sw	a5,60(sp)

000044de <.L37>:
    while (offset < chip_size_bytes) {
    44de:	5772                	lw	a4,60(sp)
    44e0:	57a2                	lw	a5,40(sp)
    44e2:	f6f764e3          	bltu	a4,a5,444a <.L42>
    }

    erase_time_s = erase_time_us / 1000000.0f;
    44e6:	5542                	lw	a0,48(sp)
    44e8:	55d2                	lw	a1,52(sp)
    44ea:	d75fe0ef          	jal	325e <__floatundisf>
    44ee:	872a                	mv	a4,a0
    44f0:	4641a583          	lw	a1,1124(gp) # dd4 <.LC8>
    44f4:	853a                	mv	a0,a4
    44f6:	638010ef          	jal	5b2e <__divsf3>
    44fa:	87aa                	mv	a5,a0
    44fc:	ca3e                	sw	a5,20(sp)
    FLASHSTRESS_LOG("[%s]: [erase_chip] PASSED!!!\n", ctx->name);
    44fe:	47b2                	lw	a5,12(sp)
    4500:	0791                	add	a5,a5,4 # 1004 <__SEGGER_RTL_Moeller_inverse_lut+0x120>
    4502:	85be                	mv	a1,a5
    4504:	0e018513          	add	a0,gp,224 # a50 <.LC9>
    4508:	3af1                	jal	3ee4 <printf>
    FLASHSTRESS_LOG("[%s]: [erase_chip] take %f seconds!!!\n", ctx->name, erase_time_s);
    450a:	47b2                	lw	a5,12(sp)
    450c:	00478413          	add	s0,a5,4
    4510:	4552                	lw	a0,20(sp)
    4512:	df7fe0ef          	jal	3308 <__extendsfdf2>
    4516:	872a                	mv	a4,a0
    4518:	87ae                	mv	a5,a1
    451a:	863a                	mv	a2,a4
    451c:	86be                	mv	a3,a5
    451e:	85a2                	mv	a1,s0
    4520:	10018513          	add	a0,gp,256 # a70 <.LC10>
    4524:	32c1                	jal	3ee4 <printf>

    return 0;
    4526:	4781                	li	a5,0

00004528 <.L32>:
}
    4528:	853e                	mv	a0,a5
    452a:	40b6                	lw	ra,76(sp)
    452c:	4426                	lw	s0,72(sp)
    452e:	6161                	add	sp,sp,80
    4530:	8082                	ret

Disassembly of section .text.flashstress_erase_all_blocks:

00004532 <flashstress_erase_all_blocks>:

int flashstress_erase_all_blocks(struct flashstress_context *ctx)
{
    4532:	715d                	add	sp,sp,-80
    4534:	c686                	sw	ra,76(sp)
    4536:	c4a2                	sw	s0,72(sp)
    4538:	c62a                	sw	a0,12(sp)
    struct flashstress_driver *drv = &ctx->drv;
    453a:	47b2                	lw	a5,12(sp)
    453c:	04878793          	add	a5,a5,72
    4540:	da3e                	sw	a5,52(sp)
    uint32_t chip_size_bytes = drv->get_flash_chip_size_bytes();
    4542:	57d2                	lw	a5,52(sp)
    4544:	439c                	lw	a5,0(a5)
    4546:	9782                	jalr	a5
    4548:	d82a                	sw	a0,48(sp)
    uint32_t block_size_bytes = drv->get_flash_block_size_bytes();
    454a:	57d2                	lw	a5,52(sp)
    454c:	43dc                	lw	a5,4(a5)
    454e:	9782                	jalr	a5
    4550:	d62a                	sw	a0,44(sp)
    uint8_t erase_value = drv->get_flash_erase_value();
    4552:	57d2                	lw	a5,52(sp)
    4554:	479c                	lw	a5,8(a5)
    4556:	9782                	jalr	a5
    4558:	87aa                	mv	a5,a0
    455a:	02f105a3          	sb	a5,43(sp)
    uint32_t i;
    uint64_t erase_time_us;
    uint64_t start_time_us;
    float erase_time_s;

    offset = 0;
    455e:	de02                	sw	zero,60(sp)
    start_time_us = interface_get_tick_us();
    4560:	31b5                	jal	41cc <interface_get_tick_us>
    4562:	d02a                	sw	a0,32(sp)
    4564:	d22e                	sw	a1,36(sp)
    while (offset < chip_size_bytes) {
    4566:	a00d                	j	4588 <.L44>

00004568 <.L47>:
        if (drv->erase_block(offset)) {
    4568:	57d2                	lw	a5,52(sp)
    456a:	4b9c                	lw	a5,16(a5)
    456c:	5572                	lw	a0,60(sp)
    456e:	9782                	jalr	a5
    4570:	87aa                	mv	a5,a0
    4572:	c799                	beqz	a5,4580 <.L45>
            FLASHSTRESS_LOG("[%s]: ERROR: <erase_block> offset: 0x%X FAILED!!!\n", offset);
    4574:	55f2                	lw	a1,60(sp)
    4576:	03418513          	add	a0,gp,52 # 9a4 <.LC5>
    457a:	32ad                	jal	3ee4 <printf>
            return -1;
    457c:	57fd                	li	a5,-1
    457e:	a8dd                	j	4674 <.L46>

00004580 <.L45>:
        }
        offset += block_size_bytes;
    4580:	5772                	lw	a4,60(sp)
    4582:	57b2                	lw	a5,44(sp)
    4584:	97ba                	add	a5,a5,a4
    4586:	de3e                	sw	a5,60(sp)

00004588 <.L44>:
    while (offset < chip_size_bytes) {
    4588:	5772                	lw	a4,60(sp)
    458a:	57c2                	lw	a5,48(sp)
    458c:	fcf76ee3          	bltu	a4,a5,4568 <.L47>
    }
    erase_time_us = tick_elapesd(start_time_us, interface_get_tick_us());
    4590:	3935                	jal	41cc <interface_get_tick_us>
    4592:	872a                	mv	a4,a0
    4594:	87ae                	mv	a5,a1
    4596:	863a                	mv	a2,a4
    4598:	86be                	mv	a3,a5
    459a:	5502                	lw	a0,32(sp)
    459c:	5592                	lw	a1,36(sp)
    459e:	394d                	jal	4250 <tick_elapesd>
    45a0:	cc2a                	sw	a0,24(sp)
    45a2:	ce2e                	sw	a1,28(sp)
    erase_time_s = erase_time_us / 1000000.0f;
    45a4:	4562                	lw	a0,24(sp)
    45a6:	45f2                	lw	a1,28(sp)
    45a8:	cb7fe0ef          	jal	325e <__floatundisf>
    45ac:	872a                	mv	a4,a0
    45ae:	4641a583          	lw	a1,1124(gp) # dd4 <.LC8>
    45b2:	853a                	mv	a0,a4
    45b4:	57a010ef          	jal	5b2e <__divsf3>
    45b8:	87aa                	mv	a5,a0
    45ba:	ca3e                	sw	a5,20(sp)

    /*
     * verify erase
     */
    offset = 0;
    45bc:	de02                	sw	zero,60(sp)
    while (offset < chip_size_bytes) {
    45be:	a051                	j	4642 <.L48>

000045c0 <.L53>:
        memset(ctx->data_buf, !erase_value, CONFIG_DATA_BUF_SIZE);
    45c0:	47b2                	lw	a5,12(sp)
    45c2:	06478713          	add	a4,a5,100
    45c6:	02b14783          	lbu	a5,43(sp)
    45ca:	0017b793          	seqz	a5,a5
    45ce:	0ff7f793          	zext.b	a5,a5
    45d2:	6605                	lui	a2,0x1
    45d4:	85be                	mv	a1,a5
    45d6:	853a                	mv	a0,a4
    45d8:	23b010ef          	jal	6012 <memset>
        if (drv->read(offset, ctx->data_buf, CONFIG_DATA_BUF_SIZE)) {
    45dc:	57d2                	lw	a5,52(sp)
    45de:	4bdc                	lw	a5,20(a5)
    45e0:	4732                	lw	a4,12(sp)
    45e2:	06470713          	add	a4,a4,100
    45e6:	6605                	lui	a2,0x1
    45e8:	85ba                	mv	a1,a4
    45ea:	5572                	lw	a0,60(sp)
    45ec:	9782                	jalr	a5
    45ee:	87aa                	mv	a5,a0
    45f0:	cb91                	beqz	a5,4604 <.L49>
            FLASHSTRESS_LOG("[%s]: ERROR: <erase verify read api> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    45f2:	47b2                	lw	a5,12(sp)
    45f4:	0791                	add	a5,a5,4
    45f6:	5672                	lw	a2,60(sp)
    45f8:	85be                	mv	a1,a5
    45fa:	06818513          	add	a0,gp,104 # 9d8 <.LC6>
    45fe:	30dd                	jal	3ee4 <printf>
            return -1;
    4600:	57fd                	li	a5,-1
    4602:	a88d                	j	4674 <.L46>

00004604 <.L49>:
        }

        for (i = 0; i < CONFIG_DATA_BUF_SIZE; i++) {
    4604:	dc02                	sw	zero,56(sp)
    4606:	a035                	j	4632 <.L50>

00004608 <.L52>:
            if (ctx->data_buf[i] != erase_value) {
    4608:	4732                	lw	a4,12(sp)
    460a:	57e2                	lw	a5,56(sp)
    460c:	97ba                	add	a5,a5,a4
    460e:	0647c783          	lbu	a5,100(a5)
    4612:	02b14703          	lbu	a4,43(sp)
    4616:	00f70b63          	beq	a4,a5,462c <.L51>
                FLASHSTRESS_LOG("[%s]: ERROR: <ease verify data> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    461a:	47b2                	lw	a5,12(sp)
    461c:	0791                	add	a5,a5,4
    461e:	5672                	lw	a2,60(sp)
    4620:	85be                	mv	a1,a5
    4622:	12818513          	add	a0,gp,296 # a98 <.LC11>
    4626:	387d                	jal	3ee4 <printf>
                return -1;
    4628:	57fd                	li	a5,-1
    462a:	a0a9                	j	4674 <.L46>

0000462c <.L51>:
        for (i = 0; i < CONFIG_DATA_BUF_SIZE; i++) {
    462c:	57e2                	lw	a5,56(sp)
    462e:	0785                	add	a5,a5,1
    4630:	dc3e                	sw	a5,56(sp)

00004632 <.L50>:
    4632:	5762                	lw	a4,56(sp)
    4634:	6785                	lui	a5,0x1
    4636:	fcf769e3          	bltu	a4,a5,4608 <.L52>
            }
        }

        offset += CONFIG_DATA_BUF_SIZE;
    463a:	5772                	lw	a4,60(sp)
    463c:	6785                	lui	a5,0x1
    463e:	97ba                	add	a5,a5,a4
    4640:	de3e                	sw	a5,60(sp)

00004642 <.L48>:
    while (offset < chip_size_bytes) {
    4642:	5772                	lw	a4,60(sp)
    4644:	57c2                	lw	a5,48(sp)
    4646:	f6f76de3          	bltu	a4,a5,45c0 <.L53>
    }

    FLASHSTRESS_LOG("[%s]: [erase all blocks] PASSED\n", ctx->name);
    464a:	47b2                	lw	a5,12(sp)
    464c:	0791                	add	a5,a5,4 # 1004 <__SEGGER_RTL_Moeller_inverse_lut+0x120>
    464e:	85be                	mv	a1,a5
    4650:	16018513          	add	a0,gp,352 # ad0 <.LC12>
    4654:	3841                	jal	3ee4 <printf>
    FLASHSTRESS_LOG("[%s]: [erase all blocks] take time: %f seconds\n", ctx->name, erase_time_s);
    4656:	47b2                	lw	a5,12(sp)
    4658:	00478413          	add	s0,a5,4
    465c:	4552                	lw	a0,20(sp)
    465e:	cabfe0ef          	jal	3308 <__extendsfdf2>
    4662:	872a                	mv	a4,a0
    4664:	87ae                	mv	a5,a1
    4666:	863a                	mv	a2,a4
    4668:	86be                	mv	a3,a5
    466a:	85a2                	mv	a1,s0
    466c:	18418513          	add	a0,gp,388 # af4 <.LC13>
    4670:	3895                	jal	3ee4 <printf>

    return 0;
    4672:	4781                	li	a5,0

00004674 <.L46>:
}
    4674:	853e                	mv	a0,a5
    4676:	40b6                	lw	ra,76(sp)
    4678:	4426                	lw	s0,72(sp)
    467a:	6161                	add	sp,sp,80
    467c:	8082                	ret

Disassembly of section .text.flashstress_write_read:

0000467e <flashstress_write_read>:

int flashstress_write_read(struct flashstress_context *ctx, uint8_t verify_data)
{
    467e:	711d                	add	sp,sp,-96
    4680:	ce86                	sw	ra,92(sp)
    4682:	cca2                	sw	s0,88(sp)
    4684:	caa6                	sw	s1,84(sp)
    4686:	c8ca                	sw	s2,80(sp)
    4688:	c62a                	sw	a0,12(sp)
    468a:	87ae                	mv	a5,a1
    468c:	00f105a3          	sb	a5,11(sp)
    struct flashstress_driver *drv = &ctx->drv;
    4690:	47b2                	lw	a5,12(sp)
    4692:	04878793          	add	a5,a5,72
    4696:	c0be                	sw	a5,64(sp)
    uint32_t chip_size_bytes = drv->get_flash_chip_size_bytes();
    4698:	4786                	lw	a5,64(sp)
    469a:	439c                	lw	a5,0(a5)
    469c:	9782                	jalr	a5
    469e:	de2a                	sw	a0,60(sp)
    uint32_t block_size_bytes = drv->get_flash_block_size_bytes();
    46a0:	4786                	lw	a5,64(sp)
    46a2:	43dc                	lw	a5,4(a5)
    46a4:	9782                	jalr	a5
    46a6:	dc2a                	sw	a0,56(sp)
    float read_time_s;
    float read_speed;
    float write_time_s;
    float write_speed;

    uint32_t write_len = block_size_bytes;
    46a8:	57e2                	lw	a5,56(sp)
    46aa:	c2be                	sw	a5,68(sp)

000046ac <.L57>:

    while (1) {
        if (write_len <= CONFIG_DATA_BUF_SIZE) {
    46ac:	4716                	lw	a4,68(sp)
    46ae:	6785                	lui	a5,0x1
    46b0:	00e7f663          	bgeu	a5,a4,46bc <.L85>
            break;
        } else {
            write_len /= 2;
    46b4:	4796                	lw	a5,68(sp)
    46b6:	8385                	srl	a5,a5,0x1
    46b8:	c2be                	sw	a5,68(sp)
        if (write_len <= CONFIG_DATA_BUF_SIZE) {
    46ba:	bfcd                	j	46ac <.L57>

000046bc <.L85>:
            break;
    46bc:	0001                	nop
        }
    }

    if (write_len == 0) {
    46be:	4796                	lw	a5,68(sp)
    46c0:	eb91                	bnez	a5,46d4 <.L58>
        FLASHSTRESS_LOG("[%s]: ERROR: write len = %u!!!\n", ctx->name, write_len);
    46c2:	47b2                	lw	a5,12(sp)
    46c4:	0791                	add	a5,a5,4 # 1004 <__SEGGER_RTL_Moeller_inverse_lut+0x120>
    46c6:	4616                	lw	a2,68(sp)
    46c8:	85be                	mv	a1,a5
    46ca:	1b418513          	add	a0,gp,436 # b24 <.LC14>
    46ce:	3819                	jal	3ee4 <printf>
        return -1;
    46d0:	57fd                	li	a5,-1
    46d2:	ae05                	j	4a02 <.L59>

000046d4 <.L58>:
    }

    /*
     * write flash
     */
    memset(ctx->data_buf, verify_data, write_len);
    46d4:	47b2                	lw	a5,12(sp)
    46d6:	06478793          	add	a5,a5,100
    46da:	00b14703          	lbu	a4,11(sp)
    46de:	4616                	lw	a2,68(sp)
    46e0:	85ba                	mv	a1,a4
    46e2:	853e                	mv	a0,a5
    46e4:	12f010ef          	jal	6012 <memset>
    offset = 0;
    46e8:	c682                	sw	zero,76(sp)
    start_time_us = interface_get_tick_us();
    46ea:	34cd                	jal	41cc <interface_get_tick_us>
    46ec:	d82a                	sw	a0,48(sp)
    46ee:	da2e                	sw	a1,52(sp)
    while (offset < chip_size_bytes) {
    46f0:	a815                	j	4724 <.L60>

000046f2 <.L62>:
        if (drv->write(offset, ctx->data_buf, write_len)) {
    46f2:	4786                	lw	a5,64(sp)
    46f4:	4f9c                	lw	a5,24(a5)
    46f6:	4732                	lw	a4,12(sp)
    46f8:	06470713          	add	a4,a4,100
    46fc:	4616                	lw	a2,68(sp)
    46fe:	85ba                	mv	a1,a4
    4700:	4536                	lw	a0,76(sp)
    4702:	9782                	jalr	a5
    4704:	87aa                	mv	a5,a0
    4706:	cb99                	beqz	a5,471c <.L61>
            FLASHSTRESS_LOG("[%s]: ERROR: <write> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    4708:	47b2                	lw	a5,12(sp)
    470a:	0791                	add	a5,a5,4
    470c:	4636                	lw	a2,76(sp)
    470e:	85be                	mv	a1,a5
    4710:	1d418513          	add	a0,gp,468 # b44 <.LC15>
    4714:	fd0ff0ef          	jal	3ee4 <printf>
            return -1;
    4718:	57fd                	li	a5,-1
    471a:	a4e5                	j	4a02 <.L59>

0000471c <.L61>:
        }
        offset += write_len;
    471c:	4736                	lw	a4,76(sp)
    471e:	4796                	lw	a5,68(sp)
    4720:	97ba                	add	a5,a5,a4
    4722:	c6be                	sw	a5,76(sp)

00004724 <.L60>:
    while (offset < chip_size_bytes) {
    4724:	4736                	lw	a4,76(sp)
    4726:	57f2                	lw	a5,60(sp)
    4728:	fcf765e3          	bltu	a4,a5,46f2 <.L62>
    }
    write_time_us = tick_elapesd(start_time_us, interface_get_tick_us());
    472c:	3445                	jal	41cc <interface_get_tick_us>
    472e:	872a                	mv	a4,a0
    4730:	87ae                	mv	a5,a1
    4732:	863a                	mv	a2,a4
    4734:	86be                	mv	a3,a5
    4736:	5542                	lw	a0,48(sp)
    4738:	55d2                	lw	a1,52(sp)
    473a:	3e19                	jal	4250 <tick_elapesd>
    473c:	d42a                	sw	a0,40(sp)
    473e:	d62e                	sw	a1,44(sp)
    write_time_s = write_time_us / 1000000.0f;
    4740:	5522                	lw	a0,40(sp)
    4742:	55b2                	lw	a1,44(sp)
    4744:	b1bfe0ef          	jal	325e <__floatundisf>
    4748:	872a                	mv	a4,a0
    474a:	4641a583          	lw	a1,1124(gp) # dd4 <.LC8>
    474e:	853a                	mv	a0,a4
    4750:	3de010ef          	jal	5b2e <__divsf3>
    4754:	87aa                	mv	a5,a0
    4756:	d23e                	sw	a5,36(sp)
    write_speed = (write_time_us == 0) ? -1.0 : (chip_size_bytes / write_time_s / 1024.0 / 1024.0);
    4758:	57a2                	lw	a5,40(sp)
    475a:	5732                	lw	a4,44(sp)
    475c:	8fd9                	or	a5,a5,a4
    475e:	cba9                	beqz	a5,47b0 <.L63>
    4760:	5572                	lw	a0,60(sp)
    4762:	aa7fe0ef          	jal	3208 <__floatunsisf>
    4766:	87aa                	mv	a5,a0
    4768:	5592                	lw	a1,36(sp)
    476a:	853e                	mv	a0,a5
    476c:	3c2010ef          	jal	5b2e <__divsf3>
    4770:	87aa                	mv	a5,a0
    4772:	853e                	mv	a0,a5
    4774:	b95fe0ef          	jal	3308 <__extendsfdf2>
    4778:	872a                	mv	a4,a0
    477a:	87ae                	mv	a5,a1
    477c:	4681a603          	lw	a2,1128(gp) # dd8 <.LC16>
    4780:	46c1a683          	lw	a3,1132(gp) # ddc <.LC16+0x4>
    4784:	853a                	mv	a0,a4
    4786:	85be                	mv	a1,a5
    4788:	4a6010ef          	jal	5c2e <__divdf3>
    478c:	872a                	mv	a4,a0
    478e:	87ae                	mv	a5,a1
    4790:	853a                	mv	a0,a4
    4792:	85be                	mv	a1,a5
    4794:	4681a603          	lw	a2,1128(gp) # dd8 <.LC16>
    4798:	46c1a683          	lw	a3,1132(gp) # ddc <.LC16+0x4>
    479c:	492010ef          	jal	5c2e <__divdf3>
    47a0:	872a                	mv	a4,a0
    47a2:	87ae                	mv	a5,a1
    47a4:	853a                	mv	a0,a4
    47a6:	85be                	mv	a1,a5
    47a8:	ba7fe0ef          	jal	334e <__truncdfsf2>
    47ac:	87aa                	mv	a5,a0
    47ae:	a019                	j	47b4 <.L65>

000047b0 <.L63>:
    47b0:	4701a783          	lw	a5,1136(gp) # de0 <.LC17>

000047b4 <.L65>:
    47b4:	d03e                	sw	a5,32(sp)

    /*
     * verify flash data
     */
    offset = 0;
    47b6:	c682                	sw	zero,76(sp)
    while (offset < chip_size_bytes) {
    47b8:	a8bd                	j	4836 <.L66>

000047ba <.L71>:
        memset(ctx->data_buf, 0xff, CONFIG_DATA_BUF_SIZE);
    47ba:	47b2                	lw	a5,12(sp)
    47bc:	06478793          	add	a5,a5,100
    47c0:	6605                	lui	a2,0x1
    47c2:	0ff00593          	li	a1,255
    47c6:	853e                	mv	a0,a5
    47c8:	04b010ef          	jal	6012 <memset>
        if (drv->read(offset, ctx->data_buf, CONFIG_DATA_BUF_SIZE)) {
    47cc:	4786                	lw	a5,64(sp)
    47ce:	4bdc                	lw	a5,20(a5)
    47d0:	4732                	lw	a4,12(sp)
    47d2:	06470713          	add	a4,a4,100
    47d6:	6605                	lui	a2,0x1
    47d8:	85ba                	mv	a1,a4
    47da:	4536                	lw	a0,76(sp)
    47dc:	9782                	jalr	a5
    47de:	87aa                	mv	a5,a0
    47e0:	cb99                	beqz	a5,47f6 <.L67>
            FLASHSTRESS_LOG("[%s]: ERROR: <write verify read api> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    47e2:	47b2                	lw	a5,12(sp)
    47e4:	0791                	add	a5,a5,4
    47e6:	4636                	lw	a2,76(sp)
    47e8:	85be                	mv	a1,a5
    47ea:	20418513          	add	a0,gp,516 # b74 <.LC18>
    47ee:	ef6ff0ef          	jal	3ee4 <printf>
            return -1;
    47f2:	57fd                	li	a5,-1
    47f4:	a439                	j	4a02 <.L59>

000047f6 <.L67>:
        }

        for (i = 0; i < CONFIG_DATA_BUF_SIZE; i++) {
    47f6:	c482                	sw	zero,72(sp)
    47f8:	a03d                	j	4826 <.L68>

000047fa <.L70>:
            if (ctx->data_buf[i] != verify_data) {
    47fa:	4732                	lw	a4,12(sp)
    47fc:	47a6                	lw	a5,72(sp)
    47fe:	97ba                	add	a5,a5,a4
    4800:	0647c783          	lbu	a5,100(a5)
    4804:	00b14703          	lbu	a4,11(sp)
    4808:	00f70c63          	beq	a4,a5,4820 <.L69>
                FLASHSTRESS_LOG("[%s]: ERROR: <write verify data> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    480c:	47b2                	lw	a5,12(sp)
    480e:	0791                	add	a5,a5,4
    4810:	4636                	lw	a2,76(sp)
    4812:	85be                	mv	a1,a5
    4814:	24418513          	add	a0,gp,580 # bb4 <.LC19>
    4818:	eccff0ef          	jal	3ee4 <printf>
                return -1;
    481c:	57fd                	li	a5,-1
    481e:	a2d5                	j	4a02 <.L59>

00004820 <.L69>:
        for (i = 0; i < CONFIG_DATA_BUF_SIZE; i++) {
    4820:	47a6                	lw	a5,72(sp)
    4822:	0785                	add	a5,a5,1
    4824:	c4be                	sw	a5,72(sp)

00004826 <.L68>:
    4826:	4726                	lw	a4,72(sp)
    4828:	6785                	lui	a5,0x1
    482a:	fcf768e3          	bltu	a4,a5,47fa <.L70>
            }
        }

        offset += CONFIG_DATA_BUF_SIZE;
    482e:	4736                	lw	a4,76(sp)
    4830:	6785                	lui	a5,0x1
    4832:	97ba                	add	a5,a5,a4
    4834:	c6be                	sw	a5,76(sp)

00004836 <.L66>:
    while (offset < chip_size_bytes) {
    4836:	4736                	lw	a4,76(sp)
    4838:	57f2                	lw	a5,60(sp)
    483a:	f8f760e3          	bltu	a4,a5,47ba <.L71>
    }

    FLASHSTRESS_LOG("[%s]: [write] PASSED!!!\n", ctx->name);
    483e:	47b2                	lw	a5,12(sp)
    4840:	0791                	add	a5,a5,4 # 1004 <__SEGGER_RTL_Moeller_inverse_lut+0x120>
    4842:	85be                	mv	a1,a5
    4844:	28018513          	add	a0,gp,640 # bf0 <.LC20>
    4848:	e9cff0ef          	jal	3ee4 <printf>
    FLASHSTRESS_LOG("[%s]: [write] take time: %f, speed: %f MiB/s\n", ctx->name, write_time_s, write_speed);
    484c:	47b2                	lw	a5,12(sp)
    484e:	00478913          	add	s2,a5,4
    4852:	5512                	lw	a0,36(sp)
    4854:	ab5fe0ef          	jal	3308 <__extendsfdf2>
    4858:	842a                	mv	s0,a0
    485a:	84ae                	mv	s1,a1
    485c:	5502                	lw	a0,32(sp)
    485e:	aabfe0ef          	jal	3308 <__extendsfdf2>
    4862:	872a                	mv	a4,a0
    4864:	87ae                	mv	a5,a1
    4866:	8622                	mv	a2,s0
    4868:	86a6                	mv	a3,s1
    486a:	85ca                	mv	a1,s2
    486c:	29c18513          	add	a0,gp,668 # c0c <.LC21>
    4870:	e74ff0ef          	jal	3ee4 <printf>

    /*
     * only read speed test, don't care data
     */
    offset = 0;
    4874:	c682                	sw	zero,76(sp)
    start_time_us = interface_get_tick_us();
    4876:	3a99                	jal	41cc <interface_get_tick_us>
    4878:	d82a                	sw	a0,48(sp)
    487a:	da2e                	sw	a1,52(sp)
    while (offset < chip_size_bytes) {
    487c:	a815                	j	48b0 <.L72>

0000487e <.L74>:
        if (drv->read(offset, ctx->data_buf, CONFIG_DATA_BUF_SIZE)) {
    487e:	4786                	lw	a5,64(sp)
    4880:	4bdc                	lw	a5,20(a5)
    4882:	4732                	lw	a4,12(sp)
    4884:	06470713          	add	a4,a4,100
    4888:	6605                	lui	a2,0x1
    488a:	85ba                	mv	a1,a4
    488c:	4536                	lw	a0,76(sp)
    488e:	9782                	jalr	a5
    4890:	87aa                	mv	a5,a0
    4892:	cb99                	beqz	a5,48a8 <.L73>
            FLASHSTRESS_LOG("[%s]: ERROR: <read speed read api> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    4894:	47b2                	lw	a5,12(sp)
    4896:	0791                	add	a5,a5,4
    4898:	4636                	lw	a2,76(sp)
    489a:	85be                	mv	a1,a5
    489c:	2cc18513          	add	a0,gp,716 # c3c <.LC22>
    48a0:	e44ff0ef          	jal	3ee4 <printf>
            return -1;
    48a4:	57fd                	li	a5,-1
    48a6:	aab1                	j	4a02 <.L59>

000048a8 <.L73>:
        }
        offset += CONFIG_DATA_BUF_SIZE;
    48a8:	4736                	lw	a4,76(sp)
    48aa:	6785                	lui	a5,0x1
    48ac:	97ba                	add	a5,a5,a4
    48ae:	c6be                	sw	a5,76(sp)

000048b0 <.L72>:
    while (offset < chip_size_bytes) {
    48b0:	4736                	lw	a4,76(sp)
    48b2:	57f2                	lw	a5,60(sp)
    48b4:	fcf765e3          	bltu	a4,a5,487e <.L74>
    }
    read_time_us = tick_elapesd(start_time_us, interface_get_tick_us());
    48b8:	3a11                	jal	41cc <interface_get_tick_us>
    48ba:	872a                	mv	a4,a0
    48bc:	87ae                	mv	a5,a1
    48be:	863a                	mv	a2,a4
    48c0:	86be                	mv	a3,a5
    48c2:	5542                	lw	a0,48(sp)
    48c4:	55d2                	lw	a1,52(sp)
    48c6:	3269                	jal	4250 <tick_elapesd>
    48c8:	cc2a                	sw	a0,24(sp)
    48ca:	ce2e                	sw	a1,28(sp)
    read_time_s = read_time_us / 1000000.0f;
    48cc:	4562                	lw	a0,24(sp)
    48ce:	45f2                	lw	a1,28(sp)
    48d0:	98ffe0ef          	jal	325e <__floatundisf>
    48d4:	872a                	mv	a4,a0
    48d6:	4641a583          	lw	a1,1124(gp) # dd4 <.LC8>
    48da:	853a                	mv	a0,a4
    48dc:	252010ef          	jal	5b2e <__divsf3>
    48e0:	87aa                	mv	a5,a0
    48e2:	ca3e                	sw	a5,20(sp)
    read_speed = (read_time_us == 0) ? -1.0 : (chip_size_bytes / read_time_s / 1024.0 / 1024.0);
    48e4:	47e2                	lw	a5,24(sp)
    48e6:	4772                	lw	a4,28(sp)
    48e8:	8fd9                	or	a5,a5,a4
    48ea:	cba9                	beqz	a5,493c <.L75>
    48ec:	5572                	lw	a0,60(sp)
    48ee:	91bfe0ef          	jal	3208 <__floatunsisf>
    48f2:	87aa                	mv	a5,a0
    48f4:	45d2                	lw	a1,20(sp)
    48f6:	853e                	mv	a0,a5
    48f8:	236010ef          	jal	5b2e <__divsf3>
    48fc:	87aa                	mv	a5,a0
    48fe:	853e                	mv	a0,a5
    4900:	a09fe0ef          	jal	3308 <__extendsfdf2>
    4904:	872a                	mv	a4,a0
    4906:	87ae                	mv	a5,a1
    4908:	4681a603          	lw	a2,1128(gp) # dd8 <.LC16>
    490c:	46c1a683          	lw	a3,1132(gp) # ddc <.LC16+0x4>
    4910:	853a                	mv	a0,a4
    4912:	85be                	mv	a1,a5
    4914:	31a010ef          	jal	5c2e <__divdf3>
    4918:	872a                	mv	a4,a0
    491a:	87ae                	mv	a5,a1
    491c:	853a                	mv	a0,a4
    491e:	85be                	mv	a1,a5
    4920:	4681a603          	lw	a2,1128(gp) # dd8 <.LC16>
    4924:	46c1a683          	lw	a3,1132(gp) # ddc <.LC16+0x4>
    4928:	306010ef          	jal	5c2e <__divdf3>
    492c:	872a                	mv	a4,a0
    492e:	87ae                	mv	a5,a1
    4930:	853a                	mv	a0,a4
    4932:	85be                	mv	a1,a5
    4934:	a1bfe0ef          	jal	334e <__truncdfsf2>
    4938:	87aa                	mv	a5,a0
    493a:	a019                	j	4940 <.L77>

0000493c <.L75>:
    493c:	4701a783          	lw	a5,1136(gp) # de0 <.LC17>

00004940 <.L77>:
    4940:	c83e                	sw	a5,16(sp)

    /*
     * verify data
     */
    offset = 0;
    4942:	c682                	sw	zero,76(sp)
    while (offset < chip_size_bytes) {
    4944:	a8bd                	j	49c2 <.L78>

00004946 <.L83>:
        memset(ctx->data_buf, 0xff, CONFIG_DATA_BUF_SIZE);
    4946:	47b2                	lw	a5,12(sp)
    4948:	06478793          	add	a5,a5,100 # 1064 <__SEGGER_RTL_Moeller_inverse_lut+0x180>
    494c:	6605                	lui	a2,0x1
    494e:	0ff00593          	li	a1,255
    4952:	853e                	mv	a0,a5
    4954:	6be010ef          	jal	6012 <memset>
        if (drv->read(offset, ctx->data_buf, CONFIG_DATA_BUF_SIZE)) {
    4958:	4786                	lw	a5,64(sp)
    495a:	4bdc                	lw	a5,20(a5)
    495c:	4732                	lw	a4,12(sp)
    495e:	06470713          	add	a4,a4,100
    4962:	6605                	lui	a2,0x1
    4964:	85ba                	mv	a1,a4
    4966:	4536                	lw	a0,76(sp)
    4968:	9782                	jalr	a5
    496a:	87aa                	mv	a5,a0
    496c:	cb99                	beqz	a5,4982 <.L79>
            FLASHSTRESS_LOG("[%s]: ERROR: <read verify read api> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    496e:	47b2                	lw	a5,12(sp)
    4970:	0791                	add	a5,a5,4
    4972:	4636                	lw	a2,76(sp)
    4974:	85be                	mv	a1,a5
    4976:	30818513          	add	a0,gp,776 # c78 <.LC23>
    497a:	d6aff0ef          	jal	3ee4 <printf>
            return -1;
    497e:	57fd                	li	a5,-1
    4980:	a049                	j	4a02 <.L59>

00004982 <.L79>:
        }

        for (i = 0; i < CONFIG_DATA_BUF_SIZE; i++) {
    4982:	c482                	sw	zero,72(sp)
    4984:	a03d                	j	49b2 <.L80>

00004986 <.L82>:
            if (ctx->data_buf[i] != verify_data) {
    4986:	4732                	lw	a4,12(sp)
    4988:	47a6                	lw	a5,72(sp)
    498a:	97ba                	add	a5,a5,a4
    498c:	0647c783          	lbu	a5,100(a5)
    4990:	00b14703          	lbu	a4,11(sp)
    4994:	00f70c63          	beq	a4,a5,49ac <.L81>
                FLASHSTRESS_LOG("[%s]: ERROR: <read verify data> offset: 0x%X FAILED!!!\n", ctx->name, offset);
    4998:	47b2                	lw	a5,12(sp)
    499a:	0791                	add	a5,a5,4
    499c:	4636                	lw	a2,76(sp)
    499e:	85be                	mv	a1,a5
    49a0:	34418513          	add	a0,gp,836 # cb4 <.LC24>
    49a4:	d40ff0ef          	jal	3ee4 <printf>
                return -1;
    49a8:	57fd                	li	a5,-1
    49aa:	a8a1                	j	4a02 <.L59>

000049ac <.L81>:
        for (i = 0; i < CONFIG_DATA_BUF_SIZE; i++) {
    49ac:	47a6                	lw	a5,72(sp)
    49ae:	0785                	add	a5,a5,1
    49b0:	c4be                	sw	a5,72(sp)

000049b2 <.L80>:
    49b2:	4726                	lw	a4,72(sp)
    49b4:	6785                	lui	a5,0x1
    49b6:	fcf768e3          	bltu	a4,a5,4986 <.L82>
            }
        }

        offset += CONFIG_DATA_BUF_SIZE;
    49ba:	4736                	lw	a4,76(sp)
    49bc:	6785                	lui	a5,0x1
    49be:	97ba                	add	a5,a5,a4
    49c0:	c6be                	sw	a5,76(sp)

000049c2 <.L78>:
    while (offset < chip_size_bytes) {
    49c2:	4736                	lw	a4,76(sp)
    49c4:	57f2                	lw	a5,60(sp)
    49c6:	f8f760e3          	bltu	a4,a5,4946 <.L83>
    }
    FLASHSTRESS_LOG("[%s]: [read] PASSED!!!\n", ctx->name);
    49ca:	47b2                	lw	a5,12(sp)
    49cc:	0791                	add	a5,a5,4 # 1004 <__SEGGER_RTL_Moeller_inverse_lut+0x120>
    49ce:	85be                	mv	a1,a5
    49d0:	37c18513          	add	a0,gp,892 # cec <.LC25>
    49d4:	d10ff0ef          	jal	3ee4 <printf>
    FLASHSTRESS_LOG("[%s]: [read] take time: %f, speed: %f MiB/s\n", ctx->name, read_time_s, read_speed);
    49d8:	47b2                	lw	a5,12(sp)
    49da:	00478913          	add	s2,a5,4
    49de:	4552                	lw	a0,20(sp)
    49e0:	929fe0ef          	jal	3308 <__extendsfdf2>
    49e4:	842a                	mv	s0,a0
    49e6:	84ae                	mv	s1,a1
    49e8:	4542                	lw	a0,16(sp)
    49ea:	91ffe0ef          	jal	3308 <__extendsfdf2>
    49ee:	872a                	mv	a4,a0
    49f0:	87ae                	mv	a5,a1
    49f2:	8622                	mv	a2,s0
    49f4:	86a6                	mv	a3,s1
    49f6:	85ca                	mv	a1,s2
    49f8:	39418513          	add	a0,gp,916 # d04 <.LC26>
    49fc:	ce8ff0ef          	jal	3ee4 <printf>

    return 0;
    4a00:	4781                	li	a5,0

00004a02 <.L59>:
}
    4a02:	853e                	mv	a0,a5
    4a04:	40f6                	lw	ra,92(sp)
    4a06:	4466                	lw	s0,88(sp)
    4a08:	44d6                	lw	s1,84(sp)
    4a0a:	4946                	lw	s2,80(sp)
    4a0c:	6125                	add	sp,sp,96
    4a0e:	8082                	ret

Disassembly of section .text.flashstress_run:

00004a10 <flashstress_run>:


int flashstress_run(struct flashstress_context *ctx)
{
    4a10:	7179                	add	sp,sp,-48
    4a12:	d606                	sw	ra,44(sp)
    4a14:	c62a                	sw	a0,12(sp)
    uint32_t chip_size_bytes = ctx->drv.get_flash_chip_size_bytes();
    4a16:	47b2                	lw	a5,12(sp)
    4a18:	47bc                	lw	a5,72(a5)
    4a1a:	9782                	jalr	a5
    4a1c:	ce2a                	sw	a0,28(sp)
    uint32_t block_size_bytes = ctx->drv.get_flash_block_size_bytes();
    4a1e:	47b2                	lw	a5,12(sp)
    4a20:	47fc                	lw	a5,76(a5)
    4a22:	9782                	jalr	a5
    4a24:	cc2a                	sw	a0,24(sp)

    FLASHSTRESS_LOG("\n=============================================\n");
    4a26:	3c418513          	add	a0,gp,964 # d34 <.LC27>
    4a2a:	cbaff0ef          	jal	3ee4 <printf>
    FLASHSTRESS_LOG("[%s]: chip size: %u\n", ctx->name, chip_size_bytes);
    4a2e:	47b2                	lw	a5,12(sp)
    4a30:	0791                	add	a5,a5,4
    4a32:	4672                	lw	a2,28(sp)
    4a34:	85be                	mv	a1,a5
    4a36:	3f418513          	add	a0,gp,1012 # d64 <.LC28>
    4a3a:	caaff0ef          	jal	3ee4 <printf>
    FLASHSTRESS_LOG("[%s]: block size: %u\n", ctx->name, block_size_bytes);
    4a3e:	47b2                	lw	a5,12(sp)
    4a40:	0791                	add	a5,a5,4
    4a42:	4662                	lw	a2,24(sp)
    4a44:	85be                	mv	a1,a5
    4a46:	40c18513          	add	a0,gp,1036 # d7c <.LC29>
    4a4a:	c9aff0ef          	jal	3ee4 <printf>
    FLASHSTRESS_LOG("=============================================\n");
    4a4e:	42418513          	add	a0,gp,1060 # d94 <.LC30>
    4a52:	c92ff0ef          	jal	3ee4 <printf>

    if (flashstress_erase_chip(ctx) < 0) {
    4a56:	4532                	lw	a0,12(sp)
    4a58:	3a15                	jal	438c <flashstress_erase_chip>
    4a5a:	87aa                	mv	a5,a0
    4a5c:	0207c763          	bltz	a5,4a8a <.L93>
        goto ERROR;
    }

    if (flashstress_write_read(ctx, 0x55) < 0) {
    4a60:	05500593          	li	a1,85
    4a64:	4532                	lw	a0,12(sp)
    4a66:	3921                	jal	467e <flashstress_write_read>
    4a68:	87aa                	mv	a5,a0
    4a6a:	0207c263          	bltz	a5,4a8e <.L94>
        goto ERROR;
    }

    if (flashstress_erase_all_blocks(ctx) < 0) {
    4a6e:	4532                	lw	a0,12(sp)
    4a70:	34c9                	jal	4532 <flashstress_erase_all_blocks>
    4a72:	87aa                	mv	a5,a0
    4a74:	0007cf63          	bltz	a5,4a92 <.L95>
        goto ERROR;
    }

    if (flashstress_write_read(ctx, 0xAA) < 0) {
    4a78:	0aa00593          	li	a1,170
    4a7c:	4532                	lw	a0,12(sp)
    4a7e:	3101                	jal	467e <flashstress_write_read>
    4a80:	87aa                	mv	a5,a0
    4a82:	0007ca63          	bltz	a5,4a96 <.L96>
        goto ERROR;
    }

    return 0;
    4a86:	4781                	li	a5,0
    4a88:	a005                	j	4aa8 <.L92>

00004a8a <.L93>:
        goto ERROR;
    4a8a:	0001                	nop
    4a8c:	a031                	j	4a98 <.L88>

00004a8e <.L94>:
        goto ERROR;
    4a8e:	0001                	nop
    4a90:	a021                	j	4a98 <.L88>

00004a92 <.L95>:
        goto ERROR;
    4a92:	0001                	nop
    4a94:	a011                	j	4a98 <.L88>

00004a96 <.L96>:
        goto ERROR;
    4a96:	0001                	nop

00004a98 <.L88>:

ERROR:
    FLASHSTRESS_LOG("[%s]: FAILED\n\n", ctx->name);
    4a98:	47b2                	lw	a5,12(sp)
    4a9a:	0791                	add	a5,a5,4
    4a9c:	85be                	mv	a1,a5
    4a9e:	45418513          	add	a0,gp,1108 # dc4 <.LC31>
    4aa2:	c42ff0ef          	jal	3ee4 <printf>
    return -1;
    4aa6:	57fd                	li	a5,-1

00004aa8 <.L92>:
}
    4aa8:	853e                	mv	a0,a5
    4aaa:	50b2                	lw	ra,44(sp)
    4aac:	6145                	add	sp,sp,48
    4aae:	8082                	ret

Disassembly of section .text.reset_handler:

00004ab0 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
    4ab0:	1141                	add	sp,sp,-16
    4ab2:	c606                	sw	ra,12(sp)
    fencei();
    4ab4:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
    4ab8:	d6ffc0ef          	jal	1826 <system_init>

    /* Entry function */
    MAIN_ENTRY();
    4abc:	dc6ff0ef          	jal	4082 <main>
}
    4ac0:	0001                	nop
    4ac2:	40b2                	lw	ra,12(sp)
    4ac4:	0141                	add	sp,sp,16
    4ac6:	8082                	ret

Disassembly of section .text._init:

00004ac8 <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
    4ac8:	0001                	nop
    4aca:	8082                	ret

Disassembly of section .text.mchtmr_isr:

00004acc <mchtmr_isr>:
}
    4acc:	0001                	nop
    4ace:	8082                	ret

Disassembly of section .text.swi_isr:

00004ad0 <swi_isr>:
}
    4ad0:	0001                	nop
    4ad2:	8082                	ret

Disassembly of section .text.exception_handler:

00004ad4 <exception_handler>:
{
    4ad4:	1141                	add	sp,sp,-16
    4ad6:	c62a                	sw	a0,12(sp)
    4ad8:	c42e                	sw	a1,8(sp)
    switch (cause) {
    4ada:	4732                	lw	a4,12(sp)
    4adc:	47bd                	li	a5,15
    4ade:	00e7ea63          	bltu	a5,a4,4af2 <.L23>
    4ae2:	47b2                	lw	a5,12(sp)
    4ae4:	00279713          	sll	a4,a5,0x2
    4ae8:	87818793          	add	a5,gp,-1928 # 1e8 <.L7>
    4aec:	97ba                	add	a5,a5,a4
    4aee:	439c                	lw	a5,0(a5)
    4af0:	8782                	jr	a5

00004af2 <.L23>:
        break;
    4af2:	0001                	nop
    return epc;
    4af4:	47a2                	lw	a5,8(sp)
}
    4af6:	853e                	mv	a0,a5
    4af8:	0141                	add	sp,sp,16
    4afa:	8082                	ret

Disassembly of section .text.enable_plic_feature:

00004afc <enable_plic_feature>:
{
    4afc:	1141                	add	sp,sp,-16
    uint32_t plic_feature = 0;
    4afe:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
    4b00:	47b2                	lw	a5,12(sp)
    4b02:	0027e793          	or	a5,a5,2
    4b06:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
    4b08:	47b2                	lw	a5,12(sp)
    4b0a:	0017e793          	or	a5,a5,1
    4b0e:	c63e                	sw	a5,12(sp)
    4b10:	e40007b7          	lui	a5,0xe4000
    4b14:	c43e                	sw	a5,8(sp)
    4b16:	47b2                	lw	a5,12(sp)
    4b18:	c23e                	sw	a5,4(sp)

00004b1a <.LBB14>:
 * @param[in] feature Specific feature to be set
 *
 */
ATTR_ALWAYS_INLINE static inline void __plic_set_feature(uint32_t base, uint32_t feature)
{
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
    4b1a:	47a2                	lw	a5,8(sp)
    4b1c:	4712                	lw	a4,4(sp)
    4b1e:	c398                	sw	a4,0(a5)
}
    4b20:	0001                	nop

00004b22 <.LBE14>:
}
    4b22:	0001                	nop
    4b24:	0141                	add	sp,sp,16
    4b26:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

00004b28 <sysctl_clock_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr, uint32_t clock)
{
    4b28:	1141                	add	sp,sp,-16
    4b2a:	c62a                	sw	a0,12(sp)
    4b2c:	c42e                	sw	a1,8(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
    4b2e:	4732                	lw	a4,12(sp)
    4b30:	47a2                	lw	a5,8(sp)
    4b32:	60078793          	add	a5,a5,1536 # e4000600 <_extram_size+0xe2000600>
    4b36:	078a                	sll	a5,a5,0x2
    4b38:	97ba                	add	a5,a5,a4
    4b3a:	4398                	lw	a4,0(a5)
    4b3c:	400007b7          	lui	a5,0x40000
    4b40:	8ff9                	and	a5,a5,a4
    4b42:	00f037b3          	snez	a5,a5
    4b46:	0ff7f793          	zext.b	a5,a5
}
    4b4a:	853e                	mv	a0,a5
    4b4c:	0141                	add	sp,sp,16
    4b4e:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

00004b50 <sysctl_enable_group_resource>:
{
    4b50:	7179                	add	sp,sp,-48
    4b52:	d606                	sw	ra,44(sp)
    4b54:	c62a                	sw	a0,12(sp)
    4b56:	87ae                	mv	a5,a1
    4b58:	8736                	mv	a4,a3
    4b5a:	00f105a3          	sb	a5,11(sp)
    4b5e:	87b2                	mv	a5,a2
    4b60:	00f11423          	sh	a5,8(sp)
    4b64:	87ba                	mv	a5,a4
    4b66:	00f10523          	sb	a5,10(sp)
    if (linkable_resource < sysctl_resource_linkable_start) {
    4b6a:	00815703          	lhu	a4,8(sp)
    4b6e:	0ff00793          	li	a5,255
    4b72:	00e7e463          	bltu	a5,a4,4b7a <.L59>
        return status_invalid_argument;
    4b76:	4789                	li	a5,2
    4b78:	a8e5                	j	4c70 <.L60>

00004b7a <.L59>:
    index = (linkable_resource - sysctl_resource_linkable_start) / 32;
    4b7a:	00815783          	lhu	a5,8(sp)
    4b7e:	f0078793          	add	a5,a5,-256 # 3fffff00 <_extram_size+0x3dffff00>
    4b82:	41f7d713          	sra	a4,a5,0x1f
    4b86:	8b7d                	and	a4,a4,31
    4b88:	97ba                	add	a5,a5,a4
    4b8a:	8795                	sra	a5,a5,0x5
    4b8c:	ce3e                	sw	a5,28(sp)
    offset = (linkable_resource - sysctl_resource_linkable_start) % 32;
    4b8e:	00815783          	lhu	a5,8(sp)
    4b92:	f0078713          	add	a4,a5,-256
    4b96:	41f75793          	sra	a5,a4,0x1f
    4b9a:	83ed                	srl	a5,a5,0x1b
    4b9c:	973e                	add	a4,a4,a5
    4b9e:	8b7d                	and	a4,a4,31
    4ba0:	40f707b3          	sub	a5,a4,a5
    4ba4:	cc3e                	sw	a5,24(sp)
    switch (group) {
    4ba6:	00b14783          	lbu	a5,11(sp)
    4baa:	c789                	beqz	a5,4bb4 <.L61>
    4bac:	4705                	li	a4,1
    4bae:	04e78f63          	beq	a5,a4,4c0c <.L62>
    4bb2:	a84d                	j	4c64 <.L73>

00004bb4 <.L61>:
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
    4bb4:	4732                	lw	a4,12(sp)
    4bb6:	47f2                	lw	a5,28(sp)
    4bb8:	08078793          	add	a5,a5,128
    4bbc:	0792                	sll	a5,a5,0x4
    4bbe:	97ba                	add	a5,a5,a4
    4bc0:	4398                	lw	a4,0(a5)
    4bc2:	47e2                	lw	a5,24(sp)
    4bc4:	4685                	li	a3,1
    4bc6:	00f697b3          	sll	a5,a3,a5
    4bca:	fff7c793          	not	a5,a5
    4bce:	8f7d                	and	a4,a4,a5
    4bd0:	00a14783          	lbu	a5,10(sp)
    4bd4:	c791                	beqz	a5,4be0 <.L64>
    4bd6:	47e2                	lw	a5,24(sp)
    4bd8:	4685                	li	a3,1
    4bda:	00f697b3          	sll	a5,a3,a5
    4bde:	a011                	j	4be2 <.L65>

00004be0 <.L64>:
    4be0:	4781                	li	a5,0

00004be2 <.L65>:
    4be2:	8f5d                	or	a4,a4,a5
    4be4:	46b2                	lw	a3,12(sp)
    4be6:	47f2                	lw	a5,28(sp)
    4be8:	08078793          	add	a5,a5,128
    4bec:	0792                	sll	a5,a5,0x4
    4bee:	97b6                	add	a5,a5,a3
    4bf0:	c398                	sw	a4,0(a5)
        if (enable) {
    4bf2:	00a14783          	lbu	a5,10(sp)
    4bf6:	cbad                	beqz	a5,4c68 <.L74>
            while (sysctl_resource_target_is_busy(ptr, linkable_resource)) {
    4bf8:	0001                	nop

00004bfa <.L67>:
    4bfa:	00815783          	lhu	a5,8(sp)
    4bfe:	85be                	mv	a1,a5
    4c00:	4532                	lw	a0,12(sp)
    4c02:	c85fc0ef          	jal	1886 <sysctl_resource_target_is_busy>
    4c06:	87aa                	mv	a5,a0
    4c08:	fbed                	bnez	a5,4bfa <.L67>
        break;
    4c0a:	a8b9                	j	4c68 <.L74>

00004c0c <.L62>:
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
    4c0c:	4732                	lw	a4,12(sp)
    4c0e:	47f2                	lw	a5,28(sp)
    4c10:	08478793          	add	a5,a5,132
    4c14:	0792                	sll	a5,a5,0x4
    4c16:	97ba                	add	a5,a5,a4
    4c18:	4398                	lw	a4,0(a5)
    4c1a:	47e2                	lw	a5,24(sp)
    4c1c:	4685                	li	a3,1
    4c1e:	00f697b3          	sll	a5,a3,a5
    4c22:	fff7c793          	not	a5,a5
    4c26:	8f7d                	and	a4,a4,a5
    4c28:	00a14783          	lbu	a5,10(sp)
    4c2c:	c791                	beqz	a5,4c38 <.L69>
    4c2e:	47e2                	lw	a5,24(sp)
    4c30:	4685                	li	a3,1
    4c32:	00f697b3          	sll	a5,a3,a5
    4c36:	a011                	j	4c3a <.L70>

00004c38 <.L69>:
    4c38:	4781                	li	a5,0

00004c3a <.L70>:
    4c3a:	8f5d                	or	a4,a4,a5
    4c3c:	46b2                	lw	a3,12(sp)
    4c3e:	47f2                	lw	a5,28(sp)
    4c40:	08478793          	add	a5,a5,132
    4c44:	0792                	sll	a5,a5,0x4
    4c46:	97b6                	add	a5,a5,a3
    4c48:	c398                	sw	a4,0(a5)
        if (enable) {
    4c4a:	00a14783          	lbu	a5,10(sp)
    4c4e:	cf99                	beqz	a5,4c6c <.L75>
            while (sysctl_resource_target_is_busy(ptr, linkable_resource)) {
    4c50:	0001                	nop

00004c52 <.L72>:
    4c52:	00815783          	lhu	a5,8(sp)
    4c56:	85be                	mv	a1,a5
    4c58:	4532                	lw	a0,12(sp)
    4c5a:	c2dfc0ef          	jal	1886 <sysctl_resource_target_is_busy>
    4c5e:	87aa                	mv	a5,a0
    4c60:	fbed                	bnez	a5,4c52 <.L72>
        break;
    4c62:	a029                	j	4c6c <.L75>

00004c64 <.L73>:
        return status_invalid_argument;
    4c64:	4789                	li	a5,2
    4c66:	a029                	j	4c70 <.L60>

00004c68 <.L74>:
        break;
    4c68:	0001                	nop
    4c6a:	a011                	j	4c6e <.L68>

00004c6c <.L75>:
        break;
    4c6c:	0001                	nop

00004c6e <.L68>:
    return status_success;
    4c6e:	4781                	li	a5,0

00004c70 <.L60>:
}
    4c70:	853e                	mv	a0,a5
    4c72:	50b2                	lw	ra,44(sp)
    4c74:	6145                	add	sp,sp,48
    4c76:	8082                	ret

Disassembly of section .text.clock_get_frequency:

00004c78 <clock_get_frequency>:
{
    4c78:	7179                	add	sp,sp,-48
    4c7a:	d606                	sw	ra,44(sp)
    4c7c:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
    4c7e:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
    4c80:	47b2                	lw	a5,12(sp)
    4c82:	83a1                	srl	a5,a5,0x8
    4c84:	0ff7f793          	zext.b	a5,a5
    4c88:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
    4c8a:	47b2                	lw	a5,12(sp)
    4c8c:	0ff7f793          	zext.b	a5,a5
    4c90:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
    4c92:	4762                	lw	a4,24(sp)
    4c94:	47b5                	li	a5,13
    4c96:	0ae7e363          	bltu	a5,a4,4d3c <.L16>
    4c9a:	47e2                	lw	a5,24(sp)
    4c9c:	00279713          	sll	a4,a5,0x2
    4ca0:	8c818793          	add	a5,gp,-1848 # 238 <.L18>
    4ca4:	97ba                	add	a5,a5,a4
    4ca6:	439c                	lw	a5,0(a5)
    4ca8:	8782                	jr	a5

00004caa <.L31>:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
    4caa:	47d2                	lw	a5,20(sp)
    4cac:	0ff7f793          	zext.b	a5,a5
    4cb0:	853e                	mv	a0,a5
    4cb2:	bccfd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4cb6:	ce2a                	sw	a0,28(sp)
        break;
    4cb8:	a061                	j	4d40 <.L32>

00004cba <.L30>:
        clk_freq = get_frequency_for_adc(node_or_instance);
    4cba:	4552                	lw	a0,20(sp)
    4cbc:	2079                	jal	4d4a <.LFE146>
    4cbe:	ce2a                	sw	a0,28(sp)
        break;
    4cc0:	a041                	j	4d40 <.L32>

00004cc2 <.L29>:
        clk_freq = get_frequency_for_i2s(node_or_instance);
    4cc2:	4552                	lw	a0,20(sp)
    4cc4:	c26fd0ef          	jal	20ea <get_frequency_for_i2s>
    4cc8:	ce2a                	sw	a0,28(sp)
        break;
    4cca:	a89d                	j	4d40 <.L32>

00004ccc <.L28>:
        clk_freq = get_frequency_for_ewdg(node_or_instance);
    4ccc:	4552                	lw	a0,20(sp)
    4cce:	2a01                	jal	4dde <get_frequency_for_ewdg>
    4cd0:	ce2a                	sw	a0,28(sp)
        break;
    4cd2:	a0bd                	j	4d40 <.L32>

00004cd4 <.L21>:
        clk_freq = get_frequency_for_pewdg();
    4cd4:	2a3d                	jal	4e12 <get_frequency_for_pewdg>
    4cd6:	ce2a                	sw	a0,28(sp)
        break;
    4cd8:	a0a5                	j	4d40 <.L32>

00004cda <.L22>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
    4cda:	016e37b7          	lui	a5,0x16e3
    4cde:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
    4ce2:	ce3e                	sw	a5,28(sp)
        break;
    4ce4:	a8b1                	j	4d40 <.L32>

00004ce6 <.L27>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
    4ce6:	4511                	li	a0,4
    4ce8:	b96fd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4cec:	ce2a                	sw	a0,28(sp)
        break;
    4cee:	a889                	j	4d40 <.L32>

00004cf0 <.L26>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axif);
    4cf0:	4515                	li	a0,5
    4cf2:	b8cfd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4cf6:	ce2a                	sw	a0,28(sp)
        break;
    4cf8:	a0a1                	j	4d40 <.L32>

00004cfa <.L25>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axis);
    4cfa:	4519                	li	a0,6
    4cfc:	b82fd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4d00:	ce2a                	sw	a0,28(sp)
        break;
    4d02:	a83d                	j	4d40 <.L32>

00004d04 <.L24>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axic);
    4d04:	451d                	li	a0,7
    4d06:	b78fd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4d0a:	ce2a                	sw	a0,28(sp)
        break;
    4d0c:	a815                	j	4d40 <.L32>

00004d0e <.L23>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axin);
    4d0e:	4521                	li	a0,8
    4d10:	b6efd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4d14:	ce2a                	sw	a0,28(sp)
        break;
    4d16:	a02d                	j	4d40 <.L32>

00004d18 <.L20>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
    4d18:	4501                	li	a0,0
    4d1a:	b64fd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4d1e:	ce2a                	sw	a0,28(sp)
        break;
    4d20:	a005                	j	4d40 <.L32>

00004d22 <.L19>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu1);
    4d22:	4509                	li	a0,2
    4d24:	b5afd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4d28:	ce2a                	sw	a0,28(sp)
        break;
    4d2a:	a819                	j	4d40 <.L32>

00004d2c <.L17>:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
    4d2c:	47d2                	lw	a5,20(sp)
    4d2e:	0ff7f793          	zext.b	a5,a5
    4d32:	853e                	mv	a0,a5
    4d34:	a9cfd0ef          	jal	1fd0 <get_frequency_for_source>
    4d38:	ce2a                	sw	a0,28(sp)
        break;
    4d3a:	a019                	j	4d40 <.L32>

00004d3c <.L16>:
        clk_freq = 0UL;
    4d3c:	ce02                	sw	zero,28(sp)
        break;
    4d3e:	0001                	nop

00004d40 <.L32>:
    return clk_freq;
    4d40:	47f2                	lw	a5,28(sp)
}
    4d42:	853e                	mv	a0,a5
    4d44:	50b2                	lw	ra,44(sp)
    4d46:	6145                	add	sp,sp,48
    4d48:	8082                	ret

Disassembly of section .text.get_frequency_for_adc:

00004d4a <get_frequency_for_adc>:
{
    4d4a:	7179                	add	sp,sp,-48
    4d4c:	d606                	sw	ra,44(sp)
    4d4e:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
    4d50:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
    4d52:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
    4d56:	04f00793          	li	a5,79
    4d5a:	00f10d23          	sb	a5,26(sp)
    if (instance < ADC_INSTANCE_NUM) {
    4d5e:	4732                	lw	a4,12(sp)
    4d60:	478d                	li	a5,3
    4d62:	02e7ee63          	bltu	a5,a4,4d9e <.L51>

00004d66 <.LBB7>:
        uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[instance]);
    4d66:	f4000737          	lui	a4,0xf4000
    4d6a:	47b2                	lw	a5,12(sp)
    4d6c:	70078793          	add	a5,a5,1792
    4d70:	078a                	sll	a5,a5,0x2
    4d72:	97ba                	add	a5,a5,a4
    4d74:	439c                	lw	a5,0(a5)
    4d76:	83a1                	srl	a5,a5,0x8
    4d78:	8b85                	and	a5,a5,1
    4d7a:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
    4d7c:	4752                	lw	a4,20(sp)
    4d7e:	4785                	li	a5,1
    4d80:	00e7ef63          	bltu	a5,a4,4d9e <.L51>
            node = s_adc_clk_mux_node[mux_in_reg];
    4d84:	000007b7          	lui	a5,0x0
    4d88:	14478713          	add	a4,a5,324 # 144 <s_adc_clk_mux_node>
    4d8c:	47d2                	lw	a5,20(sp)
    4d8e:	97ba                	add	a5,a5,a4
    4d90:	0007c783          	lbu	a5,0(a5)
    4d94:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
    4d98:	4785                	li	a5,1
    4d9a:	00f10da3          	sb	a5,27(sp)

00004d9e <.L51>:
    if (is_mux_valid) {
    4d9e:	01b14783          	lbu	a5,27(sp)
    4da2:	cb8d                	beqz	a5,4dd4 <.L52>
        if (node == clock_node_ahb0) {
    4da4:	01a14703          	lbu	a4,26(sp)
    4da8:	4791                	li	a5,4
    4daa:	00f71763          	bne	a4,a5,4db8 <.L53>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
    4dae:	4511                	li	a0,4
    4db0:	acefd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4db4:	ce2a                	sw	a0,28(sp)
    4db6:	a839                	j	4dd4 <.L52>

00004db8 <.L53>:
            node += instance;
    4db8:	47b2                	lw	a5,12(sp)
    4dba:	0ff7f793          	zext.b	a5,a5
    4dbe:	01a14703          	lbu	a4,26(sp)
    4dc2:	97ba                	add	a5,a5,a4
    4dc4:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
    4dc8:	01a14783          	lbu	a5,26(sp)
    4dcc:	853e                	mv	a0,a5
    4dce:	ab0fd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4dd2:	ce2a                	sw	a0,28(sp)

00004dd4 <.L52>:
    return clk_freq;
    4dd4:	47f2                	lw	a5,28(sp)
}
    4dd6:	853e                	mv	a0,a5
    4dd8:	50b2                	lw	ra,44(sp)
    4dda:	6145                	add	sp,sp,48
    4ddc:	8082                	ret

Disassembly of section .text.get_frequency_for_ewdg:

00004dde <get_frequency_for_ewdg>:
{
    4dde:	7179                	add	sp,sp,-48
    4de0:	d606                	sw	ra,44(sp)
    4de2:	c62a                	sw	a0,12(sp)
    if (EWDG_CTRL0_CLK_SEL_GET(s_wdgs[instance]->CTRL0) == 0) {
    4de4:	8b818713          	add	a4,gp,-1864 # 228 <s_wdgs>
    4de8:	47b2                	lw	a5,12(sp)
    4dea:	078a                	sll	a5,a5,0x2
    4dec:	97ba                	add	a5,a5,a4
    4dee:	439c                	lw	a5,0(a5)
    4df0:	4398                	lw	a4,0(a5)
    4df2:	200007b7          	lui	a5,0x20000
    4df6:	8ff9                	and	a5,a5,a4
    4df8:	e791                	bnez	a5,4e04 <.L62>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
    4dfa:	4511                	li	a0,4
    4dfc:	a82fd0ef          	jal	207e <get_frequency_for_ip_in_common_group>
    4e00:	ce2a                	sw	a0,28(sp)
    4e02:	a019                	j	4e08 <.L63>

00004e04 <.L62>:
        freq_in_hz = FREQ_32KHz;
    4e04:	67a1                	lui	a5,0x8
    4e06:	ce3e                	sw	a5,28(sp)

00004e08 <.L63>:
    return freq_in_hz;
    4e08:	47f2                	lw	a5,28(sp)
}
    4e0a:	853e                	mv	a0,a5
    4e0c:	50b2                	lw	ra,44(sp)
    4e0e:	6145                	add	sp,sp,48
    4e10:	8082                	ret

Disassembly of section .text.get_frequency_for_pewdg:

00004e12 <get_frequency_for_pewdg>:
{
    4e12:	1141                	add	sp,sp,-16
    if (EWDG_CTRL0_CLK_SEL_GET(HPM_PEWDG->CTRL0) == 0) {
    4e14:	f41287b7          	lui	a5,0xf4128
    4e18:	4398                	lw	a4,0(a5)
    4e1a:	200007b7          	lui	a5,0x20000
    4e1e:	8ff9                	and	a5,a5,a4
    4e20:	e799                	bnez	a5,4e2e <.L66>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
    4e22:	016e37b7          	lui	a5,0x16e3
    4e26:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
    4e2a:	c63e                	sw	a5,12(sp)
    4e2c:	a019                	j	4e32 <.L67>

00004e2e <.L66>:
        freq_in_hz = FREQ_32KHz;
    4e2e:	67a1                	lui	a5,0x8
    4e30:	c63e                	sw	a5,12(sp)

00004e32 <.L67>:
    return freq_in_hz;
    4e32:	47b2                	lw	a5,12(sp)
}
    4e34:	853e                	mv	a0,a5
    4e36:	0141                	add	sp,sp,16
    4e38:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

00004e3a <clock_set_source_divider>:
{
    4e3a:	7179                	add	sp,sp,-48
    4e3c:	d606                	sw	ra,44(sp)
    4e3e:	c62a                	sw	a0,12(sp)
    4e40:	87ae                	mv	a5,a1
    4e42:	c232                	sw	a2,4(sp)
    4e44:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
    4e48:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
    4e4a:	47b2                	lw	a5,12(sp)
    4e4c:	83a1                	srl	a5,a5,0x8
    4e4e:	0ff7f793          	zext.b	a5,a5
    4e52:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
    4e54:	47b2                	lw	a5,12(sp)
    4e56:	0ff7f793          	zext.b	a5,a5
    4e5a:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
    4e5c:	4762                	lw	a4,24(sp)
    4e5e:	47b5                	li	a5,13
    4e60:	0ae7e563          	bltu	a5,a4,4f0a <.L129>
    4e64:	47e2                	lw	a5,24(sp)
    4e66:	00279713          	sll	a4,a5,0x2
    4e6a:	92018793          	add	a5,gp,-1760 # 290 <.L131>
    4e6e:	97ba                	add	a5,a5,a4
    4e70:	439c                	lw	a5,0(a5)
    4e72:	8782                	jr	a5

00004e74 <.L140>:
        if ((div < 1U) || (div > 256U)) {
    4e74:	4792                	lw	a5,4(sp)
    4e76:	c791                	beqz	a5,4e82 <.L141>
    4e78:	4712                	lw	a4,4(sp)
    4e7a:	10000793          	li	a5,256
    4e7e:	00e7f763          	bgeu	a5,a4,4e8c <.L142>

00004e82 <.L141>:
            status = status_clk_div_invalid;
    4e82:	6795                	lui	a5,0x5
    4e84:	5f078793          	add	a5,a5,1520 # 55f0 <.L14+0x1e>
    4e88:	ce3e                	sw	a5,28(sp)
        break;
    4e8a:	a069                	j	4f14 <.L144>

00004e8c <.L142>:
            clock_source_t source = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
    4e8c:	00b14783          	lbu	a5,11(sp)
    4e90:	8bbd                	and	a5,a5,15
    4e92:	00f109a3          	sb	a5,19(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, source, div);
    4e96:	47d2                	lw	a5,20(sp)
    4e98:	0ff7f793          	zext.b	a5,a5
    4e9c:	01314703          	lbu	a4,19(sp)
    4ea0:	4692                	lw	a3,4(sp)
    4ea2:	863a                	mv	a2,a4
    4ea4:	85be                	mv	a1,a5
    4ea6:	f4000537          	lui	a0,0xf4000
    4eaa:	892fd0ef          	jal	1f3c <sysctl_config_clock>

00004eae <.LBE12>:
        break;
    4eae:	a09d                	j	4f14 <.L144>

00004eb0 <.L130>:
        status = status_clk_operation_unsupported;
    4eb0:	6795                	lui	a5,0x5
    4eb2:	5f378793          	add	a5,a5,1523 # 55f3 <.L14+0x21>
    4eb6:	ce3e                	sw	a5,28(sp)
        break;
    4eb8:	a8b1                	j	4f14 <.L144>

00004eba <.L134>:
        status = status_clk_fixed;
    4eba:	6795                	lui	a5,0x5
    4ebc:	5fb78793          	add	a5,a5,1531 # 55fb <.L14+0x29>
    4ec0:	ce3e                	sw	a5,28(sp)
        break;
    4ec2:	a889                	j	4f14 <.L144>

00004ec4 <.L139>:
        status = status_clk_shared_ahb;
    4ec4:	6795                	lui	a5,0x5
    4ec6:	5f478793          	add	a5,a5,1524 # 55f4 <.L14+0x22>
    4eca:	ce3e                	sw	a5,28(sp)
        break;
    4ecc:	a0a1                	j	4f14 <.L144>

00004ece <.L138>:
        status = status_clk_shared_axif;
    4ece:	6795                	lui	a5,0x5
    4ed0:	5f578793          	add	a5,a5,1525 # 55f5 <.L14+0x23>
    4ed4:	ce3e                	sw	a5,28(sp)
        break;
    4ed6:	a83d                	j	4f14 <.L144>

00004ed8 <.L137>:
        status = status_clk_shared_axis;
    4ed8:	6795                	lui	a5,0x5
    4eda:	5f678793          	add	a5,a5,1526 # 55f6 <.L14+0x24>
    4ede:	ce3e                	sw	a5,28(sp)
        break;
    4ee0:	a815                	j	4f14 <.L144>

00004ee2 <.L136>:
        status = status_clk_shared_axic;
    4ee2:	6795                	lui	a5,0x5
    4ee4:	5f778793          	add	a5,a5,1527 # 55f7 <.L14+0x25>
    4ee8:	ce3e                	sw	a5,28(sp)
        break;
    4eea:	a02d                	j	4f14 <.L144>

00004eec <.L135>:
        status = status_clk_shared_axin;
    4eec:	6795                	lui	a5,0x5
    4eee:	5f878793          	add	a5,a5,1528 # 55f8 <.L14+0x26>
    4ef2:	ce3e                	sw	a5,28(sp)
        break;
    4ef4:	a005                	j	4f14 <.L144>

00004ef6 <.L133>:
        status = status_clk_shared_cpu0;
    4ef6:	6795                	lui	a5,0x5
    4ef8:	5f978793          	add	a5,a5,1529 # 55f9 <.L14+0x27>
    4efc:	ce3e                	sw	a5,28(sp)
        break;
    4efe:	a819                	j	4f14 <.L144>

00004f00 <.L132>:
        status = status_clk_shared_cpu1;
    4f00:	6795                	lui	a5,0x5
    4f02:	5fa78793          	add	a5,a5,1530 # 55fa <.L14+0x28>
    4f06:	ce3e                	sw	a5,28(sp)
        break;
    4f08:	a031                	j	4f14 <.L144>

00004f0a <.L129>:
        status = status_clk_src_invalid;
    4f0a:	6795                	lui	a5,0x5
    4f0c:	5f178793          	add	a5,a5,1521 # 55f1 <.L14+0x1f>
    4f10:	ce3e                	sw	a5,28(sp)
        break;
    4f12:	0001                	nop

00004f14 <.L144>:
    return status;
    4f14:	47f2                	lw	a5,28(sp)
}
    4f16:	853e                	mv	a0,a5
    4f18:	50b2                	lw	ra,44(sp)
    4f1a:	6145                	add	sp,sp,48
    4f1c:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

00004f1e <clock_connect_group_to_cpu>:
{
    4f1e:	1141                	add	sp,sp,-16
    4f20:	c62a                	sw	a0,12(sp)
    4f22:	c42e                	sw	a1,8(sp)
    if (cpu < 2U) {
    4f24:	4722                	lw	a4,8(sp)
    4f26:	4785                	li	a5,1
    4f28:	00e7ee63          	bltu	a5,a4,4f44 <.L164>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
    4f2c:	f40006b7          	lui	a3,0xf4000
    4f30:	47b2                	lw	a5,12(sp)
    4f32:	4705                	li	a4,1
    4f34:	00f71733          	sll	a4,a4,a5
    4f38:	47a2                	lw	a5,8(sp)
    4f3a:	09078793          	add	a5,a5,144
    4f3e:	0792                	sll	a5,a5,0x4
    4f40:	97b6                	add	a5,a5,a3
    4f42:	c3d8                	sw	a4,4(a5)

00004f44 <.L164>:
}
    4f44:	0001                	nop
    4f46:	0141                	add	sp,sp,16
    4f48:	8082                	ret

Disassembly of section .text.l1c_dc_disable:

00004f4a <l1c_dc_disable>:
{
    4f4a:	1141                	add	sp,sp,-16

00004f4c <.LBB53>:
    return read_csr(CSR_MCACHE_CTL);
    4f4c:	7ca027f3          	csrr	a5,0x7ca
    4f50:	c63e                	sw	a5,12(sp)
    4f52:	47b2                	lw	a5,12(sp)

00004f54 <.LBE57>:
    4f54:	0001                	nop

00004f56 <.LBE55>:
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
    4f56:	8b89                	and	a5,a5,2
    4f58:	00f037b3          	snez	a5,a5
    4f5c:	0ff7f793          	zext.b	a5,a5

00004f60 <.LBE53>:
    if (l1c_dc_is_enabled()) {
    4f60:	c781                	beqz	a5,4f68 <.L16>
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    4f62:	4789                	li	a5,2
    4f64:	7ca7b073          	csrc	0x7ca,a5

00004f68 <.L16>:
}
    4f68:	0001                	nop
    4f6a:	0141                	add	sp,sp,16
    4f6c:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

00004f6e <l1c_dc_invalidate_all>:
{
    4f6e:	1141                	add	sp,sp,-16
    4f70:	47dd                	li	a5,23
    4f72:	00f107a3          	sb	a5,15(sp)

00004f76 <.LBB68>:
    write_csr(CSR_MCCTLCOMMAND, cmd);
    4f76:	00f14783          	lbu	a5,15(sp)
    4f7a:	7cc79073          	csrw	0x7cc,a5
}
    4f7e:	0001                	nop

00004f80 <.LBE68>:
}
    4f80:	0001                	nop
    4f82:	0141                	add	sp,sp,16
    4f84:	8082                	ret

Disassembly of section .text.l1c_dc_writeback_all:

00004f86 <l1c_dc_writeback_all>:
{
    4f86:	1141                	add	sp,sp,-16
    4f88:	479d                	li	a5,7
    4f8a:	00f107a3          	sb	a5,15(sp)

00004f8e <.LBB70>:
    write_csr(CSR_MCCTLCOMMAND, cmd);
    4f8e:	00f14783          	lbu	a5,15(sp)
    4f92:	7cc79073          	csrw	0x7cc,a5
}
    4f96:	0001                	nop

00004f98 <.LBE70>:
}
    4f98:	0001                	nop
    4f9a:	0141                	add	sp,sp,16
    4f9c:	8082                	ret

Disassembly of section .text.init_uart_pins:

00004f9e <init_uart_pins>:
 *
 */
#include "board.h"

void init_uart_pins(UART_Type *ptr)
{
    4f9e:	1141                	add	sp,sp,-16
    4fa0:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
    4fa2:	4732                	lw	a4,12(sp)
    4fa4:	f00407b7          	lui	a5,0xf0040
    4fa8:	00f71b63          	bne	a4,a5,4fbe <.L2>
        HPM_IOC->PAD[IOC_PAD_PA00].FUNC_CTL = IOC_PA00_FUNC_CTL_UART0_TXD;
    4fac:	f40407b7          	lui	a5,0xf4040
    4fb0:	4709                	li	a4,2
    4fb2:	c398                	sw	a4,0(a5)
        HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
    4fb4:	f40407b7          	lui	a5,0xf4040
    4fb8:	4709                	li	a4,2
    4fba:	c798                	sw	a4,8(a5)
        HPM_PIOC->PAD[IOC_PAD_PY00].FUNC_CTL = PIOC_PY00_FUNC_CTL_PURT_TXD;
        HPM_PIOC->PAD[IOC_PAD_PY01].FUNC_CTL = PIOC_PY01_FUNC_CTL_PURT_RXD;
    } else {
        ;
    }
}
    4fbc:	a071                	j	5048 <.L6>

00004fbe <.L2>:
    } else if (ptr == HPM_UART1) {
    4fbe:	4732                	lw	a4,12(sp)
    4fc0:	f00447b7          	lui	a5,0xf0044
    4fc4:	02f71f63          	bne	a4,a5,5002 <.L4>
        HPM_IOC->PAD[IOC_PAD_PY07].FUNC_CTL = IOC_PY07_FUNC_CTL_UART1_TXD;
    4fc8:	f4040737          	lui	a4,0xf4040
    4fcc:	6785                	lui	a5,0x1
    4fce:	97ba                	add	a5,a5,a4
    4fd0:	4709                	li	a4,2
    4fd2:	e2e7ac23          	sw	a4,-456(a5) # e38 <__SEGGER_RTL_fdiv_reciprocal_table+0x54>
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_SOC_PY_07;
    4fd6:	f4118737          	lui	a4,0xf4118
    4fda:	6785                	lui	a5,0x1
    4fdc:	97ba                	add	a5,a5,a4
    4fde:	470d                	li	a4,3
    4fe0:	e2e7ac23          	sw	a4,-456(a5) # e38 <__SEGGER_RTL_fdiv_reciprocal_table+0x54>
        HPM_IOC->PAD[IOC_PAD_PY06].FUNC_CTL = IOC_PY06_FUNC_CTL_UART1_RXD;
    4fe4:	f4040737          	lui	a4,0xf4040
    4fe8:	6785                	lui	a5,0x1
    4fea:	97ba                	add	a5,a5,a4
    4fec:	4709                	li	a4,2
    4fee:	e2e7a823          	sw	a4,-464(a5) # e30 <__SEGGER_RTL_fdiv_reciprocal_table+0x4c>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_SOC_PY_06;
    4ff2:	f4118737          	lui	a4,0xf4118
    4ff6:	6785                	lui	a5,0x1
    4ff8:	97ba                	add	a5,a5,a4
    4ffa:	470d                	li	a4,3
    4ffc:	e2e7a823          	sw	a4,-464(a5) # e30 <__SEGGER_RTL_fdiv_reciprocal_table+0x4c>
}
    5000:	a0a1                	j	5048 <.L6>

00005002 <.L4>:
    } else if (ptr == HPM_UART14) {
    5002:	4732                	lw	a4,12(sp)
    5004:	f01987b7          	lui	a5,0xf0198
    5008:	00f71d63          	bne	a4,a5,5022 <.L5>
        HPM_IOC->PAD[IOC_PAD_PF24].FUNC_CTL = IOC_PF24_FUNC_CTL_UART14_TXD;
    500c:	f40407b7          	lui	a5,0xf4040
    5010:	4709                	li	a4,2
    5012:	5ce7a023          	sw	a4,1472(a5) # f40405c0 <__AHB_SRAM_segment_end__+0x3e385c0>
        HPM_IOC->PAD[IOC_PAD_PF25].FUNC_CTL = IOC_PF25_FUNC_CTL_UART14_RXD;
    5016:	f40407b7          	lui	a5,0xf4040
    501a:	4709                	li	a4,2
    501c:	5ce7a423          	sw	a4,1480(a5) # f40405c8 <__AHB_SRAM_segment_end__+0x3e385c8>
}
    5020:	a025                	j	5048 <.L6>

00005022 <.L5>:
    } else if (ptr == HPM_PUART) {
    5022:	4732                	lw	a4,12(sp)
    5024:	f41247b7          	lui	a5,0xf4124
    5028:	02f71063          	bne	a4,a5,5048 <.L6>
        HPM_PIOC->PAD[IOC_PAD_PY00].FUNC_CTL = PIOC_PY00_FUNC_CTL_PURT_TXD;
    502c:	f4118737          	lui	a4,0xf4118
    5030:	6785                	lui	a5,0x1
    5032:	97ba                	add	a5,a5,a4
    5034:	4705                	li	a4,1
    5036:	e0e7a023          	sw	a4,-512(a5) # e00 <__SEGGER_RTL_fdiv_reciprocal_table+0x1c>
        HPM_PIOC->PAD[IOC_PAD_PY01].FUNC_CTL = PIOC_PY01_FUNC_CTL_PURT_RXD;
    503a:	f4118737          	lui	a4,0xf4118
    503e:	6785                	lui	a5,0x1
    5040:	97ba                	add	a5,a5,a4
    5042:	4705                	li	a4,1
    5044:	e0e7a423          	sw	a4,-504(a5) # e08 <__SEGGER_RTL_fdiv_reciprocal_table+0x24>

00005048 <.L6>:
}
    5048:	0001                	nop
    504a:	0141                	add	sp,sp,16
    504c:	8082                	ret

Disassembly of section .text.sysctl_set_cpu_lp_mode:

0000504e <sysctl_set_cpu_lp_mode>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] cpu_index CPU index
 * @param[in] mode target mode to set
 */
static inline void sysctl_set_cpu_lp_mode(SYSCTL_Type *ptr, uint8_t cpu_index, cpu_lp_mode_t mode)
{
    504e:	1141                	add	sp,sp,-16
    5050:	c62a                	sw	a0,12(sp)
    5052:	87ae                	mv	a5,a1
    5054:	8732                	mv	a4,a2
    5056:	00f105a3          	sb	a5,11(sp)
    505a:	87ba                	mv	a5,a4
    505c:	00f10523          	sb	a5,10(sp)
    ptr->CPU[cpu_index].LP = (ptr->CPU[cpu_index].LP & ~(SYSCTL_CPU_LP_MODE_MASK)) | (mode);
    5060:	00b14783          	lbu	a5,11(sp)
    5064:	4732                	lw	a4,12(sp)
    5066:	07a9                	add	a5,a5,10
    5068:	07aa                	sll	a5,a5,0xa
    506a:	97ba                	add	a5,a5,a4
    506c:	439c                	lw	a5,0(a5)
    506e:	ffe7f693          	and	a3,a5,-2
    5072:	9af5                	and	a3,a3,-3
    5074:	00a14703          	lbu	a4,10(sp)
    5078:	00b14783          	lbu	a5,11(sp)
    507c:	8f55                	or	a4,a4,a3
    507e:	46b2                	lw	a3,12(sp)
    5080:	07a9                	add	a5,a5,10
    5082:	07aa                	sll	a5,a5,0xa
    5084:	97b6                	add	a5,a5,a3
    5086:	c398                	sw	a4,0(a5)
}
    5088:	0001                	nop
    508a:	0141                	add	sp,sp,16
    508c:	8082                	ret

Disassembly of section .text.gptmr_check_status:

0000508e <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
    508e:	1141                	add	sp,sp,-16
    5090:	c62a                	sw	a0,12(sp)
    5092:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
    5094:	47b2                	lw	a5,12(sp)
    5096:	2007a703          	lw	a4,512(a5)
    509a:	47a2                	lw	a5,8(sp)
    509c:	8ff9                	and	a5,a5,a4
    509e:	4722                	lw	a4,8(sp)
    50a0:	40f707b3          	sub	a5,a4,a5
    50a4:	0017b793          	seqz	a5,a5
    50a8:	0ff7f793          	zext.b	a5,a5
}
    50ac:	853e                	mv	a0,a5
    50ae:	0141                	add	sp,sp,16
    50b0:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

000050b2 <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
    50b2:	1141                	add	sp,sp,-16
    50b4:	c62a                	sw	a0,12(sp)
    50b6:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
    50b8:	47b2                	lw	a5,12(sp)
    50ba:	4722                	lw	a4,8(sp)
    50bc:	20e7a023          	sw	a4,512(a5)
}
    50c0:	0001                	nop
    50c2:	0141                	add	sp,sp,16
    50c4:	8082                	ret

Disassembly of section .text.board_init_console:

000050c6 <board_init_console>:
{
    50c6:	1101                	add	sp,sp,-32
    50c8:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
    50ca:	f0040537          	lui	a0,0xf0040
    50ce:	3dc1                	jal	4f9e <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
    50d0:	4581                	li	a1,0
    50d2:	012107b7          	lui	a5,0x1210
    50d6:	02178513          	add	a0,a5,33 # 1210021 <__AXI_SRAM_segment_used_end__+0xee6d>
    50da:	874fd0ef          	jal	214e <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
    50de:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t) BOARD_CONSOLE_UART_BASE;
    50e0:	f00407b7          	lui	a5,0xf0040
    50e4:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
    50e6:	012107b7          	lui	a5,0x1210
    50ea:	02178513          	add	a0,a5,33 # 1210021 <__AXI_SRAM_segment_used_end__+0xee6d>
    50ee:	3669                	jal	4c78 <clock_get_frequency>
    50f0:	87aa                	mv	a5,a0
    50f2:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
    50f4:	67f1                	lui	a5,0x1c
    50f6:	20078793          	add	a5,a5,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
    50fa:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
    50fc:	878a                	mv	a5,sp
    50fe:	853e                	mv	a0,a5
    5100:	2f69                	jal	589a <console_init>
    5102:	87aa                	mv	a5,a0
    5104:	c391                	beqz	a5,5108 <.L48>

00005106 <.L47>:
        while (1) {
    5106:	a001                	j	5106 <.L47>

00005108 <.L48>:
}
    5108:	0001                	nop
    510a:	40f2                	lw	ra,28(sp)
    510c:	6105                	add	sp,sp,32
    510e:	8082                	ret

Disassembly of section .text.board_print_clock_freq:

00005110 <board_print_clock_freq>:
{
    5110:	1141                	add	sp,sp,-16
    5112:	c606                	sw	ra,12(sp)
    printf("==============================\n");
    5114:	0d420513          	add	a0,tp,212 # d4 <rom_xpi_nor_program+0x2>
    5118:	dcdfe0ef          	jal	3ee4 <printf>
    printf(" %s clock summary\n", BOARD_NAME);
    511c:	0f420593          	add	a1,tp,244 # f4 <rom_xpi_nor_program+0x22>
    5120:	10020513          	add	a0,tp,256 # 100 <rom_xpi_nor_program+0x2e>
    5124:	dc1fe0ef          	jal	3ee4 <printf>
    printf("==============================\n");
    5128:	0d420513          	add	a0,tp,212 # d4 <rom_xpi_nor_program+0x2>
    512c:	db9fe0ef          	jal	3ee4 <printf>
    printf("cpu0:\t\t %dHz\n", clock_get_frequency(clock_cpu0));
    5130:	4501                	li	a0,0
    5132:	3699                	jal	4c78 <clock_get_frequency>
    5134:	87aa                	mv	a5,a0
    5136:	85be                	mv	a1,a5
    5138:	11420513          	add	a0,tp,276 # 114 <rom_xpi_nor_auto_config>
    513c:	da9fe0ef          	jal	3ee4 <printf>
    printf("cpu1:\t\t %dHz\n", clock_get_frequency(clock_cpu1));
    5140:	000807b7          	lui	a5,0x80
    5144:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
    5148:	3e05                	jal	4c78 <clock_get_frequency>
    514a:	87aa                	mv	a5,a0
    514c:	85be                	mv	a1,a5
    514e:	12420513          	add	a0,tp,292 # 124 <rom_xpi_nor_auto_config+0x10>
    5152:	d93fe0ef          	jal	3ee4 <printf>
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb0));
    5156:	010007b7          	lui	a5,0x1000
    515a:	00478513          	add	a0,a5,4 # 1000004 <_flash_size+0x4>
    515e:	3e29                	jal	4c78 <clock_get_frequency>
    5160:	87aa                	mv	a5,a0
    5162:	85be                	mv	a1,a5
    5164:	13420513          	add	a0,tp,308 # 134 <rom_xpi_nor_auto_config+0x20>
    5168:	d7dfe0ef          	jal	3ee4 <printf>
    printf("axif:\t\t %dHz\n", clock_get_frequency(clock_axif));
    516c:	77c1                	lui	a5,0xffff0
    516e:	00578513          	add	a0,a5,5 # ffff0005 <__AHB_SRAM_segment_end__+0xfde8005>
    5172:	3619                	jal	4c78 <clock_get_frequency>
    5174:	87aa                	mv	a5,a0
    5176:	85be                	mv	a1,a5
    5178:	14420513          	add	a0,tp,324 # 144 <s_adc_clk_mux_node>
    517c:	d69fe0ef          	jal	3ee4 <printf>
    printf("axis:\t\t %dHz\n", clock_get_frequency(clock_axis));
    5180:	010107b7          	lui	a5,0x1010
    5184:	00678513          	add	a0,a5,6 # 1010006 <_flash_size+0x10006>
    5188:	3cc5                	jal	4c78 <clock_get_frequency>
    518a:	87aa                	mv	a5,a0
    518c:	85be                	mv	a1,a5
    518e:	15420513          	add	a0,tp,340 # 154 <__SEGGER_RTL_ipow10+0xc>
    5192:	d53fe0ef          	jal	3ee4 <printf>
    printf("axic:\t\t %dHz\n", clock_get_frequency(clock_axic));
    5196:	010207b7          	lui	a5,0x1020
    519a:	00778513          	add	a0,a5,7 # 1020007 <_flash_size+0x20007>
    519e:	3ce9                	jal	4c78 <clock_get_frequency>
    51a0:	87aa                	mv	a5,a0
    51a2:	85be                	mv	a1,a5
    51a4:	16420513          	add	a0,tp,356 # 164 <__SEGGER_RTL_ipow10+0x1c>
    51a8:	d3dfe0ef          	jal	3ee4 <printf>
    printf("axin:\t\t %dHz\n", clock_get_frequency(clock_axin));
    51ac:	010307b7          	lui	a5,0x1030
    51b0:	00878513          	add	a0,a5,8 # 1030008 <_flash_size+0x30008>
    51b4:	34d1                	jal	4c78 <clock_get_frequency>
    51b6:	87aa                	mv	a5,a0
    51b8:	85be                	mv	a1,a5
    51ba:	17420513          	add	a0,tp,372 # 174 <__SEGGER_RTL_ipow10+0x2c>
    51be:	d27fe0ef          	jal	3ee4 <printf>
    printf("xpi0:\t\t %dHz\n", clock_get_frequency(clock_xpi0));
    51c2:	016f07b7          	lui	a5,0x16f0
    51c6:	03f78513          	add	a0,a5,63 # 16f003f <__SHARE_RAM_segment_end__+0x3f003f>
    51ca:	347d                	jal	4c78 <clock_get_frequency>
    51cc:	87aa                	mv	a5,a0
    51ce:	85be                	mv	a1,a5
    51d0:	18420513          	add	a0,tp,388 # 184 <__SEGGER_RTL_ipow10+0x3c>
    51d4:	d11fe0ef          	jal	3ee4 <printf>
    printf("femc:\t\t %luHz\n", clock_get_frequency(clock_femc));
    51d8:	017007b7          	lui	a5,0x1700
    51dc:	04078513          	add	a0,a5,64 # 1700040 <__SHARE_RAM_segment_end__+0x400040>
    51e0:	3c61                	jal	4c78 <clock_get_frequency>
    51e2:	87aa                	mv	a5,a0
    51e4:	85be                	mv	a1,a5
    51e6:	19420513          	add	a0,tp,404 # 194 <__SEGGER_RTL_ipow10+0x4c>
    51ea:	cfbfe0ef          	jal	3ee4 <printf>
    printf("mchtmr0:\t %dHz\n", clock_get_frequency(clock_mchtmr0));
    51ee:	010607b7          	lui	a5,0x1060
    51f2:	00178513          	add	a0,a5,1 # 1060001 <_flash_size+0x60001>
    51f6:	3449                	jal	4c78 <clock_get_frequency>
    51f8:	87aa                	mv	a5,a0
    51fa:	85be                	mv	a1,a5
    51fc:	1a420513          	add	a0,tp,420 # 1a4 <__SEGGER_RTL_ipow10+0x5c>
    5200:	ce5fe0ef          	jal	3ee4 <printf>
    printf("mchtmr1:\t %dHz\n", clock_get_frequency(clock_mchtmr1));
    5204:	010807b7          	lui	a5,0x1080
    5208:	00378513          	add	a0,a5,3 # 1080003 <_flash_size+0x80003>
    520c:	34b5                	jal	4c78 <clock_get_frequency>
    520e:	87aa                	mv	a5,a0
    5210:	85be                	mv	a1,a5
    5212:	1b420513          	add	a0,tp,436 # 1b4 <__SEGGER_RTL_ipow10+0x6c>
    5216:	ccffe0ef          	jal	3ee4 <printf>
    printf("==============================\n");
    521a:	0d420513          	add	a0,tp,212 # d4 <rom_xpi_nor_program+0x2>
    521e:	cc7fe0ef          	jal	3ee4 <printf>
}
    5222:	0001                	nop
    5224:	40b2                	lw	ra,12(sp)
    5226:	0141                	add	sp,sp,16
    5228:	8082                	ret

Disassembly of section .text.board_ungate_mchtmr_at_lp_mode:

0000522a <board_ungate_mchtmr_at_lp_mode>:
{
    522a:	1141                	add	sp,sp,-16
    522c:	c606                	sw	ra,12(sp)
    sysctl_set_cpu_lp_mode(HPM_SYSCTL, BOARD_RUNNING_CORE, cpu_lp_mode_ungate_cpu_clock);
    522e:	4609                	li	a2,2
    5230:	4581                	li	a1,0
    5232:	f4000537          	lui	a0,0xf4000
    5236:	3d21                	jal	504e <sysctl_set_cpu_lp_mode>
}
    5238:	0001                	nop
    523a:	40b2                	lw	ra,12(sp)
    523c:	0141                	add	sp,sp,16
    523e:	8082                	ret

Disassembly of section .text.board_turnoff_rgb_led:

00005240 <board_turnoff_rgb_led>:
{
    5240:	1141                	add	sp,sp,-16
    uint32_t pad_ctl = IOC_PAD_PAD_CTL_PE_SET(1) | IOC_PAD_PAD_CTL_PS_SET(BOARD_LED_OFF_LEVEL);
    5242:	000207b7          	lui	a5,0x20
    5246:	c63e                	sw	a5,12(sp)
    HPM_IOC->PAD[IOC_PAD_PE14].FUNC_CTL = IOC_PE14_FUNC_CTL_GPIO_E_14;
    5248:	f40407b7          	lui	a5,0xf4040
    524c:	4607a823          	sw	zero,1136(a5) # f4040470 <__AHB_SRAM_segment_end__+0x3e38470>
    HPM_IOC->PAD[IOC_PAD_PE15].FUNC_CTL = IOC_PE15_FUNC_CTL_GPIO_E_15;
    5250:	f40407b7          	lui	a5,0xf4040
    5254:	4607ac23          	sw	zero,1144(a5) # f4040478 <__AHB_SRAM_segment_end__+0x3e38478>
    HPM_IOC->PAD[IOC_PAD_PE04].FUNC_CTL = IOC_PE04_FUNC_CTL_GPIO_E_04;
    5258:	f40407b7          	lui	a5,0xf4040
    525c:	4207a023          	sw	zero,1056(a5) # f4040420 <__AHB_SRAM_segment_end__+0x3e38420>
    HPM_IOC->PAD[IOC_PAD_PE14].PAD_CTL = pad_ctl;
    5260:	f40407b7          	lui	a5,0xf4040
    5264:	4732                	lw	a4,12(sp)
    5266:	46e7aa23          	sw	a4,1140(a5) # f4040474 <__AHB_SRAM_segment_end__+0x3e38474>
    HPM_IOC->PAD[IOC_PAD_PE15].PAD_CTL = pad_ctl;
    526a:	f40407b7          	lui	a5,0xf4040
    526e:	4732                	lw	a4,12(sp)
    5270:	46e7ae23          	sw	a4,1148(a5) # f404047c <__AHB_SRAM_segment_end__+0x3e3847c>
    HPM_IOC->PAD[IOC_PAD_PE04].PAD_CTL = pad_ctl;
    5274:	f40407b7          	lui	a5,0xf4040
    5278:	4732                	lw	a4,12(sp)
    527a:	42e7a223          	sw	a4,1060(a5) # f4040424 <__AHB_SRAM_segment_end__+0x3e38424>
}
    527e:	0001                	nop
    5280:	0141                	add	sp,sp,16
    5282:	8082                	ret

Disassembly of section .text.board_init:

00005284 <board_init>:
{
    5284:	1141                	add	sp,sp,-16
    5286:	c606                	sw	ra,12(sp)
    board_turnoff_rgb_led();
    5288:	3f65                	jal	5240 <board_turnoff_rgb_led>
    board_init_clock();
    528a:	adcfd0ef          	jal	2566 <board_init_clock>
    board_init_console();
    528e:	3d25                	jal	50c6 <board_init_console>
    board_init_pmp();
    5290:	8befd0ef          	jal	234e <board_init_pmp>
    board_print_clock_freq();
    5294:	3db5                	jal	5110 <board_print_clock_freq>
    board_print_banner();
    5296:	882fd0ef          	jal	2318 <board_print_banner>
}
    529a:	0001                	nop
    529c:	40b2                	lw	ra,12(sp)
    529e:	0141                	add	sp,sp,16
    52a0:	8082                	ret

Disassembly of section .text.uart_modem_config:

000052a2 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
    52a2:	1141                	add	sp,sp,-16
    52a4:	c62a                	sw	a0,12(sp)
    52a6:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
    52a8:	47a2                	lw	a5,8(sp)
    52aa:	0007c783          	lbu	a5,0(a5)
    52ae:	0796                	sll	a5,a5,0x5
    52b0:	0207f713          	and	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
    52b4:	47a2                	lw	a5,8(sp)
    52b6:	0017c783          	lbu	a5,1(a5)
    52ba:	0792                	sll	a5,a5,0x4
    52bc:	8bc1                	and	a5,a5,16
    52be:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
    52c0:	47a2                	lw	a5,8(sp)
    52c2:	0027c783          	lbu	a5,2(a5)
    52c6:	0017c793          	xor	a5,a5,1
    52ca:	0ff7f793          	zext.b	a5,a5
    52ce:	0786                	sll	a5,a5,0x1
    52d0:	8b89                	and	a5,a5,2
    52d2:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
    52d4:	47b2                	lw	a5,12(sp)
    52d6:	db98                	sw	a4,48(a5)
}
    52d8:	0001                	nop
    52da:	0141                	add	sp,sp,16
    52dc:	8082                	ret

Disassembly of section .text.uart_disable_irq:

000052de <uart_disable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be disabled
 */
static inline void uart_disable_irq(UART_Type *ptr, uint32_t irq_mask)
{
    52de:	1141                	add	sp,sp,-16
    52e0:	c62a                	sw	a0,12(sp)
    52e2:	c42e                	sw	a1,8(sp)
    ptr->IER &= ~irq_mask;
    52e4:	47b2                	lw	a5,12(sp)
    52e6:	53d8                	lw	a4,36(a5)
    52e8:	47a2                	lw	a5,8(sp)
    52ea:	fff7c793          	not	a5,a5
    52ee:	8f7d                	and	a4,a4,a5
    52f0:	47b2                	lw	a5,12(sp)
    52f2:	d3d8                	sw	a4,36(a5)
}
    52f4:	0001                	nop
    52f6:	0141                	add	sp,sp,16
    52f8:	8082                	ret

Disassembly of section .text.uart_enable_irq:

000052fa <uart_enable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be enabled
 */
static inline void uart_enable_irq(UART_Type *ptr, uint32_t irq_mask)
{
    52fa:	1141                	add	sp,sp,-16
    52fc:	c62a                	sw	a0,12(sp)
    52fe:	c42e                	sw	a1,8(sp)
    ptr->IER |= irq_mask;
    5300:	47b2                	lw	a5,12(sp)
    5302:	53d8                	lw	a4,36(a5)
    5304:	47a2                	lw	a5,8(sp)
    5306:	8f5d                	or	a4,a4,a5
    5308:	47b2                	lw	a5,12(sp)
    530a:	d3d8                	sw	a4,36(a5)
}
    530c:	0001                	nop
    530e:	0141                	add	sp,sp,16
    5310:	8082                	ret

Disassembly of section .text.uart_default_config:

00005312 <uart_default_config>:
{
    5312:	1141                	add	sp,sp,-16
    5314:	c62a                	sw	a0,12(sp)
    5316:	c42e                	sw	a1,8(sp)
    config->baudrate = 115200;
    5318:	47a2                	lw	a5,8(sp)
    531a:	6771                	lui	a4,0x1c
    531c:	20070713          	add	a4,a4,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
    5320:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
    5322:	47a2                	lw	a5,8(sp)
    5324:	470d                	li	a4,3
    5326:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
    532a:	47a2                	lw	a5,8(sp)
    532c:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
    5330:	47a2                	lw	a5,8(sp)
    5332:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
    5336:	47a2                	lw	a5,8(sp)
    5338:	4705                	li	a4,1
    533a:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
    533e:	47a2                	lw	a5,8(sp)
    5340:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
    5344:	47a2                	lw	a5,8(sp)
    5346:	477d                	li	a4,31
    5348:	00e785a3          	sb	a4,11(a5)
    config->dma_enable = false;
    534c:	47a2                	lw	a5,8(sp)
    534e:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
    5352:	47a2                	lw	a5,8(sp)
    5354:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
    5358:	47a2                	lw	a5,8(sp)
    535a:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
    535e:	47a2                	lw	a5,8(sp)
    5360:	000788a3          	sb	zero,17(a5)
    config->rxidle_config.detect_enable = false;
    5364:	47a2                	lw	a5,8(sp)
    5366:	00078923          	sb	zero,18(a5)
    config->rxidle_config.detect_irq_enable = false;
    536a:	47a2                	lw	a5,8(sp)
    536c:	000789a3          	sb	zero,19(a5)
    config->rxidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
    5370:	47a2                	lw	a5,8(sp)
    5372:	00078a23          	sb	zero,20(a5)
    config->rxidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
    5376:	47a2                	lw	a5,8(sp)
    5378:	4729                	li	a4,10
    537a:	00e78aa3          	sb	a4,21(a5)
    config->txidle_config.detect_enable = false;
    537e:	47a2                	lw	a5,8(sp)
    5380:	00078b23          	sb	zero,22(a5)
    config->txidle_config.detect_irq_enable = false;
    5384:	47a2                	lw	a5,8(sp)
    5386:	00078ba3          	sb	zero,23(a5)
    config->txidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
    538a:	47a2                	lw	a5,8(sp)
    538c:	00078c23          	sb	zero,24(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
    5390:	47a2                	lw	a5,8(sp)
    5392:	4729                	li	a4,10
    5394:	00e78ca3          	sb	a4,25(a5)
    config->rx_enable = true;
    5398:	47a2                	lw	a5,8(sp)
    539a:	4705                	li	a4,1
    539c:	00e78d23          	sb	a4,26(a5)
}
    53a0:	0001                	nop
    53a2:	0141                	add	sp,sp,16
    53a4:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

000053a6 <uart_calculate_baudrate>:
{
    53a6:	7119                	add	sp,sp,-128
    53a8:	de86                	sw	ra,124(sp)
    53aa:	dca2                	sw	s0,120(sp)
    53ac:	daa6                	sw	s1,116(sp)
    53ae:	d8ca                	sw	s2,112(sp)
    53b0:	d6ce                	sw	s3,108(sp)
    53b2:	d4d2                	sw	s4,104(sp)
    53b4:	d2d6                	sw	s5,100(sp)
    53b6:	d0da                	sw	s6,96(sp)
    53b8:	cede                	sw	s7,92(sp)
    53ba:	cce2                	sw	s8,88(sp)
    53bc:	cae6                	sw	s9,84(sp)
    53be:	c8ea                	sw	s10,80(sp)
    53c0:	c6ee                	sw	s11,76(sp)
    53c2:	ce2a                	sw	a0,28(sp)
    53c4:	cc2e                	sw	a1,24(sp)
    53c6:	ca32                	sw	a2,20(sp)
    53c8:	c836                	sw	a3,16(sp)
    if ((div_out == NULL) || (!freq) || (!baudrate)
    53ca:	46d2                	lw	a3,20(sp)
    53cc:	ca85                	beqz	a3,53fc <.L6>
    53ce:	46f2                	lw	a3,28(sp)
    53d0:	c695                	beqz	a3,53fc <.L6>
    53d2:	46e2                	lw	a3,24(sp)
    53d4:	c685                	beqz	a3,53fc <.L6>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
    53d6:	4662                	lw	a2,24(sp)
    53d8:	0c700693          	li	a3,199
    53dc:	02c6f063          	bgeu	a3,a2,53fc <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
    53e0:	46e2                	lw	a3,24(sp)
    53e2:	068e                	sll	a3,a3,0x3
    53e4:	4672                	lw	a2,28(sp)
    53e6:	00d66b63          	bltu	a2,a3,53fc <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
    53ea:	4672                	lw	a2,28(sp)
    53ec:	66c1                	lui	a3,0x10
    53ee:	16fd                	add	a3,a3,-1 # ffff <__AHB_SRAM_segment_size__+0x7fff>
    53f0:	02d65633          	divu	a2,a2,a3
    53f4:	46e2                	lw	a3,24(sp)
    53f6:	0696                	sll	a3,a3,0x5
    53f8:	00c6f463          	bgeu	a3,a2,5400 <.L7>

000053fc <.L6>:
        return 0;
    53fc:	4781                	li	a5,0
    53fe:	ac91                	j	5652 <.L8>

00005400 <.L7>:
    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
    5400:	46f2                	lw	a3,28(sp)
    5402:	8736                	mv	a4,a3
    5404:	4781                	li	a5,0
    5406:	3e800693          	li	a3,1000
    540a:	02d78633          	mul	a2,a5,a3
    540e:	4681                	li	a3,0
    5410:	02d706b3          	mul	a3,a4,a3
    5414:	9636                	add	a2,a2,a3
    5416:	3e800693          	li	a3,1000
    541a:	02d705b3          	mul	a1,a4,a3
    541e:	02d738b3          	mulhu	a7,a4,a3
    5422:	882e                	mv	a6,a1
    5424:	011607b3          	add	a5,a2,a7
    5428:	88be                	mv	a7,a5
    542a:	47e2                	lw	a5,24(sp)
    542c:	833e                	mv	t1,a5
    542e:	4381                	li	t2,0
    5430:	861a                	mv	a2,t1
    5432:	869e                	mv	a3,t2
    5434:	8542                	mv	a0,a6
    5436:	85c6                	mv	a1,a7
    5438:	8d4fe0ef          	jal	350c <__udivdi3>
    543c:	872a                	mv	a4,a0
    543e:	87ae                	mv	a5,a1
    5440:	d83a                	sw	a4,48(sp)
    5442:	da3e                	sw	a5,52(sp)
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
    5444:	47a1                	li	a5,8
    5446:	02f11f23          	sh	a5,62(sp)
    544a:	aaed                	j	5644 <.L9>

0000544c <.L20>:
        delta = 0;
    544c:	02011e23          	sh	zero,60(sp)
        div = (uint16_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
    5450:	03e15703          	lhu	a4,62(sp)
    5454:	87ba                	mv	a5,a4
    5456:	078a                	sll	a5,a5,0x2
    5458:	97ba                	add	a5,a5,a4
    545a:	00279713          	sll	a4,a5,0x2
    545e:	97ba                	add	a5,a5,a4
    5460:	00279713          	sll	a4,a5,0x2
    5464:	97ba                	add	a5,a5,a4
    5466:	078a                	sll	a5,a5,0x2
    5468:	843e                	mv	s0,a5
    546a:	4481                	li	s1,0
    546c:	5642                	lw	a2,48(sp)
    546e:	56d2                	lw	a3,52(sp)
    5470:	00c40733          	add	a4,s0,a2
    5474:	85ba                	mv	a1,a4
    5476:	0085b5b3          	sltu	a1,a1,s0
    547a:	00d487b3          	add	a5,s1,a3
    547e:	00f586b3          	add	a3,a1,a5
    5482:	87b6                	mv	a5,a3
    5484:	853a                	mv	a0,a4
    5486:	85be                	mv	a1,a5
    5488:	03e15703          	lhu	a4,62(sp)
    548c:	87ba                	mv	a5,a4
    548e:	078a                	sll	a5,a5,0x2
    5490:	97ba                	add	a5,a5,a4
    5492:	00279713          	sll	a4,a5,0x2
    5496:	97ba                	add	a5,a5,a4
    5498:	00279713          	sll	a4,a5,0x2
    549c:	97ba                	add	a5,a5,a4
    549e:	078e                	sll	a5,a5,0x3
    54a0:	8d3e                	mv	s10,a5
    54a2:	4d81                	li	s11,0
    54a4:	866a                	mv	a2,s10
    54a6:	86ee                	mv	a3,s11
    54a8:	864fe0ef          	jal	350c <__udivdi3>
    54ac:	872a                	mv	a4,a0
    54ae:	87ae                	mv	a5,a1
    54b0:	02e11723          	sh	a4,46(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN) {
    54b4:	02e15783          	lhu	a5,46(sp)
    54b8:	16078e63          	beqz	a5,5634 <.L23>
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
    54bc:	02e15703          	lhu	a4,46(sp)
    54c0:	03e15783          	lhu	a5,62(sp)
    54c4:	02f707b3          	mul	a5,a4,a5
    54c8:	873e                	mv	a4,a5
    54ca:	87ba                	mv	a5,a4
    54cc:	078a                	sll	a5,a5,0x2
    54ce:	97ba                	add	a5,a5,a4
    54d0:	00279713          	sll	a4,a5,0x2
    54d4:	97ba                	add	a5,a5,a4
    54d6:	00279713          	sll	a4,a5,0x2
    54da:	97ba                	add	a5,a5,a4
    54dc:	078e                	sll	a5,a5,0x3
    54de:	8b3e                	mv	s6,a5
    54e0:	4b81                	li	s7,0
    54e2:	57d2                	lw	a5,52(sp)
    54e4:	875e                	mv	a4,s7
    54e6:	00e7ea63          	bltu	a5,a4,54fa <.L21>
    54ea:	57d2                	lw	a5,52(sp)
    54ec:	875e                	mv	a4,s7
    54ee:	06e79163          	bne	a5,a4,5550 <.L12>
    54f2:	57c2                	lw	a5,48(sp)
    54f4:	875a                	mv	a4,s6
    54f6:	04e7fd63          	bgeu	a5,a4,5550 <.L12>

000054fa <.L21>:
            delta = (uint16_t)(((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp) / HPM_UART_BAUDRATE_SCALE);
    54fa:	02e15703          	lhu	a4,46(sp)
    54fe:	03e15783          	lhu	a5,62(sp)
    5502:	02f707b3          	mul	a5,a4,a5
    5506:	873e                	mv	a4,a5
    5508:	87ba                	mv	a5,a4
    550a:	078a                	sll	a5,a5,0x2
    550c:	97ba                	add	a5,a5,a4
    550e:	00279713          	sll	a4,a5,0x2
    5512:	97ba                	add	a5,a5,a4
    5514:	00279713          	sll	a4,a5,0x2
    5518:	97ba                	add	a5,a5,a4
    551a:	078e                	sll	a5,a5,0x3
    551c:	893e                	mv	s2,a5
    551e:	4981                	li	s3,0
    5520:	5642                	lw	a2,48(sp)
    5522:	56d2                	lw	a3,52(sp)
    5524:	40c90733          	sub	a4,s2,a2
    5528:	85ba                	mv	a1,a4
    552a:	00b935b3          	sltu	a1,s2,a1
    552e:	40d987b3          	sub	a5,s3,a3
    5532:	40b786b3          	sub	a3,a5,a1
    5536:	87b6                	mv	a5,a3
    5538:	3e800613          	li	a2,1000
    553c:	4681                	li	a3,0
    553e:	853a                	mv	a0,a4
    5540:	85be                	mv	a1,a5
    5542:	fcbfd0ef          	jal	350c <__udivdi3>
    5546:	872a                	mv	a4,a0
    5548:	87ae                	mv	a5,a1
    554a:	02e11e23          	sh	a4,60(sp)
    554e:	a051                	j	55d2 <.L14>

00005550 <.L12>:
        } else if (div * osc < tmp) {
    5550:	02e15703          	lhu	a4,46(sp)
    5554:	03e15783          	lhu	a5,62(sp)
    5558:	02f707b3          	mul	a5,a4,a5
    555c:	8c3e                	mv	s8,a5
    555e:	87fd                	sra	a5,a5,0x1f
    5560:	8cbe                	mv	s9,a5
    5562:	57d2                	lw	a5,52(sp)
    5564:	8766                	mv	a4,s9
    5566:	00f76a63          	bltu	a4,a5,557a <.L22>
    556a:	57d2                	lw	a5,52(sp)
    556c:	8766                	mv	a4,s9
    556e:	06e79263          	bne	a5,a4,55d2 <.L14>
    5572:	57c2                	lw	a5,48(sp)
    5574:	8762                	mv	a4,s8
    5576:	04f77e63          	bgeu	a4,a5,55d2 <.L14>

0000557a <.L22>:
            delta = (uint16_t)((tmp - (div * osc * HPM_UART_BAUDRATE_SCALE)) / HPM_UART_BAUDRATE_SCALE);
    557a:	02e15703          	lhu	a4,46(sp)
    557e:	03e15783          	lhu	a5,62(sp)
    5582:	02f707b3          	mul	a5,a4,a5
    5586:	873e                	mv	a4,a5
    5588:	87ba                	mv	a5,a4
    558a:	078a                	sll	a5,a5,0x2
    558c:	97ba                	add	a5,a5,a4
    558e:	00279713          	sll	a4,a5,0x2
    5592:	97ba                	add	a5,a5,a4
    5594:	00279713          	sll	a4,a5,0x2
    5598:	97ba                	add	a5,a5,a4
    559a:	078e                	sll	a5,a5,0x3
    559c:	8a3e                	mv	s4,a5
    559e:	4a81                	li	s5,0
    55a0:	5742                	lw	a4,48(sp)
    55a2:	57d2                	lw	a5,52(sp)
    55a4:	41470633          	sub	a2,a4,s4
    55a8:	85b2                	mv	a1,a2
    55aa:	00b735b3          	sltu	a1,a4,a1
    55ae:	415786b3          	sub	a3,a5,s5
    55b2:	40b687b3          	sub	a5,a3,a1
    55b6:	86be                	mv	a3,a5
    55b8:	8732                	mv	a4,a2
    55ba:	87b6                	mv	a5,a3
    55bc:	3e800613          	li	a2,1000
    55c0:	4681                	li	a3,0
    55c2:	853a                	mv	a0,a4
    55c4:	85be                	mv	a1,a5
    55c6:	f47fd0ef          	jal	350c <__udivdi3>
    55ca:	872a                	mv	a4,a0
    55cc:	87ae                	mv	a5,a1
    55ce:	02e11e23          	sh	a4,60(sp)

000055d2 <.L14>:
        if (delta && (((delta * 100 * HPM_UART_BAUDRATE_SCALE) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
    55d2:	03c15783          	lhu	a5,60(sp)
    55d6:	cb8d                	beqz	a5,5608 <.L16>
    55d8:	03c15703          	lhu	a4,60(sp)
    55dc:	67e1                	lui	a5,0x18
    55de:	6a078793          	add	a5,a5,1696 # 186a0 <__AHB_SRAM_segment_size__+0x106a0>
    55e2:	02f707b3          	mul	a5,a4,a5
    55e6:	c43e                	sw	a5,8(sp)
    55e8:	c602                	sw	zero,12(sp)
    55ea:	5642                	lw	a2,48(sp)
    55ec:	56d2                	lw	a3,52(sp)
    55ee:	4522                	lw	a0,8(sp)
    55f0:	45b2                	lw	a1,12(sp)
    55f2:	f1bfd0ef          	jal	350c <__udivdi3>
    55f6:	872a                	mv	a4,a0
    55f8:	87ae                	mv	a5,a1
    55fa:	86be                	mv	a3,a5
    55fc:	ee95                	bnez	a3,5638 <.L24>
    55fe:	86be                	mv	a3,a5
    5600:	e681                	bnez	a3,5608 <.L16>
    5602:	478d                	li	a5,3
    5604:	02e7ea63          	bltu	a5,a4,5638 <.L24>

00005608 <.L16>:
            *div_out = div;
    5608:	47d2                	lw	a5,20(sp)
    560a:	02e15703          	lhu	a4,46(sp)
    560e:	00e79023          	sh	a4,0(a5)
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
    5612:	03e15703          	lhu	a4,62(sp)
    5616:	02000793          	li	a5,32
    561a:	00f70763          	beq	a4,a5,5628 <.L18>
    561e:	03e15783          	lhu	a5,62(sp)
    5622:	0ff7f793          	zext.b	a5,a5
    5626:	a011                	j	562a <.L19>

00005628 <.L18>:
    5628:	4781                	li	a5,0

0000562a <.L19>:
    562a:	4742                	lw	a4,16(sp)
    562c:	00f70023          	sb	a5,0(a4)
            return true;
    5630:	4785                	li	a5,1
    5632:	a005                	j	5652 <.L8>

00005634 <.L23>:
            continue;
    5634:	0001                	nop
    5636:	a011                	j	563a <.L11>

00005638 <.L24>:
            continue;
    5638:	0001                	nop

0000563a <.L11>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
    563a:	03e15783          	lhu	a5,62(sp)
    563e:	0789                	add	a5,a5,2
    5640:	02f11f23          	sh	a5,62(sp)

00005644 <.L9>:
    5644:	03e15703          	lhu	a4,62(sp)
    5648:	02000793          	li	a5,32
    564c:	e0e7f0e3          	bgeu	a5,a4,544c <.L20>
    return false;
    5650:	4781                	li	a5,0

00005652 <.L8>:
}
    5652:	853e                	mv	a0,a5
    5654:	50f6                	lw	ra,124(sp)
    5656:	5466                	lw	s0,120(sp)
    5658:	54d6                	lw	s1,116(sp)
    565a:	5946                	lw	s2,112(sp)
    565c:	59b6                	lw	s3,108(sp)
    565e:	5a26                	lw	s4,104(sp)
    5660:	5a96                	lw	s5,100(sp)
    5662:	5b06                	lw	s6,96(sp)
    5664:	4bf6                	lw	s7,92(sp)
    5666:	4c66                	lw	s8,88(sp)
    5668:	4cd6                	lw	s9,84(sp)
    566a:	4d46                	lw	s10,80(sp)
    566c:	4db6                	lw	s11,76(sp)
    566e:	6109                	add	sp,sp,128
    5670:	8082                	ret

Disassembly of section .text.uart_flush:

00005672 <uart_flush>:
{
    5672:	1101                	add	sp,sp,-32
    5674:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
    5676:	ce02                	sw	zero,28(sp)
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
    5678:	a811                	j	568c <.L59>

0000567a <.L62>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
    567a:	4772                	lw	a4,28(sp)
    567c:	6785                	lui	a5,0x1
    567e:	38878793          	add	a5,a5,904 # 1388 <.L45+0x60>
    5682:	00e7eb63          	bltu	a5,a4,5698 <.L65>
        retry++;
    5686:	47f2                	lw	a5,28(sp)
    5688:	0785                	add	a5,a5,1
    568a:	ce3e                	sw	a5,28(sp)

0000568c <.L59>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
    568c:	47b2                	lw	a5,12(sp)
    568e:	5bdc                	lw	a5,52(a5)
    5690:	0407f793          	and	a5,a5,64
    5694:	d3fd                	beqz	a5,567a <.L62>
    5696:	a011                	j	569a <.L61>

00005698 <.L65>:
            break;
    5698:	0001                	nop

0000569a <.L61>:
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
    569a:	4772                	lw	a4,28(sp)
    569c:	6785                	lui	a5,0x1
    569e:	38878793          	add	a5,a5,904 # 1388 <.L45+0x60>
    56a2:	00e7f463          	bgeu	a5,a4,56aa <.L63>
        return status_timeout;
    56a6:	478d                	li	a5,3
    56a8:	a011                	j	56ac <.L64>

000056aa <.L63>:
    return status_success;
    56aa:	4781                	li	a5,0

000056ac <.L64>:
}
    56ac:	853e                	mv	a0,a5
    56ae:	6105                	add	sp,sp,32
    56b0:	8082                	ret

Disassembly of section .text.uart_init_rxline_idle_detection:

000056b2 <uart_init_rxline_idle_detection>:
{
    56b2:	1101                	add	sp,sp,-32
    56b4:	ce06                	sw	ra,28(sp)
    56b6:	c62a                	sw	a0,12(sp)
    56b8:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_RX_IDLE_EN_MASK
    56ba:	47b2                	lw	a5,12(sp)
    56bc:	43dc                	lw	a5,4(a5)
    56be:	c007f713          	and	a4,a5,-1024
    56c2:	47b2                	lw	a5,12(sp)
    56c4:	c3d8                	sw	a4,4(a5)
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
    56c6:	47b2                	lw	a5,12(sp)
    56c8:	43d8                	lw	a4,4(a5)
    56ca:	00814783          	lbu	a5,8(sp)
    56ce:	07a2                	sll	a5,a5,0x8
    56d0:	1007f793          	and	a5,a5,256
                    | UART_IDLE_CFG_RX_IDLE_THR_SET(rxidle_config.threshold)
    56d4:	00b14683          	lbu	a3,11(sp)
    56d8:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_RX_IDLE_COND_SET(rxidle_config.idle_cond);
    56da:	00a14783          	lbu	a5,10(sp)
    56de:	07a6                	sll	a5,a5,0x9
    56e0:	2007f793          	and	a5,a5,512
    56e4:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
    56e6:	8f5d                	or	a4,a4,a5
    56e8:	47b2                	lw	a5,12(sp)
    56ea:	c3d8                	sw	a4,4(a5)
    if (rxidle_config.detect_irq_enable) {
    56ec:	00914783          	lbu	a5,9(sp)
    56f0:	c791                	beqz	a5,56fc <.L92>
        uart_enable_irq(ptr, uart_intr_rx_line_idle);
    56f2:	800005b7          	lui	a1,0x80000
    56f6:	4532                	lw	a0,12(sp)
    56f8:	3109                	jal	52fa <uart_enable_irq>
    56fa:	a029                	j	5704 <.L93>

000056fc <.L92>:
        uart_disable_irq(ptr, uart_intr_rx_line_idle);
    56fc:	800005b7          	lui	a1,0x80000
    5700:	4532                	lw	a0,12(sp)
    5702:	3ef1                	jal	52de <uart_disable_irq>

00005704 <.L93>:
    return status_success;
    5704:	4781                	li	a5,0
}
    5706:	853e                	mv	a0,a5
    5708:	40f2                	lw	ra,28(sp)
    570a:	6105                	add	sp,sp,32
    570c:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

0000570e <write_pmp_cfg>:
{
    570e:	1141                	add	sp,sp,-16
    5710:	c62a                	sw	a0,12(sp)
    5712:	c42e                	sw	a1,8(sp)
    switch (idx) {
    5714:	4722                	lw	a4,8(sp)
    5716:	478d                	li	a5,3
    5718:	04f70163          	beq	a4,a5,575a <.L11>
    571c:	4722                	lw	a4,8(sp)
    571e:	478d                	li	a5,3
    5720:	04e7e163          	bltu	a5,a4,5762 <.L17>
    5724:	4722                	lw	a4,8(sp)
    5726:	4789                	li	a5,2
    5728:	02f70563          	beq	a4,a5,5752 <.L13>
    572c:	4722                	lw	a4,8(sp)
    572e:	4789                	li	a5,2
    5730:	02e7e963          	bltu	a5,a4,5762 <.L17>
    5734:	47a2                	lw	a5,8(sp)
    5736:	c791                	beqz	a5,5742 <.L14>
    5738:	4722                	lw	a4,8(sp)
    573a:	4785                	li	a5,1
    573c:	00f70763          	beq	a4,a5,574a <.L15>
        break;
    5740:	a00d                	j	5762 <.L17>

00005742 <.L14>:
        write_csr(CSR_PMPCFG0, value);
    5742:	47b2                	lw	a5,12(sp)
    5744:	3a079073          	csrw	pmpcfg0,a5
        break;
    5748:	a831                	j	5764 <.L16>

0000574a <.L15>:
        write_csr(CSR_PMPCFG1, value);
    574a:	47b2                	lw	a5,12(sp)
    574c:	3a179073          	csrw	pmpcfg1,a5
        break;
    5750:	a811                	j	5764 <.L16>

00005752 <.L13>:
        write_csr(CSR_PMPCFG2, value);
    5752:	47b2                	lw	a5,12(sp)
    5754:	3a279073          	csrw	pmpcfg2,a5
        break;
    5758:	a031                	j	5764 <.L16>

0000575a <.L11>:
        write_csr(CSR_PMPCFG3, value);
    575a:	47b2                	lw	a5,12(sp)
    575c:	3a379073          	csrw	pmpcfg3,a5
        break;
    5760:	a011                	j	5764 <.L16>

00005762 <.L17>:
        break;
    5762:	0001                	nop

00005764 <.L16>:
}
    5764:	0001                	nop
    5766:	0141                	add	sp,sp,16
    5768:	8082                	ret

Disassembly of section .text.write_pma_cfg:

0000576a <write_pma_cfg>:
{
    576a:	1141                	add	sp,sp,-16
    576c:	c62a                	sw	a0,12(sp)
    576e:	c42e                	sw	a1,8(sp)
    switch (idx) {
    5770:	4722                	lw	a4,8(sp)
    5772:	478d                	li	a5,3
    5774:	04f70163          	beq	a4,a5,57b6 <.L81>
    5778:	4722                	lw	a4,8(sp)
    577a:	478d                	li	a5,3
    577c:	04e7e163          	bltu	a5,a4,57be <.L87>
    5780:	4722                	lw	a4,8(sp)
    5782:	4789                	li	a5,2
    5784:	02f70563          	beq	a4,a5,57ae <.L83>
    5788:	4722                	lw	a4,8(sp)
    578a:	4789                	li	a5,2
    578c:	02e7e963          	bltu	a5,a4,57be <.L87>
    5790:	47a2                	lw	a5,8(sp)
    5792:	c791                	beqz	a5,579e <.L84>
    5794:	4722                	lw	a4,8(sp)
    5796:	4785                	li	a5,1
    5798:	00f70763          	beq	a4,a5,57a6 <.L85>
        break;
    579c:	a00d                	j	57be <.L87>

0000579e <.L84>:
        write_csr(CSR_PMACFG0, value);
    579e:	47b2                	lw	a5,12(sp)
    57a0:	bc079073          	csrw	0xbc0,a5
        break;
    57a4:	a831                	j	57c0 <.L86>

000057a6 <.L85>:
        write_csr(CSR_PMACFG1, value);
    57a6:	47b2                	lw	a5,12(sp)
    57a8:	bc179073          	csrw	0xbc1,a5
        break;
    57ac:	a811                	j	57c0 <.L86>

000057ae <.L83>:
        write_csr(CSR_PMACFG2, value);
    57ae:	47b2                	lw	a5,12(sp)
    57b0:	bc279073          	csrw	0xbc2,a5
        break;
    57b4:	a031                	j	57c0 <.L86>

000057b6 <.L81>:
        write_csr(CSR_PMACFG3, value);
    57b6:	47b2                	lw	a5,12(sp)
    57b8:	bc379073          	csrw	0xbc3,a5
        break;
    57bc:	a011                	j	57c0 <.L86>

000057be <.L87>:
        break;
    57be:	0001                	nop

000057c0 <.L86>:
}
    57c0:	0001                	nop
    57c2:	0141                	add	sp,sp,16
    57c4:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_postdiv_freq_in_hz:

000057c6 <pllctlv2_get_pll_postdiv_freq_in_hz>:

uint32_t pllctlv2_get_pll_postdiv_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
    57c6:	7179                	add	sp,sp,-48
    57c8:	d606                	sw	ra,44(sp)
    57ca:	c62a                	sw	a0,12(sp)
    57cc:	87ae                	mv	a5,a1
    57ce:	8732                	mv	a4,a2
    57d0:	00f105a3          	sb	a5,11(sp)
    57d4:	87ba                	mv	a5,a4
    57d6:	00f10523          	sb	a5,10(sp)
    uint32_t postdiv_freq = 0;
    57da:	ce02                	sw	zero,28(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
    57dc:	47b2                	lw	a5,12(sp)
    57de:	c7ad                	beqz	a5,5848 <.L43>
    57e0:	00b14703          	lbu	a4,11(sp)
    57e4:	4789                	li	a5,2
    57e6:	06e7e163          	bltu	a5,a4,5848 <.L43>

000057ea <.LBB4>:
        uint32_t postdiv = PLLCTLV2_PLL_DIV_DIV_GET(ptr->PLL[pll].DIV[clk]);
    57ea:	00b14683          	lbu	a3,11(sp)
    57ee:	00a14783          	lbu	a5,10(sp)
    57f2:	4732                	lw	a4,12(sp)
    57f4:	0696                	sll	a3,a3,0x5
    57f6:	97b6                	add	a5,a5,a3
    57f8:	03078793          	add	a5,a5,48
    57fc:	078a                	sll	a5,a5,0x2
    57fe:	97ba                	add	a5,a5,a4
    5800:	439c                	lw	a5,0(a5)
    5802:	03f7f793          	and	a5,a5,63
    5806:	cc3e                	sw	a5,24(sp)
        uint32_t pll_freq = pllctlv2_get_pll_freq_in_hz(ptr, pll);
    5808:	00b14783          	lbu	a5,11(sp)
    580c:	85be                	mv	a1,a5
    580e:	4532                	lw	a0,12(sp)
    5810:	d60fd0ef          	jal	2d70 <pllctlv2_get_pll_freq_in_hz>
    5814:	ca2a                	sw	a0,20(sp)
        postdiv_freq = (uint32_t) (pll_freq / (100 + postdiv * 100 / 5U) * 100);
    5816:	4762                	lw	a4,24(sp)
    5818:	87ba                	mv	a5,a4
    581a:	078a                	sll	a5,a5,0x2
    581c:	97ba                	add	a5,a5,a4
    581e:	00279713          	sll	a4,a5,0x2
    5822:	97ba                	add	a5,a5,a4
    5824:	078a                	sll	a5,a5,0x2
    5826:	873e                	mv	a4,a5
    5828:	4795                	li	a5,5
    582a:	02f757b3          	divu	a5,a4,a5
    582e:	06478793          	add	a5,a5,100
    5832:	4752                	lw	a4,20(sp)
    5834:	02f75733          	divu	a4,a4,a5
    5838:	87ba                	mv	a5,a4
    583a:	078a                	sll	a5,a5,0x2
    583c:	97ba                	add	a5,a5,a4
    583e:	00279713          	sll	a4,a5,0x2
    5842:	97ba                	add	a5,a5,a4
    5844:	078a                	sll	a5,a5,0x2
    5846:	ce3e                	sw	a5,28(sp)

00005848 <.L43>:
    }

    return postdiv_freq;
    5848:	47f2                	lw	a5,28(sp)
}
    584a:	853e                	mv	a0,a5
    584c:	50b2                	lw	ra,44(sp)
    584e:	6145                	add	sp,sp,48
    5850:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

00005852 <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
    5852:	1101                	add	sp,sp,-32
    5854:	c62a                	sw	a0,12(sp)
    5856:	87ae                	mv	a5,a1
    5858:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
    585c:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
    585e:	00a15703          	lhu	a4,10(sp)
    5862:	25700793          	li	a5,599
    5866:	00e7f863          	bgeu	a5,a4,5876 <.L26>
    586a:	00a15703          	lhu	a4,10(sp)
    586e:	55f00793          	li	a5,1375
    5872:	00e7f463          	bgeu	a5,a4,587a <.L27>

00005876 <.L26>:
        return status_invalid_argument;
    5876:	4789                	li	a5,2
    5878:	a831                	j	5894 <.L28>

0000587a <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
    587a:	47b2                	lw	a5,12(sp)
    587c:	4b98                	lw	a4,16(a5)
    587e:	77fd                	lui	a5,0xfffff
    5880:	8f7d                	and	a4,a4,a5
    5882:	00a15683          	lhu	a3,10(sp)
    5886:	6785                	lui	a5,0x1
    5888:	17fd                	add	a5,a5,-1 # fff <__SEGGER_RTL_Moeller_inverse_lut+0x11b>
    588a:	8ff5                	and	a5,a5,a3
    588c:	8f5d                	or	a4,a4,a5
    588e:	47b2                	lw	a5,12(sp)
    5890:	cb98                	sw	a4,16(a5)
    return stat;
    5892:	47f2                	lw	a5,28(sp)

00005894 <.L28>:
}
    5894:	853e                	mv	a0,a5
    5896:	6105                	add	sp,sp,32
    5898:	8082                	ret

Disassembly of section .text.console_init:

0000589a <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
    589a:	7139                	add	sp,sp,-64
    589c:	de06                	sw	ra,60(sp)
    589e:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
    58a0:	4785                	li	a5,1
    58a2:	d63e                	sw	a5,44(sp)

    if (cfg->type == CONSOLE_TYPE_UART) {
    58a4:	47b2                	lw	a5,12(sp)
    58a6:	439c                	lw	a5,0(a5)
    58a8:	e7b9                	bnez	a5,58f6 <.L2>

000058aa <.LBB2>:
        uart_config_t config = {0};
    58aa:	c802                	sw	zero,16(sp)
    58ac:	ca02                	sw	zero,20(sp)
    58ae:	cc02                	sw	zero,24(sp)
    58b0:	ce02                	sw	zero,28(sp)
    58b2:	d002                	sw	zero,32(sp)
    58b4:	d202                	sw	zero,36(sp)
    58b6:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
    58b8:	47b2                	lw	a5,12(sp)
    58ba:	43dc                	lw	a5,4(a5)
    58bc:	873e                	mv	a4,a5
    58be:	081c                	add	a5,sp,16
    58c0:	85be                	mv	a1,a5
    58c2:	853a                	mv	a0,a4
    58c4:	34b9                	jal	5312 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
    58c6:	47b2                	lw	a5,12(sp)
    58c8:	479c                	lw	a5,8(a5)
    58ca:	c83e                	sw	a5,16(sp)
        config.baudrate = cfg->baudrate;
    58cc:	47b2                	lw	a5,12(sp)
    58ce:	47dc                	lw	a5,12(a5)
    58d0:	ca3e                	sw	a5,20(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
    58d2:	47b2                	lw	a5,12(sp)
    58d4:	43dc                	lw	a5,4(a5)
    58d6:	873e                	mv	a4,a5
    58d8:	081c                	add	a5,sp,16
    58da:	85be                	mv	a1,a5
    58dc:	853a                	mv	a0,a4
    58de:	f09fc0ef          	jal	27e6 <uart_init>
    58e2:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
    58e4:	57b2                	lw	a5,44(sp)
    58e6:	eb81                	bnez	a5,58f6 <.L2>
            g_console_uart = (UART_Type *)cfg->base;
    58e8:	47b2                	lw	a5,12(sp)
    58ea:	43dc                	lw	a5,4(a5)
    58ec:	873e                	mv	a4,a5
    58ee:	012017b7          	lui	a5,0x1201
    58f2:	18e7ae23          	sw	a4,412(a5) # 120119c <g_console_uart>

000058f6 <.L2>:
        }
    }

    return stat;
    58f6:	57b2                	lw	a5,44(sp)
}
    58f8:	853e                	mv	a0,a5
    58fa:	50f2                	lw	ra,60(sp)
    58fc:	6121                	add	sp,sp,64
    58fe:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

00005900 <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
    5900:	7179                	add	sp,sp,-48
    5902:	d606                	sw	ra,44(sp)
    5904:	c62a                	sw	a0,12(sp)
    5906:	c42e                	sw	a1,8(sp)
    5908:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
    590a:	ce02                	sw	zero,28(sp)
    590c:	a0b9                	j	595a <.L13>

0000590e <.L17>:
        if (data[count] == '\n') {
    590e:	4722                	lw	a4,8(sp)
    5910:	47f2                	lw	a5,28(sp)
    5912:	97ba                	add	a5,a5,a4
    5914:	0007c703          	lbu	a4,0(a5)
    5918:	47a9                	li	a5,10
    591a:	00f71d63          	bne	a4,a5,5934 <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
    591e:	0001                	nop

00005920 <.L15>:
    5920:	012017b7          	lui	a5,0x1201
    5924:	19c7a783          	lw	a5,412(a5) # 120119c <g_console_uart>
    5928:	45b5                	li	a1,13
    592a:	853e                	mv	a0,a5
    592c:	886fd0ef          	jal	29b2 <uart_send_byte>
    5930:	87aa                	mv	a5,a0
    5932:	f7fd                	bnez	a5,5920 <.L15>

00005934 <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
    5934:	0001                	nop

00005936 <.L16>:
    5936:	012017b7          	lui	a5,0x1201
    593a:	19c7a683          	lw	a3,412(a5) # 120119c <g_console_uart>
    593e:	4722                	lw	a4,8(sp)
    5940:	47f2                	lw	a5,28(sp)
    5942:	97ba                	add	a5,a5,a4
    5944:	0007c783          	lbu	a5,0(a5)
    5948:	85be                	mv	a1,a5
    594a:	8536                	mv	a0,a3
    594c:	866fd0ef          	jal	29b2 <uart_send_byte>
    5950:	87aa                	mv	a5,a0
    5952:	f3f5                	bnez	a5,5936 <.L16>
    for (count = 0; count < size; count++) {
    5954:	47f2                	lw	a5,28(sp)
    5956:	0785                	add	a5,a5,1
    5958:	ce3e                	sw	a5,28(sp)

0000595a <.L13>:
    595a:	4772                	lw	a4,28(sp)
    595c:	4792                	lw	a5,4(sp)
    595e:	faf768e3          	bltu	a4,a5,590e <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
    5962:	0001                	nop

00005964 <.L18>:
    5964:	012017b7          	lui	a5,0x1201
    5968:	19c7a783          	lw	a5,412(a5) # 120119c <g_console_uart>
    596c:	853e                	mv	a0,a5
    596e:	3311                	jal	5672 <uart_flush>
    5970:	87aa                	mv	a5,a0
    5972:	fbed                	bnez	a5,5964 <.L18>
    }
    return count;
    5974:	47f2                	lw	a5,28(sp)

}
    5976:	853e                	mv	a0,a5
    5978:	50b2                	lw	ra,44(sp)
    597a:	6145                	add	sp,sp,48
    597c:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

0000597e <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
    597e:	1141                	add	sp,sp,-16
    5980:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
    5982:	4781                	li	a5,0
}
    5984:	853e                	mv	a0,a5
    5986:	0141                	add	sp,sp,16
    5988:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

0000598a <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
    598a:	1141                	add	sp,sp,-16
    598c:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
    598e:	4785                	li	a5,1
}
    5990:	853e                	mv	a0,a5
    5992:	0141                	add	sp,sp,16
    5994:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

00005996 <__SEGGER_RTL_puts_no_nl>:
    5996:	1101                	add	sp,sp,-32
    5998:	012017b7          	lui	a5,0x1201
    599c:	cc22                	sw	s0,24(sp)
    599e:	1b07a403          	lw	s0,432(a5) # 12011b0 <stdout>
    59a2:	ce06                	sw	ra,28(sp)
    59a4:	c62a                	sw	a0,12(sp)
    59a6:	2dd1                	jal	607a <strlen>
    59a8:	862a                	mv	a2,a0
    59aa:	8522                	mv	a0,s0
    59ac:	4462                	lw	s0,24(sp)
    59ae:	45b2                	lw	a1,12(sp)
    59b0:	40f2                	lw	ra,28(sp)
    59b2:	6105                	add	sp,sp,32
    59b4:	b7b1                	j	5900 <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.signal:

000059b6 <signal>:
    59b6:	4795                	li	a5,5
    59b8:	02a7e463          	bltu	a5,a0,59e0 <.L18>
    59bc:	01201737          	lui	a4,0x1201
    59c0:	17870693          	add	a3,a4,376 # 1201178 <__SEGGER_RTL_aSigTab>
    59c4:	00251793          	sll	a5,a0,0x2
    59c8:	96be                	add	a3,a3,a5
    59ca:	4288                	lw	a0,0(a3)
    59cc:	17870713          	add	a4,a4,376
    59d0:	e509                	bnez	a0,59da <.L17>
    59d2:	00000537          	lui	a0,0x0
    59d6:	14250513          	add	a0,a0,322 # 142 <__SEGGER_RTL_SIGNAL_SIG_DFL>

000059da <.L17>:
    59da:	973e                	add	a4,a4,a5
    59dc:	c30c                	sw	a1,0(a4)
    59de:	8082                	ret

000059e0 <.L18>:
    59e0:	a8a18513          	add	a0,gp,-1398 # 3fa <__SEGGER_RTL_SIGNAL_SIG_ERR>
    59e4:	8082                	ret

Disassembly of section .text.libc.raise:

000059e6 <raise>:
    59e6:	1141                	add	sp,sp,-16
    59e8:	c04a                	sw	s2,0(sp)
    59ea:	00000937          	lui	s2,0x0
    59ee:	14690593          	add	a1,s2,326 # 146 <__SEGGER_RTL_SIGNAL_SIG_IGN>
    59f2:	c226                	sw	s1,4(sp)
    59f4:	c606                	sw	ra,12(sp)
    59f6:	c422                	sw	s0,8(sp)
    59f8:	84aa                	mv	s1,a0
    59fa:	3f75                	jal	59b6 <signal>
    59fc:	a8a18793          	add	a5,gp,-1398 # 3fa <__SEGGER_RTL_SIGNAL_SIG_ERR>
    5a00:	02f50d63          	beq	a0,a5,5a3a <.L24>
    5a04:	14690913          	add	s2,s2,326
    5a08:	842a                	mv	s0,a0
    5a0a:	03250163          	beq	a0,s2,5a2c <.L22>
    5a0e:	000005b7          	lui	a1,0x0
    5a12:	14258793          	add	a5,a1,322 # 142 <__SEGGER_RTL_SIGNAL_SIG_DFL>
    5a16:	00f51563          	bne	a0,a5,5a20 <.L23>
    5a1a:	4505                	li	a0,1
    5a1c:	e3afa0ef          	jal	56 <exit>

00005a20 <.L23>:
    5a20:	14258593          	add	a1,a1,322
    5a24:	8526                	mv	a0,s1
    5a26:	3f41                	jal	59b6 <signal>
    5a28:	8526                	mv	a0,s1
    5a2a:	9402                	jalr	s0

00005a2c <.L22>:
    5a2c:	4501                	li	a0,0

00005a2e <.L20>:
    5a2e:	40b2                	lw	ra,12(sp)
    5a30:	4422                	lw	s0,8(sp)
    5a32:	4492                	lw	s1,4(sp)
    5a34:	4902                	lw	s2,0(sp)
    5a36:	0141                	add	sp,sp,16
    5a38:	8082                	ret

00005a3a <.L24>:
    5a3a:	557d                	li	a0,-1
    5a3c:	bfcd                	j	5a2e <.L20>

Disassembly of section .text.libc.abort:

00005a3e <abort>:
    5a3e:	1141                	add	sp,sp,-16
    5a40:	c606                	sw	ra,12(sp)

00005a42 <.L27>:
    5a42:	4501                	li	a0,0
    5a44:	374d                	jal	59e6 <raise>
    5a46:	bff5                	j	5a42 <.L27>

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

00005a48 <__SEGGER_RTL_X_assert>:
    5a48:	1101                	add	sp,sp,-32
    5a4a:	cc22                	sw	s0,24(sp)
    5a4c:	ca26                	sw	s1,20(sp)
    5a4e:	842a                	mv	s0,a0
    5a50:	84ae                	mv	s1,a1
    5a52:	8532                	mv	a0,a2
    5a54:	858a                	mv	a1,sp
    5a56:	4629                	li	a2,10
    5a58:	ce06                	sw	ra,28(sp)
    5a5a:	cb6fd0ef          	jal	2f10 <itoa>
    5a5e:	8526                	mv	a0,s1
    5a60:	3f1d                	jal	5996 <__SEGGER_RTL_puts_no_nl>
    5a62:	b7420513          	add	a0,tp,-1164 # fffffb74 <__AHB_SRAM_segment_end__+0xfdf7b74>
    5a66:	3f05                	jal	5996 <__SEGGER_RTL_puts_no_nl>
    5a68:	850a                	mv	a0,sp
    5a6a:	3735                	jal	5996 <__SEGGER_RTL_puts_no_nl>
    5a6c:	b7820513          	add	a0,tp,-1160 # fffffb78 <__AHB_SRAM_segment_end__+0xfdf7b78>
    5a70:	371d                	jal	5996 <__SEGGER_RTL_puts_no_nl>
    5a72:	8522                	mv	a0,s0
    5a74:	370d                	jal	5996 <__SEGGER_RTL_puts_no_nl>
    5a76:	b9020513          	add	a0,tp,-1136 # fffffb90 <__AHB_SRAM_segment_end__+0xfdf7b90>
    5a7a:	3f31                	jal	5996 <__SEGGER_RTL_puts_no_nl>
    5a7c:	37c9                	jal	5a3e <abort>

Disassembly of section .text.libc.__mulsf3:

00005a7e <__mulsf3>:
    5a7e:	80000737          	lui	a4,0x80000
    5a82:	0ff00293          	li	t0,255
    5a86:	00b547b3          	xor	a5,a0,a1
    5a8a:	8ff9                	and	a5,a5,a4
    5a8c:	00151613          	sll	a2,a0,0x1
    5a90:	8261                	srl	a2,a2,0x18
    5a92:	00159693          	sll	a3,a1,0x1
    5a96:	82e1                	srl	a3,a3,0x18
    5a98:	ce29                	beqz	a2,5af2 <.L__mulsf3_lhs_zero_or_subnormal>
    5a9a:	c6bd                	beqz	a3,5b08 <.L__mulsf3_rhs_zero_or_subnormal>
    5a9c:	04560f63          	beq	a2,t0,5afa <.L__mulsf3_lhs_inf_or_nan>
    5aa0:	06568963          	beq	a3,t0,5b12 <.L__mulsf3_rhs_inf_or_nan>
    5aa4:	9636                	add	a2,a2,a3
    5aa6:	0522                	sll	a0,a0,0x8
    5aa8:	8d59                	or	a0,a0,a4
    5aaa:	05a2                	sll	a1,a1,0x8
    5aac:	8dd9                	or	a1,a1,a4
    5aae:	02b506b3          	mul	a3,a0,a1
    5ab2:	02b53533          	mulhu	a0,a0,a1
    5ab6:	00d036b3          	snez	a3,a3
    5aba:	8d55                	or	a0,a0,a3
    5abc:	00054463          	bltz	a0,5ac4 <.L__mulsf3_normalized>
    5ac0:	0506                	sll	a0,a0,0x1
    5ac2:	167d                	add	a2,a2,-1 # fff <__SEGGER_RTL_Moeller_inverse_lut+0x11b>

00005ac4 <.L__mulsf3_normalized>:
    5ac4:	f8160613          	add	a2,a2,-127
    5ac8:	04064863          	bltz	a2,5b18 <.L__mulsf3_zero_or_underflow>
    5acc:	12fd                	add	t0,t0,-1 # 23ffff <__heap_end__+0x3bfff>
    5ace:	00565f63          	bge	a2,t0,5aec <.L__mulsf3_inf>
    5ad2:	01851693          	sll	a3,a0,0x18
    5ad6:	8121                	srl	a0,a0,0x8
    5ad8:	065e                	sll	a2,a2,0x17
    5ada:	9532                	add	a0,a0,a2
    5adc:	0006d663          	bgez	a3,5ae8 <.L__mulsf3_apply_sign>
    5ae0:	0505                	add	a0,a0,1
    5ae2:	0686                	sll	a3,a3,0x1
    5ae4:	e291                	bnez	a3,5ae8 <.L__mulsf3_apply_sign>
    5ae6:	9979                	and	a0,a0,-2

00005ae8 <.L__mulsf3_apply_sign>:
    5ae8:	8d5d                	or	a0,a0,a5
    5aea:	8082                	ret

00005aec <.L__mulsf3_inf>:
    5aec:	7f800537          	lui	a0,0x7f800
    5af0:	bfe5                	j	5ae8 <.L__mulsf3_apply_sign>

00005af2 <.L__mulsf3_lhs_zero_or_subnormal>:
    5af2:	00568d63          	beq	a3,t0,5b0c <.L__mulsf3_nan>

00005af6 <.L__mulsf3_signed_zero>:
    5af6:	853e                	mv	a0,a5
    5af8:	8082                	ret

00005afa <.L__mulsf3_lhs_inf_or_nan>:
    5afa:	0526                	sll	a0,a0,0x9
    5afc:	e901                	bnez	a0,5b0c <.L__mulsf3_nan>
    5afe:	fe5697e3          	bne	a3,t0,5aec <.L__mulsf3_inf>
    5b02:	05a6                	sll	a1,a1,0x9
    5b04:	e581                	bnez	a1,5b0c <.L__mulsf3_nan>
    5b06:	b7dd                	j	5aec <.L__mulsf3_inf>

00005b08 <.L__mulsf3_rhs_zero_or_subnormal>:
    5b08:	fe5617e3          	bne	a2,t0,5af6 <.L__mulsf3_signed_zero>

00005b0c <.L__mulsf3_nan>:
    5b0c:	7fc00537          	lui	a0,0x7fc00
    5b10:	8082                	ret

00005b12 <.L__mulsf3_rhs_inf_or_nan>:
    5b12:	05a6                	sll	a1,a1,0x9
    5b14:	fde5                	bnez	a1,5b0c <.L__mulsf3_nan>
    5b16:	bfd9                	j	5aec <.L__mulsf3_inf>

00005b18 <.L__mulsf3_zero_or_underflow>:
    5b18:	0605                	add	a2,a2,1
    5b1a:	fe71                	bnez	a2,5af6 <.L__mulsf3_signed_zero>
    5b1c:	8521                	sra	a0,a0,0x8
    5b1e:	00150293          	add	t0,a0,1 # 7fc00001 <_extram_size+0x7dc00001>
    5b22:	0509                	add	a0,a0,2
    5b24:	fc0299e3          	bnez	t0,5af6 <.L__mulsf3_signed_zero>
    5b28:	00800537          	lui	a0,0x800
    5b2c:	bf75                	j	5ae8 <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__divsf3:

00005b2e <__divsf3>:
    5b2e:	0ff00293          	li	t0,255
    5b32:	00151713          	sll	a4,a0,0x1
    5b36:	8361                	srl	a4,a4,0x18
    5b38:	00159793          	sll	a5,a1,0x1
    5b3c:	83e1                	srl	a5,a5,0x18
    5b3e:	00b54333          	xor	t1,a0,a1
    5b42:	01f35313          	srl	t1,t1,0x1f
    5b46:	037e                	sll	t1,t1,0x1f
    5b48:	cf4d                	beqz	a4,5c02 <.L__divsf3_lhs_zero_or_subnormal>
    5b4a:	cbe9                	beqz	a5,5c1c <.L__divsf3_rhs_zero_or_subnormal>
    5b4c:	0c570363          	beq	a4,t0,5c12 <.L__divsf3_lhs_inf_or_nan>
    5b50:	0c578b63          	beq	a5,t0,5c26 <.L__divsf3_rhs_inf_or_nan>
    5b54:	8f1d                	sub	a4,a4,a5
    5b56:	47418293          	add	t0,gp,1140 # de4 <__SEGGER_RTL_fdiv_reciprocal_table>
    5b5a:	00f5d693          	srl	a3,a1,0xf
    5b5e:	0fc6f693          	and	a3,a3,252
    5b62:	9696                	add	a3,a3,t0
    5b64:	429c                	lw	a5,0(a3)
    5b66:	4187d613          	sra	a2,a5,0x18
    5b6a:	00f59693          	sll	a3,a1,0xf
    5b6e:	82e1                	srl	a3,a3,0x18
    5b70:	0016f293          	and	t0,a3,1
    5b74:	8285                	srl	a3,a3,0x1
    5b76:	fc068693          	add	a3,a3,-64
    5b7a:	9696                	add	a3,a3,t0
    5b7c:	02d60633          	mul	a2,a2,a3
    5b80:	07a2                	sll	a5,a5,0x8
    5b82:	83a1                	srl	a5,a5,0x8
    5b84:	963e                	add	a2,a2,a5
    5b86:	05a2                	sll	a1,a1,0x8
    5b88:	81a1                	srl	a1,a1,0x8
    5b8a:	008007b7          	lui	a5,0x800
    5b8e:	8ddd                	or	a1,a1,a5
    5b90:	02c586b3          	mul	a3,a1,a2
    5b94:	0522                	sll	a0,a0,0x8
    5b96:	8121                	srl	a0,a0,0x8
    5b98:	8d5d                	or	a0,a0,a5
    5b9a:	02c697b3          	mulh	a5,a3,a2
    5b9e:	00b532b3          	sltu	t0,a0,a1
    5ba2:	00551533          	sll	a0,a0,t0
    5ba6:	40570733          	sub	a4,a4,t0
    5baa:	01465693          	srl	a3,a2,0x14
    5bae:	8a85                	and	a3,a3,1
    5bb0:	0016c693          	xor	a3,a3,1
    5bb4:	062e                	sll	a2,a2,0xb
    5bb6:	8e1d                	sub	a2,a2,a5
    5bb8:	8e15                	sub	a2,a2,a3
    5bba:	050a                	sll	a0,a0,0x2
    5bbc:	02a617b3          	mulh	a5,a2,a0
    5bc0:	07e70613          	add	a2,a4,126 # 8000007e <_extram_size+0x7e00007e>
    5bc4:	055a                	sll	a0,a0,0x16
    5bc6:	8d0d                	sub	a0,a0,a1
    5bc8:	02b786b3          	mul	a3,a5,a1
    5bcc:	0fe00293          	li	t0,254
    5bd0:	00567f63          	bgeu	a2,t0,5bee <.L__divsf3_underflow_or_overflow>
    5bd4:	40a68533          	sub	a0,a3,a0
    5bd8:	000522b3          	sltz	t0,a0
    5bdc:	9796                	add	a5,a5,t0
    5bde:	0017f513          	and	a0,a5,1
    5be2:	8385                	srl	a5,a5,0x1
    5be4:	953e                	add	a0,a0,a5
    5be6:	065e                	sll	a2,a2,0x17
    5be8:	9532                	add	a0,a0,a2
    5bea:	951a                	add	a0,a0,t1
    5bec:	8082                	ret

00005bee <.L__divsf3_underflow_or_overflow>:
    5bee:	851a                	mv	a0,t1
    5bf0:	00564563          	blt	a2,t0,5bfa <.L__divsf3_done>
    5bf4:	7f800337          	lui	t1,0x7f800

00005bf8 <.L__divsf3_apply_sign>:
    5bf8:	951a                	add	a0,a0,t1

00005bfa <.L__divsf3_done>:
    5bfa:	8082                	ret

00005bfc <.L__divsf3_inf>:
    5bfc:	7f800537          	lui	a0,0x7f800
    5c00:	bfe5                	j	5bf8 <.L__divsf3_apply_sign>

00005c02 <.L__divsf3_lhs_zero_or_subnormal>:
    5c02:	c789                	beqz	a5,5c0c <.L__divsf3_nan>
    5c04:	02579363          	bne	a5,t0,5c2a <.L__divsf3_signed_zero>
    5c08:	05a6                	sll	a1,a1,0x9
    5c0a:	c185                	beqz	a1,5c2a <.L__divsf3_signed_zero>

00005c0c <.L__divsf3_nan>:
    5c0c:	7fc00537          	lui	a0,0x7fc00
    5c10:	8082                	ret

00005c12 <.L__divsf3_lhs_inf_or_nan>:
    5c12:	0526                	sll	a0,a0,0x9
    5c14:	fd65                	bnez	a0,5c0c <.L__divsf3_nan>
    5c16:	fe5793e3          	bne	a5,t0,5bfc <.L__divsf3_inf>
    5c1a:	bfcd                	j	5c0c <.L__divsf3_nan>

00005c1c <.L__divsf3_rhs_zero_or_subnormal>:
    5c1c:	fe5710e3          	bne	a4,t0,5bfc <.L__divsf3_inf>
    5c20:	0526                	sll	a0,a0,0x9
    5c22:	f56d                	bnez	a0,5c0c <.L__divsf3_nan>
    5c24:	bfe1                	j	5bfc <.L__divsf3_inf>

00005c26 <.L__divsf3_rhs_inf_or_nan>:
    5c26:	05a6                	sll	a1,a1,0x9
    5c28:	f1f5                	bnez	a1,5c0c <.L__divsf3_nan>

00005c2a <.L__divsf3_signed_zero>:
    5c2a:	851a                	mv	a0,t1
    5c2c:	8082                	ret

Disassembly of section .text.libc.__divdf3:

00005c2e <__divdf3>:
    5c2e:	00169813          	sll	a6,a3,0x1
    5c32:	01585813          	srl	a6,a6,0x15
    5c36:	00159893          	sll	a7,a1,0x1
    5c3a:	0158d893          	srl	a7,a7,0x15
    5c3e:	00d5c3b3          	xor	t2,a1,a3
    5c42:	01f3d393          	srl	t2,t2,0x1f
    5c46:	03fe                	sll	t2,t2,0x1f
    5c48:	7ff00293          	li	t0,2047
    5c4c:	16588e63          	beq	a7,t0,5dc8 <.L__divdf3_inf_nan_over>
    5c50:	18080a63          	beqz	a6,5de4 <.L__divdf3_div_zero>
    5c54:	18580263          	beq	a6,t0,5dd8 <.L__divdf3_div_inf_nan>
    5c58:	18088263          	beqz	a7,5ddc <.L__divdf3_signed_zero>
    5c5c:	410888b3          	sub	a7,a7,a6
    5c60:	3ff88893          	add	a7,a7,1023
    5c64:	05b2                	sll	a1,a1,0xc
    5c66:	81b1                	srl	a1,a1,0xc
    5c68:	06b2                	sll	a3,a3,0xc
    5c6a:	82b1                	srl	a3,a3,0xc
    5c6c:	00100737          	lui	a4,0x100
    5c70:	8dd9                	or	a1,a1,a4
    5c72:	8ed9                	or	a3,a3,a4
    5c74:	00c53733          	sltu	a4,a0,a2
    5c78:	9736                	add	a4,a4,a3
    5c7a:	8d99                	sub	a1,a1,a4
    5c7c:	8d11                	sub	a0,a0,a2
    5c7e:	0005dd63          	bgez	a1,5c98 <.L__divdf3_can_subtract>
    5c82:	00052733          	sltz	a4,a0
    5c86:	95ae                	add	a1,a1,a1
    5c88:	95ba                	add	a1,a1,a4
    5c8a:	95b6                	add	a1,a1,a3
    5c8c:	952a                	add	a0,a0,a0
    5c8e:	9532                	add	a0,a0,a2
    5c90:	00c53733          	sltu	a4,a0,a2
    5c94:	95ba                	add	a1,a1,a4
    5c96:	18fd                	add	a7,a7,-1

00005c98 <.L__divdf3_can_subtract>:
    5c98:	1258dd63          	bge	a7,t0,5dd2 <.L__divdf3_signed_inf>
    5c9c:	15105063          	blez	a7,5ddc <.L__divdf3_signed_zero>
    5ca0:	05aa                	sll	a1,a1,0xa
    5ca2:	01655713          	srl	a4,a0,0x16
    5ca6:	8dd9                	or	a1,a1,a4
    5ca8:	052a                	sll	a0,a0,0xa
    5caa:	02d5d833          	divu	a6,a1,a3
    5cae:	02d80e33          	mul	t3,a6,a3
    5cb2:	41c585b3          	sub	a1,a1,t3
    5cb6:	02c80733          	mul	a4,a6,a2
    5cba:	02c837b3          	mulhu	a5,a6,a2
    5cbe:	00e53e33          	sltu	t3,a0,a4
    5cc2:	97f2                	add	a5,a5,t3
    5cc4:	8d19                	sub	a0,a0,a4
    5cc6:	8d9d                	sub	a1,a1,a5
    5cc8:	0005d863          	bgez	a1,5cd8 <.L__divdf3_qdash_correct_1>
    5ccc:	187d                	add	a6,a6,-1
    5cce:	9532                	add	a0,a0,a2
    5cd0:	95b6                	add	a1,a1,a3
    5cd2:	00c532b3          	sltu	t0,a0,a2
    5cd6:	9596                	add	a1,a1,t0

00005cd8 <.L__divdf3_qdash_correct_1>:
    5cd8:	05aa                	sll	a1,a1,0xa
    5cda:	01655293          	srl	t0,a0,0x16
    5cde:	9596                	add	a1,a1,t0
    5ce0:	052a                	sll	a0,a0,0xa
    5ce2:	02d5d2b3          	divu	t0,a1,a3
    5ce6:	02d28733          	mul	a4,t0,a3
    5cea:	8d99                	sub	a1,a1,a4
    5cec:	02c28733          	mul	a4,t0,a2
    5cf0:	02c2b7b3          	mulhu	a5,t0,a2
    5cf4:	00e53e33          	sltu	t3,a0,a4
    5cf8:	97f2                	add	a5,a5,t3
    5cfa:	8d19                	sub	a0,a0,a4
    5cfc:	8d9d                	sub	a1,a1,a5
    5cfe:	0005d863          	bgez	a1,5d0e <.L__divdf3_qdash_correct_2>
    5d02:	12fd                	add	t0,t0,-1
    5d04:	9532                	add	a0,a0,a2
    5d06:	95b6                	add	a1,a1,a3
    5d08:	00c53e33          	sltu	t3,a0,a2
    5d0c:	95f2                	add	a1,a1,t3

00005d0e <.L__divdf3_qdash_correct_2>:
    5d0e:	082a                	sll	a6,a6,0xa
    5d10:	9816                	add	a6,a6,t0
    5d12:	05ae                	sll	a1,a1,0xb
    5d14:	01555e13          	srl	t3,a0,0x15
    5d18:	95f2                	add	a1,a1,t3
    5d1a:	052e                	sll	a0,a0,0xb
    5d1c:	02d5d2b3          	divu	t0,a1,a3
    5d20:	02d28733          	mul	a4,t0,a3
    5d24:	8d99                	sub	a1,a1,a4
    5d26:	02c28733          	mul	a4,t0,a2
    5d2a:	02c2b7b3          	mulhu	a5,t0,a2
    5d2e:	00e53e33          	sltu	t3,a0,a4
    5d32:	97f2                	add	a5,a5,t3
    5d34:	8d19                	sub	a0,a0,a4
    5d36:	8d9d                	sub	a1,a1,a5
    5d38:	0005d863          	bgez	a1,5d48 <.L__divdf3_qdash_correct_3>
    5d3c:	12fd                	add	t0,t0,-1
    5d3e:	9532                	add	a0,a0,a2
    5d40:	95b6                	add	a1,a1,a3
    5d42:	00c53e33          	sltu	t3,a0,a2
    5d46:	95f2                	add	a1,a1,t3

00005d48 <.L__divdf3_qdash_correct_3>:
    5d48:	05ae                	sll	a1,a1,0xb
    5d4a:	01555e13          	srl	t3,a0,0x15
    5d4e:	95f2                	add	a1,a1,t3
    5d50:	052e                	sll	a0,a0,0xb
    5d52:	02d5d333          	divu	t1,a1,a3
    5d56:	02d30733          	mul	a4,t1,a3
    5d5a:	8d99                	sub	a1,a1,a4
    5d5c:	02c30733          	mul	a4,t1,a2
    5d60:	02c337b3          	mulhu	a5,t1,a2
    5d64:	00e53e33          	sltu	t3,a0,a4
    5d68:	97f2                	add	a5,a5,t3
    5d6a:	8d19                	sub	a0,a0,a4
    5d6c:	8d9d                	sub	a1,a1,a5
    5d6e:	0005d863          	bgez	a1,5d7e <.L__divdf3_qdash_correct_4>
    5d72:	137d                	add	t1,t1,-1 # 7f7fffff <_extram_size+0x7d7fffff>
    5d74:	9532                	add	a0,a0,a2
    5d76:	95b6                	add	a1,a1,a3
    5d78:	00c53e33          	sltu	t3,a0,a2
    5d7c:	95f2                	add	a1,a1,t3

00005d7e <.L__divdf3_qdash_correct_4>:
    5d7e:	02d6                	sll	t0,t0,0x15
    5d80:	032a                	sll	t1,t1,0xa
    5d82:	929a                	add	t0,t0,t1
    5d84:	05ae                	sll	a1,a1,0xb
    5d86:	01555e13          	srl	t3,a0,0x15
    5d8a:	95f2                	add	a1,a1,t3
    5d8c:	052e                	sll	a0,a0,0xb
    5d8e:	02d5d333          	divu	t1,a1,a3
    5d92:	02d30733          	mul	a4,t1,a3
    5d96:	8d99                	sub	a1,a1,a4
    5d98:	02c30733          	mul	a4,t1,a2
    5d9c:	02c337b3          	mulhu	a5,t1,a2
    5da0:	00e53e33          	sltu	t3,a0,a4
    5da4:	97f2                	add	a5,a5,t3
    5da6:	8d9d                	sub	a1,a1,a5
    5da8:	85fd                	sra	a1,a1,0x1f
    5daa:	932e                	add	t1,t1,a1
    5dac:	08d2                	sll	a7,a7,0x14
    5dae:	011805b3          	add	a1,a6,a7
    5db2:	00135513          	srl	a0,t1,0x1
    5db6:	9516                	add	a0,a0,t0
    5db8:	00137313          	and	t1,t1,1
    5dbc:	951a                	add	a0,a0,t1
    5dbe:	00653733          	sltu	a4,a0,t1
    5dc2:	95ba                	add	a1,a1,a4
    5dc4:	959e                	add	a1,a1,t2
    5dc6:	8082                	ret

00005dc8 <.L__divdf3_inf_nan_over>:
    5dc8:	05b2                	sll	a1,a1,0xc
    5dca:	00580f63          	beq	a6,t0,5de8 <.L__divdf3_return_nan>
    5dce:	8dc9                	or	a1,a1,a0
    5dd0:	ed81                	bnez	a1,5de8 <.L__divdf3_return_nan>

00005dd2 <.L__divdf3_signed_inf>:
    5dd2:	7ff005b7          	lui	a1,0x7ff00
    5dd6:	a021                	j	5dde <.L__divdf3_apply_sign>

00005dd8 <.L__divdf3_div_inf_nan>:
    5dd8:	06b2                	sll	a3,a3,0xc
    5dda:	e699                	bnez	a3,5de8 <.L__divdf3_return_nan>

00005ddc <.L__divdf3_signed_zero>:
    5ddc:	4581                	li	a1,0

00005dde <.L__divdf3_apply_sign>:
    5dde:	959e                	add	a1,a1,t2

00005de0 <.L__divdf3_clr_low_ret>:
    5de0:	4501                	li	a0,0
    5de2:	8082                	ret

00005de4 <.L__divdf3_div_zero>:
    5de4:	fe0897e3          	bnez	a7,5dd2 <.L__divdf3_signed_inf>

00005de8 <.L__divdf3_return_nan>:
    5de8:	7ff805b7          	lui	a1,0x7ff80
    5dec:	bfd5                	j	5de0 <.L__divdf3_clr_low_ret>

Disassembly of section .text.libc.__eqsf2:

00005dee <__eqsf2>:
    5dee:	ff000637          	lui	a2,0xff000
    5df2:	00151693          	sll	a3,a0,0x1
    5df6:	02d66063          	bltu	a2,a3,5e16 <.L__eqsf2_one>
    5dfa:	00159693          	sll	a3,a1,0x1
    5dfe:	00d66c63          	bltu	a2,a3,5e16 <.L__eqsf2_one>
    5e02:	00b56633          	or	a2,a0,a1
    5e06:	0606                	sll	a2,a2,0x1
    5e08:	c609                	beqz	a2,5e12 <.L__eqsf2_zero>
    5e0a:	8d0d                	sub	a0,a0,a1
    5e0c:	00a03533          	snez	a0,a0
    5e10:	8082                	ret

00005e12 <.L__eqsf2_zero>:
    5e12:	4501                	li	a0,0
    5e14:	8082                	ret

00005e16 <.L__eqsf2_one>:
    5e16:	4505                	li	a0,1
    5e18:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

00005e1a <__fixunssfdi>:
    5e1a:	04054a63          	bltz	a0,5e6e <.L__fixunssfdi_zero_result>
    5e1e:	00151613          	sll	a2,a0,0x1
    5e22:	8261                	srl	a2,a2,0x18
    5e24:	f8160613          	add	a2,a2,-127 # feffff81 <__AHB_SRAM_segment_end__+0xedf7f81>
    5e28:	04064363          	bltz	a2,5e6e <.L__fixunssfdi_zero_result>
    5e2c:	800006b7          	lui	a3,0x80000
    5e30:	02000293          	li	t0,32
    5e34:	00565b63          	bge	a2,t0,5e4a <.L__fixunssfdi_long_shift>
    5e38:	40c00633          	neg	a2,a2
    5e3c:	067d                	add	a2,a2,31
    5e3e:	0522                	sll	a0,a0,0x8
    5e40:	8d55                	or	a0,a0,a3
    5e42:	00c55533          	srl	a0,a0,a2
    5e46:	4581                	li	a1,0
    5e48:	8082                	ret

00005e4a <.L__fixunssfdi_long_shift>:
    5e4a:	40c00633          	neg	a2,a2
    5e4e:	03f60613          	add	a2,a2,63
    5e52:	02064163          	bltz	a2,5e74 <.L__fixunssfdi_overflow_result>
    5e56:	00851593          	sll	a1,a0,0x8
    5e5a:	8dd5                	or	a1,a1,a3
    5e5c:	4501                	li	a0,0
    5e5e:	c619                	beqz	a2,5e6c <.L__fixunssfdi_shift_32>
    5e60:	40c006b3          	neg	a3,a2
    5e64:	00d59533          	sll	a0,a1,a3
    5e68:	00c5d5b3          	srl	a1,a1,a2

00005e6c <.L__fixunssfdi_shift_32>:
    5e6c:	8082                	ret

00005e6e <.L__fixunssfdi_zero_result>:
    5e6e:	4501                	li	a0,0
    5e70:	4581                	li	a1,0
    5e72:	8082                	ret

00005e74 <.L__fixunssfdi_overflow_result>:
    5e74:	557d                	li	a0,-1
    5e76:	55fd                	li	a1,-1
    5e78:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

00005e7a <__trunctfsf2>:
    5e7a:	4110                	lw	a2,0(a0)
    5e7c:	4154                	lw	a3,4(a0)
    5e7e:	4518                	lw	a4,8(a0)
    5e80:	455c                	lw	a5,12(a0)
    5e82:	1101                	add	sp,sp,-32
    5e84:	850a                	mv	a0,sp
    5e86:	ce06                	sw	ra,28(sp)
    5e88:	c032                	sw	a2,0(sp)
    5e8a:	c236                	sw	a3,4(sp)
    5e8c:	c43a                	sw	a4,8(sp)
    5e8e:	c63e                	sw	a5,12(sp)
    5e90:	d44fd0ef          	jal	33d4 <__SEGGER_RTL_ldouble_to_double>
    5e94:	cbafd0ef          	jal	334e <__truncdfsf2>
    5e98:	40f2                	lw	ra,28(sp)
    5e9a:	6105                	add	sp,sp,32
    5e9c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

00005e9e <__SEGGER_RTL_float32_signbit>:
    5e9e:	817d                	srl	a0,a0,0x1f
    5ea0:	8082                	ret

Disassembly of section .text.libc.ldexpf:

00005ea2 <ldexpf>:
    5ea2:	01755713          	srl	a4,a0,0x17
    5ea6:	0ff77713          	zext.b	a4,a4
    5eaa:	fff70613          	add	a2,a4,-1 # fffff <__AXI_SRAM_segment_size__+0x7ffff>
    5eae:	0fd00693          	li	a3,253
    5eb2:	87aa                	mv	a5,a0
    5eb4:	02c6e863          	bltu	a3,a2,5ee4 <.L780>
    5eb8:	95ba                	add	a1,a1,a4
    5eba:	fff58713          	add	a4,a1,-1 # 7ff7ffff <_extram_size+0x7df7ffff>
    5ebe:	00e6eb63          	bltu	a3,a4,5ed4 <.L781>
    5ec2:	80800737          	lui	a4,0x80800
    5ec6:	177d                	add	a4,a4,-1 # 807fffff <_extram_size+0x7e7fffff>
    5ec8:	00e577b3          	and	a5,a0,a4
    5ecc:	05de                	sll	a1,a1,0x17
    5ece:	00f5e533          	or	a0,a1,a5
    5ed2:	8082                	ret

00005ed4 <.L781>:
    5ed4:	80000537          	lui	a0,0x80000
    5ed8:	8d7d                	and	a0,a0,a5
    5eda:	00b05563          	blez	a1,5ee4 <.L780>
    5ede:	7f8007b7          	lui	a5,0x7f800
    5ee2:	8d5d                	or	a0,a0,a5

00005ee4 <.L780>:
    5ee4:	8082                	ret

Disassembly of section .text.libc.frexpf:

00005ee6 <frexpf>:
    5ee6:	01755793          	srl	a5,a0,0x17
    5eea:	0ff7f793          	zext.b	a5,a5
    5eee:	4701                	li	a4,0
    5ef0:	cf99                	beqz	a5,5f0e <.L959>
    5ef2:	0ff00613          	li	a2,255
    5ef6:	00c78c63          	beq	a5,a2,5f0e <.L959>
    5efa:	f8278713          	add	a4,a5,-126 # 7f7fff82 <_extram_size+0x7d7fff82>
    5efe:	808007b7          	lui	a5,0x80800
    5f02:	17fd                	add	a5,a5,-1 # 807fffff <_extram_size+0x7e7fffff>
    5f04:	00f576b3          	and	a3,a0,a5
    5f08:	3f000537          	lui	a0,0x3f000
    5f0c:	8d55                	or	a0,a0,a3

00005f0e <.L959>:
    5f0e:	c198                	sw	a4,0(a1)
    5f10:	8082                	ret

Disassembly of section .text.libc.fmodf:

00005f12 <fmodf>:
    5f12:	01755793          	srl	a5,a0,0x17
    5f16:	80000837          	lui	a6,0x80000
    5f1a:	17fd                	add	a5,a5,-1
    5f1c:	0fd00713          	li	a4,253
    5f20:	86aa                	mv	a3,a0
    5f22:	862e                	mv	a2,a1
    5f24:	00a87833          	and	a6,a6,a0
    5f28:	02f76463          	bltu	a4,a5,5f50 <.L991>
    5f2c:	0175d793          	srl	a5,a1,0x17
    5f30:	17fd                	add	a5,a5,-1
    5f32:	02f77e63          	bgeu	a4,a5,5f6e <.L992>
    5f36:	00151713          	sll	a4,a0,0x1

00005f3a <.L993>:
    5f3a:	00159793          	sll	a5,a1,0x1
    5f3e:	ff000637          	lui	a2,0xff000
    5f42:	0cf66663          	bltu	a2,a5,600e <.L1009>
    5f46:	ef01                	bnez	a4,5f5e <.L995>
    5f48:	eb91                	bnez	a5,5f5c <.L994>

00005f4a <.L1011>:
    5f4a:	b2822503          	lw	a0,-1240(tp) # fffffb28 <__AHB_SRAM_segment_end__+0xfdf7b28>
    5f4e:	8082                	ret

00005f50 <.L991>:
    5f50:	00151713          	sll	a4,a0,0x1
    5f54:	ff0007b7          	lui	a5,0xff000
    5f58:	fee7f1e3          	bgeu	a5,a4,5f3a <.L993>

00005f5c <.L994>:
    5f5c:	8082                	ret

00005f5e <.L995>:
    5f5e:	fec706e3          	beq	a4,a2,5f4a <.L1011>
    5f62:	fec78de3          	beq	a5,a2,5f5c <.L994>
    5f66:	d3f5                	beqz	a5,5f4a <.L1011>
    5f68:	0586                	sll	a1,a1,0x1
    5f6a:	0015d613          	srl	a2,a1,0x1

00005f6e <.L992>:
    5f6e:	00169793          	sll	a5,a3,0x1
    5f72:	8385                	srl	a5,a5,0x1
    5f74:	00f66663          	bltu	a2,a5,5f80 <.L996>
    5f78:	fec792e3          	bne	a5,a2,5f5c <.L994>

00005f7c <.L1018>:
    5f7c:	8542                	mv	a0,a6
    5f7e:	8082                	ret

00005f80 <.L996>:
    5f80:	0177d713          	srl	a4,a5,0x17
    5f84:	cb0d                	beqz	a4,5fb6 <.L1012>
    5f86:	008007b7          	lui	a5,0x800
    5f8a:	fff78593          	add	a1,a5,-1 # 7fffff <__DLM_segment_end__+0x5bffff>
    5f8e:	8eed                	and	a3,a3,a1
    5f90:	8fd5                	or	a5,a5,a3

00005f92 <.L998>:
    5f92:	01765593          	srl	a1,a2,0x17
    5f96:	c985                	beqz	a1,5fc6 <.L1013>
    5f98:	008006b7          	lui	a3,0x800
    5f9c:	fff68513          	add	a0,a3,-1 # 7fffff <__DLM_segment_end__+0x5bffff>
    5fa0:	8e69                	and	a2,a2,a0
    5fa2:	8e55                	or	a2,a2,a3

00005fa4 <.L1002>:
    5fa4:	40c786b3          	sub	a3,a5,a2
    5fa8:	02e5c763          	blt	a1,a4,5fd6 <.L1003>
    5fac:	0206cc63          	bltz	a3,5fe4 <.L1015>
    5fb0:	8542                	mv	a0,a6
    5fb2:	ea95                	bnez	a3,5fe6 <.L1004>
    5fb4:	8082                	ret

00005fb6 <.L1012>:
    5fb6:	4701                	li	a4,0
    5fb8:	008006b7          	lui	a3,0x800

00005fbc <.L997>:
    5fbc:	0786                	sll	a5,a5,0x1
    5fbe:	177d                	add	a4,a4,-1
    5fc0:	fed7eee3          	bltu	a5,a3,5fbc <.L997>
    5fc4:	b7f9                	j	5f92 <.L998>

00005fc6 <.L1013>:
    5fc6:	4581                	li	a1,0
    5fc8:	008006b7          	lui	a3,0x800

00005fcc <.L999>:
    5fcc:	0606                	sll	a2,a2,0x1
    5fce:	15fd                	add	a1,a1,-1
    5fd0:	fed66ee3          	bltu	a2,a3,5fcc <.L999>
    5fd4:	bfc1                	j	5fa4 <.L1002>

00005fd6 <.L1003>:
    5fd6:	0006c463          	bltz	a3,5fde <.L1001>
    5fda:	d2cd                	beqz	a3,5f7c <.L1018>
    5fdc:	87b6                	mv	a5,a3

00005fde <.L1001>:
    5fde:	0786                	sll	a5,a5,0x1
    5fe0:	177d                	add	a4,a4,-1
    5fe2:	b7c9                	j	5fa4 <.L1002>

00005fe4 <.L1015>:
    5fe4:	86be                	mv	a3,a5

00005fe6 <.L1004>:
    5fe6:	008007b7          	lui	a5,0x800

00005fea <.L1006>:
    5fea:	fff70513          	add	a0,a4,-1
    5fee:	00f6ed63          	bltu	a3,a5,6008 <.L1007>
    5ff2:	00e04763          	bgtz	a4,6000 <.L1008>
    5ff6:	4785                	li	a5,1
    5ff8:	8f99                	sub	a5,a5,a4
    5ffa:	00f6d6b3          	srl	a3,a3,a5
    5ffe:	4501                	li	a0,0

00006000 <.L1008>:
    6000:	9836                	add	a6,a6,a3
    6002:	055e                	sll	a0,a0,0x17
    6004:	9542                	add	a0,a0,a6
    6006:	8082                	ret

00006008 <.L1007>:
    6008:	0686                	sll	a3,a3,0x1
    600a:	872a                	mv	a4,a0
    600c:	bff9                	j	5fea <.L1006>

0000600e <.L1009>:
    600e:	852e                	mv	a0,a1
    6010:	8082                	ret

Disassembly of section .text.libc.memset:

00006012 <memset>:
    6012:	872a                	mv	a4,a0
    6014:	c22d                	beqz	a2,6076 <.Lmemset_memset_end>

00006016 <.Lmemset_unaligned_byte_set_loop>:
    6016:	01e51693          	sll	a3,a0,0x1e
    601a:	c699                	beqz	a3,6028 <.Lmemset_fast_set>
    601c:	00b50023          	sb	a1,0(a0) # 3f000000 <_extram_size+0x3d000000>
    6020:	0505                	add	a0,a0,1
    6022:	167d                	add	a2,a2,-1 # feffffff <__AHB_SRAM_segment_end__+0xedf7fff>
    6024:	fa6d                	bnez	a2,6016 <.Lmemset_unaligned_byte_set_loop>
    6026:	a881                	j	6076 <.Lmemset_memset_end>

00006028 <.Lmemset_fast_set>:
    6028:	0ff5f593          	zext.b	a1,a1
    602c:	00859693          	sll	a3,a1,0x8
    6030:	8dd5                	or	a1,a1,a3
    6032:	01059693          	sll	a3,a1,0x10
    6036:	8dd5                	or	a1,a1,a3
    6038:	02000693          	li	a3,32
    603c:	00d66f63          	bltu	a2,a3,605a <.Lmemset_word_set>

00006040 <.Lmemset_fast_set_loop>:
    6040:	c10c                	sw	a1,0(a0)
    6042:	c14c                	sw	a1,4(a0)
    6044:	c50c                	sw	a1,8(a0)
    6046:	c54c                	sw	a1,12(a0)
    6048:	c90c                	sw	a1,16(a0)
    604a:	c94c                	sw	a1,20(a0)
    604c:	cd0c                	sw	a1,24(a0)
    604e:	cd4c                	sw	a1,28(a0)
    6050:	9536                	add	a0,a0,a3
    6052:	8e15                	sub	a2,a2,a3
    6054:	fed676e3          	bgeu	a2,a3,6040 <.Lmemset_fast_set_loop>
    6058:	ce19                	beqz	a2,6076 <.Lmemset_memset_end>

0000605a <.Lmemset_word_set>:
    605a:	4691                	li	a3,4
    605c:	00d66863          	bltu	a2,a3,606c <.Lmemset_byte_set_loop>

00006060 <.Lmemset_word_set_loop>:
    6060:	c10c                	sw	a1,0(a0)
    6062:	9536                	add	a0,a0,a3
    6064:	8e15                	sub	a2,a2,a3
    6066:	fed67de3          	bgeu	a2,a3,6060 <.Lmemset_word_set_loop>
    606a:	c611                	beqz	a2,6076 <.Lmemset_memset_end>

0000606c <.Lmemset_byte_set_loop>:
    606c:	00b50023          	sb	a1,0(a0)
    6070:	0505                	add	a0,a0,1
    6072:	167d                	add	a2,a2,-1
    6074:	fe65                	bnez	a2,606c <.Lmemset_byte_set_loop>

00006076 <.Lmemset_memset_end>:
    6076:	853a                	mv	a0,a4
    6078:	8082                	ret

Disassembly of section .text.libc.strlen:

0000607a <strlen>:
    607a:	85aa                	mv	a1,a0
    607c:	00357693          	and	a3,a0,3
    6080:	c29d                	beqz	a3,60a6 <.Lstrlen_aligned>
    6082:	00054603          	lbu	a2,0(a0)
    6086:	ce21                	beqz	a2,60de <.Lstrlen_done>
    6088:	0505                	add	a0,a0,1
    608a:	00357693          	and	a3,a0,3
    608e:	ce81                	beqz	a3,60a6 <.Lstrlen_aligned>
    6090:	00054603          	lbu	a2,0(a0)
    6094:	c629                	beqz	a2,60de <.Lstrlen_done>
    6096:	0505                	add	a0,a0,1
    6098:	00357693          	and	a3,a0,3
    609c:	c689                	beqz	a3,60a6 <.Lstrlen_aligned>
    609e:	00054603          	lbu	a2,0(a0)
    60a2:	ce15                	beqz	a2,60de <.Lstrlen_done>
    60a4:	0505                	add	a0,a0,1

000060a6 <.Lstrlen_aligned>:
    60a6:	01010637          	lui	a2,0x1010
    60aa:	10160613          	add	a2,a2,257 # 1010101 <_flash_size+0x10101>
    60ae:	00761693          	sll	a3,a2,0x7

000060b2 <.Lstrlen_wordstrlen>:
    60b2:	4118                	lw	a4,0(a0)
    60b4:	0511                	add	a0,a0,4
    60b6:	40c707b3          	sub	a5,a4,a2
    60ba:	fff74713          	not	a4,a4
    60be:	8ff9                	and	a5,a5,a4
    60c0:	8ff5                	and	a5,a5,a3
    60c2:	dbe5                	beqz	a5,60b2 <.Lstrlen_wordstrlen>
    60c4:	1571                	add	a0,a0,-4
    60c6:	01879713          	sll	a4,a5,0x18
    60ca:	eb11                	bnez	a4,60de <.Lstrlen_done>
    60cc:	0505                	add	a0,a0,1
    60ce:	01079713          	sll	a4,a5,0x10
    60d2:	e711                	bnez	a4,60de <.Lstrlen_done>
    60d4:	0505                	add	a0,a0,1
    60d6:	00879713          	sll	a4,a5,0x8
    60da:	e311                	bnez	a4,60de <.Lstrlen_done>
    60dc:	0505                	add	a0,a0,1

000060de <.Lstrlen_done>:
    60de:	8d0d                	sub	a0,a0,a1
    60e0:	8082                	ret

Disassembly of section .text.libc.strnlen:

000060e2 <strnlen>:
    60e2:	862a                	mv	a2,a0
    60e4:	852e                	mv	a0,a1
    60e6:	c9c9                	beqz	a1,6178 <.L528>
    60e8:	00064783          	lbu	a5,0(a2)
    60ec:	c7c9                	beqz	a5,6176 <.L534>
    60ee:	00367793          	and	a5,a2,3
    60f2:	00379693          	sll	a3,a5,0x3
    60f6:	00f58533          	add	a0,a1,a5
    60fa:	ffc67713          	and	a4,a2,-4
    60fe:	57fd                	li	a5,-1
    6100:	00d797b3          	sll	a5,a5,a3
    6104:	4314                	lw	a3,0(a4)
    6106:	fff7c793          	not	a5,a5
    610a:	feff05b7          	lui	a1,0xfeff0
    610e:	80808837          	lui	a6,0x80808
    6112:	8fd5                	or	a5,a5,a3
    6114:	488d                	li	a7,3
    6116:	eff58593          	add	a1,a1,-257 # fefefeff <__AHB_SRAM_segment_end__+0xede7eff>
    611a:	08080813          	add	a6,a6,128 # 80808080 <_extram_size+0x7e808080>

0000611e <.L530>:
    611e:	00a8ff63          	bgeu	a7,a0,613c <.L529>
    6122:	00b786b3          	add	a3,a5,a1
    6126:	fff7c313          	not	t1,a5
    612a:	0066f6b3          	and	a3,a3,t1
    612e:	0106f6b3          	and	a3,a3,a6
    6132:	e689                	bnez	a3,613c <.L529>
    6134:	0711                	add	a4,a4,4
    6136:	1571                	add	a0,a0,-4
    6138:	431c                	lw	a5,0(a4)
    613a:	b7d5                	j	611e <.L530>

0000613c <.L529>:
    613c:	0ff7f593          	zext.b	a1,a5
    6140:	c59d                	beqz	a1,616e <.L531>
    6142:	0087d593          	srl	a1,a5,0x8
    6146:	0ff5f593          	zext.b	a1,a1
    614a:	4685                	li	a3,1
    614c:	cd89                	beqz	a1,6166 <.L532>
    614e:	0107d593          	srl	a1,a5,0x10
    6152:	0ff5f593          	zext.b	a1,a1
    6156:	4689                	li	a3,2
    6158:	c599                	beqz	a1,6166 <.L532>
    615a:	010005b7          	lui	a1,0x1000
    615e:	468d                	li	a3,3
    6160:	00b7e363          	bltu	a5,a1,6166 <.L532>
    6164:	4691                	li	a3,4

00006166 <.L532>:
    6166:	85aa                	mv	a1,a0
    6168:	00a6f363          	bgeu	a3,a0,616e <.L531>
    616c:	85b6                	mv	a1,a3

0000616e <.L531>:
    616e:	8f11                	sub	a4,a4,a2
    6170:	00b70533          	add	a0,a4,a1
    6174:	8082                	ret

00006176 <.L534>:
    6176:	4501                	li	a0,0

00006178 <.L528>:
    6178:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

0000617a <__SEGGER_RTL_stream_write>:
    617a:	5154                	lw	a3,36(a0)
    617c:	87ae                	mv	a5,a1
    617e:	853e                	mv	a0,a5
    6180:	4585                	li	a1,1
    6182:	dabfc06f          	j	2f2c <fwrite>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

00006186 <__SEGGER_RTL_putc>:
    6186:	4918                	lw	a4,16(a0)
    6188:	1101                	add	sp,sp,-32
    618a:	0ff5f593          	zext.b	a1,a1
    618e:	cc22                	sw	s0,24(sp)
    6190:	ce06                	sw	ra,28(sp)
    6192:	00b107a3          	sb	a1,15(sp)
    6196:	411c                	lw	a5,0(a0)
    6198:	842a                	mv	s0,a0
    619a:	cb05                	beqz	a4,61ca <.L24>
    619c:	4154                	lw	a3,4(a0)
    619e:	00d7ff63          	bgeu	a5,a3,61bc <.L26>
    61a2:	495c                	lw	a5,20(a0)
    61a4:	00178693          	add	a3,a5,1 # 800001 <__DLM_segment_end__+0x5c0001>
    61a8:	973e                	add	a4,a4,a5
    61aa:	c954                	sw	a3,20(a0)
    61ac:	00b70023          	sb	a1,0(a4)
    61b0:	4958                	lw	a4,20(a0)
    61b2:	4d1c                	lw	a5,24(a0)
    61b4:	00f71463          	bne	a4,a5,61bc <.L26>
    61b8:	ca9fd0ef          	jal	3e60 <__SEGGER_RTL_prin_flush>

000061bc <.L26>:
    61bc:	401c                	lw	a5,0(s0)
    61be:	40f2                	lw	ra,28(sp)
    61c0:	0785                	add	a5,a5,1
    61c2:	c01c                	sw	a5,0(s0)
    61c4:	4462                	lw	s0,24(sp)
    61c6:	6105                	add	sp,sp,32
    61c8:	8082                	ret

000061ca <.L24>:
    61ca:	4558                	lw	a4,12(a0)
    61cc:	c305                	beqz	a4,61ec <.L28>
    61ce:	4154                	lw	a3,4(a0)
    61d0:	00178613          	add	a2,a5,1
    61d4:	00d61463          	bne	a2,a3,61dc <.L29>
    61d8:	000107a3          	sb	zero,15(sp)

000061dc <.L29>:
    61dc:	fed7f0e3          	bgeu	a5,a3,61bc <.L26>
    61e0:	00f14683          	lbu	a3,15(sp)
    61e4:	973e                	add	a4,a4,a5
    61e6:	00d70023          	sb	a3,0(a4)
    61ea:	bfc9                	j	61bc <.L26>

000061ec <.L28>:
    61ec:	4518                	lw	a4,8(a0)
    61ee:	c305                	beqz	a4,620e <.L30>
    61f0:	4154                	lw	a3,4(a0)
    61f2:	00178613          	add	a2,a5,1
    61f6:	00d61463          	bne	a2,a3,61fe <.L31>
    61fa:	000107a3          	sb	zero,15(sp)

000061fe <.L31>:
    61fe:	fad7ffe3          	bgeu	a5,a3,61bc <.L26>
    6202:	078a                	sll	a5,a5,0x2
    6204:	973e                	add	a4,a4,a5
    6206:	00f14783          	lbu	a5,15(sp)
    620a:	c31c                	sw	a5,0(a4)
    620c:	bf45                	j	61bc <.L26>

0000620e <.L30>:
    620e:	5118                	lw	a4,32(a0)
    6210:	d755                	beqz	a4,61bc <.L26>
    6212:	4154                	lw	a3,4(a0)
    6214:	fad7f4e3          	bgeu	a5,a3,61bc <.L26>
    6218:	4605                	li	a2,1
    621a:	00f10593          	add	a1,sp,15
    621e:	9702                	jalr	a4
    6220:	bf71                	j	61bc <.L26>

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

00006222 <__SEGGER_RTL_print_padding>:
    6222:	1141                	add	sp,sp,-16
    6224:	c422                	sw	s0,8(sp)
    6226:	c226                	sw	s1,4(sp)
    6228:	c04a                	sw	s2,0(sp)
    622a:	c606                	sw	ra,12(sp)
    622c:	84aa                	mv	s1,a0
    622e:	892e                	mv	s2,a1
    6230:	8432                	mv	s0,a2

00006232 <.L37>:
    6232:	147d                	add	s0,s0,-1
    6234:	00045863          	bgez	s0,6244 <.L38>
    6238:	40b2                	lw	ra,12(sp)
    623a:	4422                	lw	s0,8(sp)
    623c:	4492                	lw	s1,4(sp)
    623e:	4902                	lw	s2,0(sp)
    6240:	0141                	add	sp,sp,16
    6242:	8082                	ret

00006244 <.L38>:
    6244:	85ca                	mv	a1,s2
    6246:	8526                	mv	a0,s1
    6248:	3f3d                	jal	6186 <__SEGGER_RTL_putc>
    624a:	b7e5                	j	6232 <.L37>

Disassembly of section .text.libc.vfprintf_l:

0000624c <vfprintf_l>:
    624c:	711d                	add	sp,sp,-96
    624e:	ce86                	sw	ra,92(sp)
    6250:	cca2                	sw	s0,88(sp)
    6252:	caa6                	sw	s1,84(sp)
    6254:	1080                	add	s0,sp,96
    6256:	c8ca                	sw	s2,80(sp)
    6258:	c6ce                	sw	s3,76(sp)
    625a:	8932                	mv	s2,a2
    625c:	fad42623          	sw	a3,-84(s0)
    6260:	89aa                	mv	s3,a0
    6262:	fab42423          	sw	a1,-88(s0)
    6266:	f24ff0ef          	jal	598a <__SEGGER_RTL_X_file_bufsize>
    626a:	fa842583          	lw	a1,-88(s0)
    626e:	00f50793          	add	a5,a0,15
    6272:	9bc1                	and	a5,a5,-16
    6274:	40f10133          	sub	sp,sp,a5
    6278:	84aa                	mv	s1,a0
    627a:	fb840513          	add	a0,s0,-72
    627e:	c1ffd0ef          	jal	3e9c <__SEGGER_RTL_init_prin_l>
    6282:	800007b7          	lui	a5,0x80000
    6286:	fac42603          	lw	a2,-84(s0)
    628a:	17fd                	add	a5,a5,-1 # 7fffffff <_extram_size+0x7dffffff>
    628c:	faf42e23          	sw	a5,-68(s0)
    6290:	000067b7          	lui	a5,0x6
    6294:	17a78793          	add	a5,a5,378 # 617a <__SEGGER_RTL_stream_write>
    6298:	85ca                	mv	a1,s2
    629a:	fb840513          	add	a0,s0,-72
    629e:	fc242423          	sw	sp,-56(s0)
    62a2:	fc942823          	sw	s1,-48(s0)
    62a6:	fd342e23          	sw	s3,-36(s0)
    62aa:	fcf42c23          	sw	a5,-40(s0)
    62ae:	2811                	jal	62c2 <__SEGGER_RTL_vfprintf>
    62b0:	fa040113          	add	sp,s0,-96
    62b4:	40f6                	lw	ra,92(sp)
    62b6:	4466                	lw	s0,88(sp)
    62b8:	44d6                	lw	s1,84(sp)
    62ba:	4946                	lw	s2,80(sp)
    62bc:	49b6                	lw	s3,76(sp)
    62be:	6125                	add	sp,sp,96
    62c0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

000062c2 <__SEGGER_RTL_vfprintf>:
    62c2:	7175                	add	sp,sp,-144
    62c4:	97420793          	add	a5,tp,-1676 # fffff974 <__AHB_SRAM_segment_end__+0xfdf7974>
    62c8:	c83e                	sw	a5,16(sp)
    62ca:	dece                	sw	s3,124(sp)
    62cc:	dad6                	sw	s5,116(sp)
    62ce:	ceee                	sw	s11,92(sp)
    62d0:	c706                	sw	ra,140(sp)
    62d2:	c522                	sw	s0,136(sp)
    62d4:	c326                	sw	s1,132(sp)
    62d6:	c14a                	sw	s2,128(sp)
    62d8:	dcd2                	sw	s4,120(sp)
    62da:	d8da                	sw	s6,112(sp)
    62dc:	d6de                	sw	s7,108(sp)
    62de:	d4e2                	sw	s8,104(sp)
    62e0:	d2e6                	sw	s9,100(sp)
    62e2:	d0ea                	sw	s10,96(sp)
    62e4:	9b820793          	add	a5,tp,-1608 # fffff9b8 <__AHB_SRAM_segment_end__+0xfdf79b8>
    62e8:	00020db7          	lui	s11,0x20
    62ec:	89aa                	mv	s3,a0
    62ee:	8ab2                	mv	s5,a2
    62f0:	00052023          	sw	zero,0(a0)
    62f4:	ca3e                	sw	a5,20(sp)
    62f6:	021d8d93          	add	s11,s11,33 # 20021 <__AHB_SRAM_segment_size__+0x18021>

000062fa <.L2>:
    62fa:	00158a13          	add	s4,a1,1 # 1000001 <_flash_size+0x1>
    62fe:	0005c583          	lbu	a1,0(a1)
    6302:	e19d                	bnez	a1,6328 <.L229>
    6304:	00c9a783          	lw	a5,12(s3)
    6308:	cb91                	beqz	a5,631c <.L230>
    630a:	0009a703          	lw	a4,0(s3)
    630e:	0049a683          	lw	a3,4(s3)
    6312:	00d77563          	bgeu	a4,a3,631c <.L230>
    6316:	97ba                	add	a5,a5,a4
    6318:	00078023          	sb	zero,0(a5)

0000631c <.L230>:
    631c:	854e                	mv	a0,s3
    631e:	b43fd0ef          	jal	3e60 <__SEGGER_RTL_prin_flush>
    6322:	0009a503          	lw	a0,0(s3)
    6326:	a2f9                	j	64f4 <.L338>

00006328 <.L229>:
    6328:	02500793          	li	a5,37
    632c:	00f58563          	beq	a1,a5,6336 <.L231>

00006330 <.L362>:
    6330:	854e                	mv	a0,s3
    6332:	3d91                	jal	6186 <__SEGGER_RTL_putc>
    6334:	aab9                	j	6492 <.L4>

00006336 <.L231>:
    6336:	4b81                	li	s7,0
    6338:	03000613          	li	a2,48
    633c:	05e00593          	li	a1,94
    6340:	6505                	lui	a0,0x1
    6342:	487d                	li	a6,31
    6344:	48c1                	li	a7,16
    6346:	6321                	lui	t1,0x8
    6348:	a03d                	j	6376 <.L3>

0000634a <.L5>:
    634a:	04b78f63          	beq	a5,a1,63a8 <.L15>

0000634e <.L232>:
    634e:	8a36                	mv	s4,a3
    6350:	4b01                	li	s6,0
    6352:	46a5                	li	a3,9
    6354:	45a9                	li	a1,10

00006356 <.L18>:
    6356:	fd078713          	add	a4,a5,-48
    635a:	0ff77613          	zext.b	a2,a4
    635e:	08c6e363          	bltu	a3,a2,63e4 <.L20>
    6362:	02bb0b33          	mul	s6,s6,a1
    6366:	0a05                	add	s4,s4,1
    6368:	fffa4783          	lbu	a5,-1(s4)
    636c:	9b3a                	add	s6,s6,a4
    636e:	b7e5                	j	6356 <.L18>

00006370 <.L14>:
    6370:	040beb93          	or	s7,s7,64

00006374 <.L16>:
    6374:	8a36                	mv	s4,a3

00006376 <.L3>:
    6376:	000a4783          	lbu	a5,0(s4)
    637a:	001a0693          	add	a3,s4,1
    637e:	fcf666e3          	bltu	a2,a5,634a <.L5>
    6382:	fcf876e3          	bgeu	a6,a5,634e <.L232>
    6386:	fe078713          	add	a4,a5,-32
    638a:	0ff77713          	zext.b	a4,a4
    638e:	02e8e963          	bltu	a7,a4,63c0 <.L7>
    6392:	4442                	lw	s0,16(sp)
    6394:	070a                	sll	a4,a4,0x2
    6396:	9722                	add	a4,a4,s0
    6398:	4318                	lw	a4,0(a4)
    639a:	8702                	jr	a4

0000639c <.L13>:
    639c:	080beb93          	or	s7,s7,128
    63a0:	bfd1                	j	6374 <.L16>

000063a2 <.L12>:
    63a2:	006bebb3          	or	s7,s7,t1
    63a6:	b7f9                	j	6374 <.L16>

000063a8 <.L15>:
    63a8:	00abebb3          	or	s7,s7,a0
    63ac:	b7e1                	j	6374 <.L16>

000063ae <.L11>:
    63ae:	020beb93          	or	s7,s7,32
    63b2:	b7c9                	j	6374 <.L16>

000063b4 <.L10>:
    63b4:	010beb93          	or	s7,s7,16
    63b8:	bf75                	j	6374 <.L16>

000063ba <.L8>:
    63ba:	200beb93          	or	s7,s7,512
    63be:	bf5d                	j	6374 <.L16>

000063c0 <.L7>:
    63c0:	02a00713          	li	a4,42
    63c4:	f8e795e3          	bne	a5,a4,634e <.L232>
    63c8:	000aab03          	lw	s6,0(s5)
    63cc:	004a8713          	add	a4,s5,4
    63d0:	000b5663          	bgez	s6,63dc <.L19>
    63d4:	41600b33          	neg	s6,s6
    63d8:	010beb93          	or	s7,s7,16

000063dc <.L19>:
    63dc:	0006c783          	lbu	a5,0(a3) # 800000 <__DLM_segment_end__+0x5c0000>
    63e0:	0a09                	add	s4,s4,2
    63e2:	8aba                	mv	s5,a4

000063e4 <.L20>:
    63e4:	000b5363          	bgez	s6,63ea <.L22>
    63e8:	4b01                	li	s6,0

000063ea <.L22>:
    63ea:	02e00713          	li	a4,46
    63ee:	4481                	li	s1,0
    63f0:	04e79263          	bne	a5,a4,6434 <.L23>
    63f4:	000a4783          	lbu	a5,0(s4)
    63f8:	02a00713          	li	a4,42
    63fc:	02e78263          	beq	a5,a4,6420 <.L24>
    6400:	0a05                	add	s4,s4,1
    6402:	46a5                	li	a3,9
    6404:	45a9                	li	a1,10

00006406 <.L25>:
    6406:	fd078713          	add	a4,a5,-48
    640a:	0ff77613          	zext.b	a2,a4
    640e:	00c6ef63          	bltu	a3,a2,642c <.L26>
    6412:	02b484b3          	mul	s1,s1,a1
    6416:	0a05                	add	s4,s4,1
    6418:	fffa4783          	lbu	a5,-1(s4)
    641c:	94ba                	add	s1,s1,a4
    641e:	b7e5                	j	6406 <.L25>

00006420 <.L24>:
    6420:	000aa483          	lw	s1,0(s5)
    6424:	001a4783          	lbu	a5,1(s4)
    6428:	0a91                	add	s5,s5,4
    642a:	0a09                	add	s4,s4,2

0000642c <.L26>:
    642c:	0004c463          	bltz	s1,6434 <.L23>
    6430:	100beb93          	or	s7,s7,256

00006434 <.L23>:
    6434:	06c00713          	li	a4,108
    6438:	06e78263          	beq	a5,a4,649c <.L28>
    643c:	02f76c63          	bltu	a4,a5,6474 <.L29>
    6440:	06800713          	li	a4,104
    6444:	06e78a63          	beq	a5,a4,64b8 <.L30>
    6448:	06a00713          	li	a4,106
    644c:	04e78563          	beq	a5,a4,6496 <.L31>

00006450 <.L32>:
    6450:	05700713          	li	a4,87
    6454:	2af760e3          	bltu	a4,a5,6ef4 <.L38>
    6458:	04500713          	li	a4,69
    645c:	2ce78563          	beq	a5,a4,6726 <.L39>
    6460:	06f76763          	bltu	a4,a5,64ce <.L40>
    6464:	c7c1                	beqz	a5,64ec <.L41>
    6466:	02500713          	li	a4,37
    646a:	02500593          	li	a1,37
    646e:	ece781e3          	beq	a5,a4,6330 <.L362>
    6472:	a005                	j	6492 <.L4>

00006474 <.L29>:
    6474:	07400713          	li	a4,116
    6478:	00e78663          	beq	a5,a4,6484 <.L346>
    647c:	07a00713          	li	a4,122
    6480:	26e796e3          	bne	a5,a4,6eec <.L34>

00006484 <.L346>:
    6484:	000a4783          	lbu	a5,0(s4)
    6488:	0a05                	add	s4,s4,1

0000648a <.L35>:
    648a:	07800713          	li	a4,120
    648e:	fcf771e3          	bgeu	a4,a5,6450 <.L32>

00006492 <.L4>:
    6492:	85d2                	mv	a1,s4
    6494:	b59d                	j	62fa <.L2>

00006496 <.L31>:
    6496:	002beb93          	or	s7,s7,2
    649a:	b7ed                	j	6484 <.L346>

0000649c <.L28>:
    649c:	000a4783          	lbu	a5,0(s4)
    64a0:	00e79863          	bne	a5,a4,64b0 <.L36>
    64a4:	002beb93          	or	s7,s7,2

000064a8 <.L347>:
    64a8:	001a4783          	lbu	a5,1(s4)
    64ac:	0a09                	add	s4,s4,2
    64ae:	bff1                	j	648a <.L35>

000064b0 <.L36>:
    64b0:	0a05                	add	s4,s4,1
    64b2:	001beb93          	or	s7,s7,1
    64b6:	bfd1                	j	648a <.L35>

000064b8 <.L30>:
    64b8:	000a4783          	lbu	a5,0(s4)
    64bc:	00e79563          	bne	a5,a4,64c6 <.L37>
    64c0:	008beb93          	or	s7,s7,8
    64c4:	b7d5                	j	64a8 <.L347>

000064c6 <.L37>:
    64c6:	0a05                	add	s4,s4,1
    64c8:	004beb93          	or	s7,s7,4
    64cc:	bf7d                	j	648a <.L35>

000064ce <.L40>:
    64ce:	04600713          	li	a4,70
    64d2:	2ce78263          	beq	a5,a4,6796 <.L57>
    64d6:	04700713          	li	a4,71
    64da:	fae79ce3          	bne	a5,a4,6492 <.L4>
    64de:	6789                	lui	a5,0x2
    64e0:	00fbebb3          	or	s7,s7,a5

000064e4 <.L52>:
    64e4:	6905                	lui	s2,0x1
    64e6:	c0090913          	add	s2,s2,-1024 # c00 <.LC20+0x10>
    64ea:	ac65                	j	67a2 <.L353>

000064ec <.L41>:
    64ec:	854e                	mv	a0,s3
    64ee:	973fd0ef          	jal	3e60 <__SEGGER_RTL_prin_flush>
    64f2:	557d                	li	a0,-1

000064f4 <.L338>:
    64f4:	40ba                	lw	ra,140(sp)
    64f6:	442a                	lw	s0,136(sp)
    64f8:	449a                	lw	s1,132(sp)
    64fa:	490a                	lw	s2,128(sp)
    64fc:	59f6                	lw	s3,124(sp)
    64fe:	5a66                	lw	s4,120(sp)
    6500:	5ad6                	lw	s5,116(sp)
    6502:	5b46                	lw	s6,112(sp)
    6504:	5bb6                	lw	s7,108(sp)
    6506:	5c26                	lw	s8,104(sp)
    6508:	5c96                	lw	s9,100(sp)
    650a:	5d06                	lw	s10,96(sp)
    650c:	4df6                	lw	s11,92(sp)
    650e:	6149                	add	sp,sp,144
    6510:	8082                	ret

00006512 <.L55>:
    6512:	000aa483          	lw	s1,0(s5)
    6516:	1b7d                	add	s6,s6,-1
    6518:	865a                	mv	a2,s6
    651a:	85de                	mv	a1,s7
    651c:	854e                	mv	a0,s3
    651e:	965fd0ef          	jal	3e82 <__SEGGER_RTL_pre_padding>
    6522:	004a8413          	add	s0,s5,4
    6526:	0ff4f593          	zext.b	a1,s1
    652a:	854e                	mv	a0,s3
    652c:	39a9                	jal	6186 <__SEGGER_RTL_putc>
    652e:	8aa2                	mv	s5,s0

00006530 <.L371>:
    6530:	010bfb93          	and	s7,s7,16
    6534:	f40b8fe3          	beqz	s7,6492 <.L4>
    6538:	865a                	mv	a2,s6
    653a:	02000593          	li	a1,32
    653e:	854e                	mv	a0,s3
    6540:	31cd                	jal	6222 <__SEGGER_RTL_print_padding>
    6542:	bf81                	j	6492 <.L4>

00006544 <.L50>:
    6544:	008bf693          	and	a3,s7,8
    6548:	000aa783          	lw	a5,0(s5)
    654c:	0009a703          	lw	a4,0(s3)
    6550:	0a91                	add	s5,s5,4
    6552:	c681                	beqz	a3,655a <.L62>
    6554:	00e78023          	sb	a4,0(a5) # 2000 <.L43>
    6558:	bf2d                	j	6492 <.L4>

0000655a <.L62>:
    655a:	002bfb93          	and	s7,s7,2
    655e:	c398                	sw	a4,0(a5)
    6560:	f20b89e3          	beqz	s7,6492 <.L4>
    6564:	0007a223          	sw	zero,4(a5)
    6568:	b72d                	j	6492 <.L4>

0000656a <.L47>:
    656a:	000aa403          	lw	s0,0(s5)
    656e:	895e                	mv	s2,s7
    6570:	0a91                	add	s5,s5,4

00006572 <.L65>:
    6572:	e019                	bnez	s0,6578 <.L66>
    6574:	a2418413          	add	s0,gp,-1500 # 394 <.LC0>

00006578 <.L66>:
    6578:	dff97b93          	and	s7,s2,-513
    657c:	10097913          	and	s2,s2,256
    6580:	02090563          	beqz	s2,65aa <.L67>
    6584:	85a6                	mv	a1,s1
    6586:	8522                	mv	a0,s0
    6588:	3ea9                	jal	60e2 <strnlen>

0000658a <.L348>:
    658a:	40ab0b33          	sub	s6,s6,a0
    658e:	84aa                	mv	s1,a0
    6590:	865a                	mv	a2,s6
    6592:	85de                	mv	a1,s7
    6594:	854e                	mv	a0,s3
    6596:	8edfd0ef          	jal	3e82 <__SEGGER_RTL_pre_padding>

0000659a <.L69>:
    659a:	d8d9                	beqz	s1,6530 <.L371>
    659c:	00044583          	lbu	a1,0(s0)
    65a0:	854e                	mv	a0,s3
    65a2:	0405                	add	s0,s0,1
    65a4:	36cd                	jal	6186 <__SEGGER_RTL_putc>
    65a6:	14fd                	add	s1,s1,-1
    65a8:	bfcd                	j	659a <.L69>

000065aa <.L67>:
    65aa:	8522                	mv	a0,s0
    65ac:	34f9                	jal	607a <strlen>
    65ae:	bff1                	j	658a <.L348>

000065b0 <.L48>:
    65b0:	080bf713          	and	a4,s7,128
    65b4:	000aa403          	lw	s0,0(s5)
    65b8:	004a8693          	add	a3,s5,4
    65bc:	4581                	li	a1,0
    65be:	02300c93          	li	s9,35
    65c2:	e311                	bnez	a4,65c6 <.L71>
    65c4:	4c81                	li	s9,0

000065c6 <.L71>:
    65c6:	100beb93          	or	s7,s7,256
    65ca:	8ab6                	mv	s5,a3
    65cc:	44a1                	li	s1,8

000065ce <.L72>:
    65ce:	100bf713          	and	a4,s7,256
    65d2:	e311                	bnez	a4,65d6 <.L203>
    65d4:	4485                	li	s1,1

000065d6 <.L203>:
    65d6:	05800713          	li	a4,88
    65da:	04e78ae3          	beq	a5,a4,6e2e <.L204>
    65de:	f9c78693          	add	a3,a5,-100
    65e2:	4705                	li	a4,1
    65e4:	00d71733          	sll	a4,a4,a3
    65e8:	01b776b3          	and	a3,a4,s11
    65ec:	7c069c63          	bnez	a3,6dc4 <.L205>
    65f0:	00c75693          	srl	a3,a4,0xc
    65f4:	1016f693          	and	a3,a3,257
    65f8:	02069be3          	bnez	a3,6e2e <.L204>
    65fc:	06f00713          	li	a4,111
    6600:	4c01                	li	s8,0
    6602:	04e791e3          	bne	a5,a4,6e44 <.L206>

00006606 <.L207>:
    6606:	00b467b3          	or	a5,s0,a1
    660a:	02078de3          	beqz	a5,6e44 <.L206>
    660e:	183c                	add	a5,sp,56
    6610:	01878733          	add	a4,a5,s8
    6614:	00747793          	and	a5,s0,7
    6618:	03078793          	add	a5,a5,48
    661c:	00f70023          	sb	a5,0(a4)
    6620:	800d                	srl	s0,s0,0x3
    6622:	01d59793          	sll	a5,a1,0x1d
    6626:	0c05                	add	s8,s8,1
    6628:	8c5d                	or	s0,s0,a5
    662a:	818d                	srl	a1,a1,0x3
    662c:	bfe9                	j	6606 <.L207>

0000662e <.L56>:
    662e:	6709                	lui	a4,0x2
    6630:	00ebebb3          	or	s7,s7,a4

00006634 <.L44>:
    6634:	080bf713          	and	a4,s7,128
    6638:	4c81                	li	s9,0
    663a:	cb19                	beqz	a4,6650 <.L75>
    663c:	6c8d                	lui	s9,0x3
    663e:	07800713          	li	a4,120
    6642:	058c8c93          	add	s9,s9,88 # 3058 <.L__addsf3_sub_already_ordered+0x32>
    6646:	00e79563          	bne	a5,a4,6650 <.L75>
    664a:	6c8d                	lui	s9,0x3
    664c:	078c8c93          	add	s9,s9,120 # 3078 <.L__addsf3_exponents_equal+0x8>

00006650 <.L75>:
    6650:	100bf713          	and	a4,s7,256

00006654 <.L365>:
    6654:	c319                	beqz	a4,665a <.L74>
    6656:	dffbfb93          	and	s7,s7,-513

0000665a <.L74>:
    665a:	011b9613          	sll	a2,s7,0x11
    665e:	002bf713          	and	a4,s7,2
    6662:	004bf693          	and	a3,s7,4
    6666:	08065563          	bgez	a2,66f0 <.L76>
    666a:	cf31                	beqz	a4,66c6 <.L77>
    666c:	007a8713          	add	a4,s5,7
    6670:	9b61                	and	a4,a4,-8
    6672:	4300                	lw	s0,0(a4)
    6674:	434c                	lw	a1,4(a4)
    6676:	00870a93          	add	s5,a4,8 # 2008 <.L43+0x8>

0000667a <.L78>:
    667a:	cea1                	beqz	a3,66d2 <.L79>
    667c:	0442                	sll	s0,s0,0x10
    667e:	8441                	sra	s0,s0,0x10

00006680 <.L351>:
    6680:	41f45593          	sra	a1,s0,0x1f

00006684 <.L80>:
    6684:	0405dd63          	bgez	a1,66de <.L82>
    6688:	00803733          	snez	a4,s0
    668c:	40b005b3          	neg	a1,a1
    6690:	8d99                	sub	a1,a1,a4
    6692:	40800433          	neg	s0,s0
    6696:	02d00c93          	li	s9,45

0000669a <.L84>:
    669a:	100bf713          	and	a4,s7,256
    669e:	db05                	beqz	a4,65ce <.L72>
    66a0:	dffbfb93          	and	s7,s7,-513
    66a4:	b72d                	j	65ce <.L72>

000066a6 <.L49>:
    66a6:	080bf713          	and	a4,s7,128
    66aa:	03000c93          	li	s9,48
    66ae:	f34d                	bnez	a4,6650 <.L75>
    66b0:	4c81                	li	s9,0
    66b2:	bf79                	j	6650 <.L75>

000066b4 <.L46>:
    66b4:	100bf713          	and	a4,s7,256
    66b8:	4c81                	li	s9,0
    66ba:	bf69                	j	6654 <.L365>

000066bc <.L51>:
    66bc:	6711                	lui	a4,0x4
    66be:	00ebebb3          	or	s7,s7,a4
    66c2:	4c81                	li	s9,0
    66c4:	bf59                	j	665a <.L74>

000066c6 <.L77>:
    66c6:	000aa403          	lw	s0,0(s5)
    66ca:	0a91                	add	s5,s5,4
    66cc:	41f45593          	sra	a1,s0,0x1f
    66d0:	b76d                	j	667a <.L78>

000066d2 <.L79>:
    66d2:	008bf713          	and	a4,s7,8
    66d6:	d75d                	beqz	a4,6684 <.L80>
    66d8:	0462                	sll	s0,s0,0x18
    66da:	8461                	sra	s0,s0,0x18
    66dc:	b755                	j	6680 <.L351>

000066de <.L82>:
    66de:	020bf713          	and	a4,s7,32
    66e2:	ef1d                	bnez	a4,6720 <.L239>
    66e4:	040bf713          	and	a4,s7,64
    66e8:	db4d                	beqz	a4,669a <.L84>
    66ea:	02000c93          	li	s9,32
    66ee:	b775                	j	669a <.L84>

000066f0 <.L76>:
    66f0:	cf09                	beqz	a4,670a <.L85>
    66f2:	007a8713          	add	a4,s5,7
    66f6:	9b61                	and	a4,a4,-8
    66f8:	4300                	lw	s0,0(a4)
    66fa:	434c                	lw	a1,4(a4)
    66fc:	00870a93          	add	s5,a4,8 # 4008 <__HEAPSIZE__+0x8>

00006700 <.L86>:
    6700:	ca91                	beqz	a3,6714 <.L87>
    6702:	0442                	sll	s0,s0,0x10
    6704:	8041                	srl	s0,s0,0x10

00006706 <.L352>:
    6706:	4581                	li	a1,0
    6708:	bf49                	j	669a <.L84>

0000670a <.L85>:
    670a:	000aa403          	lw	s0,0(s5)
    670e:	4581                	li	a1,0
    6710:	0a91                	add	s5,s5,4
    6712:	b7fd                	j	6700 <.L86>

00006714 <.L87>:
    6714:	008bf713          	and	a4,s7,8
    6718:	d349                	beqz	a4,669a <.L84>
    671a:	0ff47413          	zext.b	s0,s0
    671e:	b7e5                	j	6706 <.L352>

00006720 <.L239>:
    6720:	02b00c93          	li	s9,43
    6724:	bf9d                	j	669a <.L84>

00006726 <.L39>:
    6726:	6789                	lui	a5,0x2
    6728:	00fbebb3          	or	s7,s7,a5

0000672c <.L54>:
    672c:	400be913          	or	s2,s7,1024

00006730 <.L91>:
    6730:	00297793          	and	a5,s2,2
    6734:	cbb5                	beqz	a5,67a8 <.L92>
    6736:	000aa783          	lw	a5,0(s5)
    673a:	1008                	add	a0,sp,32
    673c:	004a8413          	add	s0,s5,4
    6740:	4398                	lw	a4,0(a5)
    6742:	8aa2                	mv	s5,s0
    6744:	d03a                	sw	a4,32(sp)
    6746:	43d8                	lw	a4,4(a5)
    6748:	d23a                	sw	a4,36(sp)
    674a:	4798                	lw	a4,8(a5)
    674c:	d43a                	sw	a4,40(sp)
    674e:	47dc                	lw	a5,12(a5)
    6750:	d63e                	sw	a5,44(sp)
    6752:	f28ff0ef          	jal	5e7a <__trunctfsf2>
    6756:	8baa                	mv	s7,a0

00006758 <.L93>:
    6758:	10097793          	and	a5,s2,256
    675c:	c3ad                	beqz	a5,67be <.L240>
    675e:	e889                	bnez	s1,6770 <.L94>
    6760:	6785                	lui	a5,0x1
    6762:	c0078793          	add	a5,a5,-1024 # c00 <.LC20+0x10>
    6766:	00f974b3          	and	s1,s2,a5
    676a:	8c9d                	sub	s1,s1,a5
    676c:	0014b493          	seqz	s1,s1

00006770 <.L94>:
    6770:	855e                	mv	a0,s7
    6772:	ceffc0ef          	jal	3460 <__SEGGER_RTL_float32_isinf>
    6776:	c531                	beqz	a0,67c2 <.L95>

00006778 <.L117>:
    6778:	6409                	lui	s0,0x2
    677a:	00000593          	li	a1,0
    677e:	855e                	mv	a0,s7
    6780:	00897433          	and	s0,s2,s0
    6784:	9a5fc0ef          	jal	3128 <__ltsf2>
    6788:	3e055963          	bgez	a0,6b7a <.L341>
    678c:	3e040463          	beqz	s0,6b74 <.L244>
    6790:	a2c18413          	add	s0,gp,-1492 # 39c <.LC1>
    6794:	a089                	j	67d6 <.L122>

00006796 <.L57>:
    6796:	6789                	lui	a5,0x2
    6798:	00fbebb3          	or	s7,s7,a5

0000679c <.L53>:
    679c:	6905                	lui	s2,0x1
    679e:	80090913          	add	s2,s2,-2048 # 800 <board_timer_isr+0x24>

000067a2 <.L353>:
    67a2:	012be933          	or	s2,s7,s2
    67a6:	b769                	j	6730 <.L91>

000067a8 <.L92>:
    67a8:	007a8793          	add	a5,s5,7
    67ac:	9be1                	and	a5,a5,-8
    67ae:	4388                	lw	a0,0(a5)
    67b0:	43cc                	lw	a1,4(a5)
    67b2:	00878a93          	add	s5,a5,8 # 2008 <.L43+0x8>
    67b6:	b99fc0ef          	jal	334e <__truncdfsf2>
    67ba:	8baa                	mv	s7,a0
    67bc:	bf71                	j	6758 <.L93>

000067be <.L240>:
    67be:	4499                	li	s1,6
    67c0:	bf45                	j	6770 <.L94>

000067c2 <.L95>:
    67c2:	855e                	mv	a0,s7
    67c4:	c8bfc0ef          	jal	344e <__SEGGER_RTL_float32_isnan>
    67c8:	cd09                	beqz	a0,67e2 <.L101>
    67ca:	01291793          	sll	a5,s2,0x12
    67ce:	0007d763          	bgez	a5,67dc <.L243>
    67d2:	a4c18413          	add	s0,gp,-1460 # 3bc <.LC5>

000067d6 <.L122>:
    67d6:	eff97913          	and	s2,s2,-257
    67da:	bb61                	j	6572 <.L65>

000067dc <.L243>:
    67dc:	a5018413          	add	s0,gp,-1456 # 3c0 <.LC6>
    67e0:	bfdd                	j	67d6 <.L122>

000067e2 <.L101>:
    67e2:	855e                	mv	a0,s7
    67e4:	c8bfc0ef          	jal	346e <__SEGGER_RTL_float32_isnormal>
    67e8:	e119                	bnez	a0,67ee <.L103>
    67ea:	00000b93          	li	s7,0

000067ee <.L103>:
    67ee:	855e                	mv	a0,s7
    67f0:	845e                	mv	s0,s7
    67f2:	eacff0ef          	jal	5e9e <__SEGGER_RTL_float32_signbit>
    67f6:	c519                	beqz	a0,6804 <.L104>
    67f8:	80000437          	lui	s0,0x80000
    67fc:	06096913          	or	s2,s2,96
    6800:	01744433          	xor	s0,s0,s7

00006804 <.L104>:
    6804:	184c                	add	a1,sp,52
    6806:	8522                	mv	a0,s0
    6808:	edeff0ef          	jal	5ee6 <frexpf>
    680c:	5752                	lw	a4,52(sp)
    680e:	478d                	li	a5,3
    6810:	00000593          	li	a1,0
    6814:	02e787b3          	mul	a5,a5,a4
    6818:	4729                	li	a4,10
    681a:	8522                	mv	a0,s0
    681c:	8ba2                	mv	s7,s0
    681e:	02e7c7b3          	div	a5,a5,a4
    6822:	da3e                	sw	a5,52(sp)
    6824:	dcaff0ef          	jal	5dee <__eqsf2>
    6828:	24051063          	bnez	a0,6a68 <.L105>

0000682c <.L111>:
    682c:	6785                	lui	a5,0x1
    682e:	c0078793          	add	a5,a5,-1024 # c00 <.LC20+0x10>
    6832:	00f97c33          	and	s8,s2,a5
    6836:	40000713          	li	a4,1024
    683a:	5552                	lw	a0,52(sp)
    683c:	24ec1d63          	bne	s8,a4,6a96 <.L340>

00006840 <.L106>:
    6840:	02600793          	li	a5,38
    6844:	30f51f63          	bne	a0,a5,6b62 <.L113>
    6848:	b2422583          	lw	a1,-1244(tp) # fffffb24 <__AHB_SRAM_segment_end__+0xfdf7b24>
    684c:	855e                	mv	a0,s7
    684e:	ae0ff0ef          	jal	5b2e <__divsf3>

00006852 <.L354>:
    6852:	00000593          	li	a1,0
    6856:	8baa                	mv	s7,a0
    6858:	842a                	mv	s0,a0
    685a:	d94ff0ef          	jal	5dee <__eqsf2>
    685e:	cd39                	beqz	a0,68bc <.L116>
    6860:	855e                	mv	a0,s7
    6862:	bfffc0ef          	jal	3460 <__SEGGER_RTL_float32_isinf>
    6866:	f00519e3          	bnez	a0,6778 <.L117>
    686a:	57d2                	lw	a5,52(sp)
    686c:	4701                	li	a4,0

0000686e <.L118>:
    686e:	c63e                	sw	a5,12(sp)
    6870:	00178d13          	add	s10,a5,1
    6874:	b1c22583          	lw	a1,-1252(tp) # fffffb1c <__AHB_SRAM_segment_end__+0xfdf7b1c>
    6878:	855e                	mv	a0,s7
    687a:	cc3a                	sw	a4,24(sp)
    687c:	94ffc0ef          	jal	31ca <__gesf2>
    6880:	47b2                	lw	a5,12(sp)
    6882:	4762                	lw	a4,24(sp)
    6884:	30055763          	bgez	a0,6b92 <.L124>
    6888:	c319                	beqz	a4,688e <.L125>
    688a:	845e                	mv	s0,s7
    688c:	da3e                	sw	a5,52(sp)

0000688e <.L125>:
    688e:	b1822703          	lw	a4,-1256(tp) # fffffb18 <__AHB_SRAM_segment_end__+0xfdf7b18>
    6892:	5d52                	lw	s10,52(sp)
    6894:	b1c22c83          	lw	s9,-1252(tp) # fffffb1c <__AHB_SRAM_segment_end__+0xfdf7b1c>
    6898:	87a2                	mv	a5,s0
    689a:	4681                	li	a3,0
    689c:	c63a                	sw	a4,12(sp)

0000689e <.L126>:
    689e:	45b2                	lw	a1,12(sp)
    68a0:	853e                	mv	a0,a5
    68a2:	ce36                	sw	a3,28(sp)
    68a4:	cc3e                	sw	a5,24(sp)
    68a6:	883fc0ef          	jal	3128 <__ltsf2>
    68aa:	47e2                	lw	a5,24(sp)
    68ac:	46f2                	lw	a3,28(sp)
    68ae:	fffd0b93          	add	s7,s10,-1
    68b2:	2e054963          	bltz	a0,6ba4 <.L127>
    68b6:	c299                	beqz	a3,68bc <.L116>
    68b8:	843e                	mv	s0,a5
    68ba:	da6a                	sw	s10,52(sp)

000068bc <.L116>:
    68bc:	c499                	beqz	s1,68ca <.L129>
    68be:	6785                	lui	a5,0x1
    68c0:	c0078793          	add	a5,a5,-1024 # c00 <.LC20+0x10>
    68c4:	00fc1363          	bne	s8,a5,68ca <.L129>
    68c8:	14fd                	add	s1,s1,-1

000068ca <.L129>:
    68ca:	40900533          	neg	a0,s1
    68ce:	d40fd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    68d2:	55fd                	li	a1,-1
    68d4:	dceff0ef          	jal	5ea2 <ldexpf>
    68d8:	85a2                	mv	a1,s0
    68da:	ea0fc0ef          	jal	2f7a <__addsf3>
    68de:	b1c22583          	lw	a1,-1252(tp) # fffffb1c <__AHB_SRAM_segment_end__+0xfdf7b1c>
    68e2:	8baa                	mv	s7,a0
    68e4:	842a                	mv	s0,a0
    68e6:	8e5fc0ef          	jal	31ca <__gesf2>
    68ea:	00054b63          	bltz	a0,6900 <.L130>
    68ee:	57d2                	lw	a5,52(sp)
    68f0:	b1c22583          	lw	a1,-1252(tp) # fffffb1c <__AHB_SRAM_segment_end__+0xfdf7b1c>
    68f4:	855e                	mv	a0,s7
    68f6:	0785                	add	a5,a5,1
    68f8:	da3e                	sw	a5,52(sp)
    68fa:	a34ff0ef          	jal	5b2e <__divsf3>
    68fe:	842a                	mv	s0,a0

00006900 <.L130>:
    6900:	c622                	sw	s0,12(sp)
    6902:	2a049963          	bnez	s1,6bb4 <.L132>

00006906 <.L135>:
    6906:	4481                	li	s1,0

00006908 <.L133>:
    6908:	00548793          	add	a5,s1,5
    690c:	7c7d                	lui	s8,0xfffff
    690e:	40fb0b33          	sub	s6,s6,a5
    6912:	08097793          	and	a5,s2,128
    6916:	7ffc0c13          	add	s8,s8,2047 # fffff7ff <__AHB_SRAM_segment_end__+0xfdf77ff>
    691a:	8fc5                	or	a5,a5,s1
    691c:	01897c33          	and	s8,s2,s8
    6920:	c391                	beqz	a5,6924 <.L139>
    6922:	1b7d                	add	s6,s6,-1

00006924 <.L139>:
    6924:	01391793          	sll	a5,s2,0x13
    6928:	4d05                	li	s10,1
    692a:	0207dc63          	bgez	a5,6962 <.L140>
    692e:	5bd2                	lw	s7,52(sp)
    6930:	470d                	li	a4,3
    6932:	02ebe733          	rem	a4,s7,a4
    6936:	c31d                	beqz	a4,695c <.L141>
    6938:	0709                	add	a4,a4,2
    693a:	56b5                	li	a3,-19
    693c:	40e6d733          	sra	a4,a3,a4
    6940:	8b05                	and	a4,a4,1
    6942:	2c070663          	beqz	a4,6c0e <.L142>
    6946:	b1c22583          	lw	a1,-1252(tp) # fffffb1c <__AHB_SRAM_segment_end__+0xfdf7b1c>
    694a:	4532                	lw	a0,12(sp)
    694c:	1b7d                	add	s6,s6,-1
    694e:	4d09                	li	s10,2
    6950:	92eff0ef          	jal	5a7e <__mulsf3>
    6954:	fffb8793          	add	a5,s7,-1
    6958:	842a                	mv	s0,a0
    695a:	da3e                	sw	a5,52(sp)

0000695c <.L141>:
    695c:	0004d363          	bgez	s1,6962 <.L140>
    6960:	4481                	li	s1,0

00006962 <.L140>:
    6962:	06097913          	and	s2,s2,96
    6966:	00090363          	beqz	s2,696c <.L144>
    696a:	1b7d                	add	s6,s6,-1

0000696c <.L144>:
    696c:	5552                	lw	a0,52(sp)
    696e:	beafd0ef          	jal	3d58 <abs>
    6972:	06300793          	li	a5,99
    6976:	00a7d363          	bge	a5,a0,697c <.L145>
    697a:	1b7d                	add	s6,s6,-1

0000697c <.L145>:
    697c:	8522                	mv	a0,s0
    697e:	c9cff0ef          	jal	5e1a <__fixunssfdi>
    6982:	8bae                	mv	s7,a1
    6984:	8caa                	mv	s9,a0
    6986:	8d9fc0ef          	jal	325e <__floatundisf>
    698a:	85aa                	mv	a1,a0
    698c:	8522                	mv	a0,s0
    698e:	de4fc0ef          	jal	2f72 <__subsf3>
    6992:	842a                	mv	s0,a0

00006994 <.L146>:
    6994:	895a                	mv	s2,s6
    6996:	000b5363          	bgez	s6,699c <.L165>
    699a:	4901                	li	s2,0

0000699c <.L165>:
    699c:	210c7793          	and	a5,s8,528
    69a0:	e399                	bnez	a5,69a6 <.L167>

000069a2 <.L166>:
    69a2:	2e091d63          	bnez	s2,6c9c <.L168>

000069a6 <.L167>:
    69a6:	020c7713          	and	a4,s8,32
    69aa:	040c7793          	and	a5,s8,64
    69ae:	2e070e63          	beqz	a4,6caa <.L169>
    69b2:	02b00593          	li	a1,43
    69b6:	c399                	beqz	a5,69bc <.L358>
    69b8:	02d00593          	li	a1,45

000069bc <.L358>:
    69bc:	854e                	mv	a0,s3
    69be:	fc8ff0ef          	jal	6186 <__SEGGER_RTL_putc>

000069c2 <.L171>:
    69c2:	010c7793          	and	a5,s8,16
    69c6:	e399                	bnez	a5,69cc <.L173>

000069c8 <.L172>:
    69c8:	2e091663          	bnez	s2,6cb4 <.L174>

000069cc <.L173>:
    69cc:	00000b37          	lui	s6,0x0
    69d0:	148b0b13          	add	s6,s6,328 # 148 <__SEGGER_RTL_ipow10>

000069d4 <.L178>:
    69d4:	1d7d                	add	s10,s10,-1
    69d6:	003d1793          	sll	a5,s10,0x3
    69da:	97da                	add	a5,a5,s6
    69dc:	4398                	lw	a4,0(a5)
    69de:	43dc                	lw	a5,4(a5)
    69e0:	03000593          	li	a1,48

000069e4 <.L175>:
    69e4:	00fbe663          	bltu	s7,a5,69f0 <.L258>
    69e8:	2d779d63          	bne	a5,s7,6cc2 <.L176>
    69ec:	2cecfb63          	bgeu	s9,a4,6cc2 <.L176>

000069f0 <.L258>:
    69f0:	854e                	mv	a0,s3
    69f2:	f94ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    69f6:	fc0d1fe3          	bnez	s10,69d4 <.L178>
    69fa:	6b85                	lui	s7,0x1
    69fc:	800b8b93          	add	s7,s7,-2048 # 800 <board_timer_isr+0x24>
    6a00:	017c7bb3          	and	s7,s8,s7
    6a04:	2e0b9363          	bnez	s7,6cea <.L179>

00006a08 <.L183>:
    6a08:	080c7793          	and	a5,s8,128
    6a0c:	8fc5                	or	a5,a5,s1
    6a0e:	c3a1                	beqz	a5,6a4e <.L181>
    6a10:	02e00593          	li	a1,46
    6a14:	854e                	mv	a0,s3
    6a16:	f70ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6a1a:	47c1                	li	a5,16
    6a1c:	8ca6                	mv	s9,s1
    6a1e:	2c97da63          	bge	a5,s1,6cf2 <.L186>
    6a22:	4cc1                	li	s9,16

00006a24 <.L187>:
    6a24:	419484b3          	sub	s1,s1,s9
    6a28:	8566                	mv	a0,s9
    6a2a:	000b8563          	beqz	s7,6a34 <.L359>
    6a2e:	5552                	lw	a0,52(sp)
    6a30:	40ac8533          	sub	a0,s9,a0

00006a34 <.L359>:
    6a34:	bdafd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6a38:	85a2                	mv	a1,s0
    6a3a:	844ff0ef          	jal	5a7e <__mulsf3>
    6a3e:	bdcff0ef          	jal	5e1a <__fixunssfdi>
    6a42:	8baa                	mv	s7,a0
    6a44:	842e                	mv	s0,a1

00006a46 <.L193>:
    6a46:	2a0c9a63          	bnez	s9,6cfa <.L194>

00006a4a <.L195>:
    6a4a:	2e049563          	bnez	s1,6d34 <.L196>

00006a4e <.L181>:
    6a4e:	400c7793          	and	a5,s8,1024
    6a52:	2e079863          	bnez	a5,6d42 <.L184>

00006a56 <.L201>:
    6a56:	a2090ee3          	beqz	s2,6492 <.L4>
    6a5a:	197d                	add	s2,s2,-1
    6a5c:	02000593          	li	a1,32
    6a60:	ae81                	j	6db0 <.L360>

00006a62 <.L108>:
    6a62:	57d2                	lw	a5,52(sp)
    6a64:	0785                	add	a5,a5,1
    6a66:	da3e                	sw	a5,52(sp)

00006a68 <.L105>:
    6a68:	5552                	lw	a0,52(sp)
    6a6a:	0505                	add	a0,a0,1 # 1001 <__SEGGER_RTL_Moeller_inverse_lut+0x11d>
    6a6c:	ba2fd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6a70:	85aa                	mv	a1,a0
    6a72:	855e                	mv	a0,s7
    6a74:	f24fc0ef          	jal	3198 <__gtsf2>
    6a78:	fea045e3          	bgtz	a0,6a62 <.L108>

00006a7c <.L109>:
    6a7c:	5552                	lw	a0,52(sp)
    6a7e:	b90fd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6a82:	85aa                	mv	a1,a0
    6a84:	855e                	mv	a0,s7
    6a86:	ea2fc0ef          	jal	3128 <__ltsf2>
    6a8a:	da0551e3          	bgez	a0,682c <.L111>
    6a8e:	57d2                	lw	a5,52(sp)
    6a90:	17fd                	add	a5,a5,-1
    6a92:	da3e                	sw	a5,52(sp)
    6a94:	b7e5                	j	6a7c <.L109>

00006a96 <.L340>:
    6a96:	00fc1763          	bne	s8,a5,6aa4 <.L112>
    6a9a:	da9553e3          	bge	a0,s1,6840 <.L106>
    6a9e:	57f1                	li	a5,-4
    6aa0:	0cf54163          	blt	a0,a5,6b62 <.L113>

00006aa4 <.L112>:
    6aa4:	08097793          	and	a5,s2,128
    6aa8:	c63e                	sw	a5,12(sp)
    6aaa:	40097793          	and	a5,s2,1024
    6aae:	c789                	beqz	a5,6ab8 <.L147>
    6ab0:	47b9                	li	a5,14
    6ab2:	16a7da63          	bge	a5,a0,6c26 <.L148>

00006ab6 <.L153>:
    6ab6:	4481                	li	s1,0

00006ab8 <.L147>:
    6ab8:	57d2                	lw	a5,52(sp)
    6aba:	40900533          	neg	a0,s1
    6abe:	bff97c13          	and	s8,s2,-1025
    6ac2:	ff178713          	add	a4,a5,-15
    6ac6:	00e55463          	bge	a0,a4,6ace <.L154>
    6aca:	ff078513          	add	a0,a5,-16

00006ace <.L154>:
    6ace:	b40fd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6ad2:	55fd                	li	a1,-1
    6ad4:	bceff0ef          	jal	5ea2 <ldexpf>
    6ad8:	85aa                	mv	a1,a0
    6ada:	855e                	mv	a0,s7
    6adc:	c9efc0ef          	jal	2f7a <__addsf3>
    6ae0:	8d2a                	mv	s10,a0
    6ae2:	842a                	mv	s0,a0
    6ae4:	5552                	lw	a0,52(sp)
    6ae6:	0505                	add	a0,a0,1
    6ae8:	b26fd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6aec:	85ea                	mv	a1,s10
    6aee:	e74fc0ef          	jal	3162 <__lesf2>
    6af2:	00a04563          	bgtz	a0,6afc <.L156>
    6af6:	57d2                	lw	a5,52(sp)
    6af8:	0785                	add	a5,a5,1
    6afa:	da3e                	sw	a5,52(sp)

00006afc <.L156>:
    6afc:	57d2                	lw	a5,52(sp)
    6afe:	1807c963          	bltz	a5,6c90 <.L158>
    6b02:	4541                	li	a0,16
    6b04:	16f55863          	bge	a0,a5,6c74 <.L159>
    6b08:	ff078713          	add	a4,a5,-16
    6b0c:	8d1d                	sub	a0,a0,a5
    6b0e:	da3a                	sw	a4,52(sp)
    6b10:	afefd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6b14:	85ea                	mv	a1,s10
    6b16:	f69fe0ef          	jal	5a7e <__mulsf3>
    6b1a:	b00ff0ef          	jal	5e1a <__fixunssfdi>
    6b1e:	8caa                	mv	s9,a0
    6b20:	8bae                	mv	s7,a1
    6b22:	00000413          	li	s0,0

00006b26 <.L160>:
    6b26:	000007b7          	lui	a5,0x0
    6b2a:	14878793          	add	a5,a5,328 # 148 <__SEGGER_RTL_ipow10>
    6b2e:	4d05                	li	s10,1

00006b30 <.L161>:
    6b30:	47d8                	lw	a4,12(a5)
    6b32:	07a1                	add	a5,a5,8
    6b34:	00ebe763          	bltu	s7,a4,6b42 <.L257>
    6b38:	17771063          	bne	a4,s7,6c98 <.L162>
    6b3c:	4398                	lw	a4,0(a5)
    6b3e:	14ecfd63          	bgeu	s9,a4,6c98 <.L162>

00006b42 <.L257>:
    6b42:	5752                	lw	a4,52(sp)
    6b44:	009d07b3          	add	a5,s10,s1
    6b48:	97ba                	add	a5,a5,a4
    6b4a:	40fb0b33          	sub	s6,s6,a5
    6b4e:	47b2                	lw	a5,12(sp)
    6b50:	8fc5                	or	a5,a5,s1
    6b52:	c391                	beqz	a5,6b56 <.L164>
    6b54:	1b7d                	add	s6,s6,-1

00006b56 <.L164>:
    6b56:	06097793          	and	a5,s2,96
    6b5a:	e2078de3          	beqz	a5,6994 <.L146>
    6b5e:	1b7d                	add	s6,s6,-1
    6b60:	bd15                	j	6994 <.L146>

00006b62 <.L113>:
    6b62:	40a00533          	neg	a0,a0
    6b66:	aa8fd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6b6a:	85aa                	mv	a1,a0
    6b6c:	855e                	mv	a0,s7
    6b6e:	f11fe0ef          	jal	5a7e <__mulsf3>
    6b72:	b1c5                	j	6852 <.L354>

00006b74 <.L244>:
    6b74:	a3418413          	add	s0,gp,-1484 # 3a4 <.LC2>
    6b78:	b9b9                	j	67d6 <.L122>

00006b7a <.L341>:
    6b7a:	c809                	beqz	s0,6b8c <.L245>
    6b7c:	a3c18413          	add	s0,gp,-1476 # 3ac <.LC3>

00006b80 <.L123>:
    6b80:	02097793          	and	a5,s2,32
    6b84:	c40799e3          	bnez	a5,67d6 <.L122>
    6b88:	0405                	add	s0,s0,1 # 80000001 <_extram_size+0x7e000001>
    6b8a:	b1b1                	j	67d6 <.L122>

00006b8c <.L245>:
    6b8c:	a4418413          	add	s0,gp,-1468 # 3b4 <.LC4>
    6b90:	bfc5                	j	6b80 <.L123>

00006b92 <.L124>:
    6b92:	b1c22583          	lw	a1,-1252(tp) # fffffb1c <__AHB_SRAM_segment_end__+0xfdf7b1c>
    6b96:	855e                	mv	a0,s7
    6b98:	f97fe0ef          	jal	5b2e <__divsf3>
    6b9c:	8baa                	mv	s7,a0
    6b9e:	87ea                	mv	a5,s10
    6ba0:	4705                	li	a4,1
    6ba2:	b1f1                	j	686e <.L118>

00006ba4 <.L127>:
    6ba4:	853e                	mv	a0,a5
    6ba6:	85e6                	mv	a1,s9
    6ba8:	ed7fe0ef          	jal	5a7e <__mulsf3>
    6bac:	87aa                	mv	a5,a0
    6bae:	8d5e                	mv	s10,s7
    6bb0:	4685                	li	a3,1
    6bb2:	b1f5                	j	689e <.L126>

00006bb4 <.L132>:
    6bb4:	6785                	lui	a5,0x1
    6bb6:	88078793          	add	a5,a5,-1920 # 880 <default_isr_26+0x76>
    6bba:	00f977b3          	and	a5,s2,a5
    6bbe:	80078793          	add	a5,a5,-2048
    6bc2:	d40793e3          	bnez	a5,6908 <.L133>
    6bc6:	47c1                	li	a5,16
    6bc8:	0097d363          	bge	a5,s1,6bce <.L134>
    6bcc:	44c1                	li	s1,16

00006bce <.L134>:
    6bce:	8526                	mv	a0,s1
    6bd0:	a3efd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6bd4:	85a2                	mv	a1,s0
    6bd6:	ea9fe0ef          	jal	5a7e <__mulsf3>
    6bda:	a40ff0ef          	jal	5e1a <__fixunssfdi>
    6bde:	00a5e7b3          	or	a5,a1,a0
    6be2:	8c2a                	mv	s8,a0
    6be4:	8d2e                	mv	s10,a1
    6be6:	d20780e3          	beqz	a5,6906 <.L135>

00006bea <.L357>:
    6bea:	4629                	li	a2,10
    6bec:	4681                	li	a3,0
    6bee:	d37fc0ef          	jal	3924 <__umoddi3>
    6bf2:	8d4d                	or	a0,a0,a1
    6bf4:	d0051ae3          	bnez	a0,6908 <.L133>
    6bf8:	8562                	mv	a0,s8
    6bfa:	85ea                	mv	a1,s10
    6bfc:	4629                	li	a2,10
    6bfe:	4681                	li	a3,0
    6c00:	90dfc0ef          	jal	350c <__udivdi3>
    6c04:	14fd                	add	s1,s1,-1
    6c06:	8c2a                	mv	s8,a0
    6c08:	8d2e                	mv	s10,a1
    6c0a:	f0e5                	bnez	s1,6bea <.L357>
    6c0c:	b9ed                	j	6906 <.L135>

00006c0e <.L142>:
    6c0e:	b2022583          	lw	a1,-1248(tp) # fffffb20 <__AHB_SRAM_segment_end__+0xfdf7b20>
    6c12:	4532                	lw	a0,12(sp)
    6c14:	1b79                	add	s6,s6,-2
    6c16:	4d0d                	li	s10,3
    6c18:	e67fe0ef          	jal	5a7e <__mulsf3>
    6c1c:	ffeb8793          	add	a5,s7,-2
    6c20:	842a                	mv	s0,a0
    6c22:	da3e                	sw	a5,52(sp)
    6c24:	bb25                	j	695c <.L141>

00006c26 <.L148>:
    6c26:	0505                	add	a0,a0,1
    6c28:	8c89                	sub	s1,s1,a0
    6c2a:	47c1                	li	a5,16
    6c2c:	0097d363          	bge	a5,s1,6c32 <.L149>
    6c30:	44c1                	li	s1,16

00006c32 <.L149>:
    6c32:	08097793          	and	a5,s2,128
    6c36:	e80791e3          	bnez	a5,6ab8 <.L147>
    6c3a:	b1422c03          	lw	s8,-1260(tp) # fffffb14 <__AHB_SRAM_segment_end__+0xfdf7b14>
    6c3e:	b1c22403          	lw	s0,-1252(tp) # fffffb1c <__AHB_SRAM_segment_end__+0xfdf7b1c>

00006c42 <.L150>:
    6c42:	e6048ae3          	beqz	s1,6ab6 <.L153>
    6c46:	8526                	mv	a0,s1
    6c48:	9c6fd0ef          	jal	3e0e <__SEGGER_RTL_pow10f>
    6c4c:	85aa                	mv	a1,a0
    6c4e:	855e                	mv	a0,s7
    6c50:	e2ffe0ef          	jal	5a7e <__mulsf3>
    6c54:	85e2                	mv	a1,s8
    6c56:	b24fc0ef          	jal	2f7a <__addsf3>
    6c5a:	827fc0ef          	jal	3480 <floorf>
    6c5e:	85a2                	mv	a1,s0
    6c60:	ab2ff0ef          	jal	5f12 <fmodf>
    6c64:	00000593          	li	a1,0
    6c68:	986ff0ef          	jal	5dee <__eqsf2>
    6c6c:	e40516e3          	bnez	a0,6ab8 <.L147>
    6c70:	14fd                	add	s1,s1,-1
    6c72:	bfc1                	j	6c42 <.L150>

00006c74 <.L159>:
    6c74:	856a                	mv	a0,s10
    6c76:	da02                	sw	zero,52(sp)
    6c78:	9a2ff0ef          	jal	5e1a <__fixunssfdi>
    6c7c:	8bae                	mv	s7,a1
    6c7e:	8caa                	mv	s9,a0
    6c80:	ddefc0ef          	jal	325e <__floatundisf>
    6c84:	85aa                	mv	a1,a0
    6c86:	856a                	mv	a0,s10
    6c88:	aeafc0ef          	jal	2f72 <__subsf3>
    6c8c:	842a                	mv	s0,a0
    6c8e:	bd61                	j	6b26 <.L160>

00006c90 <.L158>:
    6c90:	da02                	sw	zero,52(sp)
    6c92:	4c81                	li	s9,0
    6c94:	4b81                	li	s7,0
    6c96:	bd41                	j	6b26 <.L160>

00006c98 <.L162>:
    6c98:	0d05                	add	s10,s10,1
    6c9a:	bd59                	j	6b30 <.L161>

00006c9c <.L168>:
    6c9c:	02000593          	li	a1,32
    6ca0:	854e                	mv	a0,s3
    6ca2:	197d                	add	s2,s2,-1
    6ca4:	ce2ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6ca8:	b9ed                	j	69a2 <.L166>

00006caa <.L169>:
    6caa:	d0078ce3          	beqz	a5,69c2 <.L171>
    6cae:	02000593          	li	a1,32
    6cb2:	b329                	j	69bc <.L358>

00006cb4 <.L174>:
    6cb4:	03000593          	li	a1,48
    6cb8:	854e                	mv	a0,s3
    6cba:	197d                	add	s2,s2,-1
    6cbc:	ccaff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6cc0:	b321                	j	69c8 <.L172>

00006cc2 <.L176>:
    6cc2:	40ec86b3          	sub	a3,s9,a4
    6cc6:	00dcb633          	sltu	a2,s9,a3
    6cca:	0585                	add	a1,a1,1
    6ccc:	40fb8bb3          	sub	s7,s7,a5
    6cd0:	0ff5f593          	zext.b	a1,a1
    6cd4:	8cb6                	mv	s9,a3
    6cd6:	40cb8bb3          	sub	s7,s7,a2
    6cda:	b329                	j	69e4 <.L175>

00006cdc <.L182>:
    6cdc:	17fd                	add	a5,a5,-1
    6cde:	03000593          	li	a1,48
    6ce2:	854e                	mv	a0,s3
    6ce4:	da3e                	sw	a5,52(sp)
    6ce6:	ca0ff0ef          	jal	6186 <__SEGGER_RTL_putc>

00006cea <.L179>:
    6cea:	57d2                	lw	a5,52(sp)
    6cec:	fef048e3          	bgtz	a5,6cdc <.L182>
    6cf0:	bb21                	j	6a08 <.L183>

00006cf2 <.L186>:
    6cf2:	d204d9e3          	bgez	s1,6a24 <.L187>
    6cf6:	4c81                	li	s9,0
    6cf8:	b335                	j	6a24 <.L187>

00006cfa <.L194>:
    6cfa:	1cfd                	add	s9,s9,-1
    6cfc:	003c9793          	sll	a5,s9,0x3
    6d00:	97da                	add	a5,a5,s6
    6d02:	4398                	lw	a4,0(a5)
    6d04:	43dc                	lw	a5,4(a5)
    6d06:	03000593          	li	a1,48

00006d0a <.L190>:
    6d0a:	00f46663          	bltu	s0,a5,6d16 <.L259>
    6d0e:	00879863          	bne	a5,s0,6d1e <.L191>
    6d12:	00ebf663          	bgeu	s7,a4,6d1e <.L191>

00006d16 <.L259>:
    6d16:	854e                	mv	a0,s3
    6d18:	c6eff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6d1c:	b32d                	j	6a46 <.L193>

00006d1e <.L191>:
    6d1e:	40eb86b3          	sub	a3,s7,a4
    6d22:	00dbb633          	sltu	a2,s7,a3
    6d26:	0585                	add	a1,a1,1
    6d28:	8c1d                	sub	s0,s0,a5
    6d2a:	0ff5f593          	zext.b	a1,a1
    6d2e:	8bb6                	mv	s7,a3
    6d30:	8c11                	sub	s0,s0,a2
    6d32:	bfe1                	j	6d0a <.L190>

00006d34 <.L196>:
    6d34:	03000593          	li	a1,48
    6d38:	854e                	mv	a0,s3
    6d3a:	14fd                	add	s1,s1,-1
    6d3c:	c4aff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6d40:	b329                	j	6a4a <.L195>

00006d42 <.L184>:
    6d42:	012c1793          	sll	a5,s8,0x12
    6d46:	06500593          	li	a1,101
    6d4a:	0007d463          	bgez	a5,6d52 <.L197>
    6d4e:	04500593          	li	a1,69

00006d52 <.L197>:
    6d52:	854e                	mv	a0,s3
    6d54:	c32ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6d58:	57d2                	lw	a5,52(sp)
    6d5a:	0407df63          	bgez	a5,6db8 <.L198>
    6d5e:	02d00593          	li	a1,45
    6d62:	854e                	mv	a0,s3
    6d64:	c22ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6d68:	57d2                	lw	a5,52(sp)
    6d6a:	40f007b3          	neg	a5,a5
    6d6e:	da3e                	sw	a5,52(sp)

00006d70 <.L199>:
    6d70:	55d2                	lw	a1,52(sp)
    6d72:	06300793          	li	a5,99
    6d76:	00b7df63          	bge	a5,a1,6d94 <.L200>
    6d7a:	06400413          	li	s0,100
    6d7e:	0285c5b3          	div	a1,a1,s0
    6d82:	854e                	mv	a0,s3
    6d84:	03058593          	add	a1,a1,48
    6d88:	bfeff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6d8c:	57d2                	lw	a5,52(sp)
    6d8e:	0287e7b3          	rem	a5,a5,s0
    6d92:	da3e                	sw	a5,52(sp)

00006d94 <.L200>:
    6d94:	55d2                	lw	a1,52(sp)
    6d96:	4429                	li	s0,10
    6d98:	854e                	mv	a0,s3
    6d9a:	0285c5b3          	div	a1,a1,s0
    6d9e:	03058593          	add	a1,a1,48
    6da2:	be4ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6da6:	55d2                	lw	a1,52(sp)
    6da8:	0285e5b3          	rem	a1,a1,s0
    6dac:	03058593          	add	a1,a1,48

00006db0 <.L360>:
    6db0:	854e                	mv	a0,s3
    6db2:	bd4ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6db6:	b145                	j	6a56 <.L201>

00006db8 <.L198>:
    6db8:	02b00593          	li	a1,43
    6dbc:	854e                	mv	a0,s3
    6dbe:	bc8ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6dc2:	b77d                	j	6d70 <.L199>

00006dc4 <.L205>:
    6dc4:	6d21                	lui	s10,0x8
    6dc6:	892e                	mv	s2,a1
    6dc8:	4c01                	li	s8,0
    6dca:	01abfd33          	and	s10,s7,s10
    6dce:	470d                	li	a4,3
    6dd0:	02c00813          	li	a6,44

00006dd4 <.L208>:
    6dd4:	012467b3          	or	a5,s0,s2
    6dd8:	c7b5                	beqz	a5,6e44 <.L206>
    6dda:	000d0d63          	beqz	s10,6df4 <.L214>
    6dde:	003c7793          	and	a5,s8,3
    6de2:	00e79963          	bne	a5,a4,6df4 <.L214>
    6de6:	030c0793          	add	a5,s8,48
    6dea:	1018                	add	a4,sp,32
    6dec:	97ba                	add	a5,a5,a4
    6dee:	ff078423          	sb	a6,-24(a5)
    6df2:	0c05                	add	s8,s8,1

00006df4 <.L214>:
    6df4:	1018                	add	a4,sp,32
    6df6:	030c0793          	add	a5,s8,48
    6dfa:	97ba                	add	a5,a5,a4
    6dfc:	4629                	li	a2,10
    6dfe:	4681                	li	a3,0
    6e00:	8522                	mv	a0,s0
    6e02:	85ca                	mv	a1,s2
    6e04:	c63e                	sw	a5,12(sp)
    6e06:	b1ffc0ef          	jal	3924 <__umoddi3>
    6e0a:	47b2                	lw	a5,12(sp)
    6e0c:	03050513          	add	a0,a0,48
    6e10:	85ca                	mv	a1,s2
    6e12:	fea78423          	sb	a0,-24(a5)
    6e16:	4629                	li	a2,10
    6e18:	8522                	mv	a0,s0
    6e1a:	4681                	li	a3,0
    6e1c:	ef0fc0ef          	jal	350c <__udivdi3>
    6e20:	0c05                	add	s8,s8,1
    6e22:	842a                	mv	s0,a0
    6e24:	892e                	mv	s2,a1
    6e26:	02c00813          	li	a6,44
    6e2a:	470d                	li	a4,3
    6e2c:	b765                	j	6dd4 <.L208>

00006e2e <.L204>:
    6e2e:	6709                	lui	a4,0x2
    6e30:	4c01                	li	s8,0
    6e32:	00ebf733          	and	a4,s7,a4
    6e36:	a0418693          	add	a3,gp,-1532 # 374 <__SEGGER_RTL_hex_lc>
    6e3a:	a1418613          	add	a2,gp,-1516 # 384 <__SEGGER_RTL_hex_uc>

00006e3e <.L209>:
    6e3e:	00b467b3          	or	a5,s0,a1
    6e42:	e38d                	bnez	a5,6e64 <.L212>

00006e44 <.L206>:
    6e44:	418484b3          	sub	s1,s1,s8
    6e48:	0004d363          	bgez	s1,6e4e <.L216>
    6e4c:	4481                	li	s1,0

00006e4e <.L216>:
    6e4e:	409b0b33          	sub	s6,s6,s1
    6e52:	0ff00793          	li	a5,255
    6e56:	418b0b33          	sub	s6,s6,s8
    6e5a:	0397f863          	bgeu	a5,s9,6e8a <.L217>
    6e5e:	1b7d                	add	s6,s6,-1

00006e60 <.L218>:
    6e60:	1b7d                	add	s6,s6,-1
    6e62:	a035                	j	6e8e <.L219>

00006e64 <.L212>:
    6e64:	00f47793          	and	a5,s0,15
    6e68:	cf19                	beqz	a4,6e86 <.L210>
    6e6a:	97b2                	add	a5,a5,a2

00006e6c <.L361>:
    6e6c:	0007c783          	lbu	a5,0(a5)
    6e70:	1828                	add	a0,sp,56
    6e72:	9562                	add	a0,a0,s8
    6e74:	00f50023          	sb	a5,0(a0)
    6e78:	8011                	srl	s0,s0,0x4
    6e7a:	01c59793          	sll	a5,a1,0x1c
    6e7e:	0c05                	add	s8,s8,1
    6e80:	8c5d                	or	s0,s0,a5
    6e82:	8191                	srl	a1,a1,0x4
    6e84:	bf6d                	j	6e3e <.L209>

00006e86 <.L210>:
    6e86:	97b6                	add	a5,a5,a3
    6e88:	b7d5                	j	6e6c <.L361>

00006e8a <.L217>:
    6e8a:	fc0c9be3          	bnez	s9,6e60 <.L218>

00006e8e <.L219>:
    6e8e:	200bf793          	and	a5,s7,512
    6e92:	e799                	bnez	a5,6ea0 <.L220>
    6e94:	865a                	mv	a2,s6
    6e96:	85de                	mv	a1,s7
    6e98:	854e                	mv	a0,s3
    6e9a:	fe9fc0ef          	jal	3e82 <__SEGGER_RTL_pre_padding>
    6e9e:	4b01                	li	s6,0

00006ea0 <.L220>:
    6ea0:	0ff00793          	li	a5,255
    6ea4:	0197fc63          	bgeu	a5,s9,6ebc <.L221>
    6ea8:	03000593          	li	a1,48
    6eac:	854e                	mv	a0,s3
    6eae:	ad8ff0ef          	jal	6186 <__SEGGER_RTL_putc>

00006eb2 <.L222>:
    6eb2:	85e6                	mv	a1,s9
    6eb4:	854e                	mv	a0,s3
    6eb6:	ad0ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6eba:	a019                	j	6ec0 <.L223>

00006ebc <.L221>:
    6ebc:	fe0c9be3          	bnez	s9,6eb2 <.L222>

00006ec0 <.L223>:
    6ec0:	865a                	mv	a2,s6
    6ec2:	85de                	mv	a1,s7
    6ec4:	854e                	mv	a0,s3
    6ec6:	fbdfc0ef          	jal	3e82 <__SEGGER_RTL_pre_padding>
    6eca:	8626                	mv	a2,s1
    6ecc:	03000593          	li	a1,48
    6ed0:	854e                	mv	a0,s3
    6ed2:	b50ff0ef          	jal	6222 <__SEGGER_RTL_print_padding>

00006ed6 <.L224>:
    6ed6:	1c7d                	add	s8,s8,-1
    6ed8:	e40c4c63          	bltz	s8,6530 <.L371>
    6edc:	183c                	add	a5,sp,56
    6ede:	97e2                	add	a5,a5,s8
    6ee0:	0007c583          	lbu	a1,0(a5)
    6ee4:	854e                	mv	a0,s3
    6ee6:	aa0ff0ef          	jal	6186 <__SEGGER_RTL_putc>
    6eea:	b7f5                	j	6ed6 <.L224>

00006eec <.L34>:
    6eec:	07800713          	li	a4,120
    6ef0:	daf76163          	bltu	a4,a5,6492 <.L4>

00006ef4 <.L38>:
    6ef4:	fa878713          	add	a4,a5,-88
    6ef8:	0ff77713          	zext.b	a4,a4
    6efc:	02000693          	li	a3,32
    6f00:	d8e6e963          	bltu	a3,a4,6492 <.L4>
    6f04:	46d2                	lw	a3,20(sp)
    6f06:	070a                	sll	a4,a4,0x2
    6f08:	9736                	add	a4,a4,a3
    6f0a:	4318                	lw	a4,0(a4)
    6f0c:	8702                	jr	a4

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

00006f0e <__SEGGER_RTL_ascii_isctype>:
    6f0e:	07f00793          	li	a5,127
    6f12:	00a7ee63          	bltu	a5,a0,6f2e <.L3>
    6f16:	a9420793          	add	a5,tp,-1388 # fffffa94 <__AHB_SRAM_segment_end__+0xfdf7a94>
    6f1a:	953e                	add	a0,a0,a5
    6f1c:	e8c20793          	add	a5,tp,-372 # fffffe8c <__AHB_SRAM_segment_end__+0xfdf7e8c>
    6f20:	95be                	add	a1,a1,a5
    6f22:	00054503          	lbu	a0,0(a0)
    6f26:	0005c783          	lbu	a5,0(a1)
    6f2a:	8d7d                	and	a0,a0,a5
    6f2c:	8082                	ret

00006f2e <.L3>:
    6f2e:	4501                	li	a0,0
    6f30:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

00006f32 <__SEGGER_RTL_ascii_tolower>:
    6f32:	fbf50713          	add	a4,a0,-65
    6f36:	47e5                	li	a5,25
    6f38:	00e7e463          	bltu	a5,a4,6f40 <.L7>
    6f3c:	02050513          	add	a0,a0,32

00006f40 <.L7>:
    6f40:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

00006f42 <__SEGGER_RTL_ascii_iswctype>:
    6f42:	07f00793          	li	a5,127
    6f46:	00a7ee63          	bltu	a5,a0,6f62 <.L10>
    6f4a:	a9420793          	add	a5,tp,-1388 # fffffa94 <__AHB_SRAM_segment_end__+0xfdf7a94>
    6f4e:	953e                	add	a0,a0,a5
    6f50:	e8c20793          	add	a5,tp,-372 # fffffe8c <__AHB_SRAM_segment_end__+0xfdf7e8c>
    6f54:	95be                	add	a1,a1,a5
    6f56:	00054503          	lbu	a0,0(a0)
    6f5a:	0005c783          	lbu	a5,0(a1)
    6f5e:	8d7d                	and	a0,a0,a5
    6f60:	8082                	ret

00006f62 <.L10>:
    6f62:	4501                	li	a0,0
    6f64:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

00006f66 <__SEGGER_RTL_ascii_towlower>:
    6f66:	fbf50713          	add	a4,a0,-65
    6f6a:	47e5                	li	a5,25
    6f6c:	00e7e463          	bltu	a5,a4,6f74 <.L14>
    6f70:	02050513          	add	a0,a0,32

00006f74 <.L14>:
    6f74:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

00006f76 <__SEGGER_RTL_ascii_wctomb>:
    6f76:	07f00793          	li	a5,127
    6f7a:	00b7e663          	bltu	a5,a1,6f86 <.L66>
    6f7e:	00b50023          	sb	a1,0(a0)
    6f82:	4505                	li	a0,1
    6f84:	8082                	ret

00006f86 <.L66>:
    6f86:	5579                	li	a0,-2
    6f88:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

00006f8a <__SEGGER_RTL_current_locale>:
    6f8a:	012017b7          	lui	a5,0x1201
    6f8e:	1a87a503          	lw	a0,424(a5) # 12011a8 <__SEGGER_RTL_locale_ptr>
    6f92:	e509                	bnez	a0,6f9c <.L155>
    6f94:	01200537          	lui	a0,0x1200
    6f98:	00050513          	mv	a0,a0

00006f9c <.L155>:
    6f9c:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_lzss:

00007088 <__SEGGER_init_lzss>:
    7088:	4008                	lw	a0,0(s0)
    708a:	404c                	lw	a1,4(s0)
    708c:	0421                	add	s0,s0,8
    708e:	08000793          	li	a5,128

00007092 <.L__SEGGER_init_lzss_NextByte>:
    7092:	0005c603          	lbu	a2,0(a1)
    7096:	0585                	add	a1,a1,1
    7098:	c631                	beqz	a2,70e4 <.L__SEGGER_init_lzss_Done>
    709a:	02f66c63          	bltu	a2,a5,70d2 <.L__SEGGER_init_lzss_LoopLiteral>
    709e:	f8060613          	add	a2,a2,-128
    70a2:	c231                	beqz	a2,70e6 <.L__SEGGER_init_lzss_Error>
    70a4:	0005c683          	lbu	a3,0(a1)
    70a8:	0585                	add	a1,a1,1
    70aa:	00f6e963          	bltu	a3,a5,70bc <.L__SEGGER_init_lzss_ShortRun>
    70ae:	f8068693          	add	a3,a3,-128
    70b2:	06a2                	sll	a3,a3,0x8
    70b4:	0005c703          	lbu	a4,0(a1)
    70b8:	0585                	add	a1,a1,1
    70ba:	96ba                	add	a3,a3,a4

000070bc <.L__SEGGER_init_lzss_ShortRun>:
    70bc:	40d50733          	sub	a4,a0,a3

000070c0 <.L__SEGGER_init_lzss_LoopShort>:
    70c0:	00074683          	lbu	a3,0(a4) # 2000 <.L43>
    70c4:	00d50023          	sb	a3,0(a0) # 1200000 <__RAL_global_locale>
    70c8:	0705                	add	a4,a4,1
    70ca:	0505                	add	a0,a0,1
    70cc:	167d                	add	a2,a2,-1
    70ce:	fa6d                	bnez	a2,70c0 <.L__SEGGER_init_lzss_LoopShort>
    70d0:	b7c9                	j	7092 <.L__SEGGER_init_lzss_NextByte>

000070d2 <.L__SEGGER_init_lzss_LoopLiteral>:
    70d2:	0005c683          	lbu	a3,0(a1)
    70d6:	0585                	add	a1,a1,1
    70d8:	00d50023          	sb	a3,0(a0)
    70dc:	0505                	add	a0,a0,1
    70de:	167d                	add	a2,a2,-1
    70e0:	fa6d                	bnez	a2,70d2 <.L__SEGGER_init_lzss_LoopLiteral>
    70e2:	bf45                	j	7092 <.L__SEGGER_init_lzss_NextByte>

000070e4 <.L__SEGGER_init_lzss_Done>:
    70e4:	8082                	ret

000070e6 <.L__SEGGER_init_lzss_Error>:
    70e6:	a001                	j	70e6 <.L__SEGGER_init_lzss_Error>

Disassembly of section .segger.init.__SEGGER_init_zero:

000070e8 <__SEGGER_init_zero>:
    70e8:	4008                	lw	a0,0(s0)
    70ea:	404c                	lw	a1,4(s0)
    70ec:	0421                	add	s0,s0,8
    70ee:	c591                	beqz	a1,70fa <.L__SEGGER_init_zero_Done>

000070f0 <.L__SEGGER_init_zero_Loop>:
    70f0:	00050023          	sb	zero,0(a0)
    70f4:	0505                	add	a0,a0,1
    70f6:	15fd                	add	a1,a1,-1
    70f8:	fde5                	bnez	a1,70f0 <.L__SEGGER_init_zero_Loop>

000070fa <.L__SEGGER_init_zero_Done>:
    70fa:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

000070fc <__SEGGER_init_copy>:
    70fc:	4008                	lw	a0,0(s0)
    70fe:	404c                	lw	a1,4(s0)
    7100:	4410                	lw	a2,8(s0)
    7102:	0431                	add	s0,s0,12
    7104:	ca09                	beqz	a2,7116 <.L__SEGGER_init_copy_Done>

00007106 <.L__SEGGER_init_copy_Loop>:
    7106:	00058683          	lb	a3,0(a1)
    710a:	00d50023          	sb	a3,0(a0)
    710e:	0505                	add	a0,a0,1
    7110:	0585                	add	a1,a1,1
    7112:	167d                	add	a2,a2,-1
    7114:	fa6d                	bnez	a2,7106 <.L__SEGGER_init_copy_Loop>

00007116 <.L__SEGGER_init_copy_Done>:
    7116:	8082                	ret
