
_test_14:     file format elf32-i386


Disassembly of section .text:

00000000 <strcpy>:
   0:	55                   	push   %ebp
   1:	31 c0                	xor    %eax,%eax
   3:	89 e5                	mov    %esp,%ebp
   5:	53                   	push   %ebx
   6:	8b 4d 08             	mov    0x8(%ebp),%ecx
   9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
   c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  14:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  17:	83 c0 01             	add    $0x1,%eax
  1a:	84 d2                	test   %dl,%dl
  1c:	75 f2                	jne    10 <strcpy+0x10>
  1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  21:	89 c8                	mov    %ecx,%eax
  23:	c9                   	leave  
  24:	c3                   	ret    
  25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000030 <strcmp>:
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  34:	8b 55 08             	mov    0x8(%ebp),%edx
  37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  3a:	0f b6 02             	movzbl (%edx),%eax
  3d:	84 c0                	test   %al,%al
  3f:	75 17                	jne    58 <strcmp+0x28>
  41:	eb 3a                	jmp    7d <strcmp+0x4d>
  43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  47:	90                   	nop
  48:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  4c:	83 c2 01             	add    $0x1,%edx
  4f:	8d 59 01             	lea    0x1(%ecx),%ebx
  52:	84 c0                	test   %al,%al
  54:	74 1a                	je     70 <strcmp+0x40>
  56:	89 d9                	mov    %ebx,%ecx
  58:	0f b6 19             	movzbl (%ecx),%ebx
  5b:	38 c3                	cmp    %al,%bl
  5d:	74 e9                	je     48 <strcmp+0x18>
  5f:	29 d8                	sub    %ebx,%eax
  61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  64:	c9                   	leave  
  65:	c3                   	ret    
  66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6d:	8d 76 00             	lea    0x0(%esi),%esi
  70:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  74:	31 c0                	xor    %eax,%eax
  76:	29 d8                	sub    %ebx,%eax
  78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  7b:	c9                   	leave  
  7c:	c3                   	ret    
  7d:	0f b6 19             	movzbl (%ecx),%ebx
  80:	31 c0                	xor    %eax,%eax
  82:	eb db                	jmp    5f <strcmp+0x2f>
  84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8f:	90                   	nop

00000090 <strlen>:
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 55 08             	mov    0x8(%ebp),%edx
  96:	80 3a 00             	cmpb   $0x0,(%edx)
  99:	74 15                	je     b0 <strlen+0x20>
  9b:	31 c0                	xor    %eax,%eax
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	83 c0 01             	add    $0x1,%eax
  a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  a7:	89 c1                	mov    %eax,%ecx
  a9:	75 f5                	jne    a0 <strlen+0x10>
  ab:	89 c8                	mov    %ecx,%eax
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    
  af:	90                   	nop
  b0:	31 c9                	xor    %ecx,%ecx
  b2:	5d                   	pop    %ebp
  b3:	89 c8                	mov    %ecx,%eax
  b5:	c3                   	ret    
  b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bd:	8d 76 00             	lea    0x0(%esi),%esi

000000c0 <memset>:
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
  c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	89 d7                	mov    %edx,%edi
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d5:	89 d0                	mov    %edx,%eax
  d7:	c9                   	leave  
  d8:	c3                   	ret    
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000e0 <strchr>:
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  ea:	0f b6 10             	movzbl (%eax),%edx
  ed:	84 d2                	test   %dl,%dl
  ef:	75 12                	jne    103 <strchr+0x23>
  f1:	eb 1d                	jmp    110 <strchr+0x30>
  f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f7:	90                   	nop
  f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  fc:	83 c0 01             	add    $0x1,%eax
  ff:	84 d2                	test   %dl,%dl
 101:	74 0d                	je     110 <strchr+0x30>
 103:	38 d1                	cmp    %dl,%cl
 105:	75 f1                	jne    f8 <strchr+0x18>
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 110:	31 c0                	xor    %eax,%eax
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    
 114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 11f:	90                   	nop

