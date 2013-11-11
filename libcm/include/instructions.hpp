#pragma once

#include "instruction_t.hpp"
#include <iostream>

struct adc_immediate_t1_t : instruction_t
{
   adc_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "adc_immediate_t1_t";
   }
};

struct adc_register_t1_t : instruction_t
{
   adc_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "adc_register_t1_t";
   }
};

struct adc_register_t2_t : instruction_t
{
   adc_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "adc_register_t2_t";
   }
};

struct add_immediate_t1_t : instruction_t
{
   add_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_immediate_t1_t";
   }
};

struct add_immediate_t2_t : instruction_t
{
   add_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_immediate_t2_t";
   }
};

struct add_immediate_t3_t : instruction_t
{
   add_immediate_t3_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_immediate_t3_t";
   }
};

struct add_immediate_t4_t : instruction_t
{
   add_immediate_t4_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_immediate_t4_t";
   }
};

struct lsl_immediate_t1_t : instruction_t
{
   lsl_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "lsl_immediate_t1_t";
   }
};

struct lsr_immediate_t1_t : instruction_t
{
   lsr_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "lsr_immediate_t1_t";
   }
};

struct add_register_t1_t : instruction_t
{
   add_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_register_t1_t";
   }
};

struct add_register_t2_t : instruction_t
{
   add_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_register_t2_t";
   }
};

struct add_register_t3_t : instruction_t
{
   add_register_t3_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_register_t3_t";
   }
};

struct add_sp_plus_immediate_t1_t : instruction_t
{
   add_sp_plus_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_sp_plus_immediate_t1_t";
   }
};

struct add_sp_plus_immediate_t2_t : instruction_t
{
   add_sp_plus_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "add_sp_plus_immediate_t2_t";
   }
};

struct adr_t1_t : instruction_t
{
   adr_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "adr_t1_t";
   }
};

struct adr_t2_t : instruction_t
{
   adr_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "adr_t2_t";
   }
};

struct adr_t3_t : instruction_t
{
   adr_t3_t(u32_t)
   {
   }
   str_t name() const
   {
      return "adr_t3_t";
   }
};

struct and_immediate_t1_t : instruction_t
{
   and_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "and_immediate_t1_t";
   }
};

struct and_register_t1_t : instruction_t
{
   and_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "and_register_t1_t";
   }
};

struct and_register_t2_t : instruction_t
{
   and_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "and_register_t2_t";
   }
};

struct asr_immediate_t1_t : instruction_t
{
   asr_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "asr_immediate_t1_t";
   }
};

struct asr_immediate_t2_t : instruction_t
{
   asr_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "asr_immediate_t2_t";
   }
};

struct asr_register_t1_t : instruction_t
{
   asr_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "asr_register_t1_t";
   }
};

struct asr_register_t2_t : instruction_t
{
   asr_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "asr_register_t2_t";
   }
};

struct b_t1_t : instruction_t
{
   b_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "b_t1_t";
   }
};

struct b_t2_t : instruction_t
{
   b_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "b_t2_t";
   }
};

struct b_t3_t : instruction_t
{
   b_t3_t(u32_t)
   {
   }
   str_t name() const
   {
      return "b_t3_t";
   }
};

struct b_t4_t : instruction_t
{
   b_t4_t(u32_t)
   {
   }
   str_t name() const
   {
      return "b_t4_t";
   }
};

struct bfi_t1_t : instruction_t
{
   bfi_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "bfi_t1_t";
   }
};

struct bic_immediate_t1_t : instruction_t
{
   bic_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "bic_immediate_t1_t";
   }
};

struct bic_register_t1_t : instruction_t
{
   bic_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "bic_register_t1_t";
   }
};

struct bic_register_t2_t : instruction_t
{
   bic_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "bic_register_t2_t";
   }
};

struct bkpt_t1_t : instruction_t
{
   bkpt_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "bkpt_t1_t";
   }
};

struct bl_t1_t : instruction_t
{
   bl_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "bl_t1_t";
   }
};

struct blx_t1_t : instruction_t
{
   blx_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "blx_t1_t";
   }
};

struct bx_t1_t : instruction_t
{
   bx_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "bx_t1_t";
   }
};

