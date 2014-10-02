
prog:     file format elf64-x86-64


Disassembly of section .init:

0000000000400648 <_init>:
  400648:	48 83 ec 08          	sub    $0x8,%rsp
  40064c:	48 8b 05 1d 06 20 00 	mov    0x20061d(%rip),%rax        # 600c70 <_DYNAMIC+0x200>
  400653:	48 85 c0             	test   %rax,%rax
  400656:	74 05                	je     40065d <_init+0x15>
  400658:	e8 23 00 00 00       	callq  400680 <__gmon_start__@plt>
  40065d:	48 83 c4 08          	add    $0x8,%rsp
  400661:	c3                   	retq   

Disassembly of section .plt:

0000000000400670 <__gmon_start__@plt-0x10>:
  400670:	ff 35 0a 06 20 00    	pushq  0x20060a(%rip)        # 600c80 <_GLOBAL_OFFSET_TABLE_+0x8>
  400676:	ff 25 0c 06 20 00    	jmpq   *0x20060c(%rip)        # 600c88 <_GLOBAL_OFFSET_TABLE_+0x10>
  40067c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400680 <__gmon_start__@plt>:
  400680:	ff 25 0a 06 20 00    	jmpq   *0x20060a(%rip)        # 600c90 <_GLOBAL_OFFSET_TABLE_+0x18>
  400686:	68 00 00 00 00       	pushq  $0x0
  40068b:	e9 e0 ff ff ff       	jmpq   400670 <_init+0x28>

0000000000400690 <_ZNSt8ios_base4InitC1Ev@plt>:
  400690:	ff 25 02 06 20 00    	jmpq   *0x200602(%rip)        # 600c98 <_GLOBAL_OFFSET_TABLE_+0x20>
  400696:	68 01 00 00 00       	pushq  $0x1
  40069b:	e9 d0 ff ff ff       	jmpq   400670 <_init+0x28>

00000000004006a0 <__libc_start_main@plt>:
  4006a0:	ff 25 fa 05 20 00    	jmpq   *0x2005fa(%rip)        # 600ca0 <_GLOBAL_OFFSET_TABLE_+0x28>
  4006a6:	68 02 00 00 00       	pushq  $0x2
  4006ab:	e9 c0 ff ff ff       	jmpq   400670 <_init+0x28>

00000000004006b0 <__cxa_atexit@plt>:
  4006b0:	ff 25 f2 05 20 00    	jmpq   *0x2005f2(%rip)        # 600ca8 <_GLOBAL_OFFSET_TABLE_+0x30>
  4006b6:	68 03 00 00 00       	pushq  $0x3
  4006bb:	e9 b0 ff ff ff       	jmpq   400670 <_init+0x28>

00000000004006c0 <_ZNSt8ios_base4InitD1Ev@plt>:
  4006c0:	ff 25 ea 05 20 00    	jmpq   *0x2005ea(%rip)        # 600cb0 <_GLOBAL_OFFSET_TABLE_+0x38>
  4006c6:	68 04 00 00 00       	pushq  $0x4
  4006cb:	e9 a0 ff ff ff       	jmpq   400670 <_init+0x28>

00000000004006d0 <_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@plt>:
  4006d0:	ff 25 e2 05 20 00    	jmpq   *0x2005e2(%rip)        # 600cb8 <_GLOBAL_OFFSET_TABLE_+0x40>
  4006d6:	68 05 00 00 00       	pushq  $0x5
  4006db:	e9 90 ff ff ff       	jmpq   400670 <_init+0x28>

00000000004006e0 <_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt>:
  4006e0:	ff 25 da 05 20 00    	jmpq   *0x2005da(%rip)        # 600cc0 <_GLOBAL_OFFSET_TABLE_+0x48>
  4006e6:	68 06 00 00 00       	pushq  $0x6
  4006eb:	e9 80 ff ff ff       	jmpq   400670 <_init+0x28>

Disassembly of section .text:

00000000004006f0 <_start>:
  4006f0:	31 ed                	xor    %ebp,%ebp
  4006f2:	49 89 d1             	mov    %rdx,%r9
  4006f5:	5e                   	pop    %rsi
  4006f6:	48 89 e2             	mov    %rsp,%rdx
  4006f9:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  4006fd:	50                   	push   %rax
  4006fe:	54                   	push   %rsp
  4006ff:	49 c7 c0 d0 08 40 00 	mov    $0x4008d0,%r8
  400706:	48 c7 c1 60 08 40 00 	mov    $0x400860,%rcx
  40070d:	48 c7 c7 32 08 40 00 	mov    $0x400832,%rdi
  400714:	e8 87 ff ff ff       	callq  4006a0 <__libc_start_main@plt>
  400719:	f4                   	hlt    
  40071a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400720 <deregister_tm_clones>:
  400720:	b8 df 0c 60 00       	mov    $0x600cdf,%eax
  400725:	55                   	push   %rbp
  400726:	48 2d d8 0c 60 00    	sub    $0x600cd8,%rax
  40072c:	48 83 f8 0e          	cmp    $0xe,%rax
  400730:	48 89 e5             	mov    %rsp,%rbp
  400733:	76 1b                	jbe    400750 <deregister_tm_clones+0x30>
  400735:	b8 00 00 00 00       	mov    $0x0,%eax
  40073a:	48 85 c0             	test   %rax,%rax
  40073d:	74 11                	je     400750 <deregister_tm_clones+0x30>
  40073f:	5d                   	pop    %rbp
  400740:	bf d8 0c 60 00       	mov    $0x600cd8,%edi
  400745:	ff e0                	jmpq   *%rax
  400747:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  40074e:	00 00 
  400750:	5d                   	pop    %rbp
  400751:	c3                   	retq   
  400752:	66 66 66 66 66 2e 0f 	data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
  400759:	1f 84 00 00 00 00 00 

