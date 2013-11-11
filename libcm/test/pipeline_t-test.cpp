#include "pipeline_t.hpp"
#include "instructions.hpp"
#include "matchers.hpp"
//#include "stream_saver_t.hpp"
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include "test.hpp"

struct fix_t
{
   fix_t()
      :p(1, matchers)
   {}

   pipeline_t p;
   const sp_t<instruction_t> np;
   sp_t<instruction_t> i;
};

FTST(adc_immediate_t1, fix_t)
{
   i = p.insert(0xf140);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("adc_immediate_t1_t", i->name());
}

FTST(adc_register_t1, fix_t)
{
   i = p.insert(0x4140);
   EQ("adc_register_t1_t", i->name());
}

FTST(adc_register_t2, fix_t)
{
   i = p.insert(0xeb40);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("adc_register_t2_t", i->name());
}

FTST(add_immediate_t1, fix_t)
{
   i = p.insert(0x1c00);
   EQ("add_immediate_t1_t", i->name());
}

FTST(add_immediate_t2, fix_t)
{
   i = p.insert(0x3000);
   EQ("add_immediate_t2_t", i->name());
}

FTST(add_immediate_t3, fix_t)
{
   i = p.insert(0xf100);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("add_immediate_t3_t", i->name());
}

FTST(add_immediate_t4, fix_t)
{
   i = p.insert(0xf200);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("add_immediate_t4_t", i->name());
}

FTST(add_register_t1, fix_t)
{
   i = p.insert(0x1800);
   EQ("add_register_t1_t", i->name());
}

FTST(add_register_t2, fix_t)
{
   i = p.insert(0x4400);
   EQ("add_register_t2_t", i->name());
}

FTST(add_register_t3, fix_t)
{
   i = p.insert(0xeb00);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("add_register_t3_t", i->name());
}

FTST(add_sp_plus_immediate_t1, fix_t)
{
   i = p.insert(0xa800);
   EQ("add_sp_plus_immediate_t1_t", i->name());
}

FTST(add_sp_plus_immediate_t2, fix_t)
{
   i = p.insert(0xb000);
   EQ("add_sp_plus_immediate_t2_t", i->name());
}

FTST(add_sp_plus_immediate_t3, fix_t)
{
   i = p.insert(0xf10d);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("add_immediate_t3_t", i->name());
}

FTST(add_sp_plus_immediate_t4, fix_t)
{
   i = p.insert(0xf20d);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("add_immediate_t4_t", i->name());
}

FTST(add_sp_plus_register_t1, fix_t)
{
   i = p.insert(0x4468);
   EQ("add_register_t2_t", i->name());
}

FTST(add_sp_plus_register_t2, fix_t)
{
   i = p.insert(0x4485);
   EQ("add_register_t2_t", i->name());
}

FTST(add_sp_plus_register_t3, fix_t)
{
   i = p.insert(0xeb0d);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("add_register_t3_t", i->name());
}

FTST(adr_t1, fix_t)
{
   i = p.insert(0xa000);
   EQ("adr_t1_t", i->name());
}

FTST(adr_t2, fix_t)
{
   i = p.insert(0xf2af);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("adr_t2_t", i->name());
}