00000120 <gets>:
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
 125:	8d 7d e7             	lea    -0x19(%ebp),%edi
 128:	53                   	push   %ebx
 129:	31 db                	xor    %ebx,%ebx
 12b:	83 ec 1c             	sub    $0x1c,%esp
 12e:	eb 27                	jmp    157 <gets+0x37>
 130:	83 ec 04             	sub    $0x4,%esp
 133:	6a 01                	push   $0x1
 135:	57                   	push   %edi
 136:	6a 00                	push   $0x0
 138:	e8 2e 01 00 00       	call   26b <read>
 13d:	83 c4 10             	add    $0x10,%esp
 140:	85 c0                	test   %eax,%eax
 142:	7e 1d                	jle    161 <gets+0x41>
 144:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 148:	8b 55 08             	mov    0x8(%ebp),%edx
 14b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
 14f:	3c 0a                	cmp    $0xa,%al
 151:	74 1d                	je     170 <gets+0x50>
 153:	3c 0d                	cmp    $0xd,%al
 155:	74 19                	je     170 <gets+0x50>
 157:	89 de                	mov    %ebx,%esi
 159:	83 c3 01             	add    $0x1,%ebx
 15c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 15f:	7c cf                	jl     130 <gets+0x10>
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 168:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16b:	5b                   	pop    %ebx
 16c:	5e                   	pop    %esi
 16d:	5f                   	pop    %edi
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	89 de                	mov    %ebx,%esi
 175:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 179:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17c:	5b                   	pop    %ebx
 17d:	5e                   	pop    %esi
 17e:	5f                   	pop    %edi
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18f:	90                   	nop

00000190 <stat>:
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	83 ec 08             	sub    $0x8,%esp
 198:	6a 00                	push   $0x0
 19a:	ff 75 08             	push   0x8(%ebp)
 19d:	e8 f1 00 00 00       	call   293 <open>
 1a2:	83 c4 10             	add    $0x10,%esp
 1a5:	85 c0                	test   %eax,%eax
 1a7:	78 27                	js     1d0 <stat+0x40>
 1a9:	83 ec 08             	sub    $0x8,%esp
 1ac:	ff 75 0c             	push   0xc(%ebp)
 1af:	89 c3                	mov    %eax,%ebx
 1b1:	50                   	push   %eax
 1b2:	e8 f4 00 00 00       	call   2ab <fstat>
 1b7:	89 1c 24             	mov    %ebx,(%esp)
 1ba:	89 c6                	mov    %eax,%esi
 1bc:	e8 ba 00 00 00       	call   27b <close>
 1c1:	83 c4 10             	add    $0x10,%esp
 1c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c7:	89 f0                	mov    %esi,%eax
 1c9:	5b                   	pop    %ebx
 1ca:	5e                   	pop    %esi
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
 1d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d5:	eb ed                	jmp    1c4 <stat+0x34>
 1d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1de:	66 90                	xchg   %ax,%ax

000001e0 <atoi>:
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 55 08             	mov    0x8(%ebp),%edx
 1e7:	0f be 02             	movsbl (%edx),%eax
 1ea:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1ed:	80 f9 09             	cmp    $0x9,%cl
 1f0:	b9 00 00 00 00       	mov    $0x0,%ecx
 1f5:	77 1e                	ja     215 <atoi+0x35>
 1f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fe:	66 90                	xchg   %ax,%ax
 200:	83 c2 01             	add    $0x1,%edx
 203:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 206:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 20a:	0f be 02             	movsbl (%edx),%eax
 20d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 210:	80 fb 09             	cmp    $0x9,%bl
 213:	76 eb                	jbe    200 <atoi+0x20>
 215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 218:	89 c8                	mov    %ecx,%eax
 21a:	c9                   	leave  
 21b:	c3                   	ret    
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000220 <memmove>:
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	8b 45 10             	mov    0x10(%ebp),%eax
 227:	8b 55 08             	mov    0x8(%ebp),%edx
 22a:	56                   	push   %esi
 22b:	8b 75 0c             	mov    0xc(%ebp),%esi
 22e:	85 c0                	test   %eax,%eax
 230:	7e 13                	jle    245 <memmove+0x25>
 232:	01 d0                	add    %edx,%eax
 234:	89 d7                	mov    %edx,%edi
 236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23d:	8d 76 00             	lea    0x0(%esi),%esi
 240:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 241:	39 f8                	cmp    %edi,%eax
 243:	75 fb                	jne    240 <memmove+0x20>
 245:	5e                   	pop    %esi
 246:	89 d0                	mov    %edx,%eax
 248:	5f                   	pop    %edi
 249:	5d                   	pop    %ebp
 24a:	c3                   	ret    