0000000000400760 <register_tm_clones>:
  400760:	be d8 0c 60 00       	mov    $0x600cd8,%esi
  400765:	55                   	push   %rbp
  400766:	48 81 ee d8 0c 60 00 	sub    $0x600cd8,%rsi
  40076d:	48 c1 fe 03          	sar    $0x3,%rsi
  400771:	48 89 e5             	mov    %rsp,%rbp
  400774:	48 89 f0             	mov    %rsi,%rax
  400777:	48 c1 e8 3f          	shr    $0x3f,%rax
  40077b:	48 01 c6             	add    %rax,%rsi
  40077e:	48 d1 fe             	sar    %rsi
  400781:	74 15                	je     400798 <register_tm_clones+0x38>
  400783:	b8 00 00 00 00       	mov    $0x0,%eax
  400788:	48 85 c0             	test   %rax,%rax
  40078b:	74 0b                	je     400798 <register_tm_clones+0x38>
  40078d:	5d                   	pop    %rbp
  40078e:	bf d8 0c 60 00       	mov    $0x600cd8,%edi
  400793:	ff e0                	jmpq   *%rax
  400795:	0f 1f 00             	nopl   (%rax)
  400798:	5d                   	pop    %rbp
  400799:	c3                   	retq   
  40079a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000004007a0 <__do_global_dtors_aux>:
  4007a0:	80 3d 69 06 20 00 00 	cmpb   $0x0,0x200669(%rip)        # 600e10 <completed.6625>
  4007a7:	75 11                	jne    4007ba <__do_global_dtors_aux+0x1a>
  4007a9:	55                   	push   %rbp
  4007aa:	48 89 e5             	mov    %rsp,%rbp
  4007ad:	e8 6e ff ff ff       	callq  400720 <deregister_tm_clones>
  4007b2:	5d                   	pop    %rbp
  4007b3:	c6 05 56 06 20 00 01 	movb   $0x1,0x200656(%rip)        # 600e10 <completed.6625>
  4007ba:	f3 c3                	repz retq 
  4007bc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004007c0 <frame_dummy>:
  4007c0:	bf 68 0a 60 00       	mov    $0x600a68,%edi
  4007c5:	48 83 3f 00          	cmpq   $0x0,(%rdi)
  4007c9:	75 05                	jne    4007d0 <frame_dummy+0x10>
  4007cb:	eb 93                	jmp    400760 <register_tm_clones>
  4007cd:	0f 1f 00             	nopl   (%rax)
  4007d0:	b8 00 00 00 00       	mov    $0x0,%eax
  4007d5:	48 85 c0             	test   %rax,%rax
  4007d8:	74 f1                	je     4007cb <frame_dummy+0xb>
  4007da:	55                   	push   %rbp
  4007db:	48 89 e5             	mov    %rsp,%rbp
  4007de:	ff d0                	callq  *%rax
  4007e0:	5d                   	pop    %rbp
  4007e1:	e9 7a ff ff ff       	jmpq   400760 <register_tm_clones>

00000000004007e6 <_Z41__static_initialization_and_destruction_0ii>:
   //
   closure();

   //
   return 0;
}
  4007e6:	83 ff 01             	cmp    $0x1,%edi
  4007e9:	75 2e                	jne    400819 <_Z41__static_initialization_and_destruction_0ii+0x33>
  4007eb:	81 fe ff ff 00 00    	cmp    $0xffff,%esi
  4007f1:	75 26                	jne    400819 <_Z41__static_initialization_and_destruction_0ii+0x33>
  4007f3:	48 83 ec 08          	sub    $0x8,%rsp
  extern wostream wclog;	/// Linked to standard error (buffered)
#endif
  //@}

  // For construction of filebuffers for cout, cin, cerr, clog et. al.
  static ios_base::Init __ioinit;
  4007f7:	bf 11 0e 60 00       	mov    $0x600e11,%edi
  4007fc:	e8 8f fe ff ff       	callq  400690 <_ZNSt8ios_base4InitC1Ev@plt>
  400801:	ba d0 0c 60 00       	mov    $0x600cd0,%edx
  400806:	be 11 0e 60 00       	mov    $0x600e11,%esi
  40080b:	bf c0 06 40 00       	mov    $0x4006c0,%edi
  400810:	e8 9b fe ff ff       	callq  4006b0 <__cxa_atexit@plt>
  400815:	48 83 c4 08          	add    $0x8,%rsp
  400819:	c3                   	retq   