FTST(adr_t3, fix_t)
{
   i = p.insert(0xf20f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("adr_t3_t", i->name());
}

FTST(and_immediate_t1, fix_t)
{
   i = p.insert(0xf000);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("and_immediate_t1_t", i->name());
}

FTST(and_register_t1, fix_t)
{
   i = p.insert(0x4000);
   EQ("and_register_t1_t", i->name());
}

FTST(and_register_t2, fix_t)
{
   i = p.insert(0xea00);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("and_register_t2_t", i->name());
}

FTST(asr_imediate_t1, fix_t)
{
   i = p.insert(0x1000);
   EQ("asr_immediate_t1_t", i->name());
}

FTST(asr_immedate_t2, fix_t)
{
   i = p.insert(0xea4f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("asr_immediate_t2_t", i->name());
}

FTST(asr_register_t1, fix_t)
{
   i = p.insert(0x4100);
   EQ("asr_register_t1_t", i->name());
}

FTST(asr_register_t2, fix_t)
{
   i = p.insert(0xfa40);
   EQ(np, i);
   i = p.insert(0xf000);
   EQ("asr_register_t2_t", i->name());
}

FTST(b_t1, fix_t)
{
   i = p.insert(0xd000);
   EQ("b_t1_t", i->name());
}

FTST(b_t2, fix_t)
{
   i = p.insert(0xe000);
   EQ("b_t2_t", i->name());
}

FTST(b_t3, fix_t)
{
   i = p.insert(0xf000);
   EQ(np, i);
   i = p.insert(0x8000);
   EQ("b_t3_t", i->name());
}

FTST(b_t4, fix_t)
{
   i = p.insert(0xf000);
   EQ(np, i);
   i = p.insert(0x9000);
   EQ("b_t4_t", i->name());
}

FTST(bfc_t1, fix_t)
{
   i = p.insert(0xf36f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("bfi_t1_t", i->name());
}

FTST(bfi_t1, fix_t)
{
   i = p.insert(0xf360);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("bfi_t1_t", i->name());
}

FTST(bic_immediate_t1, fix_t)
{
   i = p.insert(0xf020);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("bic_immediate_t1_t", i->name());
}

FTST(bic_register_t1, fix_t)
{
   i = p.insert(0x4380);
   EQ("bic_register_t1_t", i->name());
}

FTST(bic_register_t2, fix_t)
{
   i = p.insert(0xea20);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("bic_register_t2_t", i->name());
}

FTST(bkpt_t1, fix_t)
{
   i = p.insert(0xbe00);
   EQ("bkpt_t1_t", i->name());
}

FTST(bl_t1, fix_t)
{
   i = p.insert(0xf000);
   EQ(np, i);
   i = p.insert(0xd000);
   EQ("bl_t1_t", i->name());
}

FTST(blx_t1, fix_t)
{
   i = p.insert(0x4780);
   EQ("blx_t1_t", i->name());
}

FTST(bx_t1, fix_t)
{
   i = p.insert(0x4700);
   EQ("bx_t1_t", i->name());
}

FTST(cbz_t1, fix_t)
{
   i = p.insert(0xb100);
   EQ("cbz_t1_t", i->name());
}

FTST(cdp_t1, fix_t)
{
   i = p.insert(0xee00);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("cdp_t1_t", i->name());
}

FTST(cdp_t2, fix_t)
{
   i = p.insert(0xfe00);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("cdp_t2_t", i->name());
}

FTST(clrex_t1, fix_t)
{
   i = p.insert(0xf3bf);
   EQ(np, i);
   i = p.insert(0x8f2f);
   EQ("clrex_t1_t", i->name());
}

FTST(clz_t1, fix_t)
{
   i = p.insert(0xfab0);
   EQ(np, i);
   i = p.insert(0xf080);
   EQ("clz_t1_t", i->name());
}

FTST(cmn_immediate_t1, fix_t)
{
   i = p.insert(0xf110);
   EQ(np, i);
   i = p.insert(0x0f00);
   EQ("add_immediate_t3_t", i->name());
}

FTST(cmn_register_t1, fix_t)
{
   i = p.insert(0x42c0);
   EQ("cmn_register_t1_t", i->name());
}

FTST(cmn_register_t2, fix_t)
{
   i = p.insert(0xeb10);
   EQ(np, i);
   i = p.insert(0x0f00);
   EQ("add_register_t3_t", i->name());
}

FTST(cmp_immediate_t1, fix_t)
{
   i = p.insert(0x2800);
   EQ("cmp_immediate_t1_t", i->name());
}

FTST(cmp_immediate_t2, fix_t)
{
   i = p.insert(0xf1b0);
   EQ(np, i);
   i = p.insert(0x0f00);
   EQ("cmp_immediate_t2_t", i->name());
}

FTST(cmp_register_t1, fix_t)
{
   i = p.insert(0x4280);
   EQ("cmp_register_t1_t", i->name());
}

FTST(cmp_register_t2, fix_t)
{
   i = p.insert(0x4500);
   EQ("cmp_register_t2_t", i->name());
}

FTST(cmp_register_t3, fix_t)
{
   i = p.insert(0xebb0);
   EQ(np, i);
   i = p.insert(0x0f00);
   EQ("cmp_register_t3_t", i->name());
}

FTST(cps_t1, fix_t)
{
   i = p.insert(0xb660);
   EQ("cps_t1_t", i->name());
}

FTST(dbg_t1, fix_t)
{
   i = p.insert(0xf3af);
   EQ(np, i);
   i = p.insert(0x80f0);
   EQ("dbg_t1_t", i->name());
}

FTST(dmb_t1, fix_t)
{
   i = p.insert(0xf3bf);
   EQ(np, i);
   i = p.insert(0x8f50);
   EQ("dmb_t1_t", i->name());
}

FTST(dsb_t1, fix_t)
{
   i = p.insert(0xf3bf);
   EQ(np, i);
   i = p.insert(0x8f40);
   EQ("dsb_t1_t", i->name());
}

FTST(eor_immediate_t1, fix_t)
{
   i = p.insert(0xf080);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("eor_immediate_t1_t", i->name());
}

FTST(eor_register_t1, fix_t)
{
   i = p.insert(0x4040);
   EQ("eor_register_t1_t", i->name());
}

FTST(eor_register_t2, fix_t)
{
   i = p.insert(0xea80);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("eor_register_t2_t", i->name());
}

FTST(isb_t1, fix_t)
{
   i = p.insert(0xf3bf);
   EQ(np, i);
   i = p.insert(0x8f60);
   EQ("isb_t1_t", i->name());
}

FTST(it_t1, fix_t)
{
   i = p.insert(0xbf00);
   EQ("it_t1_t", i->name());
}

FTST(ldc_immediate_t1, fix_t)
{
   i = p.insert(0xec10);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldc_immediate_t1_t", i->name());
}

FTST(ldc_immediate_t2, fix_t)
{
   i = p.insert(0xfc10);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldc_immediate_t2_t", i->name());
}

FTST(ldc_literal_t1, fix_t)
{
   i = p.insert(0xec1f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldc_literal_t1_t", i->name());
}

FTST(ldc_literal_t2, fix_t)
{
   i = p.insert(0xfc1f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldc_literal_t2_t", i->name());
}

FTST(ldm_t1, fix_t)
{
   i = p.insert(0xc800);
   EQ("ldm_t1_t", i->name());
}

FTST(ldm_t2, fix_t)
{
   i = p.insert(0xe890);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldm_t2_t", i->name());
}

FTST(ldmdb_t1, fix_t)
{
   i = p.insert(0xe910);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldmdb_t1_t", i->name());
}

FTST(ldr_immediate_t1, fix_t)
{
   i = p.insert(0x6800);
   EQ("ldr_immediate_t1_t", i->name());
}

FTST(ldr_immediate_t2, fix_t)
{
   i = p.insert(0x9800);
   EQ("ldr_immediate_t2_t", i->name());
}

FTST(ldr_immediate_t3, fix_t)
{
   i = p.insert(0xf8d0);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldr_immediate_t3_t", i->name());
}

FTST(ldr_immediate_t4, fix_t)
{
   i = p.insert(0xf850);
   EQ(np, i);
   i = p.insert(0x0800);
   EQ("ldr_immediate_t4_t", i->name());
}

FTST(ldr_literal_t1, fix_t)
{
   i = p.insert(0x4800);
   EQ("ldr_literal_t1_t", i->name());
}

FTST(ldr_literal_t2, fix_t)
{
   i = p.insert(0xf85f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldr_register_t2_t", i->name());
}

FTST(ldr_register_t1, fix_t)
{
   i = p.insert(0x5800);
   EQ("ldr_register_t1_t", i->name());
}

FTST(ldr_register_t2, fix_t)
{
   i = p.insert(0xf850);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldr_register_t2_t", i->name());
}

FTST(ldrb_immediate_t1, fix_t)
{
   i = p.insert(0x7800);
   EQ("ldrb_immediate_t1_t", i->name());
}

FTST(ldrb_immediate_t2, fix_t)
{
   i = p.insert(0xf890);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrb_immediate_t2_t", i->name());
}

FTST(ldrb_immediate_t3, fix_t)
{
   i = p.insert(0xf810);
   EQ(np, i);
   i = p.insert(0x0800);
   EQ("ldrb_immediate_t3_t", i->name());
}

FTST(ldrb_literal_t1, fix_t)
{
   i = p.insert(0xf81f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrb_register_t2_t", i->name());
}

FTST(ldrb_register_t1, fix_t)
{
   i = p.insert(0x5c00);
   EQ("ldrb_register_t1_t", i->name());
}

FTST(ldrb_register_t2, fix_t)
{
   i = p.insert(0xf810);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrb_register_t2_t", i->name());
}

FTST(ldrbt_t1, fix_t)
{
   i = p.insert(0xf810);
   EQ(np, i);
   i = p.insert(0x0e00);
   EQ("ldrbt_t1_t", i->name());
}

FTST(ldrd_t1, fix_t)
{
   i = p.insert(0xe850);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrd_immediate_t1_t", i->name());
}

FTST(ldrd_literal_t1, fix_t)
{
   i = p.insert(0xe85f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrd_literal_t1_t", i->name());
}

FTST(ldrex_t1, fix_t)
{
   i = p.insert(0xe850);
   EQ(np, i);
   i = p.insert(0x0f00);
   EQ("ldrex_t1_t", i->name());
}

FTST(ldrexb_t1, fix_t)
{
   i = p.insert(0xe8d0);
   EQ(np, i);
   i = p.insert(0x0f4f);
   EQ("ldrexb_t1_t", i->name());
}

FTST(ldrexh_t1, fix_t)
{
   i = p.insert(0xe8d0);
   EQ(np, i);
   i = p.insert(0x0f5f);
   EQ("ldrexh_t1_t", i->name());
}

FTST(ldrh_immediate_t1, fix_t)
{
   i = p.insert(0x8800);
   EQ("ldrh_immediate_t1_t", i->name());
}

FTST(ldrh_immediate_t2, fix_t)
{
   i = p.insert(0xf8b0);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrh_immediate_t2_t", i->name());
}

FTST(ldrh_immediate_t3, fix_t)
{
   i = p.insert(0xf830);
   EQ(np, i);
   i = p.insert(0x0800);
   EQ("ldrh_immediate_t3_t", i->name());
}

FTST(ldrh_literal_t1, fix_t)
{
   i = p.insert(0xf83f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrh_literal_t1_t", i->name());
}

FTST(ldrh_register_t1, fix_t)
{
   i = p.insert(0x5a00);
   EQ("ldrh_register_t1_t", i->name());
}

FTST(ldrh_register_t2, fix_t)
{
   i = p.insert(0xf830);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrh_register_t2_t", i->name());
}

FTST(ldrht_t1, fix_t)
{
   i = p.insert(0xf830);
   EQ(np, i);
   i = p.insert(0x0e00);
   EQ("ldrht_t1_t", i->name());
}

FTST(ldrsb_immediate_t1, fix_t)
{
   i = p.insert(0xf990);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrsb_immediate_t1_t", i->name());
}

FTST(ldrsb_immediate_t2, fix_t)
{
   i = p.insert(0xf910);
   EQ(np, i);
   i = p.insert(0x0800);
   EQ("ldrsb_immediate_t2_t", i->name());
}

FTST(ldrsb_literal_t1, fix_t)
{
   i = p.insert(0xf91f);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrsb_literal_t1_t", i->name());
}

FTST(ldrsb_register_t1, fix_t)
{
   i = p.insert(0x5600);
   EQ("ldrsb_register_t1_t", i->name());

}

FTST(ldrsb_register_t2, fix_t)
{
   i = p.insert(0xf910);
   EQ(np, i);
   i = p.insert(0x0000);
   EQ("ldrsb_register_t2_t", i->name());
}