0000024b <fork>:
 24b:	b8 01 00 00 00       	mov    $0x1,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <exit>:
 253:	b8 02 00 00 00       	mov    $0x2,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <wait>:
 25b:	b8 03 00 00 00       	mov    $0x3,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <pipe>:
 263:	b8 04 00 00 00       	mov    $0x4,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <read>:
 26b:	b8 05 00 00 00       	mov    $0x5,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <write>:
 273:	b8 10 00 00 00       	mov    $0x10,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <close>:
 27b:	b8 15 00 00 00       	mov    $0x15,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <kill>:
 283:	b8 06 00 00 00       	mov    $0x6,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <exec>:
 28b:	b8 07 00 00 00       	mov    $0x7,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <open>:
 293:	b8 0f 00 00 00       	mov    $0xf,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <mknod>:
 29b:	b8 11 00 00 00       	mov    $0x11,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <unlink>:
 2a3:	b8 12 00 00 00       	mov    $0x12,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <fstat>:
 2ab:	b8 08 00 00 00       	mov    $0x8,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <link>:
 2b3:	b8 13 00 00 00       	mov    $0x13,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <mkdir>:
 2bb:	b8 14 00 00 00       	mov    $0x14,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <chdir>:
 2c3:	b8 09 00 00 00       	mov    $0x9,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <dup>:
 2cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <getpid>:
 2d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <sbrk>:
 2db:	b8 0c 00 00 00       	mov    $0xc,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <sleep>:
 2e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <uptime>:
 2eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <settickets>:
 2f3:	b8 16 00 00 00       	mov    $0x16,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <getpinfo>:
 2fb:	b8 17 00 00 00       	mov    $0x17,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <mprotect>:
 303:	b8 18 00 00 00       	mov    $0x18,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <munprotect>:
 30b:	b8 19 00 00 00       	mov    $0x19,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    
 313:	66 90                	xchg   %ax,%ax
 315:	66 90                	xchg   %ax,%ax
 317:	66 90                	xchg   %ax,%ax
 319:	66 90                	xchg   %ax,%ax
 31b:	66 90                	xchg   %ax,%ax
 31d:	66 90                	xchg   %ax,%ax
 31f:	90                   	nop

00000320 <printint>:
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	53                   	push   %ebx
 326:	83 ec 3c             	sub    $0x3c,%esp
 329:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 32c:	89 d1                	mov    %edx,%ecx
 32e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 331:	85 d2                	test   %edx,%edx
 333:	0f 89 7f 00 00 00    	jns    3b8 <printint+0x98>
 339:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 33d:	74 79                	je     3b8 <printint+0x98>
 33f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 346:	f7 d9                	neg    %ecx
 348:	31 db                	xor    %ebx,%ebx
 34a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 34d:	8d 76 00             	lea    0x0(%esi),%esi
 350:	89 c8                	mov    %ecx,%eax
 352:	31 d2                	xor    %edx,%edx
 354:	89 cf                	mov    %ecx,%edi
 356:	f7 75 c4             	divl   -0x3c(%ebp)
 359:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
 360:	89 45 c0             	mov    %eax,-0x40(%ebp)
 363:	89 d8                	mov    %ebx,%eax
 365:	8d 5b 01             	lea    0x1(%ebx),%ebx
 368:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 36b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 36e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 371:	76 dd                	jbe    350 <printint+0x30>
 373:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 376:	85 c9                	test   %ecx,%ecx
 378:	74 0c                	je     386 <printint+0x66>
 37a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 37f:	89 d8                	mov    %ebx,%eax
 381:	ba 2d 00 00 00       	mov    $0x2d,%edx
 386:	8b 7d b8             	mov    -0x48(%ebp),%edi
 389:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 38d:	eb 07                	jmp    396 <printint+0x76>
 38f:	90                   	nop
 390:	0f b6 13             	movzbl (%ebx),%edx
 393:	83 eb 01             	sub    $0x1,%ebx
 396:	83 ec 04             	sub    $0x4,%esp
 399:	88 55 d7             	mov    %dl,-0x29(%ebp)
 39c:	6a 01                	push   $0x1
 39e:	56                   	push   %esi
 39f:	57                   	push   %edi
 3a0:	e8 ce fe ff ff       	call   273 <write>
 3a5:	83 c4 10             	add    $0x10,%esp
 3a8:	39 de                	cmp    %ebx,%esi
 3aa:	75 e4                	jne    390 <printint+0x70>
 3ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3af:	5b                   	pop    %ebx
 3b0:	5e                   	pop    %esi
 3b1:	5f                   	pop    %edi
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret    
 3b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 3bf:	eb 87                	jmp    348 <printint+0x28>
 3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop

000003d0 <printf>:
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 2c             	sub    $0x2c,%esp
 3d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3dc:	8b 75 08             	mov    0x8(%ebp),%esi
 3df:	0f b6 13             	movzbl (%ebx),%edx
 3e2:	84 d2                	test   %dl,%dl
 3e4:	74 6a                	je     450 <printf+0x80>
 3e6:	8d 45 10             	lea    0x10(%ebp),%eax
 3e9:	83 c3 01             	add    $0x1,%ebx
 3ec:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3ef:	31 c9                	xor    %ecx,%ecx
 3f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3f4:	eb 36                	jmp    42c <printf+0x5c>
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
 400:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 403:	b9 25 00 00 00       	mov    $0x25,%ecx
 408:	83 f8 25             	cmp    $0x25,%eax
 40b:	74 15                	je     422 <printf+0x52>
 40d:	83 ec 04             	sub    $0x4,%esp
 410:	88 55 e7             	mov    %dl,-0x19(%ebp)
 413:	6a 01                	push   $0x1
 415:	57                   	push   %edi
 416:	56                   	push   %esi
 417:	e8 57 fe ff ff       	call   273 <write>
 41c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 41f:	83 c4 10             	add    $0x10,%esp
 422:	0f b6 13             	movzbl (%ebx),%edx
 425:	83 c3 01             	add    $0x1,%ebx
 428:	84 d2                	test   %dl,%dl
 42a:	74 24                	je     450 <printf+0x80>
 42c:	0f b6 c2             	movzbl %dl,%eax
 42f:	85 c9                	test   %ecx,%ecx
 431:	74 cd                	je     400 <printf+0x30>
 433:	83 f9 25             	cmp    $0x25,%ecx
 436:	75 ea                	jne    422 <printf+0x52>
 438:	83 f8 25             	cmp    $0x25,%eax
 43b:	0f 84 07 01 00 00    	je     548 <printf+0x178>
 441:	83 e8 63             	sub    $0x63,%eax
 444:	83 f8 15             	cmp    $0x15,%eax
 447:	77 17                	ja     460 <printf+0x90>
 449:	ff 24 85 00 07 00 00 	jmp    *0x700(,%eax,4)
 450:	8d 65 f4             	lea    -0xc(%ebp),%esp
 453:	5b                   	pop    %ebx
 454:	5e                   	pop    %esi
 455:	5f                   	pop    %edi
 456:	5d                   	pop    %ebp
 457:	c3                   	ret    
 458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop
 460:	83 ec 04             	sub    $0x4,%esp
 463:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 466:	6a 01                	push   $0x1
 468:	57                   	push   %edi
 469:	56                   	push   %esi
 46a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 46e:	e8 00 fe ff ff       	call   273 <write>
 473:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
 477:	83 c4 0c             	add    $0xc,%esp
 47a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 47d:	6a 01                	push   $0x1
 47f:	57                   	push   %edi
 480:	56                   	push   %esi
 481:	e8 ed fd ff ff       	call   273 <write>
 486:	83 c4 10             	add    $0x10,%esp
 489:	31 c9                	xor    %ecx,%ecx
 48b:	eb 95                	jmp    422 <printf+0x52>
 48d:	8d 76 00             	lea    0x0(%esi),%esi
 490:	83 ec 0c             	sub    $0xc,%esp
 493:	b9 10 00 00 00       	mov    $0x10,%ecx
 498:	6a 00                	push   $0x0
 49a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 49d:	8b 10                	mov    (%eax),%edx
 49f:	89 f0                	mov    %esi,%eax
 4a1:	e8 7a fe ff ff       	call   320 <printint>
 4a6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 4aa:	83 c4 10             	add    $0x10,%esp
 4ad:	31 c9                	xor    %ecx,%ecx
 4af:	e9 6e ff ff ff       	jmp    422 <printf+0x52>
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4bb:	8b 10                	mov    (%eax),%edx
 4bd:	83 c0 04             	add    $0x4,%eax
 4c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4c3:	85 d2                	test   %edx,%edx
 4c5:	0f 84 8d 00 00 00    	je     558 <printf+0x188>
 4cb:	0f b6 02             	movzbl (%edx),%eax
 4ce:	31 c9                	xor    %ecx,%ecx
 4d0:	84 c0                	test   %al,%al
 4d2:	0f 84 4a ff ff ff    	je     422 <printf+0x52>
 4d8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 4db:	89 d3                	mov    %edx,%ebx
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
 4e0:	83 ec 04             	sub    $0x4,%esp
 4e3:	83 c3 01             	add    $0x1,%ebx
 4e6:	88 45 e7             	mov    %al,-0x19(%ebp)
 4e9:	6a 01                	push   $0x1
 4eb:	57                   	push   %edi
 4ec:	56                   	push   %esi
 4ed:	e8 81 fd ff ff       	call   273 <write>
 4f2:	0f b6 03             	movzbl (%ebx),%eax
 4f5:	83 c4 10             	add    $0x10,%esp
 4f8:	84 c0                	test   %al,%al
 4fa:	75 e4                	jne    4e0 <printf+0x110>
 4fc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 4ff:	31 c9                	xor    %ecx,%ecx
 501:	e9 1c ff ff ff       	jmp    422 <printf+0x52>
 506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	83 ec 0c             	sub    $0xc,%esp
 513:	b9 0a 00 00 00       	mov    $0xa,%ecx
 518:	6a 01                	push   $0x1
 51a:	e9 7b ff ff ff       	jmp    49a <printf+0xca>
 51f:	90                   	nop
 520:	8b 45 d0             	mov    -0x30(%ebp),%eax
 523:	83 ec 04             	sub    $0x4,%esp
 526:	8b 00                	mov    (%eax),%eax
 528:	6a 01                	push   $0x1
 52a:	57                   	push   %edi
 52b:	56                   	push   %esi
 52c:	88 45 e7             	mov    %al,-0x19(%ebp)
 52f:	e8 3f fd ff ff       	call   273 <write>
 534:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 538:	83 c4 10             	add    $0x10,%esp
 53b:	31 c9                	xor    %ecx,%ecx
 53d:	e9 e0 fe ff ff       	jmp    422 <printf+0x52>
 542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 548:	88 55 e7             	mov    %dl,-0x19(%ebp)
 54b:	83 ec 04             	sub    $0x4,%esp
 54e:	e9 2a ff ff ff       	jmp    47d <printf+0xad>
 553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 557:	90                   	nop
 558:	ba f8 06 00 00       	mov    $0x6f8,%edx
 55d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 560:	b8 28 00 00 00       	mov    $0x28,%eax
 565:	89 d3                	mov    %edx,%ebx
 567:	e9 74 ff ff ff       	jmp    4e0 <printf+0x110>
 56c:	66 90                	xchg   %ax,%ax
 56e:	66 90                	xchg   %ax,%ax

