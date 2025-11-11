
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80003000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80003000:	800041b7          	lui	gp,0x80004
        addi    gp, gp, %lo(__global_pointer$)
80003004:	89018193          	add	gp,gp,-1904 # 80003890 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	80004237          	lui	tp,0x80004
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	53c20213          	add	tp,tp,1340 # 8000453c <__thread_pointer$>
        .option pop

        csrw    mstatus, zero
80003010:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
80003014:	34201073          	csrw	mcause,zero
    la t0, _stack_safe
    mv sp, t0
    call _init_ext_ram
#endif

        lui     t0,     %hi(__stack_end__)
80003018:	002402b7          	lui	t0,0x240
        addi    sp, t0, %lo(__stack_end__)
8000301c:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
80003020:	567000ef          	jal	80003d86 <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003024:	50f000ef          	jal	80003d32 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
80003028:	69d030ef          	jal	80006ec4 <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
8000302c:	4e5040ef          	jal	80007d10 <_init>

80003030 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003030:	80009437          	lui	s0,0x80009
80003034:	61440413          	add	s0,s0,1556 # 80009614 <.L155+0x2>

80003038 <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
80003038:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
8000303a:	0411                	add	s0,s0,4
        jalr    a0                              // Call initialization function
8000303c:	9502                	jalr	a0
        j       L(RunInit)
8000303e:	bfed                	j	80003038 <.L_start_RunInit>

80003040 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
80003040:	1a1020ef          	jal	800059e0 <_clean_up>

80003044 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80003044:	000002b7          	lui	t0,0x0
80003048:	00028293          	mv	t0,t0
    csrw mtvec, t0
8000304c:	30529073          	csrw	mtvec,t0
#if defined (USE_S_MODE_IRQ)
    la t0, __vector_s_table
    csrw stvec, t0
#endif
    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
80003050:	7d016073          	csrs	0x7d0,2

80003054 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003054:	4a5040ef          	jal	80007cf8 <reset_handler>
        tail    exit
80003058:	a009                	j	8000305a <exit>

8000305a <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
8000305a:	a001                	j	8000305a <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
8000305c:	4501                	li	a0,0
        li      a1, 0
8000305e:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
80003060:	499040ef          	jal	80007cf8 <reset_handler>
        tail    exit
80003064:	bfdd                	j	8000305a <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>:
80003066:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80003d32 <l1c_dc_enable>:
    }
#endif
}

void l1c_dc_enable(void)
{
80003d32:	1101                	add	sp,sp,-32
80003d34:	ce06                	sw	ra,28(sp)

80003d36 <.LBB48>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80003d36:	7ca027f3          	csrr	a5,0x7ca
80003d3a:	c63e                	sw	a5,12(sp)
80003d3c:	47b2                	lw	a5,12(sp)

80003d3e <.LBE52>:
80003d3e:	0001                	nop

80003d40 <.LBE50>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80003d40:	8b89                	and	a5,a5,2
80003d42:	00f037b3          	snez	a5,a5
80003d46:	0ff7f793          	zext.b	a5,a5

80003d4a <.LBE48>:
    if (!l1c_dc_is_enabled()) {
80003d4a:	0017c793          	xor	a5,a5,1
80003d4e:	0ff7f793          	zext.b	a5,a5
80003d52:	c791                	beqz	a5,80003d5e <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
80003d54:	20ad                	jal	80003dbe <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
80003d56:	40200793          	li	a5,1026
80003d5a:	7ca7a073          	csrs	0x7ca,a5

80003d5e <.L11>:
    }
}
80003d5e:	0001                	nop
80003d60:	40f2                	lw	ra,28(sp)
80003d62:	6105                	add	sp,sp,32
80003d64:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

80003d66 <__SEGGER_RTL_SIGNAL_SIG_IGN>:
80003d66:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

80003d86 <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
80003d86:	1141                	add	sp,sp,-16

80003d88 <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
80003d88:	7ca027f3          	csrr	a5,0x7ca
80003d8c:	c63e                	sw	a5,12(sp)
80003d8e:	47b2                	lw	a5,12(sp)

80003d90 <.LBE62>:
80003d90:	0001                	nop

80003d92 <.LBE60>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
80003d92:	8b85                	and	a5,a5,1
80003d94:	00f037b3          	snez	a5,a5
80003d98:	0ff7f793          	zext.b	a5,a5

80003d9c <.LBE58>:
    if (!l1c_ic_is_enabled()) {
80003d9c:	0017c793          	xor	a5,a5,1
80003da0:	0ff7f793          	zext.b	a5,a5
80003da4:	c789                	beqz	a5,80003dae <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
80003da6:	30100793          	li	a5,769
80003daa:	7ca7a073          	csrs	0x7ca,a5

80003dae <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80003dae:	0001                	nop
80003db0:	0141                	add	sp,sp,16
80003db2:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

80003dbe <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
80003dbe:	6799                	lui	a5,0x6
80003dc0:	7ca7a073          	csrs	0x7ca,a5
}
80003dc4:	0001                	nop
80003dc6:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

80003dca <sysctl_clock_set_preset>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr, sysctl_preset_t preset)
{
80003dca:	1141                	add	sp,sp,-16
80003dcc:	c62a                	sw	a0,12(sp)
80003dce:	87ae                	mv	a5,a1
80003dd0:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_MUX_MASK) | SYSCTL_GLOBAL00_MUX_SET(preset);
80003dd4:	4732                	lw	a4,12(sp)
80003dd6:	6789                	lui	a5,0x2
80003dd8:	97ba                	add	a5,a5,a4
80003dda:	439c                	lw	a5,0(a5)
80003ddc:	f007f713          	and	a4,a5,-256
80003de0:	00b14783          	lbu	a5,11(sp)
80003de4:	8f5d                	or	a4,a4,a5
80003de6:	46b2                	lw	a3,12(sp)
80003de8:	6789                	lui	a5,0x2
80003dea:	97b6                	add	a5,a5,a3
80003dec:	c398                	sw	a4,0(a5)
}
80003dee:	0001                	nop
80003df0:	0141                	add	sp,sp,16
80003df2:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_set_rampup_time:

80003e2e <pllctlv2_xtal_set_rampup_time>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] rc24m_cycles Number of RC24M clock cycles for the ramp-up period
 * @note The ramp-up time affects how quickly the crystal oscillator reaches stable operation
 */
static inline void pllctlv2_xtal_set_rampup_time(PLLCTLV2_Type *ptr, uint32_t rc24m_cycles)
{
80003e2e:	1141                	add	sp,sp,-16
80003e30:	c62a                	sw	a0,12(sp)
80003e32:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTLV2_XTAL_RAMP_TIME_MASK) | PLLCTLV2_XTAL_RAMP_TIME_SET(rc24m_cycles);
80003e34:	47b2                	lw	a5,12(sp)
80003e36:	4398                	lw	a4,0(a5)
80003e38:	fff007b7          	lui	a5,0xfff00
80003e3c:	8f7d                	and	a4,a4,a5
80003e3e:	46a2                	lw	a3,8(sp)
80003e40:	001007b7          	lui	a5,0x100
80003e44:	17fd                	add	a5,a5,-1 # fffff <__AXI_SRAM_segment_size__+0x7ffff>
80003e46:	8ff5                	and	a5,a5,a3
80003e48:	8f5d                	or	a4,a4,a5
80003e4a:	47b2                	lw	a5,12(sp)
80003e4c:	c398                	sw	a4,0(a5)
}
80003e4e:	0001                	nop
80003e50:	0141                	add	sp,sp,16
80003e52:	8082                	ret

Disassembly of section .text.board_print_banner:

80003ec2 <board_print_banner>:
    init_uart_pins(ptr);
    board_init_uart_clock(ptr);
}

void board_print_banner(void)
{
80003ec2:	d8010113          	add	sp,sp,-640
80003ec6:	26112e23          	sw	ra,636(sp)
    const uint8_t banner[] = { "\n\
80003eca:	2cc20713          	add	a4,tp,716 # 2cc <default_isr_26+0xa>
80003ece:	878a                	mv	a5,sp
80003ed0:	86ba                	mv	a3,a4
80003ed2:	26f00713          	li	a4,623
80003ed6:	863a                	mv	a2,a4
80003ed8:	85b6                	mv	a1,a3
80003eda:	853e                	mv	a0,a5
80003edc:	5f5020ef          	jal	80006cd0 <memcpy>
\\__|  \\__|\\__|      \\__|     \\__|\\__| \\_______|\\__|       \\______/\n\
----------------------------------------------------------------------\n" };
#ifdef SDK_VERSION_STRING
    printf("hpm_sdk: %s\n", SDK_VERSION_STRING);
#endif
    printf("%s", banner);
80003ee0:	878a                	mv	a5,sp
80003ee2:	85be                	mv	a1,a5
80003ee4:	2c820513          	add	a0,tp,712 # 2c8 <default_isr_26+0x6>
80003ee8:	745020ef          	jal	80006e2c <printf>
}
80003eec:	0001                	nop
80003eee:	27c12083          	lw	ra,636(sp)
80003ef2:	28010113          	add	sp,sp,640
80003ef6:	8082                	ret

Disassembly of section .text.board_init_pmp:

80003efa <board_init_pmp>:
        }
    }
}

void board_init_pmp(void)
{
80003efa:	712d                	add	sp,sp,-288
80003efc:	10112e23          	sw	ra,284(sp)
    uint32_t start_addr;
    uint32_t end_addr;
    uint32_t length;
    pmp_entry_t pmp_entry[16];
    uint8_t index = 0;
80003f00:	100107a3          	sb	zero,271(sp)

    /* Init noncachable memory */
    extern uint32_t __noncacheable_start__[];
    extern uint32_t __noncacheable_end__[];
    start_addr = (uint32_t) __noncacheable_start__;
80003f04:	012807b7          	lui	a5,0x1280
80003f08:	00078793          	mv	a5,a5
80003f0c:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t) __noncacheable_end__;
80003f10:	012c07b7          	lui	a5,0x12c0
80003f14:	00078793          	mv	a5,a5
80003f18:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
80003f1c:	10412703          	lw	a4,260(sp)
80003f20:	10812783          	lw	a5,264(sp)
80003f24:	40f707b3          	sub	a5,a4,a5
80003f28:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
80003f2c:	10012783          	lw	a5,256(sp)
80003f30:	cbe1                	beqz	a5,80004000 <.L125>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
80003f32:	10012783          	lw	a5,256(sp)
80003f36:	fff78713          	add	a4,a5,-1 # 12bffff <__AXI_SRAM_segment_end__+0x3ffff>
80003f3a:	10012783          	lw	a5,256(sp)
80003f3e:	8ff9                	and	a5,a5,a4
80003f40:	cb89                	beqz	a5,80003f52 <.L126>
80003f42:	20300613          	li	a2,515
80003f46:	5d820593          	add	a1,tp,1496 # 5d8 <__ILM_segment_used_end__+0x116>
80003f4a:	61c20513          	add	a0,tp,1564 # 61c <__ILM_segment_used_end__+0x15a>
80003f4e:	330040ef          	jal	8000827e <__SEGGER_RTL_X_assert>

80003f52 <.L126>:
        assert((start_addr & (length - 1U)) == 0U);
80003f52:	10012783          	lw	a5,256(sp)
80003f56:	fff78713          	add	a4,a5,-1
80003f5a:	10812783          	lw	a5,264(sp)
80003f5e:	8ff9                	and	a5,a5,a4
80003f60:	cb89                	beqz	a5,80003f72 <.L127>
80003f62:	20400613          	li	a2,516
80003f66:	5d820593          	add	a1,tp,1496 # 5d8 <__ILM_segment_used_end__+0x116>
80003f6a:	63c20513          	add	a0,tp,1596 # 63c <__ILM_segment_used_end__+0x17a>
80003f6e:	310040ef          	jal	8000827e <__SEGGER_RTL_X_assert>

80003f72 <.L127>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
80003f72:	10812783          	lw	a5,264(sp)
80003f76:	0027d713          	srl	a4,a5,0x2
80003f7a:	10012783          	lw	a5,256(sp)
80003f7e:	17fd                	add	a5,a5,-1
80003f80:	838d                	srl	a5,a5,0x3
80003f82:	00f766b3          	or	a3,a4,a5
80003f86:	10012783          	lw	a5,256(sp)
80003f8a:	838d                	srl	a5,a5,0x3
80003f8c:	fff7c713          	not	a4,a5
80003f90:	10f14783          	lbu	a5,271(sp)
80003f94:	8f75                	and	a4,a4,a3
80003f96:	0792                	sll	a5,a5,0x4
80003f98:	11078793          	add	a5,a5,272
80003f9c:	978a                	add	a5,a5,sp
80003f9e:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
80003fa2:	10f14783          	lbu	a5,271(sp)
80003fa6:	0792                	sll	a5,a5,0x4
80003fa8:	11078793          	add	a5,a5,272
80003fac:	978a                	add	a5,a5,sp
80003fae:	477d                	li	a4,31
80003fb0:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
80003fb4:	10812783          	lw	a5,264(sp)
80003fb8:	0027d713          	srl	a4,a5,0x2
80003fbc:	10012783          	lw	a5,256(sp)
80003fc0:	17fd                	add	a5,a5,-1
80003fc2:	838d                	srl	a5,a5,0x3
80003fc4:	00f766b3          	or	a3,a4,a5
80003fc8:	10012783          	lw	a5,256(sp)
80003fcc:	838d                	srl	a5,a5,0x3
80003fce:	fff7c713          	not	a4,a5
80003fd2:	10f14783          	lbu	a5,271(sp)
80003fd6:	8f75                	and	a4,a4,a3
80003fd8:	0792                	sll	a5,a5,0x4
80003fda:	11078793          	add	a5,a5,272
80003fde:	978a                	add	a5,a5,sp
80003fe0:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
80003fe4:	10f14783          	lbu	a5,271(sp)
80003fe8:	0792                	sll	a5,a5,0x4
80003fea:	11078793          	add	a5,a5,272
80003fee:	978a                	add	a5,a5,sp
80003ff0:	473d                	li	a4,15
80003ff2:	eee78c23          	sb	a4,-264(a5)
        index++;
80003ff6:	10f14783          	lbu	a5,271(sp)
80003ffa:	0785                	add	a5,a5,1
80003ffc:	10f107a3          	sb	a5,271(sp)

80004000 <.L125>:
    }

    /* Init share memory */
    extern uint32_t __share_mem_start__[];
    extern uint32_t __share_mem_end__[];
    start_addr = (uint32_t)__share_mem_start__;
80004000:	012fc7b7          	lui	a5,0x12fc
80004004:	00078793          	mv	a5,a5
80004008:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t)__share_mem_end__;
8000400c:	013007b7          	lui	a5,0x1300
80004010:	00078793          	mv	a5,a5
80004014:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
80004018:	10412703          	lw	a4,260(sp)
8000401c:	10812783          	lw	a5,264(sp)
80004020:	40f707b3          	sub	a5,a4,a5
80004024:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
80004028:	10012783          	lw	a5,256(sp)
8000402c:	cbe1                	beqz	a5,800040fc <.L128>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
8000402e:	10012783          	lw	a5,256(sp)
80004032:	fff78713          	add	a4,a5,-1 # 12fffff <__SHARE_RAM_segment_start__+0x3fff>
80004036:	10012783          	lw	a5,256(sp)
8000403a:	8ff9                	and	a5,a5,a4
8000403c:	cb89                	beqz	a5,8000404e <.L129>
8000403e:	21400613          	li	a2,532
80004042:	5d820593          	add	a1,tp,1496 # 5d8 <__ILM_segment_used_end__+0x116>
80004046:	61c20513          	add	a0,tp,1564 # 61c <__ILM_segment_used_end__+0x15a>
8000404a:	234040ef          	jal	8000827e <__SEGGER_RTL_X_assert>

8000404e <.L129>:
        assert((start_addr & (length - 1U)) == 0U);
8000404e:	10012783          	lw	a5,256(sp)
80004052:	fff78713          	add	a4,a5,-1
80004056:	10812783          	lw	a5,264(sp)
8000405a:	8ff9                	and	a5,a5,a4
8000405c:	cb89                	beqz	a5,8000406e <.L130>
8000405e:	21500613          	li	a2,533
80004062:	5d820593          	add	a1,tp,1496 # 5d8 <__ILM_segment_used_end__+0x116>
80004066:	63c20513          	add	a0,tp,1596 # 63c <__ILM_segment_used_end__+0x17a>
8000406a:	214040ef          	jal	8000827e <__SEGGER_RTL_X_assert>

8000406e <.L130>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
8000406e:	10812783          	lw	a5,264(sp)
80004072:	0027d713          	srl	a4,a5,0x2
80004076:	10012783          	lw	a5,256(sp)
8000407a:	17fd                	add	a5,a5,-1
8000407c:	838d                	srl	a5,a5,0x3
8000407e:	00f766b3          	or	a3,a4,a5
80004082:	10012783          	lw	a5,256(sp)
80004086:	838d                	srl	a5,a5,0x3
80004088:	fff7c713          	not	a4,a5
8000408c:	10f14783          	lbu	a5,271(sp)
80004090:	8f75                	and	a4,a4,a3
80004092:	0792                	sll	a5,a5,0x4
80004094:	11078793          	add	a5,a5,272
80004098:	978a                	add	a5,a5,sp
8000409a:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
8000409e:	10f14783          	lbu	a5,271(sp)
800040a2:	0792                	sll	a5,a5,0x4
800040a4:	11078793          	add	a5,a5,272
800040a8:	978a                	add	a5,a5,sp
800040aa:	477d                	li	a4,31
800040ac:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
800040b0:	10812783          	lw	a5,264(sp)
800040b4:	0027d713          	srl	a4,a5,0x2
800040b8:	10012783          	lw	a5,256(sp)
800040bc:	17fd                	add	a5,a5,-1
800040be:	838d                	srl	a5,a5,0x3
800040c0:	00f766b3          	or	a3,a4,a5
800040c4:	10012783          	lw	a5,256(sp)
800040c8:	838d                	srl	a5,a5,0x3
800040ca:	fff7c713          	not	a4,a5
800040ce:	10f14783          	lbu	a5,271(sp)
800040d2:	8f75                	and	a4,a4,a3
800040d4:	0792                	sll	a5,a5,0x4
800040d6:	11078793          	add	a5,a5,272
800040da:	978a                	add	a5,a5,sp
800040dc:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
800040e0:	10f14783          	lbu	a5,271(sp)
800040e4:	0792                	sll	a5,a5,0x4
800040e6:	11078793          	add	a5,a5,272
800040ea:	978a                	add	a5,a5,sp
800040ec:	473d                	li	a4,15
800040ee:	eee78c23          	sb	a4,-264(a5)
        index++;
800040f2:	10f14783          	lbu	a5,271(sp)
800040f6:	0785                	add	a5,a5,1
800040f8:	10f107a3          	sb	a5,271(sp)

800040fc <.L128>:
    }

    pmp_config(&pmp_entry[0], index);
800040fc:	10f14703          	lbu	a4,271(sp)
80004100:	878a                	mv	a5,sp
80004102:	85ba                	mv	a1,a4
80004104:	853e                	mv	a0,a5
80004106:	3ad000ef          	jal	80004cb2 <pmp_config>
}
8000410a:	0001                	nop
8000410c:	11c12083          	lw	ra,284(sp)
80004110:	6115                	add	sp,sp,288
80004112:	8082                	ret

Disassembly of section .text.board_init_clock:

80004146 <board_init_clock>:

void board_init_clock(void)
{
80004146:	1101                	add	sp,sp,-32
80004148:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
8000414a:	4501                	li	a0,0
8000414c:	3f9030ef          	jal	80007d44 <clock_get_frequency>
80004150:	c62a                	sw	a0,12(sp)
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
80004152:	4732                	lw	a4,12(sp)
80004154:	016e37b7          	lui	a5,0x16e3
80004158:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
8000415c:	00f71d63          	bne	a4,a5,80004176 <.L132>
        /* Configure the External OSC ramp-up time: ~9ms */
        pllctlv2_xtal_set_rampup_time(HPM_PLLCTLV2, 32ul * 1000ul * 9u);
80004160:	000467b7          	lui	a5,0x46
80004164:	50078593          	add	a1,a5,1280 # 46500 <__DLM_segment_size__+0x6500>
80004168:	f40c0537          	lui	a0,0xf40c0
8000416c:	31c9                	jal	80003e2e <pllctlv2_xtal_set_rampup_time>

        /* select clock setting preset1 */
        sysctl_clock_set_preset(HPM_SYSCTL, 2);
8000416e:	4589                	li	a1,2
80004170:	f4000537          	lui	a0,0xf4000
80004174:	3999                	jal	80003dca <sysctl_clock_set_preset>

80004176 <.L132>:
    }
    /* Add Clocks to group 0 */
    clock_add_to_group(clock_cpu0, 0);
80004176:	4581                	li	a1,0
80004178:	4501                	li	a0,0
8000417a:	31b010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
8000417e:	4581                	li	a1,0
80004180:	010607b7          	lui	a5,0x1060
80004184:	00178513          	add	a0,a5,1 # 1060001 <_flash_size+0x60001>
80004188:	30d010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_ahb0, 0);
8000418c:	4581                	li	a1,0
8000418e:	010007b7          	lui	a5,0x1000
80004192:	00478513          	add	a0,a5,4 # 1000004 <_flash_size+0x4>
80004196:	2ff010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_axif, 0);
8000419a:	4581                	li	a1,0
8000419c:	77c1                	lui	a5,0xffff0
8000419e:	00578513          	add	a0,a5,5 # ffff0005 <__AHB_SRAM_segment_end__+0xfde8005>
800041a2:	2f3010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_axis, 0);
800041a6:	4581                	li	a1,0
800041a8:	010107b7          	lui	a5,0x1010
800041ac:	00678513          	add	a0,a5,6 # 1010006 <_flash_size+0x10006>
800041b0:	2e5010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_axic, 0);
800041b4:	4581                	li	a1,0
800041b6:	010207b7          	lui	a5,0x1020
800041ba:	00778513          	add	a0,a5,7 # 1020007 <_flash_size+0x20007>
800041be:	2d7010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_axin, 0);
800041c2:	4581                	li	a1,0
800041c4:	010307b7          	lui	a5,0x1030
800041c8:	00878513          	add	a0,a5,8 # 1030008 <_flash_size+0x30008>
800041cc:	2c9010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_rom0, 0);
800041d0:	4581                	li	a1,0
800041d2:	010407b7          	lui	a5,0x1040
800041d6:	60678513          	add	a0,a5,1542 # 1040606 <_flash_size+0x40606>
800041da:	2bb010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
800041de:	4581                	li	a1,0
800041e0:	016f07b7          	lui	a5,0x16f0
800041e4:	03f78513          	add	a0,a5,63 # 16f003f <__SHARE_RAM_segment_end__+0x3f003f>
800041e8:	2ad010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
800041ec:	4581                	li	a1,0
800041ee:	010517b7          	lui	a5,0x1051
800041f2:	b0078513          	add	a0,a5,-1280 # 1050b00 <_flash_size+0x50b00>
800041f6:	29f010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_lmm1, 0);
800041fa:	4581                	li	a1,0
800041fc:	010517b7          	lui	a5,0x1051
80004200:	c0078513          	add	a0,a5,-1024 # 1050c00 <_flash_size+0x50c00>
80004204:	291010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_ram0, 0);
80004208:	4581                	li	a1,0
8000420a:	017107b7          	lui	a5,0x1710
8000420e:	50078513          	add	a0,a5,1280 # 1710500 <__SHARE_RAM_segment_end__+0x410500>
80004212:	283010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_ram1, 0);
80004216:	4581                	li	a1,0
80004218:	017207b7          	lui	a5,0x1720
8000421c:	50178513          	add	a0,a5,1281 # 1720501 <__SHARE_RAM_segment_end__+0x420501>
80004220:	275010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
80004224:	4581                	li	a1,0
80004226:	013b07b7          	lui	a5,0x13b0
8000422a:	40078513          	add	a0,a5,1024 # 13b0400 <__SHARE_RAM_segment_end__+0xb0400>
8000422e:	267010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_xdma, 0);
80004232:	4581                	li	a1,0
80004234:	017307b7          	lui	a5,0x1730
80004238:	60478513          	add	a0,a5,1540 # 1730604 <__SHARE_RAM_segment_end__+0x430604>
8000423c:	259010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
80004240:	4581                	li	a1,0
80004242:	013907b7          	lui	a5,0x1390
80004246:	40078513          	add	a0,a5,1024 # 1390400 <__SHARE_RAM_segment_end__+0x90400>
8000424a:	24b010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
8000424e:	4581                	li	a1,0
80004250:	015107b7          	lui	a5,0x1510
80004254:	40078513          	add	a0,a5,1024 # 1510400 <__SHARE_RAM_segment_end__+0x210400>
80004258:	23d010ef          	jal	80005c94 <clock_add_to_group>
    /* Motor Related */
    clock_add_to_group(clock_qei0, 0);
8000425c:	4581                	li	a1,0
8000425e:	015207b7          	lui	a5,0x1520
80004262:	40078513          	add	a0,a5,1024 # 1520400 <__SHARE_RAM_segment_end__+0x220400>
80004266:	22f010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_qei1, 0);
8000426a:	4581                	li	a1,0
8000426c:	015307b7          	lui	a5,0x1530
80004270:	40078513          	add	a0,a5,1024 # 1530400 <__SHARE_RAM_segment_end__+0x230400>
80004274:	221010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_qei2, 0);
80004278:	4581                	li	a1,0
8000427a:	015407b7          	lui	a5,0x1540
8000427e:	40078513          	add	a0,a5,1024 # 1540400 <__SHARE_RAM_segment_end__+0x240400>
80004282:	213010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_qei3, 0);
80004286:	4581                	li	a1,0
80004288:	015507b7          	lui	a5,0x1550
8000428c:	40078513          	add	a0,a5,1024 # 1550400 <__SHARE_RAM_segment_end__+0x250400>
80004290:	205010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_qeo0, 0);
80004294:	4581                	li	a1,0
80004296:	015607b7          	lui	a5,0x1560
8000429a:	40078513          	add	a0,a5,1024 # 1560400 <__SHARE_RAM_segment_end__+0x260400>
8000429e:	1f7010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_qeo1, 0);
800042a2:	4581                	li	a1,0
800042a4:	015707b7          	lui	a5,0x1570
800042a8:	40078513          	add	a0,a5,1024 # 1570400 <__SHARE_RAM_segment_end__+0x270400>
800042ac:	1e9010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_qeo2, 0);
800042b0:	4581                	li	a1,0
800042b2:	015807b7          	lui	a5,0x1580
800042b6:	40078513          	add	a0,a5,1024 # 1580400 <__SHARE_RAM_segment_end__+0x280400>
800042ba:	1db010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_qeo3, 0);
800042be:	4581                	li	a1,0
800042c0:	015907b7          	lui	a5,0x1590
800042c4:	40078513          	add	a0,a5,1024 # 1590400 <__SHARE_RAM_segment_end__+0x290400>
800042c8:	1cd010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_pwm0, 0);
800042cc:	4581                	li	a1,0
800042ce:	015a07b7          	lui	a5,0x15a0
800042d2:	40078513          	add	a0,a5,1024 # 15a0400 <__SHARE_RAM_segment_end__+0x2a0400>
800042d6:	1bf010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_pwm1, 0);
800042da:	4581                	li	a1,0
800042dc:	015b07b7          	lui	a5,0x15b0
800042e0:	40078513          	add	a0,a5,1024 # 15b0400 <__SHARE_RAM_segment_end__+0x2b0400>
800042e4:	1b1010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_pwm2, 0);
800042e8:	4581                	li	a1,0
800042ea:	015c07b7          	lui	a5,0x15c0
800042ee:	40078513          	add	a0,a5,1024 # 15c0400 <__SHARE_RAM_segment_end__+0x2c0400>
800042f2:	1a3010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_pwm3, 0);
800042f6:	4581                	li	a1,0
800042f8:	015d07b7          	lui	a5,0x15d0
800042fc:	40078513          	add	a0,a5,1024 # 15d0400 <__SHARE_RAM_segment_end__+0x2d0400>
80004300:	195010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_rdc0, 0);
80004304:	4581                	li	a1,0
80004306:	015e07b7          	lui	a5,0x15e0
8000430a:	40078513          	add	a0,a5,1024 # 15e0400 <__SHARE_RAM_segment_end__+0x2e0400>
8000430e:	187010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_rdc1, 0);
80004312:	4581                	li	a1,0
80004314:	015f07b7          	lui	a5,0x15f0
80004318:	40078513          	add	a0,a5,1024 # 15f0400 <__SHARE_RAM_segment_end__+0x2f0400>
8000431c:	179010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_plb0, 0);
80004320:	4581                	li	a1,0
80004322:	016207b7          	lui	a5,0x1620
80004326:	40078513          	add	a0,a5,1024 # 1620400 <__SHARE_RAM_segment_end__+0x320400>
8000432a:	16b010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_sei0, 0);
8000432e:	4581                	li	a1,0
80004330:	016307b7          	lui	a5,0x1630
80004334:	40078513          	add	a0,a5,1024 # 1630400 <__SHARE_RAM_segment_end__+0x330400>
80004338:	15d010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_mtg0, 0);
8000433c:	4581                	li	a1,0
8000433e:	016407b7          	lui	a5,0x1640
80004342:	40078513          	add	a0,a5,1024 # 1640400 <__SHARE_RAM_segment_end__+0x340400>
80004346:	14f010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_mtg1, 0);
8000434a:	4581                	li	a1,0
8000434c:	016507b7          	lui	a5,0x1650
80004350:	40078513          	add	a0,a5,1024 # 1650400 <__SHARE_RAM_segment_end__+0x350400>
80004354:	141010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_vsc0, 0);
80004358:	4581                	li	a1,0
8000435a:	016607b7          	lui	a5,0x1660
8000435e:	40078513          	add	a0,a5,1024 # 1660400 <__SHARE_RAM_segment_end__+0x360400>
80004362:	133010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_vsc1, 0);
80004366:	4581                	li	a1,0
80004368:	016707b7          	lui	a5,0x1670
8000436c:	40078513          	add	a0,a5,1024 # 1670400 <__SHARE_RAM_segment_end__+0x370400>
80004370:	125010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_clc0, 0);
80004374:	4581                	li	a1,0
80004376:	016807b7          	lui	a5,0x1680
8000437a:	40078513          	add	a0,a5,1024 # 1680400 <__SHARE_RAM_segment_end__+0x380400>
8000437e:	117010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_clc1, 0);
80004382:	4581                	li	a1,0
80004384:	016907b7          	lui	a5,0x1690
80004388:	40078513          	add	a0,a5,1024 # 1690400 <__SHARE_RAM_segment_end__+0x390400>
8000438c:	109010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_emds, 0);
80004390:	4581                	li	a1,0
80004392:	016a07b7          	lui	a5,0x16a0
80004396:	40078513          	add	a0,a5,1024 # 16a0400 <__SHARE_RAM_segment_end__+0x3a0400>
8000439a:	0fb010ef          	jal	80005c94 <clock_add_to_group>
    /* Connect Group0 to CPU0 */
    clock_connect_group_to_cpu(0, 0);
8000439e:	4581                	li	a1,0
800043a0:	4501                	li	a0,0
800043a2:	449030ef          	jal	80007fea <clock_connect_group_to_cpu>

    /* Add the CPU1 clock to Group1 */
    clock_add_to_group(clock_cpu1, 1);
800043a6:	4585                	li	a1,1
800043a8:	000807b7          	lui	a5,0x80
800043ac:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
800043b0:	0e5010ef          	jal	80005c94 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr1, 1);
800043b4:	4585                	li	a1,1
800043b6:	010807b7          	lui	a5,0x1080
800043ba:	00378513          	add	a0,a5,3 # 1080003 <_flash_size+0x80003>
800043be:	0d7010ef          	jal	80005c94 <clock_add_to_group>
    /* Connect Group1 to CPU1 */
    clock_connect_group_to_cpu(1, 1);
800043c2:	4585                	li	a1,1
800043c4:	4505                	li	a0,1
800043c6:	425030ef          	jal	80007fea <clock_connect_group_to_cpu>

    /* Bump up DCDC voltage to 1275mv */
    pcfg_dcdc_set_voltage(HPM_PCFG, 1275);
800043ca:	4fb00593          	li	a1,1275
800043ce:	f4104537          	lui	a0,0xf4104
800043d2:	79d020ef          	jal	8000736e <pcfg_dcdc_set_voltage>

    /* Set CPU clock to 600MHz */
    clock_set_source_divider(clock_cpu0, clk_src_pll0_clk0, 1);
800043d6:	4605                	li	a2,1
800043d8:	4585                	li	a1,1
800043da:	4501                	li	a0,0
800043dc:	32b030ef          	jal	80007f06 <clock_set_source_divider>
    clock_set_source_divider(clock_cpu1, clk_src_pll0_clk0, 1);
800043e0:	4605                	li	a2,1
800043e2:	4585                	li	a1,1
800043e4:	000807b7          	lui	a5,0x80
800043e8:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
800043ec:	31b030ef          	jal	80007f06 <clock_set_source_divider>

    /* Configure mchtmr to 24MHz */
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
800043f0:	4605                	li	a2,1
800043f2:	4581                	li	a1,0
800043f4:	010607b7          	lui	a5,0x1060
800043f8:	00178513          	add	a0,a5,1 # 1060001 <_flash_size+0x60001>
800043fc:	30b030ef          	jal	80007f06 <clock_set_source_divider>
    clock_set_source_divider(clock_mchtmr1, clk_src_osc24m, 1);
80004400:	4605                	li	a2,1
80004402:	4581                	li	a1,0
80004404:	010807b7          	lui	a5,0x1080
80004408:	00378513          	add	a0,a5,3 # 1080003 <_flash_size+0x80003>
8000440c:	2fb030ef          	jal	80007f06 <clock_set_source_divider>

    clock_update_core_clock();
80004410:	151010ef          	jal	80005d60 <clock_update_core_clock>
}
80004414:	0001                	nop
80004416:	40f2                	lw	ra,28(sp)
80004418:	6105                	add	sp,sp,32
8000441a:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_freq_in_hz:

8000443a <pllctlv2_get_pll_freq_in_hz>:
        }
    }
}

uint32_t pllctlv2_get_pll_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
8000443a:	7139                	add	sp,sp,-64
8000443c:	de06                	sw	ra,60(sp)
8000443e:	c62a                	sw	a0,12(sp)
80004440:	87ae                	mv	a5,a1
80004442:	00f105a3          	sb	a5,11(sp)
    uint32_t freq = 0;
80004446:	d602                	sw	zero,44(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80004448:	47b2                	lw	a5,12(sp)
8000444a:	10078e63          	beqz	a5,80004566 <.L36>
8000444e:	00b14703          	lbu	a4,11(sp)
80004452:	4789                	li	a5,2
80004454:	10e7e963          	bltu	a5,a4,80004566 <.L36>

80004458 <.LBB3>:
        uint32_t mfi = PLLCTLV2_PLL_MFI_MFI_GET(ptr->PLL[pll].MFI);
80004458:	00b14783          	lbu	a5,11(sp)
8000445c:	4732                	lw	a4,12(sp)
8000445e:	0785                	add	a5,a5,1
80004460:	079e                	sll	a5,a5,0x7
80004462:	97ba                	add	a5,a5,a4
80004464:	439c                	lw	a5,0(a5)
80004466:	07f7f793          	and	a5,a5,127
8000446a:	d23e                	sw	a5,36(sp)
        uint32_t mfn = PLLCTLV2_PLL_MFN_MFN_GET(ptr->PLL[pll].MFN);
8000446c:	00b14783          	lbu	a5,11(sp)
80004470:	4732                	lw	a4,12(sp)
80004472:	0785                	add	a5,a5,1
80004474:	079e                	sll	a5,a5,0x7
80004476:	97ba                	add	a5,a5,a4
80004478:	43d8                	lw	a4,4(a5)
8000447a:	400007b7          	lui	a5,0x40000
8000447e:	17fd                	add	a5,a5,-1 # 3fffffff <_extram_size+0x3dffffff>
80004480:	8ff9                	and	a5,a5,a4
80004482:	d03e                	sw	a5,32(sp)
        uint32_t mfd = PLLCTLV2_PLL_MFD_MFD_GET(ptr->PLL[pll].MFD);
80004484:	00b14783          	lbu	a5,11(sp)
80004488:	4732                	lw	a4,12(sp)
8000448a:	0785                	add	a5,a5,1
8000448c:	079e                	sll	a5,a5,0x7
8000448e:	97ba                	add	a5,a5,a4
80004490:	4798                	lw	a4,8(a5)
80004492:	400007b7          	lui	a5,0x40000
80004496:	17fd                	add	a5,a5,-1 # 3fffffff <_extram_size+0x3dffffff>
80004498:	8ff9                	and	a5,a5,a4
8000449a:	ce3e                	sw	a5,28(sp)
        /* Trade-off for avoiding the float computing.
         * Ensure both `mfd` and `PLLCTLV2_PLL_XTAL_FREQ` are n * `FREQ_1MHz`, n is a positive integer
         */
        assert((mfd / FREQ_1MHz) * FREQ_1MHz == mfd);
8000449c:	4772                	lw	a4,28(sp)
8000449e:	000f47b7          	lui	a5,0xf4
800044a2:	24078793          	add	a5,a5,576 # f4240 <__AXI_SRAM_segment_size__+0x74240>
800044a6:	02f777b3          	remu	a5,a4,a5
800044aa:	cb89                	beqz	a5,800044bc <.L37>
800044ac:	07400613          	li	a2,116
800044b0:	5c418593          	add	a1,gp,1476 # 80003e54 <.LC0>
800044b4:	60c18513          	add	a0,gp,1548 # 80003e9c <.LC1>
800044b8:	5c7030ef          	jal	8000827e <__SEGGER_RTL_X_assert>

800044bc <.L37>:
        assert((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * FREQ_1MHz == PLLCTLV2_PLL_XTAL_FREQ);

        uint32_t scaled_num;
        uint32_t scaled_denom;
        uint32_t shifted_mfn;
        uint32_t max_mfn = 0xFFFFFFFF / (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz);
800044bc:	0aaab7b7          	lui	a5,0xaaab
800044c0:	aaa78793          	add	a5,a5,-1366 # aaaaaaa <_extram_size+0x8aaaaaa>
800044c4:	cc3e                	sw	a5,24(sp)
        if (mfn < max_mfn) {
800044c6:	5702                	lw	a4,32(sp)
800044c8:	47e2                	lw	a5,24(sp)
800044ca:	02f77e63          	bgeu	a4,a5,80004506 <.L38>
            scaled_num =  (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * mfn;
800044ce:	5702                	lw	a4,32(sp)
800044d0:	87ba                	mv	a5,a4
800044d2:	0786                	sll	a5,a5,0x1
800044d4:	97ba                	add	a5,a5,a4
800044d6:	078e                	sll	a5,a5,0x3
800044d8:	c83e                	sw	a5,16(sp)
            scaled_denom = mfd / FREQ_1MHz;
800044da:	4772                	lw	a4,28(sp)
800044dc:	000f47b7          	lui	a5,0xf4
800044e0:	24078793          	add	a5,a5,576 # f4240 <__AXI_SRAM_segment_size__+0x74240>
800044e4:	02f757b3          	divu	a5,a4,a5
800044e8:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + scaled_num / scaled_denom;
800044ea:	5712                	lw	a4,36(sp)
800044ec:	016e37b7          	lui	a5,0x16e3
800044f0:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
800044f4:	02f70733          	mul	a4,a4,a5
800044f8:	46c2                	lw	a3,16(sp)
800044fa:	47d2                	lw	a5,20(sp)
800044fc:	02f6d7b3          	divu	a5,a3,a5
80004500:	97ba                	add	a5,a5,a4
80004502:	d63e                	sw	a5,44(sp)
80004504:	a08d                	j	80004566 <.L36>

80004506 <.L38>:
        } else {
            shifted_mfn = mfn;
80004506:	5782                	lw	a5,32(sp)
80004508:	d43e                	sw	a5,40(sp)
            while (shifted_mfn > max_mfn) {
8000450a:	a021                	j	80004512 <.L39>

8000450c <.L40>:
                shifted_mfn >>= 1;
8000450c:	57a2                	lw	a5,40(sp)
8000450e:	8385                	srl	a5,a5,0x1
80004510:	d43e                	sw	a5,40(sp)

80004512 <.L39>:
            while (shifted_mfn > max_mfn) {
80004512:	5722                	lw	a4,40(sp)
80004514:	47e2                	lw	a5,24(sp)
80004516:	fee7ebe3          	bltu	a5,a4,8000450c <.L40>
            }
            scaled_denom = mfd / FREQ_1MHz;
8000451a:	4772                	lw	a4,28(sp)
8000451c:	000f47b7          	lui	a5,0xf4
80004520:	24078793          	add	a5,a5,576 # f4240 <__AXI_SRAM_segment_size__+0x74240>
80004524:	02f757b3          	divu	a5,a4,a5
80004528:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * shifted_mfn) / scaled_denom +  ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * (mfn - shifted_mfn)) / scaled_denom;
8000452a:	5712                	lw	a4,36(sp)
8000452c:	016e37b7          	lui	a5,0x16e3
80004530:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
80004534:	02f706b3          	mul	a3,a4,a5
80004538:	5722                	lw	a4,40(sp)
8000453a:	87ba                	mv	a5,a4
8000453c:	0786                	sll	a5,a5,0x1
8000453e:	97ba                	add	a5,a5,a4
80004540:	078e                	sll	a5,a5,0x3
80004542:	873e                	mv	a4,a5
80004544:	47d2                	lw	a5,20(sp)
80004546:	02f757b3          	divu	a5,a4,a5
8000454a:	96be                	add	a3,a3,a5
8000454c:	5702                	lw	a4,32(sp)
8000454e:	57a2                	lw	a5,40(sp)
80004550:	8f1d                	sub	a4,a4,a5
80004552:	87ba                	mv	a5,a4
80004554:	0786                	sll	a5,a5,0x1
80004556:	97ba                	add	a5,a5,a4
80004558:	078e                	sll	a5,a5,0x3
8000455a:	873e                	mv	a4,a5
8000455c:	47d2                	lw	a5,20(sp)
8000455e:	02f757b3          	divu	a5,a4,a5
80004562:	97b6                	add	a5,a5,a3
80004564:	d63e                	sw	a5,44(sp)

80004566 <.L36>:
        }
    }
    return freq;
80004566:	57b2                	lw	a5,44(sp)
}
80004568:	853e                	mv	a0,a5
8000456a:	50f2                	lw	ra,60(sp)
8000456c:	6121                	add	sp,sp,64
8000456e:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

8000457e <read_pmp_cfg>:

#define PMP_ENTRY_MAX 16
#define PMA_ENTRY_MAX 16

uint32_t read_pmp_cfg(uint32_t idx)
{
8000457e:	7179                	add	sp,sp,-48
80004580:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
80004582:	d602                	sw	zero,44(sp)
    switch (idx) {
80004584:	4732                	lw	a4,12(sp)
80004586:	478d                	li	a5,3
80004588:	04f70763          	beq	a4,a5,800045d6 <.L2>
8000458c:	4732                	lw	a4,12(sp)
8000458e:	478d                	li	a5,3
80004590:	04e7e963          	bltu	a5,a4,800045e2 <.L9>
80004594:	4732                	lw	a4,12(sp)
80004596:	4789                	li	a5,2
80004598:	02f70963          	beq	a4,a5,800045ca <.L4>
8000459c:	4732                	lw	a4,12(sp)
8000459e:	4789                	li	a5,2
800045a0:	04e7e163          	bltu	a5,a4,800045e2 <.L9>
800045a4:	47b2                	lw	a5,12(sp)
800045a6:	c791                	beqz	a5,800045b2 <.L5>
800045a8:	4732                	lw	a4,12(sp)
800045aa:	4785                	li	a5,1
800045ac:	00f70963          	beq	a4,a5,800045be <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
800045b0:	a80d                	j	800045e2 <.L9>

800045b2 <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
800045b2:	3a0027f3          	csrr	a5,pmpcfg0
800045b6:	ce3e                	sw	a5,28(sp)
800045b8:	47f2                	lw	a5,28(sp)

800045ba <.LBE2>:
800045ba:	d63e                	sw	a5,44(sp)
        break;
800045bc:	a025                	j	800045e4 <.L7>

800045be <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
800045be:	3a1027f3          	csrr	a5,pmpcfg1
800045c2:	d03e                	sw	a5,32(sp)
800045c4:	5782                	lw	a5,32(sp)

800045c6 <.LBE3>:
800045c6:	d63e                	sw	a5,44(sp)
        break;
800045c8:	a831                	j	800045e4 <.L7>

800045ca <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
800045ca:	3a2027f3          	csrr	a5,pmpcfg2
800045ce:	d23e                	sw	a5,36(sp)
800045d0:	5792                	lw	a5,36(sp)

800045d2 <.LBE4>:
800045d2:	d63e                	sw	a5,44(sp)
        break;
800045d4:	a801                	j	800045e4 <.L7>

800045d6 <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
800045d6:	3a3027f3          	csrr	a5,pmpcfg3
800045da:	d43e                	sw	a5,40(sp)
800045dc:	57a2                	lw	a5,40(sp)

800045de <.LBE5>:
800045de:	d63e                	sw	a5,44(sp)
        break;
800045e0:	a011                	j	800045e4 <.L7>

800045e2 <.L9>:
        break;
800045e2:	0001                	nop

800045e4 <.L7>:
    }
    return pmp_cfg;
800045e4:	57b2                	lw	a5,44(sp)
}
800045e6:	853e                	mv	a0,a5
800045e8:	6145                	add	sp,sp,48
800045ea:	8082                	ret

Disassembly of section .text.write_pmp_addr:

800045f6 <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
800045f6:	1141                	add	sp,sp,-16
800045f8:	c62a                	sw	a0,12(sp)
800045fa:	c42e                	sw	a1,8(sp)
    switch (idx) {
800045fc:	4722                	lw	a4,8(sp)
800045fe:	47bd                	li	a5,15
80004600:	08e7ea63          	bltu	a5,a4,80004694 <.L38>
80004604:	47a2                	lw	a5,8(sp)
80004606:	00279713          	sll	a4,a5,0x2
8000460a:	87818793          	add	a5,gp,-1928 # 80003108 <.L21>
8000460e:	97ba                	add	a5,a5,a4
80004610:	439c                	lw	a5,0(a5)
80004612:	8782                	jr	a5

80004614 <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
80004614:	47b2                	lw	a5,12(sp)
80004616:	3b079073          	csrw	pmpaddr0,a5
        break;
8000461a:	a8b5                	j	80004696 <.L37>

8000461c <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
8000461c:	47b2                	lw	a5,12(sp)
8000461e:	3b179073          	csrw	pmpaddr1,a5
        break;
80004622:	a895                	j	80004696 <.L37>

80004624 <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
80004624:	47b2                	lw	a5,12(sp)
80004626:	3b279073          	csrw	pmpaddr2,a5
        break;
8000462a:	a0b5                	j	80004696 <.L37>

8000462c <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
8000462c:	47b2                	lw	a5,12(sp)
8000462e:	3b379073          	csrw	pmpaddr3,a5
        break;
80004632:	a095                	j	80004696 <.L37>

80004634 <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
80004634:	47b2                	lw	a5,12(sp)
80004636:	3b479073          	csrw	pmpaddr4,a5
        break;
8000463a:	a8b1                	j	80004696 <.L37>

8000463c <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
8000463c:	47b2                	lw	a5,12(sp)
8000463e:	3b579073          	csrw	pmpaddr5,a5
        break;
80004642:	a891                	j	80004696 <.L37>

80004644 <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
80004644:	47b2                	lw	a5,12(sp)
80004646:	3b679073          	csrw	pmpaddr6,a5
        break;
8000464a:	a0b1                	j	80004696 <.L37>

8000464c <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
8000464c:	47b2                	lw	a5,12(sp)
8000464e:	3b779073          	csrw	pmpaddr7,a5
        break;
80004652:	a091                	j	80004696 <.L37>

80004654 <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
80004654:	47b2                	lw	a5,12(sp)
80004656:	3b879073          	csrw	pmpaddr8,a5
        break;
8000465a:	a835                	j	80004696 <.L37>

8000465c <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
8000465c:	47b2                	lw	a5,12(sp)
8000465e:	3b979073          	csrw	pmpaddr9,a5
        break;
80004662:	a815                	j	80004696 <.L37>

80004664 <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
80004664:	47b2                	lw	a5,12(sp)
80004666:	3ba79073          	csrw	pmpaddr10,a5
        break;
8000466a:	a035                	j	80004696 <.L37>

8000466c <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
8000466c:	47b2                	lw	a5,12(sp)
8000466e:	3bb79073          	csrw	pmpaddr11,a5
        break;
80004672:	a015                	j	80004696 <.L37>

80004674 <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
80004674:	47b2                	lw	a5,12(sp)
80004676:	3bc79073          	csrw	pmpaddr12,a5
        break;
8000467a:	a831                	j	80004696 <.L37>

8000467c <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
8000467c:	47b2                	lw	a5,12(sp)
8000467e:	3bd79073          	csrw	pmpaddr13,a5
        break;
80004682:	a811                	j	80004696 <.L37>

80004684 <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
80004684:	47b2                	lw	a5,12(sp)
80004686:	3be79073          	csrw	pmpaddr14,a5
        break;
8000468a:	a031                	j	80004696 <.L37>

8000468c <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
8000468c:	47b2                	lw	a5,12(sp)
8000468e:	3bf79073          	csrw	pmpaddr15,a5
        break;
80004692:	a011                	j	80004696 <.L37>

80004694 <.L38>:
    default:
        /* Do nothing */
        break;
80004694:	0001                	nop

80004696 <.L37>:
    }
}
80004696:	0001                	nop
80004698:	0141                	add	sp,sp,16
8000469a:	8082                	ret

Disassembly of section .text.read_pma_cfg:

800046a6 <read_pma_cfg>:
    return status_success;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
800046a6:	7179                	add	sp,sp,-48
800046a8:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
800046aa:	d602                	sw	zero,44(sp)
    switch (idx) {
800046ac:	4732                	lw	a4,12(sp)
800046ae:	478d                	li	a5,3
800046b0:	04f70763          	beq	a4,a5,800046fe <.L72>
800046b4:	4732                	lw	a4,12(sp)
800046b6:	478d                	li	a5,3
800046b8:	04e7e963          	bltu	a5,a4,8000470a <.L79>
800046bc:	4732                	lw	a4,12(sp)
800046be:	4789                	li	a5,2
800046c0:	02f70963          	beq	a4,a5,800046f2 <.L74>
800046c4:	4732                	lw	a4,12(sp)
800046c6:	4789                	li	a5,2
800046c8:	04e7e163          	bltu	a5,a4,8000470a <.L79>
800046cc:	47b2                	lw	a5,12(sp)
800046ce:	c791                	beqz	a5,800046da <.L75>
800046d0:	4732                	lw	a4,12(sp)
800046d2:	4785                	li	a5,1
800046d4:	00f70963          	beq	a4,a5,800046e6 <.L76>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
800046d8:	a80d                	j	8000470a <.L79>

800046da <.L75>:
        pma_cfg = read_csr(CSR_PMACFG0);
800046da:	bc0027f3          	csrr	a5,0xbc0
800046de:	ce3e                	sw	a5,28(sp)
800046e0:	47f2                	lw	a5,28(sp)

800046e2 <.LBE24>:
800046e2:	d63e                	sw	a5,44(sp)
        break;
800046e4:	a025                	j	8000470c <.L77>

800046e6 <.L76>:
        pma_cfg = read_csr(CSR_PMACFG1);
800046e6:	bc1027f3          	csrr	a5,0xbc1
800046ea:	d03e                	sw	a5,32(sp)
800046ec:	5782                	lw	a5,32(sp)

800046ee <.LBE25>:
800046ee:	d63e                	sw	a5,44(sp)
        break;
800046f0:	a831                	j	8000470c <.L77>

800046f2 <.L74>:
        pma_cfg = read_csr(CSR_PMACFG2);
800046f2:	bc2027f3          	csrr	a5,0xbc2
800046f6:	d23e                	sw	a5,36(sp)
800046f8:	5792                	lw	a5,36(sp)

800046fa <.LBE26>:
800046fa:	d63e                	sw	a5,44(sp)
        break;
800046fc:	a801                	j	8000470c <.L77>

800046fe <.L72>:
        pma_cfg = read_csr(CSR_PMACFG3);
800046fe:	bc3027f3          	csrr	a5,0xbc3
80004702:	d43e                	sw	a5,40(sp)
80004704:	57a2                	lw	a5,40(sp)

80004706 <.LBE27>:
80004706:	d63e                	sw	a5,44(sp)
        break;
80004708:	a011                	j	8000470c <.L77>

8000470a <.L79>:
        break;
8000470a:	0001                	nop

8000470c <.L77>:
    }
    return pma_cfg;
8000470c:	57b2                	lw	a5,44(sp)
}
8000470e:	853e                	mv	a0,a5
80004710:	6145                	add	sp,sp,48
80004712:	8082                	ret

Disassembly of section .text.write_pma_addr:

80004c0c <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
80004c0c:	1141                	add	sp,sp,-16
80004c0e:	c62a                	sw	a0,12(sp)
80004c10:	c42e                	sw	a1,8(sp)
    switch (idx) {
80004c12:	4722                	lw	a4,8(sp)
80004c14:	47bd                	li	a5,15
80004c16:	08e7ea63          	bltu	a5,a4,80004caa <.L108>
80004c1a:	47a2                	lw	a5,8(sp)
80004c1c:	00279713          	sll	a4,a5,0x2
80004c20:	8b818793          	add	a5,gp,-1864 # 80003148 <.L91>
80004c24:	97ba                	add	a5,a5,a4
80004c26:	439c                	lw	a5,0(a5)
80004c28:	8782                	jr	a5

80004c2a <.L106>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
80004c2a:	47b2                	lw	a5,12(sp)
80004c2c:	bd079073          	csrw	0xbd0,a5
        break;
80004c30:	a8b5                	j	80004cac <.L107>

80004c32 <.L105>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
80004c32:	47b2                	lw	a5,12(sp)
80004c34:	bd179073          	csrw	0xbd1,a5
        break;
80004c38:	a895                	j	80004cac <.L107>

80004c3a <.L104>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
80004c3a:	47b2                	lw	a5,12(sp)
80004c3c:	bd279073          	csrw	0xbd2,a5
        break;
80004c40:	a0b5                	j	80004cac <.L107>

80004c42 <.L103>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
80004c42:	47b2                	lw	a5,12(sp)
80004c44:	bd379073          	csrw	0xbd3,a5
        break;
80004c48:	a095                	j	80004cac <.L107>

80004c4a <.L102>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
80004c4a:	47b2                	lw	a5,12(sp)
80004c4c:	bd479073          	csrw	0xbd4,a5
        break;
80004c50:	a8b1                	j	80004cac <.L107>

80004c52 <.L101>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
80004c52:	47b2                	lw	a5,12(sp)
80004c54:	bd579073          	csrw	0xbd5,a5
        break;
80004c58:	a891                	j	80004cac <.L107>

80004c5a <.L100>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
80004c5a:	47b2                	lw	a5,12(sp)
80004c5c:	bd679073          	csrw	0xbd6,a5
        break;
80004c60:	a0b1                	j	80004cac <.L107>

80004c62 <.L99>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
80004c62:	47b2                	lw	a5,12(sp)
80004c64:	bd779073          	csrw	0xbd7,a5
        break;
80004c68:	a091                	j	80004cac <.L107>

80004c6a <.L98>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
80004c6a:	47b2                	lw	a5,12(sp)
80004c6c:	bd879073          	csrw	0xbd8,a5
        break;
80004c70:	a835                	j	80004cac <.L107>

80004c72 <.L97>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
80004c72:	47b2                	lw	a5,12(sp)
80004c74:	bd979073          	csrw	0xbd9,a5
        break;
80004c78:	a815                	j	80004cac <.L107>

80004c7a <.L96>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
80004c7a:	47b2                	lw	a5,12(sp)
80004c7c:	bda79073          	csrw	0xbda,a5
        break;
80004c80:	a035                	j	80004cac <.L107>

80004c82 <.L95>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
80004c82:	47b2                	lw	a5,12(sp)
80004c84:	bdb79073          	csrw	0xbdb,a5
        break;
80004c88:	a015                	j	80004cac <.L107>

80004c8a <.L94>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
80004c8a:	47b2                	lw	a5,12(sp)
80004c8c:	bdc79073          	csrw	0xbdc,a5
        break;
80004c90:	a831                	j	80004cac <.L107>

80004c92 <.L93>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
80004c92:	47b2                	lw	a5,12(sp)
80004c94:	bdd79073          	csrw	0xbdd,a5
        break;
80004c98:	a811                	j	80004cac <.L107>

80004c9a <.L92>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
80004c9a:	47b2                	lw	a5,12(sp)
80004c9c:	bde79073          	csrw	0xbde,a5
        break;
80004ca0:	a031                	j	80004cac <.L107>

80004ca2 <.L90>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
80004ca2:	47b2                	lw	a5,12(sp)
80004ca4:	bdf79073          	csrw	0xbdf,a5
        break;
80004ca8:	a011                	j	80004cac <.L107>

80004caa <.L108>:
    default:
        /* Do nothing */
        break;
80004caa:	0001                	nop

80004cac <.L107>:
    }
}
80004cac:	0001                	nop
80004cae:	0141                	add	sp,sp,16
80004cb0:	8082                	ret

Disassembly of section .text.pmp_config:

80004cb2 <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
80004cb2:	7139                	add	sp,sp,-64
80004cb4:	de06                	sw	ra,60(sp)
80004cb6:	c62a                	sw	a0,12(sp)
80004cb8:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
80004cba:	4789                	li	a5,2
80004cbc:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > 15U));
80004cbe:	47b2                	lw	a5,12(sp)
80004cc0:	cfcd                	beqz	a5,80004d7a <.L140>
80004cc2:	47a2                	lw	a5,8(sp)
80004cc4:	cbdd                	beqz	a5,80004d7a <.L140>
80004cc6:	4722                	lw	a4,8(sp)
80004cc8:	47bd                	li	a5,15
80004cca:	0ae7e863          	bltu	a5,a4,80004d7a <.L140>

80004cce <.LBB47>:

        for (uint32_t i = 0; i < num_of_entries; i++) {
80004cce:	d402                	sw	zero,40(sp)
80004cd0:	a871                	j	80004d6c <.L141>

80004cd2 <.L142>:
            uint32_t idx = i / 4;
80004cd2:	57a2                	lw	a5,40(sp)
80004cd4:	8389                	srl	a5,a5,0x2
80004cd6:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
80004cd8:	57a2                	lw	a5,40(sp)
80004cda:	078e                	sll	a5,a5,0x3
80004cdc:	8be1                	and	a5,a5,24
80004cde:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
80004ce0:	5512                	lw	a0,36(sp)
80004ce2:	3871                	jal	8000457e <read_pmp_cfg>
80004ce4:	ce2a                	sw	a0,28(sp)
            pmp_cfg &= ~(0xFFUL << offset);
80004ce6:	5782                	lw	a5,32(sp)
80004ce8:	0ff00713          	li	a4,255
80004cec:	00f717b3          	sll	a5,a4,a5
80004cf0:	fff7c793          	not	a5,a5
80004cf4:	4772                	lw	a4,28(sp)
80004cf6:	8ff9                	and	a5,a5,a4
80004cf8:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t)entry->pmp_cfg.val) << offset;
80004cfa:	47b2                	lw	a5,12(sp)
80004cfc:	0007c783          	lbu	a5,0(a5)
80004d00:	873e                	mv	a4,a5
80004d02:	5782                	lw	a5,32(sp)
80004d04:	00f717b3          	sll	a5,a4,a5
80004d08:	4772                	lw	a4,28(sp)
80004d0a:	8fd9                	or	a5,a5,a4
80004d0c:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
80004d0e:	47b2                	lw	a5,12(sp)
80004d10:	43dc                	lw	a5,4(a5)
80004d12:	55a2                	lw	a1,40(sp)
80004d14:	853e                	mv	a0,a5
80004d16:	30c5                	jal	800045f6 <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
80004d18:	5592                	lw	a1,36(sp)
80004d1a:	4572                	lw	a0,28(sp)
80004d1c:	726020ef          	jal	80007442 <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
80004d20:	5512                	lw	a0,36(sp)
80004d22:	3251                	jal	800046a6 <read_pma_cfg>
80004d24:	cc2a                	sw	a0,24(sp)
            pma_cfg &= ~(0xFFUL << offset);
80004d26:	5782                	lw	a5,32(sp)
80004d28:	0ff00713          	li	a4,255
80004d2c:	00f717b3          	sll	a5,a4,a5
80004d30:	fff7c793          	not	a5,a5
80004d34:	4762                	lw	a4,24(sp)
80004d36:	8ff9                	and	a5,a5,a4
80004d38:	cc3e                	sw	a5,24(sp)
            pma_cfg |= ((uint32_t)entry->pma_cfg.val) << offset;
80004d3a:	47b2                	lw	a5,12(sp)
80004d3c:	0087c783          	lbu	a5,8(a5)
80004d40:	873e                	mv	a4,a5
80004d42:	5782                	lw	a5,32(sp)
80004d44:	00f717b3          	sll	a5,a4,a5
80004d48:	4762                	lw	a4,24(sp)
80004d4a:	8fd9                	or	a5,a5,a4
80004d4c:	cc3e                	sw	a5,24(sp)
            write_pma_cfg(pma_cfg, idx);
80004d4e:	5592                	lw	a1,36(sp)
80004d50:	4562                	lw	a0,24(sp)
80004d52:	74c020ef          	jal	8000749e <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
80004d56:	47b2                	lw	a5,12(sp)
80004d58:	47dc                	lw	a5,12(a5)
80004d5a:	55a2                	lw	a1,40(sp)
80004d5c:	853e                	mv	a0,a5
80004d5e:	357d                	jal	80004c0c <write_pma_addr>
#endif
            ++entry;
80004d60:	47b2                	lw	a5,12(sp)
80004d62:	07c1                	add	a5,a5,16
80004d64:	c63e                	sw	a5,12(sp)

80004d66 <.LBE48>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
80004d66:	57a2                	lw	a5,40(sp)
80004d68:	0785                	add	a5,a5,1
80004d6a:	d43e                	sw	a5,40(sp)

80004d6c <.L141>:
80004d6c:	5722                	lw	a4,40(sp)
80004d6e:	47a2                	lw	a5,8(sp)
80004d70:	f6f761e3          	bltu	a4,a5,80004cd2 <.L142>

80004d74 <.LBE47>:
        }
        fencei();
80004d74:	0000100f          	fence.i

        status = status_success;
80004d78:	d602                	sw	zero,44(sp)

80004d7a <.L140>:

    } while (false);

    return status;
80004d7a:	57b2                	lw	a5,44(sp)
}
80004d7c:	853e                	mv	a0,a5
80004d7e:	50f2                	lw	ra,60(sp)
80004d80:	6121                	add	sp,sp,64
80004d82:	8082                	ret

Disassembly of section .text.spi_get_data_length_in_bytes:

80004d84 <spi_get_data_length_in_bytes>:
 *
 * @param ptr SPI base address.
 * @retval SPI data length in bytes
 */
static inline uint8_t spi_get_data_length_in_bytes(SPI_Type *ptr)
{
80004d84:	1101                	add	sp,sp,-32
80004d86:	ce06                	sw	ra,28(sp)
80004d88:	c62a                	sw	a0,12(sp)
    return ((spi_get_data_length_in_bits(ptr) + 7U) / 8U);
80004d8a:	4532                	lw	a0,12(sp)
80004d8c:	76e020ef          	jal	800074fa <spi_get_data_length_in_bits>
80004d90:	87aa                	mv	a5,a0
80004d92:	079d                	add	a5,a5,7
80004d94:	838d                	srl	a5,a5,0x3
80004d96:	0ff7f793          	zext.b	a5,a5
}
80004d9a:	853e                	mv	a0,a5
80004d9c:	40f2                	lw	ra,28(sp)
80004d9e:	6105                	add	sp,sp,32
80004da0:	8082                	ret

Disassembly of section .text.spi_is_active:

80004da2 <spi_is_active>:
 *
 * @param ptr SPI base address.
 * @retval bool true for active, false for inactive
 */
static inline bool spi_is_active(SPI_Type *ptr)
{
80004da2:	1141                	add	sp,sp,-16
80004da4:	c62a                	sw	a0,12(sp)
    return ((ptr->STATUS & SPI_STATUS_SPIACTIVE_MASK) == SPI_STATUS_SPIACTIVE_MASK) ? true : false;
80004da6:	47b2                	lw	a5,12(sp)
80004da8:	5bdc                	lw	a5,52(a5)
80004daa:	8b85                	and	a5,a5,1
80004dac:	17fd                	add	a5,a5,-1
80004dae:	0017b793          	seqz	a5,a5
80004db2:	0ff7f793          	zext.b	a5,a5
}
80004db6:	853e                	mv	a0,a5
80004db8:	0141                	add	sp,sp,16
80004dba:	8082                	ret

Disassembly of section .text.spi_get_rx_fifo_valid_data_size:

80004dbc <spi_get_rx_fifo_valid_data_size>:
 * @param [in] ptr SPI base address
 *
 * @return rx fifo valid data size
 */
static inline uint8_t spi_get_rx_fifo_valid_data_size(SPI_Type *ptr)
{
80004dbc:	1141                	add	sp,sp,-16
80004dbe:	c62a                	sw	a0,12(sp)
    return ((SPI_STATUS_RXNUM_7_6_GET(ptr->STATUS) << 6) | SPI_STATUS_RXNUM_5_0_GET(ptr->STATUS));
80004dc0:	47b2                	lw	a5,12(sp)
80004dc2:	5bdc                	lw	a5,52(a5)
80004dc4:	83e1                	srl	a5,a5,0x18
80004dc6:	0ff7f793          	zext.b	a5,a5
80004dca:	079a                	sll	a5,a5,0x6
80004dcc:	0ff7f713          	zext.b	a4,a5
80004dd0:	47b2                	lw	a5,12(sp)
80004dd2:	5bdc                	lw	a5,52(a5)
80004dd4:	83a1                	srl	a5,a5,0x8
80004dd6:	0ff7f793          	zext.b	a5,a5
80004dda:	03f7f793          	and	a5,a5,63
80004dde:	0ff7f793          	zext.b	a5,a5
80004de2:	8fd9                	or	a5,a5,a4
80004de4:	0ff7f793          	zext.b	a5,a5
}
80004de8:	853e                	mv	a0,a5
80004dea:	0141                	add	sp,sp,16
80004dec:	8082                	ret

Disassembly of section .text.spi_write_command:

80004dee <spi_write_command>:

    return status_success;
}

hpm_stat_t spi_write_command(SPI_Type *ptr, spi_mode_selection_t mode, spi_control_config_t *config, uint8_t *cmd)
{
80004dee:	1141                	add	sp,sp,-16
80004df0:	c62a                	sw	a0,12(sp)
80004df2:	87ae                	mv	a5,a1
80004df4:	c232                	sw	a2,4(sp)
80004df6:	c036                	sw	a3,0(sp)
80004df8:	00f105a3          	sb	a5,11(sp)
    if (mode == spi_master_mode) {
80004dfc:	00b14783          	lbu	a5,11(sp)
80004e00:	e785                	bnez	a5,80004e28 <.L24>
        if (config->master_config.cmd_enable == true) {
80004e02:	4792                	lw	a5,4(sp)
80004e04:	0007c783          	lbu	a5,0(a5)
80004e08:	cf81                	beqz	a5,80004e20 <.L25>
            if (cmd == NULL) {
80004e0a:	4782                	lw	a5,0(sp)
80004e0c:	e399                	bnez	a5,80004e12 <.L26>
                return status_invalid_argument;
80004e0e:	4789                	li	a5,2
80004e10:	a829                	j	80004e2a <.L27>

80004e12 <.L26>:
            }
            ptr->CMD = SPI_CMD_CMD_SET(*cmd);
80004e12:	4782                	lw	a5,0(sp)
80004e14:	0007c783          	lbu	a5,0(a5)
80004e18:	873e                	mv	a4,a5
80004e1a:	47b2                	lw	a5,12(sp)
80004e1c:	d3d8                	sw	a4,36(a5)
80004e1e:	a029                	j	80004e28 <.L24>

80004e20 <.L25>:
        } else {
            ptr->CMD = SPI_CMD_CMD_SET(0xff); /* Write a dummy byte */
80004e20:	47b2                	lw	a5,12(sp)
80004e22:	0ff00713          	li	a4,255
80004e26:	d3d8                	sw	a4,36(a5)

80004e28 <.L24>:
        }
    }

    return status_success;
80004e28:	4781                	li	a5,0

80004e2a <.L27>:
}
80004e2a:	853e                	mv	a0,a5
80004e2c:	0141                	add	sp,sp,16
80004e2e:	8082                	ret

Disassembly of section .text.spi_read_command:

80004e30 <spi_read_command>:

hpm_stat_t spi_read_command(SPI_Type *ptr, spi_mode_selection_t mode, spi_control_config_t *config, uint8_t *cmd)
{
80004e30:	1141                	add	sp,sp,-16
80004e32:	c62a                	sw	a0,12(sp)
80004e34:	87ae                	mv	a5,a1
80004e36:	c232                	sw	a2,4(sp)
80004e38:	c036                	sw	a3,0(sp)
80004e3a:	00f105a3          	sb	a5,11(sp)
    if (mode == spi_slave_mode) {
80004e3e:	00b14703          	lbu	a4,11(sp)
80004e42:	4785                	li	a5,1
80004e44:	02f71563          	bne	a4,a5,80004e6e <.L29>
        if (config->slave_config.slave_data_only == false) {
80004e48:	4792                	lw	a5,4(sp)
80004e4a:	0057c783          	lbu	a5,5(a5)
80004e4e:	0017c793          	xor	a5,a5,1
80004e52:	0ff7f793          	zext.b	a5,a5
80004e56:	cf81                	beqz	a5,80004e6e <.L29>
            if (cmd == NULL) {
80004e58:	4782                	lw	a5,0(sp)
80004e5a:	e399                	bnez	a5,80004e60 <.L30>
                return status_invalid_argument;
80004e5c:	4789                	li	a5,2
80004e5e:	a809                	j	80004e70 <.L31>

80004e60 <.L30>:
            }
            *cmd = (uint8_t)(ptr->CMD & SPI_CMD_CMD_MASK) >> SPI_CMD_CMD_SHIFT;
80004e60:	47b2                	lw	a5,12(sp)
80004e62:	53dc                	lw	a5,36(a5)
80004e64:	0ff7f713          	zext.b	a4,a5
80004e68:	4782                	lw	a5,0(sp)
80004e6a:	00e78023          	sb	a4,0(a5)

80004e6e <.L29>:
        }
    }

    return status_success;
80004e6e:	4781                	li	a5,0

80004e70 <.L31>:
}
80004e70:	853e                	mv	a0,a5
80004e72:	0141                	add	sp,sp,16
80004e74:	8082                	ret

Disassembly of section .text.spi_write_data:

80004e76 <spi_write_data>:

    return status_success;
}

hpm_stat_t spi_write_data(SPI_Type *ptr, uint8_t data_len_in_bytes, uint8_t *buff, uint32_t count)
{
80004e76:	7179                	add	sp,sp,-48
80004e78:	c62a                	sw	a0,12(sp)
80004e7a:	87ae                	mv	a5,a1
80004e7c:	c232                	sw	a2,4(sp)
80004e7e:	c036                	sw	a3,0(sp)
80004e80:	00f105a3          	sb	a5,11(sp)
    uint32_t status;
    uint32_t transferred = 0;
80004e84:	d602                	sw	zero,44(sp)
    uint32_t retry = 0;
80004e86:	d402                	sw	zero,40(sp)
    uint32_t temp;

    /* check parameter validity */
    if (buff == NULL || count == 0) {
80004e88:	4792                	lw	a5,4(sp)
80004e8a:	c399                	beqz	a5,80004e90 <.L37>
80004e8c:	4782                	lw	a5,0(sp)
80004e8e:	e399                	bnez	a5,80004e94 <.L38>

80004e90 <.L37>:
        return status_invalid_argument;
80004e90:	4789                	li	a5,2
80004e92:	a055                	j	80004f36 <.L39>

80004e94 <.L38>:
    }

    if (data_len_in_bytes > 4 || data_len_in_bytes < 1) {
80004e94:	00b14703          	lbu	a4,11(sp)
80004e98:	4791                	li	a5,4
80004e9a:	00e7e563          	bltu	a5,a4,80004ea4 <.L40>
80004e9e:	00b14783          	lbu	a5,11(sp)
80004ea2:	ebbd                	bnez	a5,80004f18 <.L42>

80004ea4 <.L40>:
        return status_invalid_argument;
80004ea4:	4789                	li	a5,2
80004ea6:	a841                	j	80004f36 <.L39>

80004ea8 <.L48>:
    }

    /* data transfer */
    while (transferred < count) {
        status = ptr->STATUS;
80004ea8:	47b2                	lw	a5,12(sp)
80004eaa:	5bdc                	lw	a5,52(a5)
80004eac:	ce3e                	sw	a5,28(sp)
        if (!(status & SPI_STATUS_TXFULL_MASK)) {
80004eae:	4772                	lw	a4,28(sp)
80004eb0:	008007b7          	lui	a5,0x800
80004eb4:	8ff9                	and	a5,a5,a4
80004eb6:	eba1                	bnez	a5,80004f06 <.L43>
            /* write data into the txfifo */
            temp = 0;
80004eb8:	d202                	sw	zero,36(sp)

80004eba <.LBB2>:
            for (uint8_t i = 0; i < data_len_in_bytes; i++) {
80004eba:	020101a3          	sb	zero,35(sp)
80004ebe:	a035                	j	80004eea <.L44>

80004ec0 <.L45>:
                temp += *(buff++) << i * 8;
80004ec0:	4792                	lw	a5,4(sp)
80004ec2:	00178713          	add	a4,a5,1 # 800001 <__DLM_segment_end__+0x5c0001>
80004ec6:	c23a                	sw	a4,4(sp)
80004ec8:	0007c783          	lbu	a5,0(a5)
80004ecc:	873e                	mv	a4,a5
80004ece:	02314783          	lbu	a5,35(sp)
80004ed2:	078e                	sll	a5,a5,0x3
80004ed4:	00f717b3          	sll	a5,a4,a5
80004ed8:	873e                	mv	a4,a5
80004eda:	5792                	lw	a5,36(sp)
80004edc:	97ba                	add	a5,a5,a4
80004ede:	d23e                	sw	a5,36(sp)
            for (uint8_t i = 0; i < data_len_in_bytes; i++) {
80004ee0:	02314783          	lbu	a5,35(sp)
80004ee4:	0785                	add	a5,a5,1
80004ee6:	02f101a3          	sb	a5,35(sp)

80004eea <.L44>:
80004eea:	02314703          	lbu	a4,35(sp)
80004eee:	00b14783          	lbu	a5,11(sp)
80004ef2:	fcf767e3          	bltu	a4,a5,80004ec0 <.L45>

80004ef6 <.LBE2>:
            }
            ptr->DATA = temp;
80004ef6:	47b2                	lw	a5,12(sp)
80004ef8:	5712                	lw	a4,36(sp)
80004efa:	d7d8                	sw	a4,44(a5)
            /* transfer count increment */
            transferred++;
80004efc:	57b2                	lw	a5,44(sp)
80004efe:	0785                	add	a5,a5,1
80004f00:	d63e                	sw	a5,44(sp)
            retry = 0;
80004f02:	d402                	sw	zero,40(sp)
80004f04:	a811                	j	80004f18 <.L42>

80004f06 <.L43>:
        } else {
            if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
80004f06:	5722                	lw	a4,40(sp)
80004f08:	6785                	lui	a5,0x1
80004f0a:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80004f0e:	00e7ea63          	bltu	a5,a4,80004f22 <.L50>
                break;
            }
            retry++;
80004f12:	57a2                	lw	a5,40(sp)
80004f14:	0785                	add	a5,a5,1
80004f16:	d43e                	sw	a5,40(sp)

80004f18 <.L42>:
    while (transferred < count) {
80004f18:	5732                	lw	a4,44(sp)
80004f1a:	4782                	lw	a5,0(sp)
80004f1c:	f8f766e3          	bltu	a4,a5,80004ea8 <.L48>
80004f20:	a011                	j	80004f24 <.L47>

80004f22 <.L50>:
                break;
80004f22:	0001                	nop

80004f24 <.L47>:
        }
    }

    if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
80004f24:	5722                	lw	a4,40(sp)
80004f26:	6785                	lui	a5,0x1
80004f28:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80004f2c:	00e7f463          	bgeu	a5,a4,80004f34 <.L49>
        /* dummy state may triggers timeout if dummy count, retry count, spi rate and cpu frequency are inappropriate */
        return status_timeout;
80004f30:	478d                	li	a5,3
80004f32:	a011                	j	80004f36 <.L39>

80004f34 <.L49>:
    }

    return status_success;
80004f34:	4781                	li	a5,0

80004f36 <.L39>:
}
80004f36:	853e                	mv	a0,a5
80004f38:	6145                	add	sp,sp,48
80004f3a:	8082                	ret

Disassembly of section .text.spi_read_data:

80004f3c <spi_read_data>:

hpm_stat_t spi_read_data(SPI_Type *ptr, uint8_t data_len_in_bytes, uint8_t *buff, uint32_t count)
{
80004f3c:	7179                	add	sp,sp,-48
80004f3e:	d606                	sw	ra,44(sp)
80004f40:	c62a                	sw	a0,12(sp)
80004f42:	87ae                	mv	a5,a1
80004f44:	c232                	sw	a2,4(sp)
80004f46:	c036                	sw	a3,0(sp)
80004f48:	00f105a3          	sb	a5,11(sp)
    uint32_t transferred = 0;
80004f4c:	ce02                	sw	zero,28(sp)
    uint32_t retry = 0;
80004f4e:	cc02                	sw	zero,24(sp)
    uint32_t temp;
    uint8_t rx_valid_size = 0;
80004f50:	00010aa3          	sb	zero,21(sp)
    uint8_t j = 0;
80004f54:	00010ba3          	sb	zero,23(sp)
    /* check parameter validity */
    if (buff == NULL || count == 0) {
80004f58:	4792                	lw	a5,4(sp)
80004f5a:	c399                	beqz	a5,80004f60 <.L52>
80004f5c:	4782                	lw	a5,0(sp)
80004f5e:	e399                	bnez	a5,80004f64 <.L53>

80004f60 <.L52>:
        return status_invalid_argument;
80004f60:	4789                	li	a5,2
80004f62:	a0d9                	j	80005028 <.L54>

80004f64 <.L53>:
    }

    if (data_len_in_bytes > 4 || data_len_in_bytes < 1) {
80004f64:	00b14703          	lbu	a4,11(sp)
80004f68:	4791                	li	a5,4
80004f6a:	00e7e563          	bltu	a5,a4,80004f74 <.L55>
80004f6e:	00b14783          	lbu	a5,11(sp)
80004f72:	efc1                	bnez	a5,8000500a <.L57>

80004f74 <.L55>:
        return status_invalid_argument;
80004f74:	4789                	li	a5,2
80004f76:	a84d                	j	80005028 <.L54>

80004f78 <.L67>:
    }

    /* data transfer */
    while (transferred < count) {
        rx_valid_size = spi_get_rx_fifo_valid_data_size(ptr);
80004f78:	4532                	lw	a0,12(sp)
80004f7a:	3589                	jal	80004dbc <spi_get_rx_fifo_valid_data_size>
80004f7c:	87aa                	mv	a5,a0
80004f7e:	00f10aa3          	sb	a5,21(sp)
        if (rx_valid_size > 0) {
80004f82:	01514783          	lbu	a5,21(sp)
80004f86:	cbad                	beqz	a5,80004ff8 <.L58>
            for (j = 0; j < rx_valid_size; j++) {
80004f88:	00010ba3          	sb	zero,23(sp)
80004f8c:	a8a1                	j	80004fe4 <.L59>

80004f8e <.L64>:
                temp = ptr->DATA;
80004f8e:	47b2                	lw	a5,12(sp)
80004f90:	57dc                	lw	a5,44(a5)
80004f92:	c83e                	sw	a5,16(sp)

80004f94 <.LBB3>:
                for (uint8_t i = 0; i < data_len_in_bytes; i++) {
80004f94:	00010b23          	sb	zero,22(sp)
80004f98:	a025                	j	80004fc0 <.L60>

80004f9a <.L61>:
                    *(buff++) = (uint8_t)(temp >> (i * 8));
80004f9a:	01614783          	lbu	a5,22(sp)
80004f9e:	078e                	sll	a5,a5,0x3
80004fa0:	4742                	lw	a4,16(sp)
80004fa2:	00f756b3          	srl	a3,a4,a5
80004fa6:	4792                	lw	a5,4(sp)
80004fa8:	00178713          	add	a4,a5,1
80004fac:	c23a                	sw	a4,4(sp)
80004fae:	0ff6f713          	zext.b	a4,a3
80004fb2:	00e78023          	sb	a4,0(a5)
                for (uint8_t i = 0; i < data_len_in_bytes; i++) {
80004fb6:	01614783          	lbu	a5,22(sp)
80004fba:	0785                	add	a5,a5,1
80004fbc:	00f10b23          	sb	a5,22(sp)

80004fc0 <.L60>:
80004fc0:	01614703          	lbu	a4,22(sp)
80004fc4:	00b14783          	lbu	a5,11(sp)
80004fc8:	fcf769e3          	bltu	a4,a5,80004f9a <.L61>

80004fcc <.LBE3>:
                }
                /* transfer count increment */
                transferred++;
80004fcc:	47f2                	lw	a5,28(sp)
80004fce:	0785                	add	a5,a5,1
80004fd0:	ce3e                	sw	a5,28(sp)
                if (transferred >= count) {
80004fd2:	4772                	lw	a4,28(sp)
80004fd4:	4782                	lw	a5,0(sp)
80004fd6:	00f77e63          	bgeu	a4,a5,80004ff2 <.L69>
            for (j = 0; j < rx_valid_size; j++) {
80004fda:	01714783          	lbu	a5,23(sp)
80004fde:	0785                	add	a5,a5,1
80004fe0:	00f10ba3          	sb	a5,23(sp)

80004fe4 <.L59>:
80004fe4:	01714703          	lbu	a4,23(sp)
80004fe8:	01514783          	lbu	a5,21(sp)
80004fec:	faf761e3          	bltu	a4,a5,80004f8e <.L64>
80004ff0:	a011                	j	80004ff4 <.L63>

80004ff2 <.L69>:
                    break;
80004ff2:	0001                	nop

80004ff4 <.L63>:
                }
            }
            retry = 0;
80004ff4:	cc02                	sw	zero,24(sp)
80004ff6:	a811                	j	8000500a <.L57>

80004ff8 <.L58>:
        } else {
            if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
80004ff8:	4762                	lw	a4,24(sp)
80004ffa:	6785                	lui	a5,0x1
80004ffc:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80005000:	00e7ea63          	bltu	a5,a4,80005014 <.L70>
                break;
            }
            retry++;
80005004:	47e2                	lw	a5,24(sp)
80005006:	0785                	add	a5,a5,1
80005008:	cc3e                	sw	a5,24(sp)

8000500a <.L57>:
    while (transferred < count) {
8000500a:	4772                	lw	a4,28(sp)
8000500c:	4782                	lw	a5,0(sp)
8000500e:	f6f765e3          	bltu	a4,a5,80004f78 <.L67>
80005012:	a011                	j	80005016 <.L66>

80005014 <.L70>:
                break;
80005014:	0001                	nop

80005016 <.L66>:
        }
    }

    if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
80005016:	4762                	lw	a4,24(sp)
80005018:	6785                	lui	a5,0x1
8000501a:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000501e:	00e7f463          	bgeu	a5,a4,80005026 <.L68>
        /* dummy state may triggers timeout if dummy count, retry count, spi rate and cpu frequency are inappropriate */
        return status_timeout;
80005022:	478d                	li	a5,3
80005024:	a011                	j	80005028 <.L54>

80005026 <.L68>:
    }

    return status_success;
80005026:	4781                	li	a5,0

80005028 <.L54>:
}
80005028:	853e                	mv	a0,a5
8000502a:	50b2                	lw	ra,44(sp)
8000502c:	6145                	add	sp,sp,48
8000502e:	8082                	ret

Disassembly of section .text.spi_write_read_data:

80005030 <spi_write_read_data>:

hpm_stat_t spi_write_read_data(SPI_Type *ptr, uint8_t data_len_in_bytes, uint8_t *wbuff, uint32_t wcount, uint8_t *rbuff, uint32_t rcount)
{
80005030:	7139                	add	sp,sp,-64
80005032:	ce2a                	sw	a0,28(sp)
80005034:	ca32                	sw	a2,20(sp)
80005036:	c836                	sw	a3,16(sp)
80005038:	c63a                	sw	a4,12(sp)
8000503a:	c43e                	sw	a5,8(sp)
8000503c:	87ae                	mv	a5,a1
8000503e:	00f10da3          	sb	a5,27(sp)
    uint32_t status;
    uint32_t wtransferred = 0;
80005042:	de02                	sw	zero,60(sp)
    uint32_t rtransferred = 0;
80005044:	dc02                	sw	zero,56(sp)
    uint32_t retry = 0;
80005046:	da02                	sw	zero,52(sp)
    uint32_t temp;

    /* check parameter validity */
    if (wbuff == NULL || wcount == 0 || rbuff == NULL || rcount == 0) {
80005048:	47d2                	lw	a5,20(sp)
8000504a:	c799                	beqz	a5,80005058 <.L72>
8000504c:	47c2                	lw	a5,16(sp)
8000504e:	c789                	beqz	a5,80005058 <.L72>
80005050:	47b2                	lw	a5,12(sp)
80005052:	c399                	beqz	a5,80005058 <.L72>
80005054:	47a2                	lw	a5,8(sp)
80005056:	e399                	bnez	a5,8000505c <.L73>

80005058 <.L72>:
        return status_invalid_argument;
80005058:	4789                	li	a5,2
8000505a:	a20d                	j	8000517c <.L74>

8000505c <.L73>:
    }

    if (data_len_in_bytes > 4 || data_len_in_bytes < 1) {
8000505c:	01b14703          	lbu	a4,27(sp)
80005060:	4791                	li	a5,4
80005062:	00e7e563          	bltu	a5,a4,8000506c <.L75>
80005066:	01b14783          	lbu	a5,27(sp)
8000506a:	e7e5                	bnez	a5,80005152 <.L77>

8000506c <.L75>:
        return status_invalid_argument;
8000506c:	4789                	li	a5,2
8000506e:	a239                	j	8000517c <.L74>

80005070 <.L88>:
    }

    /* data transfer */
    while (wtransferred < wcount || rtransferred < rcount) {
        status = ptr->STATUS;
80005070:	47f2                	lw	a5,28(sp)
80005072:	5bdc                	lw	a5,52(a5)
80005074:	d43e                	sw	a5,40(sp)

        if (wtransferred < wcount) {
80005076:	5772                	lw	a4,60(sp)
80005078:	47c2                	lw	a5,16(sp)
8000507a:	06f77763          	bgeu	a4,a5,800050e8 <.L78>
            /* write data into the txfifo */
            if (!(status & SPI_STATUS_TXFULL_MASK)) {
8000507e:	5722                	lw	a4,40(sp)
80005080:	008007b7          	lui	a5,0x800
80005084:	8ff9                	and	a5,a5,a4
80005086:	eba1                	bnez	a5,800050d6 <.L79>
                temp = 0;
80005088:	d802                	sw	zero,48(sp)

8000508a <.LBB4>:
                for (uint8_t i = 0; i < data_len_in_bytes; i++) {
8000508a:	020107a3          	sb	zero,47(sp)
8000508e:	a035                	j	800050ba <.L80>

80005090 <.L81>:
                    temp += *(wbuff++) << i * 8;
80005090:	47d2                	lw	a5,20(sp)
80005092:	00178713          	add	a4,a5,1 # 800001 <__DLM_segment_end__+0x5c0001>
80005096:	ca3a                	sw	a4,20(sp)
80005098:	0007c783          	lbu	a5,0(a5)
8000509c:	873e                	mv	a4,a5
8000509e:	02f14783          	lbu	a5,47(sp)
800050a2:	078e                	sll	a5,a5,0x3
800050a4:	00f717b3          	sll	a5,a4,a5
800050a8:	873e                	mv	a4,a5
800050aa:	57c2                	lw	a5,48(sp)
800050ac:	97ba                	add	a5,a5,a4
800050ae:	d83e                	sw	a5,48(sp)
                for (uint8_t i = 0; i < data_len_in_bytes; i++) {
800050b0:	02f14783          	lbu	a5,47(sp)
800050b4:	0785                	add	a5,a5,1
800050b6:	02f107a3          	sb	a5,47(sp)

800050ba <.L80>:
800050ba:	02f14703          	lbu	a4,47(sp)
800050be:	01b14783          	lbu	a5,27(sp)
800050c2:	fcf767e3          	bltu	a4,a5,80005090 <.L81>

800050c6 <.LBE4>:
                }
                ptr->DATA = temp;
800050c6:	47f2                	lw	a5,28(sp)
800050c8:	5742                	lw	a4,48(sp)
800050ca:	d7d8                	sw	a4,44(a5)
                /* transfer count increment */
                wtransferred++;
800050cc:	57f2                	lw	a5,60(sp)
800050ce:	0785                	add	a5,a5,1
800050d0:	de3e                	sw	a5,60(sp)
                retry = 0;
800050d2:	da02                	sw	zero,52(sp)
800050d4:	a811                	j	800050e8 <.L78>

800050d6 <.L79>:
            } else {
                if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
800050d6:	5752                	lw	a4,52(sp)
800050d8:	6785                	lui	a5,0x1
800050da:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800050de:	08e7e363          	bltu	a5,a4,80005164 <.L90>
                    break;
                }
                retry++;
800050e2:	57d2                	lw	a5,52(sp)
800050e4:	0785                	add	a5,a5,1
800050e6:	da3e                	sw	a5,52(sp)

800050e8 <.L78>:
            }
        }

        if (rtransferred < rcount) {
800050e8:	5762                	lw	a4,56(sp)
800050ea:	47a2                	lw	a5,8(sp)
800050ec:	06f77363          	bgeu	a4,a5,80005152 <.L77>
            /* read data from the txfifo */
            if (!(status & SPI_STATUS_RXEMPTY_MASK)) {
800050f0:	5722                	lw	a4,40(sp)
800050f2:	6791                	lui	a5,0x4
800050f4:	8ff9                	and	a5,a5,a4
800050f6:	e7a9                	bnez	a5,80005140 <.L84>
                temp = ptr->DATA;
800050f8:	47f2                	lw	a5,28(sp)
800050fa:	57dc                	lw	a5,44(a5)
800050fc:	d83e                	sw	a5,48(sp)

800050fe <.LBB5>:
                for (uint8_t i = 0; i < data_len_in_bytes; i++) {
800050fe:	02010723          	sb	zero,46(sp)
80005102:	a025                	j	8000512a <.L85>

80005104 <.L86>:
                    *(rbuff++) = (uint8_t)(temp >> (i * 8));
80005104:	02e14783          	lbu	a5,46(sp)
80005108:	078e                	sll	a5,a5,0x3
8000510a:	5742                	lw	a4,48(sp)
8000510c:	00f756b3          	srl	a3,a4,a5
80005110:	47b2                	lw	a5,12(sp)
80005112:	00178713          	add	a4,a5,1 # 4001 <__HEAPSIZE__+0x1>
80005116:	c63a                	sw	a4,12(sp)
80005118:	0ff6f713          	zext.b	a4,a3
8000511c:	00e78023          	sb	a4,0(a5)
                for (uint8_t i = 0; i < data_len_in_bytes; i++) {
80005120:	02e14783          	lbu	a5,46(sp)
80005124:	0785                	add	a5,a5,1
80005126:	02f10723          	sb	a5,46(sp)

8000512a <.L85>:
8000512a:	02e14703          	lbu	a4,46(sp)
8000512e:	01b14783          	lbu	a5,27(sp)
80005132:	fcf769e3          	bltu	a4,a5,80005104 <.L86>

80005136 <.LBE5>:
                }
                /* transfer count increment */
                rtransferred++;
80005136:	57e2                	lw	a5,56(sp)
80005138:	0785                	add	a5,a5,1
8000513a:	dc3e                	sw	a5,56(sp)
                retry = 0;
8000513c:	da02                	sw	zero,52(sp)
8000513e:	a811                	j	80005152 <.L77>

80005140 <.L84>:
            } else {
                if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
80005140:	5752                	lw	a4,52(sp)
80005142:	6785                	lui	a5,0x1
80005144:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80005148:	02e7e063          	bltu	a5,a4,80005168 <.L91>
                    break;
                }
                retry++;
8000514c:	57d2                	lw	a5,52(sp)
8000514e:	0785                	add	a5,a5,1
80005150:	da3e                	sw	a5,52(sp)

80005152 <.L77>:
    while (wtransferred < wcount || rtransferred < rcount) {
80005152:	5772                	lw	a4,60(sp)
80005154:	47c2                	lw	a5,16(sp)
80005156:	f0f76de3          	bltu	a4,a5,80005070 <.L88>
8000515a:	5762                	lw	a4,56(sp)
8000515c:	47a2                	lw	a5,8(sp)
8000515e:	f0f769e3          	bltu	a4,a5,80005070 <.L88>
80005162:	a021                	j	8000516a <.L83>

80005164 <.L90>:
                    break;
80005164:	0001                	nop
80005166:	a011                	j	8000516a <.L83>

80005168 <.L91>:
                    break;
80005168:	0001                	nop

8000516a <.L83>:
            }
        }
    }

    if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
8000516a:	5752                	lw	a4,52(sp)
8000516c:	6785                	lui	a5,0x1
8000516e:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80005172:	00e7f463          	bgeu	a5,a4,8000517a <.L89>
        /* dummy state may triggers timeout if dummy count, retry count, spi rate and cpu frequency are inappropriate */
        return status_timeout;
80005176:	478d                	li	a5,3
80005178:	a011                	j	8000517c <.L74>

8000517a <.L89>:
    }

    return status_success;
8000517a:	4781                	li	a5,0

8000517c <.L74>:
}
8000517c:	853e                	mv	a0,a5
8000517e:	6121                	add	sp,sp,64
80005180:	8082                	ret

Disassembly of section .text.spi_no_data:

80005182 <spi_no_data>:

static hpm_stat_t spi_no_data(SPI_Type *ptr, spi_mode_selection_t mode, spi_control_config_t *config)
{
80005182:	1141                	add	sp,sp,-16
80005184:	c62a                	sw	a0,12(sp)
80005186:	87ae                	mv	a5,a1
80005188:	c232                	sw	a2,4(sp)
8000518a:	00f105a3          	sb	a5,11(sp)
    (void) ptr;
    if (mode == spi_master_mode) {
8000518e:	00b14783          	lbu	a5,11(sp)
80005192:	e39d                	bnez	a5,800051b8 <.L93>
        if (config->master_config.cmd_enable == false && config->master_config.addr_enable == false) {
80005194:	4792                	lw	a5,4(sp)
80005196:	0007c783          	lbu	a5,0(a5)
8000519a:	0017c793          	xor	a5,a5,1
8000519e:	0ff7f793          	zext.b	a5,a5
800051a2:	cb99                	beqz	a5,800051b8 <.L93>
800051a4:	4792                	lw	a5,4(sp)
800051a6:	0017c783          	lbu	a5,1(a5)
800051aa:	0017c793          	xor	a5,a5,1
800051ae:	0ff7f793          	zext.b	a5,a5
800051b2:	c399                	beqz	a5,800051b8 <.L93>
            return status_invalid_argument;
800051b4:	4789                	li	a5,2
800051b6:	a011                	j	800051ba <.L94>

800051b8 <.L93>:
        }
    }
    return status_success;
800051b8:	4781                	li	a5,0

800051ba <.L94>:
}
800051ba:	853e                	mv	a0,a5
800051bc:	0141                	add	sp,sp,16
800051be:	8082                	ret

Disassembly of section .text.spi_slave_get_default_format_config:

800051c0 <spi_slave_get_default_format_config>:
    config->common_config.cpol = 0;//spi_sclk_high_idle;
    config->common_config.cpha = 0;//spi_sclk_sampling_even_clk_edges;
}

void spi_slave_get_default_format_config(spi_format_config_t *config)
{
800051c0:	1141                	add	sp,sp,-16
800051c2:	c62a                	sw	a0,12(sp)
    config->common_config.data_len_in_bits = 32;
800051c4:	47b2                	lw	a5,12(sp)
800051c6:	02000713          	li	a4,32
800051ca:	00e780a3          	sb	a4,1(a5)
    config->common_config.data_merge = false;
800051ce:	47b2                	lw	a5,12(sp)
800051d0:	00078123          	sb	zero,2(a5)
    config->common_config.mosi_bidir = false;
800051d4:	47b2                	lw	a5,12(sp)
800051d6:	000781a3          	sb	zero,3(a5)
    config->common_config.lsb = false;
800051da:	47b2                	lw	a5,12(sp)
800051dc:	00078223          	sb	zero,4(a5)
    config->common_config.mode = spi_slave_mode;
800051e0:	47b2                	lw	a5,12(sp)
800051e2:	4705                	li	a4,1
800051e4:	00e782a3          	sb	a4,5(a5)
    config->common_config.cpol = 0;//spi_sclk_high_idle;
800051e8:	47b2                	lw	a5,12(sp)
800051ea:	00078323          	sb	zero,6(a5)
    config->common_config.cpha = 0;//spi_sclk_sampling_even_clk_edges;
800051ee:	47b2                	lw	a5,12(sp)
800051f0:	000783a3          	sb	zero,7(a5)
}
800051f4:	0001                	nop
800051f6:	0141                	add	sp,sp,16
800051f8:	8082                	ret

Disassembly of section .text.spi_control_init:

800051fa <spi_control_init>:
                    SPI_TRANSFMT_CPOL_SET(config->common_config.cpol) |
                    SPI_TRANSFMT_CPHA_SET(config->common_config.cpha);
}

hpm_stat_t spi_control_init(SPI_Type *ptr, spi_control_config_t *config, uint32_t wcount, uint32_t rcount)
{
800051fa:	1101                	add	sp,sp,-32
800051fc:	c62a                	sw	a0,12(sp)
800051fe:	c42e                	sw	a1,8(sp)
80005200:	c232                	sw	a2,4(sp)
80005202:	c036                	sw	a3,0(sp)
        return status_invalid_argument;
    }
#endif

    /* read spi control mode */
    mode = (ptr->TRANSFMT & SPI_TRANSFMT_SLVMODE_MASK) >> SPI_TRANSFMT_SLVMODE_SHIFT;
80005204:	47b2                	lw	a5,12(sp)
80005206:	4b9c                	lw	a5,16(a5)
80005208:	8389                	srl	a5,a5,0x2
8000520a:	0ff7f793          	zext.b	a5,a5
8000520e:	8b85                	and	a5,a5,1
80005210:	00f10fa3          	sb	a5,31(sp)

    /* slave data only mode only works on write read together transfer mode */
    if ((config->slave_config.slave_data_only == true) &&
80005214:	47a2                	lw	a5,8(sp)
80005216:	0057c783          	lbu	a5,5(a5)
8000521a:	cf81                	beqz	a5,80005232 <.L109>
        (config->common_config.trans_mode != spi_trans_write_read_together) &&
8000521c:	47a2                	lw	a5,8(sp)
8000521e:	0087c783          	lbu	a5,8(a5)
    if ((config->slave_config.slave_data_only == true) &&
80005222:	cb81                	beqz	a5,80005232 <.L109>
        (config->common_config.trans_mode != spi_trans_write_read_together) &&
80005224:	01f14703          	lbu	a4,31(sp)
80005228:	4785                	li	a5,1
8000522a:	00f71463          	bne	a4,a5,80005232 <.L109>
        (mode == spi_slave_mode)) {
        return status_invalid_argument;
8000522e:	4789                	li	a5,2
80005230:	a8ed                	j	8000532a <.L110>

80005232 <.L109>:
    }

    ptr->TRANSCTRL = SPI_TRANSCTRL_SLVDATAONLY_SET(config->slave_config.slave_data_only) |
80005232:	47a2                	lw	a5,8(sp)
80005234:	0057c783          	lbu	a5,5(a5)
80005238:	01f79713          	sll	a4,a5,0x1f
                     SPI_TRANSCTRL_CMDEN_SET(config->master_config.cmd_enable) |
8000523c:	47a2                	lw	a5,8(sp)
8000523e:	0007c783          	lbu	a5,0(a5)
80005242:	01e79693          	sll	a3,a5,0x1e
80005246:	400007b7          	lui	a5,0x40000
8000524a:	8ff5                	and	a5,a5,a3
    ptr->TRANSCTRL = SPI_TRANSCTRL_SLVDATAONLY_SET(config->slave_config.slave_data_only) |
8000524c:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_ADDREN_SET(config->master_config.addr_enable) |
8000524e:	47a2                	lw	a5,8(sp)
80005250:	0017c783          	lbu	a5,1(a5) # 40000001 <_extram_size+0x3e000001>
80005254:	01d79693          	sll	a3,a5,0x1d
80005258:	200007b7          	lui	a5,0x20000
8000525c:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_CMDEN_SET(config->master_config.cmd_enable) |
8000525e:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_ADDRFMT_SET(config->master_config.addr_phase_fmt) |
80005260:	47a2                	lw	a5,8(sp)
80005262:	0027c783          	lbu	a5,2(a5) # 20000002 <_extram_size+0x1e000002>
80005266:	01c79693          	sll	a3,a5,0x1c
8000526a:	100007b7          	lui	a5,0x10000
8000526e:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_ADDREN_SET(config->master_config.addr_enable) |
80005270:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_TRANSMODE_SET(config->common_config.trans_mode) |
80005272:	47a2                	lw	a5,8(sp)
80005274:	0087c783          	lbu	a5,8(a5) # 10000008 <_extram_size+0xe000008>
80005278:	01879693          	sll	a3,a5,0x18
8000527c:	0f0007b7          	lui	a5,0xf000
80005280:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_ADDRFMT_SET(config->master_config.addr_phase_fmt) |
80005282:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_DUALQUAD_SET(config->common_config.data_phase_fmt) |
80005284:	47a2                	lw	a5,8(sp)
80005286:	0097c783          	lbu	a5,9(a5) # f000009 <_extram_size+0xd000009>
8000528a:	01679693          	sll	a3,a5,0x16
8000528e:	00c007b7          	lui	a5,0xc00
80005292:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_TRANSMODE_SET(config->common_config.trans_mode) |
80005294:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_TOKENEN_SET(config->master_config.token_enable) |
80005296:	47a2                	lw	a5,8(sp)
80005298:	0037c783          	lbu	a5,3(a5) # c00003 <__DLM_segment_end__+0x9c0003>
8000529c:	01579693          	sll	a3,a5,0x15
800052a0:	002007b7          	lui	a5,0x200
800052a4:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_DUALQUAD_SET(config->common_config.data_phase_fmt) |
800052a6:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_WRTRANCNT_SET(wcount - 1) |
800052a8:	4792                	lw	a5,4(sp)
800052aa:	17fd                	add	a5,a5,-1 # 1fffff <__AXI_SRAM_segment_size__+0x17ffff>
800052ac:	00c79693          	sll	a3,a5,0xc
800052b0:	001ff7b7          	lui	a5,0x1ff
800052b4:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_TOKENEN_SET(config->master_config.token_enable) |
800052b6:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_TOKENVALUE_SET(config->master_config.token_value) |
800052b8:	47a2                	lw	a5,8(sp)
800052ba:	0047c783          	lbu	a5,4(a5) # 1ff004 <__AXI_SRAM_segment_size__+0x17f004>
800052be:	00b79693          	sll	a3,a5,0xb
800052c2:	28b01793          	bset	a5,zero,0xb
800052c6:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_WRTRANCNT_SET(wcount - 1) |
800052c8:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_DUMMYCNT_SET(config->common_config.dummy_cnt) |
800052ca:	47a2                	lw	a5,8(sp)
800052cc:	00a7c783          	lbu	a5,10(a5)
800052d0:	07a6                	sll	a5,a5,0x9
800052d2:	6007f793          	and	a5,a5,1536
                     SPI_TRANSCTRL_TOKENVALUE_SET(config->master_config.token_value) |
800052d6:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_RDTRANCNT_SET(rcount - 1);
800052d8:	4782                	lw	a5,0(sp)
800052da:	17fd                	add	a5,a5,-1
800052dc:	1ff7f793          	and	a5,a5,511
                     SPI_TRANSCTRL_DUMMYCNT_SET(config->common_config.dummy_cnt) |
800052e0:	8f5d                	or	a4,a4,a5
    ptr->TRANSCTRL = SPI_TRANSCTRL_SLVDATAONLY_SET(config->slave_config.slave_data_only) |
800052e2:	47b2                	lw	a5,12(sp)
800052e4:	d398                	sw	a4,32(a5)

#if defined(HPM_IP_FEATURE_SPI_CS_SELECT) && (HPM_IP_FEATURE_SPI_CS_SELECT == 1)
    ptr->CTRL = (ptr->CTRL & ~SPI_CTRL_CS_EN_MASK) | SPI_CTRL_CS_EN_SET(config->common_config.cs_index);
800052e6:	47b2                	lw	a5,12(sp)
800052e8:	5b98                	lw	a4,48(a5)
800052ea:	f10007b7          	lui	a5,0xf1000
800052ee:	17fd                	add	a5,a5,-1 # f0ffffff <__AHB_SRAM_segment_end__+0xdf7fff>
800052f0:	8f7d                	and	a4,a4,a5
800052f2:	47a2                	lw	a5,8(sp)
800052f4:	00b7c783          	lbu	a5,11(a5)
800052f8:	01879693          	sll	a3,a5,0x18
800052fc:	0f0007b7          	lui	a5,0xf000
80005300:	8ff5                	and	a5,a5,a3
80005302:	8f5d                	or	a4,a4,a5
80005304:	47b2                	lw	a5,12(sp)
80005306:	db98                	sw	a4,48(a5)
#endif

#if defined(HPM_IP_FEATURE_SPI_NEW_TRANS_COUNT) && (HPM_IP_FEATURE_SPI_NEW_TRANS_COUNT == 1)
    ptr->WR_TRANS_CNT = wcount - 1;
80005308:	4792                	lw	a5,4(sp)
8000530a:	fff78713          	add	a4,a5,-1 # effffff <_extram_size+0xcffffff>
8000530e:	47b2                	lw	a5,12(sp)
80005310:	c3d8                	sw	a4,4(a5)
    ptr->RD_TRANS_CNT = rcount - 1;
80005312:	4782                	lw	a5,0(sp)
80005314:	fff78713          	add	a4,a5,-1
80005318:	47b2                	lw	a5,12(sp)
8000531a:	c798                	sw	a4,8(a5)
#endif

    /* reset txfifo, rxfifo and control */
    ptr->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
8000531c:	47b2                	lw	a5,12(sp)
8000531e:	5b9c                	lw	a5,48(a5)
80005320:	0077e713          	or	a4,a5,7
80005324:	47b2                	lw	a5,12(sp)
80005326:	db98                	sw	a4,48(a5)

    return status_success;
80005328:	4781                	li	a5,0

8000532a <.L110>:
}
8000532a:	853e                	mv	a0,a5
8000532c:	6105                	add	sp,sp,32
8000532e:	8082                	ret

Disassembly of section .text.uart_init:

80005330 <uart_init>:
    }
    return false;
}

hpm_stat_t uart_init(UART_Type *ptr, uart_config_t *config)
{
80005330:	7179                	add	sp,sp,-48
80005332:	d606                	sw	ra,44(sp)
80005334:	c62a                	sw	a0,12(sp)
80005336:	c42e                	sw	a1,8(sp)
    uint32_t tmp;
    uint8_t osc;
    uint16_t div;

    /* disable all interrupts */
    ptr->IER = 0;
80005338:	47b2                	lw	a5,12(sp)
8000533a:	0207a223          	sw	zero,36(a5)
    /* Set DLAB to 1 */
    ptr->LCR |= UART_LCR_DLAB_MASK;
8000533e:	47b2                	lw	a5,12(sp)
80005340:	57dc                	lw	a5,44(a5)
80005342:	0807e713          	or	a4,a5,128
80005346:	47b2                	lw	a5,12(sp)
80005348:	d7d8                	sw	a4,44(a5)

    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
8000534a:	47a2                	lw	a5,8(sp)
8000534c:	4398                	lw	a4,0(a5)
8000534e:	47a2                	lw	a5,8(sp)
80005350:	43dc                	lw	a5,4(a5)
80005352:	01b10693          	add	a3,sp,27
80005356:	0830                	add	a2,sp,24
80005358:	85be                	mv	a1,a5
8000535a:	853a                	mv	a0,a4
8000535c:	59a020ef          	jal	800078f6 <uart_calculate_baudrate>
80005360:	87aa                	mv	a5,a0
80005362:	0017c793          	xor	a5,a5,1
80005366:	0ff7f793          	zext.b	a5,a5
8000536a:	c781                	beqz	a5,80005372 <.L26>
        return status_uart_no_suitable_baudrate_parameter_found;
8000536c:	3e900793          	li	a5,1001
80005370:	a251                	j	800054f4 <.L43>

80005372 <.L26>:
    }

    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80005372:	47b2                	lw	a5,12(sp)
80005374:	4bdc                	lw	a5,20(a5)
80005376:	fe07f713          	and	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
8000537a:	01b14783          	lbu	a5,27(sp)
8000537e:	8bfd                	and	a5,a5,31
80005380:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80005382:	47b2                	lw	a5,12(sp)
80005384:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
80005386:	01815783          	lhu	a5,24(sp)
8000538a:	0ff7f713          	zext.b	a4,a5
8000538e:	47b2                	lw	a5,12(sp)
80005390:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
80005392:	01815783          	lhu	a5,24(sp)
80005396:	83a1                	srl	a5,a5,0x8
80005398:	0807c7b3          	zext.h	a5,a5
8000539c:	0ff7f713          	zext.b	a4,a5
800053a0:	47b2                	lw	a5,12(sp)
800053a2:	d3d8                	sw	a4,36(a5)

    /* DLAB bit needs to be cleared once baudrate is configured */
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
800053a4:	47b2                	lw	a5,12(sp)
800053a6:	57dc                	lw	a5,44(a5)
800053a8:	f7f7f793          	and	a5,a5,-129
800053ac:	ce3e                	sw	a5,28(sp)

    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
800053ae:	47f2                	lw	a5,28(sp)
800053b0:	fc77f793          	and	a5,a5,-57
800053b4:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
800053b6:	47a2                	lw	a5,8(sp)
800053b8:	00a7c783          	lbu	a5,10(a5)
800053bc:	4711                	li	a4,4
800053be:	02f76d63          	bltu	a4,a5,800053f8 <.L28>
800053c2:	00279713          	sll	a4,a5,0x2
800053c6:	8f818793          	add	a5,gp,-1800 # 80003188 <.L30>
800053ca:	97ba                	add	a5,a5,a4
800053cc:	439c                	lw	a5,0(a5)
800053ce:	8782                	jr	a5

800053d0 <.L33>:
    case parity_none:
        break;
    case parity_odd:
        tmp |= UART_LCR_PEN_MASK;
800053d0:	47f2                	lw	a5,28(sp)
800053d2:	0087e793          	or	a5,a5,8
800053d6:	ce3e                	sw	a5,28(sp)
        break;
800053d8:	a01d                	j	800053fe <.L35>

800053da <.L32>:
    case parity_even:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
800053da:	47f2                	lw	a5,28(sp)
800053dc:	0187e793          	or	a5,a5,24
800053e0:	ce3e                	sw	a5,28(sp)
        break;
800053e2:	a831                	j	800053fe <.L35>

800053e4 <.L31>:
    case parity_always_1:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
800053e4:	47f2                	lw	a5,28(sp)
800053e6:	0287e793          	or	a5,a5,40
800053ea:	ce3e                	sw	a5,28(sp)
        break;
800053ec:	a809                	j	800053fe <.L35>

800053ee <.L29>:
    case parity_always_0:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
800053ee:	47f2                	lw	a5,28(sp)
800053f0:	0387e793          	or	a5,a5,56
800053f4:	ce3e                	sw	a5,28(sp)
            | UART_LCR_SPS_MASK;
        break;
800053f6:	a021                	j	800053fe <.L35>

800053f8 <.L28>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
800053f8:	4789                	li	a5,2
800053fa:	a8ed                	j	800054f4 <.L43>

800053fc <.L44>:
        break;
800053fc:	0001                	nop

800053fe <.L35>:
    }

    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
800053fe:	47f2                	lw	a5,28(sp)
80005400:	9be1                	and	a5,a5,-8
80005402:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
80005404:	47a2                	lw	a5,8(sp)
80005406:	0087c783          	lbu	a5,8(a5)
8000540a:	4709                	li	a4,2
8000540c:	00e78e63          	beq	a5,a4,80005428 <.L36>
80005410:	4709                	li	a4,2
80005412:	02f74663          	blt	a4,a5,8000543e <.L37>
80005416:	c795                	beqz	a5,80005442 <.L45>
80005418:	4705                	li	a4,1
8000541a:	02e79263          	bne	a5,a4,8000543e <.L37>
    case stop_bits_1:
        break;
    case stop_bits_1_5:
        tmp |= UART_LCR_STB_MASK;
8000541e:	47f2                	lw	a5,28(sp)
80005420:	0047e793          	or	a5,a5,4
80005424:	ce3e                	sw	a5,28(sp)
        break;
80005426:	a839                	j	80005444 <.L40>

80005428 <.L36>:
    case stop_bits_2:
        if (config->word_length < word_length_6_bits) {
80005428:	47a2                	lw	a5,8(sp)
8000542a:	0097c783          	lbu	a5,9(a5)
8000542e:	e399                	bnez	a5,80005434 <.L41>
            /* invalid configuration */
            return status_invalid_argument;
80005430:	4789                	li	a5,2
80005432:	a0c9                	j	800054f4 <.L43>

80005434 <.L41>:
        }
        tmp |= UART_LCR_STB_MASK;
80005434:	47f2                	lw	a5,28(sp)
80005436:	0047e793          	or	a5,a5,4
8000543a:	ce3e                	sw	a5,28(sp)
        break;
8000543c:	a021                	j	80005444 <.L40>

8000543e <.L37>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
8000543e:	4789                	li	a5,2
80005440:	a855                	j	800054f4 <.L43>

80005442 <.L45>:
        break;
80005442:	0001                	nop

80005444 <.L40>:
    }

    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
80005444:	47a2                	lw	a5,8(sp)
80005446:	0097c783          	lbu	a5,9(a5)
8000544a:	0037f713          	and	a4,a5,3
8000544e:	47f2                	lw	a5,28(sp)
80005450:	8f5d                	or	a4,a4,a5
80005452:	47b2                	lw	a5,12(sp)
80005454:	d7d8                	sw	a4,44(a5)

#if defined(HPM_IP_FEATURE_UART_FINE_FIFO_THRLD) && (HPM_IP_FEATURE_UART_FINE_FIFO_THRLD == 1)
    /* reset TX and RX fifo */
    ptr->FCRR = UART_FCRR_TFIFORST_MASK | UART_FCRR_RFIFORST_MASK;
80005456:	47b2                	lw	a5,12(sp)
80005458:	4719                	li	a4,6
8000545a:	cf98                	sw	a4,24(a5)
    /* Enable FIFO */
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
        | UART_FCRR_FIFOE_SET(config->fifo_enable)
8000545c:	47a2                	lw	a5,8(sp)
8000545e:	00e7c783          	lbu	a5,14(a5)
80005462:	86be                	mv	a3,a5
        | UART_FCRR_TFIFOT4_SET(config->tx_fifo_level)
80005464:	47a2                	lw	a5,8(sp)
80005466:	00b7c783          	lbu	a5,11(a5)
8000546a:	01079713          	sll	a4,a5,0x10
8000546e:	001f07b7          	lui	a5,0x1f0
80005472:	8ff9                	and	a5,a5,a4
80005474:	00f6e733          	or	a4,a3,a5
        | UART_FCRR_RFIFOT4_SET(config->rx_fifo_level)
80005478:	47a2                	lw	a5,8(sp)
8000547a:	00c7c783          	lbu	a5,12(a5) # 1f000c <__AXI_SRAM_segment_size__+0x17000c>
8000547e:	00879693          	sll	a3,a5,0x8
80005482:	6789                	lui	a5,0x2
80005484:	f0078793          	add	a5,a5,-256 # 1f00 <__NOR_CFG_OPTION_segment_size__+0x1300>
80005488:	8ff5                	and	a5,a5,a3
8000548a:	8f5d                	or	a4,a4,a5
#if defined(HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT) && (HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT == 1)
        | UART_FCRR_TMOUT_RXDMA_DIS_MASK /**< disable RX timeout trigger dma */
#endif
        | UART_FCRR_DMAE_SET(config->dma_enable);
8000548c:	47a2                	lw	a5,8(sp)
8000548e:	00d7c783          	lbu	a5,13(a5)
80005492:	078e                	sll	a5,a5,0x3
80005494:	8ba1                	and	a5,a5,8
80005496:	8f5d                	or	a4,a4,a5
80005498:	008007b7          	lui	a5,0x800
8000549c:	8f5d                	or	a4,a4,a5
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
8000549e:	47b2                	lw	a5,12(sp)
800054a0:	cf98                	sw	a4,24(a5)
    ptr->FCR = tmp;
    /* store FCR register value */
    ptr->GPR = tmp;
#endif

    uart_modem_config(ptr, &config->modem_config);
800054a2:	47a2                	lw	a5,8(sp)
800054a4:	07bd                	add	a5,a5,15 # 80000f <__DLM_segment_end__+0x5c000f>
800054a6:	85be                	mv	a1,a5
800054a8:	4532                	lw	a0,12(sp)
800054aa:	348020ef          	jal	800077f2 <uart_modem_config>

#if defined(HPM_IP_FEATURE_UART_RX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_RX_IDLE_DETECT == 1)
    uart_init_rxline_idle_detection(ptr, config->rxidle_config);
800054ae:	47a2                	lw	a5,8(sp)
800054b0:	0127d703          	lhu	a4,18(a5)
800054b4:	0147d783          	lhu	a5,20(a5)
800054b8:	07c2                	sll	a5,a5,0x10
800054ba:	8fd9                	or	a5,a5,a4
800054bc:	873e                	mv	a4,a5
800054be:	85ba                	mv	a1,a4
800054c0:	4532                	lw	a0,12(sp)
800054c2:	740020ef          	jal	80007c02 <uart_init_rxline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
    uart_init_txline_idle_detection(ptr, config->txidle_config);
800054c6:	47a2                	lw	a5,8(sp)
800054c8:	0167d703          	lhu	a4,22(a5)
800054cc:	0187d783          	lhu	a5,24(a5)
800054d0:	07c2                	sll	a5,a5,0x10
800054d2:	8fd9                	or	a5,a5,a4
800054d4:	873e                	mv	a4,a5
800054d6:	85ba                	mv	a1,a4
800054d8:	4532                	lw	a0,12(sp)
800054da:	2885                	jal	8000554a <uart_init_txline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    if (config->rx_enable) {
800054dc:	47a2                	lw	a5,8(sp)
800054de:	01a7c783          	lbu	a5,26(a5)
800054e2:	cb81                	beqz	a5,800054f2 <.L42>
        ptr->IDLE_CFG |= UART_IDLE_CFG_RXEN_MASK;
800054e4:	47b2                	lw	a5,12(sp)
800054e6:	43d8                	lw	a4,4(a5)
800054e8:	28b01793          	bset	a5,zero,0xb
800054ec:	8f5d                	or	a4,a4,a5
800054ee:	47b2                	lw	a5,12(sp)
800054f0:	c3d8                	sw	a4,4(a5)

800054f2 <.L42>:
    }
#endif
    return status_success;
800054f2:	4781                	li	a5,0

800054f4 <.L43>:
}
800054f4:	853e                	mv	a0,a5
800054f6:	50b2                	lw	ra,44(sp)
800054f8:	6145                	add	sp,sp,48
800054fa:	8082                	ret

Disassembly of section .text.uart_send_byte:

800054fc <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
800054fc:	1101                	add	sp,sp,-32
800054fe:	c62a                	sw	a0,12(sp)
80005500:	87ae                	mv	a5,a1
80005502:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
80005506:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
80005508:	a811                	j	8000551c <.L51>

8000550a <.L54>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000550a:	4772                	lw	a4,28(sp)
8000550c:	6785                	lui	a5,0x1
8000550e:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80005512:	00e7eb63          	bltu	a5,a4,80005528 <.L57>
            break;
        }
        retry++;
80005516:	47f2                	lw	a5,28(sp)
80005518:	0785                	add	a5,a5,1
8000551a:	ce3e                	sw	a5,28(sp)

8000551c <.L51>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
8000551c:	47b2                	lw	a5,12(sp)
8000551e:	5bdc                	lw	a5,52(a5)
80005520:	0207f793          	and	a5,a5,32
80005524:	d3fd                	beqz	a5,8000550a <.L54>
80005526:	a011                	j	8000552a <.L53>

80005528 <.L57>:
            break;
80005528:	0001                	nop

8000552a <.L53>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000552a:	4772                	lw	a4,28(sp)
8000552c:	6785                	lui	a5,0x1
8000552e:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80005532:	00e7f463          	bgeu	a5,a4,8000553a <.L55>
        return status_timeout;
80005536:	478d                	li	a5,3
80005538:	a031                	j	80005544 <.L56>

8000553a <.L55>:
    }

    ptr->THR = UART_THR_THR_SET(c);
8000553a:	00b14703          	lbu	a4,11(sp)
8000553e:	47b2                	lw	a5,12(sp)
80005540:	d398                	sw	a4,32(a5)
    return status_success;
80005542:	4781                	li	a5,0

80005544 <.L56>:
}
80005544:	853e                	mv	a0,a5
80005546:	6105                	add	sp,sp,32
80005548:	8082                	ret

Disassembly of section .text.uart_init_txline_idle_detection:

8000554a <uart_init_txline_idle_detection>:
}
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
hpm_stat_t uart_init_txline_idle_detection(UART_Type *ptr, uart_rxline_idle_config_t txidle_config)
{
8000554a:	1101                	add	sp,sp,-32
8000554c:	ce06                	sw	ra,28(sp)
8000554e:	c62a                	sw	a0,12(sp)
80005550:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_TX_IDLE_EN_MASK
80005552:	47b2                	lw	a5,12(sp)
80005554:	43d8                	lw	a4,4(a5)
80005556:	fc0107b7          	lui	a5,0xfc010
8000555a:	17fd                	add	a5,a5,-1 # fc00ffff <__AHB_SRAM_segment_end__+0xbe07fff>
8000555c:	8f7d                	and	a4,a4,a5
8000555e:	47b2                	lw	a5,12(sp)
80005560:	c3d8                	sw	a4,4(a5)
                    | UART_IDLE_CFG_TX_IDLE_THR_MASK
                    | UART_IDLE_CFG_TX_IDLE_COND_MASK);
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
80005562:	47b2                	lw	a5,12(sp)
80005564:	43d8                	lw	a4,4(a5)
80005566:	00814783          	lbu	a5,8(sp)
8000556a:	01879693          	sll	a3,a5,0x18
8000556e:	010007b7          	lui	a5,0x1000
80005572:	8efd                	and	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_THR_SET(txidle_config.threshold)
80005574:	00b14783          	lbu	a5,11(sp)
80005578:	01079613          	sll	a2,a5,0x10
8000557c:	00ff07b7          	lui	a5,0xff0
80005580:	8ff1                	and	a5,a5,a2
80005582:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_COND_SET(txidle_config.idle_cond);
80005584:	00a14783          	lbu	a5,10(sp)
80005588:	01979613          	sll	a2,a5,0x19
8000558c:	020007b7          	lui	a5,0x2000
80005590:	8ff1                	and	a5,a5,a2
80005592:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
80005594:	8f5d                	or	a4,a4,a5
80005596:	47b2                	lw	a5,12(sp)
80005598:	c3d8                	sw	a4,4(a5)

    if (txidle_config.detect_irq_enable) {
8000559a:	00914783          	lbu	a5,9(sp)
8000559e:	c799                	beqz	a5,800055ac <.L96>
        uart_enable_irq(ptr, uart_intr_tx_line_idle);
800055a0:	400005b7          	lui	a1,0x40000
800055a4:	4532                	lw	a0,12(sp)
800055a6:	2a4020ef          	jal	8000784a <uart_enable_irq>
800055aa:	a031                	j	800055b6 <.L97>

800055ac <.L96>:
    } else {
        uart_disable_irq(ptr, uart_intr_tx_line_idle);
800055ac:	400005b7          	lui	a1,0x40000
800055b0:	4532                	lw	a0,12(sp)
800055b2:	27c020ef          	jal	8000782e <uart_disable_irq>

800055b6 <.L97>:
    }

    return status_success;
800055b6:	4781                	li	a5,0
}
800055b8:	853e                	mv	a0,a5
800055ba:	40f2                	lw	ra,28(sp)
800055bc:	6105                	add	sp,sp,32
800055be:	8082                	ret

Disassembly of section .text.gpio_write_pin:

800055c0 <gpio_write_pin>:
 * @param port Port index
 * @param pin Pin index
 * @param high Pin level set to high when it is set to true
 */
static inline void gpio_write_pin(GPIO_Type *ptr, uint32_t port, uint8_t pin, uint8_t high)
{
800055c0:	1141                	add	sp,sp,-16
800055c2:	c62a                	sw	a0,12(sp)
800055c4:	c42e                	sw	a1,8(sp)
800055c6:	87b2                	mv	a5,a2
800055c8:	8736                	mv	a4,a3
800055ca:	00f103a3          	sb	a5,7(sp)
800055ce:	87ba                	mv	a5,a4
800055d0:	00f10323          	sb	a5,6(sp)
    if (high) {
800055d4:	00614783          	lbu	a5,6(sp)
800055d8:	cf91                	beqz	a5,800055f4 <.L2>
        ptr->DO[port].SET = 1 << pin;
800055da:	00714783          	lbu	a5,7(sp)
800055de:	4705                	li	a4,1
800055e0:	00f717b3          	sll	a5,a4,a5
800055e4:	86be                	mv	a3,a5
800055e6:	4732                	lw	a4,12(sp)
800055e8:	47a2                	lw	a5,8(sp)
800055ea:	07c1                	add	a5,a5,16 # 2000010 <_extram_size+0x10>
800055ec:	0792                	sll	a5,a5,0x4
800055ee:	97ba                	add	a5,a5,a4
800055f0:	c3d4                	sw	a3,4(a5)
    } else {
        ptr->DO[port].CLEAR = 1 << pin;
    }
}
800055f2:	a829                	j	8000560c <.L4>

800055f4 <.L2>:
        ptr->DO[port].CLEAR = 1 << pin;
800055f4:	00714783          	lbu	a5,7(sp)
800055f8:	4705                	li	a4,1
800055fa:	00f717b3          	sll	a5,a4,a5
800055fe:	86be                	mv	a3,a5
80005600:	4732                	lw	a4,12(sp)
80005602:	47a2                	lw	a5,8(sp)
80005604:	07c1                	add	a5,a5,16
80005606:	0792                	sll	a5,a5,0x4
80005608:	97ba                	add	a5,a5,a4
8000560a:	c794                	sw	a3,8(a5)

8000560c <.L4>:
}
8000560c:	0001                	nop
8000560e:	0141                	add	sp,sp,16
80005610:	8082                	ret

Disassembly of section .text.gpiom_set_pin_controller:

80005612 <gpiom_set_pin_controller>:
 */
static inline void gpiom_set_pin_controller(GPIOM_Type *ptr,
                              uint8_t gpio_index,
                              uint8_t pin_index,
                              gpiom_gpio_t gpio)
{
80005612:	1141                	add	sp,sp,-16
80005614:	c62a                	sw	a0,12(sp)
80005616:	87ae                	mv	a5,a1
80005618:	8736                	mv	a4,a3
8000561a:	00f105a3          	sb	a5,11(sp)
8000561e:	87b2                	mv	a5,a2
80005620:	00f10523          	sb	a5,10(sp)
80005624:	87ba                	mv	a5,a4
80005626:	00f104a3          	sb	a5,9(sp)
    ptr->ASSIGN[gpio_index].PIN[pin_index] =
        (ptr->ASSIGN[gpio_index].PIN[pin_index] & ~(GPIOM_ASSIGN_PIN_SELECT_MASK))
8000562a:	00b14683          	lbu	a3,11(sp)
8000562e:	00a14783          	lbu	a5,10(sp)
80005632:	4732                	lw	a4,12(sp)
80005634:	0696                	sll	a3,a3,0x5
80005636:	97b6                	add	a5,a5,a3
80005638:	078a                	sll	a5,a5,0x2
8000563a:	97ba                	add	a5,a5,a4
8000563c:	439c                	lw	a5,0(a5)
8000563e:	ffe7f693          	and	a3,a5,-2
80005642:	9af5                	and	a3,a3,-3
      | GPIOM_ASSIGN_PIN_SELECT_SET(gpio);
80005644:	00914783          	lbu	a5,9(sp)
80005648:	0037f713          	and	a4,a5,3
    ptr->ASSIGN[gpio_index].PIN[pin_index] =
8000564c:	00b14603          	lbu	a2,11(sp)
80005650:	00a14783          	lbu	a5,10(sp)
      | GPIOM_ASSIGN_PIN_SELECT_SET(gpio);
80005654:	8f55                	or	a4,a4,a3
    ptr->ASSIGN[gpio_index].PIN[pin_index] =
80005656:	46b2                	lw	a3,12(sp)
80005658:	0616                	sll	a2,a2,0x5
8000565a:	97b2                	add	a5,a5,a2
8000565c:	078a                	sll	a5,a5,0x2
8000565e:	97b6                	add	a5,a5,a3
80005660:	c398                	sw	a4,0(a5)
}
80005662:	0001                	nop
80005664:	0141                	add	sp,sp,16
80005666:	8082                	ret

Disassembly of section .text.spi_transfer_mode_print:

80005668 <spi_transfer_mode_print>:
    spi_op_read,
    spi_op_no_data
} spi_op_t;

void spi_transfer_mode_print(spi_control_config_t *config)
{
80005668:	de010113          	add	sp,sp,-544
8000566c:	20112e23          	sw	ra,540(sp)
80005670:	c62a                	sw	a0,12(sp)
    uint8_t trans_mode = config->common_config.trans_mode;
80005672:	47b2                	lw	a5,12(sp)
80005674:	0087c783          	lbu	a5,8(a5)
80005678:	20f107a3          	sb	a5,527(sp)

    char trans_mode_table[][50] = { "write-read-together",
8000567c:	92818713          	add	a4,gp,-1752 # 800031b8 <.LC0>
80005680:	083c                	add	a5,sp,24
80005682:	86ba                	mv	a3,a4
80005684:	1f400713          	li	a4,500
80005688:	863a                	mv	a2,a4
8000568a:	85b6                	mv	a1,a3
8000568c:	853e                	mv	a0,a5
8000568e:	642010ef          	jal	80006cd0 <memcpy>
                                    "no-data",
                                    "dummy-write",
                                    "dummy-read"
                                };

   printf("SPI-Slave transfer mode:%s\n", trans_mode_table[trans_mode]);
80005692:	20f14703          	lbu	a4,527(sp)
80005696:	0834                	add	a3,sp,24
80005698:	87ba                	mv	a5,a4
8000569a:	078a                	sll	a5,a5,0x2
8000569c:	97ba                	add	a5,a5,a4
8000569e:	00279713          	sll	a4,a5,0x2
800056a2:	97ba                	add	a5,a5,a4
800056a4:	0786                	sll	a5,a5,0x1
800056a6:	97b6                	add	a5,a5,a3
800056a8:	85be                	mv	a1,a5
800056aa:	90c18513          	add	a0,gp,-1780 # 8000319c <.LC1>
800056ae:	77e010ef          	jal	80006e2c <printf>
}
800056b2:	0001                	nop
800056b4:	21c12083          	lw	ra,540(sp)
800056b8:	22010113          	add	sp,sp,544
800056bc:	8082                	ret

Disassembly of section .text.spi_slave_address_dump:

800056be <spi_slave_address_dump>:
        printf("SPI-Slave read command:0x%02x\n", *cmd);
    }
}

void spi_slave_address_dump(spi_control_config_t *config)
{
800056be:	1101                	add	sp,sp,-32
800056c0:	ce06                	sw	ra,28(sp)
800056c2:	c62a                	sw	a0,12(sp)
    if (config->slave_config.slave_data_only == false) {
800056c4:	47b2                	lw	a5,12(sp)
800056c6:	0057c783          	lbu	a5,5(a5)
800056ca:	0017c793          	xor	a5,a5,1
800056ce:	0ff7f793          	zext.b	a5,a5
800056d2:	c789                	beqz	a5,800056dc <.L13>
        printf("SPI-Slave read address:dummy\n");
800056d4:	b3c18513          	add	a0,gp,-1220 # 800033cc <.LC3>
800056d8:	754010ef          	jal	80006e2c <printf>

800056dc <.L13>:
    }
}
800056dc:	0001                	nop
800056de:	40f2                	lw	ra,28(sp)
800056e0:	6105                	add	sp,sp,32
800056e2:	8082                	ret

Disassembly of section .text.spi_slave_data_dump:

800056e4 <spi_slave_data_dump>:

void spi_slave_data_dump(spi_op_t op, uint32_t datalen,  uint8_t *buff,  uint32_t size)
{
800056e4:	7179                	add	sp,sp,-48
800056e6:	d606                	sw	ra,44(sp)
800056e8:	87aa                	mv	a5,a0
800056ea:	c42e                	sw	a1,8(sp)
800056ec:	c232                	sw	a2,4(sp)
800056ee:	c036                	sw	a3,0(sp)
800056f0:	00f107a3          	sb	a5,15(sp)
    uint32_t i;

    if (op == spi_op_no_data) {
800056f4:	00f14703          	lbu	a4,15(sp)
800056f8:	4789                	li	a5,2
800056fa:	00f71763          	bne	a4,a5,80005708 <.L15>
        printf("SPI-Slave no data transfer.\n");
800056fe:	b5c18513          	add	a0,gp,-1188 # 800033ec <.LC4>
80005702:	72a010ef          	jal	80006e2c <printf>
        return;
80005706:	a859                	j	8000579c <.L14>

80005708 <.L15>:
    }

    if (buff == NULL || size == 0) {
80005708:	4792                	lw	a5,4(sp)
8000570a:	cbc1                	beqz	a5,8000579a <.L26>
8000570c:	4782                	lw	a5,0(sp)
8000570e:	c7d1                	beqz	a5,8000579a <.L26>
        return;
    }

    printf("SPI-Slave %s", op == spi_op_write ? "write data: " : "read  data: ");
80005710:	00f14783          	lbu	a5,15(sp)
80005714:	e781                	bnez	a5,8000571c <.L19>
80005716:	b7c18793          	add	a5,gp,-1156 # 8000340c <.LC5>
8000571a:	a019                	j	80005720 <.L20>

8000571c <.L19>:
8000571c:	b8c18793          	add	a5,gp,-1140 # 8000341c <.LC6>

80005720 <.L20>:
80005720:	85be                	mv	a1,a5
80005722:	b9c18513          	add	a0,gp,-1124 # 8000342c <.LC7>
80005726:	706010ef          	jal	80006e2c <printf>

    for (i = 0; i < size; i++) {
8000572a:	ce02                	sw	zero,28(sp)
8000572c:	a8b1                	j	80005788 <.L21>

8000572e <.L25>:
        if (datalen <= 8) {
8000572e:	4722                	lw	a4,8(sp)
80005730:	47a1                	li	a5,8
80005732:	00e7ee63          	bltu	a5,a4,8000574e <.L22>
            printf("0x%02x ", *(uint8_t *)buff);
80005736:	4792                	lw	a5,4(sp)
80005738:	0007c783          	lbu	a5,0(a5)
8000573c:	85be                	mv	a1,a5
8000573e:	bac18513          	add	a0,gp,-1108 # 8000343c <.LC8>
80005742:	6ea010ef          	jal	80006e2c <printf>
             buff += 1;
80005746:	4792                	lw	a5,4(sp)
80005748:	0785                	add	a5,a5,1
8000574a:	c23e                	sw	a5,4(sp)
8000574c:	a81d                	j	80005782 <.L23>

8000574e <.L22>:
        } else if (datalen <= 16) {
8000574e:	4722                	lw	a4,8(sp)
80005750:	47c1                	li	a5,16
80005752:	00e7ee63          	bltu	a5,a4,8000576e <.L24>
            printf("0x%02x ", *(uint16_t *)buff);
80005756:	4792                	lw	a5,4(sp)
80005758:	0007d783          	lhu	a5,0(a5)
8000575c:	85be                	mv	a1,a5
8000575e:	bac18513          	add	a0,gp,-1108 # 8000343c <.LC8>
80005762:	6ca010ef          	jal	80006e2c <printf>
            buff += 2;
80005766:	4792                	lw	a5,4(sp)
80005768:	0789                	add	a5,a5,2
8000576a:	c23e                	sw	a5,4(sp)
8000576c:	a819                	j	80005782 <.L23>

8000576e <.L24>:
        } else {
            printf("0x%02x ", *(uint32_t *)buff);
8000576e:	4792                	lw	a5,4(sp)
80005770:	439c                	lw	a5,0(a5)
80005772:	85be                	mv	a1,a5
80005774:	bac18513          	add	a0,gp,-1108 # 8000343c <.LC8>
80005778:	6b4010ef          	jal	80006e2c <printf>
            buff += 4;
8000577c:	4792                	lw	a5,4(sp)
8000577e:	0791                	add	a5,a5,4
80005780:	c23e                	sw	a5,4(sp)

80005782 <.L23>:
    for (i = 0; i < size; i++) {
80005782:	47f2                	lw	a5,28(sp)
80005784:	0785                	add	a5,a5,1
80005786:	ce3e                	sw	a5,28(sp)

80005788 <.L21>:
80005788:	4772                	lw	a4,28(sp)
8000578a:	4782                	lw	a5,0(sp)
8000578c:	faf761e3          	bltu	a4,a5,8000572e <.L25>
        }
    }
    printf("\n");
80005790:	bb418513          	add	a0,gp,-1100 # 80003444 <.LC9>
80005794:	698010ef          	jal	80006e2c <printf>
80005798:	a011                	j	8000579c <.L14>

8000579a <.L26>:
        return;
8000579a:	0001                	nop

8000579c <.L14>:
}
8000579c:	50b2                	lw	ra,44(sp)
8000579e:	6145                	add	sp,sp,48
800057a0:	8082                	ret

Disassembly of section .text.spi_slave_frame_dump:

800057a2 <spi_slave_frame_dump>:

void spi_slave_frame_dump(uint32_t datalen,
                          spi_control_config_t *config,
                          uint8_t *cmd,
                          uint8_t *wbuff,  uint32_t wsize, uint8_t *rbuff,  uint32_t rsize)
{
800057a2:	7139                	add	sp,sp,-64
800057a4:	de06                	sw	ra,60(sp)
800057a6:	ce2a                	sw	a0,28(sp)
800057a8:	cc2e                	sw	a1,24(sp)
800057aa:	ca32                	sw	a2,20(sp)
800057ac:	c836                	sw	a3,16(sp)
800057ae:	c63a                	sw	a4,12(sp)
800057b0:	c43e                	sw	a5,8(sp)
800057b2:	c242                	sw	a6,4(sp)
    uint8_t trans_mode = config->common_config.trans_mode;
800057b4:	47e2                	lw	a5,24(sp)
800057b6:	0087c783          	lbu	a5,8(a5)
800057ba:	02f107a3          	sb	a5,47(sp)

    spi_slave_comand_dump(config, cmd);
800057be:	45d2                	lw	a1,20(sp)
800057c0:	4562                	lw	a0,24(sp)
800057c2:	4c8020ef          	jal	80007c8a <spi_slave_comand_dump>
    spi_slave_address_dump(config);
800057c6:	4562                	lw	a0,24(sp)
800057c8:	3ddd                	jal	800056be <spi_slave_address_dump>

    if (trans_mode == spi_trans_write_read || trans_mode == spi_trans_write_dummy_read) {
800057ca:	02f14703          	lbu	a4,47(sp)
800057ce:	478d                	li	a5,3
800057d0:	00f70763          	beq	a4,a5,800057de <.L28>
800057d4:	02f14703          	lbu	a4,47(sp)
800057d8:	4795                	li	a5,5
800057da:	00f71d63          	bne	a4,a5,800057f4 <.L29>

800057de <.L28>:
        spi_slave_data_dump(spi_op_write, datalen, wbuff, wsize);
800057de:	46b2                	lw	a3,12(sp)
800057e0:	4642                	lw	a2,16(sp)
800057e2:	45f2                	lw	a1,28(sp)
800057e4:	4501                	li	a0,0
800057e6:	3dfd                	jal	800056e4 <spi_slave_data_dump>
        spi_slave_data_dump(spi_op_read, datalen, rbuff, rsize);
800057e8:	4692                	lw	a3,4(sp)
800057ea:	4622                	lw	a2,8(sp)
800057ec:	45f2                	lw	a1,28(sp)
800057ee:	4505                	li	a0,1
800057f0:	3dd5                	jal	800056e4 <spi_slave_data_dump>
800057f2:	a8bd                	j	80005870 <.L30>

800057f4 <.L29>:
    } else if (trans_mode == spi_trans_write_read_together || trans_mode == spi_trans_read_write ||  trans_mode == spi_trans_read_dummy_write) {
800057f4:	02f14783          	lbu	a5,47(sp)
800057f8:	cb99                	beqz	a5,8000580e <.L31>
800057fa:	02f14703          	lbu	a4,47(sp)
800057fe:	4791                	li	a5,4
80005800:	00f70763          	beq	a4,a5,8000580e <.L31>
80005804:	02f14703          	lbu	a4,47(sp)
80005808:	4799                	li	a5,6
8000580a:	00f71d63          	bne	a4,a5,80005824 <.L32>

8000580e <.L31>:
        spi_slave_data_dump(spi_op_read, datalen, rbuff, rsize);
8000580e:	4692                	lw	a3,4(sp)
80005810:	4622                	lw	a2,8(sp)
80005812:	45f2                	lw	a1,28(sp)
80005814:	4505                	li	a0,1
80005816:	35f9                	jal	800056e4 <spi_slave_data_dump>
        spi_slave_data_dump(spi_op_write, datalen, wbuff, wsize);
80005818:	46b2                	lw	a3,12(sp)
8000581a:	4642                	lw	a2,16(sp)
8000581c:	45f2                	lw	a1,28(sp)
8000581e:	4501                	li	a0,0
80005820:	35d1                	jal	800056e4 <spi_slave_data_dump>
80005822:	a0b9                	j	80005870 <.L30>

80005824 <.L32>:
    } else if (trans_mode == spi_trans_write_only || trans_mode == spi_trans_dummy_write) {
80005824:	02f14703          	lbu	a4,47(sp)
80005828:	4785                	li	a5,1
8000582a:	00f70763          	beq	a4,a5,80005838 <.L33>
8000582e:	02f14703          	lbu	a4,47(sp)
80005832:	47a1                	li	a5,8
80005834:	00f71863          	bne	a4,a5,80005844 <.L34>

80005838 <.L33>:
        spi_slave_data_dump(spi_op_write, datalen, wbuff, wsize);
80005838:	46b2                	lw	a3,12(sp)
8000583a:	4642                	lw	a2,16(sp)
8000583c:	45f2                	lw	a1,28(sp)
8000583e:	4501                	li	a0,0
80005840:	3555                	jal	800056e4 <spi_slave_data_dump>
80005842:	a03d                	j	80005870 <.L30>

80005844 <.L34>:
    } else if (trans_mode == spi_trans_read_only || trans_mode == spi_trans_dummy_read) {
80005844:	02f14703          	lbu	a4,47(sp)
80005848:	4789                	li	a5,2
8000584a:	00f70763          	beq	a4,a5,80005858 <.L35>
8000584e:	02f14703          	lbu	a4,47(sp)
80005852:	47a5                	li	a5,9
80005854:	00f71863          	bne	a4,a5,80005864 <.L36>

80005858 <.L35>:
         spi_slave_data_dump(spi_op_read, datalen, rbuff, rsize);
80005858:	4692                	lw	a3,4(sp)
8000585a:	4622                	lw	a2,8(sp)
8000585c:	45f2                	lw	a1,28(sp)
8000585e:	4505                	li	a0,1
80005860:	3551                	jal	800056e4 <spi_slave_data_dump>
80005862:	a039                	j	80005870 <.L30>

80005864 <.L36>:
    } else {
        spi_slave_data_dump(spi_op_no_data, 0, NULL, 0);
80005864:	4681                	li	a3,0
80005866:	4601                	li	a2,0
80005868:	4581                	li	a1,0
8000586a:	4509                	li	a0,2
8000586c:	3da5                	jal	800056e4 <spi_slave_data_dump>
    }
}
8000586e:	0001                	nop

80005870 <.L30>:
80005870:	0001                	nop
80005872:	50f2                	lw	ra,60(sp)
80005874:	6121                	add	sp,sp,64
80005876:	8082                	ret

Disassembly of section .text.init_pins:

80005878 <init_pins>:
//    HPM_IOC->PAD[IOC_PAD_PC28].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3);
//    HPM_IOC->PAD[IOC_PAD_PC29].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3);
    }
else
{
    HPM_IOC->PAD[IOC_PAD_PA29].FUNC_CTL = IOC_PA29_FUNC_CTL_SPI3_MOSI;
80005878:	f40407b7          	lui	a5,0xf4040
8000587c:	4715                	li	a4,5
8000587e:	0ee7a423          	sw	a4,232(a5) # f40400e8 <__AHB_SRAM_segment_end__+0x3e380e8>

    HPM_IOC->PAD[IOC_PAD_PA28].FUNC_CTL = IOC_PA28_FUNC_CTL_SPI3_MISO;
80005882:	f40407b7          	lui	a5,0xf4040
80005886:	4715                	li	a4,5
80005888:	0ee7a023          	sw	a4,224(a5) # f40400e0 <__AHB_SRAM_segment_end__+0x3e380e0>

    HPM_IOC->PAD[IOC_PAD_PA26].FUNC_CTL = IOC_PA26_FUNC_CTL_SPI3_SCLK | IOC_PAD_FUNC_CTL_LOOP_BACK_MASK;
8000588c:	f40407b7          	lui	a5,0xf4040
80005890:	6741                	lui	a4,0x10
80005892:	0715                	add	a4,a4,5 # 10005 <__AHB_SRAM_segment_size__+0x8005>
80005894:	0ce7a823          	sw	a4,208(a5) # f40400d0 <__AHB_SRAM_segment_end__+0x3e380d0>

    HPM_IOC->PAD[IOC_PAD_PA27].FUNC_CTL = IOC_PA27_FUNC_CTL_SPI3_CS_0;
80005898:	f40407b7          	lui	a5,0xf4040
8000589c:	4715                	li	a4,5
8000589e:	0ce7ac23          	sw	a4,216(a5) # f40400d8 <__AHB_SRAM_segment_end__+0x3e380d8>

           /* set max frequency slew rate(200M) */
    HPM_IOC->PAD[IOC_PAD_PA27].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3) | IOC_PAD_PAD_CTL_PE_SET(1) | IOC_PAD_PAD_CTL_PS_SET(1) | IOC_PAD_PAD_CTL_PRS_SET(1);
800058a2:	f40407b7          	lui	a5,0xf4040
800058a6:	00160737          	lui	a4,0x160
800058aa:	07070713          	add	a4,a4,112 # 160070 <__AXI_SRAM_segment_size__+0xe0070>
800058ae:	0ce7ae23          	sw	a4,220(a5) # f40400dc <__AHB_SRAM_segment_end__+0x3e380dc>
    HPM_IOC->PAD[IOC_PAD_PA26].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3);
800058b2:	f40407b7          	lui	a5,0xf4040
800058b6:	07000713          	li	a4,112
800058ba:	0ce7aa23          	sw	a4,212(a5) # f40400d4 <__AHB_SRAM_segment_end__+0x3e380d4>
    HPM_IOC->PAD[IOC_PAD_PA28].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3);
800058be:	f40407b7          	lui	a5,0xf4040
800058c2:	07000713          	li	a4,112
800058c6:	0ee7a223          	sw	a4,228(a5) # f40400e4 <__AHB_SRAM_segment_end__+0x3e380e4>
    HPM_IOC->PAD[IOC_PAD_PA29].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3);
800058ca:	f40407b7          	lui	a5,0xf4040
800058ce:	07000713          	li	a4,112
800058d2:	0ee7a623          	sw	a4,236(a5) # f40400ec <__AHB_SRAM_segment_end__+0x3e380ec>

}

}
800058d6:	0001                	nop
800058d8:	8082                	ret

Disassembly of section .text.main:

800058da <main>:
    gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
}


int main(void)
{
800058da:	715d                	add	sp,sp,-80
800058dc:	c686                	sw	ra,76(sp)
    uint8_t wbuff[16] = {0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9,0xba,0xbb,0xbc,0xbd,0xbe,0xbf};
800058de:	c6018793          	add	a5,gp,-928 # 800034f0 <.LC10>
800058e2:	4390                	lw	a2,0(a5)
800058e4:	43d4                	lw	a3,4(a5)
800058e6:	4798                	lw	a4,8(a5)
800058e8:	47dc                	lw	a5,12(a5)
800058ea:	d632                	sw	a2,44(sp)
800058ec:	d836                	sw	a3,48(sp)
800058ee:	da3a                	sw	a4,52(sp)
800058f0:	dc3e                	sw	a5,56(sp)
    uint8_t rbuff[16] = {0};
800058f2:	ce02                	sw	zero,28(sp)
800058f4:	d002                	sw	zero,32(sp)
800058f6:	d202                	sw	zero,36(sp)
800058f8:	d402                	sw	zero,40(sp)
    spi_format_config_t format_config = {0};
800058fa:	ca02                	sw	zero,20(sp)
800058fc:	cc02                	sw	zero,24(sp)
    spi_control_config_t control_config = {0};
800058fe:	c402                	sw	zero,8(sp)
80005900:	c602                	sw	zero,12(sp)
80005902:	c802                	sw	zero,16(sp)
    hpm_stat_t stat;

    /* bsp initialization */
    board_init();
80005904:	7b2010ef          	jal	800070b6 <board_init>
    board_init_spi_clock(HPM_SPI3);//HPM_SPI2
80005908:	f007c537          	lui	a0,0xf007c
8000590c:	7dc010ef          	jal	800070e8 <board_init_spi_clock>

    init_pins_io();
80005910:	3ae020ef          	jal	80007cbe <init_pins_io>
    init_pins();
80005914:	3795                	jal	80005878 <init_pins>
     //  board_init_spi_pins(BOARD_APP_SPI_BASE);

    printf("SPI-Slave Polling Transfer Example\n");
80005916:	bb818513          	add	a0,gp,-1096 # 80003448 <.LC11>
8000591a:	512010ef          	jal	80006e2c <printf>

    /* set SPI format config for slave */
    spi_slave_get_default_format_config(&format_config);
8000591e:	085c                	add	a5,sp,20
80005920:	853e                	mv	a0,a5
80005922:	3879                	jal	800051c0 <spi_slave_get_default_format_config>
    format_config.common_config.data_len_in_bits = BOARD_APP_SPI_DATA_LEN_IN_BITS;
80005924:	47a1                	li	a5,8
80005926:	00f10aa3          	sb	a5,21(sp)
    format_config.common_config.mode = spi_slave_mode;
8000592a:	4785                	li	a5,1
8000592c:	00f10ca3          	sb	a5,25(sp)
    format_config.common_config.cpol = 0;//spi_sclk_high_idle;
80005930:	00010d23          	sb	zero,26(sp)
    format_config.common_config.cpha = 0;//spi_sclk_sampling_even_clk_edges;
80005934:	00010da3          	sb	zero,27(sp)
    spi_format_init(HPM_SPI3, &format_config);
80005938:	085c                	add	a5,sp,20
8000593a:	85be                	mv	a1,a5
8000593c:	f007c537          	lui	a0,0xf007c
80005940:	487010ef          	jal	800075c6 <spi_format_init>
    printf("SPI-Slave transfer format is configured.\n");
80005944:	bdc18513          	add	a0,gp,-1060 # 8000346c <.LC12>
80005948:	4e4010ef          	jal	80006e2c <printf>

    /* set SPI control config for slave */
    spi_slave_get_default_control_config(&control_config);
8000594c:	003c                	add	a5,sp,8
8000594e:	853e                	mv	a0,a5
80005950:	43f010ef          	jal	8000758e <spi_slave_get_default_control_config>
    control_config.slave_config.slave_data_only = true; /* raw data mode for slave */
80005954:	4785                	li	a5,1
80005956:	00f106a3          	sb	a5,13(sp)
    /* data only mode, trans_mode have to be spi_trans_write_read_together */
    control_config.common_config.trans_mode = spi_trans_write_read_together;
8000595a:	00010823          	sb	zero,16(sp)
    spi_transfer_mode_print(&control_config);
8000595e:	003c                	add	a5,sp,8
80005960:	853e                	mv	a0,a5
80005962:	3319                	jal	80005668 <spi_transfer_mode_print>

    printf("SPI-Slave transfer waits.\n");
80005964:	c0818513          	add	a0,gp,-1016 # 80003498 <.LC13>
80005968:	4c4010ef          	jal	80006e2c <printf>

8000596c <.L43>:

  

    while (1) {

        gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
8000596c:	4685                	li	a3,1
8000596e:	4601                	li	a2,0
80005970:	458d                	li	a1,3
80005972:	00300537          	lui	a0,0x300
80005976:	31a9                	jal	800055c0 <gpio_write_pin>
        board_delay_ms(100);
80005978:	06400513          	li	a0,100
8000597c:	758010ef          	jal	800070d4 <board_delay_ms>
        gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 0);
80005980:	4681                	li	a3,0
80005982:	4601                	li	a2,0
80005984:	458d                	li	a1,3
80005986:	00300537          	lui	a0,0x300
8000598a:	391d                	jal	800055c0 <gpio_write_pin>
        board_delay_ms(100);
8000598c:	06400513          	li	a0,100
80005990:	744010ef          	jal	800070d4 <board_delay_ms>

80005994 <.L40>:



  do {
        stat = spi_transfer(HPM_SPI3,
80005994:	087c                	add	a5,sp,28
80005996:	1078                	add	a4,sp,44
80005998:	002c                	add	a1,sp,8
8000599a:	48c1                	li	a7,16
8000599c:	883e                	mv	a6,a5
8000599e:	47c1                	li	a5,16
800059a0:	4681                	li	a3,0
800059a2:	4601                	li	a2,0
800059a4:	f007c537          	lui	a0,0xf007c
800059a8:	49f010ef          	jal	80007646 <spi_transfer>
800059ac:	de2a                	sw	a0,60(sp)
                        &control_config,
                        NULL, NULL,
                        (uint8_t *)wbuff, ARRAY_SIZE(wbuff), (uint8_t *)rbuff, ARRAY_SIZE(rbuff));
    } while (stat == status_timeout);
800059ae:	5772                	lw	a4,60(sp)
800059b0:	478d                	li	a5,3
800059b2:	fef701e3          	beq	a4,a5,80005994 <.L40>

    if (stat == status_success) {
800059b6:	57f2                	lw	a5,60(sp)
800059b8:	ef91                	bnez	a5,800059d4 <.L41>
        spi_slave_frame_dump(BOARD_APP_SPI_DATA_LEN_IN_BITS,
800059ba:	087c                	add	a5,sp,28
800059bc:	1074                	add	a3,sp,44
800059be:	002c                	add	a1,sp,8
800059c0:	4841                	li	a6,16
800059c2:	4741                	li	a4,16
800059c4:	4601                	li	a2,0
800059c6:	4521                	li	a0,8
800059c8:	3be9                	jal	800057a2 <spi_slave_frame_dump>
                                &control_config,
                                NULL,
                                (uint8_t *)wbuff, ARRAY_SIZE(wbuff), (uint8_t *)rbuff, ARRAY_SIZE(rbuff));

        printf("SPI-Slave transfer ends.\n");
800059ca:	c2418513          	add	a0,gp,-988 # 800034b4 <.LC14>
800059ce:	45e010ef          	jal	80006e2c <printf>
800059d2:	bf69                	j	8000596c <.L43>

800059d4 <.L41>:
    } else {
        printf("SPI-Slave transfer error[%d]!\n", stat);
800059d4:	55f2                	lw	a1,60(sp)
800059d6:	c4018513          	add	a0,gp,-960 # 800034d0 <.LC15>
800059da:	452010ef          	jal	80006e2c <printf>
        gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
800059de:	b779                	j	8000596c <.L43>

Disassembly of section .text._clean_up:

800059e0 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
800059e0:	7139                	add	sp,sp,-64

800059e2 <.LBB18>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
800059e2:	28b01793          	bset	a5,zero,0xb
800059e6:	3047b073          	csrc	mie,a5
}
800059ea:	0001                	nop
800059ec:	da02                	sw	zero,52(sp)
800059ee:	d802                	sw	zero,48(sp)
800059f0:	e40007b7          	lui	a5,0xe4000
800059f4:	d63e                	sw	a5,44(sp)
800059f6:	57d2                	lw	a5,52(sp)
800059f8:	d43e                	sw	a5,40(sp)
800059fa:	57c2                	lw	a5,48(sp)
800059fc:	d23e                	sw	a5,36(sp)

800059fe <.LBB20>:
                                                           uint32_t target,
                                                           uint32_t threshold)
{
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_THRESHOLD_OFFSET +
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
800059fe:	57a2                	lw	a5,40(sp)
80005a00:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
80005a04:	57b2                	lw	a5,44(sp)
80005a06:	973e                	add	a4,a4,a5
80005a08:	002007b7          	lui	a5,0x200
80005a0c:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
80005a0e:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
80005a10:	5782                	lw	a5,32(sp)
80005a12:	5712                	lw	a4,36(sp)
80005a14:	c398                	sw	a4,0(a5)
}
80005a16:	0001                	nop

80005a18 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
80005a18:	0001                	nop

80005a1a <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
80005a1a:	de02                	sw	zero,60(sp)
80005a1c:	a82d                	j	80005a56 <.L2>

80005a1e <.L3>:
80005a1e:	ce02                	sw	zero,28(sp)
80005a20:	57f2                	lw	a5,60(sp)
80005a22:	cc3e                	sw	a5,24(sp)
80005a24:	e40007b7          	lui	a5,0xe4000
80005a28:	ca3e                	sw	a5,20(sp)
80005a2a:	47f2                	lw	a5,28(sp)
80005a2c:	c83e                	sw	a5,16(sp)
80005a2e:	47e2                	lw	a5,24(sp)
80005a30:	c63e                	sw	a5,12(sp)

80005a32 <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
80005a32:	47c2                	lw	a5,16(sp)
80005a34:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
80005a38:	47d2                	lw	a5,20(sp)
80005a3a:	973e                	add	a4,a4,a5
80005a3c:	002007b7          	lui	a5,0x200
80005a40:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_start__+0x4>
80005a42:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
80005a44:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
80005a46:	47a2                	lw	a5,8(sp)
80005a48:	4732                	lw	a4,12(sp)
80005a4a:	c398                	sw	a4,0(a5)
}
80005a4c:	0001                	nop

80005a4e <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
80005a4e:	0001                	nop

80005a50 <.LBE25>:
80005a50:	57f2                	lw	a5,60(sp)
80005a52:	0785                	add	a5,a5,1
80005a54:	de3e                	sw	a5,60(sp)

80005a56 <.L2>:
80005a56:	5772                	lw	a4,60(sp)
80005a58:	07f00793          	li	a5,127
80005a5c:	fce7f1e3          	bgeu	a5,a4,80005a1e <.L3>

80005a60 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
80005a60:	dc02                	sw	zero,56(sp)
80005a62:	a821                	j	80005a7a <.L4>

80005a64 <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
80005a64:	57e2                	lw	a5,56(sp)
80005a66:	00279713          	sll	a4,a5,0x2
80005a6a:	e40027b7          	lui	a5,0xe4002
80005a6e:	97ba                	add	a5,a5,a4
80005a70:	0007a023          	sw	zero,0(a5) # e4002000 <__FLASH_segment_end__+0x63002000>
    for (uint32_t i = 0; i < 4; i++) {
80005a74:	57e2                	lw	a5,56(sp)
80005a76:	0785                	add	a5,a5,1
80005a78:	dc3e                	sw	a5,56(sp)

80005a7a <.L4>:
80005a7a:	5762                	lw	a4,56(sp)
80005a7c:	478d                	li	a5,3
80005a7e:	fee7f3e3          	bgeu	a5,a4,80005a64 <.L5>

80005a82 <.LBE29>:
    }
}
80005a82:	0001                	nop
80005a84:	0001                	nop
80005a86:	6121                	add	sp,sp,64
80005a88:	8082                	ret

Disassembly of section .text.syscall_handler:

80005a8a <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
80005a8a:	1101                	add	sp,sp,-32
80005a8c:	ce2a                	sw	a0,28(sp)
80005a8e:	cc2e                	sw	a1,24(sp)
80005a90:	ca32                	sw	a2,20(sp)
80005a92:	c836                	sw	a3,16(sp)
80005a94:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
80005a96:	0001                	nop
80005a98:	6105                	add	sp,sp,32
80005a9a:	8082                	ret

Disassembly of section .text.hpm_csr_get_core_cycle:

80005a9c <hpm_csr_get_core_cycle>:
 *          - in user mode if the device supports M/U mode
 *
 * @return CSR cycle value in 64-bit
 */
static inline uint64_t hpm_csr_get_core_cycle(void)
{
80005a9c:	7179                	add	sp,sp,-48

80005a9e <.LBB2>:
    uint64_t result;
    uint32_t resultl_first = read_csr(CSR_CYCLE);
80005a9e:	c0002f73          	rdcycle	t5
80005aa2:	d27a                	sw	t5,36(sp)
80005aa4:	5f12                	lw	t5,36(sp)

80005aa6 <.LBE2>:
80005aa6:	d07a                	sw	t5,32(sp)

80005aa8 <.LBB3>:
    uint32_t resulth = read_csr(CSR_CYCLEH);
80005aa8:	c8002f73          	rdcycleh	t5
80005aac:	ce7a                	sw	t5,28(sp)
80005aae:	4f72                	lw	t5,28(sp)

80005ab0 <.LBE3>:
80005ab0:	cc7a                	sw	t5,24(sp)

80005ab2 <.LBB4>:
    uint32_t resultl_second = read_csr(CSR_CYCLE);
80005ab2:	c0002f73          	rdcycle	t5
80005ab6:	ca7a                	sw	t5,20(sp)
80005ab8:	4f52                	lw	t5,20(sp)

80005aba <.LBE4>:
80005aba:	c87a                	sw	t5,16(sp)
    if (resultl_first < resultl_second) {
80005abc:	5f82                	lw	t6,32(sp)
80005abe:	4f42                	lw	t5,16(sp)
80005ac0:	03eff263          	bgeu	t6,t5,80005ae4 <.L2>
        result = ((uint64_t)resulth << 32) | resultl_first; /* if CYCLE didn't roll over, return the value directly */
80005ac4:	47e2                	lw	a5,24(sp)
80005ac6:	8e3e                	mv	t3,a5
80005ac8:	4e81                	li	t4,0
80005aca:	000e1693          	sll	a3,t3,0x0
80005ace:	4601                	li	a2,0
80005ad0:	5782                	lw	a5,32(sp)
80005ad2:	883e                	mv	a6,a5
80005ad4:	4881                	li	a7,0
80005ad6:	010667b3          	or	a5,a2,a6
80005ada:	d43e                	sw	a5,40(sp)
80005adc:	0116e7b3          	or	a5,a3,a7
80005ae0:	d63e                	sw	a5,44(sp)
80005ae2:	a025                	j	80005b0a <.L3>

80005ae4 <.L2>:
    } else {
        resulth = read_csr(CSR_CYCLEH);
80005ae4:	c80026f3          	rdcycleh	a3
80005ae8:	c636                	sw	a3,12(sp)
80005aea:	46b2                	lw	a3,12(sp)

80005aec <.LBE5>:
80005aec:	cc36                	sw	a3,24(sp)
        result = ((uint64_t)resulth << 32) | resultl_second; /* if CYCLE rolled over, need to get the CYCLEH again */
80005aee:	46e2                	lw	a3,24(sp)
80005af0:	8336                	mv	t1,a3
80005af2:	4381                	li	t2,0
80005af4:	00031793          	sll	a5,t1,0x0
80005af8:	4701                	li	a4,0
80005afa:	46c2                	lw	a3,16(sp)
80005afc:	8536                	mv	a0,a3
80005afe:	4581                	li	a1,0
80005b00:	00a766b3          	or	a3,a4,a0
80005b04:	d436                	sw	a3,40(sp)
80005b06:	8fcd                	or	a5,a5,a1
80005b08:	d63e                	sw	a5,44(sp)

80005b0a <.L3>:
    }
    return result;
80005b0a:	5722                	lw	a4,40(sp)
80005b0c:	57b2                	lw	a5,44(sp)
 }
80005b0e:	853a                	mv	a0,a4
80005b10:	85be                	mv	a1,a5
80005b12:	6145                	add	sp,sp,48
80005b14:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

80005b16 <get_frequency_for_source>:
    }
    return clk_freq;
}

uint32_t get_frequency_for_source(clock_source_t source)
{
80005b16:	7179                	add	sp,sp,-48
80005b18:	d606                	sw	ra,44(sp)
80005b1a:	87aa                	mv	a5,a0
80005b1c:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80005b20:	ce02                	sw	zero,28(sp)
    switch (source) {
80005b22:	00f14783          	lbu	a5,15(sp)
80005b26:	471d                	li	a4,7
80005b28:	08f76763          	bltu	a4,a5,80005bb6 <.L35>
80005b2c:	00279713          	sll	a4,a5,0x2
80005b30:	cf818793          	add	a5,gp,-776 # 80003588 <.L37>
80005b34:	97ba                	add	a5,a5,a4
80005b36:	439c                	lw	a5,0(a5)
80005b38:	8782                	jr	a5

80005b3a <.L44>:
    case clock_source_osc0_clk0:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80005b3a:	016e37b7          	lui	a5,0x16e3
80005b3e:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
80005b42:	ce3e                	sw	a5,28(sp)
        break;
80005b44:	a89d                	j	80005bba <.L45>

80005b46 <.L43>:
    case clock_source_pll0_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0);
80005b46:	4601                	li	a2,0
80005b48:	4581                	li	a1,0
80005b4a:	f40c0537          	lui	a0,0xf40c0
80005b4e:	069010ef          	jal	800073b6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80005b52:	ce2a                	sw	a0,28(sp)
        break;
80005b54:	a09d                	j	80005bba <.L45>

80005b56 <.L42>:
    case clock_source_pll0_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1);
80005b56:	4605                	li	a2,1
80005b58:	4581                	li	a1,0
80005b5a:	f40c0537          	lui	a0,0xf40c0
80005b5e:	059010ef          	jal	800073b6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80005b62:	ce2a                	sw	a0,28(sp)
        break;
80005b64:	a899                	j	80005bba <.L45>

80005b66 <.L41>:
    case clock_source_pll1_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk0);
80005b66:	4601                	li	a2,0
80005b68:	4585                	li	a1,1
80005b6a:	f40c0537          	lui	a0,0xf40c0
80005b6e:	049010ef          	jal	800073b6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80005b72:	ce2a                	sw	a0,28(sp)
        break;
80005b74:	a099                	j	80005bba <.L45>

80005b76 <.L40>:
    case clock_source_pll1_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk1);
80005b76:	4605                	li	a2,1
80005b78:	4585                	li	a1,1
80005b7a:	f40c0537          	lui	a0,0xf40c0
80005b7e:	039010ef          	jal	800073b6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80005b82:	ce2a                	sw	a0,28(sp)
        break;
80005b84:	a81d                	j	80005bba <.L45>

80005b86 <.L39>:
    case clock_source_pll1_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk2);
80005b86:	4609                	li	a2,2
80005b88:	4585                	li	a1,1
80005b8a:	f40c0537          	lui	a0,0xf40c0
80005b8e:	029010ef          	jal	800073b6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80005b92:	ce2a                	sw	a0,28(sp)
        break;
80005b94:	a01d                	j	80005bba <.L45>

80005b96 <.L38>:
    case clock_source_pll2_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll2, pllctlv2_clk0);
80005b96:	4601                	li	a2,0
80005b98:	4589                	li	a1,2
80005b9a:	f40c0537          	lui	a0,0xf40c0
80005b9e:	019010ef          	jal	800073b6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80005ba2:	ce2a                	sw	a0,28(sp)
        break;
80005ba4:	a819                	j	80005bba <.L45>

80005ba6 <.L36>:
    case clock_source_pll2_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll2, pllctlv2_clk1);
80005ba6:	4605                	li	a2,1
80005ba8:	4589                	li	a1,2
80005baa:	f40c0537          	lui	a0,0xf40c0
80005bae:	009010ef          	jal	800073b6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80005bb2:	ce2a                	sw	a0,28(sp)
        break;
80005bb4:	a019                	j	80005bba <.L45>

80005bb6 <.L35>:
    default:
        clk_freq = 0UL;
80005bb6:	ce02                	sw	zero,28(sp)
        break;
80005bb8:	0001                	nop

80005bba <.L45>:
    }

    return clk_freq;
80005bba:	47f2                	lw	a5,28(sp)
}
80005bbc:	853e                	mv	a0,a5
80005bbe:	50b2                	lw	ra,44(sp)
80005bc0:	6145                	add	sp,sp,48
80005bc2:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

80005bc4 <get_frequency_for_ip_in_common_group>:

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
80005bc4:	7139                	add	sp,sp,-64
80005bc6:	de06                	sw	ra,60(sp)
80005bc8:	87aa                	mv	a5,a0
80005bca:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80005bce:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
80005bd0:	00f14783          	lbu	a5,15(sp)
80005bd4:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
80005bd6:	5722                	lw	a4,40(sp)
80005bd8:	04e00793          	li	a5,78
80005bdc:	04e7e563          	bltu	a5,a4,80005c26 <.L48>

80005be0 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
80005be0:	57a2                	lw	a5,40(sp)
80005be2:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
80005be4:	f4000737          	lui	a4,0xf4000
80005be8:	5792                	lw	a5,36(sp)
80005bea:	60078793          	add	a5,a5,1536
80005bee:	078a                	sll	a5,a5,0x2
80005bf0:	97ba                	add	a5,a5,a4
80005bf2:	439c                	lw	a5,0(a5)
80005bf4:	0ff7f793          	zext.b	a5,a5
80005bf8:	0785                	add	a5,a5,1
80005bfa:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
80005bfc:	f4000737          	lui	a4,0xf4000
80005c00:	5792                	lw	a5,36(sp)
80005c02:	60078793          	add	a5,a5,1536
80005c06:	078a                	sll	a5,a5,0x2
80005c08:	97ba                	add	a5,a5,a4
80005c0a:	439c                	lw	a5,0(a5)
80005c0c:	83a1                	srl	a5,a5,0x8
80005c0e:	8b9d                	and	a5,a5,7
80005c10:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
80005c14:	01f14783          	lbu	a5,31(sp)
80005c18:	853e                	mv	a0,a5
80005c1a:	3df5                	jal	80005b16 <get_frequency_for_source>
80005c1c:	872a                	mv	a4,a0
80005c1e:	5782                	lw	a5,32(sp)
80005c20:	02f757b3          	divu	a5,a4,a5
80005c24:	d63e                	sw	a5,44(sp)

80005c26 <.L48>:
    }
    return clk_freq;
80005c26:	57b2                	lw	a5,44(sp)
}
80005c28:	853e                	mv	a0,a5
80005c2a:	50f2                	lw	ra,60(sp)
80005c2c:	6121                	add	sp,sp,64
80005c2e:	8082                	ret

Disassembly of section .text.get_frequency_for_i2s:

80005c30 <get_frequency_for_i2s>:
    }
    return clk_freq;
}

static uint32_t get_frequency_for_i2s(uint32_t instance)
{
80005c30:	7179                	add	sp,sp,-48
80005c32:	d606                	sw	ra,44(sp)
80005c34:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80005c36:	ce02                	sw	zero,28(sp)
    clock_node_t node;
    uint32_t mux_in_reg;

    if (instance < I2S_INSTANCE_NUM) {
80005c38:	4732                	lw	a4,12(sp)
80005c3a:	4785                	li	a5,1
80005c3c:	04e7e763          	bltu	a5,a4,80005c8a <.L56>
        mux_in_reg = SYSCTL_I2SCLK_MUX_GET(HPM_SYSCTL->I2SCLK[instance]);
80005c40:	f4000737          	lui	a4,0xf4000
80005c44:	47b2                	lw	a5,12(sp)
80005c46:	70478793          	add	a5,a5,1796
80005c4a:	078a                	sll	a5,a5,0x2
80005c4c:	97ba                	add	a5,a5,a4
80005c4e:	439c                	lw	a5,0(a5)
80005c50:	83a1                	srl	a5,a5,0x8
80005c52:	8b85                	and	a5,a5,1
80005c54:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg == 0) {
80005c56:	47d2                	lw	a5,20(sp)
80005c58:	eb89                	bnez	a5,80005c6a <.L57>
            node = clock_node_aud0 + instance;
80005c5a:	47b2                	lw	a5,12(sp)
80005c5c:	0ff7f793          	zext.b	a5,a5
80005c60:	03578793          	add	a5,a5,53
80005c64:	00f10da3          	sb	a5,27(sp)
80005c68:	a821                	j	80005c80 <.L58>

80005c6a <.L57>:
        } else if (instance == 0) {
80005c6a:	47b2                	lw	a5,12(sp)
80005c6c:	e791                	bnez	a5,80005c78 <.L59>
            node = clock_node_aud1;
80005c6e:	03600793          	li	a5,54
80005c72:	00f10da3          	sb	a5,27(sp)
80005c76:	a029                	j	80005c80 <.L58>

80005c78 <.L59>:
        } else {
            node = clock_node_aud0;
80005c78:	03500793          	li	a5,53
80005c7c:	00f10da3          	sb	a5,27(sp)

80005c80 <.L58>:
        }
        clk_freq = get_frequency_for_ip_in_common_group(node);
80005c80:	01b14783          	lbu	a5,27(sp)
80005c84:	853e                	mv	a0,a5
80005c86:	3f3d                	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80005c88:	ce2a                	sw	a0,28(sp)

80005c8a <.L56>:
    }

    return clk_freq;
80005c8a:	47f2                	lw	a5,28(sp)
}
80005c8c:	853e                	mv	a0,a5
80005c8e:	50b2                	lw	ra,44(sp)
80005c90:	6145                	add	sp,sp,48
80005c92:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80005c94 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80005c94:	7179                	add	sp,sp,-48
80005c96:	d606                	sw	ra,44(sp)
80005c98:	c62a                	sw	a0,12(sp)
80005c9a:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80005c9c:	47b2                	lw	a5,12(sp)
80005c9e:	83c1                	srl	a5,a5,0x10
80005ca0:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80005ca2:	4772                	lw	a4,28(sp)
80005ca4:	17b00793          	li	a5,379
80005ca8:	00e7ef63          	bltu	a5,a4,80005cc6 <.L155>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80005cac:	47a2                	lw	a5,8(sp)
80005cae:	0ff7f793          	zext.b	a5,a5
80005cb2:	4772                	lw	a4,28(sp)
80005cb4:	08074733          	zext.h	a4,a4
80005cb8:	4685                	li	a3,1
80005cba:	863a                	mv	a2,a4
80005cbc:	85be                	mv	a1,a5
80005cbe:	f4000537          	lui	a0,0xf4000
80005cc2:	3b0020ef          	jal	80008072 <sysctl_enable_group_resource>

80005cc6 <.L155>:
    }
}
80005cc6:	0001                	nop
80005cc8:	50b2                	lw	ra,44(sp)
80005cca:	6145                	add	sp,sp,48
80005ccc:	8082                	ret

Disassembly of section .text.clock_cpu_delay_ms:

80005cce <clock_cpu_delay_ms>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_cpu_delay_ms(uint32_t ms)
{
80005cce:	715d                	add	sp,sp,-80
80005cd0:	c686                	sw	ra,76(sp)
80005cd2:	c4a2                	sw	s0,72(sp)
80005cd4:	c2a6                	sw	s1,68(sp)
80005cd6:	c0ca                	sw	s2,64(sp)
80005cd8:	de4e                	sw	s3,60(sp)
80005cda:	dc52                	sw	s4,56(sp)
80005cdc:	da56                	sw	s5,52(sp)
80005cde:	d85a                	sw	s6,48(sp)
80005ce0:	d65e                	sw	s7,44(sp)
80005ce2:	c62a                	sw	a0,12(sp)
    uint64_t expected_ticks = hpm_csr_get_core_cycle() + (uint64_t)clock_get_core_clock_ticks_per_ms() * (uint64_t)ms;
80005ce4:	3b65                	jal	80005a9c <hpm_csr_get_core_cycle>
80005ce6:	8b2a                	mv	s6,a0
80005ce8:	8bae                	mv	s7,a1
80005cea:	32c020ef          	jal	80008016 <clock_get_core_clock_ticks_per_ms>
80005cee:	87aa                	mv	a5,a0
80005cf0:	8a3e                	mv	s4,a5
80005cf2:	4a81                	li	s5,0
80005cf4:	47b2                	lw	a5,12(sp)
80005cf6:	893e                	mv	s2,a5
80005cf8:	4981                	li	s3,0
80005cfa:	032a8733          	mul	a4,s5,s2
80005cfe:	034987b3          	mul	a5,s3,s4
80005d02:	97ba                	add	a5,a5,a4
80005d04:	032a0733          	mul	a4,s4,s2
80005d08:	032a34b3          	mulhu	s1,s4,s2
80005d0c:	843a                	mv	s0,a4
80005d0e:	97a6                	add	a5,a5,s1
80005d10:	84be                	mv	s1,a5
80005d12:	008b0733          	add	a4,s6,s0
80005d16:	86ba                	mv	a3,a4
80005d18:	0166b6b3          	sltu	a3,a3,s6
80005d1c:	009b87b3          	add	a5,s7,s1
80005d20:	96be                	add	a3,a3,a5
80005d22:	87b6                	mv	a5,a3
80005d24:	cc3a                	sw	a4,24(sp)
80005d26:	ce3e                	sw	a5,28(sp)
    while (hpm_csr_get_core_cycle() < expected_ticks) {
80005d28:	0001                	nop

80005d2a <.L179>:
80005d2a:	3b8d                	jal	80005a9c <hpm_csr_get_core_cycle>
80005d2c:	872a                	mv	a4,a0
80005d2e:	87ae                	mv	a5,a1
80005d30:	46f2                	lw	a3,28(sp)
80005d32:	863e                	mv	a2,a5
80005d34:	fed66be3          	bltu	a2,a3,80005d2a <.L179>
80005d38:	46f2                	lw	a3,28(sp)
80005d3a:	863e                	mv	a2,a5
80005d3c:	00c69663          	bne	a3,a2,80005d48 <.L181>
80005d40:	46e2                	lw	a3,24(sp)
80005d42:	87ba                	mv	a5,a4
80005d44:	fed7e3e3          	bltu	a5,a3,80005d2a <.L179>

80005d48 <.L181>:
    }
}
80005d48:	0001                	nop
80005d4a:	40b6                	lw	ra,76(sp)
80005d4c:	4426                	lw	s0,72(sp)
80005d4e:	4496                	lw	s1,68(sp)
80005d50:	4906                	lw	s2,64(sp)
80005d52:	59f2                	lw	s3,60(sp)
80005d54:	5a62                	lw	s4,56(sp)
80005d56:	5ad2                	lw	s5,52(sp)
80005d58:	5b42                	lw	s6,48(sp)
80005d5a:	5bb2                	lw	s7,44(sp)
80005d5c:	6161                	add	sp,sp,80
80005d5e:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

80005d60 <clock_update_core_clock>:

void clock_update_core_clock(void)
{
80005d60:	1101                	add	sp,sp,-32
80005d62:	ce06                	sw	ra,28(sp)

80005d64 <.LBB14>:
    uint32_t hart_id = read_csr(CSR_MHARTID);
80005d64:	f14027f3          	csrr	a5,mhartid
80005d68:	c63e                	sw	a5,12(sp)
80005d6a:	47b2                	lw	a5,12(sp)

80005d6c <.LBE14>:
80005d6c:	c43e                	sw	a5,8(sp)
    clock_name_t cpu_clk_name = (hart_id == 1U) ? clock_cpu1 : clock_cpu0;
80005d6e:	4722                	lw	a4,8(sp)
80005d70:	4785                	li	a5,1
80005d72:	00f71663          	bne	a4,a5,80005d7e <.L183>
80005d76:	000807b7          	lui	a5,0x80
80005d7a:	0789                	add	a5,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
80005d7c:	a011                	j	80005d80 <.L184>

80005d7e <.L183>:
80005d7e:	4781                	li	a5,0

80005d80 <.L184>:
80005d80:	c23e                	sw	a5,4(sp)
    hpm_core_clock = clock_get_frequency(cpu_clk_name);
80005d82:	4512                	lw	a0,4(sp)
80005d84:	7c1010ef          	jal	80007d44 <clock_get_frequency>
80005d88:	872a                	mv	a4,a0
80005d8a:	012007b7          	lui	a5,0x1200
80005d8e:	02e7a823          	sw	a4,48(a5) # 1200030 <hpm_core_clock>
}
80005d92:	0001                	nop
80005d94:	40f2                	lw	ra,28(sp)
80005d96:	6105                	add	sp,sp,32
80005d98:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

80005d9a <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
80005d9a:	1141                	add	sp,sp,-16
80005d9c:	c62a                	sw	a0,12(sp)
80005d9e:	87ae                	mv	a5,a1
80005da0:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
80005da4:	00a15783          	lhu	a5,10(sp)
80005da8:	4732                	lw	a4,12(sp)
80005daa:	078a                	sll	a5,a5,0x2
80005dac:	97ba                	add	a5,a5,a4
80005dae:	4398                	lw	a4,0(a5)
80005db0:	400007b7          	lui	a5,0x40000
80005db4:	8ff9                	and	a5,a5,a4
80005db6:	00f037b3          	snez	a5,a5
80005dba:	0ff7f793          	zext.b	a5,a5
}
80005dbe:	853e                	mv	a0,a5
80005dc0:	0141                	add	sp,sp,16
80005dc2:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

80005dc4 <sysctl_config_clock>:
    }
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node_index, clock_source_t source, uint32_t divide_by)
{
80005dc4:	7179                	add	sp,sp,-48
80005dc6:	d606                	sw	ra,44(sp)
80005dc8:	c62a                	sw	a0,12(sp)
80005dca:	87ae                	mv	a5,a1
80005dcc:	8732                	mv	a4,a2
80005dce:	c236                	sw	a3,4(sp)
80005dd0:	00f105a3          	sb	a5,11(sp)
80005dd4:	87ba                	mv	a5,a4
80005dd6:	00f10523          	sb	a5,10(sp)
    uint32_t node = (uint32_t) node_index;
80005dda:	00b14783          	lbu	a5,11(sp)
80005dde:	ce3e                	sw	a5,28(sp)
    if (node >= clock_node_adc_start) {
80005de0:	4772                	lw	a4,28(sp)
80005de2:	04800793          	li	a5,72
80005de6:	00e7f463          	bgeu	a5,a4,80005dee <.L103>
        return status_invalid_argument;
80005dea:	4789                	li	a5,2
80005dec:	a095                	j	80005e50 <.L104>

80005dee <.L103>:
    }

    if (source >= clock_source_general_source_end) {
80005dee:	00a14703          	lbu	a4,10(sp)
80005df2:	479d                	li	a5,7
80005df4:	00e7f463          	bgeu	a5,a4,80005dfc <.L105>
        return status_invalid_argument;
80005df8:	4789                	li	a5,2
80005dfa:	a899                	j	80005e50 <.L104>

80005dfc <.L105>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80005dfc:	4732                	lw	a4,12(sp)
80005dfe:	47f2                	lw	a5,28(sp)
80005e00:	60078793          	add	a5,a5,1536 # 40000600 <_extram_size+0x3e000600>
80005e04:	078a                	sll	a5,a5,0x2
80005e06:	97ba                	add	a5,a5,a4
80005e08:	439c                	lw	a5,0(a5)
80005e0a:	8007f713          	and	a4,a5,-2048
        (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80005e0e:	00a14783          	lbu	a5,10(sp)
80005e12:	07a2                	sll	a5,a5,0x8
80005e14:	7007f693          	and	a3,a5,1792
80005e18:	4792                	lw	a5,4(sp)
80005e1a:	17fd                	add	a5,a5,-1
80005e1c:	0ff7f793          	zext.b	a5,a5
80005e20:	8fd5                	or	a5,a5,a3
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80005e22:	8f5d                	or	a4,a4,a5
80005e24:	46b2                	lw	a3,12(sp)
80005e26:	47f2                	lw	a5,28(sp)
80005e28:	60078793          	add	a5,a5,1536
80005e2c:	078a                	sll	a5,a5,0x2
80005e2e:	97b6                	add	a5,a5,a3
80005e30:	c398                	sw	a4,0(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
80005e32:	0001                	nop

80005e34 <.L106>:
80005e34:	45f2                	lw	a1,28(sp)
80005e36:	4532                	lw	a0,12(sp)
80005e38:	212020ef          	jal	8000804a <sysctl_clock_target_is_busy>
80005e3c:	87aa                	mv	a5,a0
80005e3e:	fbfd                	bnez	a5,80005e34 <.L106>
    }
    if ((node == clock_node_cpu0) || (node == clock_node_cpu1)) {
80005e40:	47f2                	lw	a5,28(sp)
80005e42:	c789                	beqz	a5,80005e4c <.L107>
80005e44:	4772                	lw	a4,28(sp)
80005e46:	4789                	li	a5,2
80005e48:	00f71363          	bne	a4,a5,80005e4e <.L108>

80005e4c <.L107>:
        clock_update_core_clock();
80005e4c:	3f11                	jal	80005d60 <clock_update_core_clock>

80005e4e <.L108>:
    }
    return status_success;
80005e4e:	4781                	li	a5,0

80005e50 <.L104>:
}
80005e50:	853e                	mv	a0,a5
80005e52:	50b2                	lw	ra,44(sp)
80005e54:	6145                	add	sp,sp,48
80005e56:	8082                	ret

Disassembly of section .text.system_init:

80005e58 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80005e58:	7179                	add	sp,sp,-48
80005e5a:	d606                	sw	ra,44(sp)

80005e5c <.LBB16>:
#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
80005e5c:	306027f3          	csrr	a5,mcounteren
80005e60:	ce3e                	sw	a5,28(sp)
80005e62:	47f2                	lw	a5,28(sp)

80005e64 <.LBE16>:
80005e64:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80005e66:	47e2                	lw	a5,24(sp)
80005e68:	0017e793          	or	a5,a5,1
80005e6c:	30679073          	csrw	mcounteren,a5
80005e70:	47a1                	li	a5,8
80005e72:	c83e                	sw	a5,16(sp)

80005e74 <.LBB17>:
 * @param[in] mask interrupt mask to be disabled
 * @retval current mstatus value before irq mask is disabled
 */
ATTR_ALWAYS_INLINE static inline uint32_t disable_global_irq(uint32_t mask)
{
    return read_clear_csr(CSR_MSTATUS, mask);
80005e74:	c602                	sw	zero,12(sp)
80005e76:	47c2                	lw	a5,16(sp)
80005e78:	3007b7f3          	csrrc	a5,mstatus,a5
80005e7c:	c63e                	sw	a5,12(sp)
80005e7e:	47b2                	lw	a5,12(sp)

80005e80 <.LBE19>:
80005e80:	0001                	nop

80005e82 <.LBB20>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80005e82:	28b01793          	bset	a5,zero,0xb
80005e86:	3047b073          	csrc	mie,a5
}
80005e8a:	0001                	nop

80005e8c <.LBE20>:
    disable_irq_from_intc();
#ifdef USE_S_MODE_IRQ
    disable_s_irq_from_intc();
#endif

    enable_plic_feature();
80005e8c:	30e020ef          	jal	8000819a <enable_plic_feature>

80005e90 <.LBB22>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80005e90:	28b01793          	bset	a5,zero,0xb
80005e94:	3047a073          	csrs	mie,a5
}
80005e98:	0001                	nop
80005e9a:	47a1                	li	a5,8
80005e9c:	ca3e                	sw	a5,20(sp)

80005e9e <.LBB24>:
    set_csr(CSR_MSTATUS, mask);
80005e9e:	47d2                	lw	a5,20(sp)
80005ea0:	3007a073          	csrs	mstatus,a5
}
80005ea4:	0001                	nop

80005ea6 <.LBE24>:
#endif

#if defined(CONFIG_ENABLE_BPOR_RETENTION) && CONFIG_ENABLE_BPOR_RETENTION
    bpor_enable_reg_value_retention(HPM_BPOR);
#endif
}
80005ea6:	0001                	nop
80005ea8:	50b2                	lw	ra,44(sp)
80005eaa:	6145                	add	sp,sp,48
80005eac:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80005eae <__SEGGER_RTL_xltoa>:
80005eae:	882a                	mv	a6,a0
80005eb0:	88ae                	mv	a7,a1
80005eb2:	852e                	mv	a0,a1
80005eb4:	ca89                	beqz	a3,80005ec6 <.L2>
80005eb6:	02d00793          	li	a5,45
80005eba:	00158893          	add	a7,a1,1 # 40000001 <_extram_size+0x3e000001>
80005ebe:	00f58023          	sb	a5,0(a1)
80005ec2:	41000833          	neg	a6,a6

80005ec6 <.L2>:
80005ec6:	8746                	mv	a4,a7
80005ec8:	4325                	li	t1,9

80005eca <.L5>:
80005eca:	02c876b3          	remu	a3,a6,a2
80005ece:	85c2                	mv	a1,a6
80005ed0:	0ff6f793          	zext.b	a5,a3
80005ed4:	02c85833          	divu	a6,a6,a2
80005ed8:	02d37d63          	bgeu	t1,a3,80005f12 <.L3>
80005edc:	05778793          	add	a5,a5,87

80005ee0 <.L11>:
80005ee0:	0ff7f793          	zext.b	a5,a5
80005ee4:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3df8000>
80005ee8:	00170693          	add	a3,a4,1
80005eec:	02c5f163          	bgeu	a1,a2,80005f0e <.L8>
80005ef0:	000700a3          	sb	zero,1(a4)

80005ef4 <.L6>:
80005ef4:	0008c683          	lbu	a3,0(a7)
80005ef8:	00074783          	lbu	a5,0(a4)
80005efc:	0885                	add	a7,a7,1
80005efe:	177d                	add	a4,a4,-1
80005f00:	00d700a3          	sb	a3,1(a4)
80005f04:	fef88fa3          	sb	a5,-1(a7)
80005f08:	fee8e6e3          	bltu	a7,a4,80005ef4 <.L6>
80005f0c:	8082                	ret

80005f0e <.L8>:
80005f0e:	8736                	mv	a4,a3
80005f10:	bf6d                	j	80005eca <.L5>

80005f12 <.L3>:
80005f12:	03078793          	add	a5,a5,48
80005f16:	b7e9                	j	80005ee0 <.L11>

Disassembly of section .text.libc.itoa:

80005f18 <itoa>:
80005f18:	46a9                	li	a3,10
80005f1a:	87aa                	mv	a5,a0
80005f1c:	882e                	mv	a6,a1
80005f1e:	8732                	mv	a4,a2
80005f20:	00d61563          	bne	a2,a3,80005f2a <.L301>
80005f24:	4685                	li	a3,1
80005f26:	00054663          	bltz	a0,80005f32 <.L302>

80005f2a <.L301>:
80005f2a:	4681                	li	a3,0
80005f2c:	863a                	mv	a2,a4
80005f2e:	85c2                	mv	a1,a6
80005f30:	853e                	mv	a0,a5

80005f32 <.L302>:
80005f32:	bfb5                	j	80005eae <__SEGGER_RTL_xltoa>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

80005f34 <__SEGGER_RTL_SIGNAL_SIG_ERR>:
80005f34:	8082                	ret

Disassembly of section .text.libc.fwrite:

80005f36 <fwrite>:
80005f36:	1101                	add	sp,sp,-32
80005f38:	c64e                	sw	s3,12(sp)
80005f3a:	89aa                	mv	s3,a0
80005f3c:	8536                	mv	a0,a3
80005f3e:	cc22                	sw	s0,24(sp)
80005f40:	ca26                	sw	s1,20(sp)
80005f42:	c84a                	sw	s2,16(sp)
80005f44:	ce06                	sw	ra,28(sp)
80005f46:	84ae                	mv	s1,a1
80005f48:	8432                	mv	s0,a2
80005f4a:	8936                	mv	s2,a3
80005f4c:	40a010ef          	jal	80007356 <__SEGGER_RTL_X_file_stat>
80005f50:	02054463          	bltz	a0,80005f78 <.L43>
80005f54:	02848633          	mul	a2,s1,s0
80005f58:	4501                	li	a0,0
80005f5a:	00966863          	bltu	a2,s1,80005f6a <.L41>
80005f5e:	85ce                	mv	a1,s3
80005f60:	854a                	mv	a0,s2
80005f62:	374010ef          	jal	800072d6 <__SEGGER_RTL_X_file_write>
80005f66:	02955533          	divu	a0,a0,s1

80005f6a <.L41>:
80005f6a:	40f2                	lw	ra,28(sp)
80005f6c:	4462                	lw	s0,24(sp)
80005f6e:	44d2                	lw	s1,20(sp)
80005f70:	4942                	lw	s2,16(sp)
80005f72:	49b2                	lw	s3,12(sp)
80005f74:	6105                	add	sp,sp,32
80005f76:	8082                	ret

80005f78 <.L43>:
80005f78:	4501                	li	a0,0
80005f7a:	bfc5                	j	80005f6a <.L41>

Disassembly of section .text.libc.__subsf3:

80005f7c <__subsf3>:
80005f7c:	80000637          	lui	a2,0x80000
80005f80:	8db1                	xor	a1,a1,a2
80005f82:	a009                	j	80005f84 <__addsf3>

Disassembly of section .text.libc.__addsf3:

80005f84 <__addsf3>:
80005f84:	80000637          	lui	a2,0x80000
80005f88:	00b546b3          	xor	a3,a0,a1
80005f8c:	0806ca63          	bltz	a3,80006020 <.L__addsf3_subtract>
80005f90:	00b57563          	bgeu	a0,a1,80005f9a <.L__addsf3_add_already_ordered>
80005f94:	86aa                	mv	a3,a0
80005f96:	852e                	mv	a0,a1
80005f98:	85b6                	mv	a1,a3

80005f9a <.L__addsf3_add_already_ordered>:
80005f9a:	00151713          	sll	a4,a0,0x1
80005f9e:	8361                	srl	a4,a4,0x18
80005fa0:	00159693          	sll	a3,a1,0x1
80005fa4:	82e1                	srl	a3,a3,0x18
80005fa6:	0ff00293          	li	t0,255
80005faa:	06570563          	beq	a4,t0,80006014 <.L__addsf3_add_inf_or_nan>
80005fae:	c325                	beqz	a4,8000600e <.L__addsf3_zero>
80005fb0:	ceb1                	beqz	a3,8000600c <.L__addsf3_add_done>
80005fb2:	40d706b3          	sub	a3,a4,a3
80005fb6:	42e1                	li	t0,24
80005fb8:	04d2ca63          	blt	t0,a3,8000600c <.L__addsf3_add_done>
80005fbc:	05a2                	sll	a1,a1,0x8
80005fbe:	8dd1                	or	a1,a1,a2
80005fc0:	01755713          	srl	a4,a0,0x17
80005fc4:	0522                	sll	a0,a0,0x8
80005fc6:	8d51                	or	a0,a0,a2
80005fc8:	47e5                	li	a5,25
80005fca:	8f95                	sub	a5,a5,a3
80005fcc:	00f59633          	sll	a2,a1,a5
80005fd0:	821d                	srl	a2,a2,0x7
80005fd2:	00d5d5b3          	srl	a1,a1,a3
80005fd6:	00b507b3          	add	a5,a0,a1
80005fda:	00a7f463          	bgeu	a5,a0,80005fe2 <.L__addsf3_add_no_normalization>
80005fde:	8385                	srl	a5,a5,0x1
80005fe0:	0709                	add	a4,a4,2

80005fe2 <.L__addsf3_add_no_normalization>:
80005fe2:	177d                	add	a4,a4,-1
80005fe4:	0ff77593          	zext.b	a1,a4
80005fe8:	f0158593          	add	a1,a1,-255
80005fec:	cd91                	beqz	a1,80006008 <.L__addsf3_inf>
80005fee:	075e                	sll	a4,a4,0x17
80005ff0:	0087d513          	srl	a0,a5,0x8
80005ff4:	07e2                	sll	a5,a5,0x18
80005ff6:	8fd1                	or	a5,a5,a2
80005ff8:	0007d663          	bgez	a5,80006004 <.L__addsf3_no_tie>
80005ffc:	0786                	sll	a5,a5,0x1
80005ffe:	0505                	add	a0,a0,1 # f4000001 <__AHB_SRAM_segment_end__+0x3df8001>
80006000:	e391                	bnez	a5,80006004 <.L__addsf3_no_tie>
80006002:	9979                	and	a0,a0,-2

80006004 <.L__addsf3_no_tie>:
80006004:	953a                	add	a0,a0,a4
80006006:	8082                	ret

80006008 <.L__addsf3_inf>:
80006008:	01771513          	sll	a0,a4,0x17

8000600c <.L__addsf3_add_done>:
8000600c:	8082                	ret

8000600e <.L__addsf3_zero>:
8000600e:	817d                	srl	a0,a0,0x1f
80006010:	057e                	sll	a0,a0,0x1f
80006012:	8082                	ret

80006014 <.L__addsf3_add_inf_or_nan>:
80006014:	00951613          	sll	a2,a0,0x9
80006018:	da75                	beqz	a2,8000600c <.L__addsf3_add_done>

8000601a <.L__addsf3_return_nan>:
8000601a:	7fc00537          	lui	a0,0x7fc00
8000601e:	8082                	ret

80006020 <.L__addsf3_subtract>:
80006020:	8db1                	xor	a1,a1,a2
80006022:	40b506b3          	sub	a3,a0,a1
80006026:	00b57563          	bgeu	a0,a1,80006030 <.L__addsf3_sub_already_ordered>
8000602a:	8eb1                	xor	a3,a3,a2
8000602c:	8d15                	sub	a0,a0,a3
8000602e:	95b6                	add	a1,a1,a3

80006030 <.L__addsf3_sub_already_ordered>:
80006030:	00159693          	sll	a3,a1,0x1
80006034:	82e1                	srl	a3,a3,0x18
80006036:	00151713          	sll	a4,a0,0x1
8000603a:	8361                	srl	a4,a4,0x18
8000603c:	05a2                	sll	a1,a1,0x8
8000603e:	8dd1                	or	a1,a1,a2
80006040:	0ff00293          	li	t0,255
80006044:	0c570c63          	beq	a4,t0,8000611c <.L__addsf3_sub_inf_or_nan>
80006048:	c2f5                	beqz	a3,8000612c <.L__addsf3_sub_zero>
8000604a:	40d706b3          	sub	a3,a4,a3
8000604e:	c695                	beqz	a3,8000607a <.L__addsf3_exponents_equal>
80006050:	4285                	li	t0,1
80006052:	08569063          	bne	a3,t0,800060d2 <.L__addsf3_exponents_differ_by_more_than_1>
80006056:	01755693          	srl	a3,a0,0x17
8000605a:	0526                	sll	a0,a0,0x9
8000605c:	00b532b3          	sltu	t0,a0,a1
80006060:	8d0d                	sub	a0,a0,a1
80006062:	02029263          	bnez	t0,80006086 <.L__addsf3_normalization_steps>
80006066:	06de                	sll	a3,a3,0x17
80006068:	01751593          	sll	a1,a0,0x17
8000606c:	8125                	srl	a0,a0,0x9
8000606e:	0005d463          	bgez	a1,80006076 <.L__addsf3_sub_no_tie_single>
80006072:	0505                	add	a0,a0,1 # 7fc00001 <_extram_size+0x7dc00001>
80006074:	9979                	and	a0,a0,-2

80006076 <.L__addsf3_sub_no_tie_single>:
80006076:	9536                	add	a0,a0,a3

80006078 <.L__addsf3_sub_done>:
80006078:	8082                	ret

8000607a <.L__addsf3_exponents_equal>:
8000607a:	01755693          	srl	a3,a0,0x17
8000607e:	0526                	sll	a0,a0,0x9
80006080:	0586                	sll	a1,a1,0x1
80006082:	8d0d                	sub	a0,a0,a1
80006084:	d975                	beqz	a0,80006078 <.L__addsf3_sub_done>

80006086 <.L__addsf3_normalization_steps>:
80006086:	4581                	li	a1,0
80006088:	01055793          	srl	a5,a0,0x10
8000608c:	e399                	bnez	a5,80006092 <.L1^B1>
8000608e:	0542                	sll	a0,a0,0x10
80006090:	05c1                	add	a1,a1,16

80006092 <.L1^B1>:
80006092:	01855793          	srl	a5,a0,0x18
80006096:	e399                	bnez	a5,8000609c <.L2^B1>
80006098:	0522                	sll	a0,a0,0x8
8000609a:	05a1                	add	a1,a1,8

8000609c <.L2^B1>:
8000609c:	01c55793          	srl	a5,a0,0x1c
800060a0:	e399                	bnez	a5,800060a6 <.L3^B1>
800060a2:	0512                	sll	a0,a0,0x4
800060a4:	0591                	add	a1,a1,4

800060a6 <.L3^B1>:
800060a6:	01e55793          	srl	a5,a0,0x1e
800060aa:	e399                	bnez	a5,800060b0 <.L4^B1>
800060ac:	050a                	sll	a0,a0,0x2
800060ae:	0589                	add	a1,a1,2

800060b0 <.L4^B1>:
800060b0:	00054463          	bltz	a0,800060b8 <.L5^B1>
800060b4:	0506                	sll	a0,a0,0x1
800060b6:	0585                	add	a1,a1,1

800060b8 <.L5^B1>:
800060b8:	0585                	add	a1,a1,1
800060ba:	0506                	sll	a0,a0,0x1
800060bc:	00e5f763          	bgeu	a1,a4,800060ca <.L__addsf3_underflow>
800060c0:	8e8d                	sub	a3,a3,a1
800060c2:	06de                	sll	a3,a3,0x17
800060c4:	8125                	srl	a0,a0,0x9
800060c6:	9536                	add	a0,a0,a3
800060c8:	8082                	ret

800060ca <.L__addsf3_underflow>:
800060ca:	0086d513          	srl	a0,a3,0x8
800060ce:	057e                	sll	a0,a0,0x1f
800060d0:	8082                	ret

800060d2 <.L__addsf3_exponents_differ_by_more_than_1>:
800060d2:	42e5                	li	t0,25
800060d4:	fad2e2e3          	bltu	t0,a3,80006078 <.L__addsf3_sub_done>
800060d8:	0685                	add	a3,a3,1
800060da:	40d00733          	neg	a4,a3
800060de:	00e59733          	sll	a4,a1,a4
800060e2:	00d5d5b3          	srl	a1,a1,a3
800060e6:	00e03733          	snez	a4,a4
800060ea:	95ae                	add	a1,a1,a1
800060ec:	95ba                	add	a1,a1,a4
800060ee:	01755693          	srl	a3,a0,0x17
800060f2:	0522                	sll	a0,a0,0x8
800060f4:	8d51                	or	a0,a0,a2
800060f6:	40b50733          	sub	a4,a0,a1
800060fa:	00074463          	bltz	a4,80006102 <.L__addsf3_sub_already_normalized>
800060fe:	070a                	sll	a4,a4,0x2
80006100:	8305                	srl	a4,a4,0x1

80006102 <.L__addsf3_sub_already_normalized>:
80006102:	16fd                	add	a3,a3,-1
80006104:	06de                	sll	a3,a3,0x17
80006106:	00875513          	srl	a0,a4,0x8
8000610a:	0762                	sll	a4,a4,0x18
8000610c:	00075663          	bgez	a4,80006118 <.L__addsf3_sub_no_tie>
80006110:	0706                	sll	a4,a4,0x1
80006112:	0505                	add	a0,a0,1
80006114:	e311                	bnez	a4,80006118 <.L__addsf3_sub_no_tie>
80006116:	9979                	and	a0,a0,-2

80006118 <.L__addsf3_sub_no_tie>:
80006118:	9536                	add	a0,a0,a3
8000611a:	8082                	ret

8000611c <.L__addsf3_sub_inf_or_nan>:
8000611c:	0ff00293          	li	t0,255
80006120:	ee568de3          	beq	a3,t0,8000601a <.L__addsf3_return_nan>
80006124:	00951593          	sll	a1,a0,0x9
80006128:	d9a1                	beqz	a1,80006078 <.L__addsf3_sub_done>
8000612a:	bdc5                	j	8000601a <.L__addsf3_return_nan>

8000612c <.L__addsf3_sub_zero>:
8000612c:	f731                	bnez	a4,80006078 <.L__addsf3_sub_done>
8000612e:	4501                	li	a0,0
80006130:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

80006132 <__ltsf2>:
80006132:	ff000637          	lui	a2,0xff000
80006136:	00151693          	sll	a3,a0,0x1
8000613a:	02d66763          	bltu	a2,a3,80006168 <.L__ltsf2_zero>
8000613e:	00159693          	sll	a3,a1,0x1
80006142:	02d66363          	bltu	a2,a3,80006168 <.L__ltsf2_zero>
80006146:	00b56633          	or	a2,a0,a1
8000614a:	00161693          	sll	a3,a2,0x1
8000614e:	ce89                	beqz	a3,80006168 <.L__ltsf2_zero>
80006150:	00064763          	bltz	a2,8000615e <.L__ltsf2_negative>
80006154:	00b53533          	sltu	a0,a0,a1
80006158:	40a00533          	neg	a0,a0
8000615c:	8082                	ret

8000615e <.L__ltsf2_negative>:
8000615e:	00a5b533          	sltu	a0,a1,a0
80006162:	40a00533          	neg	a0,a0
80006166:	8082                	ret

80006168 <.L__ltsf2_zero>:
80006168:	4501                	li	a0,0
8000616a:	8082                	ret

Disassembly of section .text.libc.__lesf2:

8000616c <__lesf2>:
8000616c:	ff000637          	lui	a2,0xff000
80006170:	00151693          	sll	a3,a0,0x1
80006174:	02d66363          	bltu	a2,a3,8000619a <.L__lesf2_nan>
80006178:	00159693          	sll	a3,a1,0x1
8000617c:	00d66f63          	bltu	a2,a3,8000619a <.L__lesf2_nan>
80006180:	00b56633          	or	a2,a0,a1
80006184:	00161693          	sll	a3,a2,0x1
80006188:	ca99                	beqz	a3,8000619e <.L__lesf2_zero>
8000618a:	00064563          	bltz	a2,80006194 <.L__lesf2_negative>
8000618e:	00a5b533          	sltu	a0,a1,a0
80006192:	8082                	ret

80006194 <.L__lesf2_negative>:
80006194:	00b53533          	sltu	a0,a0,a1
80006198:	8082                	ret

8000619a <.L__lesf2_nan>:
8000619a:	4505                	li	a0,1
8000619c:	8082                	ret

8000619e <.L__lesf2_zero>:
8000619e:	4501                	li	a0,0
800061a0:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

800061a2 <__gtsf2>:
800061a2:	ff000637          	lui	a2,0xff000
800061a6:	00151693          	sll	a3,a0,0x1
800061aa:	02d66363          	bltu	a2,a3,800061d0 <.L__gtsf2_zero>
800061ae:	00159693          	sll	a3,a1,0x1
800061b2:	00d66f63          	bltu	a2,a3,800061d0 <.L__gtsf2_zero>
800061b6:	00b56633          	or	a2,a0,a1
800061ba:	00161693          	sll	a3,a2,0x1
800061be:	ca89                	beqz	a3,800061d0 <.L__gtsf2_zero>
800061c0:	00064563          	bltz	a2,800061ca <.L__gtsf2_negative>
800061c4:	00a5b533          	sltu	a0,a1,a0
800061c8:	8082                	ret

800061ca <.L__gtsf2_negative>:
800061ca:	00b53533          	sltu	a0,a0,a1
800061ce:	8082                	ret

800061d0 <.L__gtsf2_zero>:
800061d0:	4501                	li	a0,0
800061d2:	8082                	ret

Disassembly of section .text.libc.__gesf2:

800061d4 <__gesf2>:
800061d4:	ff000637          	lui	a2,0xff000
800061d8:	00151693          	sll	a3,a0,0x1
800061dc:	02d66763          	bltu	a2,a3,8000620a <.L__gesf2_nan>
800061e0:	00159693          	sll	a3,a1,0x1
800061e4:	02d66363          	bltu	a2,a3,8000620a <.L__gesf2_nan>
800061e8:	00b56633          	or	a2,a0,a1
800061ec:	00161693          	sll	a3,a2,0x1
800061f0:	ce99                	beqz	a3,8000620e <.L__gesf2_zero>
800061f2:	00064763          	bltz	a2,80006200 <.L__gesf2_negative>
800061f6:	00b53533          	sltu	a0,a0,a1
800061fa:	40a00533          	neg	a0,a0
800061fe:	8082                	ret

80006200 <.L__gesf2_negative>:
80006200:	00a5b533          	sltu	a0,a1,a0
80006204:	40a00533          	neg	a0,a0
80006208:	8082                	ret

8000620a <.L__gesf2_nan>:
8000620a:	557d                	li	a0,-1
8000620c:	8082                	ret

8000620e <.L__gesf2_zero>:
8000620e:	4501                	li	a0,0
80006210:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

80006212 <__floatundisf>:
80006212:	c5bd                	beqz	a1,80006280 <.L__floatundisf_high_word_zero>
80006214:	4701                	li	a4,0
80006216:	0105d693          	srl	a3,a1,0x10
8000621a:	e299                	bnez	a3,80006220 <.L8^B3>
8000621c:	0741                	add	a4,a4,16
8000621e:	05c2                	sll	a1,a1,0x10

80006220 <.L8^B3>:
80006220:	0185d693          	srl	a3,a1,0x18
80006224:	e299                	bnez	a3,8000622a <.L4^B10>
80006226:	0721                	add	a4,a4,8
80006228:	05a2                	sll	a1,a1,0x8

8000622a <.L4^B10>:
8000622a:	01c5d693          	srl	a3,a1,0x1c
8000622e:	e299                	bnez	a3,80006234 <.L2^B10>
80006230:	0711                	add	a4,a4,4
80006232:	0592                	sll	a1,a1,0x4

80006234 <.L2^B10>:
80006234:	01e5d693          	srl	a3,a1,0x1e
80006238:	e299                	bnez	a3,8000623e <.L1^B10>
8000623a:	0709                	add	a4,a4,2
8000623c:	058a                	sll	a1,a1,0x2

8000623e <.L1^B10>:
8000623e:	0005c463          	bltz	a1,80006246 <.L0^B3>
80006242:	0705                	add	a4,a4,1
80006244:	0586                	sll	a1,a1,0x1

80006246 <.L0^B3>:
80006246:	fff74613          	not	a2,a4
8000624a:	00c556b3          	srl	a3,a0,a2
8000624e:	8285                	srl	a3,a3,0x1
80006250:	8dd5                	or	a1,a1,a3
80006252:	00e51533          	sll	a0,a0,a4
80006256:	0be60613          	add	a2,a2,190 # ff0000be <__AHB_SRAM_segment_end__+0xedf80be>
8000625a:	00a03533          	snez	a0,a0
8000625e:	8dc9                	or	a1,a1,a0

80006260 <.L__floatundisf_round_and_pack>:
80006260:	065e                	sll	a2,a2,0x17
80006262:	0085d513          	srl	a0,a1,0x8
80006266:	05de                	sll	a1,a1,0x17
80006268:	0005a333          	sltz	t1,a1
8000626c:	95ae                	add	a1,a1,a1
8000626e:	959a                	add	a1,a1,t1
80006270:	0005d663          	bgez	a1,8000627c <.L__floatundisf_round_down>
80006274:	95ae                	add	a1,a1,a1
80006276:	00b035b3          	snez	a1,a1
8000627a:	952e                	add	a0,a0,a1

8000627c <.L__floatundisf_round_down>:
8000627c:	9532                	add	a0,a0,a2

8000627e <.L__floatundisf_done>:
8000627e:	8082                	ret

80006280 <.L__floatundisf_high_word_zero>:
80006280:	dd7d                	beqz	a0,8000627e <.L__floatundisf_done>
80006282:	09d00613          	li	a2,157
80006286:	01055693          	srl	a3,a0,0x10
8000628a:	e299                	bnez	a3,80006290 <.L1^B11>
8000628c:	0542                	sll	a0,a0,0x10
8000628e:	1641                	add	a2,a2,-16

80006290 <.L1^B11>:
80006290:	01855693          	srl	a3,a0,0x18
80006294:	e299                	bnez	a3,8000629a <.L2^B11>
80006296:	0522                	sll	a0,a0,0x8
80006298:	1661                	add	a2,a2,-8

8000629a <.L2^B11>:
8000629a:	01c55693          	srl	a3,a0,0x1c
8000629e:	e299                	bnez	a3,800062a4 <.L3^B8>
800062a0:	0512                	sll	a0,a0,0x4
800062a2:	1671                	add	a2,a2,-4

800062a4 <.L3^B8>:
800062a4:	01e55693          	srl	a3,a0,0x1e
800062a8:	e299                	bnez	a3,800062ae <.L4^B11>
800062aa:	050a                	sll	a0,a0,0x2
800062ac:	1679                	add	a2,a2,-2

800062ae <.L4^B11>:
800062ae:	00054463          	bltz	a0,800062b6 <.L5^B8>
800062b2:	0506                	sll	a0,a0,0x1
800062b4:	167d                	add	a2,a2,-1

800062b6 <.L5^B8>:
800062b6:	85aa                	mv	a1,a0
800062b8:	4501                	li	a0,0
800062ba:	b75d                	j	80006260 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

800062bc <__truncdfsf2>:
800062bc:	00159693          	sll	a3,a1,0x1
800062c0:	82d5                	srl	a3,a3,0x15
800062c2:	7ff00613          	li	a2,2047
800062c6:	04c68663          	beq	a3,a2,80006312 <.L__truncdfsf2_inf_nan>
800062ca:	c8068693          	add	a3,a3,-896
800062ce:	02d05e63          	blez	a3,8000630a <.L__truncdfsf2_underflow>
800062d2:	0ff00613          	li	a2,255
800062d6:	04c6f263          	bgeu	a3,a2,8000631a <.L__truncdfsf2_inf>
800062da:	06de                	sll	a3,a3,0x17
800062dc:	01f5d613          	srl	a2,a1,0x1f
800062e0:	067e                	sll	a2,a2,0x1f
800062e2:	8ed1                	or	a3,a3,a2
800062e4:	05b2                	sll	a1,a1,0xc
800062e6:	01455613          	srl	a2,a0,0x14
800062ea:	8dd1                	or	a1,a1,a2
800062ec:	81a5                	srl	a1,a1,0x9
800062ee:	00251613          	sll	a2,a0,0x2
800062f2:	00062733          	sltz	a4,a2
800062f6:	9632                	add	a2,a2,a2
800062f8:	000627b3          	sltz	a5,a2
800062fc:	9632                	add	a2,a2,a2
800062fe:	963a                	add	a2,a2,a4
80006300:	c211                	beqz	a2,80006304 <.L__truncdfsf2_no_round_tie>
80006302:	95be                	add	a1,a1,a5

80006304 <.L__truncdfsf2_no_round_tie>:
80006304:	00d58533          	add	a0,a1,a3
80006308:	8082                	ret

8000630a <.L__truncdfsf2_underflow>:
8000630a:	01f5d513          	srl	a0,a1,0x1f
8000630e:	057e                	sll	a0,a0,0x1f
80006310:	8082                	ret

80006312 <.L__truncdfsf2_inf_nan>:
80006312:	00c59693          	sll	a3,a1,0xc
80006316:	8ec9                	or	a3,a3,a0
80006318:	ea81                	bnez	a3,80006328 <.L__truncdfsf2_nan>

8000631a <.L__truncdfsf2_inf>:
8000631a:	81fd                	srl	a1,a1,0x1f
8000631c:	05fe                	sll	a1,a1,0x1f
8000631e:	7f800537          	lui	a0,0x7f800
80006322:	8d4d                	or	a0,a0,a1
80006324:	4581                	li	a1,0
80006326:	8082                	ret

80006328 <.L__truncdfsf2_nan>:
80006328:	800006b7          	lui	a3,0x80000
8000632c:	00d5f633          	and	a2,a1,a3
80006330:	058e                	sll	a1,a1,0x3
80006332:	8175                	srl	a0,a0,0x1d
80006334:	8d4d                	or	a0,a0,a1
80006336:	0506                	sll	a0,a0,0x1
80006338:	8105                	srl	a0,a0,0x1
8000633a:	8d51                	or	a0,a0,a2
8000633c:	82a5                	srl	a3,a3,0x9
8000633e:	8d55                	or	a0,a0,a3
80006340:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

80006342 <__SEGGER_RTL_ldouble_to_double>:
80006342:	4158                	lw	a4,4(a0)
80006344:	451c                	lw	a5,8(a0)
80006346:	4554                	lw	a3,12(a0)
80006348:	1141                	add	sp,sp,-16
8000634a:	c23a                	sw	a4,4(sp)
8000634c:	c43e                	sw	a5,8(sp)
8000634e:	7771                	lui	a4,0xffffc
80006350:	00169793          	sll	a5,a3,0x1
80006354:	83c5                	srl	a5,a5,0x11
80006356:	40070713          	add	a4,a4,1024 # ffffc400 <__AHB_SRAM_segment_end__+0xfdf4400>
8000635a:	c636                	sw	a3,12(sp)
8000635c:	97ba                	add	a5,a5,a4
8000635e:	00f04a63          	bgtz	a5,80006372 <.L27>
80006362:	800007b7          	lui	a5,0x80000
80006366:	4701                	li	a4,0
80006368:	8ff5                	and	a5,a5,a3

8000636a <.L28>:
8000636a:	853a                	mv	a0,a4
8000636c:	85be                	mv	a1,a5
8000636e:	0141                	add	sp,sp,16
80006370:	8082                	ret

80006372 <.L27>:
80006372:	6711                	lui	a4,0x4
80006374:	3ff70713          	add	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
80006378:	00e78c63          	beq	a5,a4,80006390 <.L29>
8000637c:	7ff00713          	li	a4,2047
80006380:	00f75a63          	bge	a4,a5,80006394 <.L30>
80006384:	4781                	li	a5,0
80006386:	4801                	li	a6,0
80006388:	c43e                	sw	a5,8(sp)
8000638a:	c642                	sw	a6,12(sp)
8000638c:	c03e                	sw	a5,0(sp)
8000638e:	c242                	sw	a6,4(sp)

80006390 <.L29>:
80006390:	7ff00793          	li	a5,2047

80006394 <.L30>:
80006394:	45a2                	lw	a1,8(sp)
80006396:	4732                	lw	a4,12(sp)
80006398:	80000637          	lui	a2,0x80000
8000639c:	01c5d513          	srl	a0,a1,0x1c
800063a0:	8e79                	and	a2,a2,a4
800063a2:	0712                	sll	a4,a4,0x4
800063a4:	4692                	lw	a3,4(sp)
800063a6:	8f49                	or	a4,a4,a0
800063a8:	0732                	sll	a4,a4,0xc
800063aa:	8331                	srl	a4,a4,0xc
800063ac:	8e59                	or	a2,a2,a4
800063ae:	82f1                	srl	a3,a3,0x1c
800063b0:	0592                	sll	a1,a1,0x4
800063b2:	07d2                	sll	a5,a5,0x14
800063b4:	00b6e733          	or	a4,a3,a1
800063b8:	8fd1                	or	a5,a5,a2
800063ba:	bf45                	j	8000636a <.L28>

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

800063bc <__SEGGER_RTL_float32_isnan>:
800063bc:	ff0007b7          	lui	a5,0xff000
800063c0:	0785                	add	a5,a5,1 # ff000001 <__AHB_SRAM_segment_end__+0xedf8001>
800063c2:	0506                	sll	a0,a0,0x1
800063c4:	00f53533          	sltu	a0,a0,a5
800063c8:	00154513          	xor	a0,a0,1
800063cc:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

800063ce <__SEGGER_RTL_float32_isinf>:
800063ce:	010007b7          	lui	a5,0x1000
800063d2:	0506                	sll	a0,a0,0x1
800063d4:	953e                	add	a0,a0,a5
800063d6:	00153513          	seqz	a0,a0
800063da:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

800063dc <__SEGGER_RTL_float32_isnormal>:
800063dc:	ff0007b7          	lui	a5,0xff000
800063e0:	0506                	sll	a0,a0,0x1
800063e2:	953e                	add	a0,a0,a5
800063e4:	fe0007b7          	lui	a5,0xfe000
800063e8:	00f53533          	sltu	a0,a0,a5
800063ec:	8082                	ret

Disassembly of section .text.libc.floorf:

800063ee <floorf>:
800063ee:	00151693          	sll	a3,a0,0x1
800063f2:	82e1                	srl	a3,a3,0x18
800063f4:	01755793          	srl	a5,a0,0x17
800063f8:	16fd                	add	a3,a3,-1 # 7fffffff <_extram_size+0x7dffffff>
800063fa:	0fd00613          	li	a2,253
800063fe:	872a                	mv	a4,a0
80006400:	0ff7f793          	zext.b	a5,a5
80006404:	00d67963          	bgeu	a2,a3,80006416 <.L1240>
80006408:	e789                	bnez	a5,80006412 <.L1241>
8000640a:	800007b7          	lui	a5,0x80000
8000640e:	00f57733          	and	a4,a0,a5

80006412 <.L1241>:
80006412:	853a                	mv	a0,a4
80006414:	8082                	ret

80006416 <.L1240>:
80006416:	f8178793          	add	a5,a5,-127 # 7fffff81 <_extram_size+0x7dffff81>
8000641a:	0007d963          	bgez	a5,8000642c <.L1243>
8000641e:	00000513          	li	a0,0
80006422:	02075863          	bgez	a4,80006452 <.L1242>
80006426:	49c1a503          	lw	a0,1180(gp) # 80003d2c <.Lmerged_single+0x18>
8000642a:	8082                	ret

8000642c <.L1243>:
8000642c:	46d9                	li	a3,22
8000642e:	02f6c263          	blt	a3,a5,80006452 <.L1242>
80006432:	008006b7          	lui	a3,0x800
80006436:	fff68613          	add	a2,a3,-1 # 7fffff <__DLM_segment_end__+0x5bffff>
8000643a:	00f65633          	srl	a2,a2,a5
8000643e:	fff64513          	not	a0,a2
80006442:	8d79                	and	a0,a0,a4
80006444:	8f71                	and	a4,a4,a2
80006446:	c711                	beqz	a4,80006452 <.L1242>
80006448:	00055563          	bgez	a0,80006452 <.L1242>
8000644c:	00f6d6b3          	srl	a3,a3,a5
80006450:	9536                	add	a0,a0,a3

80006452 <.L1242>:
80006452:	8082                	ret

Disassembly of section .text.libc.__ashldi3:

80006454 <__ashldi3>:
80006454:	02067793          	and	a5,a2,32
80006458:	ef89                	bnez	a5,80006472 <.L__ashldi3LongShift>
8000645a:	00155793          	srl	a5,a0,0x1
8000645e:	fff64713          	not	a4,a2
80006462:	00e7d7b3          	srl	a5,a5,a4
80006466:	00c595b3          	sll	a1,a1,a2
8000646a:	8ddd                	or	a1,a1,a5
8000646c:	00c51533          	sll	a0,a0,a2
80006470:	8082                	ret

80006472 <.L__ashldi3LongShift>:
80006472:	00c515b3          	sll	a1,a0,a2
80006476:	4501                	li	a0,0
80006478:	8082                	ret

Disassembly of section .text.libc.__udivdi3:

8000647a <__udivdi3>:
8000647a:	1101                	add	sp,sp,-32
8000647c:	cc22                	sw	s0,24(sp)
8000647e:	ca26                	sw	s1,20(sp)
80006480:	c84a                	sw	s2,16(sp)
80006482:	c64e                	sw	s3,12(sp)
80006484:	ce06                	sw	ra,28(sp)
80006486:	c452                	sw	s4,8(sp)
80006488:	c256                	sw	s5,4(sp)
8000648a:	c05a                	sw	s6,0(sp)
8000648c:	842a                	mv	s0,a0
8000648e:	892e                	mv	s2,a1
80006490:	89b2                	mv	s3,a2
80006492:	84b6                	mv	s1,a3
80006494:	2e069063          	bnez	a3,80006774 <.L47>
80006498:	ed99                	bnez	a1,800064b6 <.L48>
8000649a:	02c55433          	divu	s0,a0,a2

8000649e <.L49>:
8000649e:	40f2                	lw	ra,28(sp)
800064a0:	8522                	mv	a0,s0
800064a2:	4462                	lw	s0,24(sp)
800064a4:	44d2                	lw	s1,20(sp)
800064a6:	49b2                	lw	s3,12(sp)
800064a8:	4a22                	lw	s4,8(sp)
800064aa:	4a92                	lw	s5,4(sp)
800064ac:	4b02                	lw	s6,0(sp)
800064ae:	85ca                	mv	a1,s2
800064b0:	4942                	lw	s2,16(sp)
800064b2:	6105                	add	sp,sp,32
800064b4:	8082                	ret

800064b6 <.L48>:
800064b6:	010007b7          	lui	a5,0x1000
800064ba:	12f67863          	bgeu	a2,a5,800065ea <.L50>
800064be:	4791                	li	a5,4
800064c0:	08c7e763          	bltu	a5,a2,8000654e <.L52>
800064c4:	470d                	li	a4,3
800064c6:	02e60263          	beq	a2,a4,800064ea <.L54>
800064ca:	06f60a63          	beq	a2,a5,8000653e <.L55>
800064ce:	4785                	li	a5,1
800064d0:	fcf607e3          	beq	a2,a5,8000649e <.L49>
800064d4:	4789                	li	a5,2
800064d6:	3af61c63          	bne	a2,a5,8000688e <.L88>
800064da:	01f59793          	sll	a5,a1,0x1f
800064de:	00155413          	srl	s0,a0,0x1
800064e2:	8c5d                	or	s0,s0,a5
800064e4:	0015d913          	srl	s2,a1,0x1
800064e8:	bf5d                	j	8000649e <.L49>

800064ea <.L54>:
800064ea:	555557b7          	lui	a5,0x55555
800064ee:	55578793          	add	a5,a5,1365 # 55555555 <_extram_size+0x53555555>
800064f2:	02b7b6b3          	mulhu	a3,a5,a1
800064f6:	02a7b633          	mulhu	a2,a5,a0
800064fa:	02a78733          	mul	a4,a5,a0
800064fe:	02b787b3          	mul	a5,a5,a1
80006502:	97b2                	add	a5,a5,a2
80006504:	00c7b633          	sltu	a2,a5,a2
80006508:	9636                	add	a2,a2,a3
8000650a:	00f706b3          	add	a3,a4,a5
8000650e:	00e6b733          	sltu	a4,a3,a4
80006512:	9732                	add	a4,a4,a2
80006514:	97ba                	add	a5,a5,a4
80006516:	00e7b5b3          	sltu	a1,a5,a4
8000651a:	9736                	add	a4,a4,a3
8000651c:	00d736b3          	sltu	a3,a4,a3
80006520:	0705                	add	a4,a4,1
80006522:	97b6                	add	a5,a5,a3
80006524:	00173713          	seqz	a4,a4
80006528:	00d7b6b3          	sltu	a3,a5,a3
8000652c:	962e                	add	a2,a2,a1
8000652e:	97ba                	add	a5,a5,a4
80006530:	00c68933          	add	s2,a3,a2
80006534:	00e7b733          	sltu	a4,a5,a4
80006538:	843e                	mv	s0,a5
8000653a:	993a                	add	s2,s2,a4
8000653c:	b78d                	j	8000649e <.L49>

8000653e <.L55>:
8000653e:	01e59793          	sll	a5,a1,0x1e
80006542:	00255413          	srl	s0,a0,0x2
80006546:	8c5d                	or	s0,s0,a5
80006548:	0025d913          	srl	s2,a1,0x2
8000654c:	bf89                	j	8000649e <.L49>

8000654e <.L52>:
8000654e:	67c1                	lui	a5,0x10
80006550:	02c5d6b3          	divu	a3,a1,a2
80006554:	01055713          	srl	a4,a0,0x10
80006558:	02f67a63          	bgeu	a2,a5,8000658c <.L62>
8000655c:	01051413          	sll	s0,a0,0x10
80006560:	8041                	srl	s0,s0,0x10
80006562:	02c687b3          	mul	a5,a3,a2
80006566:	40f587b3          	sub	a5,a1,a5
8000656a:	07c2                	sll	a5,a5,0x10
8000656c:	97ba                	add	a5,a5,a4
8000656e:	02c7d933          	divu	s2,a5,a2
80006572:	02c90733          	mul	a4,s2,a2
80006576:	0942                	sll	s2,s2,0x10
80006578:	8f99                	sub	a5,a5,a4
8000657a:	07c2                	sll	a5,a5,0x10
8000657c:	943e                	add	s0,s0,a5
8000657e:	02c45433          	divu	s0,s0,a2
80006582:	944a                	add	s0,s0,s2
80006584:	01243933          	sltu	s2,s0,s2
80006588:	9936                	add	s2,s2,a3
8000658a:	bf11                	j	8000649e <.L49>

8000658c <.L62>:
8000658c:	02c687b3          	mul	a5,a3,a2
80006590:	01855613          	srl	a2,a0,0x18
80006594:	0ff77713          	zext.b	a4,a4
80006598:	0ff47413          	zext.b	s0,s0
8000659c:	8936                	mv	s2,a3
8000659e:	40f587b3          	sub	a5,a1,a5
800065a2:	07a2                	sll	a5,a5,0x8
800065a4:	963e                	add	a2,a2,a5
800065a6:	033657b3          	divu	a5,a2,s3
800065aa:	033785b3          	mul	a1,a5,s3
800065ae:	07a2                	sll	a5,a5,0x8
800065b0:	8e0d                	sub	a2,a2,a1
800065b2:	0622                	sll	a2,a2,0x8
800065b4:	9732                	add	a4,a4,a2
800065b6:	033755b3          	divu	a1,a4,s3
800065ba:	97ae                	add	a5,a5,a1
800065bc:	07a2                	sll	a5,a5,0x8
800065be:	03358633          	mul	a2,a1,s3
800065c2:	8f11                	sub	a4,a4,a2
800065c4:	00855613          	srl	a2,a0,0x8
800065c8:	0ff67613          	zext.b	a2,a2
800065cc:	0722                	sll	a4,a4,0x8
800065ce:	9732                	add	a4,a4,a2
800065d0:	03375633          	divu	a2,a4,s3
800065d4:	97b2                	add	a5,a5,a2
800065d6:	07a2                	sll	a5,a5,0x8
800065d8:	03360533          	mul	a0,a2,s3
800065dc:	8f09                	sub	a4,a4,a0
800065de:	0722                	sll	a4,a4,0x8
800065e0:	943a                	add	s0,s0,a4
800065e2:	03345433          	divu	s0,s0,s3
800065e6:	943e                	add	s0,s0,a5
800065e8:	bd5d                	j	8000649e <.L49>

800065ea <.L50>:
800065ea:	e5018a93          	add	s5,gp,-432 # 800036e0 <__SEGGER_RTL_Moeller_inverse_lut>
800065ee:	0cc5f063          	bgeu	a1,a2,800066ae <.L64>
800065f2:	10000737          	lui	a4,0x10000
800065f6:	87b2                	mv	a5,a2
800065f8:	00e67563          	bgeu	a2,a4,80006602 <.L65>
800065fc:	00461793          	sll	a5,a2,0x4
80006600:	4491                	li	s1,4

80006602 <.L65>:
80006602:	40000737          	lui	a4,0x40000
80006606:	00e7f463          	bgeu	a5,a4,8000660e <.L66>
8000660a:	0489                	add	s1,s1,2
8000660c:	078a                	sll	a5,a5,0x2

8000660e <.L66>:
8000660e:	0007c363          	bltz	a5,80006614 <.L67>
80006612:	0485                	add	s1,s1,1

80006614 <.L67>:
80006614:	8626                	mv	a2,s1
80006616:	8522                	mv	a0,s0
80006618:	85ca                	mv	a1,s2
8000661a:	3d2d                	jal	80006454 <__ashldi3>
8000661c:	009994b3          	sll	s1,s3,s1
80006620:	0164d793          	srl	a5,s1,0x16
80006624:	e0078793          	add	a5,a5,-512 # fe00 <__AHB_SRAM_segment_size__+0x7e00>
80006628:	0786                	sll	a5,a5,0x1
8000662a:	97d6                	add	a5,a5,s5
8000662c:	0007d783          	lhu	a5,0(a5)
80006630:	00b4d813          	srl	a6,s1,0xb
80006634:	0014f713          	and	a4,s1,1
80006638:	02f78633          	mul	a2,a5,a5
8000663c:	0792                	sll	a5,a5,0x4
8000663e:	0014d693          	srl	a3,s1,0x1
80006642:	0805                	add	a6,a6,1
80006644:	03063633          	mulhu	a2,a2,a6
80006648:	8f91                	sub	a5,a5,a2
8000664a:	96ba                	add	a3,a3,a4
8000664c:	17fd                	add	a5,a5,-1
8000664e:	c319                	beqz	a4,80006654 <.L68>
80006650:	0017d713          	srl	a4,a5,0x1

80006654 <.L68>:
80006654:	02f686b3          	mul	a3,a3,a5
80006658:	8f15                	sub	a4,a4,a3
8000665a:	02e7b733          	mulhu	a4,a5,a4
8000665e:	07be                	sll	a5,a5,0xf
80006660:	8305                	srl	a4,a4,0x1
80006662:	97ba                	add	a5,a5,a4
80006664:	8726                	mv	a4,s1
80006666:	029786b3          	mul	a3,a5,s1
8000666a:	9736                	add	a4,a4,a3
8000666c:	00d736b3          	sltu	a3,a4,a3
80006670:	8726                	mv	a4,s1
80006672:	9736                	add	a4,a4,a3
80006674:	0297b6b3          	mulhu	a3,a5,s1
80006678:	9736                	add	a4,a4,a3
8000667a:	8f99                	sub	a5,a5,a4
8000667c:	02b7b733          	mulhu	a4,a5,a1
80006680:	02b787b3          	mul	a5,a5,a1
80006684:	00a786b3          	add	a3,a5,a0
80006688:	00f6b7b3          	sltu	a5,a3,a5
8000668c:	95be                	add	a1,a1,a5
8000668e:	00b707b3          	add	a5,a4,a1
80006692:	00178413          	add	s0,a5,1
80006696:	02848733          	mul	a4,s1,s0
8000669a:	8d19                	sub	a0,a0,a4
8000669c:	00a6f463          	bgeu	a3,a0,800066a4 <.L69>
800066a0:	9526                	add	a0,a0,s1
800066a2:	843e                	mv	s0,a5

800066a4 <.L69>:
800066a4:	00956363          	bltu	a0,s1,800066aa <.L109>
800066a8:	0405                	add	s0,s0,1

800066aa <.L109>:
800066aa:	4901                	li	s2,0
800066ac:	bbcd                	j	8000649e <.L49>

800066ae <.L64>:
800066ae:	02c5da33          	divu	s4,a1,a2
800066b2:	10000737          	lui	a4,0x10000
800066b6:	87b2                	mv	a5,a2
800066b8:	02ca05b3          	mul	a1,s4,a2
800066bc:	40b905b3          	sub	a1,s2,a1
800066c0:	00e67563          	bgeu	a2,a4,800066ca <.L71>
800066c4:	00461793          	sll	a5,a2,0x4
800066c8:	4491                	li	s1,4

800066ca <.L71>:
800066ca:	40000737          	lui	a4,0x40000
800066ce:	00e7f463          	bgeu	a5,a4,800066d6 <.L72>
800066d2:	0489                	add	s1,s1,2
800066d4:	078a                	sll	a5,a5,0x2

800066d6 <.L72>:
800066d6:	0007c363          	bltz	a5,800066dc <.L73>
800066da:	0485                	add	s1,s1,1

800066dc <.L73>:
800066dc:	8626                	mv	a2,s1
800066de:	8522                	mv	a0,s0
800066e0:	3b95                	jal	80006454 <__ashldi3>
800066e2:	009994b3          	sll	s1,s3,s1
800066e6:	0164d793          	srl	a5,s1,0x16
800066ea:	e0078793          	add	a5,a5,-512
800066ee:	0786                	sll	a5,a5,0x1
800066f0:	9abe                	add	s5,s5,a5
800066f2:	000ad783          	lhu	a5,0(s5)
800066f6:	00b4d813          	srl	a6,s1,0xb
800066fa:	0014f713          	and	a4,s1,1
800066fe:	02f78633          	mul	a2,a5,a5
80006702:	0792                	sll	a5,a5,0x4
80006704:	0014d693          	srl	a3,s1,0x1
80006708:	0805                	add	a6,a6,1
8000670a:	03063633          	mulhu	a2,a2,a6
8000670e:	8f91                	sub	a5,a5,a2
80006710:	96ba                	add	a3,a3,a4
80006712:	17fd                	add	a5,a5,-1
80006714:	c319                	beqz	a4,8000671a <.L74>
80006716:	0017d713          	srl	a4,a5,0x1

8000671a <.L74>:
8000671a:	02f686b3          	mul	a3,a3,a5
8000671e:	8f15                	sub	a4,a4,a3
80006720:	02e7b733          	mulhu	a4,a5,a4
80006724:	07be                	sll	a5,a5,0xf
80006726:	8305                	srl	a4,a4,0x1
80006728:	97ba                	add	a5,a5,a4
8000672a:	8726                	mv	a4,s1
8000672c:	029786b3          	mul	a3,a5,s1
80006730:	9736                	add	a4,a4,a3
80006732:	00d736b3          	sltu	a3,a4,a3
80006736:	8726                	mv	a4,s1
80006738:	9736                	add	a4,a4,a3
8000673a:	0297b6b3          	mulhu	a3,a5,s1
8000673e:	9736                	add	a4,a4,a3
80006740:	8f99                	sub	a5,a5,a4
80006742:	02b7b733          	mulhu	a4,a5,a1
80006746:	02b787b3          	mul	a5,a5,a1
8000674a:	00a786b3          	add	a3,a5,a0
8000674e:	00f6b7b3          	sltu	a5,a3,a5
80006752:	95be                	add	a1,a1,a5
80006754:	00b707b3          	add	a5,a4,a1
80006758:	00178413          	add	s0,a5,1
8000675c:	02848733          	mul	a4,s1,s0
80006760:	8d19                	sub	a0,a0,a4
80006762:	00a6f463          	bgeu	a3,a0,8000676a <.L75>
80006766:	9526                	add	a0,a0,s1
80006768:	843e                	mv	s0,a5

8000676a <.L75>:
8000676a:	00956363          	bltu	a0,s1,80006770 <.L76>
8000676e:	0405                	add	s0,s0,1

80006770 <.L76>:
80006770:	8952                	mv	s2,s4
80006772:	b335                	j	8000649e <.L49>

80006774 <.L47>:
80006774:	67c1                	lui	a5,0x10
80006776:	8ab6                	mv	s5,a3
80006778:	4a01                	li	s4,0
8000677a:	00f6f563          	bgeu	a3,a5,80006784 <.L77>
8000677e:	01069493          	sll	s1,a3,0x10
80006782:	4a41                	li	s4,16

80006784 <.L77>:
80006784:	010007b7          	lui	a5,0x1000
80006788:	00f4f463          	bgeu	s1,a5,80006790 <.L78>
8000678c:	0a21                	add	s4,s4,8
8000678e:	04a2                	sll	s1,s1,0x8

80006790 <.L78>:
80006790:	100007b7          	lui	a5,0x10000
80006794:	00f4f463          	bgeu	s1,a5,8000679c <.L79>
80006798:	0a11                	add	s4,s4,4
8000679a:	0492                	sll	s1,s1,0x4

8000679c <.L79>:
8000679c:	400007b7          	lui	a5,0x40000
800067a0:	00f4f463          	bgeu	s1,a5,800067a8 <.L80>
800067a4:	0a09                	add	s4,s4,2
800067a6:	048a                	sll	s1,s1,0x2

800067a8 <.L80>:
800067a8:	0004c363          	bltz	s1,800067ae <.L81>
800067ac:	0a05                	add	s4,s4,1

800067ae <.L81>:
800067ae:	01f91793          	sll	a5,s2,0x1f
800067b2:	8652                	mv	a2,s4
800067b4:	00145493          	srl	s1,s0,0x1
800067b8:	854e                	mv	a0,s3
800067ba:	85d6                	mv	a1,s5
800067bc:	8cdd                	or	s1,s1,a5
800067be:	3959                	jal	80006454 <__ashldi3>
800067c0:	0165d613          	srl	a2,a1,0x16
800067c4:	e0060613          	add	a2,a2,-512 # 7ffffe00 <_extram_size+0x7dfffe00>
800067c8:	0606                	sll	a2,a2,0x1
800067ca:	e5018793          	add	a5,gp,-432 # 800036e0 <__SEGGER_RTL_Moeller_inverse_lut>
800067ce:	97b2                	add	a5,a5,a2
800067d0:	0007d783          	lhu	a5,0(a5) # 40000000 <_extram_size+0x3e000000>
800067d4:	00b5d513          	srl	a0,a1,0xb
800067d8:	0015f713          	and	a4,a1,1
800067dc:	02f78633          	mul	a2,a5,a5
800067e0:	0792                	sll	a5,a5,0x4
800067e2:	0015d693          	srl	a3,a1,0x1
800067e6:	0505                	add	a0,a0,1 # 7f800001 <_extram_size+0x7d800001>
800067e8:	02a63633          	mulhu	a2,a2,a0
800067ec:	8f91                	sub	a5,a5,a2
800067ee:	00195b13          	srl	s6,s2,0x1
800067f2:	96ba                	add	a3,a3,a4
800067f4:	17fd                	add	a5,a5,-1
800067f6:	c319                	beqz	a4,800067fc <.L82>
800067f8:	0017d713          	srl	a4,a5,0x1

800067fc <.L82>:
800067fc:	02f686b3          	mul	a3,a3,a5
80006800:	8f15                	sub	a4,a4,a3
80006802:	02e7b733          	mulhu	a4,a5,a4
80006806:	07be                	sll	a5,a5,0xf
80006808:	8305                	srl	a4,a4,0x1
8000680a:	97ba                	add	a5,a5,a4
8000680c:	872e                	mv	a4,a1
8000680e:	02b786b3          	mul	a3,a5,a1
80006812:	9736                	add	a4,a4,a3
80006814:	00d736b3          	sltu	a3,a4,a3
80006818:	872e                	mv	a4,a1
8000681a:	9736                	add	a4,a4,a3
8000681c:	02b7b6b3          	mulhu	a3,a5,a1
80006820:	9736                	add	a4,a4,a3
80006822:	8f99                	sub	a5,a5,a4
80006824:	0367b733          	mulhu	a4,a5,s6
80006828:	036787b3          	mul	a5,a5,s6
8000682c:	009786b3          	add	a3,a5,s1
80006830:	00f6b7b3          	sltu	a5,a3,a5
80006834:	97da                	add	a5,a5,s6
80006836:	973e                	add	a4,a4,a5
80006838:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
8000683c:	02f58633          	mul	a2,a1,a5
80006840:	8c91                	sub	s1,s1,a2
80006842:	0096f463          	bgeu	a3,s1,8000684a <.L83>
80006846:	94ae                	add	s1,s1,a1
80006848:	87ba                	mv	a5,a4

8000684a <.L83>:
8000684a:	00b4e363          	bltu	s1,a1,80006850 <.L84>
8000684e:	0785                	add	a5,a5,1

80006850 <.L84>:
80006850:	477d                	li	a4,31
80006852:	41470733          	sub	a4,a4,s4
80006856:	00e7d633          	srl	a2,a5,a4
8000685a:	c211                	beqz	a2,8000685e <.L85>
8000685c:	167d                	add	a2,a2,-1

8000685e <.L85>:
8000685e:	02ca87b3          	mul	a5,s5,a2
80006862:	03360733          	mul	a4,a2,s3
80006866:	033636b3          	mulhu	a3,a2,s3
8000686a:	40e40733          	sub	a4,s0,a4
8000686e:	00e43433          	sltu	s0,s0,a4
80006872:	97b6                	add	a5,a5,a3
80006874:	40f907b3          	sub	a5,s2,a5
80006878:	40878433          	sub	s0,a5,s0
8000687c:	01546763          	bltu	s0,s5,8000688a <.L86>
80006880:	008a9463          	bne	s5,s0,80006888 <.L95>
80006884:	01376363          	bltu	a4,s3,8000688a <.L86>

80006888 <.L95>:
80006888:	0605                	add	a2,a2,1

8000688a <.L86>:
8000688a:	8432                	mv	s0,a2
8000688c:	bd39                	j	800066aa <.L109>

8000688e <.L88>:
8000688e:	4401                	li	s0,0
80006890:	bd29                	j	800066aa <.L109>

Disassembly of section .text.libc.__umoddi3:

80006892 <__umoddi3>:
80006892:	1101                	add	sp,sp,-32
80006894:	cc22                	sw	s0,24(sp)
80006896:	ca26                	sw	s1,20(sp)
80006898:	c84a                	sw	s2,16(sp)
8000689a:	c64e                	sw	s3,12(sp)
8000689c:	c452                	sw	s4,8(sp)
8000689e:	ce06                	sw	ra,28(sp)
800068a0:	c256                	sw	s5,4(sp)
800068a2:	c05a                	sw	s6,0(sp)
800068a4:	892a                	mv	s2,a0
800068a6:	84ae                	mv	s1,a1
800068a8:	8432                	mv	s0,a2
800068aa:	89b6                	mv	s3,a3
800068ac:	8a36                	mv	s4,a3
800068ae:	2e069c63          	bnez	a3,80006ba6 <.L111>
800068b2:	e589                	bnez	a1,800068bc <.L112>
800068b4:	02c557b3          	divu	a5,a0,a2

800068b8 <.L174>:
800068b8:	4701                	li	a4,0
800068ba:	a815                	j	800068ee <.L113>

800068bc <.L112>:
800068bc:	010007b7          	lui	a5,0x1000
800068c0:	16f67163          	bgeu	a2,a5,80006a22 <.L114>
800068c4:	4791                	li	a5,4
800068c6:	0cc7e063          	bltu	a5,a2,80006986 <.L116>
800068ca:	470d                	li	a4,3
800068cc:	04e60d63          	beq	a2,a4,80006926 <.L118>
800068d0:	0af60363          	beq	a2,a5,80006976 <.L119>
800068d4:	4785                	li	a5,1
800068d6:	3ef60363          	beq	a2,a5,80006cbc <.L152>
800068da:	4789                	li	a5,2
800068dc:	3ef61363          	bne	a2,a5,80006cc2 <.L153>
800068e0:	01f59713          	sll	a4,a1,0x1f
800068e4:	00155793          	srl	a5,a0,0x1
800068e8:	8fd9                	or	a5,a5,a4
800068ea:	0015d713          	srl	a4,a1,0x1

800068ee <.L113>:
800068ee:	02870733          	mul	a4,a4,s0
800068f2:	40f2                	lw	ra,28(sp)
800068f4:	4a22                	lw	s4,8(sp)
800068f6:	4a92                	lw	s5,4(sp)
800068f8:	4b02                	lw	s6,0(sp)
800068fa:	02f989b3          	mul	s3,s3,a5
800068fe:	02f40533          	mul	a0,s0,a5
80006902:	99ba                	add	s3,s3,a4
80006904:	02f43433          	mulhu	s0,s0,a5
80006908:	40a90533          	sub	a0,s2,a0
8000690c:	00a935b3          	sltu	a1,s2,a0
80006910:	4942                	lw	s2,16(sp)
80006912:	99a2                	add	s3,s3,s0
80006914:	4462                	lw	s0,24(sp)
80006916:	413484b3          	sub	s1,s1,s3
8000691a:	40b485b3          	sub	a1,s1,a1
8000691e:	49b2                	lw	s3,12(sp)
80006920:	44d2                	lw	s1,20(sp)
80006922:	6105                	add	sp,sp,32
80006924:	8082                	ret

80006926 <.L118>:
80006926:	555557b7          	lui	a5,0x55555
8000692a:	55578793          	add	a5,a5,1365 # 55555555 <_extram_size+0x53555555>
8000692e:	02b7b6b3          	mulhu	a3,a5,a1
80006932:	02a7b633          	mulhu	a2,a5,a0
80006936:	02a78733          	mul	a4,a5,a0
8000693a:	02b787b3          	mul	a5,a5,a1
8000693e:	97b2                	add	a5,a5,a2
80006940:	00c7b633          	sltu	a2,a5,a2
80006944:	9636                	add	a2,a2,a3
80006946:	00f706b3          	add	a3,a4,a5
8000694a:	00e6b733          	sltu	a4,a3,a4
8000694e:	9732                	add	a4,a4,a2
80006950:	97ba                	add	a5,a5,a4
80006952:	00e7b5b3          	sltu	a1,a5,a4
80006956:	9736                	add	a4,a4,a3
80006958:	00d736b3          	sltu	a3,a4,a3
8000695c:	0705                	add	a4,a4,1
8000695e:	97b6                	add	a5,a5,a3
80006960:	00173713          	seqz	a4,a4
80006964:	00d7b6b3          	sltu	a3,a5,a3
80006968:	962e                	add	a2,a2,a1
8000696a:	97ba                	add	a5,a5,a4
8000696c:	96b2                	add	a3,a3,a2
8000696e:	00e7b733          	sltu	a4,a5,a4
80006972:	9736                	add	a4,a4,a3
80006974:	bfad                	j	800068ee <.L113>

80006976 <.L119>:
80006976:	01e59713          	sll	a4,a1,0x1e
8000697a:	00255793          	srl	a5,a0,0x2
8000697e:	8fd9                	or	a5,a5,a4
80006980:	0025d713          	srl	a4,a1,0x2
80006984:	b7ad                	j	800068ee <.L113>

80006986 <.L116>:
80006986:	67c1                	lui	a5,0x10
80006988:	02c5d733          	divu	a4,a1,a2
8000698c:	01055693          	srl	a3,a0,0x10
80006990:	02f67b63          	bgeu	a2,a5,800069c6 <.L126>
80006994:	02c707b3          	mul	a5,a4,a2
80006998:	40f587b3          	sub	a5,a1,a5
8000699c:	07c2                	sll	a5,a5,0x10
8000699e:	97b6                	add	a5,a5,a3
800069a0:	02c7d633          	divu	a2,a5,a2
800069a4:	028606b3          	mul	a3,a2,s0
800069a8:	0642                	sll	a2,a2,0x10
800069aa:	8f95                	sub	a5,a5,a3
800069ac:	01079693          	sll	a3,a5,0x10
800069b0:	01051793          	sll	a5,a0,0x10
800069b4:	83c1                	srl	a5,a5,0x10
800069b6:	97b6                	add	a5,a5,a3
800069b8:	0287d7b3          	divu	a5,a5,s0
800069bc:	97b2                	add	a5,a5,a2
800069be:	00c7b633          	sltu	a2,a5,a2
800069c2:	9732                	add	a4,a4,a2
800069c4:	b72d                	j	800068ee <.L113>

800069c6 <.L126>:
800069c6:	02c707b3          	mul	a5,a4,a2
800069ca:	01855613          	srl	a2,a0,0x18
800069ce:	0ff6f693          	zext.b	a3,a3
800069d2:	40f587b3          	sub	a5,a1,a5
800069d6:	07a2                	sll	a5,a5,0x8
800069d8:	963e                	add	a2,a2,a5
800069da:	028657b3          	divu	a5,a2,s0
800069de:	028785b3          	mul	a1,a5,s0
800069e2:	07a2                	sll	a5,a5,0x8
800069e4:	8e0d                	sub	a2,a2,a1
800069e6:	0622                	sll	a2,a2,0x8
800069e8:	96b2                	add	a3,a3,a2
800069ea:	0286d5b3          	divu	a1,a3,s0
800069ee:	97ae                	add	a5,a5,a1
800069f0:	07a2                	sll	a5,a5,0x8
800069f2:	02858633          	mul	a2,a1,s0
800069f6:	8e91                	sub	a3,a3,a2
800069f8:	00855613          	srl	a2,a0,0x8
800069fc:	0ff67613          	zext.b	a2,a2
80006a00:	06a2                	sll	a3,a3,0x8
80006a02:	96b2                	add	a3,a3,a2
80006a04:	0286d633          	divu	a2,a3,s0
80006a08:	97b2                	add	a5,a5,a2
80006a0a:	07a2                	sll	a5,a5,0x8
80006a0c:	02860533          	mul	a0,a2,s0
80006a10:	0ff97613          	zext.b	a2,s2
80006a14:	8e89                	sub	a3,a3,a0
80006a16:	06a2                	sll	a3,a3,0x8
80006a18:	96b2                	add	a3,a3,a2
80006a1a:	0286d6b3          	divu	a3,a3,s0
80006a1e:	97b6                	add	a5,a5,a3
80006a20:	b5f9                	j	800068ee <.L113>

80006a22 <.L114>:
80006a22:	e5018b13          	add	s6,gp,-432 # 800036e0 <__SEGGER_RTL_Moeller_inverse_lut>
80006a26:	0ac5fe63          	bgeu	a1,a2,80006ae2 <.L128>
80006a2a:	10000737          	lui	a4,0x10000
80006a2e:	87b2                	mv	a5,a2
80006a30:	00e67563          	bgeu	a2,a4,80006a3a <.L129>
80006a34:	00461793          	sll	a5,a2,0x4
80006a38:	4a11                	li	s4,4

80006a3a <.L129>:
80006a3a:	40000737          	lui	a4,0x40000
80006a3e:	00e7f463          	bgeu	a5,a4,80006a46 <.L130>
80006a42:	0a09                	add	s4,s4,2
80006a44:	078a                	sll	a5,a5,0x2

80006a46 <.L130>:
80006a46:	0007c363          	bltz	a5,80006a4c <.L131>
80006a4a:	0a05                	add	s4,s4,1

80006a4c <.L131>:
80006a4c:	8652                	mv	a2,s4
80006a4e:	854a                	mv	a0,s2
80006a50:	85a6                	mv	a1,s1
80006a52:	3409                	jal	80006454 <__ashldi3>
80006a54:	01441a33          	sll	s4,s0,s4
80006a58:	016a5793          	srl	a5,s4,0x16
80006a5c:	e0078793          	add	a5,a5,-512 # fe00 <__AHB_SRAM_segment_size__+0x7e00>
80006a60:	0786                	sll	a5,a5,0x1
80006a62:	97da                	add	a5,a5,s6
80006a64:	0007d783          	lhu	a5,0(a5)
80006a68:	00ba5813          	srl	a6,s4,0xb
80006a6c:	001a7713          	and	a4,s4,1
80006a70:	02f78633          	mul	a2,a5,a5
80006a74:	0792                	sll	a5,a5,0x4
80006a76:	001a5693          	srl	a3,s4,0x1
80006a7a:	0805                	add	a6,a6,1
80006a7c:	03063633          	mulhu	a2,a2,a6
80006a80:	8f91                	sub	a5,a5,a2
80006a82:	96ba                	add	a3,a3,a4
80006a84:	17fd                	add	a5,a5,-1
80006a86:	c319                	beqz	a4,80006a8c <.L132>
80006a88:	0017d713          	srl	a4,a5,0x1

80006a8c <.L132>:
80006a8c:	02f686b3          	mul	a3,a3,a5
80006a90:	8f15                	sub	a4,a4,a3
80006a92:	02e7b733          	mulhu	a4,a5,a4
80006a96:	07be                	sll	a5,a5,0xf
80006a98:	8305                	srl	a4,a4,0x1
80006a9a:	97ba                	add	a5,a5,a4
80006a9c:	8752                	mv	a4,s4
80006a9e:	034786b3          	mul	a3,a5,s4
80006aa2:	9736                	add	a4,a4,a3
80006aa4:	00d736b3          	sltu	a3,a4,a3
80006aa8:	8752                	mv	a4,s4
80006aaa:	9736                	add	a4,a4,a3
80006aac:	0347b6b3          	mulhu	a3,a5,s4
80006ab0:	9736                	add	a4,a4,a3
80006ab2:	8f99                	sub	a5,a5,a4
80006ab4:	02b7b733          	mulhu	a4,a5,a1
80006ab8:	02b787b3          	mul	a5,a5,a1
80006abc:	00a786b3          	add	a3,a5,a0
80006ac0:	00f6b7b3          	sltu	a5,a3,a5
80006ac4:	95be                	add	a1,a1,a5
80006ac6:	972e                	add	a4,a4,a1
80006ac8:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
80006acc:	02fa0633          	mul	a2,s4,a5
80006ad0:	8d11                	sub	a0,a0,a2
80006ad2:	00a6f463          	bgeu	a3,a0,80006ada <.L133>
80006ad6:	9552                	add	a0,a0,s4
80006ad8:	87ba                	mv	a5,a4

80006ada <.L133>:
80006ada:	dd456fe3          	bltu	a0,s4,800068b8 <.L174>

80006ade <.L160>:
80006ade:	0785                	add	a5,a5,1
80006ae0:	bbe1                	j	800068b8 <.L174>

80006ae2 <.L128>:
80006ae2:	02c5dab3          	divu	s5,a1,a2
80006ae6:	10000737          	lui	a4,0x10000
80006aea:	87b2                	mv	a5,a2
80006aec:	02ca85b3          	mul	a1,s5,a2
80006af0:	40b485b3          	sub	a1,s1,a1
80006af4:	00e67563          	bgeu	a2,a4,80006afe <.L135>
80006af8:	00461793          	sll	a5,a2,0x4
80006afc:	4a11                	li	s4,4

80006afe <.L135>:
80006afe:	40000737          	lui	a4,0x40000
80006b02:	00e7f463          	bgeu	a5,a4,80006b0a <.L136>
80006b06:	0a09                	add	s4,s4,2
80006b08:	078a                	sll	a5,a5,0x2

80006b0a <.L136>:
80006b0a:	0007c363          	bltz	a5,80006b10 <.L137>
80006b0e:	0a05                	add	s4,s4,1

80006b10 <.L137>:
80006b10:	8652                	mv	a2,s4
80006b12:	854a                	mv	a0,s2
80006b14:	3281                	jal	80006454 <__ashldi3>
80006b16:	01441a33          	sll	s4,s0,s4
80006b1a:	016a5793          	srl	a5,s4,0x16
80006b1e:	e0078793          	add	a5,a5,-512
80006b22:	0786                	sll	a5,a5,0x1
80006b24:	9b3e                	add	s6,s6,a5
80006b26:	000b5783          	lhu	a5,0(s6)
80006b2a:	00ba5813          	srl	a6,s4,0xb
80006b2e:	001a7713          	and	a4,s4,1
80006b32:	02f78633          	mul	a2,a5,a5
80006b36:	0792                	sll	a5,a5,0x4
80006b38:	001a5693          	srl	a3,s4,0x1
80006b3c:	0805                	add	a6,a6,1
80006b3e:	03063633          	mulhu	a2,a2,a6
80006b42:	8f91                	sub	a5,a5,a2
80006b44:	96ba                	add	a3,a3,a4
80006b46:	17fd                	add	a5,a5,-1
80006b48:	c319                	beqz	a4,80006b4e <.L138>
80006b4a:	0017d713          	srl	a4,a5,0x1

80006b4e <.L138>:
80006b4e:	02f686b3          	mul	a3,a3,a5
80006b52:	8f15                	sub	a4,a4,a3
80006b54:	02e7b733          	mulhu	a4,a5,a4
80006b58:	07be                	sll	a5,a5,0xf
80006b5a:	8305                	srl	a4,a4,0x1
80006b5c:	97ba                	add	a5,a5,a4
80006b5e:	8752                	mv	a4,s4
80006b60:	034786b3          	mul	a3,a5,s4
80006b64:	9736                	add	a4,a4,a3
80006b66:	00d736b3          	sltu	a3,a4,a3
80006b6a:	8752                	mv	a4,s4
80006b6c:	9736                	add	a4,a4,a3
80006b6e:	0347b6b3          	mulhu	a3,a5,s4
80006b72:	9736                	add	a4,a4,a3
80006b74:	8f99                	sub	a5,a5,a4
80006b76:	02b7b733          	mulhu	a4,a5,a1
80006b7a:	02b787b3          	mul	a5,a5,a1
80006b7e:	00a786b3          	add	a3,a5,a0
80006b82:	00f6b7b3          	sltu	a5,a3,a5
80006b86:	95be                	add	a1,a1,a5
80006b88:	972e                	add	a4,a4,a1
80006b8a:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
80006b8e:	02fa0633          	mul	a2,s4,a5
80006b92:	8d11                	sub	a0,a0,a2
80006b94:	00a6f463          	bgeu	a3,a0,80006b9c <.L139>
80006b98:	9552                	add	a0,a0,s4
80006b9a:	87ba                	mv	a5,a4

80006b9c <.L139>:
80006b9c:	01456363          	bltu	a0,s4,80006ba2 <.L140>
80006ba0:	0785                	add	a5,a5,1

80006ba2 <.L140>:
80006ba2:	8756                	mv	a4,s5
80006ba4:	b3a9                	j	800068ee <.L113>

80006ba6 <.L111>:
80006ba6:	67c1                	lui	a5,0x10
80006ba8:	4a81                	li	s5,0
80006baa:	00f6f563          	bgeu	a3,a5,80006bb4 <.L141>
80006bae:	01069a13          	sll	s4,a3,0x10
80006bb2:	4ac1                	li	s5,16

80006bb4 <.L141>:
80006bb4:	010007b7          	lui	a5,0x1000
80006bb8:	00fa7463          	bgeu	s4,a5,80006bc0 <.L142>
80006bbc:	0aa1                	add	s5,s5,8
80006bbe:	0a22                	sll	s4,s4,0x8

80006bc0 <.L142>:
80006bc0:	100007b7          	lui	a5,0x10000
80006bc4:	00fa7463          	bgeu	s4,a5,80006bcc <.L143>
80006bc8:	0a91                	add	s5,s5,4
80006bca:	0a12                	sll	s4,s4,0x4

80006bcc <.L143>:
80006bcc:	400007b7          	lui	a5,0x40000
80006bd0:	00fa7463          	bgeu	s4,a5,80006bd8 <.L144>
80006bd4:	0a89                	add	s5,s5,2
80006bd6:	0a0a                	sll	s4,s4,0x2

80006bd8 <.L144>:
80006bd8:	000a4363          	bltz	s4,80006bde <.L145>
80006bdc:	0a85                	add	s5,s5,1

80006bde <.L145>:
80006bde:	01f49793          	sll	a5,s1,0x1f
80006be2:	8656                	mv	a2,s5
80006be4:	00195a13          	srl	s4,s2,0x1
80006be8:	8522                	mv	a0,s0
80006bea:	85ce                	mv	a1,s3
80006bec:	0147ea33          	or	s4,a5,s4
80006bf0:	3095                	jal	80006454 <__ashldi3>
80006bf2:	0165d613          	srl	a2,a1,0x16
80006bf6:	e0060613          	add	a2,a2,-512
80006bfa:	0606                	sll	a2,a2,0x1
80006bfc:	e5018793          	add	a5,gp,-432 # 800036e0 <__SEGGER_RTL_Moeller_inverse_lut>
80006c00:	97b2                	add	a5,a5,a2
80006c02:	0007d783          	lhu	a5,0(a5) # 40000000 <_extram_size+0x3e000000>
80006c06:	00b5d513          	srl	a0,a1,0xb
80006c0a:	0015f713          	and	a4,a1,1
80006c0e:	02f78633          	mul	a2,a5,a5
80006c12:	0792                	sll	a5,a5,0x4
80006c14:	0015d693          	srl	a3,a1,0x1
80006c18:	0505                	add	a0,a0,1
80006c1a:	02a63633          	mulhu	a2,a2,a0
80006c1e:	8f91                	sub	a5,a5,a2
80006c20:	0014db13          	srl	s6,s1,0x1
80006c24:	96ba                	add	a3,a3,a4
80006c26:	17fd                	add	a5,a5,-1
80006c28:	c319                	beqz	a4,80006c2e <.L146>
80006c2a:	0017d713          	srl	a4,a5,0x1

80006c2e <.L146>:
80006c2e:	02f686b3          	mul	a3,a3,a5
80006c32:	8f15                	sub	a4,a4,a3
80006c34:	02e7b733          	mulhu	a4,a5,a4
80006c38:	07be                	sll	a5,a5,0xf
80006c3a:	8305                	srl	a4,a4,0x1
80006c3c:	97ba                	add	a5,a5,a4
80006c3e:	872e                	mv	a4,a1
80006c40:	02b786b3          	mul	a3,a5,a1
80006c44:	9736                	add	a4,a4,a3
80006c46:	00d736b3          	sltu	a3,a4,a3
80006c4a:	872e                	mv	a4,a1
80006c4c:	9736                	add	a4,a4,a3
80006c4e:	02b7b6b3          	mulhu	a3,a5,a1
80006c52:	9736                	add	a4,a4,a3
80006c54:	8f99                	sub	a5,a5,a4
80006c56:	0367b733          	mulhu	a4,a5,s6
80006c5a:	036787b3          	mul	a5,a5,s6
80006c5e:	014786b3          	add	a3,a5,s4
80006c62:	00f6b7b3          	sltu	a5,a3,a5
80006c66:	97da                	add	a5,a5,s6
80006c68:	973e                	add	a4,a4,a5
80006c6a:	00170793          	add	a5,a4,1
80006c6e:	02f58633          	mul	a2,a1,a5
80006c72:	40ca0a33          	sub	s4,s4,a2
80006c76:	0146f463          	bgeu	a3,s4,80006c7e <.L147>
80006c7a:	9a2e                	add	s4,s4,a1
80006c7c:	87ba                	mv	a5,a4

80006c7e <.L147>:
80006c7e:	00ba6363          	bltu	s4,a1,80006c84 <.L148>
80006c82:	0785                	add	a5,a5,1

80006c84 <.L148>:
80006c84:	477d                	li	a4,31
80006c86:	41570733          	sub	a4,a4,s5
80006c8a:	00e7d7b3          	srl	a5,a5,a4
80006c8e:	c391                	beqz	a5,80006c92 <.L149>
80006c90:	17fd                	add	a5,a5,-1

80006c92 <.L149>:
80006c92:	0287b633          	mulhu	a2,a5,s0
80006c96:	02f98733          	mul	a4,s3,a5
80006c9a:	028786b3          	mul	a3,a5,s0
80006c9e:	9732                	add	a4,a4,a2
80006ca0:	40e48733          	sub	a4,s1,a4
80006ca4:	40d906b3          	sub	a3,s2,a3
80006ca8:	00d93633          	sltu	a2,s2,a3
80006cac:	8f11                	sub	a4,a4,a2
80006cae:	c13765e3          	bltu	a4,s3,800068b8 <.L174>
80006cb2:	e2e996e3          	bne	s3,a4,80006ade <.L160>
80006cb6:	c086e1e3          	bltu	a3,s0,800068b8 <.L174>
80006cba:	b515                	j	80006ade <.L160>

80006cbc <.L152>:
80006cbc:	87aa                	mv	a5,a0
80006cbe:	872e                	mv	a4,a1
80006cc0:	b13d                	j	800068ee <.L113>

80006cc2 <.L153>:
80006cc2:	4781                	li	a5,0
80006cc4:	bed5                	j	800068b8 <.L174>

Disassembly of section .text.libc.abs:

80006cc6 <abs>:
80006cc6:	41f55793          	sra	a5,a0,0x1f
80006cca:	8d3d                	xor	a0,a0,a5
80006ccc:	8d1d                	sub	a0,a0,a5
80006cce:	8082                	ret

Disassembly of section .text.libc.memcpy:

80006cd0 <memcpy>:
80006cd0:	c251                	beqz	a2,80006d54 <.Lmemcpy_done>
80006cd2:	87aa                	mv	a5,a0
80006cd4:	00b546b3          	xor	a3,a0,a1
80006cd8:	06fa                	sll	a3,a3,0x1e
80006cda:	e2bd                	bnez	a3,80006d40 <.Lmemcpy_byte_copy>
80006cdc:	01e51693          	sll	a3,a0,0x1e
80006ce0:	ce81                	beqz	a3,80006cf8 <.Lmemcpy_aligned>

80006ce2 <.Lmemcpy_word_align>:
80006ce2:	00058683          	lb	a3,0(a1)
80006ce6:	00d50023          	sb	a3,0(a0)
80006cea:	0585                	add	a1,a1,1
80006cec:	0505                	add	a0,a0,1
80006cee:	167d                	add	a2,a2,-1
80006cf0:	c22d                	beqz	a2,80006d52 <.Lmemcpy_memcpy_end>
80006cf2:	01e51693          	sll	a3,a0,0x1e
80006cf6:	f6f5                	bnez	a3,80006ce2 <.Lmemcpy_word_align>

80006cf8 <.Lmemcpy_aligned>:
80006cf8:	02000693          	li	a3,32
80006cfc:	02d66763          	bltu	a2,a3,80006d2a <.Lmemcpy_word_copy>

80006d00 <.Lmemcpy_aligned_block_copy_loop>:
80006d00:	4198                	lw	a4,0(a1)
80006d02:	c118                	sw	a4,0(a0)
80006d04:	41d8                	lw	a4,4(a1)
80006d06:	c158                	sw	a4,4(a0)
80006d08:	4598                	lw	a4,8(a1)
80006d0a:	c518                	sw	a4,8(a0)
80006d0c:	45d8                	lw	a4,12(a1)
80006d0e:	c558                	sw	a4,12(a0)
80006d10:	4998                	lw	a4,16(a1)
80006d12:	c918                	sw	a4,16(a0)
80006d14:	49d8                	lw	a4,20(a1)
80006d16:	c958                	sw	a4,20(a0)
80006d18:	4d98                	lw	a4,24(a1)
80006d1a:	cd18                	sw	a4,24(a0)
80006d1c:	4dd8                	lw	a4,28(a1)
80006d1e:	cd58                	sw	a4,28(a0)
80006d20:	9536                	add	a0,a0,a3
80006d22:	95b6                	add	a1,a1,a3
80006d24:	8e15                	sub	a2,a2,a3
80006d26:	fcd67de3          	bgeu	a2,a3,80006d00 <.Lmemcpy_aligned_block_copy_loop>

80006d2a <.Lmemcpy_word_copy>:
80006d2a:	c605                	beqz	a2,80006d52 <.Lmemcpy_memcpy_end>
80006d2c:	4691                	li	a3,4
80006d2e:	00d66963          	bltu	a2,a3,80006d40 <.Lmemcpy_byte_copy>

80006d32 <.Lmemcpy_word_copy_loop>:
80006d32:	4198                	lw	a4,0(a1)
80006d34:	c118                	sw	a4,0(a0)
80006d36:	9536                	add	a0,a0,a3
80006d38:	95b6                	add	a1,a1,a3
80006d3a:	8e15                	sub	a2,a2,a3
80006d3c:	fed67be3          	bgeu	a2,a3,80006d32 <.Lmemcpy_word_copy_loop>

80006d40 <.Lmemcpy_byte_copy>:
80006d40:	ca09                	beqz	a2,80006d52 <.Lmemcpy_memcpy_end>

80006d42 <.Lmemcpy_byte_copy_loop>:
80006d42:	00058703          	lb	a4,0(a1)
80006d46:	00e50023          	sb	a4,0(a0)
80006d4a:	0585                	add	a1,a1,1
80006d4c:	0505                	add	a0,a0,1
80006d4e:	167d                	add	a2,a2,-1
80006d50:	fa6d                	bnez	a2,80006d42 <.Lmemcpy_byte_copy_loop>

80006d52 <.Lmemcpy_memcpy_end>:
80006d52:	853e                	mv	a0,a5

80006d54 <.Lmemcpy_done>:
80006d54:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

80006d56 <__SEGGER_RTL_pow10f>:
80006d56:	1101                	add	sp,sp,-32
80006d58:	cc22                	sw	s0,24(sp)
80006d5a:	c64e                	sw	s3,12(sp)
80006d5c:	ce06                	sw	ra,28(sp)
80006d5e:	ca26                	sw	s1,20(sp)
80006d60:	c84a                	sw	s2,16(sp)
80006d62:	842a                	mv	s0,a0
80006d64:	4981                	li	s3,0
80006d66:	00055563          	bgez	a0,80006d70 <.L17>
80006d6a:	40a00433          	neg	s0,a0
80006d6e:	4985                	li	s3,1

80006d70 <.L17>:
80006d70:	4881a503          	lw	a0,1160(gp) # 80003d18 <.Lmerged_single+0x4>
80006d74:	25018493          	add	s1,gp,592 # 80003ae0 <__SEGGER_RTL_aPower2f>

80006d78 <.L18>:
80006d78:	ec19                	bnez	s0,80006d96 <.L20>
80006d7a:	00098763          	beqz	s3,80006d88 <.L16>
80006d7e:	85aa                	mv	a1,a0
80006d80:	4881a503          	lw	a0,1160(gp) # 80003d18 <.Lmerged_single+0x4>
80006d84:	5e0010ef          	jal	80008364 <__divsf3>

80006d88 <.L16>:
80006d88:	40f2                	lw	ra,28(sp)
80006d8a:	4462                	lw	s0,24(sp)
80006d8c:	44d2                	lw	s1,20(sp)
80006d8e:	4942                	lw	s2,16(sp)
80006d90:	49b2                	lw	s3,12(sp)
80006d92:	6105                	add	sp,sp,32
80006d94:	8082                	ret

80006d96 <.L20>:
80006d96:	00147793          	and	a5,s0,1
80006d9a:	c781                	beqz	a5,80006da2 <.L19>
80006d9c:	408c                	lw	a1,0(s1)
80006d9e:	516010ef          	jal	800082b4 <__mulsf3>

80006da2 <.L19>:
80006da2:	8405                	sra	s0,s0,0x1
80006da4:	0491                	add	s1,s1,4
80006da6:	bfc9                	j	80006d78 <.L18>

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80006da8 <__SEGGER_RTL_prin_flush>:
80006da8:	4950                	lw	a2,20(a0)
80006daa:	ce19                	beqz	a2,80006dc8 <.L20>
80006dac:	511c                	lw	a5,32(a0)
80006dae:	1141                	add	sp,sp,-16
80006db0:	c422                	sw	s0,8(sp)
80006db2:	c606                	sw	ra,12(sp)
80006db4:	842a                	mv	s0,a0
80006db6:	c399                	beqz	a5,80006dbc <.L12>
80006db8:	490c                	lw	a1,16(a0)
80006dba:	9782                	jalr	a5

80006dbc <.L12>:
80006dbc:	40b2                	lw	ra,12(sp)
80006dbe:	00042a23          	sw	zero,20(s0)
80006dc2:	4422                	lw	s0,8(sp)
80006dc4:	0141                	add	sp,sp,16
80006dc6:	8082                	ret

80006dc8 <.L20>:
80006dc8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80006dca <__SEGGER_RTL_pre_padding>:
80006dca:	0105f793          	and	a5,a1,16
80006dce:	eb91                	bnez	a5,80006de2 <.L40>
80006dd0:	2005f793          	and	a5,a1,512
80006dd4:	02000593          	li	a1,32
80006dd8:	c399                	beqz	a5,80006dde <.L42>
80006dda:	03000593          	li	a1,48

80006dde <.L42>:
80006dde:	2bb0106f          	j	80008898 <__SEGGER_RTL_print_padding>

80006de2 <.L40>:
80006de2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin_l:

80006de4 <__SEGGER_RTL_init_prin_l>:
80006de4:	1141                	add	sp,sp,-16
80006de6:	c226                	sw	s1,4(sp)
80006de8:	02400613          	li	a2,36
80006dec:	84ae                	mv	s1,a1
80006dee:	4581                	li	a1,0
80006df0:	c422                	sw	s0,8(sp)
80006df2:	c606                	sw	ra,12(sp)
80006df4:	842a                	mv	s0,a0
80006df6:	093010ef          	jal	80008688 <memset>
80006dfa:	40b2                	lw	ra,12(sp)
80006dfc:	cc44                	sw	s1,28(s0)
80006dfe:	4422                	lw	s0,8(sp)
80006e00:	4492                	lw	s1,4(sp)
80006e02:	0141                	add	sp,sp,16
80006e04:	8082                	ret

Disassembly of section .text.libc.vfprintf:

80006e06 <vfprintf>:
80006e06:	1101                	add	sp,sp,-32
80006e08:	cc22                	sw	s0,24(sp)
80006e0a:	ca26                	sw	s1,20(sp)
80006e0c:	ce06                	sw	ra,28(sp)
80006e0e:	84ae                	mv	s1,a1
80006e10:	842a                	mv	s0,a0
80006e12:	c632                	sw	a2,12(sp)
80006e14:	7ec020ef          	jal	80009600 <__SEGGER_RTL_current_locale>
80006e18:	85aa                	mv	a1,a0
80006e1a:	8522                	mv	a0,s0
80006e1c:	4462                	lw	s0,24(sp)
80006e1e:	46b2                	lw	a3,12(sp)
80006e20:	40f2                	lw	ra,28(sp)
80006e22:	8626                	mv	a2,s1
80006e24:	44d2                	lw	s1,20(sp)
80006e26:	6105                	add	sp,sp,32
80006e28:	29b0106f          	j	800088c2 <vfprintf_l>

Disassembly of section .text.libc.printf:

80006e2c <printf>:
80006e2c:	7139                	add	sp,sp,-64
80006e2e:	da3e                	sw	a5,52(sp)
80006e30:	012007b7          	lui	a5,0x1200
80006e34:	d22e                	sw	a1,36(sp)
80006e36:	85aa                	mv	a1,a0
80006e38:	0447a503          	lw	a0,68(a5) # 1200044 <stdout>
80006e3c:	d432                	sw	a2,40(sp)
80006e3e:	1050                	add	a2,sp,36
80006e40:	ce06                	sw	ra,28(sp)
80006e42:	d636                	sw	a3,44(sp)
80006e44:	d83a                	sw	a4,48(sp)
80006e46:	dc42                	sw	a6,56(sp)
80006e48:	de46                	sw	a7,60(sp)
80006e4a:	c632                	sw	a2,12(sp)
80006e4c:	3f6d                	jal	80006e06 <vfprintf>
80006e4e:	40f2                	lw	ra,28(sp)
80006e50:	6121                	add	sp,sp,64
80006e52:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

80006e54 <__SEGGER_init_heap>:
80006e54:	00200537          	lui	a0,0x200
80006e58:	00050513          	mv	a0,a0
80006e5c:	002045b7          	lui	a1,0x204
80006e60:	00058593          	mv	a1,a1
80006e64:	8d89                	sub	a1,a1,a0
80006e66:	a009                	j	80006e68 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

80006e68 <__SEGGER_RTL_init_heap>:
80006e68:	479d                	li	a5,7
80006e6a:	00b7f963          	bgeu	a5,a1,80006e7c <.L68>
80006e6e:	012007b7          	lui	a5,0x1200
80006e72:	04a7a023          	sw	a0,64(a5) # 1200040 <__SEGGER_RTL_heap_globals>
80006e76:	00052023          	sw	zero,0(a0) # 200000 <__DLM_segment_start__>
80006e7a:	c14c                	sw	a1,4(a0)

80006e7c <.L68>:
80006e7c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

80006e7e <__SEGGER_RTL_ascii_toupper>:
80006e7e:	f9f50713          	add	a4,a0,-97
80006e82:	47e5                	li	a5,25
80006e84:	00e7e363          	bltu	a5,a4,80006e8a <.L5>
80006e88:	1501                	add	a0,a0,-32

80006e8a <.L5>:
80006e8a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

80006e8c <__SEGGER_RTL_ascii_towupper>:
80006e8c:	f9f50713          	add	a4,a0,-97
80006e90:	47e5                	li	a5,25
80006e92:	00e7e363          	bltu	a5,a4,80006e98 <.L12>
80006e96:	1501                	add	a0,a0,-32

80006e98 <.L12>:
80006e98:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

80006e9a <__SEGGER_RTL_ascii_mbtowc>:
80006e9a:	87aa                	mv	a5,a0
80006e9c:	4501                	li	a0,0
80006e9e:	c195                	beqz	a1,80006ec2 <.L55>
80006ea0:	c20d                	beqz	a2,80006ec2 <.L55>
80006ea2:	0005c703          	lbu	a4,0(a1) # 204000 <__heap_end__>
80006ea6:	07f00613          	li	a2,127
80006eaa:	5579                	li	a0,-2
80006eac:	00e66b63          	bltu	a2,a4,80006ec2 <.L55>
80006eb0:	c391                	beqz	a5,80006eb4 <.L57>
80006eb2:	c398                	sw	a4,0(a5)

80006eb4 <.L57>:
80006eb4:	0006a023          	sw	zero,0(a3)
80006eb8:	0006a223          	sw	zero,4(a3)
80006ebc:	00e03533          	snez	a0,a4
80006ec0:	8082                	ret

80006ec2 <.L55>:
80006ec2:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

80006ec4 <l1c_dc_invalidate_all>:
{
80006ec4:	1141                	add	sp,sp,-16
80006ec6:	47dd                	li	a5,23
80006ec8:	00f107a3          	sb	a5,15(sp)

80006ecc <.LBB68>:
}

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
80006ecc:	00f14783          	lbu	a5,15(sp)
80006ed0:	7cc79073          	csrw	0x7cc,a5
}
80006ed4:	0001                	nop

80006ed6 <.LBE68>:
}
80006ed6:	0001                	nop
80006ed8:	0141                	add	sp,sp,16
80006eda:	8082                	ret

Disassembly of section .text.gptmr_check_status:

80006edc <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
80006edc:	1141                	add	sp,sp,-16
80006ede:	c62a                	sw	a0,12(sp)
80006ee0:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
80006ee2:	47b2                	lw	a5,12(sp)
80006ee4:	2007a703          	lw	a4,512(a5)
80006ee8:	47a2                	lw	a5,8(sp)
80006eea:	8ff9                	and	a5,a5,a4
80006eec:	4722                	lw	a4,8(sp)
80006eee:	40f707b3          	sub	a5,a4,a5
80006ef2:	0017b793          	seqz	a5,a5
80006ef6:	0ff7f793          	zext.b	a5,a5
}
80006efa:	853e                	mv	a0,a5
80006efc:	0141                	add	sp,sp,16
80006efe:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

80006f00 <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
80006f00:	1141                	add	sp,sp,-16
80006f02:	c62a                	sw	a0,12(sp)
80006f04:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
80006f06:	47b2                	lw	a5,12(sp)
80006f08:	4722                	lw	a4,8(sp)
80006f0a:	20e7a023          	sw	a4,512(a5)
}
80006f0e:	0001                	nop
80006f10:	0141                	add	sp,sp,16
80006f12:	8082                	ret

Disassembly of section .text.board_init_console:

80006f14 <board_init_console>:
{
80006f14:	1101                	add	sp,sp,-32
80006f16:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
80006f18:	f0040537          	lui	a0,0xf0040
80006f1c:	2455                	jal	800071c0 <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
80006f1e:	4581                	li	a1,0
80006f20:	012107b7          	lui	a5,0x1210
80006f24:	02178513          	add	a0,a5,33 # 1210021 <__AXI_SRAM_segment_used_end__+0xffd9>
80006f28:	d6dfe0ef          	jal	80005c94 <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
80006f2c:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t) BOARD_CONSOLE_UART_BASE;
80006f2e:	f00407b7          	lui	a5,0xf0040
80006f32:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
80006f34:	012107b7          	lui	a5,0x1210
80006f38:	02178513          	add	a0,a5,33 # 1210021 <__AXI_SRAM_segment_used_end__+0xffd9>
80006f3c:	609000ef          	jal	80007d44 <clock_get_frequency>
80006f40:	87aa                	mv	a5,a0
80006f42:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
80006f44:	67f1                	lui	a5,0x1c
80006f46:	20078793          	add	a5,a5,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80006f4a:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
80006f4c:	878a                	mv	a5,sp
80006f4e:	853e                	mv	a0,a5
80006f50:	2605                	jal	80007270 <console_init>
80006f52:	87aa                	mv	a5,a0
80006f54:	c391                	beqz	a5,80006f58 <.L48>

80006f56 <.L47>:
        while (1) {
80006f56:	a001                	j	80006f56 <.L47>

80006f58 <.L48>:
}
80006f58:	0001                	nop
80006f5a:	40f2                	lw	ra,28(sp)
80006f5c:	6105                	add	sp,sp,32
80006f5e:	8082                	ret

Disassembly of section .text.board_print_clock_freq:

80006f60 <board_print_clock_freq>:
{
80006f60:	1141                	add	sp,sp,-16
80006f62:	c606                	sw	ra,12(sp)
    printf("==============================\n");
80006f64:	1d820513          	add	a0,tp,472 # 1d8 <__BOOT_HEADER_segment_used_size__+0x148>
80006f68:	35d1                	jal	80006e2c <printf>
    printf(" %s clock summary\n", BOARD_NAME);
80006f6a:	1f820593          	add	a1,tp,504 # 1f8 <__BOOT_HEADER_segment_used_size__+0x168>
80006f6e:	20420513          	add	a0,tp,516 # 204 <__BOOT_HEADER_segment_used_size__+0x174>
80006f72:	3d6d                	jal	80006e2c <printf>
    printf("==============================\n");
80006f74:	1d820513          	add	a0,tp,472 # 1d8 <__BOOT_HEADER_segment_used_size__+0x148>
80006f78:	3d55                	jal	80006e2c <printf>
    printf("cpu0:\t\t %dHz\n", clock_get_frequency(clock_cpu0));
80006f7a:	4501                	li	a0,0
80006f7c:	5c9000ef          	jal	80007d44 <clock_get_frequency>
80006f80:	87aa                	mv	a5,a0
80006f82:	85be                	mv	a1,a5
80006f84:	21820513          	add	a0,tp,536 # 218 <__BOOT_HEADER_segment_used_size__+0x188>
80006f88:	3555                	jal	80006e2c <printf>
    printf("cpu1:\t\t %dHz\n", clock_get_frequency(clock_cpu1));
80006f8a:	000807b7          	lui	a5,0x80
80006f8e:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
80006f92:	5b3000ef          	jal	80007d44 <clock_get_frequency>
80006f96:	87aa                	mv	a5,a0
80006f98:	85be                	mv	a1,a5
80006f9a:	22820513          	add	a0,tp,552 # 228 <__BOOT_HEADER_segment_used_size__+0x198>
80006f9e:	3579                	jal	80006e2c <printf>
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb0));
80006fa0:	010007b7          	lui	a5,0x1000
80006fa4:	00478513          	add	a0,a5,4 # 1000004 <_flash_size+0x4>
80006fa8:	59d000ef          	jal	80007d44 <clock_get_frequency>
80006fac:	87aa                	mv	a5,a0
80006fae:	85be                	mv	a1,a5
80006fb0:	23820513          	add	a0,tp,568 # 238 <__BOOT_HEADER_segment_used_size__+0x1a8>
80006fb4:	3da5                	jal	80006e2c <printf>
    printf("axif:\t\t %dHz\n", clock_get_frequency(clock_axif));
80006fb6:	77c1                	lui	a5,0xffff0
80006fb8:	00578513          	add	a0,a5,5 # ffff0005 <__AHB_SRAM_segment_end__+0xfde8005>
80006fbc:	589000ef          	jal	80007d44 <clock_get_frequency>
80006fc0:	87aa                	mv	a5,a0
80006fc2:	85be                	mv	a1,a5
80006fc4:	24820513          	add	a0,tp,584 # 248 <__BOOT_HEADER_segment_used_size__+0x1b8>
80006fc8:	3595                	jal	80006e2c <printf>
    printf("axis:\t\t %dHz\n", clock_get_frequency(clock_axis));
80006fca:	010107b7          	lui	a5,0x1010
80006fce:	00678513          	add	a0,a5,6 # 1010006 <_flash_size+0x10006>
80006fd2:	573000ef          	jal	80007d44 <clock_get_frequency>
80006fd6:	87aa                	mv	a5,a0
80006fd8:	85be                	mv	a1,a5
80006fda:	25820513          	add	a0,tp,600 # 258 <__BOOT_HEADER_segment_used_size__+0x1c8>
80006fde:	35b9                	jal	80006e2c <printf>
    printf("axic:\t\t %dHz\n", clock_get_frequency(clock_axic));
80006fe0:	010207b7          	lui	a5,0x1020
80006fe4:	00778513          	add	a0,a5,7 # 1020007 <_flash_size+0x20007>
80006fe8:	55d000ef          	jal	80007d44 <clock_get_frequency>
80006fec:	87aa                	mv	a5,a0
80006fee:	85be                	mv	a1,a5
80006ff0:	26820513          	add	a0,tp,616 # 268 <__BOOT_HEADER_segment_used_size__+0x1d8>
80006ff4:	3d25                	jal	80006e2c <printf>
    printf("axin:\t\t %dHz\n", clock_get_frequency(clock_axin));
80006ff6:	010307b7          	lui	a5,0x1030
80006ffa:	00878513          	add	a0,a5,8 # 1030008 <_flash_size+0x30008>
80006ffe:	547000ef          	jal	80007d44 <clock_get_frequency>
80007002:	87aa                	mv	a5,a0
80007004:	85be                	mv	a1,a5
80007006:	27820513          	add	a0,tp,632 # 278 <__BOOT_HEADER_segment_used_size__+0x1e8>
8000700a:	350d                	jal	80006e2c <printf>
    printf("xpi0:\t\t %dHz\n", clock_get_frequency(clock_xpi0));
8000700c:	016f07b7          	lui	a5,0x16f0
80007010:	03f78513          	add	a0,a5,63 # 16f003f <__SHARE_RAM_segment_end__+0x3f003f>
80007014:	531000ef          	jal	80007d44 <clock_get_frequency>
80007018:	87aa                	mv	a5,a0
8000701a:	85be                	mv	a1,a5
8000701c:	28820513          	add	a0,tp,648 # 288 <default_irq_s_handler>
80007020:	3531                	jal	80006e2c <printf>
    printf("femc:\t\t %luHz\n", clock_get_frequency(clock_femc));
80007022:	017007b7          	lui	a5,0x1700
80007026:	04078513          	add	a0,a5,64 # 1700040 <__SHARE_RAM_segment_end__+0x400040>
8000702a:	51b000ef          	jal	80007d44 <clock_get_frequency>
8000702e:	87aa                	mv	a5,a0
80007030:	85be                	mv	a1,a5
80007032:	29820513          	add	a0,tp,664 # 298 <board_timer_isr+0xc>
80007036:	3bdd                	jal	80006e2c <printf>
    printf("mchtmr0:\t %dHz\n", clock_get_frequency(clock_mchtmr0));
80007038:	010607b7          	lui	a5,0x1060
8000703c:	00178513          	add	a0,a5,1 # 1060001 <_flash_size+0x60001>
80007040:	505000ef          	jal	80007d44 <clock_get_frequency>
80007044:	87aa                	mv	a5,a0
80007046:	85be                	mv	a1,a5
80007048:	2a820513          	add	a0,tp,680 # 2a8 <board_timer_isr+0x1c>
8000704c:	33c5                	jal	80006e2c <printf>
    printf("mchtmr1:\t %dHz\n", clock_get_frequency(clock_mchtmr1));
8000704e:	010807b7          	lui	a5,0x1080
80007052:	00378513          	add	a0,a5,3 # 1080003 <_flash_size+0x80003>
80007056:	4ef000ef          	jal	80007d44 <clock_get_frequency>
8000705a:	87aa                	mv	a5,a0
8000705c:	85be                	mv	a1,a5
8000705e:	2b820513          	add	a0,tp,696 # 2b8 <board_timer_isr+0x2c>
80007062:	33e9                	jal	80006e2c <printf>
    printf("==============================\n");
80007064:	1d820513          	add	a0,tp,472 # 1d8 <__BOOT_HEADER_segment_used_size__+0x148>
80007068:	33d1                	jal	80006e2c <printf>
}
8000706a:	0001                	nop
8000706c:	40b2                	lw	ra,12(sp)
8000706e:	0141                	add	sp,sp,16
80007070:	8082                	ret

Disassembly of section .text.board_turnoff_rgb_led:

80007072 <board_turnoff_rgb_led>:
{
80007072:	1141                	add	sp,sp,-16
    uint32_t pad_ctl = IOC_PAD_PAD_CTL_PE_SET(1) | IOC_PAD_PAD_CTL_PS_SET(BOARD_LED_OFF_LEVEL);
80007074:	000207b7          	lui	a5,0x20
80007078:	c63e                	sw	a5,12(sp)
    HPM_IOC->PAD[IOC_PAD_PE14].FUNC_CTL = IOC_PE14_FUNC_CTL_GPIO_E_14;
8000707a:	f40407b7          	lui	a5,0xf4040
8000707e:	4607a823          	sw	zero,1136(a5) # f4040470 <__AHB_SRAM_segment_end__+0x3e38470>
    HPM_IOC->PAD[IOC_PAD_PE15].FUNC_CTL = IOC_PE15_FUNC_CTL_GPIO_E_15;
80007082:	f40407b7          	lui	a5,0xf4040
80007086:	4607ac23          	sw	zero,1144(a5) # f4040478 <__AHB_SRAM_segment_end__+0x3e38478>
    HPM_IOC->PAD[IOC_PAD_PE04].FUNC_CTL = IOC_PE04_FUNC_CTL_GPIO_E_04;
8000708a:	f40407b7          	lui	a5,0xf4040
8000708e:	4207a023          	sw	zero,1056(a5) # f4040420 <__AHB_SRAM_segment_end__+0x3e38420>
    HPM_IOC->PAD[IOC_PAD_PE14].PAD_CTL = pad_ctl;
80007092:	f40407b7          	lui	a5,0xf4040
80007096:	4732                	lw	a4,12(sp)
80007098:	46e7aa23          	sw	a4,1140(a5) # f4040474 <__AHB_SRAM_segment_end__+0x3e38474>
    HPM_IOC->PAD[IOC_PAD_PE15].PAD_CTL = pad_ctl;
8000709c:	f40407b7          	lui	a5,0xf4040
800070a0:	4732                	lw	a4,12(sp)
800070a2:	46e7ae23          	sw	a4,1148(a5) # f404047c <__AHB_SRAM_segment_end__+0x3e3847c>
    HPM_IOC->PAD[IOC_PAD_PE04].PAD_CTL = pad_ctl;
800070a6:	f40407b7          	lui	a5,0xf4040
800070aa:	4732                	lw	a4,12(sp)
800070ac:	42e7a223          	sw	a4,1060(a5) # f4040424 <__AHB_SRAM_segment_end__+0x3e38424>
}
800070b0:	0001                	nop
800070b2:	0141                	add	sp,sp,16
800070b4:	8082                	ret

Disassembly of section .text.board_init:

800070b6 <board_init>:
{
800070b6:	1141                	add	sp,sp,-16
800070b8:	c606                	sw	ra,12(sp)
    board_turnoff_rgb_led();
800070ba:	3f65                	jal	80007072 <board_turnoff_rgb_led>
    board_init_clock();
800070bc:	88afd0ef          	jal	80004146 <board_init_clock>
    board_init_console();
800070c0:	3d91                	jal	80006f14 <board_init_console>
    board_init_pmp();
800070c2:	e39fc0ef          	jal	80003efa <board_init_pmp>
    board_print_clock_freq();
800070c6:	3d69                	jal	80006f60 <board_print_clock_freq>
    board_print_banner();
800070c8:	dfbfc0ef          	jal	80003ec2 <board_print_banner>
}
800070cc:	0001                	nop
800070ce:	40b2                	lw	ra,12(sp)
800070d0:	0141                	add	sp,sp,16
800070d2:	8082                	ret

Disassembly of section .text.board_delay_ms:

800070d4 <board_delay_ms>:
{
800070d4:	1101                	add	sp,sp,-32
800070d6:	ce06                	sw	ra,28(sp)
800070d8:	c62a                	sw	a0,12(sp)
    clock_cpu_delay_ms(ms);
800070da:	4532                	lw	a0,12(sp)
800070dc:	bf3fe0ef          	jal	80005cce <clock_cpu_delay_ms>
}
800070e0:	0001                	nop
800070e2:	40f2                	lw	ra,28(sp)
800070e4:	6105                	add	sp,sp,32
800070e6:	8082                	ret

Disassembly of section .text.board_init_spi_clock:

800070e8 <board_init_spi_clock>:
{
800070e8:	1101                	add	sp,sp,-32
800070ea:	ce06                	sw	ra,28(sp)
800070ec:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_SPI1) {
800070ee:	4732                	lw	a4,12(sp)
800070f0:	f00747b7          	lui	a5,0xf0074
800070f4:	02f71163          	bne	a4,a5,80007116 <.L87>
        clock_add_to_group(clock_spi1, 0);
800070f8:	4581                	li	a1,0
800070fa:	011a07b7          	lui	a5,0x11a0
800070fe:	01a78513          	add	a0,a5,26 # 11a001a <_flash_size+0x1a001a>
80007102:	b93fe0ef          	jal	80005c94 <clock_add_to_group>
        return clock_get_frequency(clock_spi1);
80007106:	011a07b7          	lui	a5,0x11a0
8000710a:	01a78513          	add	a0,a5,26 # 11a001a <_flash_size+0x1a001a>
8000710e:	437000ef          	jal	80007d44 <clock_get_frequency>
80007112:	87aa                	mv	a5,a0
80007114:	a055                	j	800071b8 <.L88>

80007116 <.L87>:
    } else if (ptr == HPM_SPI3) {
80007116:	4732                	lw	a4,12(sp)
80007118:	f007c7b7          	lui	a5,0xf007c
8000711c:	02f71163          	bne	a4,a5,8000713e <.L89>
        clock_add_to_group(clock_spi3, 0);
80007120:	4581                	li	a1,0
80007122:	011c07b7          	lui	a5,0x11c0
80007126:	01c78513          	add	a0,a5,28 # 11c001c <_flash_size+0x1c001c>
8000712a:	b6bfe0ef          	jal	80005c94 <clock_add_to_group>
        return clock_get_frequency(clock_spi3);
8000712e:	011c07b7          	lui	a5,0x11c0
80007132:	01c78513          	add	a0,a5,28 # 11c001c <_flash_size+0x1c001c>
80007136:	40f000ef          	jal	80007d44 <clock_get_frequency>
8000713a:	87aa                	mv	a5,a0
8000713c:	a8b5                	j	800071b8 <.L88>

8000713e <.L89>:
    } else if (ptr == HPM_SPI6) {
8000713e:	4732                	lw	a4,12(sp)
80007140:	f01b87b7          	lui	a5,0xf01b8
80007144:	02f71163          	bne	a4,a5,80007166 <.L90>
        clock_add_to_group(clock_spi6, 0);
80007148:	4581                	li	a1,0
8000714a:	011f07b7          	lui	a5,0x11f0
8000714e:	01f78513          	add	a0,a5,31 # 11f001f <_flash_size+0x1f001f>
80007152:	b43fe0ef          	jal	80005c94 <clock_add_to_group>
        return clock_get_frequency(clock_spi6);
80007156:	011f07b7          	lui	a5,0x11f0
8000715a:	01f78513          	add	a0,a5,31 # 11f001f <_flash_size+0x1f001f>
8000715e:	3e7000ef          	jal	80007d44 <clock_get_frequency>
80007162:	87aa                	mv	a5,a0
80007164:	a891                	j	800071b8 <.L88>

80007166 <.L90>:
    } else if (ptr == HPM_SPI7) {
80007166:	4732                	lw	a4,12(sp)
80007168:	f01bc7b7          	lui	a5,0xf01bc
8000716c:	02f71163          	bne	a4,a5,8000718e <.L91>
        clock_add_to_group(clock_spi7, 0);
80007170:	4581                	li	a1,0
80007172:	012007b7          	lui	a5,0x1200
80007176:	02078513          	add	a0,a5,32 # 1200020 <__SEGGER_RTL_aSigTab+0xc>
8000717a:	b1bfe0ef          	jal	80005c94 <clock_add_to_group>
        return clock_get_frequency(clock_spi7);
8000717e:	012007b7          	lui	a5,0x1200
80007182:	02078513          	add	a0,a5,32 # 1200020 <__SEGGER_RTL_aSigTab+0xc>
80007186:	3bf000ef          	jal	80007d44 <clock_get_frequency>
8000718a:	87aa                	mv	a5,a0
8000718c:	a035                	j	800071b8 <.L88>

8000718e <.L91>:
    } else if (ptr == HPM_SPI2){
8000718e:	4732                	lw	a4,12(sp)
80007190:	f00787b7          	lui	a5,0xf0078
80007194:	02f71163          	bne	a4,a5,800071b6 <.L92>
        clock_add_to_group(clock_spi2, 0);
80007198:	4581                	li	a1,0
8000719a:	011b07b7          	lui	a5,0x11b0
8000719e:	01b78513          	add	a0,a5,27 # 11b001b <_flash_size+0x1b001b>
800071a2:	af3fe0ef          	jal	80005c94 <clock_add_to_group>
        return  clock_get_frequency(clock_spi2);
800071a6:	011b07b7          	lui	a5,0x11b0
800071aa:	01b78513          	add	a0,a5,27 # 11b001b <_flash_size+0x1b001b>
800071ae:	397000ef          	jal	80007d44 <clock_get_frequency>
800071b2:	87aa                	mv	a5,a0
800071b4:	a011                	j	800071b8 <.L88>

800071b6 <.L92>:
    return  0;
800071b6:	4781                	li	a5,0

800071b8 <.L88>:
}
800071b8:	853e                	mv	a0,a5
800071ba:	40f2                	lw	ra,28(sp)
800071bc:	6105                	add	sp,sp,32
800071be:	8082                	ret

Disassembly of section .text.init_uart_pins:

800071c0 <init_uart_pins>:
 *
 */
#include "board.h"

void init_uart_pins(UART_Type *ptr)
{
800071c0:	1141                	add	sp,sp,-16
800071c2:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
800071c4:	4732                	lw	a4,12(sp)
800071c6:	f00407b7          	lui	a5,0xf0040
800071ca:	00f71b63          	bne	a4,a5,800071e0 <.L2>
        HPM_IOC->PAD[IOC_PAD_PA00].FUNC_CTL = IOC_PA00_FUNC_CTL_UART0_TXD;
800071ce:	f40407b7          	lui	a5,0xf4040
800071d2:	4709                	li	a4,2
800071d4:	c398                	sw	a4,0(a5)
        HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
800071d6:	f40407b7          	lui	a5,0xf4040
800071da:	4709                	li	a4,2
800071dc:	c798                	sw	a4,8(a5)
        HPM_PIOC->PAD[IOC_PAD_PY00].FUNC_CTL = PIOC_PY00_FUNC_CTL_PURT_TXD;
        HPM_PIOC->PAD[IOC_PAD_PY01].FUNC_CTL = PIOC_PY01_FUNC_CTL_PURT_RXD;
    } else {
        ;
    }
}
800071de:	a071                	j	8000726a <.L6>

800071e0 <.L2>:
    } else if (ptr == HPM_UART1) {
800071e0:	4732                	lw	a4,12(sp)
800071e2:	f00447b7          	lui	a5,0xf0044
800071e6:	02f71f63          	bne	a4,a5,80007224 <.L4>
        HPM_IOC->PAD[IOC_PAD_PY07].FUNC_CTL = IOC_PY07_FUNC_CTL_UART1_TXD;
800071ea:	f4040737          	lui	a4,0xf4040
800071ee:	6785                	lui	a5,0x1
800071f0:	97ba                	add	a5,a5,a4
800071f2:	4709                	li	a4,2
800071f4:	e2e7ac23          	sw	a4,-456(a5) # e38 <__NOR_CFG_OPTION_segment_size__+0x238>
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_SOC_PY_07;
800071f8:	f4118737          	lui	a4,0xf4118
800071fc:	6785                	lui	a5,0x1
800071fe:	97ba                	add	a5,a5,a4
80007200:	470d                	li	a4,3
80007202:	e2e7ac23          	sw	a4,-456(a5) # e38 <__NOR_CFG_OPTION_segment_size__+0x238>
        HPM_IOC->PAD[IOC_PAD_PY06].FUNC_CTL = IOC_PY06_FUNC_CTL_UART1_RXD;
80007206:	f4040737          	lui	a4,0xf4040
8000720a:	6785                	lui	a5,0x1
8000720c:	97ba                	add	a5,a5,a4
8000720e:	4709                	li	a4,2
80007210:	e2e7a823          	sw	a4,-464(a5) # e30 <__NOR_CFG_OPTION_segment_size__+0x230>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_SOC_PY_06;
80007214:	f4118737          	lui	a4,0xf4118
80007218:	6785                	lui	a5,0x1
8000721a:	97ba                	add	a5,a5,a4
8000721c:	470d                	li	a4,3
8000721e:	e2e7a823          	sw	a4,-464(a5) # e30 <__NOR_CFG_OPTION_segment_size__+0x230>
}
80007222:	a0a1                	j	8000726a <.L6>

80007224 <.L4>:
    } else if (ptr == HPM_UART14) {
80007224:	4732                	lw	a4,12(sp)
80007226:	f01987b7          	lui	a5,0xf0198
8000722a:	00f71d63          	bne	a4,a5,80007244 <.L5>
        HPM_IOC->PAD[IOC_PAD_PF24].FUNC_CTL = IOC_PF24_FUNC_CTL_UART14_TXD;
8000722e:	f40407b7          	lui	a5,0xf4040
80007232:	4709                	li	a4,2
80007234:	5ce7a023          	sw	a4,1472(a5) # f40405c0 <__AHB_SRAM_segment_end__+0x3e385c0>
        HPM_IOC->PAD[IOC_PAD_PF25].FUNC_CTL = IOC_PF25_FUNC_CTL_UART14_RXD;
80007238:	f40407b7          	lui	a5,0xf4040
8000723c:	4709                	li	a4,2
8000723e:	5ce7a423          	sw	a4,1480(a5) # f40405c8 <__AHB_SRAM_segment_end__+0x3e385c8>
}
80007242:	a025                	j	8000726a <.L6>

80007244 <.L5>:
    } else if (ptr == HPM_PUART) {
80007244:	4732                	lw	a4,12(sp)
80007246:	f41247b7          	lui	a5,0xf4124
8000724a:	02f71063          	bne	a4,a5,8000726a <.L6>
        HPM_PIOC->PAD[IOC_PAD_PY00].FUNC_CTL = PIOC_PY00_FUNC_CTL_PURT_TXD;
8000724e:	f4118737          	lui	a4,0xf4118
80007252:	6785                	lui	a5,0x1
80007254:	97ba                	add	a5,a5,a4
80007256:	4705                	li	a4,1
80007258:	e0e7a023          	sw	a4,-512(a5) # e00 <__NOR_CFG_OPTION_segment_size__+0x200>
        HPM_PIOC->PAD[IOC_PAD_PY01].FUNC_CTL = PIOC_PY01_FUNC_CTL_PURT_RXD;
8000725c:	f4118737          	lui	a4,0xf4118
80007260:	6785                	lui	a5,0x1
80007262:	97ba                	add	a5,a5,a4
80007264:	4705                	li	a4,1
80007266:	e0e7a423          	sw	a4,-504(a5) # e08 <__NOR_CFG_OPTION_segment_size__+0x208>

8000726a <.L6>:
}
8000726a:	0001                	nop
8000726c:	0141                	add	sp,sp,16
8000726e:	8082                	ret

Disassembly of section .text.console_init:

80007270 <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
80007270:	7139                	add	sp,sp,-64
80007272:	de06                	sw	ra,60(sp)
80007274:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
80007276:	4785                	li	a5,1
80007278:	d63e                	sw	a5,44(sp)

    if (cfg->type == CONSOLE_TYPE_UART) {
8000727a:	47b2                	lw	a5,12(sp)
8000727c:	439c                	lw	a5,0(a5)
8000727e:	e7b9                	bnez	a5,800072cc <.L2>

80007280 <.LBB2>:
        uart_config_t config = {0};
80007280:	c802                	sw	zero,16(sp)
80007282:	ca02                	sw	zero,20(sp)
80007284:	cc02                	sw	zero,24(sp)
80007286:	ce02                	sw	zero,28(sp)
80007288:	d002                	sw	zero,32(sp)
8000728a:	d202                	sw	zero,36(sp)
8000728c:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
8000728e:	47b2                	lw	a5,12(sp)
80007290:	43dc                	lw	a5,4(a5)
80007292:	873e                	mv	a4,a5
80007294:	081c                	add	a5,sp,16
80007296:	85be                	mv	a1,a5
80007298:	853a                	mv	a0,a4
8000729a:	23e1                	jal	80007862 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
8000729c:	47b2                	lw	a5,12(sp)
8000729e:	479c                	lw	a5,8(a5)
800072a0:	c83e                	sw	a5,16(sp)
        config.baudrate = cfg->baudrate;
800072a2:	47b2                	lw	a5,12(sp)
800072a4:	47dc                	lw	a5,12(a5)
800072a6:	ca3e                	sw	a5,20(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
800072a8:	47b2                	lw	a5,12(sp)
800072aa:	43dc                	lw	a5,4(a5)
800072ac:	873e                	mv	a4,a5
800072ae:	081c                	add	a5,sp,16
800072b0:	85be                	mv	a1,a5
800072b2:	853a                	mv	a0,a4
800072b4:	87cfe0ef          	jal	80005330 <uart_init>
800072b8:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
800072ba:	57b2                	lw	a5,44(sp)
800072bc:	eb81                	bnez	a5,800072cc <.L2>
            g_console_uart = (UART_Type *)cfg->base;
800072be:	47b2                	lw	a5,12(sp)
800072c0:	43dc                	lw	a5,4(a5)
800072c2:	873e                	mv	a4,a5
800072c4:	012007b7          	lui	a5,0x1200
800072c8:	02e7aa23          	sw	a4,52(a5) # 1200034 <g_console_uart>

800072cc <.L2>:
        }
    }

    return stat;
800072cc:	57b2                	lw	a5,44(sp)
}
800072ce:	853e                	mv	a0,a5
800072d0:	50f2                	lw	ra,60(sp)
800072d2:	6121                	add	sp,sp,64
800072d4:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

800072d6 <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
800072d6:	7179                	add	sp,sp,-48
800072d8:	d606                	sw	ra,44(sp)
800072da:	c62a                	sw	a0,12(sp)
800072dc:	c42e                	sw	a1,8(sp)
800072de:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
800072e0:	ce02                	sw	zero,28(sp)
800072e2:	a0b9                	j	80007330 <.L13>

800072e4 <.L17>:
        if (data[count] == '\n') {
800072e4:	4722                	lw	a4,8(sp)
800072e6:	47f2                	lw	a5,28(sp)
800072e8:	97ba                	add	a5,a5,a4
800072ea:	0007c703          	lbu	a4,0(a5)
800072ee:	47a9                	li	a5,10
800072f0:	00f71d63          	bne	a4,a5,8000730a <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
800072f4:	0001                	nop

800072f6 <.L15>:
800072f6:	012007b7          	lui	a5,0x1200
800072fa:	0347a783          	lw	a5,52(a5) # 1200034 <g_console_uart>
800072fe:	45b5                	li	a1,13
80007300:	853e                	mv	a0,a5
80007302:	9fafe0ef          	jal	800054fc <uart_send_byte>
80007306:	87aa                	mv	a5,a0
80007308:	f7fd                	bnez	a5,800072f6 <.L15>

8000730a <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
8000730a:	0001                	nop

8000730c <.L16>:
8000730c:	012007b7          	lui	a5,0x1200
80007310:	0347a683          	lw	a3,52(a5) # 1200034 <g_console_uart>
80007314:	4722                	lw	a4,8(sp)
80007316:	47f2                	lw	a5,28(sp)
80007318:	97ba                	add	a5,a5,a4
8000731a:	0007c783          	lbu	a5,0(a5)
8000731e:	85be                	mv	a1,a5
80007320:	8536                	mv	a0,a3
80007322:	9dafe0ef          	jal	800054fc <uart_send_byte>
80007326:	87aa                	mv	a5,a0
80007328:	f3f5                	bnez	a5,8000730c <.L16>
    for (count = 0; count < size; count++) {
8000732a:	47f2                	lw	a5,28(sp)
8000732c:	0785                	add	a5,a5,1
8000732e:	ce3e                	sw	a5,28(sp)

80007330 <.L13>:
80007330:	4772                	lw	a4,28(sp)
80007332:	4792                	lw	a5,4(sp)
80007334:	faf768e3          	bltu	a4,a5,800072e4 <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
80007338:	0001                	nop

8000733a <.L18>:
8000733a:	012007b7          	lui	a5,0x1200
8000733e:	0347a783          	lw	a5,52(a5) # 1200034 <g_console_uart>
80007342:	853e                	mv	a0,a5
80007344:	07f000ef          	jal	80007bc2 <uart_flush>
80007348:	87aa                	mv	a5,a0
8000734a:	fbe5                	bnez	a5,8000733a <.L18>
    }
    return count;
8000734c:	47f2                	lw	a5,28(sp)

}
8000734e:	853e                	mv	a0,a5
80007350:	50b2                	lw	ra,44(sp)
80007352:	6145                	add	sp,sp,48
80007354:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

80007356 <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
80007356:	1141                	add	sp,sp,-16
80007358:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
8000735a:	4781                	li	a5,0
}
8000735c:	853e                	mv	a0,a5
8000735e:	0141                	add	sp,sp,16
80007360:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

80007362 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
80007362:	1141                	add	sp,sp,-16
80007364:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
80007366:	4785                	li	a5,1
}
80007368:	853e                	mv	a0,a5
8000736a:	0141                	add	sp,sp,16
8000736c:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

8000736e <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
8000736e:	1101                	add	sp,sp,-32
80007370:	c62a                	sw	a0,12(sp)
80007372:	87ae                	mv	a5,a1
80007374:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80007378:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
8000737a:	00a15703          	lhu	a4,10(sp)
8000737e:	25700793          	li	a5,599
80007382:	00e7f863          	bgeu	a5,a4,80007392 <.L26>
80007386:	00a15703          	lhu	a4,10(sp)
8000738a:	55f00793          	li	a5,1375
8000738e:	00e7f463          	bgeu	a5,a4,80007396 <.L27>

80007392 <.L26>:
        return status_invalid_argument;
80007392:	4789                	li	a5,2
80007394:	a831                	j	800073b0 <.L28>

80007396 <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80007396:	47b2                	lw	a5,12(sp)
80007398:	4b98                	lw	a4,16(a5)
8000739a:	77fd                	lui	a5,0xfffff
8000739c:	8f7d                	and	a4,a4,a5
8000739e:	00a15683          	lhu	a3,10(sp)
800073a2:	6785                	lui	a5,0x1
800073a4:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
800073a6:	8ff5                	and	a5,a5,a3
800073a8:	8f5d                	or	a4,a4,a5
800073aa:	47b2                	lw	a5,12(sp)
800073ac:	cb98                	sw	a4,16(a5)
    return stat;
800073ae:	47f2                	lw	a5,28(sp)

800073b0 <.L28>:
}
800073b0:	853e                	mv	a0,a5
800073b2:	6105                	add	sp,sp,32
800073b4:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_postdiv_freq_in_hz:

800073b6 <pllctlv2_get_pll_postdiv_freq_in_hz>:

uint32_t pllctlv2_get_pll_postdiv_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
800073b6:	7179                	add	sp,sp,-48
800073b8:	d606                	sw	ra,44(sp)
800073ba:	c62a                	sw	a0,12(sp)
800073bc:	87ae                	mv	a5,a1
800073be:	8732                	mv	a4,a2
800073c0:	00f105a3          	sb	a5,11(sp)
800073c4:	87ba                	mv	a5,a4
800073c6:	00f10523          	sb	a5,10(sp)
    uint32_t postdiv_freq = 0;
800073ca:	ce02                	sw	zero,28(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
800073cc:	47b2                	lw	a5,12(sp)
800073ce:	c7ad                	beqz	a5,80007438 <.L43>
800073d0:	00b14703          	lbu	a4,11(sp)
800073d4:	4789                	li	a5,2
800073d6:	06e7e163          	bltu	a5,a4,80007438 <.L43>

800073da <.LBB4>:
        uint32_t postdiv = PLLCTLV2_PLL_DIV_DIV_GET(ptr->PLL[pll].DIV[clk]);
800073da:	00b14683          	lbu	a3,11(sp)
800073de:	00a14783          	lbu	a5,10(sp)
800073e2:	4732                	lw	a4,12(sp)
800073e4:	0696                	sll	a3,a3,0x5
800073e6:	97b6                	add	a5,a5,a3
800073e8:	03078793          	add	a5,a5,48
800073ec:	078a                	sll	a5,a5,0x2
800073ee:	97ba                	add	a5,a5,a4
800073f0:	439c                	lw	a5,0(a5)
800073f2:	03f7f793          	and	a5,a5,63
800073f6:	cc3e                	sw	a5,24(sp)
        uint32_t pll_freq = pllctlv2_get_pll_freq_in_hz(ptr, pll);
800073f8:	00b14783          	lbu	a5,11(sp)
800073fc:	85be                	mv	a1,a5
800073fe:	4532                	lw	a0,12(sp)
80007400:	83afd0ef          	jal	8000443a <pllctlv2_get_pll_freq_in_hz>
80007404:	ca2a                	sw	a0,20(sp)
        postdiv_freq = (uint32_t) (pll_freq / (100 + postdiv * 100 / 5U) * 100);
80007406:	4762                	lw	a4,24(sp)
80007408:	87ba                	mv	a5,a4
8000740a:	078a                	sll	a5,a5,0x2
8000740c:	97ba                	add	a5,a5,a4
8000740e:	00279713          	sll	a4,a5,0x2
80007412:	97ba                	add	a5,a5,a4
80007414:	078a                	sll	a5,a5,0x2
80007416:	873e                	mv	a4,a5
80007418:	4795                	li	a5,5
8000741a:	02f757b3          	divu	a5,a4,a5
8000741e:	06478793          	add	a5,a5,100
80007422:	4752                	lw	a4,20(sp)
80007424:	02f75733          	divu	a4,a4,a5
80007428:	87ba                	mv	a5,a4
8000742a:	078a                	sll	a5,a5,0x2
8000742c:	97ba                	add	a5,a5,a4
8000742e:	00279713          	sll	a4,a5,0x2
80007432:	97ba                	add	a5,a5,a4
80007434:	078a                	sll	a5,a5,0x2
80007436:	ce3e                	sw	a5,28(sp)

80007438 <.L43>:
    }

    return postdiv_freq;
80007438:	47f2                	lw	a5,28(sp)
}
8000743a:	853e                	mv	a0,a5
8000743c:	50b2                	lw	ra,44(sp)
8000743e:	6145                	add	sp,sp,48
80007440:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

80007442 <write_pmp_cfg>:
{
80007442:	1141                	add	sp,sp,-16
80007444:	c62a                	sw	a0,12(sp)
80007446:	c42e                	sw	a1,8(sp)
    switch (idx) {
80007448:	4722                	lw	a4,8(sp)
8000744a:	478d                	li	a5,3
8000744c:	04f70163          	beq	a4,a5,8000748e <.L11>
80007450:	4722                	lw	a4,8(sp)
80007452:	478d                	li	a5,3
80007454:	04e7e163          	bltu	a5,a4,80007496 <.L17>
80007458:	4722                	lw	a4,8(sp)
8000745a:	4789                	li	a5,2
8000745c:	02f70563          	beq	a4,a5,80007486 <.L13>
80007460:	4722                	lw	a4,8(sp)
80007462:	4789                	li	a5,2
80007464:	02e7e963          	bltu	a5,a4,80007496 <.L17>
80007468:	47a2                	lw	a5,8(sp)
8000746a:	c791                	beqz	a5,80007476 <.L14>
8000746c:	4722                	lw	a4,8(sp)
8000746e:	4785                	li	a5,1
80007470:	00f70763          	beq	a4,a5,8000747e <.L15>
        break;
80007474:	a00d                	j	80007496 <.L17>

80007476 <.L14>:
        write_csr(CSR_PMPCFG0, value);
80007476:	47b2                	lw	a5,12(sp)
80007478:	3a079073          	csrw	pmpcfg0,a5
        break;
8000747c:	a831                	j	80007498 <.L16>

8000747e <.L15>:
        write_csr(CSR_PMPCFG1, value);
8000747e:	47b2                	lw	a5,12(sp)
80007480:	3a179073          	csrw	pmpcfg1,a5
        break;
80007484:	a811                	j	80007498 <.L16>

80007486 <.L13>:
        write_csr(CSR_PMPCFG2, value);
80007486:	47b2                	lw	a5,12(sp)
80007488:	3a279073          	csrw	pmpcfg2,a5
        break;
8000748c:	a031                	j	80007498 <.L16>

8000748e <.L11>:
        write_csr(CSR_PMPCFG3, value);
8000748e:	47b2                	lw	a5,12(sp)
80007490:	3a379073          	csrw	pmpcfg3,a5
        break;
80007494:	a011                	j	80007498 <.L16>

80007496 <.L17>:
        break;
80007496:	0001                	nop

80007498 <.L16>:
}
80007498:	0001                	nop
8000749a:	0141                	add	sp,sp,16
8000749c:	8082                	ret

Disassembly of section .text.write_pma_cfg:

8000749e <write_pma_cfg>:
{
8000749e:	1141                	add	sp,sp,-16
800074a0:	c62a                	sw	a0,12(sp)
800074a2:	c42e                	sw	a1,8(sp)
    switch (idx) {
800074a4:	4722                	lw	a4,8(sp)
800074a6:	478d                	li	a5,3
800074a8:	04f70163          	beq	a4,a5,800074ea <.L81>
800074ac:	4722                	lw	a4,8(sp)
800074ae:	478d                	li	a5,3
800074b0:	04e7e163          	bltu	a5,a4,800074f2 <.L87>
800074b4:	4722                	lw	a4,8(sp)
800074b6:	4789                	li	a5,2
800074b8:	02f70563          	beq	a4,a5,800074e2 <.L83>
800074bc:	4722                	lw	a4,8(sp)
800074be:	4789                	li	a5,2
800074c0:	02e7e963          	bltu	a5,a4,800074f2 <.L87>
800074c4:	47a2                	lw	a5,8(sp)
800074c6:	c791                	beqz	a5,800074d2 <.L84>
800074c8:	4722                	lw	a4,8(sp)
800074ca:	4785                	li	a5,1
800074cc:	00f70763          	beq	a4,a5,800074da <.L85>
        break;
800074d0:	a00d                	j	800074f2 <.L87>

800074d2 <.L84>:
        write_csr(CSR_PMACFG0, value);
800074d2:	47b2                	lw	a5,12(sp)
800074d4:	bc079073          	csrw	0xbc0,a5
        break;
800074d8:	a831                	j	800074f4 <.L86>

800074da <.L85>:
        write_csr(CSR_PMACFG1, value);
800074da:	47b2                	lw	a5,12(sp)
800074dc:	bc179073          	csrw	0xbc1,a5
        break;
800074e0:	a811                	j	800074f4 <.L86>

800074e2 <.L83>:
        write_csr(CSR_PMACFG2, value);
800074e2:	47b2                	lw	a5,12(sp)
800074e4:	bc279073          	csrw	0xbc2,a5
        break;
800074e8:	a031                	j	800074f4 <.L86>

800074ea <.L81>:
        write_csr(CSR_PMACFG3, value);
800074ea:	47b2                	lw	a5,12(sp)
800074ec:	bc379073          	csrw	0xbc3,a5
        break;
800074f0:	a011                	j	800074f4 <.L86>

800074f2 <.L87>:
        break;
800074f2:	0001                	nop

800074f4 <.L86>:
}
800074f4:	0001                	nop
800074f6:	0141                	add	sp,sp,16
800074f8:	8082                	ret

Disassembly of section .text.spi_get_data_length_in_bits:

800074fa <spi_get_data_length_in_bits>:
{
800074fa:	1141                	add	sp,sp,-16
800074fc:	c62a                	sw	a0,12(sp)
    return ((ptr->TRANSFMT & SPI_TRANSFMT_DATALEN_MASK) >> SPI_TRANSFMT_DATALEN_SHIFT) + 1;
800074fe:	47b2                	lw	a5,12(sp)
80007500:	4b9c                	lw	a5,16(a5)
80007502:	83a1                	srl	a5,a5,0x8
80007504:	0ff7f793          	zext.b	a5,a5
80007508:	8bfd                	and	a5,a5,31
8000750a:	0ff7f793          	zext.b	a5,a5
8000750e:	0785                	add	a5,a5,1
80007510:	0ff7f793          	zext.b	a5,a5
}
80007514:	853e                	mv	a0,a5
80007516:	0141                	add	sp,sp,16
80007518:	8082                	ret

Disassembly of section .text.spi_wait_for_idle_status:

8000751a <spi_wait_for_idle_status>:
{
8000751a:	1101                	add	sp,sp,-32
8000751c:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
8000751e:	ce02                	sw	zero,28(sp)

80007520 <.L12>:
        status = ptr->STATUS;
80007520:	47b2                	lw	a5,12(sp)
80007522:	5bdc                	lw	a5,52(a5)
80007524:	cc3e                	sw	a5,24(sp)
        if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
80007526:	4772                	lw	a4,28(sp)
80007528:	6785                	lui	a5,0x1
8000752a:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000752e:	00e7e963          	bltu	a5,a4,80007540 <.L15>
        retry++;
80007532:	47f2                	lw	a5,28(sp)
80007534:	0785                	add	a5,a5,1
80007536:	ce3e                	sw	a5,28(sp)
    } while (status & SPI_STATUS_SPIACTIVE_MASK);
80007538:	47e2                	lw	a5,24(sp)
8000753a:	8b85                	and	a5,a5,1
8000753c:	f3f5                	bnez	a5,80007520 <.L12>
8000753e:	a011                	j	80007542 <.L11>

80007540 <.L15>:
            break;
80007540:	0001                	nop

80007542 <.L11>:
    if (retry > HPM_SPI_DRV_DEFAULT_RETRY_COUNT) {
80007542:	4772                	lw	a4,28(sp)
80007544:	6785                	lui	a5,0x1
80007546:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000754a:	00e7f463          	bgeu	a5,a4,80007552 <.L13>
        return status_timeout;
8000754e:	478d                	li	a5,3
80007550:	a011                	j	80007554 <.L14>

80007552 <.L13>:
    return status_success;
80007552:	4781                	li	a5,0

80007554 <.L14>:
}
80007554:	853e                	mv	a0,a5
80007556:	6105                	add	sp,sp,32
80007558:	8082                	ret

Disassembly of section .text.spi_write_address:

8000755a <spi_write_address>:
{
8000755a:	1141                	add	sp,sp,-16
8000755c:	c62a                	sw	a0,12(sp)
8000755e:	87ae                	mv	a5,a1
80007560:	c232                	sw	a2,4(sp)
80007562:	c036                	sw	a3,0(sp)
80007564:	00f105a3          	sb	a5,11(sp)
    if (mode == spi_master_mode) {
80007568:	00b14783          	lbu	a5,11(sp)
8000756c:	ef89                	bnez	a5,80007586 <.L33>
        if (config->master_config.addr_enable == true) {
8000756e:	4792                	lw	a5,4(sp)
80007570:	0017c783          	lbu	a5,1(a5)
80007574:	cb89                	beqz	a5,80007586 <.L33>
            if (addr == NULL) {
80007576:	4782                	lw	a5,0(sp)
80007578:	e399                	bnez	a5,8000757e <.L34>
                return status_invalid_argument;
8000757a:	4789                	li	a5,2
8000757c:	a031                	j	80007588 <.L35>

8000757e <.L34>:
            ptr->ADDR = SPI_ADDR_ADDR_SET(*addr);
8000757e:	4782                	lw	a5,0(sp)
80007580:	4398                	lw	a4,0(a5)
80007582:	47b2                	lw	a5,12(sp)
80007584:	d798                	sw	a4,40(a5)

80007586 <.L33>:
    return status_success;
80007586:	4781                	li	a5,0

80007588 <.L35>:
}
80007588:	853e                	mv	a0,a5
8000758a:	0141                	add	sp,sp,16
8000758c:	8082                	ret

Disassembly of section .text.spi_slave_get_default_control_config:

8000758e <spi_slave_get_default_control_config>:
{
8000758e:	1141                	add	sp,sp,-16
80007590:	c62a                	sw	a0,12(sp)
    config->slave_config.slave_data_only = false;
80007592:	47b2                	lw	a5,12(sp)
80007594:	000782a3          	sb	zero,5(a5)
    config->common_config.tx_dma_enable = false;
80007598:	47b2                	lw	a5,12(sp)
8000759a:	00078323          	sb	zero,6(a5)
    config->common_config.rx_dma_enable = false;
8000759e:	47b2                	lw	a5,12(sp)
800075a0:	000783a3          	sb	zero,7(a5)
    config->common_config.trans_mode = spi_trans_write_read_together;//spi_trans_read_only;
800075a4:	47b2                	lw	a5,12(sp)
800075a6:	00078423          	sb	zero,8(a5)
    config->common_config.data_phase_fmt = spi_single_io_mode;
800075aa:	47b2                	lw	a5,12(sp)
800075ac:	000784a3          	sb	zero,9(a5)
    config->common_config.dummy_cnt = spi_dummy_count_2;
800075b0:	47b2                	lw	a5,12(sp)
800075b2:	4705                	li	a4,1
800075b4:	00e78523          	sb	a4,10(a5)
    config->common_config.cs_index = spi_cs_0;
800075b8:	47b2                	lw	a5,12(sp)
800075ba:	4705                	li	a4,1
800075bc:	00e785a3          	sb	a4,11(a5)
}
800075c0:	0001                	nop
800075c2:	0141                	add	sp,sp,16
800075c4:	8082                	ret

Disassembly of section .text.spi_format_init:

800075c6 <spi_format_init>:
{
800075c6:	1141                	add	sp,sp,-16
800075c8:	c62a                	sw	a0,12(sp)
800075ca:	c42e                	sw	a1,8(sp)
    ptr->TRANSFMT = SPI_TRANSFMT_ADDRLEN_SET(config->master_config.addr_len_in_bytes - 1) |
800075cc:	47a2                	lw	a5,8(sp)
800075ce:	0007c783          	lbu	a5,0(a5)
800075d2:	17fd                	add	a5,a5,-1
800075d4:	01079713          	sll	a4,a5,0x10
800075d8:	000307b7          	lui	a5,0x30
800075dc:	8f7d                	and	a4,a4,a5
                    SPI_TRANSFMT_DATALEN_SET(config->common_config.data_len_in_bits - 1) |
800075de:	47a2                	lw	a5,8(sp)
800075e0:	0017c783          	lbu	a5,1(a5) # 30001 <__AHB_SRAM_segment_size__+0x28001>
800075e4:	17fd                	add	a5,a5,-1
800075e6:	00879693          	sll	a3,a5,0x8
800075ea:	6789                	lui	a5,0x2
800075ec:	f0078793          	add	a5,a5,-256 # 1f00 <__NOR_CFG_OPTION_segment_size__+0x1300>
800075f0:	8ff5                	and	a5,a5,a3
    ptr->TRANSFMT = SPI_TRANSFMT_ADDRLEN_SET(config->master_config.addr_len_in_bytes - 1) |
800075f2:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_DATAMERGE_SET(config->common_config.data_merge) |
800075f4:	47a2                	lw	a5,8(sp)
800075f6:	0027c783          	lbu	a5,2(a5)
800075fa:	079e                	sll	a5,a5,0x7
800075fc:	0ff7f793          	zext.b	a5,a5
                    SPI_TRANSFMT_DATALEN_SET(config->common_config.data_len_in_bits - 1) |
80007600:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_MOSIBIDIR_SET(config->common_config.mosi_bidir) |
80007602:	47a2                	lw	a5,8(sp)
80007604:	0037c783          	lbu	a5,3(a5)
80007608:	0792                	sll	a5,a5,0x4
8000760a:	8bc1                	and	a5,a5,16
                    SPI_TRANSFMT_DATAMERGE_SET(config->common_config.data_merge) |
8000760c:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_LSB_SET(config->common_config.lsb) |
8000760e:	47a2                	lw	a5,8(sp)
80007610:	0047c783          	lbu	a5,4(a5)
80007614:	078e                	sll	a5,a5,0x3
80007616:	8ba1                	and	a5,a5,8
                    SPI_TRANSFMT_MOSIBIDIR_SET(config->common_config.mosi_bidir) |
80007618:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_SLVMODE_SET(config->common_config.mode) |
8000761a:	47a2                	lw	a5,8(sp)
8000761c:	0057c783          	lbu	a5,5(a5)
80007620:	078a                	sll	a5,a5,0x2
80007622:	8b91                	and	a5,a5,4
                    SPI_TRANSFMT_LSB_SET(config->common_config.lsb) |
80007624:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_CPOL_SET(config->common_config.cpol) |
80007626:	47a2                	lw	a5,8(sp)
80007628:	0067c783          	lbu	a5,6(a5)
8000762c:	0786                	sll	a5,a5,0x1
8000762e:	8b89                	and	a5,a5,2
                    SPI_TRANSFMT_SLVMODE_SET(config->common_config.mode) |
80007630:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_CPHA_SET(config->common_config.cpha);
80007632:	47a2                	lw	a5,8(sp)
80007634:	0077c783          	lbu	a5,7(a5)
80007638:	8b85                	and	a5,a5,1
                    SPI_TRANSFMT_CPOL_SET(config->common_config.cpol) |
8000763a:	8f5d                	or	a4,a4,a5
    ptr->TRANSFMT = SPI_TRANSFMT_ADDRLEN_SET(config->master_config.addr_len_in_bytes - 1) |
8000763c:	47b2                	lw	a5,12(sp)
8000763e:	cb98                	sw	a4,16(a5)
}
80007640:	0001                	nop
80007642:	0141                	add	sp,sp,16
80007644:	8082                	ret

Disassembly of section .text.spi_transfer:

80007646 <spi_transfer>:

hpm_stat_t spi_transfer(SPI_Type *ptr,
                        spi_control_config_t *config,
                        uint8_t *cmd, uint32_t *addr,
                        uint8_t *wbuff, uint32_t wcount, uint8_t *rbuff, uint32_t rcount)
{
80007646:	7139                	add	sp,sp,-64
80007648:	de06                	sw	ra,60(sp)
8000764a:	ce2a                	sw	a0,28(sp)
8000764c:	cc2e                	sw	a1,24(sp)
8000764e:	ca32                	sw	a2,20(sp)
80007650:	c836                	sw	a3,16(sp)
80007652:	c63a                	sw	a4,12(sp)
80007654:	c43e                	sw	a5,8(sp)
80007656:	c242                	sw	a6,4(sp)
80007658:	c046                	sw	a7,0(sp)
    hpm_stat_t stat = status_fail;
8000765a:	4785                	li	a5,1
8000765c:	d63e                	sw	a5,44(sp)
    spi_mode_selection_t mode;
    uint8_t data_len_in_bytes, trans_mode;

    /* read spi control mode */
    mode = (spi_mode_selection_t)((ptr->TRANSFMT & SPI_TRANSFMT_SLVMODE_MASK) >> SPI_TRANSFMT_SLVMODE_SHIFT);
8000765e:	47f2                	lw	a5,28(sp)
80007660:	4b9c                	lw	a5,16(a5)
80007662:	8389                	srl	a5,a5,0x2
80007664:	8b85                	and	a5,a5,1
80007666:	02f105a3          	sb	a5,43(sp)

    /* When acting as a host, it is necessary to determine whether the SPI bus is active to ensure that only one device accesses the bus. */
    if ((mode == spi_master_mode) && (spi_is_active(ptr) == true)) {
8000766a:	02b14783          	lbu	a5,43(sp)
8000766e:	eb91                	bnez	a5,80007682 <.L112>
80007670:	4572                	lw	a0,28(sp)
80007672:	f30fd0ef          	jal	80004da2 <spi_is_active>
80007676:	87aa                	mv	a5,a0
80007678:	c789                	beqz	a5,80007682 <.L112>
        return status_spi_master_busy;
8000767a:	6785                	lui	a5,0x1
8000767c:	bb978793          	add	a5,a5,-1095 # bb9 <__ILM_segment_used_end__+0x6f7>
80007680:	a2ad                	j	800077ea <.L113>

80007682 <.L112>:
    }

    stat = spi_control_init(ptr, config, wcount, rcount);
80007682:	4682                	lw	a3,0(sp)
80007684:	4622                	lw	a2,8(sp)
80007686:	45e2                	lw	a1,24(sp)
80007688:	4572                	lw	a0,28(sp)
8000768a:	b71fd0ef          	jal	800051fa <spi_control_init>
8000768e:	d62a                	sw	a0,44(sp)
    if (stat != status_success) {
80007690:	57b2                	lw	a5,44(sp)
80007692:	c399                	beqz	a5,80007698 <.L114>
        return stat;
80007694:	57b2                	lw	a5,44(sp)
80007696:	aa91                	j	800077ea <.L113>

80007698 <.L114>:
    }

    /* read data length */
    data_len_in_bytes = spi_get_data_length_in_bytes(ptr);
80007698:	4572                	lw	a0,28(sp)
8000769a:	eeafd0ef          	jal	80004d84 <spi_get_data_length_in_bytes>
8000769e:	87aa                	mv	a5,a0
800076a0:	02f10523          	sb	a5,42(sp)

    /* read spi transfer mode */
    trans_mode = config->common_config.trans_mode;
800076a4:	47e2                	lw	a5,24(sp)
800076a6:	0087c783          	lbu	a5,8(a5)
800076aa:	02f104a3          	sb	a5,41(sp)

    /* write address on master mode */
    stat = spi_write_address(ptr, mode, config, addr);
800076ae:	02b14783          	lbu	a5,43(sp)
800076b2:	46c2                	lw	a3,16(sp)
800076b4:	4662                	lw	a2,24(sp)
800076b6:	85be                	mv	a1,a5
800076b8:	4572                	lw	a0,28(sp)
800076ba:	3545                	jal	8000755a <spi_write_address>
800076bc:	d62a                	sw	a0,44(sp)
    if (stat != status_success) {
800076be:	57b2                	lw	a5,44(sp)
800076c0:	c399                	beqz	a5,800076c6 <.L115>
        return stat;
800076c2:	57b2                	lw	a5,44(sp)
800076c4:	a21d                	j	800077ea <.L113>

800076c6 <.L115>:
    }

    /* write command on master mode */
    stat = spi_write_command(ptr, mode, config, cmd);
800076c6:	02b14783          	lbu	a5,43(sp)
800076ca:	46d2                	lw	a3,20(sp)
800076cc:	4662                	lw	a2,24(sp)
800076ce:	85be                	mv	a1,a5
800076d0:	4572                	lw	a0,28(sp)
800076d2:	f1cfd0ef          	jal	80004dee <spi_write_command>
800076d6:	d62a                	sw	a0,44(sp)
    if (stat != status_success) {
800076d8:	57b2                	lw	a5,44(sp)
800076da:	c399                	beqz	a5,800076e0 <.L116>
        return stat;
800076dc:	57b2                	lw	a5,44(sp)
800076de:	a231                	j	800077ea <.L113>

800076e0 <.L116>:
    }

    /* data phase */
    if (trans_mode == spi_trans_write_read_together) {
800076e0:	02914783          	lbu	a5,41(sp)
800076e4:	ef81                	bnez	a5,800076fc <.L117>
        stat = spi_write_read_data(ptr, data_len_in_bytes, wbuff, wcount, rbuff, rcount);
800076e6:	02a14583          	lbu	a1,42(sp)
800076ea:	4782                	lw	a5,0(sp)
800076ec:	4712                	lw	a4,4(sp)
800076ee:	46a2                	lw	a3,8(sp)
800076f0:	4632                	lw	a2,12(sp)
800076f2:	4572                	lw	a0,28(sp)
800076f4:	93dfd0ef          	jal	80005030 <spi_write_read_data>
800076f8:	d62a                	sw	a0,44(sp)
800076fa:	a0d9                	j	800077c0 <.L118>

800076fc <.L117>:
    } else if (trans_mode == spi_trans_write_only || trans_mode == spi_trans_dummy_write) {
800076fc:	02914703          	lbu	a4,41(sp)
80007700:	4785                	li	a5,1
80007702:	00f70763          	beq	a4,a5,80007710 <.L119>
80007706:	02914703          	lbu	a4,41(sp)
8000770a:	47a1                	li	a5,8
8000770c:	00f71c63          	bne	a4,a5,80007724 <.L120>

80007710 <.L119>:
        stat = spi_write_data(ptr, data_len_in_bytes, wbuff, wcount);
80007710:	02a14783          	lbu	a5,42(sp)
80007714:	46a2                	lw	a3,8(sp)
80007716:	4632                	lw	a2,12(sp)
80007718:	85be                	mv	a1,a5
8000771a:	4572                	lw	a0,28(sp)
8000771c:	f5afd0ef          	jal	80004e76 <spi_write_data>
80007720:	d62a                	sw	a0,44(sp)
80007722:	a879                	j	800077c0 <.L118>

80007724 <.L120>:
    } else if (trans_mode == spi_trans_read_only || trans_mode == spi_trans_dummy_read) {
80007724:	02914703          	lbu	a4,41(sp)
80007728:	4789                	li	a5,2
8000772a:	00f70763          	beq	a4,a5,80007738 <.L121>
8000772e:	02914703          	lbu	a4,41(sp)
80007732:	47a5                	li	a5,9
80007734:	00f71c63          	bne	a4,a5,8000774c <.L122>

80007738 <.L121>:
        stat = spi_read_data(ptr, data_len_in_bytes, rbuff, rcount);
80007738:	02a14783          	lbu	a5,42(sp)
8000773c:	4682                	lw	a3,0(sp)
8000773e:	4612                	lw	a2,4(sp)
80007740:	85be                	mv	a1,a5
80007742:	4572                	lw	a0,28(sp)
80007744:	ff8fd0ef          	jal	80004f3c <spi_read_data>
80007748:	d62a                	sw	a0,44(sp)
8000774a:	a89d                	j	800077c0 <.L118>

8000774c <.L122>:
    } else if (trans_mode == spi_trans_write_read || trans_mode == spi_trans_write_dummy_read) {
8000774c:	02914703          	lbu	a4,41(sp)
80007750:	478d                	li	a5,3
80007752:	00f70763          	beq	a4,a5,80007760 <.L123>
80007756:	02914703          	lbu	a4,41(sp)
8000775a:	4795                	li	a5,5
8000775c:	00f71d63          	bne	a4,a5,80007776 <.L124>

80007760 <.L123>:
        stat = spi_write_read_data(ptr, data_len_in_bytes, wbuff, wcount, rbuff, rcount);
80007760:	02a14583          	lbu	a1,42(sp)
80007764:	4782                	lw	a5,0(sp)
80007766:	4712                	lw	a4,4(sp)
80007768:	46a2                	lw	a3,8(sp)
8000776a:	4632                	lw	a2,12(sp)
8000776c:	4572                	lw	a0,28(sp)
8000776e:	8c3fd0ef          	jal	80005030 <spi_write_read_data>
80007772:	d62a                	sw	a0,44(sp)
80007774:	a0b1                	j	800077c0 <.L118>

80007776 <.L124>:
    } else if (trans_mode == spi_trans_read_write || trans_mode == spi_trans_read_dummy_write) {
80007776:	02914703          	lbu	a4,41(sp)
8000777a:	4791                	li	a5,4
8000777c:	00f70763          	beq	a4,a5,8000778a <.L125>
80007780:	02914703          	lbu	a4,41(sp)
80007784:	4799                	li	a5,6
80007786:	00f71d63          	bne	a4,a5,800077a0 <.L126>

8000778a <.L125>:
        stat = spi_write_read_data(ptr, data_len_in_bytes, wbuff, wcount, rbuff, rcount);
8000778a:	02a14583          	lbu	a1,42(sp)
8000778e:	4782                	lw	a5,0(sp)
80007790:	4712                	lw	a4,4(sp)
80007792:	46a2                	lw	a3,8(sp)
80007794:	4632                	lw	a2,12(sp)
80007796:	4572                	lw	a0,28(sp)
80007798:	899fd0ef          	jal	80005030 <spi_write_read_data>
8000779c:	d62a                	sw	a0,44(sp)
8000779e:	a00d                	j	800077c0 <.L118>

800077a0 <.L126>:
    } else if (trans_mode == spi_trans_no_data) {
800077a0:	02914703          	lbu	a4,41(sp)
800077a4:	479d                	li	a5,7
800077a6:	00f71b63          	bne	a4,a5,800077bc <.L127>
        stat = spi_no_data(ptr, mode, config);
800077aa:	02b14783          	lbu	a5,43(sp)
800077ae:	4662                	lw	a2,24(sp)
800077b0:	85be                	mv	a1,a5
800077b2:	4572                	lw	a0,28(sp)
800077b4:	9cffd0ef          	jal	80005182 <spi_no_data>
800077b8:	d62a                	sw	a0,44(sp)
800077ba:	a019                	j	800077c0 <.L118>

800077bc <.L127>:
    } else {
        stat = status_invalid_argument;
800077bc:	4789                	li	a5,2
800077be:	d63e                	sw	a5,44(sp)

800077c0 <.L118>:
    }

    if (stat != status_success) {
800077c0:	57b2                	lw	a5,44(sp)
800077c2:	c399                	beqz	a5,800077c8 <.L128>
        return stat;
800077c4:	57b2                	lw	a5,44(sp)
800077c6:	a015                	j	800077ea <.L113>

800077c8 <.L128>:
    }

    /* read command on slave mode */
    stat = spi_read_command(ptr, mode, config, cmd);
800077c8:	02b14783          	lbu	a5,43(sp)
800077cc:	46d2                	lw	a3,20(sp)
800077ce:	4662                	lw	a2,24(sp)
800077d0:	85be                	mv	a1,a5
800077d2:	4572                	lw	a0,28(sp)
800077d4:	e5cfd0ef          	jal	80004e30 <spi_read_command>
800077d8:	d62a                	sw	a0,44(sp)
    if (stat != status_success) {
800077da:	57b2                	lw	a5,44(sp)
800077dc:	c399                	beqz	a5,800077e2 <.L129>
        return stat;
800077de:	57b2                	lw	a5,44(sp)
800077e0:	a029                	j	800077ea <.L113>

800077e2 <.L129>:
    }
    /* on the slave mode, if master keeps asserting the cs signal, it's maybe timeout */
    stat = spi_wait_for_idle_status(ptr);
800077e2:	4572                	lw	a0,28(sp)
800077e4:	3b1d                	jal	8000751a <spi_wait_for_idle_status>
800077e6:	d62a                	sw	a0,44(sp)
    return stat;
800077e8:	57b2                	lw	a5,44(sp)

800077ea <.L113>:
}
800077ea:	853e                	mv	a0,a5
800077ec:	50f2                	lw	ra,60(sp)
800077ee:	6121                	add	sp,sp,64
800077f0:	8082                	ret

Disassembly of section .text.uart_modem_config:

800077f2 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
800077f2:	1141                	add	sp,sp,-16
800077f4:	c62a                	sw	a0,12(sp)
800077f6:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
800077f8:	47a2                	lw	a5,8(sp)
800077fa:	0007c783          	lbu	a5,0(a5)
800077fe:	0796                	sll	a5,a5,0x5
80007800:	0207f713          	and	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
80007804:	47a2                	lw	a5,8(sp)
80007806:	0017c783          	lbu	a5,1(a5)
8000780a:	0792                	sll	a5,a5,0x4
8000780c:	8bc1                	and	a5,a5,16
8000780e:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
80007810:	47a2                	lw	a5,8(sp)
80007812:	0027c783          	lbu	a5,2(a5)
80007816:	0017c793          	xor	a5,a5,1
8000781a:	0ff7f793          	zext.b	a5,a5
8000781e:	0786                	sll	a5,a5,0x1
80007820:	8b89                	and	a5,a5,2
80007822:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80007824:	47b2                	lw	a5,12(sp)
80007826:	db98                	sw	a4,48(a5)
}
80007828:	0001                	nop
8000782a:	0141                	add	sp,sp,16
8000782c:	8082                	ret

Disassembly of section .text.uart_disable_irq:

8000782e <uart_disable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be disabled
 */
static inline void uart_disable_irq(UART_Type *ptr, uint32_t irq_mask)
{
8000782e:	1141                	add	sp,sp,-16
80007830:	c62a                	sw	a0,12(sp)
80007832:	c42e                	sw	a1,8(sp)
    ptr->IER &= ~irq_mask;
80007834:	47b2                	lw	a5,12(sp)
80007836:	53d8                	lw	a4,36(a5)
80007838:	47a2                	lw	a5,8(sp)
8000783a:	fff7c793          	not	a5,a5
8000783e:	8f7d                	and	a4,a4,a5
80007840:	47b2                	lw	a5,12(sp)
80007842:	d3d8                	sw	a4,36(a5)
}
80007844:	0001                	nop
80007846:	0141                	add	sp,sp,16
80007848:	8082                	ret

Disassembly of section .text.uart_enable_irq:

8000784a <uart_enable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be enabled
 */
static inline void uart_enable_irq(UART_Type *ptr, uint32_t irq_mask)
{
8000784a:	1141                	add	sp,sp,-16
8000784c:	c62a                	sw	a0,12(sp)
8000784e:	c42e                	sw	a1,8(sp)
    ptr->IER |= irq_mask;
80007850:	47b2                	lw	a5,12(sp)
80007852:	53d8                	lw	a4,36(a5)
80007854:	47a2                	lw	a5,8(sp)
80007856:	8f5d                	or	a4,a4,a5
80007858:	47b2                	lw	a5,12(sp)
8000785a:	d3d8                	sw	a4,36(a5)
}
8000785c:	0001                	nop
8000785e:	0141                	add	sp,sp,16
80007860:	8082                	ret

Disassembly of section .text.uart_default_config:

80007862 <uart_default_config>:
{
80007862:	1141                	add	sp,sp,-16
80007864:	c62a                	sw	a0,12(sp)
80007866:	c42e                	sw	a1,8(sp)
    config->baudrate = 115200;
80007868:	47a2                	lw	a5,8(sp)
8000786a:	6771                	lui	a4,0x1c
8000786c:	20070713          	add	a4,a4,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80007870:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80007872:	47a2                	lw	a5,8(sp)
80007874:	470d                	li	a4,3
80007876:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
8000787a:	47a2                	lw	a5,8(sp)
8000787c:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80007880:	47a2                	lw	a5,8(sp)
80007882:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
80007886:	47a2                	lw	a5,8(sp)
80007888:	4705                	li	a4,1
8000788a:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
8000788e:	47a2                	lw	a5,8(sp)
80007890:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
80007894:	47a2                	lw	a5,8(sp)
80007896:	477d                	li	a4,31
80007898:	00e785a3          	sb	a4,11(a5)
    config->dma_enable = false;
8000789c:	47a2                	lw	a5,8(sp)
8000789e:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
800078a2:	47a2                	lw	a5,8(sp)
800078a4:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
800078a8:	47a2                	lw	a5,8(sp)
800078aa:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
800078ae:	47a2                	lw	a5,8(sp)
800078b0:	000788a3          	sb	zero,17(a5)
    config->rxidle_config.detect_enable = false;
800078b4:	47a2                	lw	a5,8(sp)
800078b6:	00078923          	sb	zero,18(a5)
    config->rxidle_config.detect_irq_enable = false;
800078ba:	47a2                	lw	a5,8(sp)
800078bc:	000789a3          	sb	zero,19(a5)
    config->rxidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
800078c0:	47a2                	lw	a5,8(sp)
800078c2:	00078a23          	sb	zero,20(a5)
    config->rxidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
800078c6:	47a2                	lw	a5,8(sp)
800078c8:	4729                	li	a4,10
800078ca:	00e78aa3          	sb	a4,21(a5)
    config->txidle_config.detect_enable = false;
800078ce:	47a2                	lw	a5,8(sp)
800078d0:	00078b23          	sb	zero,22(a5)
    config->txidle_config.detect_irq_enable = false;
800078d4:	47a2                	lw	a5,8(sp)
800078d6:	00078ba3          	sb	zero,23(a5)
    config->txidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
800078da:	47a2                	lw	a5,8(sp)
800078dc:	00078c23          	sb	zero,24(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
800078e0:	47a2                	lw	a5,8(sp)
800078e2:	4729                	li	a4,10
800078e4:	00e78ca3          	sb	a4,25(a5)
    config->rx_enable = true;
800078e8:	47a2                	lw	a5,8(sp)
800078ea:	4705                	li	a4,1
800078ec:	00e78d23          	sb	a4,26(a5)
}
800078f0:	0001                	nop
800078f2:	0141                	add	sp,sp,16
800078f4:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

800078f6 <uart_calculate_baudrate>:
{
800078f6:	7119                	add	sp,sp,-128
800078f8:	de86                	sw	ra,124(sp)
800078fa:	dca2                	sw	s0,120(sp)
800078fc:	daa6                	sw	s1,116(sp)
800078fe:	d8ca                	sw	s2,112(sp)
80007900:	d6ce                	sw	s3,108(sp)
80007902:	d4d2                	sw	s4,104(sp)
80007904:	d2d6                	sw	s5,100(sp)
80007906:	d0da                	sw	s6,96(sp)
80007908:	cede                	sw	s7,92(sp)
8000790a:	cce2                	sw	s8,88(sp)
8000790c:	cae6                	sw	s9,84(sp)
8000790e:	c8ea                	sw	s10,80(sp)
80007910:	c6ee                	sw	s11,76(sp)
80007912:	ce2a                	sw	a0,28(sp)
80007914:	cc2e                	sw	a1,24(sp)
80007916:	ca32                	sw	a2,20(sp)
80007918:	c836                	sw	a3,16(sp)
    if ((div_out == NULL) || (!freq) || (!baudrate)
8000791a:	46d2                	lw	a3,20(sp)
8000791c:	ca85                	beqz	a3,8000794c <.L6>
8000791e:	46f2                	lw	a3,28(sp)
80007920:	c695                	beqz	a3,8000794c <.L6>
80007922:	46e2                	lw	a3,24(sp)
80007924:	c685                	beqz	a3,8000794c <.L6>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
80007926:	4662                	lw	a2,24(sp)
80007928:	0c700693          	li	a3,199
8000792c:	02c6f063          	bgeu	a3,a2,8000794c <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
80007930:	46e2                	lw	a3,24(sp)
80007932:	068e                	sll	a3,a3,0x3
80007934:	4672                	lw	a2,28(sp)
80007936:	00d66b63          	bltu	a2,a3,8000794c <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
8000793a:	4672                	lw	a2,28(sp)
8000793c:	66c1                	lui	a3,0x10
8000793e:	16fd                	add	a3,a3,-1 # ffff <__AHB_SRAM_segment_size__+0x7fff>
80007940:	02d65633          	divu	a2,a2,a3
80007944:	46e2                	lw	a3,24(sp)
80007946:	0696                	sll	a3,a3,0x5
80007948:	00c6f463          	bgeu	a3,a2,80007950 <.L7>

8000794c <.L6>:
        return 0;
8000794c:	4781                	li	a5,0
8000794e:	ac91                	j	80007ba2 <.L8>

80007950 <.L7>:
    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
80007950:	46f2                	lw	a3,28(sp)
80007952:	8736                	mv	a4,a3
80007954:	4781                	li	a5,0
80007956:	3e800693          	li	a3,1000
8000795a:	02d78633          	mul	a2,a5,a3
8000795e:	4681                	li	a3,0
80007960:	02d706b3          	mul	a3,a4,a3
80007964:	9636                	add	a2,a2,a3
80007966:	3e800693          	li	a3,1000
8000796a:	02d705b3          	mul	a1,a4,a3
8000796e:	02d738b3          	mulhu	a7,a4,a3
80007972:	882e                	mv	a6,a1
80007974:	011607b3          	add	a5,a2,a7
80007978:	88be                	mv	a7,a5
8000797a:	47e2                	lw	a5,24(sp)
8000797c:	833e                	mv	t1,a5
8000797e:	4381                	li	t2,0
80007980:	861a                	mv	a2,t1
80007982:	869e                	mv	a3,t2
80007984:	8542                	mv	a0,a6
80007986:	85c6                	mv	a1,a7
80007988:	af3fe0ef          	jal	8000647a <__udivdi3>
8000798c:	872a                	mv	a4,a0
8000798e:	87ae                	mv	a5,a1
80007990:	d83a                	sw	a4,48(sp)
80007992:	da3e                	sw	a5,52(sp)
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80007994:	47a1                	li	a5,8
80007996:	02f11f23          	sh	a5,62(sp)
8000799a:	aaed                	j	80007b94 <.L9>

8000799c <.L20>:
        delta = 0;
8000799c:	02011e23          	sh	zero,60(sp)
        div = (uint16_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
800079a0:	03e15703          	lhu	a4,62(sp)
800079a4:	87ba                	mv	a5,a4
800079a6:	078a                	sll	a5,a5,0x2
800079a8:	97ba                	add	a5,a5,a4
800079aa:	00279713          	sll	a4,a5,0x2
800079ae:	97ba                	add	a5,a5,a4
800079b0:	00279713          	sll	a4,a5,0x2
800079b4:	97ba                	add	a5,a5,a4
800079b6:	078a                	sll	a5,a5,0x2
800079b8:	843e                	mv	s0,a5
800079ba:	4481                	li	s1,0
800079bc:	5642                	lw	a2,48(sp)
800079be:	56d2                	lw	a3,52(sp)
800079c0:	00c40733          	add	a4,s0,a2
800079c4:	85ba                	mv	a1,a4
800079c6:	0085b5b3          	sltu	a1,a1,s0
800079ca:	00d487b3          	add	a5,s1,a3
800079ce:	00f586b3          	add	a3,a1,a5
800079d2:	87b6                	mv	a5,a3
800079d4:	853a                	mv	a0,a4
800079d6:	85be                	mv	a1,a5
800079d8:	03e15703          	lhu	a4,62(sp)
800079dc:	87ba                	mv	a5,a4
800079de:	078a                	sll	a5,a5,0x2
800079e0:	97ba                	add	a5,a5,a4
800079e2:	00279713          	sll	a4,a5,0x2
800079e6:	97ba                	add	a5,a5,a4
800079e8:	00279713          	sll	a4,a5,0x2
800079ec:	97ba                	add	a5,a5,a4
800079ee:	078e                	sll	a5,a5,0x3
800079f0:	8d3e                	mv	s10,a5
800079f2:	4d81                	li	s11,0
800079f4:	866a                	mv	a2,s10
800079f6:	86ee                	mv	a3,s11
800079f8:	a83fe0ef          	jal	8000647a <__udivdi3>
800079fc:	872a                	mv	a4,a0
800079fe:	87ae                	mv	a5,a1
80007a00:	02e11723          	sh	a4,46(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN) {
80007a04:	02e15783          	lhu	a5,46(sp)
80007a08:	16078e63          	beqz	a5,80007b84 <.L23>
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
80007a0c:	02e15703          	lhu	a4,46(sp)
80007a10:	03e15783          	lhu	a5,62(sp)
80007a14:	02f707b3          	mul	a5,a4,a5
80007a18:	873e                	mv	a4,a5
80007a1a:	87ba                	mv	a5,a4
80007a1c:	078a                	sll	a5,a5,0x2
80007a1e:	97ba                	add	a5,a5,a4
80007a20:	00279713          	sll	a4,a5,0x2
80007a24:	97ba                	add	a5,a5,a4
80007a26:	00279713          	sll	a4,a5,0x2
80007a2a:	97ba                	add	a5,a5,a4
80007a2c:	078e                	sll	a5,a5,0x3
80007a2e:	8b3e                	mv	s6,a5
80007a30:	4b81                	li	s7,0
80007a32:	57d2                	lw	a5,52(sp)
80007a34:	875e                	mv	a4,s7
80007a36:	00e7ea63          	bltu	a5,a4,80007a4a <.L21>
80007a3a:	57d2                	lw	a5,52(sp)
80007a3c:	875e                	mv	a4,s7
80007a3e:	06e79163          	bne	a5,a4,80007aa0 <.L12>
80007a42:	57c2                	lw	a5,48(sp)
80007a44:	875a                	mv	a4,s6
80007a46:	04e7fd63          	bgeu	a5,a4,80007aa0 <.L12>

80007a4a <.L21>:
            delta = (uint16_t)(((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp) / HPM_UART_BAUDRATE_SCALE);
80007a4a:	02e15703          	lhu	a4,46(sp)
80007a4e:	03e15783          	lhu	a5,62(sp)
80007a52:	02f707b3          	mul	a5,a4,a5
80007a56:	873e                	mv	a4,a5
80007a58:	87ba                	mv	a5,a4
80007a5a:	078a                	sll	a5,a5,0x2
80007a5c:	97ba                	add	a5,a5,a4
80007a5e:	00279713          	sll	a4,a5,0x2
80007a62:	97ba                	add	a5,a5,a4
80007a64:	00279713          	sll	a4,a5,0x2
80007a68:	97ba                	add	a5,a5,a4
80007a6a:	078e                	sll	a5,a5,0x3
80007a6c:	893e                	mv	s2,a5
80007a6e:	4981                	li	s3,0
80007a70:	5642                	lw	a2,48(sp)
80007a72:	56d2                	lw	a3,52(sp)
80007a74:	40c90733          	sub	a4,s2,a2
80007a78:	85ba                	mv	a1,a4
80007a7a:	00b935b3          	sltu	a1,s2,a1
80007a7e:	40d987b3          	sub	a5,s3,a3
80007a82:	40b786b3          	sub	a3,a5,a1
80007a86:	87b6                	mv	a5,a3
80007a88:	3e800613          	li	a2,1000
80007a8c:	4681                	li	a3,0
80007a8e:	853a                	mv	a0,a4
80007a90:	85be                	mv	a1,a5
80007a92:	9e9fe0ef          	jal	8000647a <__udivdi3>
80007a96:	872a                	mv	a4,a0
80007a98:	87ae                	mv	a5,a1
80007a9a:	02e11e23          	sh	a4,60(sp)
80007a9e:	a051                	j	80007b22 <.L14>

80007aa0 <.L12>:
        } else if (div * osc < tmp) {
80007aa0:	02e15703          	lhu	a4,46(sp)
80007aa4:	03e15783          	lhu	a5,62(sp)
80007aa8:	02f707b3          	mul	a5,a4,a5
80007aac:	8c3e                	mv	s8,a5
80007aae:	87fd                	sra	a5,a5,0x1f
80007ab0:	8cbe                	mv	s9,a5
80007ab2:	57d2                	lw	a5,52(sp)
80007ab4:	8766                	mv	a4,s9
80007ab6:	00f76a63          	bltu	a4,a5,80007aca <.L22>
80007aba:	57d2                	lw	a5,52(sp)
80007abc:	8766                	mv	a4,s9
80007abe:	06e79263          	bne	a5,a4,80007b22 <.L14>
80007ac2:	57c2                	lw	a5,48(sp)
80007ac4:	8762                	mv	a4,s8
80007ac6:	04f77e63          	bgeu	a4,a5,80007b22 <.L14>

80007aca <.L22>:
            delta = (uint16_t)((tmp - (div * osc * HPM_UART_BAUDRATE_SCALE)) / HPM_UART_BAUDRATE_SCALE);
80007aca:	02e15703          	lhu	a4,46(sp)
80007ace:	03e15783          	lhu	a5,62(sp)
80007ad2:	02f707b3          	mul	a5,a4,a5
80007ad6:	873e                	mv	a4,a5
80007ad8:	87ba                	mv	a5,a4
80007ada:	078a                	sll	a5,a5,0x2
80007adc:	97ba                	add	a5,a5,a4
80007ade:	00279713          	sll	a4,a5,0x2
80007ae2:	97ba                	add	a5,a5,a4
80007ae4:	00279713          	sll	a4,a5,0x2
80007ae8:	97ba                	add	a5,a5,a4
80007aea:	078e                	sll	a5,a5,0x3
80007aec:	8a3e                	mv	s4,a5
80007aee:	4a81                	li	s5,0
80007af0:	5742                	lw	a4,48(sp)
80007af2:	57d2                	lw	a5,52(sp)
80007af4:	41470633          	sub	a2,a4,s4
80007af8:	85b2                	mv	a1,a2
80007afa:	00b735b3          	sltu	a1,a4,a1
80007afe:	415786b3          	sub	a3,a5,s5
80007b02:	40b687b3          	sub	a5,a3,a1
80007b06:	86be                	mv	a3,a5
80007b08:	8732                	mv	a4,a2
80007b0a:	87b6                	mv	a5,a3
80007b0c:	3e800613          	li	a2,1000
80007b10:	4681                	li	a3,0
80007b12:	853a                	mv	a0,a4
80007b14:	85be                	mv	a1,a5
80007b16:	965fe0ef          	jal	8000647a <__udivdi3>
80007b1a:	872a                	mv	a4,a0
80007b1c:	87ae                	mv	a5,a1
80007b1e:	02e11e23          	sh	a4,60(sp)

80007b22 <.L14>:
        if (delta && (((delta * 100 * HPM_UART_BAUDRATE_SCALE) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
80007b22:	03c15783          	lhu	a5,60(sp)
80007b26:	cb8d                	beqz	a5,80007b58 <.L16>
80007b28:	03c15703          	lhu	a4,60(sp)
80007b2c:	67e1                	lui	a5,0x18
80007b2e:	6a078793          	add	a5,a5,1696 # 186a0 <__AHB_SRAM_segment_size__+0x106a0>
80007b32:	02f707b3          	mul	a5,a4,a5
80007b36:	c43e                	sw	a5,8(sp)
80007b38:	c602                	sw	zero,12(sp)
80007b3a:	5642                	lw	a2,48(sp)
80007b3c:	56d2                	lw	a3,52(sp)
80007b3e:	4522                	lw	a0,8(sp)
80007b40:	45b2                	lw	a1,12(sp)
80007b42:	939fe0ef          	jal	8000647a <__udivdi3>
80007b46:	872a                	mv	a4,a0
80007b48:	87ae                	mv	a5,a1
80007b4a:	86be                	mv	a3,a5
80007b4c:	ee95                	bnez	a3,80007b88 <.L24>
80007b4e:	86be                	mv	a3,a5
80007b50:	e681                	bnez	a3,80007b58 <.L16>
80007b52:	478d                	li	a5,3
80007b54:	02e7ea63          	bltu	a5,a4,80007b88 <.L24>

80007b58 <.L16>:
            *div_out = div;
80007b58:	47d2                	lw	a5,20(sp)
80007b5a:	02e15703          	lhu	a4,46(sp)
80007b5e:	00e79023          	sh	a4,0(a5)
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
80007b62:	03e15703          	lhu	a4,62(sp)
80007b66:	02000793          	li	a5,32
80007b6a:	00f70763          	beq	a4,a5,80007b78 <.L18>
80007b6e:	03e15783          	lhu	a5,62(sp)
80007b72:	0ff7f793          	zext.b	a5,a5
80007b76:	a011                	j	80007b7a <.L19>

80007b78 <.L18>:
80007b78:	4781                	li	a5,0

80007b7a <.L19>:
80007b7a:	4742                	lw	a4,16(sp)
80007b7c:	00f70023          	sb	a5,0(a4)
            return true;
80007b80:	4785                	li	a5,1
80007b82:	a005                	j	80007ba2 <.L8>

80007b84 <.L23>:
            continue;
80007b84:	0001                	nop
80007b86:	a011                	j	80007b8a <.L11>

80007b88 <.L24>:
            continue;
80007b88:	0001                	nop

80007b8a <.L11>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80007b8a:	03e15783          	lhu	a5,62(sp)
80007b8e:	0789                	add	a5,a5,2
80007b90:	02f11f23          	sh	a5,62(sp)

80007b94 <.L9>:
80007b94:	03e15703          	lhu	a4,62(sp)
80007b98:	02000793          	li	a5,32
80007b9c:	e0e7f0e3          	bgeu	a5,a4,8000799c <.L20>
    return false;
80007ba0:	4781                	li	a5,0

80007ba2 <.L8>:
}
80007ba2:	853e                	mv	a0,a5
80007ba4:	50f6                	lw	ra,124(sp)
80007ba6:	5466                	lw	s0,120(sp)
80007ba8:	54d6                	lw	s1,116(sp)
80007baa:	5946                	lw	s2,112(sp)
80007bac:	59b6                	lw	s3,108(sp)
80007bae:	5a26                	lw	s4,104(sp)
80007bb0:	5a96                	lw	s5,100(sp)
80007bb2:	5b06                	lw	s6,96(sp)
80007bb4:	4bf6                	lw	s7,92(sp)
80007bb6:	4c66                	lw	s8,88(sp)
80007bb8:	4cd6                	lw	s9,84(sp)
80007bba:	4d46                	lw	s10,80(sp)
80007bbc:	4db6                	lw	s11,76(sp)
80007bbe:	6109                	add	sp,sp,128
80007bc0:	8082                	ret

Disassembly of section .text.uart_flush:

80007bc2 <uart_flush>:
{
80007bc2:	1101                	add	sp,sp,-32
80007bc4:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
80007bc6:	ce02                	sw	zero,28(sp)
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80007bc8:	a811                	j	80007bdc <.L59>

80007bca <.L62>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
80007bca:	4772                	lw	a4,28(sp)
80007bcc:	6785                	lui	a5,0x1
80007bce:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80007bd2:	00e7eb63          	bltu	a5,a4,80007be8 <.L65>
        retry++;
80007bd6:	47f2                	lw	a5,28(sp)
80007bd8:	0785                	add	a5,a5,1
80007bda:	ce3e                	sw	a5,28(sp)

80007bdc <.L59>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80007bdc:	47b2                	lw	a5,12(sp)
80007bde:	5bdc                	lw	a5,52(a5)
80007be0:	0407f793          	and	a5,a5,64
80007be4:	d3fd                	beqz	a5,80007bca <.L62>
80007be6:	a011                	j	80007bea <.L61>

80007be8 <.L65>:
            break;
80007be8:	0001                	nop

80007bea <.L61>:
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
80007bea:	4772                	lw	a4,28(sp)
80007bec:	6785                	lui	a5,0x1
80007bee:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80007bf2:	00e7f463          	bgeu	a5,a4,80007bfa <.L63>
        return status_timeout;
80007bf6:	478d                	li	a5,3
80007bf8:	a011                	j	80007bfc <.L64>

80007bfa <.L63>:
    return status_success;
80007bfa:	4781                	li	a5,0

80007bfc <.L64>:
}
80007bfc:	853e                	mv	a0,a5
80007bfe:	6105                	add	sp,sp,32
80007c00:	8082                	ret

Disassembly of section .text.uart_init_rxline_idle_detection:

80007c02 <uart_init_rxline_idle_detection>:
{
80007c02:	1101                	add	sp,sp,-32
80007c04:	ce06                	sw	ra,28(sp)
80007c06:	c62a                	sw	a0,12(sp)
80007c08:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_RX_IDLE_EN_MASK
80007c0a:	47b2                	lw	a5,12(sp)
80007c0c:	43dc                	lw	a5,4(a5)
80007c0e:	c007f713          	and	a4,a5,-1024
80007c12:	47b2                	lw	a5,12(sp)
80007c14:	c3d8                	sw	a4,4(a5)
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
80007c16:	47b2                	lw	a5,12(sp)
80007c18:	43d8                	lw	a4,4(a5)
80007c1a:	00814783          	lbu	a5,8(sp)
80007c1e:	07a2                	sll	a5,a5,0x8
80007c20:	1007f793          	and	a5,a5,256
                    | UART_IDLE_CFG_RX_IDLE_THR_SET(rxidle_config.threshold)
80007c24:	00b14683          	lbu	a3,11(sp)
80007c28:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_RX_IDLE_COND_SET(rxidle_config.idle_cond);
80007c2a:	00a14783          	lbu	a5,10(sp)
80007c2e:	07a6                	sll	a5,a5,0x9
80007c30:	2007f793          	and	a5,a5,512
80007c34:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
80007c36:	8f5d                	or	a4,a4,a5
80007c38:	47b2                	lw	a5,12(sp)
80007c3a:	c3d8                	sw	a4,4(a5)
    if (rxidle_config.detect_irq_enable) {
80007c3c:	00914783          	lbu	a5,9(sp)
80007c40:	c791                	beqz	a5,80007c4c <.L92>
        uart_enable_irq(ptr, uart_intr_rx_line_idle);
80007c42:	800005b7          	lui	a1,0x80000
80007c46:	4532                	lw	a0,12(sp)
80007c48:	3109                	jal	8000784a <uart_enable_irq>
80007c4a:	a029                	j	80007c54 <.L93>

80007c4c <.L92>:
        uart_disable_irq(ptr, uart_intr_rx_line_idle);
80007c4c:	800005b7          	lui	a1,0x80000
80007c50:	4532                	lw	a0,12(sp)
80007c52:	3ef1                	jal	8000782e <uart_disable_irq>

80007c54 <.L93>:
    return status_success;
80007c54:	4781                	li	a5,0
}
80007c56:	853e                	mv	a0,a5
80007c58:	40f2                	lw	ra,28(sp)
80007c5a:	6105                	add	sp,sp,32
80007c5c:	8082                	ret

Disassembly of section .text.gpio_set_pin_output:

80007c5e <gpio_set_pin_output>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_set_pin_output(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
80007c5e:	1141                	add	sp,sp,-16
80007c60:	c62a                	sw	a0,12(sp)
80007c62:	c42e                	sw	a1,8(sp)
80007c64:	87b2                	mv	a5,a2
80007c66:	00f103a3          	sb	a5,7(sp)
    ptr->OE[port].SET = 1 << pin;
80007c6a:	00714783          	lbu	a5,7(sp)
80007c6e:	4705                	li	a4,1
80007c70:	00f717b3          	sll	a5,a4,a5
80007c74:	86be                	mv	a3,a5
80007c76:	4732                	lw	a4,12(sp)
80007c78:	47a2                	lw	a5,8(sp)
80007c7a:	02078793          	add	a5,a5,32
80007c7e:	0792                	sll	a5,a5,0x4
80007c80:	97ba                	add	a5,a5,a4
80007c82:	c3d4                	sw	a3,4(a5)
}
80007c84:	0001                	nop
80007c86:	0141                	add	sp,sp,16
80007c88:	8082                	ret

Disassembly of section .text.spi_slave_comand_dump:

80007c8a <spi_slave_comand_dump>:
{
80007c8a:	1101                	add	sp,sp,-32
80007c8c:	ce06                	sw	ra,28(sp)
80007c8e:	c62a                	sw	a0,12(sp)
80007c90:	c42e                	sw	a1,8(sp)
    if (config->slave_config.slave_data_only == false &&  cmd != NULL) {
80007c92:	47b2                	lw	a5,12(sp)
80007c94:	0057c783          	lbu	a5,5(a5)
80007c98:	0017c793          	xor	a5,a5,1
80007c9c:	0ff7f793          	zext.b	a5,a5
80007ca0:	cb99                	beqz	a5,80007cb6 <.L10>
80007ca2:	47a2                	lw	a5,8(sp)
80007ca4:	cb89                	beqz	a5,80007cb6 <.L10>
        printf("SPI-Slave read command:0x%02x\n", *cmd);
80007ca6:	47a2                	lw	a5,8(sp)
80007ca8:	0007c783          	lbu	a5,0(a5)
80007cac:	85be                	mv	a1,a5
80007cae:	b1c18513          	add	a0,gp,-1252 # 800033ac <.LC2>
80007cb2:	97aff0ef          	jal	80006e2c <printf>

80007cb6 <.L10>:
}
80007cb6:	0001                	nop
80007cb8:	40f2                	lw	ra,28(sp)
80007cba:	6105                	add	sp,sp,32
80007cbc:	8082                	ret

Disassembly of section .text.init_pins_io:

80007cbe <init_pins_io>:
{
80007cbe:	1141                	add	sp,sp,-16
80007cc0:	c606                	sw	ra,12(sp)
    HPM_IOC->PAD[IOC_PAD_PD00].FUNC_CTL = IOC_PD00_FUNC_CTL_GPIO_D_00;
80007cc2:	f40407b7          	lui	a5,0xf4040
80007cc6:	3007a023          	sw	zero,768(a5) # f4040300 <__AHB_SRAM_segment_end__+0x3e38300>
    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOD, 0, gpiom_core0_fast);
80007cca:	4689                	li	a3,2
80007ccc:	4601                	li	a2,0
80007cce:	458d                	li	a1,3
80007cd0:	f00d8537          	lui	a0,0xf00d8
80007cd4:	93ffd0ef          	jal	80005612 <gpiom_set_pin_controller>
    gpio_set_pin_output(HPM_FGPIO, GPIO_OE_GPIOD, 0);
80007cd8:	4601                	li	a2,0
80007cda:	458d                	li	a1,3
80007cdc:	00300537          	lui	a0,0x300
80007ce0:	3fbd                	jal	80007c5e <gpio_set_pin_output>
    gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
80007ce2:	4685                	li	a3,1
80007ce4:	4601                	li	a2,0
80007ce6:	458d                	li	a1,3
80007ce8:	00300537          	lui	a0,0x300
80007cec:	8d5fd0ef          	jal	800055c0 <gpio_write_pin>
}
80007cf0:	0001                	nop
80007cf2:	40b2                	lw	ra,12(sp)
80007cf4:	0141                	add	sp,sp,16
80007cf6:	8082                	ret

Disassembly of section .text.reset_handler:

80007cf8 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
80007cf8:	1141                	add	sp,sp,-16
80007cfa:	c606                	sw	ra,12(sp)
    fencei();
80007cfc:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
80007d00:	958fe0ef          	jal	80005e58 <system_init>

    /* Entry function */
    MAIN_ENTRY();
80007d04:	bd7fd0ef          	jal	800058da <main>
}
80007d08:	0001                	nop
80007d0a:	40b2                	lw	ra,12(sp)
80007d0c:	0141                	add	sp,sp,16
80007d0e:	8082                	ret

Disassembly of section .text._init:

80007d10 <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
80007d10:	0001                	nop
80007d12:	8082                	ret

Disassembly of section .text.mchtmr_isr:

80007d14 <mchtmr_isr>:
}
80007d14:	0001                	nop
80007d16:	8082                	ret

Disassembly of section .text.swi_isr:

80007d18 <swi_isr>:
}
80007d18:	0001                	nop
80007d1a:	8082                	ret

Disassembly of section .text.exception_handler:

80007d1c <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
80007d1c:	1141                	add	sp,sp,-16
80007d1e:	c62a                	sw	a0,12(sp)
80007d20:	c42e                	sw	a1,8(sp)
    switch (cause) {
80007d22:	4732                	lw	a4,12(sp)
80007d24:	47bd                	li	a5,15
80007d26:	00e7ea63          	bltu	a5,a4,80007d3a <.L23>
80007d2a:	47b2                	lw	a5,12(sp)
80007d2c:	00279713          	sll	a4,a5,0x2
80007d30:	c7018793          	add	a5,gp,-912 # 80003500 <.L7>
80007d34:	97ba                	add	a5,a5,a4
80007d36:	439c                	lw	a5,0(a5)
80007d38:	8782                	jr	a5

80007d3a <.L23>:
    case MCAUSE_LOAD_PAGE_FAULT:
        break;
    case MCAUSE_STORE_AMO_PAGE_FAULT:
        break;
    default:
        break;
80007d3a:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
80007d3c:	47a2                	lw	a5,8(sp)
}
80007d3e:	853e                	mv	a0,a5
80007d40:	0141                	add	sp,sp,16
80007d42:	8082                	ret

Disassembly of section .text.clock_get_frequency:

80007d44 <clock_get_frequency>:
{
80007d44:	7179                	add	sp,sp,-48
80007d46:	d606                	sw	ra,44(sp)
80007d48:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80007d4a:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80007d4c:	47b2                	lw	a5,12(sp)
80007d4e:	83a1                	srl	a5,a5,0x8
80007d50:	0ff7f793          	zext.b	a5,a5
80007d54:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80007d56:	47b2                	lw	a5,12(sp)
80007d58:	0ff7f793          	zext.b	a5,a5
80007d5c:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80007d5e:	4762                	lw	a4,24(sp)
80007d60:	47b5                	li	a5,13
80007d62:	0ae7e363          	bltu	a5,a4,80007e08 <.L16>
80007d66:	47e2                	lw	a5,24(sp)
80007d68:	00279713          	sll	a4,a5,0x2
80007d6c:	cc018793          	add	a5,gp,-832 # 80003550 <.L18>
80007d70:	97ba                	add	a5,a5,a4
80007d72:	439c                	lw	a5,0(a5)
80007d74:	8782                	jr	a5

80007d76 <.L31>:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
80007d76:	47d2                	lw	a5,20(sp)
80007d78:	0ff7f793          	zext.b	a5,a5
80007d7c:	853e                	mv	a0,a5
80007d7e:	e47fd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007d82:	ce2a                	sw	a0,28(sp)
        break;
80007d84:	a061                	j	80007e0c <.L32>

80007d86 <.L30>:
        clk_freq = get_frequency_for_adc(node_or_instance);
80007d86:	4552                	lw	a0,20(sp)
80007d88:	2079                	jal	80007e16 <.LFE146>
80007d8a:	ce2a                	sw	a0,28(sp)
        break;
80007d8c:	a041                	j	80007e0c <.L32>

80007d8e <.L29>:
        clk_freq = get_frequency_for_i2s(node_or_instance);
80007d8e:	4552                	lw	a0,20(sp)
80007d90:	ea1fd0ef          	jal	80005c30 <get_frequency_for_i2s>
80007d94:	ce2a                	sw	a0,28(sp)
        break;
80007d96:	a89d                	j	80007e0c <.L32>

80007d98 <.L28>:
        clk_freq = get_frequency_for_ewdg(node_or_instance);
80007d98:	4552                	lw	a0,20(sp)
80007d9a:	2a01                	jal	80007eaa <get_frequency_for_ewdg>
80007d9c:	ce2a                	sw	a0,28(sp)
        break;
80007d9e:	a0bd                	j	80007e0c <.L32>

80007da0 <.L21>:
        clk_freq = get_frequency_for_pewdg();
80007da0:	2a3d                	jal	80007ede <get_frequency_for_pewdg>
80007da2:	ce2a                	sw	a0,28(sp)
        break;
80007da4:	a0a5                	j	80007e0c <.L32>

80007da6 <.L22>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80007da6:	016e37b7          	lui	a5,0x16e3
80007daa:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
80007dae:	ce3e                	sw	a5,28(sp)
        break;
80007db0:	a8b1                	j	80007e0c <.L32>

80007db2 <.L27>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
80007db2:	4511                	li	a0,4
80007db4:	e11fd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007db8:	ce2a                	sw	a0,28(sp)
        break;
80007dba:	a889                	j	80007e0c <.L32>

80007dbc <.L26>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axif);
80007dbc:	4515                	li	a0,5
80007dbe:	e07fd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007dc2:	ce2a                	sw	a0,28(sp)
        break;
80007dc4:	a0a1                	j	80007e0c <.L32>

80007dc6 <.L25>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axis);
80007dc6:	4519                	li	a0,6
80007dc8:	dfdfd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007dcc:	ce2a                	sw	a0,28(sp)
        break;
80007dce:	a83d                	j	80007e0c <.L32>

80007dd0 <.L24>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axic);
80007dd0:	451d                	li	a0,7
80007dd2:	df3fd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007dd6:	ce2a                	sw	a0,28(sp)
        break;
80007dd8:	a815                	j	80007e0c <.L32>

80007dda <.L23>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axin);
80007dda:	4521                	li	a0,8
80007ddc:	de9fd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007de0:	ce2a                	sw	a0,28(sp)
        break;
80007de2:	a02d                	j	80007e0c <.L32>

80007de4 <.L20>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
80007de4:	4501                	li	a0,0
80007de6:	ddffd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007dea:	ce2a                	sw	a0,28(sp)
        break;
80007dec:	a005                	j	80007e0c <.L32>

80007dee <.L19>:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu1);
80007dee:	4509                	li	a0,2
80007df0:	dd5fd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007df4:	ce2a                	sw	a0,28(sp)
        break;
80007df6:	a819                	j	80007e0c <.L32>

80007df8 <.L17>:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
80007df8:	47d2                	lw	a5,20(sp)
80007dfa:	0ff7f793          	zext.b	a5,a5
80007dfe:	853e                	mv	a0,a5
80007e00:	d17fd0ef          	jal	80005b16 <get_frequency_for_source>
80007e04:	ce2a                	sw	a0,28(sp)
        break;
80007e06:	a019                	j	80007e0c <.L32>

80007e08 <.L16>:
        clk_freq = 0UL;
80007e08:	ce02                	sw	zero,28(sp)
        break;
80007e0a:	0001                	nop

80007e0c <.L32>:
    return clk_freq;
80007e0c:	47f2                	lw	a5,28(sp)
}
80007e0e:	853e                	mv	a0,a5
80007e10:	50b2                	lw	ra,44(sp)
80007e12:	6145                	add	sp,sp,48
80007e14:	8082                	ret

Disassembly of section .text.get_frequency_for_adc:

80007e16 <get_frequency_for_adc>:
{
80007e16:	7179                	add	sp,sp,-48
80007e18:	d606                	sw	ra,44(sp)
80007e1a:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80007e1c:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
80007e1e:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
80007e22:	04f00793          	li	a5,79
80007e26:	00f10d23          	sb	a5,26(sp)
    if (instance < ADC_INSTANCE_NUM) {
80007e2a:	4732                	lw	a4,12(sp)
80007e2c:	478d                	li	a5,3
80007e2e:	02e7ee63          	bltu	a5,a4,80007e6a <.L51>

80007e32 <.LBB7>:
        uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[instance]);
80007e32:	f4000737          	lui	a4,0xf4000
80007e36:	47b2                	lw	a5,12(sp)
80007e38:	70078793          	add	a5,a5,1792
80007e3c:	078a                	sll	a5,a5,0x2
80007e3e:	97ba                	add	a5,a5,a4
80007e40:	439c                	lw	a5,0(a5)
80007e42:	83a1                	srl	a5,a5,0x8
80007e44:	8b85                	and	a5,a5,1
80007e46:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
80007e48:	4752                	lw	a4,20(sp)
80007e4a:	4785                	li	a5,1
80007e4c:	00e7ef63          	bltu	a5,a4,80007e6a <.L51>
            node = s_adc_clk_mux_node[mux_in_reg];
80007e50:	800047b7          	lui	a5,0x80004
80007e54:	d3078713          	add	a4,a5,-720 # 80003d30 <s_adc_clk_mux_node>
80007e58:	47d2                	lw	a5,20(sp)
80007e5a:	97ba                	add	a5,a5,a4
80007e5c:	0007c783          	lbu	a5,0(a5)
80007e60:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
80007e64:	4785                	li	a5,1
80007e66:	00f10da3          	sb	a5,27(sp)

80007e6a <.L51>:
    if (is_mux_valid) {
80007e6a:	01b14783          	lbu	a5,27(sp)
80007e6e:	cb8d                	beqz	a5,80007ea0 <.L52>
        if (node == clock_node_ahb0) {
80007e70:	01a14703          	lbu	a4,26(sp)
80007e74:	4791                	li	a5,4
80007e76:	00f71763          	bne	a4,a5,80007e84 <.L53>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
80007e7a:	4511                	li	a0,4
80007e7c:	d49fd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007e80:	ce2a                	sw	a0,28(sp)
80007e82:	a839                	j	80007ea0 <.L52>

80007e84 <.L53>:
            node += instance;
80007e84:	47b2                	lw	a5,12(sp)
80007e86:	0ff7f793          	zext.b	a5,a5
80007e8a:	01a14703          	lbu	a4,26(sp)
80007e8e:	97ba                	add	a5,a5,a4
80007e90:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
80007e94:	01a14783          	lbu	a5,26(sp)
80007e98:	853e                	mv	a0,a5
80007e9a:	d2bfd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007e9e:	ce2a                	sw	a0,28(sp)

80007ea0 <.L52>:
    return clk_freq;
80007ea0:	47f2                	lw	a5,28(sp)
}
80007ea2:	853e                	mv	a0,a5
80007ea4:	50b2                	lw	ra,44(sp)
80007ea6:	6145                	add	sp,sp,48
80007ea8:	8082                	ret

Disassembly of section .text.get_frequency_for_ewdg:

80007eaa <get_frequency_for_ewdg>:
{
80007eaa:	7179                	add	sp,sp,-48
80007eac:	d606                	sw	ra,44(sp)
80007eae:	c62a                	sw	a0,12(sp)
    if (EWDG_CTRL0_CLK_SEL_GET(s_wdgs[instance]->CTRL0) == 0) {
80007eb0:	cb018713          	add	a4,gp,-848 # 80003540 <s_wdgs>
80007eb4:	47b2                	lw	a5,12(sp)
80007eb6:	078a                	sll	a5,a5,0x2
80007eb8:	97ba                	add	a5,a5,a4
80007eba:	439c                	lw	a5,0(a5)
80007ebc:	4398                	lw	a4,0(a5)
80007ebe:	200007b7          	lui	a5,0x20000
80007ec2:	8ff9                	and	a5,a5,a4
80007ec4:	e791                	bnez	a5,80007ed0 <.L62>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
80007ec6:	4511                	li	a0,4
80007ec8:	cfdfd0ef          	jal	80005bc4 <get_frequency_for_ip_in_common_group>
80007ecc:	ce2a                	sw	a0,28(sp)
80007ece:	a019                	j	80007ed4 <.L63>

80007ed0 <.L62>:
        freq_in_hz = FREQ_32KHz;
80007ed0:	67a1                	lui	a5,0x8
80007ed2:	ce3e                	sw	a5,28(sp)

80007ed4 <.L63>:
    return freq_in_hz;
80007ed4:	47f2                	lw	a5,28(sp)
}
80007ed6:	853e                	mv	a0,a5
80007ed8:	50b2                	lw	ra,44(sp)
80007eda:	6145                	add	sp,sp,48
80007edc:	8082                	ret

Disassembly of section .text.get_frequency_for_pewdg:

80007ede <get_frequency_for_pewdg>:
{
80007ede:	1141                	add	sp,sp,-16
    if (EWDG_CTRL0_CLK_SEL_GET(HPM_PEWDG->CTRL0) == 0) {
80007ee0:	f41287b7          	lui	a5,0xf4128
80007ee4:	4398                	lw	a4,0(a5)
80007ee6:	200007b7          	lui	a5,0x20000
80007eea:	8ff9                	and	a5,a5,a4
80007eec:	e799                	bnez	a5,80007efa <.L66>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
80007eee:	016e37b7          	lui	a5,0x16e3
80007ef2:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x3e3600>
80007ef6:	c63e                	sw	a5,12(sp)
80007ef8:	a019                	j	80007efe <.L67>

80007efa <.L66>:
        freq_in_hz = FREQ_32KHz;
80007efa:	67a1                	lui	a5,0x8
80007efc:	c63e                	sw	a5,12(sp)

80007efe <.L67>:
    return freq_in_hz;
80007efe:	47b2                	lw	a5,12(sp)
}
80007f00:	853e                	mv	a0,a5
80007f02:	0141                	add	sp,sp,16
80007f04:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

80007f06 <clock_set_source_divider>:
{
80007f06:	7179                	add	sp,sp,-48
80007f08:	d606                	sw	ra,44(sp)
80007f0a:	c62a                	sw	a0,12(sp)
80007f0c:	87ae                	mv	a5,a1
80007f0e:	c232                	sw	a2,4(sp)
80007f10:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
80007f14:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80007f16:	47b2                	lw	a5,12(sp)
80007f18:	83a1                	srl	a5,a5,0x8
80007f1a:	0ff7f793          	zext.b	a5,a5
80007f1e:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80007f20:	47b2                	lw	a5,12(sp)
80007f22:	0ff7f793          	zext.b	a5,a5
80007f26:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80007f28:	4762                	lw	a4,24(sp)
80007f2a:	47b5                	li	a5,13
80007f2c:	0ae7e563          	bltu	a5,a4,80007fd6 <.L129>
80007f30:	47e2                	lw	a5,24(sp)
80007f32:	00279713          	sll	a4,a5,0x2
80007f36:	d1818793          	add	a5,gp,-744 # 800035a8 <.L131>
80007f3a:	97ba                	add	a5,a5,a4
80007f3c:	439c                	lw	a5,0(a5)
80007f3e:	8782                	jr	a5

80007f40 <.L140>:
        if ((div < 1U) || (div > 256U)) {
80007f40:	4792                	lw	a5,4(sp)
80007f42:	c791                	beqz	a5,80007f4e <.L141>
80007f44:	4712                	lw	a4,4(sp)
80007f46:	10000793          	li	a5,256
80007f4a:	00e7f763          	bgeu	a5,a4,80007f58 <.L142>

80007f4e <.L141>:
            status = status_clk_div_invalid;
80007f4e:	6795                	lui	a5,0x5
80007f50:	5f078793          	add	a5,a5,1520 # 55f0 <__HEAPSIZE__+0x15f0>
80007f54:	ce3e                	sw	a5,28(sp)
        break;
80007f56:	a069                	j	80007fe0 <.L144>

80007f58 <.L142>:
            clock_source_t source = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
80007f58:	00b14783          	lbu	a5,11(sp)
80007f5c:	8bbd                	and	a5,a5,15
80007f5e:	00f109a3          	sb	a5,19(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, source, div);
80007f62:	47d2                	lw	a5,20(sp)
80007f64:	0ff7f793          	zext.b	a5,a5
80007f68:	01314703          	lbu	a4,19(sp)
80007f6c:	4692                	lw	a3,4(sp)
80007f6e:	863a                	mv	a2,a4
80007f70:	85be                	mv	a1,a5
80007f72:	f4000537          	lui	a0,0xf4000
80007f76:	e4ffd0ef          	jal	80005dc4 <sysctl_config_clock>

80007f7a <.LBE12>:
        break;
80007f7a:	a09d                	j	80007fe0 <.L144>

80007f7c <.L130>:
        status = status_clk_operation_unsupported;
80007f7c:	6795                	lui	a5,0x5
80007f7e:	5f378793          	add	a5,a5,1523 # 55f3 <__HEAPSIZE__+0x15f3>
80007f82:	ce3e                	sw	a5,28(sp)
        break;
80007f84:	a8b1                	j	80007fe0 <.L144>

80007f86 <.L134>:
        status = status_clk_fixed;
80007f86:	6795                	lui	a5,0x5
80007f88:	5fb78793          	add	a5,a5,1531 # 55fb <__HEAPSIZE__+0x15fb>
80007f8c:	ce3e                	sw	a5,28(sp)
        break;
80007f8e:	a889                	j	80007fe0 <.L144>

80007f90 <.L139>:
        status = status_clk_shared_ahb;
80007f90:	6795                	lui	a5,0x5
80007f92:	5f478793          	add	a5,a5,1524 # 55f4 <__HEAPSIZE__+0x15f4>
80007f96:	ce3e                	sw	a5,28(sp)
        break;
80007f98:	a0a1                	j	80007fe0 <.L144>

80007f9a <.L138>:
        status = status_clk_shared_axif;
80007f9a:	6795                	lui	a5,0x5
80007f9c:	5f578793          	add	a5,a5,1525 # 55f5 <__HEAPSIZE__+0x15f5>
80007fa0:	ce3e                	sw	a5,28(sp)
        break;
80007fa2:	a83d                	j	80007fe0 <.L144>

80007fa4 <.L137>:
        status = status_clk_shared_axis;
80007fa4:	6795                	lui	a5,0x5
80007fa6:	5f678793          	add	a5,a5,1526 # 55f6 <__HEAPSIZE__+0x15f6>
80007faa:	ce3e                	sw	a5,28(sp)
        break;
80007fac:	a815                	j	80007fe0 <.L144>

80007fae <.L136>:
        status = status_clk_shared_axic;
80007fae:	6795                	lui	a5,0x5
80007fb0:	5f778793          	add	a5,a5,1527 # 55f7 <__HEAPSIZE__+0x15f7>
80007fb4:	ce3e                	sw	a5,28(sp)
        break;
80007fb6:	a02d                	j	80007fe0 <.L144>

80007fb8 <.L135>:
        status = status_clk_shared_axin;
80007fb8:	6795                	lui	a5,0x5
80007fba:	5f878793          	add	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
80007fbe:	ce3e                	sw	a5,28(sp)
        break;
80007fc0:	a005                	j	80007fe0 <.L144>

80007fc2 <.L133>:
        status = status_clk_shared_cpu0;
80007fc2:	6795                	lui	a5,0x5
80007fc4:	5f978793          	add	a5,a5,1529 # 55f9 <__HEAPSIZE__+0x15f9>
80007fc8:	ce3e                	sw	a5,28(sp)
        break;
80007fca:	a819                	j	80007fe0 <.L144>

80007fcc <.L132>:
        status = status_clk_shared_cpu1;
80007fcc:	6795                	lui	a5,0x5
80007fce:	5fa78793          	add	a5,a5,1530 # 55fa <__HEAPSIZE__+0x15fa>
80007fd2:	ce3e                	sw	a5,28(sp)
        break;
80007fd4:	a031                	j	80007fe0 <.L144>

80007fd6 <.L129>:
        status = status_clk_src_invalid;
80007fd6:	6795                	lui	a5,0x5
80007fd8:	5f178793          	add	a5,a5,1521 # 55f1 <__HEAPSIZE__+0x15f1>
80007fdc:	ce3e                	sw	a5,28(sp)
        break;
80007fde:	0001                	nop

80007fe0 <.L144>:
    return status;
80007fe0:	47f2                	lw	a5,28(sp)
}
80007fe2:	853e                	mv	a0,a5
80007fe4:	50b2                	lw	ra,44(sp)
80007fe6:	6145                	add	sp,sp,48
80007fe8:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

80007fea <clock_connect_group_to_cpu>:
{
80007fea:	1141                	add	sp,sp,-16
80007fec:	c62a                	sw	a0,12(sp)
80007fee:	c42e                	sw	a1,8(sp)
    if (cpu < 2U) {
80007ff0:	4722                	lw	a4,8(sp)
80007ff2:	4785                	li	a5,1
80007ff4:	00e7ee63          	bltu	a5,a4,80008010 <.L164>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
80007ff8:	f40006b7          	lui	a3,0xf4000
80007ffc:	47b2                	lw	a5,12(sp)
80007ffe:	4705                	li	a4,1
80008000:	00f71733          	sll	a4,a4,a5
80008004:	47a2                	lw	a5,8(sp)
80008006:	09078793          	add	a5,a5,144
8000800a:	0792                	sll	a5,a5,0x4
8000800c:	97b6                	add	a5,a5,a3
8000800e:	c3d8                	sw	a4,4(a5)

80008010 <.L164>:
}
80008010:	0001                	nop
80008012:	0141                	add	sp,sp,16
80008014:	8082                	ret

Disassembly of section .text.clock_get_core_clock_ticks_per_ms:

80008016 <clock_get_core_clock_ticks_per_ms>:
{
80008016:	1141                	add	sp,sp,-16
80008018:	c606                	sw	ra,12(sp)
    if (hpm_core_clock == 0U) {
8000801a:	012007b7          	lui	a5,0x1200
8000801e:	0307a783          	lw	a5,48(a5) # 1200030 <hpm_core_clock>
80008022:	e399                	bnez	a5,80008028 <.L172>
        clock_update_core_clock();
80008024:	d3dfd0ef          	jal	80005d60 <clock_update_core_clock>

80008028 <.L172>:
    return (hpm_core_clock + FREQ_1MHz - 1U) / 1000;
80008028:	012007b7          	lui	a5,0x1200
8000802c:	0307a703          	lw	a4,48(a5) # 1200030 <hpm_core_clock>
80008030:	000f47b7          	lui	a5,0xf4
80008034:	23f78793          	add	a5,a5,575 # f423f <__AXI_SRAM_segment_size__+0x7423f>
80008038:	973e                	add	a4,a4,a5
8000803a:	3e800793          	li	a5,1000
8000803e:	02f757b3          	divu	a5,a4,a5
}
80008042:	853e                	mv	a0,a5
80008044:	40b2                	lw	ra,12(sp)
80008046:	0141                	add	sp,sp,16
80008048:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

8000804a <sysctl_clock_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr, uint32_t clock)
{
8000804a:	1141                	add	sp,sp,-16
8000804c:	c62a                	sw	a0,12(sp)
8000804e:	c42e                	sw	a1,8(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
80008050:	4732                	lw	a4,12(sp)
80008052:	47a2                	lw	a5,8(sp)
80008054:	60078793          	add	a5,a5,1536
80008058:	078a                	sll	a5,a5,0x2
8000805a:	97ba                	add	a5,a5,a4
8000805c:	4398                	lw	a4,0(a5)
8000805e:	400007b7          	lui	a5,0x40000
80008062:	8ff9                	and	a5,a5,a4
80008064:	00f037b3          	snez	a5,a5
80008068:	0ff7f793          	zext.b	a5,a5
}
8000806c:	853e                	mv	a0,a5
8000806e:	0141                	add	sp,sp,16
80008070:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

80008072 <sysctl_enable_group_resource>:
{
80008072:	7179                	add	sp,sp,-48
80008074:	d606                	sw	ra,44(sp)
80008076:	c62a                	sw	a0,12(sp)
80008078:	87ae                	mv	a5,a1
8000807a:	8736                	mv	a4,a3
8000807c:	00f105a3          	sb	a5,11(sp)
80008080:	87b2                	mv	a5,a2
80008082:	00f11423          	sh	a5,8(sp)
80008086:	87ba                	mv	a5,a4
80008088:	00f10523          	sb	a5,10(sp)
    if (linkable_resource < sysctl_resource_linkable_start) {
8000808c:	00815703          	lhu	a4,8(sp)
80008090:	0ff00793          	li	a5,255
80008094:	00e7e463          	bltu	a5,a4,8000809c <.L59>
        return status_invalid_argument;
80008098:	4789                	li	a5,2
8000809a:	a8e5                	j	80008192 <.L60>

8000809c <.L59>:
    index = (linkable_resource - sysctl_resource_linkable_start) / 32;
8000809c:	00815783          	lhu	a5,8(sp)
800080a0:	f0078793          	add	a5,a5,-256 # 3fffff00 <_extram_size+0x3dffff00>
800080a4:	41f7d713          	sra	a4,a5,0x1f
800080a8:	8b7d                	and	a4,a4,31
800080aa:	97ba                	add	a5,a5,a4
800080ac:	8795                	sra	a5,a5,0x5
800080ae:	ce3e                	sw	a5,28(sp)
    offset = (linkable_resource - sysctl_resource_linkable_start) % 32;
800080b0:	00815783          	lhu	a5,8(sp)
800080b4:	f0078713          	add	a4,a5,-256
800080b8:	41f75793          	sra	a5,a4,0x1f
800080bc:	83ed                	srl	a5,a5,0x1b
800080be:	973e                	add	a4,a4,a5
800080c0:	8b7d                	and	a4,a4,31
800080c2:	40f707b3          	sub	a5,a4,a5
800080c6:	cc3e                	sw	a5,24(sp)
    switch (group) {
800080c8:	00b14783          	lbu	a5,11(sp)
800080cc:	c789                	beqz	a5,800080d6 <.L61>
800080ce:	4705                	li	a4,1
800080d0:	04e78f63          	beq	a5,a4,8000812e <.L62>
800080d4:	a84d                	j	80008186 <.L73>

800080d6 <.L61>:
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
800080d6:	4732                	lw	a4,12(sp)
800080d8:	47f2                	lw	a5,28(sp)
800080da:	08078793          	add	a5,a5,128
800080de:	0792                	sll	a5,a5,0x4
800080e0:	97ba                	add	a5,a5,a4
800080e2:	4398                	lw	a4,0(a5)
800080e4:	47e2                	lw	a5,24(sp)
800080e6:	4685                	li	a3,1
800080e8:	00f697b3          	sll	a5,a3,a5
800080ec:	fff7c793          	not	a5,a5
800080f0:	8f7d                	and	a4,a4,a5
800080f2:	00a14783          	lbu	a5,10(sp)
800080f6:	c791                	beqz	a5,80008102 <.L64>
800080f8:	47e2                	lw	a5,24(sp)
800080fa:	4685                	li	a3,1
800080fc:	00f697b3          	sll	a5,a3,a5
80008100:	a011                	j	80008104 <.L65>

80008102 <.L64>:
80008102:	4781                	li	a5,0

80008104 <.L65>:
80008104:	8f5d                	or	a4,a4,a5
80008106:	46b2                	lw	a3,12(sp)
80008108:	47f2                	lw	a5,28(sp)
8000810a:	08078793          	add	a5,a5,128
8000810e:	0792                	sll	a5,a5,0x4
80008110:	97b6                	add	a5,a5,a3
80008112:	c398                	sw	a4,0(a5)
        if (enable) {
80008114:	00a14783          	lbu	a5,10(sp)
80008118:	cbad                	beqz	a5,8000818a <.L74>
            while (sysctl_resource_target_is_busy(ptr, linkable_resource)) {
8000811a:	0001                	nop

8000811c <.L67>:
8000811c:	00815783          	lhu	a5,8(sp)
80008120:	85be                	mv	a1,a5
80008122:	4532                	lw	a0,12(sp)
80008124:	c77fd0ef          	jal	80005d9a <sysctl_resource_target_is_busy>
80008128:	87aa                	mv	a5,a0
8000812a:	fbed                	bnez	a5,8000811c <.L67>
        break;
8000812c:	a8b9                	j	8000818a <.L74>

8000812e <.L62>:
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
8000812e:	4732                	lw	a4,12(sp)
80008130:	47f2                	lw	a5,28(sp)
80008132:	08478793          	add	a5,a5,132
80008136:	0792                	sll	a5,a5,0x4
80008138:	97ba                	add	a5,a5,a4
8000813a:	4398                	lw	a4,0(a5)
8000813c:	47e2                	lw	a5,24(sp)
8000813e:	4685                	li	a3,1
80008140:	00f697b3          	sll	a5,a3,a5
80008144:	fff7c793          	not	a5,a5
80008148:	8f7d                	and	a4,a4,a5
8000814a:	00a14783          	lbu	a5,10(sp)
8000814e:	c791                	beqz	a5,8000815a <.L69>
80008150:	47e2                	lw	a5,24(sp)
80008152:	4685                	li	a3,1
80008154:	00f697b3          	sll	a5,a3,a5
80008158:	a011                	j	8000815c <.L70>

8000815a <.L69>:
8000815a:	4781                	li	a5,0

8000815c <.L70>:
8000815c:	8f5d                	or	a4,a4,a5
8000815e:	46b2                	lw	a3,12(sp)
80008160:	47f2                	lw	a5,28(sp)
80008162:	08478793          	add	a5,a5,132
80008166:	0792                	sll	a5,a5,0x4
80008168:	97b6                	add	a5,a5,a3
8000816a:	c398                	sw	a4,0(a5)
        if (enable) {
8000816c:	00a14783          	lbu	a5,10(sp)
80008170:	cf99                	beqz	a5,8000818e <.L75>
            while (sysctl_resource_target_is_busy(ptr, linkable_resource)) {
80008172:	0001                	nop

80008174 <.L72>:
80008174:	00815783          	lhu	a5,8(sp)
80008178:	85be                	mv	a1,a5
8000817a:	4532                	lw	a0,12(sp)
8000817c:	c1ffd0ef          	jal	80005d9a <sysctl_resource_target_is_busy>
80008180:	87aa                	mv	a5,a0
80008182:	fbed                	bnez	a5,80008174 <.L72>
        break;
80008184:	a029                	j	8000818e <.L75>

80008186 <.L73>:
        return status_invalid_argument;
80008186:	4789                	li	a5,2
80008188:	a029                	j	80008192 <.L60>

8000818a <.L74>:
        break;
8000818a:	0001                	nop
8000818c:	a011                	j	80008190 <.L68>

8000818e <.L75>:
        break;
8000818e:	0001                	nop

80008190 <.L68>:
    return status_success;
80008190:	4781                	li	a5,0

80008192 <.L60>:
}
80008192:	853e                	mv	a0,a5
80008194:	50b2                	lw	ra,44(sp)
80008196:	6145                	add	sp,sp,48
80008198:	8082                	ret

Disassembly of section .text.enable_plic_feature:

8000819a <enable_plic_feature>:
{
8000819a:	1141                	add	sp,sp,-16
    uint32_t plic_feature = 0;
8000819c:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
8000819e:	47b2                	lw	a5,12(sp)
800081a0:	0027e793          	or	a5,a5,2
800081a4:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
800081a6:	47b2                	lw	a5,12(sp)
800081a8:	0017e793          	or	a5,a5,1
800081ac:	c63e                	sw	a5,12(sp)
800081ae:	e40007b7          	lui	a5,0xe4000
800081b2:	c43e                	sw	a5,8(sp)
800081b4:	47b2                	lw	a5,12(sp)
800081b6:	c23e                	sw	a5,4(sp)

800081b8 <.LBB14>:
 * @param[in] feature Specific feature to be set
 *
 */
ATTR_ALWAYS_INLINE static inline void __plic_set_feature(uint32_t base, uint32_t feature)
{
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
800081b8:	47a2                	lw	a5,8(sp)
800081ba:	4712                	lw	a4,4(sp)
800081bc:	c398                	sw	a4,0(a5)
}
800081be:	0001                	nop

800081c0 <.LBE14>:
}
800081c0:	0001                	nop
800081c2:	0141                	add	sp,sp,16
800081c4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

800081c6 <__SEGGER_RTL_puts_no_nl>:
800081c6:	1101                	add	sp,sp,-32
800081c8:	012007b7          	lui	a5,0x1200
800081cc:	cc22                	sw	s0,24(sp)
800081ce:	0447a403          	lw	s0,68(a5) # 1200044 <stdout>
800081d2:	ce06                	sw	ra,28(sp)
800081d4:	c62a                	sw	a0,12(sp)
800081d6:	2b29                	jal	800086f0 <strlen>
800081d8:	862a                	mv	a2,a0
800081da:	8522                	mv	a0,s0
800081dc:	4462                	lw	s0,24(sp)
800081de:	45b2                	lw	a1,12(sp)
800081e0:	40f2                	lw	ra,28(sp)
800081e2:	6105                	add	sp,sp,32
800081e4:	8f2ff06f          	j	800072d6 <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.signal:

800081e8 <signal>:
800081e8:	4795                	li	a5,5
800081ea:	02a7e463          	bltu	a5,a0,80008212 <.L18>
800081ee:	01200737          	lui	a4,0x1200
800081f2:	01470693          	add	a3,a4,20 # 1200014 <__SEGGER_RTL_aSigTab>
800081f6:	00251793          	sll	a5,a0,0x2
800081fa:	96be                	add	a3,a3,a5
800081fc:	4288                	lw	a0,0(a3)
800081fe:	01470713          	add	a4,a4,20
80008202:	e509                	bnez	a0,8000820c <.L17>
80008204:	80003537          	lui	a0,0x80003
80008208:	06650513          	add	a0,a0,102 # 80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>

8000820c <.L17>:
8000820c:	973e                	add	a4,a4,a5
8000820e:	c30c                	sw	a1,0(a4)
80008210:	8082                	ret

80008212 <.L18>:
80008212:	80006537          	lui	a0,0x80006
80008216:	f3450513          	add	a0,a0,-204 # 80005f34 <__SEGGER_RTL_SIGNAL_SIG_ERR>
8000821a:	8082                	ret

Disassembly of section .text.libc.raise:

8000821c <raise>:
8000821c:	1141                	add	sp,sp,-16
8000821e:	c04a                	sw	s2,0(sp)
80008220:	4d618593          	add	a1,gp,1238 # 80003d66 <__SEGGER_RTL_SIGNAL_SIG_IGN>
80008224:	c226                	sw	s1,4(sp)
80008226:	c606                	sw	ra,12(sp)
80008228:	c422                	sw	s0,8(sp)
8000822a:	84aa                	mv	s1,a0
8000822c:	3f75                	jal	800081e8 <signal>
8000822e:	800067b7          	lui	a5,0x80006
80008232:	f3478793          	add	a5,a5,-204 # 80005f34 <__SEGGER_RTL_SIGNAL_SIG_ERR>
80008236:	02f50d63          	beq	a0,a5,80008270 <.L24>
8000823a:	4d618913          	add	s2,gp,1238 # 80003d66 <__SEGGER_RTL_SIGNAL_SIG_IGN>
8000823e:	842a                	mv	s0,a0
80008240:	03250163          	beq	a0,s2,80008262 <.L22>
80008244:	800035b7          	lui	a1,0x80003
80008248:	06658793          	add	a5,a1,102 # 80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>
8000824c:	00f51563          	bne	a0,a5,80008256 <.L23>
80008250:	4505                	li	a0,1
80008252:	e09fa0ef          	jal	8000305a <exit>

80008256 <.L23>:
80008256:	06658593          	add	a1,a1,102
8000825a:	8526                	mv	a0,s1
8000825c:	3771                	jal	800081e8 <signal>
8000825e:	8526                	mv	a0,s1
80008260:	9402                	jalr	s0

80008262 <.L22>:
80008262:	4501                	li	a0,0

80008264 <.L20>:
80008264:	40b2                	lw	ra,12(sp)
80008266:	4422                	lw	s0,8(sp)
80008268:	4492                	lw	s1,4(sp)
8000826a:	4902                	lw	s2,0(sp)
8000826c:	0141                	add	sp,sp,16
8000826e:	8082                	ret

80008270 <.L24>:
80008270:	557d                	li	a0,-1
80008272:	bfcd                	j	80008264 <.L20>

Disassembly of section .text.libc.abort:

80008274 <abort>:
80008274:	1141                	add	sp,sp,-16
80008276:	c606                	sw	ra,12(sp)

80008278 <.L27>:
80008278:	4501                	li	a0,0
8000827a:	374d                	jal	8000821c <raise>
8000827c:	bff5                	j	80008278 <.L27>

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

8000827e <__SEGGER_RTL_X_assert>:
8000827e:	1101                	add	sp,sp,-32
80008280:	cc22                	sw	s0,24(sp)
80008282:	ca26                	sw	s1,20(sp)
80008284:	842a                	mv	s0,a0
80008286:	84ae                	mv	s1,a1
80008288:	8532                	mv	a0,a2
8000828a:	858a                	mv	a1,sp
8000828c:	4629                	li	a2,10
8000828e:	ce06                	sw	ra,28(sp)
80008290:	c89fd0ef          	jal	80005f18 <itoa>
80008294:	8526                	mv	a0,s1
80008296:	3f05                	jal	800081c6 <__SEGGER_RTL_puts_no_nl>
80008298:	4d818513          	add	a0,gp,1240 # 80003d68 <.LC0>
8000829c:	372d                	jal	800081c6 <__SEGGER_RTL_puts_no_nl>
8000829e:	850a                	mv	a0,sp
800082a0:	371d                	jal	800081c6 <__SEGGER_RTL_puts_no_nl>
800082a2:	4dc18513          	add	a0,gp,1244 # 80003d6c <.LC1>
800082a6:	3705                	jal	800081c6 <__SEGGER_RTL_puts_no_nl>
800082a8:	8522                	mv	a0,s0
800082aa:	3f31                	jal	800081c6 <__SEGGER_RTL_puts_no_nl>
800082ac:	4f418513          	add	a0,gp,1268 # 80003d84 <.LC2>
800082b0:	3f19                	jal	800081c6 <__SEGGER_RTL_puts_no_nl>
800082b2:	37c9                	jal	80008274 <abort>

Disassembly of section .text.libc.__mulsf3:

800082b4 <__mulsf3>:
800082b4:	80000737          	lui	a4,0x80000
800082b8:	0ff00293          	li	t0,255
800082bc:	00b547b3          	xor	a5,a0,a1
800082c0:	8ff9                	and	a5,a5,a4
800082c2:	00151613          	sll	a2,a0,0x1
800082c6:	8261                	srl	a2,a2,0x18
800082c8:	00159693          	sll	a3,a1,0x1
800082cc:	82e1                	srl	a3,a3,0x18
800082ce:	ce29                	beqz	a2,80008328 <.L__mulsf3_lhs_zero_or_subnormal>
800082d0:	c6bd                	beqz	a3,8000833e <.L__mulsf3_rhs_zero_or_subnormal>
800082d2:	04560f63          	beq	a2,t0,80008330 <.L__mulsf3_lhs_inf_or_nan>
800082d6:	06568963          	beq	a3,t0,80008348 <.L__mulsf3_rhs_inf_or_nan>
800082da:	9636                	add	a2,a2,a3
800082dc:	0522                	sll	a0,a0,0x8
800082de:	8d59                	or	a0,a0,a4
800082e0:	05a2                	sll	a1,a1,0x8
800082e2:	8dd9                	or	a1,a1,a4
800082e4:	02b506b3          	mul	a3,a0,a1
800082e8:	02b53533          	mulhu	a0,a0,a1
800082ec:	00d036b3          	snez	a3,a3
800082f0:	8d55                	or	a0,a0,a3
800082f2:	00054463          	bltz	a0,800082fa <.L__mulsf3_normalized>
800082f6:	0506                	sll	a0,a0,0x1
800082f8:	167d                	add	a2,a2,-1

800082fa <.L__mulsf3_normalized>:
800082fa:	f8160613          	add	a2,a2,-127
800082fe:	04064863          	bltz	a2,8000834e <.L__mulsf3_zero_or_underflow>
80008302:	12fd                	add	t0,t0,-1 # ffffffff <__AHB_SRAM_segment_end__+0xfdf7fff>
80008304:	00565f63          	bge	a2,t0,80008322 <.L__mulsf3_inf>
80008308:	01851693          	sll	a3,a0,0x18
8000830c:	8121                	srl	a0,a0,0x8
8000830e:	065e                	sll	a2,a2,0x17
80008310:	9532                	add	a0,a0,a2
80008312:	0006d663          	bgez	a3,8000831e <.L__mulsf3_apply_sign>
80008316:	0505                	add	a0,a0,1
80008318:	0686                	sll	a3,a3,0x1
8000831a:	e291                	bnez	a3,8000831e <.L__mulsf3_apply_sign>
8000831c:	9979                	and	a0,a0,-2

8000831e <.L__mulsf3_apply_sign>:
8000831e:	8d5d                	or	a0,a0,a5
80008320:	8082                	ret

80008322 <.L__mulsf3_inf>:
80008322:	7f800537          	lui	a0,0x7f800
80008326:	bfe5                	j	8000831e <.L__mulsf3_apply_sign>

80008328 <.L__mulsf3_lhs_zero_or_subnormal>:
80008328:	00568d63          	beq	a3,t0,80008342 <.L__mulsf3_nan>

8000832c <.L__mulsf3_signed_zero>:
8000832c:	853e                	mv	a0,a5
8000832e:	8082                	ret

80008330 <.L__mulsf3_lhs_inf_or_nan>:
80008330:	0526                	sll	a0,a0,0x9
80008332:	e901                	bnez	a0,80008342 <.L__mulsf3_nan>
80008334:	fe5697e3          	bne	a3,t0,80008322 <.L__mulsf3_inf>
80008338:	05a6                	sll	a1,a1,0x9
8000833a:	e581                	bnez	a1,80008342 <.L__mulsf3_nan>
8000833c:	b7dd                	j	80008322 <.L__mulsf3_inf>

8000833e <.L__mulsf3_rhs_zero_or_subnormal>:
8000833e:	fe5617e3          	bne	a2,t0,8000832c <.L__mulsf3_signed_zero>

80008342 <.L__mulsf3_nan>:
80008342:	7fc00537          	lui	a0,0x7fc00
80008346:	8082                	ret

80008348 <.L__mulsf3_rhs_inf_or_nan>:
80008348:	05a6                	sll	a1,a1,0x9
8000834a:	fde5                	bnez	a1,80008342 <.L__mulsf3_nan>
8000834c:	bfd9                	j	80008322 <.L__mulsf3_inf>

8000834e <.L__mulsf3_zero_or_underflow>:
8000834e:	0605                	add	a2,a2,1
80008350:	fe71                	bnez	a2,8000832c <.L__mulsf3_signed_zero>
80008352:	8521                	sra	a0,a0,0x8
80008354:	00150293          	add	t0,a0,1 # 7fc00001 <_extram_size+0x7dc00001>
80008358:	0509                	add	a0,a0,2
8000835a:	fc0299e3          	bnez	t0,8000832c <.L__mulsf3_signed_zero>
8000835e:	00800537          	lui	a0,0x800
80008362:	bf75                	j	8000831e <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__divsf3:

80008364 <__divsf3>:
80008364:	0ff00293          	li	t0,255
80008368:	00151713          	sll	a4,a0,0x1
8000836c:	8361                	srl	a4,a4,0x18
8000836e:	00159793          	sll	a5,a1,0x1
80008372:	83e1                	srl	a5,a5,0x18
80008374:	00b54333          	xor	t1,a0,a1
80008378:	01f35313          	srl	t1,t1,0x1f
8000837c:	037e                	sll	t1,t1,0x1f
8000837e:	cf4d                	beqz	a4,80008438 <.L__divsf3_lhs_zero_or_subnormal>
80008380:	cbe9                	beqz	a5,80008452 <.L__divsf3_rhs_zero_or_subnormal>
80008382:	0c570363          	beq	a4,t0,80008448 <.L__divsf3_lhs_inf_or_nan>
80008386:	0c578b63          	beq	a5,t0,8000845c <.L__divsf3_rhs_inf_or_nan>
8000838a:	8f1d                	sub	a4,a4,a5
8000838c:	d5018293          	add	t0,gp,-688 # 800035e0 <__SEGGER_RTL_fdiv_reciprocal_table>
80008390:	00f5d693          	srl	a3,a1,0xf
80008394:	0fc6f693          	and	a3,a3,252
80008398:	9696                	add	a3,a3,t0
8000839a:	429c                	lw	a5,0(a3)
8000839c:	4187d613          	sra	a2,a5,0x18
800083a0:	00f59693          	sll	a3,a1,0xf
800083a4:	82e1                	srl	a3,a3,0x18
800083a6:	0016f293          	and	t0,a3,1
800083aa:	8285                	srl	a3,a3,0x1
800083ac:	fc068693          	add	a3,a3,-64 # f3ffffc0 <__AHB_SRAM_segment_end__+0x3df7fc0>
800083b0:	9696                	add	a3,a3,t0
800083b2:	02d60633          	mul	a2,a2,a3
800083b6:	07a2                	sll	a5,a5,0x8
800083b8:	83a1                	srl	a5,a5,0x8
800083ba:	963e                	add	a2,a2,a5
800083bc:	05a2                	sll	a1,a1,0x8
800083be:	81a1                	srl	a1,a1,0x8
800083c0:	008007b7          	lui	a5,0x800
800083c4:	8ddd                	or	a1,a1,a5
800083c6:	02c586b3          	mul	a3,a1,a2
800083ca:	0522                	sll	a0,a0,0x8
800083cc:	8121                	srl	a0,a0,0x8
800083ce:	8d5d                	or	a0,a0,a5
800083d0:	02c697b3          	mulh	a5,a3,a2
800083d4:	00b532b3          	sltu	t0,a0,a1
800083d8:	00551533          	sll	a0,a0,t0
800083dc:	40570733          	sub	a4,a4,t0
800083e0:	01465693          	srl	a3,a2,0x14
800083e4:	8a85                	and	a3,a3,1
800083e6:	0016c693          	xor	a3,a3,1
800083ea:	062e                	sll	a2,a2,0xb
800083ec:	8e1d                	sub	a2,a2,a5
800083ee:	8e15                	sub	a2,a2,a3
800083f0:	050a                	sll	a0,a0,0x2
800083f2:	02a617b3          	mulh	a5,a2,a0
800083f6:	07e70613          	add	a2,a4,126 # 8000007e <_extram_size+0x7e00007e>
800083fa:	055a                	sll	a0,a0,0x16
800083fc:	8d0d                	sub	a0,a0,a1
800083fe:	02b786b3          	mul	a3,a5,a1
80008402:	0fe00293          	li	t0,254
80008406:	00567f63          	bgeu	a2,t0,80008424 <.L__divsf3_underflow_or_overflow>
8000840a:	40a68533          	sub	a0,a3,a0
8000840e:	000522b3          	sltz	t0,a0
80008412:	9796                	add	a5,a5,t0
80008414:	0017f513          	and	a0,a5,1
80008418:	8385                	srl	a5,a5,0x1
8000841a:	953e                	add	a0,a0,a5
8000841c:	065e                	sll	a2,a2,0x17
8000841e:	9532                	add	a0,a0,a2
80008420:	951a                	add	a0,a0,t1
80008422:	8082                	ret

80008424 <.L__divsf3_underflow_or_overflow>:
80008424:	851a                	mv	a0,t1
80008426:	00564563          	blt	a2,t0,80008430 <.L__divsf3_done>
8000842a:	7f800337          	lui	t1,0x7f800

8000842e <.L__divsf3_apply_sign>:
8000842e:	951a                	add	a0,a0,t1

80008430 <.L__divsf3_done>:
80008430:	8082                	ret

80008432 <.L__divsf3_inf>:
80008432:	7f800537          	lui	a0,0x7f800
80008436:	bfe5                	j	8000842e <.L__divsf3_apply_sign>

80008438 <.L__divsf3_lhs_zero_or_subnormal>:
80008438:	c789                	beqz	a5,80008442 <.L__divsf3_nan>
8000843a:	02579363          	bne	a5,t0,80008460 <.L__divsf3_signed_zero>
8000843e:	05a6                	sll	a1,a1,0x9
80008440:	c185                	beqz	a1,80008460 <.L__divsf3_signed_zero>

80008442 <.L__divsf3_nan>:
80008442:	7fc00537          	lui	a0,0x7fc00
80008446:	8082                	ret

80008448 <.L__divsf3_lhs_inf_or_nan>:
80008448:	0526                	sll	a0,a0,0x9
8000844a:	fd65                	bnez	a0,80008442 <.L__divsf3_nan>
8000844c:	fe5793e3          	bne	a5,t0,80008432 <.L__divsf3_inf>
80008450:	bfcd                	j	80008442 <.L__divsf3_nan>

80008452 <.L__divsf3_rhs_zero_or_subnormal>:
80008452:	fe5710e3          	bne	a4,t0,80008432 <.L__divsf3_inf>
80008456:	0526                	sll	a0,a0,0x9
80008458:	f56d                	bnez	a0,80008442 <.L__divsf3_nan>
8000845a:	bfe1                	j	80008432 <.L__divsf3_inf>

8000845c <.L__divsf3_rhs_inf_or_nan>:
8000845c:	05a6                	sll	a1,a1,0x9
8000845e:	f1f5                	bnez	a1,80008442 <.L__divsf3_nan>

80008460 <.L__divsf3_signed_zero>:
80008460:	851a                	mv	a0,t1
80008462:	8082                	ret

Disassembly of section .text.libc.__eqsf2:

80008464 <__eqsf2>:
80008464:	ff000637          	lui	a2,0xff000
80008468:	00151693          	sll	a3,a0,0x1
8000846c:	02d66063          	bltu	a2,a3,8000848c <.L__eqsf2_one>
80008470:	00159693          	sll	a3,a1,0x1
80008474:	00d66c63          	bltu	a2,a3,8000848c <.L__eqsf2_one>
80008478:	00b56633          	or	a2,a0,a1
8000847c:	0606                	sll	a2,a2,0x1
8000847e:	c609                	beqz	a2,80008488 <.L__eqsf2_zero>
80008480:	8d0d                	sub	a0,a0,a1
80008482:	00a03533          	snez	a0,a0
80008486:	8082                	ret

80008488 <.L__eqsf2_zero>:
80008488:	4501                	li	a0,0
8000848a:	8082                	ret

8000848c <.L__eqsf2_one>:
8000848c:	4505                	li	a0,1
8000848e:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

80008490 <__fixunssfdi>:
80008490:	04054a63          	bltz	a0,800084e4 <.L__fixunssfdi_zero_result>
80008494:	00151613          	sll	a2,a0,0x1
80008498:	8261                	srl	a2,a2,0x18
8000849a:	f8160613          	add	a2,a2,-127 # feffff81 <__AHB_SRAM_segment_end__+0xedf7f81>
8000849e:	04064363          	bltz	a2,800084e4 <.L__fixunssfdi_zero_result>
800084a2:	800006b7          	lui	a3,0x80000
800084a6:	02000293          	li	t0,32
800084aa:	00565b63          	bge	a2,t0,800084c0 <.L__fixunssfdi_long_shift>
800084ae:	40c00633          	neg	a2,a2
800084b2:	067d                	add	a2,a2,31
800084b4:	0522                	sll	a0,a0,0x8
800084b6:	8d55                	or	a0,a0,a3
800084b8:	00c55533          	srl	a0,a0,a2
800084bc:	4581                	li	a1,0
800084be:	8082                	ret

800084c0 <.L__fixunssfdi_long_shift>:
800084c0:	40c00633          	neg	a2,a2
800084c4:	03f60613          	add	a2,a2,63
800084c8:	02064163          	bltz	a2,800084ea <.L__fixunssfdi_overflow_result>
800084cc:	00851593          	sll	a1,a0,0x8
800084d0:	8dd5                	or	a1,a1,a3
800084d2:	4501                	li	a0,0
800084d4:	c619                	beqz	a2,800084e2 <.L__fixunssfdi_shift_32>
800084d6:	40c006b3          	neg	a3,a2
800084da:	00d59533          	sll	a0,a1,a3
800084de:	00c5d5b3          	srl	a1,a1,a2

800084e2 <.L__fixunssfdi_shift_32>:
800084e2:	8082                	ret

800084e4 <.L__fixunssfdi_zero_result>:
800084e4:	4501                	li	a0,0
800084e6:	4581                	li	a1,0
800084e8:	8082                	ret

800084ea <.L__fixunssfdi_overflow_result>:
800084ea:	557d                	li	a0,-1
800084ec:	55fd                	li	a1,-1
800084ee:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

800084f0 <__trunctfsf2>:
800084f0:	4110                	lw	a2,0(a0)
800084f2:	4154                	lw	a3,4(a0)
800084f4:	4518                	lw	a4,8(a0)
800084f6:	455c                	lw	a5,12(a0)
800084f8:	1101                	add	sp,sp,-32
800084fa:	850a                	mv	a0,sp
800084fc:	ce06                	sw	ra,28(sp)
800084fe:	c032                	sw	a2,0(sp)
80008500:	c236                	sw	a3,4(sp)
80008502:	c43a                	sw	a4,8(sp)
80008504:	c63e                	sw	a5,12(sp)
80008506:	e3dfd0ef          	jal	80006342 <__SEGGER_RTL_ldouble_to_double>
8000850a:	db3fd0ef          	jal	800062bc <__truncdfsf2>
8000850e:	40f2                	lw	ra,28(sp)
80008510:	6105                	add	sp,sp,32
80008512:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

80008514 <__SEGGER_RTL_float32_signbit>:
80008514:	817d                	srl	a0,a0,0x1f
80008516:	8082                	ret

Disassembly of section .text.libc.ldexpf:

80008518 <ldexpf>:
80008518:	01755713          	srl	a4,a0,0x17
8000851c:	0ff77713          	zext.b	a4,a4
80008520:	fff70613          	add	a2,a4,-1
80008524:	0fd00693          	li	a3,253
80008528:	87aa                	mv	a5,a0
8000852a:	02c6e863          	bltu	a3,a2,8000855a <.L780>
8000852e:	95ba                	add	a1,a1,a4
80008530:	fff58713          	add	a4,a1,-1
80008534:	00e6eb63          	bltu	a3,a4,8000854a <.L781>
80008538:	80800737          	lui	a4,0x80800
8000853c:	177d                	add	a4,a4,-1 # 807fffff <__FLASH_segment_used_end__+0x7f647f>
8000853e:	00e577b3          	and	a5,a0,a4
80008542:	05de                	sll	a1,a1,0x17
80008544:	00f5e533          	or	a0,a1,a5
80008548:	8082                	ret

8000854a <.L781>:
8000854a:	80000537          	lui	a0,0x80000
8000854e:	8d7d                	and	a0,a0,a5
80008550:	00b05563          	blez	a1,8000855a <.L780>
80008554:	7f8007b7          	lui	a5,0x7f800
80008558:	8d5d                	or	a0,a0,a5

8000855a <.L780>:
8000855a:	8082                	ret

Disassembly of section .text.libc.frexpf:

8000855c <frexpf>:
8000855c:	01755793          	srl	a5,a0,0x17
80008560:	0ff7f793          	zext.b	a5,a5
80008564:	4701                	li	a4,0
80008566:	cf99                	beqz	a5,80008584 <.L959>
80008568:	0ff00613          	li	a2,255
8000856c:	00c78c63          	beq	a5,a2,80008584 <.L959>
80008570:	f8278713          	add	a4,a5,-126 # 7f7fff82 <_extram_size+0x7d7fff82>
80008574:	808007b7          	lui	a5,0x80800
80008578:	17fd                	add	a5,a5,-1 # 807fffff <__FLASH_segment_used_end__+0x7f647f>
8000857a:	00f576b3          	and	a3,a0,a5
8000857e:	3f000537          	lui	a0,0x3f000
80008582:	8d55                	or	a0,a0,a3

80008584 <.L959>:
80008584:	c198                	sw	a4,0(a1)
80008586:	8082                	ret

Disassembly of section .text.libc.fmodf:

80008588 <fmodf>:
80008588:	01755793          	srl	a5,a0,0x17
8000858c:	80000837          	lui	a6,0x80000
80008590:	17fd                	add	a5,a5,-1
80008592:	0fd00713          	li	a4,253
80008596:	86aa                	mv	a3,a0
80008598:	862e                	mv	a2,a1
8000859a:	00a87833          	and	a6,a6,a0
8000859e:	02f76463          	bltu	a4,a5,800085c6 <.L991>
800085a2:	0175d793          	srl	a5,a1,0x17
800085a6:	17fd                	add	a5,a5,-1
800085a8:	02f77e63          	bgeu	a4,a5,800085e4 <.L992>
800085ac:	00151713          	sll	a4,a0,0x1

800085b0 <.L993>:
800085b0:	00159793          	sll	a5,a1,0x1
800085b4:	ff000637          	lui	a2,0xff000
800085b8:	0cf66663          	bltu	a2,a5,80008684 <.L1009>
800085bc:	ef01                	bnez	a4,800085d4 <.L995>
800085be:	eb91                	bnez	a5,800085d2 <.L994>

800085c0 <.L1011>:
800085c0:	4981a503          	lw	a0,1176(gp) # 80003d28 <.Lmerged_single+0x14>
800085c4:	8082                	ret

800085c6 <.L991>:
800085c6:	00151713          	sll	a4,a0,0x1
800085ca:	ff0007b7          	lui	a5,0xff000
800085ce:	fee7f1e3          	bgeu	a5,a4,800085b0 <.L993>

800085d2 <.L994>:
800085d2:	8082                	ret

800085d4 <.L995>:
800085d4:	fec706e3          	beq	a4,a2,800085c0 <.L1011>
800085d8:	fec78de3          	beq	a5,a2,800085d2 <.L994>
800085dc:	d3f5                	beqz	a5,800085c0 <.L1011>
800085de:	0586                	sll	a1,a1,0x1
800085e0:	0015d613          	srl	a2,a1,0x1

800085e4 <.L992>:
800085e4:	00169793          	sll	a5,a3,0x1
800085e8:	8385                	srl	a5,a5,0x1
800085ea:	00f66663          	bltu	a2,a5,800085f6 <.L996>
800085ee:	fec792e3          	bne	a5,a2,800085d2 <.L994>

800085f2 <.L1018>:
800085f2:	8542                	mv	a0,a6
800085f4:	8082                	ret

800085f6 <.L996>:
800085f6:	0177d713          	srl	a4,a5,0x17
800085fa:	cb0d                	beqz	a4,8000862c <.L1012>
800085fc:	008007b7          	lui	a5,0x800
80008600:	fff78593          	add	a1,a5,-1 # 7fffff <__DLM_segment_end__+0x5bffff>
80008604:	8eed                	and	a3,a3,a1
80008606:	8fd5                	or	a5,a5,a3

80008608 <.L998>:
80008608:	01765593          	srl	a1,a2,0x17
8000860c:	c985                	beqz	a1,8000863c <.L1013>
8000860e:	008006b7          	lui	a3,0x800
80008612:	fff68513          	add	a0,a3,-1 # 7fffff <__DLM_segment_end__+0x5bffff>
80008616:	8e69                	and	a2,a2,a0
80008618:	8e55                	or	a2,a2,a3

8000861a <.L1002>:
8000861a:	40c786b3          	sub	a3,a5,a2
8000861e:	02e5c763          	blt	a1,a4,8000864c <.L1003>
80008622:	0206cc63          	bltz	a3,8000865a <.L1015>
80008626:	8542                	mv	a0,a6
80008628:	ea95                	bnez	a3,8000865c <.L1004>
8000862a:	8082                	ret

8000862c <.L1012>:
8000862c:	4701                	li	a4,0
8000862e:	008006b7          	lui	a3,0x800

80008632 <.L997>:
80008632:	0786                	sll	a5,a5,0x1
80008634:	177d                	add	a4,a4,-1
80008636:	fed7eee3          	bltu	a5,a3,80008632 <.L997>
8000863a:	b7f9                	j	80008608 <.L998>

8000863c <.L1013>:
8000863c:	4581                	li	a1,0
8000863e:	008006b7          	lui	a3,0x800

80008642 <.L999>:
80008642:	0606                	sll	a2,a2,0x1
80008644:	15fd                	add	a1,a1,-1
80008646:	fed66ee3          	bltu	a2,a3,80008642 <.L999>
8000864a:	bfc1                	j	8000861a <.L1002>

8000864c <.L1003>:
8000864c:	0006c463          	bltz	a3,80008654 <.L1001>
80008650:	d2cd                	beqz	a3,800085f2 <.L1018>
80008652:	87b6                	mv	a5,a3

80008654 <.L1001>:
80008654:	0786                	sll	a5,a5,0x1
80008656:	177d                	add	a4,a4,-1
80008658:	b7c9                	j	8000861a <.L1002>

8000865a <.L1015>:
8000865a:	86be                	mv	a3,a5

8000865c <.L1004>:
8000865c:	008007b7          	lui	a5,0x800

80008660 <.L1006>:
80008660:	fff70513          	add	a0,a4,-1
80008664:	00f6ed63          	bltu	a3,a5,8000867e <.L1007>
80008668:	00e04763          	bgtz	a4,80008676 <.L1008>
8000866c:	4785                	li	a5,1
8000866e:	8f99                	sub	a5,a5,a4
80008670:	00f6d6b3          	srl	a3,a3,a5
80008674:	4501                	li	a0,0

80008676 <.L1008>:
80008676:	9836                	add	a6,a6,a3
80008678:	055e                	sll	a0,a0,0x17
8000867a:	9542                	add	a0,a0,a6
8000867c:	8082                	ret

8000867e <.L1007>:
8000867e:	0686                	sll	a3,a3,0x1
80008680:	872a                	mv	a4,a0
80008682:	bff9                	j	80008660 <.L1006>

80008684 <.L1009>:
80008684:	852e                	mv	a0,a1
80008686:	8082                	ret

Disassembly of section .text.libc.memset:

80008688 <memset>:
80008688:	872a                	mv	a4,a0
8000868a:	c22d                	beqz	a2,800086ec <.Lmemset_memset_end>

8000868c <.Lmemset_unaligned_byte_set_loop>:
8000868c:	01e51693          	sll	a3,a0,0x1e
80008690:	c699                	beqz	a3,8000869e <.Lmemset_fast_set>
80008692:	00b50023          	sb	a1,0(a0) # 3f000000 <_extram_size+0x3d000000>
80008696:	0505                	add	a0,a0,1
80008698:	167d                	add	a2,a2,-1 # feffffff <__AHB_SRAM_segment_end__+0xedf7fff>
8000869a:	fa6d                	bnez	a2,8000868c <.Lmemset_unaligned_byte_set_loop>
8000869c:	a881                	j	800086ec <.Lmemset_memset_end>

8000869e <.Lmemset_fast_set>:
8000869e:	0ff5f593          	zext.b	a1,a1
800086a2:	00859693          	sll	a3,a1,0x8
800086a6:	8dd5                	or	a1,a1,a3
800086a8:	01059693          	sll	a3,a1,0x10
800086ac:	8dd5                	or	a1,a1,a3
800086ae:	02000693          	li	a3,32
800086b2:	00d66f63          	bltu	a2,a3,800086d0 <.Lmemset_word_set>

800086b6 <.Lmemset_fast_set_loop>:
800086b6:	c10c                	sw	a1,0(a0)
800086b8:	c14c                	sw	a1,4(a0)
800086ba:	c50c                	sw	a1,8(a0)
800086bc:	c54c                	sw	a1,12(a0)
800086be:	c90c                	sw	a1,16(a0)
800086c0:	c94c                	sw	a1,20(a0)
800086c2:	cd0c                	sw	a1,24(a0)
800086c4:	cd4c                	sw	a1,28(a0)
800086c6:	9536                	add	a0,a0,a3
800086c8:	8e15                	sub	a2,a2,a3
800086ca:	fed676e3          	bgeu	a2,a3,800086b6 <.Lmemset_fast_set_loop>
800086ce:	ce19                	beqz	a2,800086ec <.Lmemset_memset_end>

800086d0 <.Lmemset_word_set>:
800086d0:	4691                	li	a3,4
800086d2:	00d66863          	bltu	a2,a3,800086e2 <.Lmemset_byte_set_loop>

800086d6 <.Lmemset_word_set_loop>:
800086d6:	c10c                	sw	a1,0(a0)
800086d8:	9536                	add	a0,a0,a3
800086da:	8e15                	sub	a2,a2,a3
800086dc:	fed67de3          	bgeu	a2,a3,800086d6 <.Lmemset_word_set_loop>
800086e0:	c611                	beqz	a2,800086ec <.Lmemset_memset_end>

800086e2 <.Lmemset_byte_set_loop>:
800086e2:	00b50023          	sb	a1,0(a0)
800086e6:	0505                	add	a0,a0,1
800086e8:	167d                	add	a2,a2,-1
800086ea:	fe65                	bnez	a2,800086e2 <.Lmemset_byte_set_loop>

800086ec <.Lmemset_memset_end>:
800086ec:	853a                	mv	a0,a4
800086ee:	8082                	ret

Disassembly of section .text.libc.strlen:

800086f0 <strlen>:
800086f0:	85aa                	mv	a1,a0
800086f2:	00357693          	and	a3,a0,3
800086f6:	c29d                	beqz	a3,8000871c <.Lstrlen_aligned>
800086f8:	00054603          	lbu	a2,0(a0)
800086fc:	ce21                	beqz	a2,80008754 <.Lstrlen_done>
800086fe:	0505                	add	a0,a0,1
80008700:	00357693          	and	a3,a0,3
80008704:	ce81                	beqz	a3,8000871c <.Lstrlen_aligned>
80008706:	00054603          	lbu	a2,0(a0)
8000870a:	c629                	beqz	a2,80008754 <.Lstrlen_done>
8000870c:	0505                	add	a0,a0,1
8000870e:	00357693          	and	a3,a0,3
80008712:	c689                	beqz	a3,8000871c <.Lstrlen_aligned>
80008714:	00054603          	lbu	a2,0(a0)
80008718:	ce15                	beqz	a2,80008754 <.Lstrlen_done>
8000871a:	0505                	add	a0,a0,1

8000871c <.Lstrlen_aligned>:
8000871c:	01010637          	lui	a2,0x1010
80008720:	10160613          	add	a2,a2,257 # 1010101 <_flash_size+0x10101>
80008724:	00761693          	sll	a3,a2,0x7

80008728 <.Lstrlen_wordstrlen>:
80008728:	4118                	lw	a4,0(a0)
8000872a:	0511                	add	a0,a0,4
8000872c:	40c707b3          	sub	a5,a4,a2
80008730:	fff74713          	not	a4,a4
80008734:	8ff9                	and	a5,a5,a4
80008736:	8ff5                	and	a5,a5,a3
80008738:	dbe5                	beqz	a5,80008728 <.Lstrlen_wordstrlen>
8000873a:	1571                	add	a0,a0,-4
8000873c:	01879713          	sll	a4,a5,0x18
80008740:	eb11                	bnez	a4,80008754 <.Lstrlen_done>
80008742:	0505                	add	a0,a0,1
80008744:	01079713          	sll	a4,a5,0x10
80008748:	e711                	bnez	a4,80008754 <.Lstrlen_done>
8000874a:	0505                	add	a0,a0,1
8000874c:	00879713          	sll	a4,a5,0x8
80008750:	e311                	bnez	a4,80008754 <.Lstrlen_done>
80008752:	0505                	add	a0,a0,1

80008754 <.Lstrlen_done>:
80008754:	8d0d                	sub	a0,a0,a1
80008756:	8082                	ret

Disassembly of section .text.libc.strnlen:

80008758 <strnlen>:
80008758:	862a                	mv	a2,a0
8000875a:	852e                	mv	a0,a1
8000875c:	c9c9                	beqz	a1,800087ee <.L528>
8000875e:	00064783          	lbu	a5,0(a2)
80008762:	c7c9                	beqz	a5,800087ec <.L534>
80008764:	00367793          	and	a5,a2,3
80008768:	00379693          	sll	a3,a5,0x3
8000876c:	00f58533          	add	a0,a1,a5
80008770:	ffc67713          	and	a4,a2,-4
80008774:	57fd                	li	a5,-1
80008776:	00d797b3          	sll	a5,a5,a3
8000877a:	4314                	lw	a3,0(a4)
8000877c:	fff7c793          	not	a5,a5
80008780:	feff05b7          	lui	a1,0xfeff0
80008784:	80808837          	lui	a6,0x80808
80008788:	8fd5                	or	a5,a5,a3
8000878a:	488d                	li	a7,3
8000878c:	eff58593          	add	a1,a1,-257 # fefefeff <__AHB_SRAM_segment_end__+0xede7eff>
80008790:	08080813          	add	a6,a6,128 # 80808080 <__FLASH_segment_used_end__+0x7fe500>

80008794 <.L530>:
80008794:	00a8ff63          	bgeu	a7,a0,800087b2 <.L529>
80008798:	00b786b3          	add	a3,a5,a1
8000879c:	fff7c313          	not	t1,a5
800087a0:	0066f6b3          	and	a3,a3,t1
800087a4:	0106f6b3          	and	a3,a3,a6
800087a8:	e689                	bnez	a3,800087b2 <.L529>
800087aa:	0711                	add	a4,a4,4
800087ac:	1571                	add	a0,a0,-4
800087ae:	431c                	lw	a5,0(a4)
800087b0:	b7d5                	j	80008794 <.L530>

800087b2 <.L529>:
800087b2:	0ff7f593          	zext.b	a1,a5
800087b6:	c59d                	beqz	a1,800087e4 <.L531>
800087b8:	0087d593          	srl	a1,a5,0x8
800087bc:	0ff5f593          	zext.b	a1,a1
800087c0:	4685                	li	a3,1
800087c2:	cd89                	beqz	a1,800087dc <.L532>
800087c4:	0107d593          	srl	a1,a5,0x10
800087c8:	0ff5f593          	zext.b	a1,a1
800087cc:	4689                	li	a3,2
800087ce:	c599                	beqz	a1,800087dc <.L532>
800087d0:	010005b7          	lui	a1,0x1000
800087d4:	468d                	li	a3,3
800087d6:	00b7e363          	bltu	a5,a1,800087dc <.L532>
800087da:	4691                	li	a3,4

800087dc <.L532>:
800087dc:	85aa                	mv	a1,a0
800087de:	00a6f363          	bgeu	a3,a0,800087e4 <.L531>
800087e2:	85b6                	mv	a1,a3

800087e4 <.L531>:
800087e4:	8f11                	sub	a4,a4,a2
800087e6:	00b70533          	add	a0,a4,a1
800087ea:	8082                	ret

800087ec <.L534>:
800087ec:	4501                	li	a0,0

800087ee <.L528>:
800087ee:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

800087f0 <__SEGGER_RTL_stream_write>:
800087f0:	5154                	lw	a3,36(a0)
800087f2:	87ae                	mv	a5,a1
800087f4:	853e                	mv	a0,a5
800087f6:	4585                	li	a1,1
800087f8:	f3efd06f          	j	80005f36 <fwrite>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

800087fc <__SEGGER_RTL_putc>:
800087fc:	4918                	lw	a4,16(a0)
800087fe:	1101                	add	sp,sp,-32
80008800:	0ff5f593          	zext.b	a1,a1
80008804:	cc22                	sw	s0,24(sp)
80008806:	ce06                	sw	ra,28(sp)
80008808:	00b107a3          	sb	a1,15(sp)
8000880c:	411c                	lw	a5,0(a0)
8000880e:	842a                	mv	s0,a0
80008810:	cb05                	beqz	a4,80008840 <.L24>
80008812:	4154                	lw	a3,4(a0)
80008814:	00d7ff63          	bgeu	a5,a3,80008832 <.L26>
80008818:	495c                	lw	a5,20(a0)
8000881a:	00178693          	add	a3,a5,1 # 800001 <__DLM_segment_end__+0x5c0001>
8000881e:	973e                	add	a4,a4,a5
80008820:	c954                	sw	a3,20(a0)
80008822:	00b70023          	sb	a1,0(a4)
80008826:	4958                	lw	a4,20(a0)
80008828:	4d1c                	lw	a5,24(a0)
8000882a:	00f71463          	bne	a4,a5,80008832 <.L26>
8000882e:	d7afe0ef          	jal	80006da8 <__SEGGER_RTL_prin_flush>

80008832 <.L26>:
80008832:	401c                	lw	a5,0(s0)
80008834:	40f2                	lw	ra,28(sp)
80008836:	0785                	add	a5,a5,1
80008838:	c01c                	sw	a5,0(s0)
8000883a:	4462                	lw	s0,24(sp)
8000883c:	6105                	add	sp,sp,32
8000883e:	8082                	ret

80008840 <.L24>:
80008840:	4558                	lw	a4,12(a0)
80008842:	c305                	beqz	a4,80008862 <.L28>
80008844:	4154                	lw	a3,4(a0)
80008846:	00178613          	add	a2,a5,1
8000884a:	00d61463          	bne	a2,a3,80008852 <.L29>
8000884e:	000107a3          	sb	zero,15(sp)

80008852 <.L29>:
80008852:	fed7f0e3          	bgeu	a5,a3,80008832 <.L26>
80008856:	00f14683          	lbu	a3,15(sp)
8000885a:	973e                	add	a4,a4,a5
8000885c:	00d70023          	sb	a3,0(a4)
80008860:	bfc9                	j	80008832 <.L26>

80008862 <.L28>:
80008862:	4518                	lw	a4,8(a0)
80008864:	c305                	beqz	a4,80008884 <.L30>
80008866:	4154                	lw	a3,4(a0)
80008868:	00178613          	add	a2,a5,1
8000886c:	00d61463          	bne	a2,a3,80008874 <.L31>
80008870:	000107a3          	sb	zero,15(sp)

80008874 <.L31>:
80008874:	fad7ffe3          	bgeu	a5,a3,80008832 <.L26>
80008878:	078a                	sll	a5,a5,0x2
8000887a:	973e                	add	a4,a4,a5
8000887c:	00f14783          	lbu	a5,15(sp)
80008880:	c31c                	sw	a5,0(a4)
80008882:	bf45                	j	80008832 <.L26>

80008884 <.L30>:
80008884:	5118                	lw	a4,32(a0)
80008886:	d755                	beqz	a4,80008832 <.L26>
80008888:	4154                	lw	a3,4(a0)
8000888a:	fad7f4e3          	bgeu	a5,a3,80008832 <.L26>
8000888e:	4605                	li	a2,1
80008890:	00f10593          	add	a1,sp,15
80008894:	9702                	jalr	a4
80008896:	bf71                	j	80008832 <.L26>

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

80008898 <__SEGGER_RTL_print_padding>:
80008898:	1141                	add	sp,sp,-16
8000889a:	c422                	sw	s0,8(sp)
8000889c:	c226                	sw	s1,4(sp)
8000889e:	c04a                	sw	s2,0(sp)
800088a0:	c606                	sw	ra,12(sp)
800088a2:	84aa                	mv	s1,a0
800088a4:	892e                	mv	s2,a1
800088a6:	8432                	mv	s0,a2

800088a8 <.L37>:
800088a8:	147d                	add	s0,s0,-1
800088aa:	00045863          	bgez	s0,800088ba <.L38>
800088ae:	40b2                	lw	ra,12(sp)
800088b0:	4422                	lw	s0,8(sp)
800088b2:	4492                	lw	s1,4(sp)
800088b4:	4902                	lw	s2,0(sp)
800088b6:	0141                	add	sp,sp,16
800088b8:	8082                	ret

800088ba <.L38>:
800088ba:	85ca                	mv	a1,s2
800088bc:	8526                	mv	a0,s1
800088be:	3f3d                	jal	800087fc <__SEGGER_RTL_putc>
800088c0:	b7e5                	j	800088a8 <.L37>

Disassembly of section .text.libc.vfprintf_l:

800088c2 <vfprintf_l>:
800088c2:	711d                	add	sp,sp,-96
800088c4:	ce86                	sw	ra,92(sp)
800088c6:	cca2                	sw	s0,88(sp)
800088c8:	caa6                	sw	s1,84(sp)
800088ca:	1080                	add	s0,sp,96
800088cc:	c8ca                	sw	s2,80(sp)
800088ce:	c6ce                	sw	s3,76(sp)
800088d0:	8932                	mv	s2,a2
800088d2:	fad42623          	sw	a3,-84(s0)
800088d6:	89aa                	mv	s3,a0
800088d8:	fab42423          	sw	a1,-88(s0)
800088dc:	a87fe0ef          	jal	80007362 <__SEGGER_RTL_X_file_bufsize>
800088e0:	fa842583          	lw	a1,-88(s0)
800088e4:	00f50793          	add	a5,a0,15
800088e8:	9bc1                	and	a5,a5,-16
800088ea:	40f10133          	sub	sp,sp,a5
800088ee:	84aa                	mv	s1,a0
800088f0:	fb840513          	add	a0,s0,-72
800088f4:	cf0fe0ef          	jal	80006de4 <__SEGGER_RTL_init_prin_l>
800088f8:	800007b7          	lui	a5,0x80000
800088fc:	fac42603          	lw	a2,-84(s0)
80008900:	17fd                	add	a5,a5,-1 # 7fffffff <_extram_size+0x7dffffff>
80008902:	faf42e23          	sw	a5,-68(s0)
80008906:	800087b7          	lui	a5,0x80008
8000890a:	7f078793          	add	a5,a5,2032 # 800087f0 <__SEGGER_RTL_stream_write>
8000890e:	85ca                	mv	a1,s2
80008910:	fb840513          	add	a0,s0,-72
80008914:	fc242423          	sw	sp,-56(s0)
80008918:	fc942823          	sw	s1,-48(s0)
8000891c:	fd342e23          	sw	s3,-36(s0)
80008920:	fcf42c23          	sw	a5,-40(s0)
80008924:	2811                	jal	80008938 <__SEGGER_RTL_vfprintf>
80008926:	fa040113          	add	sp,s0,-96
8000892a:	40f6                	lw	ra,92(sp)
8000892c:	4466                	lw	s0,88(sp)
8000892e:	44d6                	lw	s1,84(sp)
80008930:	4946                	lw	s2,80(sp)
80008932:	49b6                	lw	s3,76(sp)
80008934:	6125                	add	sp,sp,96
80008936:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

80008938 <__SEGGER_RTL_vfprintf>:
80008938:	7175                	add	sp,sp,-144
8000893a:	2b818793          	add	a5,gp,696 # 80003b48 <.L9>
8000893e:	c83e                	sw	a5,16(sp)
80008940:	dece                	sw	s3,124(sp)
80008942:	dad6                	sw	s5,116(sp)
80008944:	ceee                	sw	s11,92(sp)
80008946:	c706                	sw	ra,140(sp)
80008948:	c522                	sw	s0,136(sp)
8000894a:	c326                	sw	s1,132(sp)
8000894c:	c14a                	sw	s2,128(sp)
8000894e:	dcd2                	sw	s4,120(sp)
80008950:	d8da                	sw	s6,112(sp)
80008952:	d6de                	sw	s7,108(sp)
80008954:	d4e2                	sw	s8,104(sp)
80008956:	d2e6                	sw	s9,100(sp)
80008958:	d0ea                	sw	s10,96(sp)
8000895a:	2fc18793          	add	a5,gp,764 # 80003b8c <.L45>
8000895e:	00020db7          	lui	s11,0x20
80008962:	89aa                	mv	s3,a0
80008964:	8ab2                	mv	s5,a2
80008966:	00052023          	sw	zero,0(a0)
8000896a:	ca3e                	sw	a5,20(sp)
8000896c:	021d8d93          	add	s11,s11,33 # 20021 <__AHB_SRAM_segment_size__+0x18021>

80008970 <.L2>:
80008970:	00158a13          	add	s4,a1,1 # 1000001 <_flash_size+0x1>
80008974:	0005c583          	lbu	a1,0(a1)
80008978:	e19d                	bnez	a1,8000899e <.L229>
8000897a:	00c9a783          	lw	a5,12(s3)
8000897e:	cb91                	beqz	a5,80008992 <.L230>
80008980:	0009a703          	lw	a4,0(s3)
80008984:	0049a683          	lw	a3,4(s3)
80008988:	00d77563          	bgeu	a4,a3,80008992 <.L230>
8000898c:	97ba                	add	a5,a5,a4
8000898e:	00078023          	sb	zero,0(a5)

80008992 <.L230>:
80008992:	854e                	mv	a0,s3
80008994:	c14fe0ef          	jal	80006da8 <__SEGGER_RTL_prin_flush>
80008998:	0009a503          	lw	a0,0(s3)
8000899c:	a2f9                	j	80008b6a <.L338>

8000899e <.L229>:
8000899e:	02500793          	li	a5,37
800089a2:	00f58563          	beq	a1,a5,800089ac <.L231>

800089a6 <.L362>:
800089a6:	854e                	mv	a0,s3
800089a8:	3d91                	jal	800087fc <__SEGGER_RTL_putc>
800089aa:	aab9                	j	80008b08 <.L4>

800089ac <.L231>:
800089ac:	4b81                	li	s7,0
800089ae:	03000613          	li	a2,48
800089b2:	05e00593          	li	a1,94
800089b6:	6505                	lui	a0,0x1
800089b8:	487d                	li	a6,31
800089ba:	48c1                	li	a7,16
800089bc:	6321                	lui	t1,0x8
800089be:	a03d                	j	800089ec <.L3>

800089c0 <.L5>:
800089c0:	04b78f63          	beq	a5,a1,80008a1e <.L15>

800089c4 <.L232>:
800089c4:	8a36                	mv	s4,a3
800089c6:	4b01                	li	s6,0
800089c8:	46a5                	li	a3,9
800089ca:	45a9                	li	a1,10

800089cc <.L18>:
800089cc:	fd078713          	add	a4,a5,-48
800089d0:	0ff77613          	zext.b	a2,a4
800089d4:	08c6e363          	bltu	a3,a2,80008a5a <.L20>
800089d8:	02bb0b33          	mul	s6,s6,a1
800089dc:	0a05                	add	s4,s4,1
800089de:	fffa4783          	lbu	a5,-1(s4)
800089e2:	9b3a                	add	s6,s6,a4
800089e4:	b7e5                	j	800089cc <.L18>

800089e6 <.L14>:
800089e6:	040beb93          	or	s7,s7,64

800089ea <.L16>:
800089ea:	8a36                	mv	s4,a3

800089ec <.L3>:
800089ec:	000a4783          	lbu	a5,0(s4)
800089f0:	001a0693          	add	a3,s4,1
800089f4:	fcf666e3          	bltu	a2,a5,800089c0 <.L5>
800089f8:	fcf876e3          	bgeu	a6,a5,800089c4 <.L232>
800089fc:	fe078713          	add	a4,a5,-32
80008a00:	0ff77713          	zext.b	a4,a4
80008a04:	02e8e963          	bltu	a7,a4,80008a36 <.L7>
80008a08:	4442                	lw	s0,16(sp)
80008a0a:	070a                	sll	a4,a4,0x2
80008a0c:	9722                	add	a4,a4,s0
80008a0e:	4318                	lw	a4,0(a4)
80008a10:	8702                	jr	a4

80008a12 <.L13>:
80008a12:	080beb93          	or	s7,s7,128
80008a16:	bfd1                	j	800089ea <.L16>

80008a18 <.L12>:
80008a18:	006bebb3          	or	s7,s7,t1
80008a1c:	b7f9                	j	800089ea <.L16>

80008a1e <.L15>:
80008a1e:	00abebb3          	or	s7,s7,a0
80008a22:	b7e1                	j	800089ea <.L16>

80008a24 <.L11>:
80008a24:	020beb93          	or	s7,s7,32
80008a28:	b7c9                	j	800089ea <.L16>

80008a2a <.L10>:
80008a2a:	010beb93          	or	s7,s7,16
80008a2e:	bf75                	j	800089ea <.L16>

80008a30 <.L8>:
80008a30:	200beb93          	or	s7,s7,512
80008a34:	bf5d                	j	800089ea <.L16>

80008a36 <.L7>:
80008a36:	02a00713          	li	a4,42
80008a3a:	f8e795e3          	bne	a5,a4,800089c4 <.L232>
80008a3e:	000aab03          	lw	s6,0(s5)
80008a42:	004a8713          	add	a4,s5,4
80008a46:	000b5663          	bgez	s6,80008a52 <.L19>
80008a4a:	41600b33          	neg	s6,s6
80008a4e:	010beb93          	or	s7,s7,16

80008a52 <.L19>:
80008a52:	0006c783          	lbu	a5,0(a3) # 800000 <__DLM_segment_end__+0x5c0000>
80008a56:	0a09                	add	s4,s4,2
80008a58:	8aba                	mv	s5,a4

80008a5a <.L20>:
80008a5a:	000b5363          	bgez	s6,80008a60 <.L22>
80008a5e:	4b01                	li	s6,0

80008a60 <.L22>:
80008a60:	02e00713          	li	a4,46
80008a64:	4481                	li	s1,0
80008a66:	04e79263          	bne	a5,a4,80008aaa <.L23>
80008a6a:	000a4783          	lbu	a5,0(s4)
80008a6e:	02a00713          	li	a4,42
80008a72:	02e78263          	beq	a5,a4,80008a96 <.L24>
80008a76:	0a05                	add	s4,s4,1
80008a78:	46a5                	li	a3,9
80008a7a:	45a9                	li	a1,10

80008a7c <.L25>:
80008a7c:	fd078713          	add	a4,a5,-48
80008a80:	0ff77613          	zext.b	a2,a4
80008a84:	00c6ef63          	bltu	a3,a2,80008aa2 <.L26>
80008a88:	02b484b3          	mul	s1,s1,a1
80008a8c:	0a05                	add	s4,s4,1
80008a8e:	fffa4783          	lbu	a5,-1(s4)
80008a92:	94ba                	add	s1,s1,a4
80008a94:	b7e5                	j	80008a7c <.L25>

80008a96 <.L24>:
80008a96:	000aa483          	lw	s1,0(s5)
80008a9a:	001a4783          	lbu	a5,1(s4)
80008a9e:	0a91                	add	s5,s5,4
80008aa0:	0a09                	add	s4,s4,2

80008aa2 <.L26>:
80008aa2:	0004c463          	bltz	s1,80008aaa <.L23>
80008aa6:	100beb93          	or	s7,s7,256

80008aaa <.L23>:
80008aaa:	06c00713          	li	a4,108
80008aae:	06e78263          	beq	a5,a4,80008b12 <.L28>
80008ab2:	02f76c63          	bltu	a4,a5,80008aea <.L29>
80008ab6:	06800713          	li	a4,104
80008aba:	06e78a63          	beq	a5,a4,80008b2e <.L30>
80008abe:	06a00713          	li	a4,106
80008ac2:	04e78563          	beq	a5,a4,80008b0c <.L31>

80008ac6 <.L32>:
80008ac6:	05700713          	li	a4,87
80008aca:	2af760e3          	bltu	a4,a5,8000956a <.L38>
80008ace:	04500713          	li	a4,69
80008ad2:	2ce78563          	beq	a5,a4,80008d9c <.L39>
80008ad6:	06f76763          	bltu	a4,a5,80008b44 <.L40>
80008ada:	c7c1                	beqz	a5,80008b62 <.L41>
80008adc:	02500713          	li	a4,37
80008ae0:	02500593          	li	a1,37
80008ae4:	ece781e3          	beq	a5,a4,800089a6 <.L362>
80008ae8:	a005                	j	80008b08 <.L4>

80008aea <.L29>:
80008aea:	07400713          	li	a4,116
80008aee:	00e78663          	beq	a5,a4,80008afa <.L346>
80008af2:	07a00713          	li	a4,122
80008af6:	26e796e3          	bne	a5,a4,80009562 <.L34>

80008afa <.L346>:
80008afa:	000a4783          	lbu	a5,0(s4)
80008afe:	0a05                	add	s4,s4,1

80008b00 <.L35>:
80008b00:	07800713          	li	a4,120
80008b04:	fcf771e3          	bgeu	a4,a5,80008ac6 <.L32>

80008b08 <.L4>:
80008b08:	85d2                	mv	a1,s4
80008b0a:	b59d                	j	80008970 <.L2>

80008b0c <.L31>:
80008b0c:	002beb93          	or	s7,s7,2
80008b10:	b7ed                	j	80008afa <.L346>

80008b12 <.L28>:
80008b12:	000a4783          	lbu	a5,0(s4)
80008b16:	00e79863          	bne	a5,a4,80008b26 <.L36>
80008b1a:	002beb93          	or	s7,s7,2

80008b1e <.L347>:
80008b1e:	001a4783          	lbu	a5,1(s4)
80008b22:	0a09                	add	s4,s4,2
80008b24:	bff1                	j	80008b00 <.L35>

80008b26 <.L36>:
80008b26:	0a05                	add	s4,s4,1
80008b28:	001beb93          	or	s7,s7,1
80008b2c:	bfd1                	j	80008b00 <.L35>

80008b2e <.L30>:
80008b2e:	000a4783          	lbu	a5,0(s4)
80008b32:	00e79563          	bne	a5,a4,80008b3c <.L37>
80008b36:	008beb93          	or	s7,s7,8
80008b3a:	b7d5                	j	80008b1e <.L347>

80008b3c <.L37>:
80008b3c:	0a05                	add	s4,s4,1
80008b3e:	004beb93          	or	s7,s7,4
80008b42:	bf7d                	j	80008b00 <.L35>

80008b44 <.L40>:
80008b44:	04600713          	li	a4,70
80008b48:	2ce78263          	beq	a5,a4,80008e0c <.L57>
80008b4c:	04700713          	li	a4,71
80008b50:	fae79ce3          	bne	a5,a4,80008b08 <.L4>
80008b54:	6789                	lui	a5,0x2
80008b56:	00fbebb3          	or	s7,s7,a5

80008b5a <.L52>:
80008b5a:	6905                	lui	s2,0x1
80008b5c:	c0090913          	add	s2,s2,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
80008b60:	ac65                	j	80008e18 <.L353>

80008b62 <.L41>:
80008b62:	854e                	mv	a0,s3
80008b64:	a44fe0ef          	jal	80006da8 <__SEGGER_RTL_prin_flush>
80008b68:	557d                	li	a0,-1

80008b6a <.L338>:
80008b6a:	40ba                	lw	ra,140(sp)
80008b6c:	442a                	lw	s0,136(sp)
80008b6e:	449a                	lw	s1,132(sp)
80008b70:	490a                	lw	s2,128(sp)
80008b72:	59f6                	lw	s3,124(sp)
80008b74:	5a66                	lw	s4,120(sp)
80008b76:	5ad6                	lw	s5,116(sp)
80008b78:	5b46                	lw	s6,112(sp)
80008b7a:	5bb6                	lw	s7,108(sp)
80008b7c:	5c26                	lw	s8,104(sp)
80008b7e:	5c96                	lw	s9,100(sp)
80008b80:	5d06                	lw	s10,96(sp)
80008b82:	4df6                	lw	s11,92(sp)
80008b84:	6149                	add	sp,sp,144
80008b86:	8082                	ret

80008b88 <.L55>:
80008b88:	000aa483          	lw	s1,0(s5)
80008b8c:	1b7d                	add	s6,s6,-1
80008b8e:	865a                	mv	a2,s6
80008b90:	85de                	mv	a1,s7
80008b92:	854e                	mv	a0,s3
80008b94:	a36fe0ef          	jal	80006dca <__SEGGER_RTL_pre_padding>
80008b98:	004a8413          	add	s0,s5,4
80008b9c:	0ff4f593          	zext.b	a1,s1
80008ba0:	854e                	mv	a0,s3
80008ba2:	39a9                	jal	800087fc <__SEGGER_RTL_putc>
80008ba4:	8aa2                	mv	s5,s0

80008ba6 <.L371>:
80008ba6:	010bfb93          	and	s7,s7,16
80008baa:	f40b8fe3          	beqz	s7,80008b08 <.L4>
80008bae:	865a                	mv	a2,s6
80008bb0:	02000593          	li	a1,32
80008bb4:	854e                	mv	a0,s3
80008bb6:	31cd                	jal	80008898 <__SEGGER_RTL_print_padding>
80008bb8:	bf81                	j	80008b08 <.L4>

80008bba <.L50>:
80008bba:	008bf693          	and	a3,s7,8
80008bbe:	000aa783          	lw	a5,0(s5)
80008bc2:	0009a703          	lw	a4,0(s3)
80008bc6:	0a91                	add	s5,s5,4
80008bc8:	c681                	beqz	a3,80008bd0 <.L62>
80008bca:	00e78023          	sb	a4,0(a5) # 2000 <__BOOT_HEADER_segment_size__>
80008bce:	bf2d                	j	80008b08 <.L4>

80008bd0 <.L62>:
80008bd0:	002bfb93          	and	s7,s7,2
80008bd4:	c398                	sw	a4,0(a5)
80008bd6:	f20b89e3          	beqz	s7,80008b08 <.L4>
80008bda:	0007a223          	sw	zero,4(a5)
80008bde:	b72d                	j	80008b08 <.L4>

80008be0 <.L47>:
80008be0:	000aa403          	lw	s0,0(s5)
80008be4:	895e                	mv	s2,s7
80008be6:	0a91                	add	s5,s5,4

80008be8 <.L65>:
80008be8:	e019                	bnez	s0,80008bee <.L66>
80008bea:	28818413          	add	s0,gp,648 # 80003b18 <.LC0>

80008bee <.L66>:
80008bee:	dff97b93          	and	s7,s2,-513
80008bf2:	10097913          	and	s2,s2,256
80008bf6:	02090563          	beqz	s2,80008c20 <.L67>
80008bfa:	85a6                	mv	a1,s1
80008bfc:	8522                	mv	a0,s0
80008bfe:	3ea9                	jal	80008758 <strnlen>

80008c00 <.L348>:
80008c00:	40ab0b33          	sub	s6,s6,a0
80008c04:	84aa                	mv	s1,a0
80008c06:	865a                	mv	a2,s6
80008c08:	85de                	mv	a1,s7
80008c0a:	854e                	mv	a0,s3
80008c0c:	9befe0ef          	jal	80006dca <__SEGGER_RTL_pre_padding>

80008c10 <.L69>:
80008c10:	d8d9                	beqz	s1,80008ba6 <.L371>
80008c12:	00044583          	lbu	a1,0(s0)
80008c16:	854e                	mv	a0,s3
80008c18:	0405                	add	s0,s0,1
80008c1a:	36cd                	jal	800087fc <__SEGGER_RTL_putc>
80008c1c:	14fd                	add	s1,s1,-1
80008c1e:	bfcd                	j	80008c10 <.L69>

80008c20 <.L67>:
80008c20:	8522                	mv	a0,s0
80008c22:	34f9                	jal	800086f0 <strlen>
80008c24:	bff1                	j	80008c00 <.L348>

80008c26 <.L48>:
80008c26:	080bf713          	and	a4,s7,128
80008c2a:	000aa403          	lw	s0,0(s5)
80008c2e:	004a8693          	add	a3,s5,4
80008c32:	4581                	li	a1,0
80008c34:	02300c93          	li	s9,35
80008c38:	e311                	bnez	a4,80008c3c <.L71>
80008c3a:	4c81                	li	s9,0

80008c3c <.L71>:
80008c3c:	100beb93          	or	s7,s7,256
80008c40:	8ab6                	mv	s5,a3
80008c42:	44a1                	li	s1,8

80008c44 <.L72>:
80008c44:	100bf713          	and	a4,s7,256
80008c48:	e311                	bnez	a4,80008c4c <.L203>
80008c4a:	4485                	li	s1,1

80008c4c <.L203>:
80008c4c:	05800713          	li	a4,88
80008c50:	04e78ae3          	beq	a5,a4,800094a4 <.L204>
80008c54:	f9c78693          	add	a3,a5,-100
80008c58:	4705                	li	a4,1
80008c5a:	00d71733          	sll	a4,a4,a3
80008c5e:	01b776b3          	and	a3,a4,s11
80008c62:	7c069c63          	bnez	a3,8000943a <.L205>
80008c66:	00c75693          	srl	a3,a4,0xc
80008c6a:	1016f693          	and	a3,a3,257
80008c6e:	02069be3          	bnez	a3,800094a4 <.L204>
80008c72:	06f00713          	li	a4,111
80008c76:	4c01                	li	s8,0
80008c78:	04e791e3          	bne	a5,a4,800094ba <.L206>

80008c7c <.L207>:
80008c7c:	00b467b3          	or	a5,s0,a1
80008c80:	02078de3          	beqz	a5,800094ba <.L206>
80008c84:	183c                	add	a5,sp,56
80008c86:	01878733          	add	a4,a5,s8
80008c8a:	00747793          	and	a5,s0,7
80008c8e:	03078793          	add	a5,a5,48
80008c92:	00f70023          	sb	a5,0(a4)
80008c96:	800d                	srl	s0,s0,0x3
80008c98:	01d59793          	sll	a5,a1,0x1d
80008c9c:	0c05                	add	s8,s8,1
80008c9e:	8c5d                	or	s0,s0,a5
80008ca0:	818d                	srl	a1,a1,0x3
80008ca2:	bfe9                	j	80008c7c <.L207>

80008ca4 <.L56>:
80008ca4:	6709                	lui	a4,0x2
80008ca6:	00ebebb3          	or	s7,s7,a4

80008caa <.L44>:
80008caa:	080bf713          	and	a4,s7,128
80008cae:	4c81                	li	s9,0
80008cb0:	cb19                	beqz	a4,80008cc6 <.L75>
80008cb2:	6c8d                	lui	s9,0x3
80008cb4:	07800713          	li	a4,120
80008cb8:	058c8c93          	add	s9,s9,88 # 3058 <__BOOT_HEADER_segment_size__+0x1058>
80008cbc:	00e79563          	bne	a5,a4,80008cc6 <.L75>
80008cc0:	6c8d                	lui	s9,0x3
80008cc2:	078c8c93          	add	s9,s9,120 # 3078 <__BOOT_HEADER_segment_size__+0x1078>

80008cc6 <.L75>:
80008cc6:	100bf713          	and	a4,s7,256

80008cca <.L365>:
80008cca:	c319                	beqz	a4,80008cd0 <.L74>
80008ccc:	dffbfb93          	and	s7,s7,-513

80008cd0 <.L74>:
80008cd0:	011b9613          	sll	a2,s7,0x11
80008cd4:	002bf713          	and	a4,s7,2
80008cd8:	004bf693          	and	a3,s7,4
80008cdc:	08065563          	bgez	a2,80008d66 <.L76>
80008ce0:	cf31                	beqz	a4,80008d3c <.L77>
80008ce2:	007a8713          	add	a4,s5,7
80008ce6:	9b61                	and	a4,a4,-8
80008ce8:	4300                	lw	s0,0(a4)
80008cea:	434c                	lw	a1,4(a4)
80008cec:	00870a93          	add	s5,a4,8 # 2008 <__BOOT_HEADER_segment_size__+0x8>

80008cf0 <.L78>:
80008cf0:	cea1                	beqz	a3,80008d48 <.L79>
80008cf2:	0442                	sll	s0,s0,0x10
80008cf4:	8441                	sra	s0,s0,0x10

80008cf6 <.L351>:
80008cf6:	41f45593          	sra	a1,s0,0x1f

80008cfa <.L80>:
80008cfa:	0405dd63          	bgez	a1,80008d54 <.L82>
80008cfe:	00803733          	snez	a4,s0
80008d02:	40b005b3          	neg	a1,a1
80008d06:	8d99                	sub	a1,a1,a4
80008d08:	40800433          	neg	s0,s0
80008d0c:	02d00c93          	li	s9,45

80008d10 <.L84>:
80008d10:	100bf713          	and	a4,s7,256
80008d14:	db05                	beqz	a4,80008c44 <.L72>
80008d16:	dffbfb93          	and	s7,s7,-513
80008d1a:	b72d                	j	80008c44 <.L72>

80008d1c <.L49>:
80008d1c:	080bf713          	and	a4,s7,128
80008d20:	03000c93          	li	s9,48
80008d24:	f34d                	bnez	a4,80008cc6 <.L75>
80008d26:	4c81                	li	s9,0
80008d28:	bf79                	j	80008cc6 <.L75>

80008d2a <.L46>:
80008d2a:	100bf713          	and	a4,s7,256
80008d2e:	4c81                	li	s9,0
80008d30:	bf69                	j	80008cca <.L365>

80008d32 <.L51>:
80008d32:	6711                	lui	a4,0x4
80008d34:	00ebebb3          	or	s7,s7,a4
80008d38:	4c81                	li	s9,0
80008d3a:	bf59                	j	80008cd0 <.L74>

80008d3c <.L77>:
80008d3c:	000aa403          	lw	s0,0(s5)
80008d40:	0a91                	add	s5,s5,4
80008d42:	41f45593          	sra	a1,s0,0x1f
80008d46:	b76d                	j	80008cf0 <.L78>

80008d48 <.L79>:
80008d48:	008bf713          	and	a4,s7,8
80008d4c:	d75d                	beqz	a4,80008cfa <.L80>
80008d4e:	0462                	sll	s0,s0,0x18
80008d50:	8461                	sra	s0,s0,0x18
80008d52:	b755                	j	80008cf6 <.L351>

80008d54 <.L82>:
80008d54:	020bf713          	and	a4,s7,32
80008d58:	ef1d                	bnez	a4,80008d96 <.L239>
80008d5a:	040bf713          	and	a4,s7,64
80008d5e:	db4d                	beqz	a4,80008d10 <.L84>
80008d60:	02000c93          	li	s9,32
80008d64:	b775                	j	80008d10 <.L84>

80008d66 <.L76>:
80008d66:	cf09                	beqz	a4,80008d80 <.L85>
80008d68:	007a8713          	add	a4,s5,7
80008d6c:	9b61                	and	a4,a4,-8
80008d6e:	4300                	lw	s0,0(a4)
80008d70:	434c                	lw	a1,4(a4)
80008d72:	00870a93          	add	s5,a4,8 # 4008 <__HEAPSIZE__+0x8>

80008d76 <.L86>:
80008d76:	ca91                	beqz	a3,80008d8a <.L87>
80008d78:	0442                	sll	s0,s0,0x10
80008d7a:	8041                	srl	s0,s0,0x10

80008d7c <.L352>:
80008d7c:	4581                	li	a1,0
80008d7e:	bf49                	j	80008d10 <.L84>

80008d80 <.L85>:
80008d80:	000aa403          	lw	s0,0(s5)
80008d84:	4581                	li	a1,0
80008d86:	0a91                	add	s5,s5,4
80008d88:	b7fd                	j	80008d76 <.L86>

80008d8a <.L87>:
80008d8a:	008bf713          	and	a4,s7,8
80008d8e:	d349                	beqz	a4,80008d10 <.L84>
80008d90:	0ff47413          	zext.b	s0,s0
80008d94:	b7e5                	j	80008d7c <.L352>

80008d96 <.L239>:
80008d96:	02b00c93          	li	s9,43
80008d9a:	bf9d                	j	80008d10 <.L84>

80008d9c <.L39>:
80008d9c:	6789                	lui	a5,0x2
80008d9e:	00fbebb3          	or	s7,s7,a5

80008da2 <.L54>:
80008da2:	400be913          	or	s2,s7,1024

80008da6 <.L91>:
80008da6:	00297793          	and	a5,s2,2
80008daa:	cbb5                	beqz	a5,80008e1e <.L92>
80008dac:	000aa783          	lw	a5,0(s5)
80008db0:	1008                	add	a0,sp,32
80008db2:	004a8413          	add	s0,s5,4
80008db6:	4398                	lw	a4,0(a5)
80008db8:	8aa2                	mv	s5,s0
80008dba:	d03a                	sw	a4,32(sp)
80008dbc:	43d8                	lw	a4,4(a5)
80008dbe:	d23a                	sw	a4,36(sp)
80008dc0:	4798                	lw	a4,8(a5)
80008dc2:	d43a                	sw	a4,40(sp)
80008dc4:	47dc                	lw	a5,12(a5)
80008dc6:	d63e                	sw	a5,44(sp)
80008dc8:	f28ff0ef          	jal	800084f0 <__trunctfsf2>
80008dcc:	8baa                	mv	s7,a0

80008dce <.L93>:
80008dce:	10097793          	and	a5,s2,256
80008dd2:	c3ad                	beqz	a5,80008e34 <.L240>
80008dd4:	e889                	bnez	s1,80008de6 <.L94>
80008dd6:	6785                	lui	a5,0x1
80008dd8:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
80008ddc:	00f974b3          	and	s1,s2,a5
80008de0:	8c9d                	sub	s1,s1,a5
80008de2:	0014b493          	seqz	s1,s1

80008de6 <.L94>:
80008de6:	855e                	mv	a0,s7
80008de8:	de6fd0ef          	jal	800063ce <__SEGGER_RTL_float32_isinf>
80008dec:	c531                	beqz	a0,80008e38 <.L95>

80008dee <.L117>:
80008dee:	6409                	lui	s0,0x2
80008df0:	00000593          	li	a1,0
80008df4:	855e                	mv	a0,s7
80008df6:	00897433          	and	s0,s2,s0
80008dfa:	b38fd0ef          	jal	80006132 <__ltsf2>
80008dfe:	3e055963          	bgez	a0,800091f0 <.L341>
80008e02:	3e040463          	beqz	s0,800091ea <.L244>
80008e06:	29018413          	add	s0,gp,656 # 80003b20 <.LC1>
80008e0a:	a089                	j	80008e4c <.L122>

80008e0c <.L57>:
80008e0c:	6789                	lui	a5,0x2
80008e0e:	00fbebb3          	or	s7,s7,a5

80008e12 <.L53>:
80008e12:	6905                	lui	s2,0x1
80008e14:	80090913          	add	s2,s2,-2048 # 800 <__ILM_segment_used_end__+0x33e>

80008e18 <.L353>:
80008e18:	012be933          	or	s2,s7,s2
80008e1c:	b769                	j	80008da6 <.L91>

80008e1e <.L92>:
80008e1e:	007a8793          	add	a5,s5,7
80008e22:	9be1                	and	a5,a5,-8
80008e24:	4388                	lw	a0,0(a5)
80008e26:	43cc                	lw	a1,4(a5)
80008e28:	00878a93          	add	s5,a5,8 # 2008 <__BOOT_HEADER_segment_size__+0x8>
80008e2c:	c90fd0ef          	jal	800062bc <__truncdfsf2>
80008e30:	8baa                	mv	s7,a0
80008e32:	bf71                	j	80008dce <.L93>

80008e34 <.L240>:
80008e34:	4499                	li	s1,6
80008e36:	bf45                	j	80008de6 <.L94>

80008e38 <.L95>:
80008e38:	855e                	mv	a0,s7
80008e3a:	d82fd0ef          	jal	800063bc <__SEGGER_RTL_float32_isnan>
80008e3e:	cd09                	beqz	a0,80008e58 <.L101>
80008e40:	01291793          	sll	a5,s2,0x12
80008e44:	0007d763          	bgez	a5,80008e52 <.L243>
80008e48:	2b018413          	add	s0,gp,688 # 80003b40 <.LC5>

80008e4c <.L122>:
80008e4c:	eff97913          	and	s2,s2,-257
80008e50:	bb61                	j	80008be8 <.L65>

80008e52 <.L243>:
80008e52:	2b418413          	add	s0,gp,692 # 80003b44 <.LC6>
80008e56:	bfdd                	j	80008e4c <.L122>

80008e58 <.L101>:
80008e58:	855e                	mv	a0,s7
80008e5a:	d82fd0ef          	jal	800063dc <__SEGGER_RTL_float32_isnormal>
80008e5e:	e119                	bnez	a0,80008e64 <.L103>
80008e60:	00000b93          	li	s7,0

80008e64 <.L103>:
80008e64:	855e                	mv	a0,s7
80008e66:	845e                	mv	s0,s7
80008e68:	eacff0ef          	jal	80008514 <__SEGGER_RTL_float32_signbit>
80008e6c:	c519                	beqz	a0,80008e7a <.L104>
80008e6e:	80000437          	lui	s0,0x80000
80008e72:	06096913          	or	s2,s2,96
80008e76:	01744433          	xor	s0,s0,s7

80008e7a <.L104>:
80008e7a:	184c                	add	a1,sp,52
80008e7c:	8522                	mv	a0,s0
80008e7e:	edeff0ef          	jal	8000855c <frexpf>
80008e82:	5752                	lw	a4,52(sp)
80008e84:	478d                	li	a5,3
80008e86:	00000593          	li	a1,0
80008e8a:	02e787b3          	mul	a5,a5,a4
80008e8e:	4729                	li	a4,10
80008e90:	8522                	mv	a0,s0
80008e92:	8ba2                	mv	s7,s0
80008e94:	02e7c7b3          	div	a5,a5,a4
80008e98:	da3e                	sw	a5,52(sp)
80008e9a:	dcaff0ef          	jal	80008464 <__eqsf2>
80008e9e:	24051063          	bnez	a0,800090de <.L105>

80008ea2 <.L111>:
80008ea2:	6785                	lui	a5,0x1
80008ea4:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
80008ea8:	00f97c33          	and	s8,s2,a5
80008eac:	40000713          	li	a4,1024
80008eb0:	5552                	lw	a0,52(sp)
80008eb2:	24ec1d63          	bne	s8,a4,8000910c <.L340>

80008eb6 <.L106>:
80008eb6:	02600793          	li	a5,38
80008eba:	30f51f63          	bne	a0,a5,800091d8 <.L113>
80008ebe:	4941a583          	lw	a1,1172(gp) # 80003d24 <.Lmerged_single+0x10>
80008ec2:	855e                	mv	a0,s7
80008ec4:	ca0ff0ef          	jal	80008364 <__divsf3>

80008ec8 <.L354>:
80008ec8:	00000593          	li	a1,0
80008ecc:	8baa                	mv	s7,a0
80008ece:	842a                	mv	s0,a0
80008ed0:	d94ff0ef          	jal	80008464 <__eqsf2>
80008ed4:	cd39                	beqz	a0,80008f32 <.L116>
80008ed6:	855e                	mv	a0,s7
80008ed8:	cf6fd0ef          	jal	800063ce <__SEGGER_RTL_float32_isinf>
80008edc:	f00519e3          	bnez	a0,80008dee <.L117>
80008ee0:	57d2                	lw	a5,52(sp)
80008ee2:	4701                	li	a4,0

80008ee4 <.L118>:
80008ee4:	c63e                	sw	a5,12(sp)
80008ee6:	00178d13          	add	s10,a5,1
80008eea:	48c1a583          	lw	a1,1164(gp) # 80003d1c <.Lmerged_single+0x8>
80008eee:	855e                	mv	a0,s7
80008ef0:	cc3a                	sw	a4,24(sp)
80008ef2:	ae2fd0ef          	jal	800061d4 <__gesf2>
80008ef6:	47b2                	lw	a5,12(sp)
80008ef8:	4762                	lw	a4,24(sp)
80008efa:	30055763          	bgez	a0,80009208 <.L124>
80008efe:	c319                	beqz	a4,80008f04 <.L125>
80008f00:	845e                	mv	s0,s7
80008f02:	da3e                	sw	a5,52(sp)

80008f04 <.L125>:
80008f04:	4881a703          	lw	a4,1160(gp) # 80003d18 <.Lmerged_single+0x4>
80008f08:	5d52                	lw	s10,52(sp)
80008f0a:	48c1ac83          	lw	s9,1164(gp) # 80003d1c <.Lmerged_single+0x8>
80008f0e:	87a2                	mv	a5,s0
80008f10:	4681                	li	a3,0
80008f12:	c63a                	sw	a4,12(sp)

80008f14 <.L126>:
80008f14:	45b2                	lw	a1,12(sp)
80008f16:	853e                	mv	a0,a5
80008f18:	ce36                	sw	a3,28(sp)
80008f1a:	cc3e                	sw	a5,24(sp)
80008f1c:	a16fd0ef          	jal	80006132 <__ltsf2>
80008f20:	47e2                	lw	a5,24(sp)
80008f22:	46f2                	lw	a3,28(sp)
80008f24:	fffd0b93          	add	s7,s10,-1
80008f28:	2e054963          	bltz	a0,8000921a <.L127>
80008f2c:	c299                	beqz	a3,80008f32 <.L116>
80008f2e:	843e                	mv	s0,a5
80008f30:	da6a                	sw	s10,52(sp)

80008f32 <.L116>:
80008f32:	c499                	beqz	s1,80008f40 <.L129>
80008f34:	6785                	lui	a5,0x1
80008f36:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
80008f3a:	00fc1363          	bne	s8,a5,80008f40 <.L129>
80008f3e:	14fd                	add	s1,s1,-1

80008f40 <.L129>:
80008f40:	40900533          	neg	a0,s1
80008f44:	e13fd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
80008f48:	55fd                	li	a1,-1
80008f4a:	dceff0ef          	jal	80008518 <ldexpf>
80008f4e:	85a2                	mv	a1,s0
80008f50:	834fd0ef          	jal	80005f84 <__addsf3>
80008f54:	48c1a583          	lw	a1,1164(gp) # 80003d1c <.Lmerged_single+0x8>
80008f58:	8baa                	mv	s7,a0
80008f5a:	842a                	mv	s0,a0
80008f5c:	a78fd0ef          	jal	800061d4 <__gesf2>
80008f60:	00054b63          	bltz	a0,80008f76 <.L130>
80008f64:	57d2                	lw	a5,52(sp)
80008f66:	48c1a583          	lw	a1,1164(gp) # 80003d1c <.Lmerged_single+0x8>
80008f6a:	855e                	mv	a0,s7
80008f6c:	0785                	add	a5,a5,1
80008f6e:	da3e                	sw	a5,52(sp)
80008f70:	bf4ff0ef          	jal	80008364 <__divsf3>
80008f74:	842a                	mv	s0,a0

80008f76 <.L130>:
80008f76:	c622                	sw	s0,12(sp)
80008f78:	2a049963          	bnez	s1,8000922a <.L132>

80008f7c <.L135>:
80008f7c:	4481                	li	s1,0

80008f7e <.L133>:
80008f7e:	00548793          	add	a5,s1,5
80008f82:	7c7d                	lui	s8,0xfffff
80008f84:	40fb0b33          	sub	s6,s6,a5
80008f88:	08097793          	and	a5,s2,128
80008f8c:	7ffc0c13          	add	s8,s8,2047 # fffff7ff <__AHB_SRAM_segment_end__+0xfdf77ff>
80008f90:	8fc5                	or	a5,a5,s1
80008f92:	01897c33          	and	s8,s2,s8
80008f96:	c391                	beqz	a5,80008f9a <.L139>
80008f98:	1b7d                	add	s6,s6,-1

80008f9a <.L139>:
80008f9a:	01391793          	sll	a5,s2,0x13
80008f9e:	4d05                	li	s10,1
80008fa0:	0207dc63          	bgez	a5,80008fd8 <.L140>
80008fa4:	5bd2                	lw	s7,52(sp)
80008fa6:	470d                	li	a4,3
80008fa8:	02ebe733          	rem	a4,s7,a4
80008fac:	c31d                	beqz	a4,80008fd2 <.L141>
80008fae:	0709                	add	a4,a4,2
80008fb0:	56b5                	li	a3,-19
80008fb2:	40e6d733          	sra	a4,a3,a4
80008fb6:	8b05                	and	a4,a4,1
80008fb8:	2c070663          	beqz	a4,80009284 <.L142>
80008fbc:	48c1a583          	lw	a1,1164(gp) # 80003d1c <.Lmerged_single+0x8>
80008fc0:	4532                	lw	a0,12(sp)
80008fc2:	1b7d                	add	s6,s6,-1
80008fc4:	4d09                	li	s10,2
80008fc6:	aeeff0ef          	jal	800082b4 <__mulsf3>
80008fca:	fffb8793          	add	a5,s7,-1
80008fce:	842a                	mv	s0,a0
80008fd0:	da3e                	sw	a5,52(sp)

80008fd2 <.L141>:
80008fd2:	0004d363          	bgez	s1,80008fd8 <.L140>
80008fd6:	4481                	li	s1,0

80008fd8 <.L140>:
80008fd8:	06097913          	and	s2,s2,96
80008fdc:	00090363          	beqz	s2,80008fe2 <.L144>
80008fe0:	1b7d                	add	s6,s6,-1

80008fe2 <.L144>:
80008fe2:	5552                	lw	a0,52(sp)
80008fe4:	ce3fd0ef          	jal	80006cc6 <abs>
80008fe8:	06300793          	li	a5,99
80008fec:	00a7d363          	bge	a5,a0,80008ff2 <.L145>
80008ff0:	1b7d                	add	s6,s6,-1

80008ff2 <.L145>:
80008ff2:	8522                	mv	a0,s0
80008ff4:	c9cff0ef          	jal	80008490 <__fixunssfdi>
80008ff8:	8bae                	mv	s7,a1
80008ffa:	8caa                	mv	s9,a0
80008ffc:	a16fd0ef          	jal	80006212 <__floatundisf>
80009000:	85aa                	mv	a1,a0
80009002:	8522                	mv	a0,s0
80009004:	f79fc0ef          	jal	80005f7c <__subsf3>
80009008:	842a                	mv	s0,a0

8000900a <.L146>:
8000900a:	895a                	mv	s2,s6
8000900c:	000b5363          	bgez	s6,80009012 <.L165>
80009010:	4901                	li	s2,0

80009012 <.L165>:
80009012:	210c7793          	and	a5,s8,528
80009016:	e399                	bnez	a5,8000901c <.L167>

80009018 <.L166>:
80009018:	2e091d63          	bnez	s2,80009312 <.L168>

8000901c <.L167>:
8000901c:	020c7713          	and	a4,s8,32
80009020:	040c7793          	and	a5,s8,64
80009024:	2e070e63          	beqz	a4,80009320 <.L169>
80009028:	02b00593          	li	a1,43
8000902c:	c399                	beqz	a5,80009032 <.L358>
8000902e:	02d00593          	li	a1,45

80009032 <.L358>:
80009032:	854e                	mv	a0,s3
80009034:	fc8ff0ef          	jal	800087fc <__SEGGER_RTL_putc>

80009038 <.L171>:
80009038:	010c7793          	and	a5,s8,16
8000903c:	e399                	bnez	a5,80009042 <.L173>

8000903e <.L172>:
8000903e:	2e091663          	bnez	s2,8000932a <.L174>

80009042 <.L173>:
80009042:	80003b37          	lui	s6,0x80003
80009046:	068b0b13          	add	s6,s6,104 # 80003068 <__SEGGER_RTL_ipow10>

8000904a <.L178>:
8000904a:	1d7d                	add	s10,s10,-1
8000904c:	003d1793          	sll	a5,s10,0x3
80009050:	97da                	add	a5,a5,s6
80009052:	4398                	lw	a4,0(a5)
80009054:	43dc                	lw	a5,4(a5)
80009056:	03000593          	li	a1,48

8000905a <.L175>:
8000905a:	00fbe663          	bltu	s7,a5,80009066 <.L258>
8000905e:	2d779d63          	bne	a5,s7,80009338 <.L176>
80009062:	2cecfb63          	bgeu	s9,a4,80009338 <.L176>

80009066 <.L258>:
80009066:	854e                	mv	a0,s3
80009068:	f94ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
8000906c:	fc0d1fe3          	bnez	s10,8000904a <.L178>
80009070:	6b85                	lui	s7,0x1
80009072:	800b8b93          	add	s7,s7,-2048 # 800 <__ILM_segment_used_end__+0x33e>
80009076:	017c7bb3          	and	s7,s8,s7
8000907a:	2e0b9363          	bnez	s7,80009360 <.L179>

8000907e <.L183>:
8000907e:	080c7793          	and	a5,s8,128
80009082:	8fc5                	or	a5,a5,s1
80009084:	c3a1                	beqz	a5,800090c4 <.L181>
80009086:	02e00593          	li	a1,46
8000908a:	854e                	mv	a0,s3
8000908c:	f70ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
80009090:	47c1                	li	a5,16
80009092:	8ca6                	mv	s9,s1
80009094:	2c97da63          	bge	a5,s1,80009368 <.L186>
80009098:	4cc1                	li	s9,16

8000909a <.L187>:
8000909a:	419484b3          	sub	s1,s1,s9
8000909e:	8566                	mv	a0,s9
800090a0:	000b8563          	beqz	s7,800090aa <.L359>
800090a4:	5552                	lw	a0,52(sp)
800090a6:	40ac8533          	sub	a0,s9,a0

800090aa <.L359>:
800090aa:	cadfd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
800090ae:	85a2                	mv	a1,s0
800090b0:	a04ff0ef          	jal	800082b4 <__mulsf3>
800090b4:	bdcff0ef          	jal	80008490 <__fixunssfdi>
800090b8:	8baa                	mv	s7,a0
800090ba:	842e                	mv	s0,a1

800090bc <.L193>:
800090bc:	2a0c9a63          	bnez	s9,80009370 <.L194>

800090c0 <.L195>:
800090c0:	2e049563          	bnez	s1,800093aa <.L196>

800090c4 <.L181>:
800090c4:	400c7793          	and	a5,s8,1024
800090c8:	2e079863          	bnez	a5,800093b8 <.L184>

800090cc <.L201>:
800090cc:	a2090ee3          	beqz	s2,80008b08 <.L4>
800090d0:	197d                	add	s2,s2,-1
800090d2:	02000593          	li	a1,32
800090d6:	ae81                	j	80009426 <.L360>

800090d8 <.L108>:
800090d8:	57d2                	lw	a5,52(sp)
800090da:	0785                	add	a5,a5,1
800090dc:	da3e                	sw	a5,52(sp)

800090de <.L105>:
800090de:	5552                	lw	a0,52(sp)
800090e0:	0505                	add	a0,a0,1 # 1001 <__NOR_CFG_OPTION_segment_size__+0x401>
800090e2:	c75fd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
800090e6:	85aa                	mv	a1,a0
800090e8:	855e                	mv	a0,s7
800090ea:	8b8fd0ef          	jal	800061a2 <__gtsf2>
800090ee:	fea045e3          	bgtz	a0,800090d8 <.L108>

800090f2 <.L109>:
800090f2:	5552                	lw	a0,52(sp)
800090f4:	c63fd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
800090f8:	85aa                	mv	a1,a0
800090fa:	855e                	mv	a0,s7
800090fc:	836fd0ef          	jal	80006132 <__ltsf2>
80009100:	da0551e3          	bgez	a0,80008ea2 <.L111>
80009104:	57d2                	lw	a5,52(sp)
80009106:	17fd                	add	a5,a5,-1
80009108:	da3e                	sw	a5,52(sp)
8000910a:	b7e5                	j	800090f2 <.L109>

8000910c <.L340>:
8000910c:	00fc1763          	bne	s8,a5,8000911a <.L112>
80009110:	da9553e3          	bge	a0,s1,80008eb6 <.L106>
80009114:	57f1                	li	a5,-4
80009116:	0cf54163          	blt	a0,a5,800091d8 <.L113>

8000911a <.L112>:
8000911a:	08097793          	and	a5,s2,128
8000911e:	c63e                	sw	a5,12(sp)
80009120:	40097793          	and	a5,s2,1024
80009124:	c789                	beqz	a5,8000912e <.L147>
80009126:	47b9                	li	a5,14
80009128:	16a7da63          	bge	a5,a0,8000929c <.L148>

8000912c <.L153>:
8000912c:	4481                	li	s1,0

8000912e <.L147>:
8000912e:	57d2                	lw	a5,52(sp)
80009130:	40900533          	neg	a0,s1
80009134:	bff97c13          	and	s8,s2,-1025
80009138:	ff178713          	add	a4,a5,-15
8000913c:	00e55463          	bge	a0,a4,80009144 <.L154>
80009140:	ff078513          	add	a0,a5,-16

80009144 <.L154>:
80009144:	c13fd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
80009148:	55fd                	li	a1,-1
8000914a:	bceff0ef          	jal	80008518 <ldexpf>
8000914e:	85aa                	mv	a1,a0
80009150:	855e                	mv	a0,s7
80009152:	e33fc0ef          	jal	80005f84 <__addsf3>
80009156:	8d2a                	mv	s10,a0
80009158:	842a                	mv	s0,a0
8000915a:	5552                	lw	a0,52(sp)
8000915c:	0505                	add	a0,a0,1
8000915e:	bf9fd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
80009162:	85ea                	mv	a1,s10
80009164:	808fd0ef          	jal	8000616c <__lesf2>
80009168:	00a04563          	bgtz	a0,80009172 <.L156>
8000916c:	57d2                	lw	a5,52(sp)
8000916e:	0785                	add	a5,a5,1
80009170:	da3e                	sw	a5,52(sp)

80009172 <.L156>:
80009172:	57d2                	lw	a5,52(sp)
80009174:	1807c963          	bltz	a5,80009306 <.L158>
80009178:	4541                	li	a0,16
8000917a:	16f55863          	bge	a0,a5,800092ea <.L159>
8000917e:	ff078713          	add	a4,a5,-16
80009182:	8d1d                	sub	a0,a0,a5
80009184:	da3a                	sw	a4,52(sp)
80009186:	bd1fd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
8000918a:	85ea                	mv	a1,s10
8000918c:	928ff0ef          	jal	800082b4 <__mulsf3>
80009190:	b00ff0ef          	jal	80008490 <__fixunssfdi>
80009194:	8caa                	mv	s9,a0
80009196:	8bae                	mv	s7,a1
80009198:	00000413          	li	s0,0

8000919c <.L160>:
8000919c:	800037b7          	lui	a5,0x80003
800091a0:	06878793          	add	a5,a5,104 # 80003068 <__SEGGER_RTL_ipow10>
800091a4:	4d05                	li	s10,1

800091a6 <.L161>:
800091a6:	47d8                	lw	a4,12(a5)
800091a8:	07a1                	add	a5,a5,8
800091aa:	00ebe763          	bltu	s7,a4,800091b8 <.L257>
800091ae:	17771063          	bne	a4,s7,8000930e <.L162>
800091b2:	4398                	lw	a4,0(a5)
800091b4:	14ecfd63          	bgeu	s9,a4,8000930e <.L162>

800091b8 <.L257>:
800091b8:	5752                	lw	a4,52(sp)
800091ba:	009d07b3          	add	a5,s10,s1
800091be:	97ba                	add	a5,a5,a4
800091c0:	40fb0b33          	sub	s6,s6,a5
800091c4:	47b2                	lw	a5,12(sp)
800091c6:	8fc5                	or	a5,a5,s1
800091c8:	c391                	beqz	a5,800091cc <.L164>
800091ca:	1b7d                	add	s6,s6,-1

800091cc <.L164>:
800091cc:	06097793          	and	a5,s2,96
800091d0:	e2078de3          	beqz	a5,8000900a <.L146>
800091d4:	1b7d                	add	s6,s6,-1
800091d6:	bd15                	j	8000900a <.L146>

800091d8 <.L113>:
800091d8:	40a00533          	neg	a0,a0
800091dc:	b7bfd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
800091e0:	85aa                	mv	a1,a0
800091e2:	855e                	mv	a0,s7
800091e4:	8d0ff0ef          	jal	800082b4 <__mulsf3>
800091e8:	b1c5                	j	80008ec8 <.L354>

800091ea <.L244>:
800091ea:	29818413          	add	s0,gp,664 # 80003b28 <.LC2>
800091ee:	b9b9                	j	80008e4c <.L122>

800091f0 <.L341>:
800091f0:	c809                	beqz	s0,80009202 <.L245>
800091f2:	2a018413          	add	s0,gp,672 # 80003b30 <.LC3>

800091f6 <.L123>:
800091f6:	02097793          	and	a5,s2,32
800091fa:	c40799e3          	bnez	a5,80008e4c <.L122>
800091fe:	0405                	add	s0,s0,1 # 80000001 <_extram_size+0x7e000001>
80009200:	b1b1                	j	80008e4c <.L122>

80009202 <.L245>:
80009202:	2a818413          	add	s0,gp,680 # 80003b38 <.LC4>
80009206:	bfc5                	j	800091f6 <.L123>

80009208 <.L124>:
80009208:	48c1a583          	lw	a1,1164(gp) # 80003d1c <.Lmerged_single+0x8>
8000920c:	855e                	mv	a0,s7
8000920e:	956ff0ef          	jal	80008364 <__divsf3>
80009212:	8baa                	mv	s7,a0
80009214:	87ea                	mv	a5,s10
80009216:	4705                	li	a4,1
80009218:	b1f1                	j	80008ee4 <.L118>

8000921a <.L127>:
8000921a:	853e                	mv	a0,a5
8000921c:	85e6                	mv	a1,s9
8000921e:	896ff0ef          	jal	800082b4 <__mulsf3>
80009222:	87aa                	mv	a5,a0
80009224:	8d5e                	mv	s10,s7
80009226:	4685                	li	a3,1
80009228:	b1f5                	j	80008f14 <.L126>

8000922a <.L132>:
8000922a:	6785                	lui	a5,0x1
8000922c:	88078793          	add	a5,a5,-1920 # 880 <__ILM_segment_used_end__+0x3be>
80009230:	00f977b3          	and	a5,s2,a5
80009234:	80078793          	add	a5,a5,-2048
80009238:	d40793e3          	bnez	a5,80008f7e <.L133>
8000923c:	47c1                	li	a5,16
8000923e:	0097d363          	bge	a5,s1,80009244 <.L134>
80009242:	44c1                	li	s1,16

80009244 <.L134>:
80009244:	8526                	mv	a0,s1
80009246:	b11fd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
8000924a:	85a2                	mv	a1,s0
8000924c:	868ff0ef          	jal	800082b4 <__mulsf3>
80009250:	a40ff0ef          	jal	80008490 <__fixunssfdi>
80009254:	00a5e7b3          	or	a5,a1,a0
80009258:	8c2a                	mv	s8,a0
8000925a:	8d2e                	mv	s10,a1
8000925c:	d20780e3          	beqz	a5,80008f7c <.L135>

80009260 <.L357>:
80009260:	4629                	li	a2,10
80009262:	4681                	li	a3,0
80009264:	e2efd0ef          	jal	80006892 <__umoddi3>
80009268:	8d4d                	or	a0,a0,a1
8000926a:	d0051ae3          	bnez	a0,80008f7e <.L133>
8000926e:	8562                	mv	a0,s8
80009270:	85ea                	mv	a1,s10
80009272:	4629                	li	a2,10
80009274:	4681                	li	a3,0
80009276:	a04fd0ef          	jal	8000647a <__udivdi3>
8000927a:	14fd                	add	s1,s1,-1
8000927c:	8c2a                	mv	s8,a0
8000927e:	8d2e                	mv	s10,a1
80009280:	f0e5                	bnez	s1,80009260 <.L357>
80009282:	b9ed                	j	80008f7c <.L135>

80009284 <.L142>:
80009284:	4901a583          	lw	a1,1168(gp) # 80003d20 <.Lmerged_single+0xc>
80009288:	4532                	lw	a0,12(sp)
8000928a:	1b79                	add	s6,s6,-2
8000928c:	4d0d                	li	s10,3
8000928e:	826ff0ef          	jal	800082b4 <__mulsf3>
80009292:	ffeb8793          	add	a5,s7,-2
80009296:	842a                	mv	s0,a0
80009298:	da3e                	sw	a5,52(sp)
8000929a:	bb25                	j	80008fd2 <.L141>

8000929c <.L148>:
8000929c:	0505                	add	a0,a0,1
8000929e:	8c89                	sub	s1,s1,a0
800092a0:	47c1                	li	a5,16
800092a2:	0097d363          	bge	a5,s1,800092a8 <.L149>
800092a6:	44c1                	li	s1,16

800092a8 <.L149>:
800092a8:	08097793          	and	a5,s2,128
800092ac:	e80791e3          	bnez	a5,8000912e <.L147>
800092b0:	4841ac03          	lw	s8,1156(gp) # 80003d14 <.Lmerged_single>
800092b4:	48c1a403          	lw	s0,1164(gp) # 80003d1c <.Lmerged_single+0x8>

800092b8 <.L150>:
800092b8:	e6048ae3          	beqz	s1,8000912c <.L153>
800092bc:	8526                	mv	a0,s1
800092be:	a99fd0ef          	jal	80006d56 <__SEGGER_RTL_pow10f>
800092c2:	85aa                	mv	a1,a0
800092c4:	855e                	mv	a0,s7
800092c6:	feffe0ef          	jal	800082b4 <__mulsf3>
800092ca:	85e2                	mv	a1,s8
800092cc:	cb9fc0ef          	jal	80005f84 <__addsf3>
800092d0:	91efd0ef          	jal	800063ee <floorf>
800092d4:	85a2                	mv	a1,s0
800092d6:	ab2ff0ef          	jal	80008588 <fmodf>
800092da:	00000593          	li	a1,0
800092de:	986ff0ef          	jal	80008464 <__eqsf2>
800092e2:	e40516e3          	bnez	a0,8000912e <.L147>
800092e6:	14fd                	add	s1,s1,-1
800092e8:	bfc1                	j	800092b8 <.L150>

800092ea <.L159>:
800092ea:	856a                	mv	a0,s10
800092ec:	da02                	sw	zero,52(sp)
800092ee:	9a2ff0ef          	jal	80008490 <__fixunssfdi>
800092f2:	8bae                	mv	s7,a1
800092f4:	8caa                	mv	s9,a0
800092f6:	f1dfc0ef          	jal	80006212 <__floatundisf>
800092fa:	85aa                	mv	a1,a0
800092fc:	856a                	mv	a0,s10
800092fe:	c7ffc0ef          	jal	80005f7c <__subsf3>
80009302:	842a                	mv	s0,a0
80009304:	bd61                	j	8000919c <.L160>

80009306 <.L158>:
80009306:	da02                	sw	zero,52(sp)
80009308:	4c81                	li	s9,0
8000930a:	4b81                	li	s7,0
8000930c:	bd41                	j	8000919c <.L160>

8000930e <.L162>:
8000930e:	0d05                	add	s10,s10,1
80009310:	bd59                	j	800091a6 <.L161>

80009312 <.L168>:
80009312:	02000593          	li	a1,32
80009316:	854e                	mv	a0,s3
80009318:	197d                	add	s2,s2,-1
8000931a:	ce2ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
8000931e:	b9ed                	j	80009018 <.L166>

80009320 <.L169>:
80009320:	d0078ce3          	beqz	a5,80009038 <.L171>
80009324:	02000593          	li	a1,32
80009328:	b329                	j	80009032 <.L358>

8000932a <.L174>:
8000932a:	03000593          	li	a1,48
8000932e:	854e                	mv	a0,s3
80009330:	197d                	add	s2,s2,-1
80009332:	ccaff0ef          	jal	800087fc <__SEGGER_RTL_putc>
80009336:	b321                	j	8000903e <.L172>

80009338 <.L176>:
80009338:	40ec86b3          	sub	a3,s9,a4
8000933c:	00dcb633          	sltu	a2,s9,a3
80009340:	0585                	add	a1,a1,1
80009342:	40fb8bb3          	sub	s7,s7,a5
80009346:	0ff5f593          	zext.b	a1,a1
8000934a:	8cb6                	mv	s9,a3
8000934c:	40cb8bb3          	sub	s7,s7,a2
80009350:	b329                	j	8000905a <.L175>

80009352 <.L182>:
80009352:	17fd                	add	a5,a5,-1
80009354:	03000593          	li	a1,48
80009358:	854e                	mv	a0,s3
8000935a:	da3e                	sw	a5,52(sp)
8000935c:	ca0ff0ef          	jal	800087fc <__SEGGER_RTL_putc>

80009360 <.L179>:
80009360:	57d2                	lw	a5,52(sp)
80009362:	fef048e3          	bgtz	a5,80009352 <.L182>
80009366:	bb21                	j	8000907e <.L183>

80009368 <.L186>:
80009368:	d204d9e3          	bgez	s1,8000909a <.L187>
8000936c:	4c81                	li	s9,0
8000936e:	b335                	j	8000909a <.L187>

80009370 <.L194>:
80009370:	1cfd                	add	s9,s9,-1
80009372:	003c9793          	sll	a5,s9,0x3
80009376:	97da                	add	a5,a5,s6
80009378:	4398                	lw	a4,0(a5)
8000937a:	43dc                	lw	a5,4(a5)
8000937c:	03000593          	li	a1,48

80009380 <.L190>:
80009380:	00f46663          	bltu	s0,a5,8000938c <.L259>
80009384:	00879863          	bne	a5,s0,80009394 <.L191>
80009388:	00ebf663          	bgeu	s7,a4,80009394 <.L191>

8000938c <.L259>:
8000938c:	854e                	mv	a0,s3
8000938e:	c6eff0ef          	jal	800087fc <__SEGGER_RTL_putc>
80009392:	b32d                	j	800090bc <.L193>

80009394 <.L191>:
80009394:	40eb86b3          	sub	a3,s7,a4
80009398:	00dbb633          	sltu	a2,s7,a3
8000939c:	0585                	add	a1,a1,1
8000939e:	8c1d                	sub	s0,s0,a5
800093a0:	0ff5f593          	zext.b	a1,a1
800093a4:	8bb6                	mv	s7,a3
800093a6:	8c11                	sub	s0,s0,a2
800093a8:	bfe1                	j	80009380 <.L190>

800093aa <.L196>:
800093aa:	03000593          	li	a1,48
800093ae:	854e                	mv	a0,s3
800093b0:	14fd                	add	s1,s1,-1
800093b2:	c4aff0ef          	jal	800087fc <__SEGGER_RTL_putc>
800093b6:	b329                	j	800090c0 <.L195>

800093b8 <.L184>:
800093b8:	012c1793          	sll	a5,s8,0x12
800093bc:	06500593          	li	a1,101
800093c0:	0007d463          	bgez	a5,800093c8 <.L197>
800093c4:	04500593          	li	a1,69

800093c8 <.L197>:
800093c8:	854e                	mv	a0,s3
800093ca:	c32ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
800093ce:	57d2                	lw	a5,52(sp)
800093d0:	0407df63          	bgez	a5,8000942e <.L198>
800093d4:	02d00593          	li	a1,45
800093d8:	854e                	mv	a0,s3
800093da:	c22ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
800093de:	57d2                	lw	a5,52(sp)
800093e0:	40f007b3          	neg	a5,a5
800093e4:	da3e                	sw	a5,52(sp)

800093e6 <.L199>:
800093e6:	55d2                	lw	a1,52(sp)
800093e8:	06300793          	li	a5,99
800093ec:	00b7df63          	bge	a5,a1,8000940a <.L200>
800093f0:	06400413          	li	s0,100
800093f4:	0285c5b3          	div	a1,a1,s0
800093f8:	854e                	mv	a0,s3
800093fa:	03058593          	add	a1,a1,48
800093fe:	bfeff0ef          	jal	800087fc <__SEGGER_RTL_putc>
80009402:	57d2                	lw	a5,52(sp)
80009404:	0287e7b3          	rem	a5,a5,s0
80009408:	da3e                	sw	a5,52(sp)

8000940a <.L200>:
8000940a:	55d2                	lw	a1,52(sp)
8000940c:	4429                	li	s0,10
8000940e:	854e                	mv	a0,s3
80009410:	0285c5b3          	div	a1,a1,s0
80009414:	03058593          	add	a1,a1,48
80009418:	be4ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
8000941c:	55d2                	lw	a1,52(sp)
8000941e:	0285e5b3          	rem	a1,a1,s0
80009422:	03058593          	add	a1,a1,48

80009426 <.L360>:
80009426:	854e                	mv	a0,s3
80009428:	bd4ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
8000942c:	b145                	j	800090cc <.L201>

8000942e <.L198>:
8000942e:	02b00593          	li	a1,43
80009432:	854e                	mv	a0,s3
80009434:	bc8ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
80009438:	b77d                	j	800093e6 <.L199>

8000943a <.L205>:
8000943a:	6d21                	lui	s10,0x8
8000943c:	892e                	mv	s2,a1
8000943e:	4c01                	li	s8,0
80009440:	01abfd33          	and	s10,s7,s10
80009444:	470d                	li	a4,3
80009446:	02c00813          	li	a6,44

8000944a <.L208>:
8000944a:	012467b3          	or	a5,s0,s2
8000944e:	c7b5                	beqz	a5,800094ba <.L206>
80009450:	000d0d63          	beqz	s10,8000946a <.L214>
80009454:	003c7793          	and	a5,s8,3
80009458:	00e79963          	bne	a5,a4,8000946a <.L214>
8000945c:	030c0793          	add	a5,s8,48
80009460:	1018                	add	a4,sp,32
80009462:	97ba                	add	a5,a5,a4
80009464:	ff078423          	sb	a6,-24(a5)
80009468:	0c05                	add	s8,s8,1

8000946a <.L214>:
8000946a:	1018                	add	a4,sp,32
8000946c:	030c0793          	add	a5,s8,48
80009470:	97ba                	add	a5,a5,a4
80009472:	4629                	li	a2,10
80009474:	4681                	li	a3,0
80009476:	8522                	mv	a0,s0
80009478:	85ca                	mv	a1,s2
8000947a:	c63e                	sw	a5,12(sp)
8000947c:	c16fd0ef          	jal	80006892 <__umoddi3>
80009480:	47b2                	lw	a5,12(sp)
80009482:	03050513          	add	a0,a0,48
80009486:	85ca                	mv	a1,s2
80009488:	fea78423          	sb	a0,-24(a5)
8000948c:	4629                	li	a2,10
8000948e:	8522                	mv	a0,s0
80009490:	4681                	li	a3,0
80009492:	fe9fc0ef          	jal	8000647a <__udivdi3>
80009496:	0c05                	add	s8,s8,1
80009498:	842a                	mv	s0,a0
8000949a:	892e                	mv	s2,a1
8000949c:	02c00813          	li	a6,44
800094a0:	470d                	li	a4,3
800094a2:	b765                	j	8000944a <.L208>

800094a4 <.L204>:
800094a4:	6709                	lui	a4,0x2
800094a6:	4c01                	li	s8,0
800094a8:	00ebf733          	and	a4,s7,a4
800094ac:	26818693          	add	a3,gp,616 # 80003af8 <__SEGGER_RTL_hex_lc>
800094b0:	27818613          	add	a2,gp,632 # 80003b08 <__SEGGER_RTL_hex_uc>

800094b4 <.L209>:
800094b4:	00b467b3          	or	a5,s0,a1
800094b8:	e38d                	bnez	a5,800094da <.L212>

800094ba <.L206>:
800094ba:	418484b3          	sub	s1,s1,s8
800094be:	0004d363          	bgez	s1,800094c4 <.L216>
800094c2:	4481                	li	s1,0

800094c4 <.L216>:
800094c4:	409b0b33          	sub	s6,s6,s1
800094c8:	0ff00793          	li	a5,255
800094cc:	418b0b33          	sub	s6,s6,s8
800094d0:	0397f863          	bgeu	a5,s9,80009500 <.L217>
800094d4:	1b7d                	add	s6,s6,-1

800094d6 <.L218>:
800094d6:	1b7d                	add	s6,s6,-1
800094d8:	a035                	j	80009504 <.L219>

800094da <.L212>:
800094da:	00f47793          	and	a5,s0,15
800094de:	cf19                	beqz	a4,800094fc <.L210>
800094e0:	97b2                	add	a5,a5,a2

800094e2 <.L361>:
800094e2:	0007c783          	lbu	a5,0(a5)
800094e6:	1828                	add	a0,sp,56
800094e8:	9562                	add	a0,a0,s8
800094ea:	00f50023          	sb	a5,0(a0)
800094ee:	8011                	srl	s0,s0,0x4
800094f0:	01c59793          	sll	a5,a1,0x1c
800094f4:	0c05                	add	s8,s8,1
800094f6:	8c5d                	or	s0,s0,a5
800094f8:	8191                	srl	a1,a1,0x4
800094fa:	bf6d                	j	800094b4 <.L209>

800094fc <.L210>:
800094fc:	97b6                	add	a5,a5,a3
800094fe:	b7d5                	j	800094e2 <.L361>

80009500 <.L217>:
80009500:	fc0c9be3          	bnez	s9,800094d6 <.L218>

80009504 <.L219>:
80009504:	200bf793          	and	a5,s7,512
80009508:	e799                	bnez	a5,80009516 <.L220>
8000950a:	865a                	mv	a2,s6
8000950c:	85de                	mv	a1,s7
8000950e:	854e                	mv	a0,s3
80009510:	8bbfd0ef          	jal	80006dca <__SEGGER_RTL_pre_padding>
80009514:	4b01                	li	s6,0

80009516 <.L220>:
80009516:	0ff00793          	li	a5,255
8000951a:	0197fc63          	bgeu	a5,s9,80009532 <.L221>
8000951e:	03000593          	li	a1,48
80009522:	854e                	mv	a0,s3
80009524:	ad8ff0ef          	jal	800087fc <__SEGGER_RTL_putc>

80009528 <.L222>:
80009528:	85e6                	mv	a1,s9
8000952a:	854e                	mv	a0,s3
8000952c:	ad0ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
80009530:	a019                	j	80009536 <.L223>

80009532 <.L221>:
80009532:	fe0c9be3          	bnez	s9,80009528 <.L222>

80009536 <.L223>:
80009536:	865a                	mv	a2,s6
80009538:	85de                	mv	a1,s7
8000953a:	854e                	mv	a0,s3
8000953c:	88ffd0ef          	jal	80006dca <__SEGGER_RTL_pre_padding>
80009540:	8626                	mv	a2,s1
80009542:	03000593          	li	a1,48
80009546:	854e                	mv	a0,s3
80009548:	b50ff0ef          	jal	80008898 <__SEGGER_RTL_print_padding>

8000954c <.L224>:
8000954c:	1c7d                	add	s8,s8,-1
8000954e:	e40c4c63          	bltz	s8,80008ba6 <.L371>
80009552:	183c                	add	a5,sp,56
80009554:	97e2                	add	a5,a5,s8
80009556:	0007c583          	lbu	a1,0(a5)
8000955a:	854e                	mv	a0,s3
8000955c:	aa0ff0ef          	jal	800087fc <__SEGGER_RTL_putc>
80009560:	b7f5                	j	8000954c <.L224>

80009562 <.L34>:
80009562:	07800713          	li	a4,120
80009566:	daf76163          	bltu	a4,a5,80008b08 <.L4>

8000956a <.L38>:
8000956a:	fa878713          	add	a4,a5,-88
8000956e:	0ff77713          	zext.b	a4,a4
80009572:	02000693          	li	a3,32
80009576:	d8e6e963          	bltu	a3,a4,80008b08 <.L4>
8000957a:	46d2                	lw	a3,20(sp)
8000957c:	070a                	sll	a4,a4,0x2
8000957e:	9736                	add	a4,a4,a3
80009580:	4318                	lw	a4,0(a4)
80009582:	8702                	jr	a4

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

80009584 <__SEGGER_RTL_ascii_isctype>:
80009584:	07f00793          	li	a5,127
80009588:	00a7ee63          	bltu	a5,a0,800095a4 <.L3>
8000958c:	40418793          	add	a5,gp,1028 # 80003c94 <__SEGGER_RTL_ascii_ctype_map>
80009590:	953e                	add	a0,a0,a5
80009592:	03420793          	add	a5,tp,52 # 34 <__NOR_CFG_OPTION_segment_used_size__+0x24>
80009596:	95be                	add	a1,a1,a5
80009598:	00054503          	lbu	a0,0(a0)
8000959c:	0005c783          	lbu	a5,0(a1)
800095a0:	8d7d                	and	a0,a0,a5
800095a2:	8082                	ret

800095a4 <.L3>:
800095a4:	4501                	li	a0,0
800095a6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

800095a8 <__SEGGER_RTL_ascii_tolower>:
800095a8:	fbf50713          	add	a4,a0,-65
800095ac:	47e5                	li	a5,25
800095ae:	00e7e463          	bltu	a5,a4,800095b6 <.L7>
800095b2:	02050513          	add	a0,a0,32

800095b6 <.L7>:
800095b6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

800095b8 <__SEGGER_RTL_ascii_iswctype>:
800095b8:	07f00793          	li	a5,127
800095bc:	00a7ee63          	bltu	a5,a0,800095d8 <.L10>
800095c0:	40418793          	add	a5,gp,1028 # 80003c94 <__SEGGER_RTL_ascii_ctype_map>
800095c4:	953e                	add	a0,a0,a5
800095c6:	03420793          	add	a5,tp,52 # 34 <__NOR_CFG_OPTION_segment_used_size__+0x24>
800095ca:	95be                	add	a1,a1,a5
800095cc:	00054503          	lbu	a0,0(a0)
800095d0:	0005c783          	lbu	a5,0(a1)
800095d4:	8d7d                	and	a0,a0,a5
800095d6:	8082                	ret

800095d8 <.L10>:
800095d8:	4501                	li	a0,0
800095da:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

800095dc <__SEGGER_RTL_ascii_towlower>:
800095dc:	fbf50713          	add	a4,a0,-65
800095e0:	47e5                	li	a5,25
800095e2:	00e7e463          	bltu	a5,a4,800095ea <.L14>
800095e6:	02050513          	add	a0,a0,32

800095ea <.L14>:
800095ea:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

800095ec <__SEGGER_RTL_ascii_wctomb>:
800095ec:	07f00793          	li	a5,127
800095f0:	00b7e663          	bltu	a5,a1,800095fc <.L66>
800095f4:	00b50023          	sb	a1,0(a0)
800095f8:	4505                	li	a0,1
800095fa:	8082                	ret

800095fc <.L66>:
800095fc:	5579                	li	a0,-2
800095fe:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

80009600 <__SEGGER_RTL_current_locale>:
80009600:	012007b7          	lui	a5,0x1200
80009604:	03c7a503          	lw	a0,60(a5) # 120003c <__SEGGER_RTL_locale_ptr>
80009608:	e509                	bnez	a0,80009612 <.L155>
8000960a:	01200537          	lui	a0,0x1200
8000960e:	00050513          	mv	a0,a0

80009612 <.L155>:
80009612:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

80009b50 <__SEGGER_init_zero>:
80009b50:	4008                	lw	a0,0(s0)
80009b52:	404c                	lw	a1,4(s0)
80009b54:	0421                	add	s0,s0,8
80009b56:	c591                	beqz	a1,80009b62 <.L__SEGGER_init_zero_Done>

80009b58 <.L__SEGGER_init_zero_Loop>:
80009b58:	00050023          	sb	zero,0(a0) # 1200000 <__RAL_global_locale>
80009b5c:	0505                	add	a0,a0,1
80009b5e:	15fd                	add	a1,a1,-1
80009b60:	fde5                	bnez	a1,80009b58 <.L__SEGGER_init_zero_Loop>

80009b62 <.L__SEGGER_init_zero_Done>:
80009b62:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

80009b64 <__SEGGER_init_copy>:
80009b64:	4008                	lw	a0,0(s0)
80009b66:	404c                	lw	a1,4(s0)
80009b68:	4410                	lw	a2,8(s0)
80009b6a:	0431                	add	s0,s0,12
80009b6c:	ca09                	beqz	a2,80009b7e <.L__SEGGER_init_copy_Done>

80009b6e <.L__SEGGER_init_copy_Loop>:
80009b6e:	00058683          	lb	a3,0(a1)
80009b72:	00d50023          	sb	a3,0(a0)
80009b76:	0505                	add	a0,a0,1
80009b78:	0585                	add	a1,a1,1
80009b7a:	167d                	add	a2,a2,-1
80009b7c:	fa6d                	bnez	a2,80009b6e <.L__SEGGER_init_copy_Loop>

80009b7e <.L__SEGGER_init_copy_Done>:
80009b7e:	8082                	ret