struct cbz_t1_t : instruction_t
{
   cbz_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cbz_t1_t";
   }
};

struct cdp_t1_t : instruction_t
{
   cdp_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cdp_t1_t";
   }
};

struct cdp_t2_t : instruction_t
{
   cdp_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cdp_t2_t";
   }
};

struct clrex_t1_t : instruction_t
{
   clrex_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "clrex_t1_t";
   }
};

struct clz_t1_t : instruction_t
{
   clz_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "clz_t1_t";
   }
};

struct cmn_register_t1_t : instruction_t
{
   cmn_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cmn_register_t1_t";
   }
};

struct sub_register_t1_t : instruction_t
{
   sub_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "sub_register_t1_t";
   }
};

struct sub_immediate_t1_t : instruction_t
{
   sub_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "sub_immediate_t1_t";
   }
};

struct sub_immediate_t2_t : instruction_t
{
   sub_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "sub_immediate_t2_t";
   }
};

struct mov_immediate_t1_t : instruction_t
{
   mov_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "mov_immediate_t1_t";
   }
};

struct lsl_register_t1_t : instruction_t
{
   lsl_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "lsl_register_t1_t";
   }
};

struct lsr_register_t1_t : instruction_t
{
   lsr_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "lsr_register_t1_t";
   }
};

struct sbc_register_t1_t : instruction_t
{
   sbc_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "sbc_register_t1_t";
   }
};

struct ror_register_t1_t : instruction_t
{
   ror_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ror_register_t1_t";
   }
};

struct tst_register_t1_t : instruction_t
{
   tst_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "tst_register_t1_t";
   }
};

struct rsb_immediate_t1_t : instruction_t
{
   rsb_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "rsb_immediate_t1_t";
   }
};

struct cmp_immediate_t1_t : instruction_t
{
   cmp_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cmp_immediate_t1_t";
   }
};

struct cmp_immediate_t2_t : instruction_t
{
   cmp_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cmp_immediate_t2_t";
   }
};

struct cmp_register_t1_t : instruction_t
{
   cmp_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cmp_register_t1_t";
   }
};

struct cmp_register_t2_t : instruction_t
{
   cmp_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cmp_register_t2_t";
   }
};

struct cmp_register_t3_t : instruction_t
{
   cmp_register_t3_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cmp_register_t3_t";
   }
};

struct cps_t1_t : instruction_t
{
   cps_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "cps_t1_t";
   }
};

struct dbg_t1_t : instruction_t
{
   dbg_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "dbg_t1_t";
   }
};

struct dmb_t1_t : instruction_t
{
   dmb_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "dmb_t1_t";
   }
};

struct dsb_t1_t : instruction_t
{
   dsb_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "dsb_t1_t";
   }
};

struct eor_immediate_t1_t : instruction_t
{
   eor_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "eor_immediate_t1_t";
   }
};

struct eor_register_t1_t : instruction_t
{
   eor_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "eor_register_t1_t";
   }
};

struct eor_register_t2_t : instruction_t
{
   eor_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "eor_register_t2_t";
   }
};

struct isb_t1_t : instruction_t
{
   isb_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "isb_t1_t";
   }
};

struct it_t1_t : instruction_t
{
   it_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "it_t1_t";
   }
};

struct ldc_immediate_t1_t : instruction_t
{
   ldc_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldc_immediate_t1_t";
   }
};

struct ldc_immediate_t2_t : instruction_t
{
   ldc_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldc_immediate_t2_t";
   }
};

struct ldc_literal_t1_t : instruction_t
{
   ldc_literal_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldc_literal_t1_t";
   }
};

struct ldc_literal_t2_t : instruction_t
{
   ldc_literal_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldc_literal_t2_t";
   }
};

struct ldm_t1_t : instruction_t
{
   ldm_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldm_t1_t";
   }
};

struct ldm_t2_t : instruction_t
{
   ldm_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldm_t2_t";
   }
};

struct ldmdb_t1_t : instruction_t
{
   ldmdb_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldmdb_t1_t";
   }
};

struct ldr_immediate_t1_t : instruction_t
{
   ldr_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldr_immediate_t1_t";
   }
};

