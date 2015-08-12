#include ".test.hpp"

enum class enum_t
{
    red,
    green,
    blue,
};

int not_ungood(enum_t e)
{
    switch(e)
    {
        case enum_t::red:
            return 12;
        case enum_t::green:
            return 42;
        case enum_t::blue:
            return -1;
    }
}

TEST(basic)
{
    EQ(12, not_ungood(enum_t::red));
    EQ(42, not_ungood(enum_t::green));
    EQ(-1, not_ungood(enum_t::blue));
    EQ(0, not_ungood(static_cast<enum_t>(100)));
#if 0
Program received signal SIGILL, Illegal instruction.
        0x00000000004df892 in not_ungood (e=(unknown: 100)) at test-it.cpp:20
        20          }
        (gdb) bt
#0  0x00000000004df892 in not_ungood (e=(unknown: 100)) at test-it.cpp:20
#1  0x00000000004e1a00 in basic::test_method (this=<optimized out>) at test-it.cpp:29
#2  0x00000000004dfa14 in basic_invoker () at test-it.cpp:23
#3  0x00000000004ed94c in boost::unit_test::ut_detail::invoker<boost::unit_test::ut_detail::unused>::invoke<void (*)()> (this=0x7fffffffcff0, f=@0x60200000eed8: 0x4df940 <basic_invoker()>)
            at /usr/include/boost/test/utils/callback.hpp:56
#4  0x00000000004ed71f in boost::unit_test::ut_detail::callback0_impl_t<boost::unit_test::ut_detail::unused, void (*)()>::invoke (this=0x60200000eed0)
                at /usr/include/boost/test/utils/callback.hpp:89
#5  0x00007ffff7b9b191 in ?? () from /usr/lib/libboost_unit_test_framework.so.1.58.0
#6  0x00007ffff7b7acb6 in boost::execution_monitor::catch_signals(boost::unit_test::callback0<int> const&) () from /usr/lib/libboost_unit_test_framework.so.1.58.0
#7  0x00007ffff7b7b4d3 in boost::execution_monitor::execute(boost::unit_test::callback0<int> const&) () from /usr/lib/libboost_unit_test_framework.so.1.58.0
#8  0x00007ffff7b9b2c2 in boost::unit_test::unit_test_monitor_t::execute_and_translate(boost::unit_test::test_case const&) () from /usr/lib/libboost_unit_test_framework.so.1.58.0
#9  0x00007ffff7b822fe in boost::unit_test::framework_impl::visit(boost::unit_test::test_case const&) () from /usr/lib/libboost_unit_test_framework.so.1.58.0
#10 0x00007ffff7bb8693 in boost::unit_test::traverse_test_tree(boost::unit_test::test_suite const&, boost::unit_test::test_tree_visitor&) ()
                   from /usr/lib/libboost_unit_test_framework.so.1.58.0
#11 0x00007ffff7b7dc46 in boost::unit_test::framework::run(unsigned long, bool) () from /usr/lib/libboost_unit_test_framework.so.1.58.0
#12 0x00007ffff7b99767 in boost::unit_test::unit_test_main(bool (*)(), int, char**) () from /usr/lib/libboost_unit_test_framework.so.1.58.0
#13 0x00000000004df564 in main (argc=1, argv=0x7fffffffdf58) at /usr/include/boost/test/unit_test.hpp:59
#endif
}