00000570 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 570:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 571:	a1 dc 09 00 00       	mov    0x9dc,%eax
{
 576:	89 e5                	mov    %esp,%ebp
 578:	57                   	push   %edi
 579:	56                   	push   %esi
 57a:	53                   	push   %ebx
 57b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 57e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	89 c2                	mov    %eax,%edx
 58a:	8b 00                	mov    (%eax),%eax
 58c:	39 ca                	cmp    %ecx,%edx
 58e:	73 30                	jae    5c0 <free+0x50>
 590:	39 c1                	cmp    %eax,%ecx
 592:	72 04                	jb     598 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 594:	39 c2                	cmp    %eax,%edx
 596:	72 f0                	jb     588 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 598:	8b 73 fc             	mov    -0x4(%ebx),%esi
 59b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59e:	39 f8                	cmp    %edi,%eax
 5a0:	74 30                	je     5d2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5a2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5a5:	8b 42 04             	mov    0x4(%edx),%eax
 5a8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5ab:	39 f1                	cmp    %esi,%ecx
 5ad:	74 3a                	je     5e9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5af:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5b1:	5b                   	pop    %ebx
  freep = p;
 5b2:	89 15 dc 09 00 00    	mov    %edx,0x9dc
}
 5b8:	5e                   	pop    %esi
 5b9:	5f                   	pop    %edi
 5ba:	5d                   	pop    %ebp
 5bb:	c3                   	ret    
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c0:	39 c2                	cmp    %eax,%edx
 5c2:	72 c4                	jb     588 <free+0x18>
 5c4:	39 c1                	cmp    %eax,%ecx
 5c6:	73 c0                	jae    588 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 5c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ce:	39 f8                	cmp    %edi,%eax
 5d0:	75 d0                	jne    5a2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 5d2:	03 70 04             	add    0x4(%eax),%esi
 5d5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5d8:	8b 02                	mov    (%edx),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5df:	8b 42 04             	mov    0x4(%edx),%eax
 5e2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5e5:	39 f1                	cmp    %esi,%ecx
 5e7:	75 c6                	jne    5af <free+0x3f>
    p->s.size += bp->s.size;
 5e9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 5ec:	89 15 dc 09 00 00    	mov    %edx,0x9dc
    p->s.size += bp->s.size;
 5f2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5f5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5f8:	89 0a                	mov    %ecx,(%edx)
}
 5fa:	5b                   	pop    %ebx
 5fb:	5e                   	pop    %esi
 5fc:	5f                   	pop    %edi
 5fd:	5d                   	pop    %ebp
 5fe:	c3                   	ret    
 5ff:	90                   	nop