struct ldr_immediate_t2_t : instruction_t
{
   ldr_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldr_immediate_t2_t";
   }
};

struct ldr_immediate_t3_t : instruction_t
{
   ldr_immediate_t3_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldr_immediate_t3_t";
   }
};

struct ldr_immediate_t4_t : instruction_t
{
   ldr_immediate_t4_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldr_immediate_t4_t";
   }
};

struct ldr_literal_t1_t : instruction_t
{
   ldr_literal_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldr_literal_t1_t";
   }
};

struct ldr_register_t1_t : instruction_t
{
   ldr_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldr_register_t1_t";
   }
};

struct ldr_register_t2_t : instruction_t
{
   ldr_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldr_register_t2_t";
   }
};

struct ldrb_immediate_t1_t : instruction_t
{
   ldrb_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrb_immediate_t1_t";
   }
};

struct ldrb_immediate_t2_t : instruction_t
{
   ldrb_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrb_immediate_t2_t";
   }
};

struct ldrb_immediate_t3_t : instruction_t
{
   ldrb_immediate_t3_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrb_immediate_t3_t";
   }
};

struct ldrb_register_t1_t : instruction_t
{
   ldrb_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrb_register_t1_t";
   }
};

struct ldrb_register_t2_t : instruction_t
{
   ldrb_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrb_register_t2_t";
   }
};

struct ldrbt_t1_t : instruction_t
{
   ldrbt_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrbt_t1_t";
   }
};

struct ldrd_immediate_t1_t : instruction_t
{
   ldrd_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrd_immediate_t1_t";
   }
};

struct ldrd_literal_t1_t : instruction_t
{
   ldrd_literal_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrd_literal_t1_t";
   }
};

struct ldrex_t1_t : instruction_t
{
   ldrex_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrex_t1_t";
   }
};

struct ldrexb_t1_t : instruction_t
{
   ldrexb_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrexb_t1_t";
   }
};

struct ldrexh_t1_t : instruction_t
{
   ldrexh_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrexh_t1_t";
   }
};

struct ldrh_immediate_t1_t : instruction_t
{
   ldrh_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrh_immediate_t1_t";
   }
};

struct ldrh_immediate_t2_t : instruction_t
{
   ldrh_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrh_immediate_t2_t";
   }
};

struct ldrh_immediate_t3_t : instruction_t
{
   ldrh_immediate_t3_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrh_immediate_t3_t";
   }
};

struct ldrh_literal_t1_t : instruction_t
{
   ldrh_literal_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrh_literal_t1_t";
   }
};

struct ldrh_register_t1_t : instruction_t
{
   ldrh_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrh_register_t1_t";
   }
};

struct ldrh_register_t2_t : instruction_t
{
   ldrh_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrh_register_t2_t";
   }
};

struct ldrht_t1_t : instruction_t
{
   ldrht_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrht_t1_t";
   }
};

struct ldrsb_immediate_t1_t : instruction_t
{
   ldrsb_immediate_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrsb_immediate_t1_t";
   }
};

struct ldrsb_immediate_t2_t : instruction_t
{
   ldrsb_immediate_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrsb_immediate_t2_t";
   }
};

struct ldrsb_literal_t1_t : instruction_t
{
   ldrsb_literal_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrsb_literal_t1_t";
   }
};

struct ldrsb_register_t1_t : instruction_t
{
   ldrsb_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrsb_register_t1_t";
   }
};

struct ldrsb_register_t2_t : instruction_t
{
   ldrsb_register_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "ldrsb_register_t2_t";
   }
};

struct orr_register_t1_t : instruction_t
{
   orr_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "orr_register_t1_t";
   }
};

struct mul_registers_t1_t : instruction_t
{
   mul_registers_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "mul_registers_t1_t";
   }
};

struct mvn_register_t1_t : instruction_t
{
   mvn_register_t1_t(u32_t)
   {
   }
   str_t name() const
   {
      return "mvn_register_t1_t";
   }
};

struct stm_t2_t : instruction_t
{
   stm_t2_t(u32_t)
   {
   }
   str_t name() const
   {
      return "stm_t2_t";
   }
};