000000000040081a <_GLOBAL__sub_I__Z3fooi1B>:
  40081a:	48 83 ec 08          	sub    $0x8,%rsp
  40081e:	be ff ff 00 00       	mov    $0xffff,%esi
  400823:	bf 01 00 00 00       	mov    $0x1,%edi
  400828:	e8 b9 ff ff ff       	callq  4007e6 <_Z41__static_initialization_and_destruction_0ii>
  40082d:	48 83 c4 08          	add    $0x8,%rsp
  400831:	c3                   	retq   

0000000000400832 <main>:
int a = 10;
B b;
auto capturing_closure = [=, b = std::move(B(b))]() {foo(a, b);};

int main()
{
  400832:	48 83 ec 08          	sub    $0x8,%rsp
   //generates an extra instruction at invocation...
   //auto&& closure = []{std::cout << "yo" << std::endl;};
   //...but is equivalent to this when optimizing.
   auto closure = []{std::cout << "yo" << std::endl;};
  400836:	be e4 08 40 00       	mov    $0x4008e4,%esi
  40083b:	bf 00 0d 60 00       	mov    $0x600d00,%edi
  400840:	e8 8b fe ff ff       	callq  4006d0 <_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@plt>
      operator<<(__ostream_type& (*__pf)(__ostream_type&))
      {
	// _GLIBCXX_RESOLVE_LIB_DEFECTS
	// DR 60. What is a formatted input function?
	// The inserters for manipulators are *not* formatted output functions.
	return __pf(*this);
  400845:	48 89 c7             	mov    %rax,%rdi
  400848:	e8 93 fe ff ff       	callq  4006e0 <_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt>
   //
   closure();

   //
   return 0;
}
  40084d:	b8 00 00 00 00       	mov    $0x0,%eax
  400852:	48 83 c4 08          	add    $0x8,%rsp
  400856:	c3                   	retq   
  400857:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  40085e:	00 00 

0000000000400860 <__libc_csu_init>:
  400860:	41 57                	push   %r15
  400862:	41 56                	push   %r14
  400864:	41 89 ff             	mov    %edi,%r15d
  400867:	41 55                	push   %r13
  400869:	41 54                	push   %r12
  40086b:	4c 8d 25 de 01 20 00 	lea    0x2001de(%rip),%r12        # 600a50 <__frame_dummy_init_array_entry>
  400872:	55                   	push   %rbp
  400873:	48 8d 2d e6 01 20 00 	lea    0x2001e6(%rip),%rbp        # 600a60 <__init_array_end>
  40087a:	53                   	push   %rbx
  40087b:	49 89 f6             	mov    %rsi,%r14
  40087e:	49 89 d5             	mov    %rdx,%r13
  400881:	31 db                	xor    %ebx,%ebx
  400883:	4c 29 e5             	sub    %r12,%rbp
  400886:	48 83 ec 08          	sub    $0x8,%rsp
  40088a:	48 c1 fd 03          	sar    $0x3,%rbp
  40088e:	e8 b5 fd ff ff       	callq  400648 <_init>
  400893:	48 85 ed             	test   %rbp,%rbp
  400896:	74 1e                	je     4008b6 <__libc_csu_init+0x56>
  400898:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  40089f:	00 
  4008a0:	4c 89 ea             	mov    %r13,%rdx
  4008a3:	4c 89 f6             	mov    %r14,%rsi
  4008a6:	44 89 ff             	mov    %r15d,%edi
  4008a9:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  4008ad:	48 83 c3 01          	add    $0x1,%rbx
  4008b1:	48 39 eb             	cmp    %rbp,%rbx
  4008b4:	75 ea                	jne    4008a0 <__libc_csu_init+0x40>
  4008b6:	48 83 c4 08          	add    $0x8,%rsp
  4008ba:	5b                   	pop    %rbx
  4008bb:	5d                   	pop    %rbp
  4008bc:	41 5c                	pop    %r12
  4008be:	41 5d                	pop    %r13
  4008c0:	41 5e                	pop    %r14
  4008c2:	41 5f                	pop    %r15
  4008c4:	c3                   	retq   
  4008c5:	66 66 2e 0f 1f 84 00 	data32 nopw %cs:0x0(%rax,%rax,1)
  4008cc:	00 00 00 00 

00000000004008d0 <__libc_csu_fini>:
  4008d0:	f3 c3                	repz retq 

Disassembly of section .fini:

00000000004008d4 <_fini>:
  4008d4:	48 83 ec 08          	sub    $0x8,%rsp
  4008d8:	48 83 c4 08          	add    $0x8,%rsp
  4008dc:	c3                   	retq   