00000600 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 609:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 60c:	8b 3d dc 09 00 00    	mov    0x9dc,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 612:	8d 70 07             	lea    0x7(%eax),%esi
 615:	c1 ee 03             	shr    $0x3,%esi
 618:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 61b:	85 ff                	test   %edi,%edi
 61d:	0f 84 9d 00 00 00    	je     6c0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 623:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 625:	8b 4a 04             	mov    0x4(%edx),%ecx
 628:	39 f1                	cmp    %esi,%ecx
 62a:	73 6a                	jae    696 <malloc+0x96>
 62c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 631:	39 de                	cmp    %ebx,%esi
 633:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 636:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 63d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 640:	eb 17                	jmp    659 <malloc+0x59>
 642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 648:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 64a:	8b 48 04             	mov    0x4(%eax),%ecx
 64d:	39 f1                	cmp    %esi,%ecx
 64f:	73 4f                	jae    6a0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 651:	8b 3d dc 09 00 00    	mov    0x9dc,%edi
 657:	89 c2                	mov    %eax,%edx
 659:	39 d7                	cmp    %edx,%edi
 65b:	75 eb                	jne    648 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 65d:	83 ec 0c             	sub    $0xc,%esp
 660:	ff 75 e4             	push   -0x1c(%ebp)
 663:	e8 73 fc ff ff       	call   2db <sbrk>
  if(p == (char*)-1)
 668:	83 c4 10             	add    $0x10,%esp
 66b:	83 f8 ff             	cmp    $0xffffffff,%eax
 66e:	74 1c                	je     68c <malloc+0x8c>
  hp->s.size = nu;
 670:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 673:	83 ec 0c             	sub    $0xc,%esp
 676:	83 c0 08             	add    $0x8,%eax
 679:	50                   	push   %eax
 67a:	e8 f1 fe ff ff       	call   570 <free>
  return freep;
 67f:	8b 15 dc 09 00 00    	mov    0x9dc,%edx
      if((p = morecore(nunits)) == 0)
 685:	83 c4 10             	add    $0x10,%esp
 688:	85 d2                	test   %edx,%edx
 68a:	75 bc                	jne    648 <malloc+0x48>
        return 0;
  }
}
 68c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 68f:	31 c0                	xor    %eax,%eax
}
 691:	5b                   	pop    %ebx
 692:	5e                   	pop    %esi
 693:	5f                   	pop    %edi
 694:	5d                   	pop    %ebp
 695:	c3                   	ret    
    if(p->s.size >= nunits){
 696:	89 d0                	mov    %edx,%eax
 698:	89 fa                	mov    %edi,%edx
 69a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6a0:	39 ce                	cmp    %ecx,%esi
 6a2:	74 4c                	je     6f0 <malloc+0xf0>
        p->s.size -= nunits;
 6a4:	29 f1                	sub    %esi,%ecx
 6a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6ac:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 6af:	89 15 dc 09 00 00    	mov    %edx,0x9dc
}
 6b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6b8:	83 c0 08             	add    $0x8,%eax
}
 6bb:	5b                   	pop    %ebx
 6bc:	5e                   	pop    %esi
 6bd:	5f                   	pop    %edi
 6be:	5d                   	pop    %ebp
 6bf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 6c0:	c7 05 dc 09 00 00 e0 	movl   $0x9e0,0x9dc
 6c7:	09 00 00 
    base.s.size = 0;
 6ca:	bf e0 09 00 00       	mov    $0x9e0,%edi
    base.s.ptr = freep = prevp = &base;
 6cf:	c7 05 e0 09 00 00 e0 	movl   $0x9e0,0x9e0
 6d6:	09 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 6db:	c7 05 e4 09 00 00 00 	movl   $0x0,0x9e4
 6e2:	00 00 00 
    if(p->s.size >= nunits){
 6e5:	e9 42 ff ff ff       	jmp    62c <malloc+0x2c>
 6ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 6f0:	8b 08                	mov    (%eax),%ecx
 6f2:	89 0a                	mov    %ecx,(%edx)
 6f4:	eb b9                	jmp    6af <malloc+0xaf>
