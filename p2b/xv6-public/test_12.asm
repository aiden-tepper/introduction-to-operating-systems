
_test_12:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 18 08 00 00    	sub    $0x818,%esp
  int pid_low = getpid();
  17:	e8 27 05 00 00       	call   543 <getpid>
  int lowtickets = 0, hightickets = 1;

  if (settickets(lowtickets) != 0) {
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	6a 00                	push   $0x0
  int pid_low = getpid();
  21:	89 c3                	mov    %eax,%ebx
  if (settickets(lowtickets) != 0) {
  23:	e8 3b 05 00 00       	call   563 <settickets>
  28:	83 c4 10             	add    $0x10,%esp
  2b:	85 c0                	test   %eax,%eax
  2d:	75 41                	jne    70 <main+0x70>
    printf(1, "XV6_SCHEDULER\t FAILED\n"); 
    exit();
  }

  if (fork() == 0) {  	
  2f:	e8 87 04 00 00       	call   4bb <fork>
  34:	85 c0                	test   %eax,%eax
  36:	74 26                	je     5e <main+0x5e>
	
    compare(pid_low, pid_high, &st_before, &st_after);
         
    exit();
  }
  printf(1,"Spinning...%d\n", spin());
  38:	e8 e3 00 00 00       	call   120 <spin>
  3d:	52                   	push   %edx
  3e:	50                   	push   %eax
  3f:	68 0e 0a 00 00       	push   $0xa0e
  44:	6a 01                	push   $0x1
  46:	e8 f5 05 00 00       	call   640 <printf>

  while (wait() > -1);
  4b:	83 c4 10             	add    $0x10,%esp
  4e:	66 90                	xchg   %ax,%ax
  50:	e8 76 04 00 00       	call   4cb <wait>
  55:	85 c0                	test   %eax,%eax
  57:	79 f7                	jns    50 <main+0x50>
  exit();
  59:	e8 65 04 00 00       	call   4c3 <exit>
    if (settickets(hightickets) != 0) {
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	6a 01                	push   $0x1
  63:	e8 fb 04 00 00       	call   563 <settickets>
  68:	83 c4 10             	add    $0x10,%esp
  6b:	85 c0                	test   %eax,%eax
  6d:	74 15                	je     84 <main+0x84>
  6f:	90                   	nop
    printf(1, "XV6_SCHEDULER\t FAILED\n"); 
  70:	83 ec 08             	sub    $0x8,%esp
  73:	68 de 09 00 00       	push   $0x9de
  78:	6a 01                	push   $0x1
  7a:	e8 c1 05 00 00       	call   640 <printf>
    exit();
  7f:	e8 3f 04 00 00       	call   4c3 <exit>
    int pid_high = getpid();
  84:	e8 ba 04 00 00       	call   543 <getpid>
    if (getpinfo(&st_before) != 0) {
  89:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	56                   	push   %esi
    int pid_high = getpid();
  93:	89 85 e4 f7 ff ff    	mov    %eax,-0x81c(%ebp)
    if (getpinfo(&st_before) != 0) {
  99:	e8 cd 04 00 00       	call   56b <getpinfo>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	85 c0                	test   %eax,%eax
  a3:	75 cb                	jne    70 <main+0x70>
    printf(1, "\n ****PInfo before**** \n");
  a5:	57                   	push   %edi
  a6:	57                   	push   %edi
    if (getpinfo(&st_after) != 0) {
  a7:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
    printf(1, "\n ****PInfo before**** \n");
  ad:	68 f5 09 00 00       	push   $0x9f5
  b2:	6a 01                	push   $0x1
  b4:	e8 87 05 00 00       	call   640 <printf>
    print(&st_before);
  b9:	89 34 24             	mov    %esi,(%esp)
  bc:	e8 6f 00 00 00       	call   130 <print>
    printf(1,"Spinning...%d\n", spin());
  c1:	e8 5a 00 00 00       	call   120 <spin>
  c6:	83 c4 0c             	add    $0xc,%esp
  c9:	50                   	push   %eax
  ca:	68 0e 0a 00 00       	push   $0xa0e
  cf:	6a 01                	push   $0x1
  d1:	e8 6a 05 00 00       	call   640 <printf>
    if (getpinfo(&st_after) != 0) {
  d6:	89 3c 24             	mov    %edi,(%esp)
  d9:	e8 8d 04 00 00       	call   56b <getpinfo>
  de:	83 c4 10             	add    $0x10,%esp
  e1:	85 c0                	test   %eax,%eax
  e3:	75 8b                	jne    70 <main+0x70>
    printf(1, "\n ****PInfo after**** \n");
  e5:	51                   	push   %ecx
  e6:	51                   	push   %ecx
  e7:	68 1d 0a 00 00       	push   $0xa1d
  ec:	6a 01                	push   $0x1
  ee:	e8 4d 05 00 00       	call   640 <printf>
    print(&st_after);
  f3:	89 3c 24             	mov    %edi,(%esp)
  f6:	e8 35 00 00 00       	call   130 <print>
    compare(pid_low, pid_high, &st_before, &st_after);
  fb:	57                   	push   %edi
  fc:	56                   	push   %esi
  fd:	ff b5 e4 f7 ff ff    	push   -0x81c(%ebp)
 103:	53                   	push   %ebx
 104:	e8 77 00 00 00       	call   180 <compare>
    exit();
 109:	83 c4 20             	add    $0x20,%esp
 10c:	e8 b2 03 00 00       	call   4c3 <exit>
 111:	66 90                	xchg   %ax,%ax
 113:	66 90                	xchg   %ax,%ax
 115:	66 90                	xchg   %ax,%ax
 117:	66 90                	xchg   %ax,%ax
 119:	66 90                	xchg   %ax,%ax
 11b:	66 90                	xchg   %ax,%ax
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <spin>:
}
 120:	b8 91 13 00 00       	mov    $0x1391,%eax
 125:	c3                   	ret    
 126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12d:	8d 76 00             	lea    0x0(%esi),%esi

00000130 <print>:
void print(struct pstat *st) {
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
 135:	8b 5d 08             	mov    0x8(%ebp),%ebx
 138:	8d b3 00 01 00 00    	lea    0x100(%ebx),%esi
 13e:	eb 07                	jmp    147 <print+0x17>
   for(i = 0; i < NPROC; i++) {
 140:	83 c3 04             	add    $0x4,%ebx
 143:	39 f3                	cmp    %esi,%ebx
 145:	74 31                	je     178 <print+0x48>
     if (st->inuse[i]) {
 147:	8b 03                	mov    (%ebx),%eax
 149:	85 c0                	test   %eax,%eax
 14b:	74 f3                	je     140 <print+0x10>
       printf(1, "pid: %d tickets: %d ticks: %d\n", st->pid[i], st->tickets[i], st->ticks[i]);
 14d:	83 ec 0c             	sub    $0xc,%esp
 150:	ff b3 00 03 00 00    	push   0x300(%ebx)
   for(i = 0; i < NPROC; i++) {
 156:	83 c3 04             	add    $0x4,%ebx
       printf(1, "pid: %d tickets: %d ticks: %d\n", st->pid[i], st->tickets[i], st->ticks[i]);
 159:	ff b3 fc 00 00 00    	push   0xfc(%ebx)
 15f:	ff b3 fc 01 00 00    	push   0x1fc(%ebx)
 165:	68 68 09 00 00       	push   $0x968
 16a:	6a 01                	push   $0x1
 16c:	e8 cf 04 00 00       	call   640 <printf>
 171:	83 c4 20             	add    $0x20,%esp
   for(i = 0; i < NPROC; i++) {
 174:	39 f3                	cmp    %esi,%ebx
 176:	75 cf                	jne    147 <print+0x17>
}
 178:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17b:	5b                   	pop    %ebx
 17c:	5e                   	pop    %esi
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    
 17f:	90                   	nop

00000180 <compare>:
void compare(int pid_low, int pid_high, struct pstat *before, struct pstat *after) {
 180:	55                   	push   %ebp
  for(i = 0; i < NPROC; i++) {
 181:	31 c0                	xor    %eax,%eax
void compare(int pid_low, int pid_high, struct pstat *before, struct pstat *after) {
 183:	89 e5                	mov    %esp,%ebp
 185:	57                   	push   %edi
 186:	56                   	push   %esi
 187:	53                   	push   %ebx
 188:	83 ec 2c             	sub    $0x2c,%esp
 18b:	8b 75 14             	mov    0x14(%ebp),%esi
 18e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i, ticks_low_before=-1, ticks_low_after=-1, ticks_high_before=-1, ticks_high_after=-1;
 191:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
void compare(int pid_low, int pid_high, struct pstat *before, struct pstat *after) {
 198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 19b:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i, ticks_low_before=-1, ticks_low_after=-1, ticks_high_before=-1, ticks_high_after=-1;
 19e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
 1a5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
 1ac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  for(i = 0; i < NPROC; i++) {
 1b3:	89 75 e4             	mov    %esi,-0x1c(%ebp)
 1b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
    if (before->pid[i] == pid_low) 
 1c0:	8b 94 87 00 02 00 00 	mov    0x200(%edi,%eax,4),%edx
 1c7:	39 da                	cmp    %ebx,%edx
 1c9:	75 0a                	jne    1d5 <compare+0x55>
        ticks_low_before = before->ticks[i];
 1cb:	8b b4 87 00 03 00 00 	mov    0x300(%edi,%eax,4),%esi
 1d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
    if (before->pid[i] == pid_high)
 1d5:	39 ca                	cmp    %ecx,%edx
 1d7:	75 0a                	jne    1e3 <compare+0x63>
        ticks_high_before = before->ticks[i];
 1d9:	8b b4 87 00 03 00 00 	mov    0x300(%edi,%eax,4),%esi
 1e0:	89 75 d8             	mov    %esi,-0x28(%ebp)
    if (after->pid[i] == pid_low)
 1e3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
 1e6:	8b 94 86 00 02 00 00 	mov    0x200(%esi,%eax,4),%edx
 1ed:	39 da                	cmp    %ebx,%edx
 1ef:	75 0a                	jne    1fb <compare+0x7b>
        ticks_low_after = after->ticks[i];
 1f1:	8b b4 86 00 03 00 00 	mov    0x300(%esi,%eax,4),%esi
 1f8:	89 75 dc             	mov    %esi,-0x24(%ebp)
    if (after->pid[i] == pid_high)
 1fb:	39 ca                	cmp    %ecx,%edx
 1fd:	75 0d                	jne    20c <compare+0x8c>
        ticks_high_after = after->ticks[i];
 1ff:	8b 75 e4             	mov    -0x1c(%ebp),%esi
 202:	8b b4 86 00 03 00 00 	mov    0x300(%esi,%eax,4),%esi
 209:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  for(i = 0; i < NPROC; i++) {
 20c:	83 c0 01             	add    $0x1,%eax
 20f:	83 f8 40             	cmp    $0x40,%eax
 212:	75 ac                	jne    1c0 <compare+0x40>
  printf(1, "high before: %d high after: %d, low before: %d low after: %d\n", 
 214:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 217:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 21a:	83 ec 08             	sub    $0x8,%esp
 21d:	8b 75 d8             	mov    -0x28(%ebp),%esi
 220:	53                   	push   %ebx
 221:	ff 75 e0             	push   -0x20(%ebp)
 224:	57                   	push   %edi
  if ( (ticks_high_after-ticks_high_before) > (ticks_low_after - ticks_low_before)) {
 225:	29 f7                	sub    %esi,%edi
  printf(1, "high before: %d high after: %d, low before: %d low after: %d\n", 
 227:	56                   	push   %esi
 228:	68 88 09 00 00       	push   $0x988
 22d:	6a 01                	push   $0x1
 22f:	e8 0c 04 00 00       	call   640 <printf>
  if ( (ticks_high_after-ticks_high_before) > (ticks_low_after - ticks_low_before)) {
 234:	89 d8                	mov    %ebx,%eax
 236:	2b 45 e0             	sub    -0x20(%ebp),%eax
 239:	83 c4 20             	add    $0x20,%esp
 23c:	39 c7                	cmp    %eax,%edi
 23e:	7e 1a                	jle    25a <compare+0xda>
    printf(1, "XV6_SCHEDULER\t SUCCESS\n"); 
 240:	c7 45 0c c6 09 00 00 	movl   $0x9c6,0xc(%ebp)
 247:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 24e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 251:	5b                   	pop    %ebx
 252:	5e                   	pop    %esi
 253:	5f                   	pop    %edi
 254:	5d                   	pop    %ebp
    printf(1, "XV6_SCHEDULER\t SUCCESS\n"); 
 255:	e9 e6 03 00 00       	jmp    640 <printf>
    printf(1, "XV6_SCHEDULER\t FAILED\n"); 
 25a:	50                   	push   %eax
 25b:	50                   	push   %eax
 25c:	68 de 09 00 00       	push   $0x9de
 261:	6a 01                	push   $0x1
 263:	e8 d8 03 00 00       	call   640 <printf>
    exit();
 268:	e8 56 02 00 00       	call   4c3 <exit>
 26d:	66 90                	xchg   %ax,%ax
 26f:	90                   	nop

00000270 <strcpy>:
 270:	55                   	push   %ebp
 271:	31 c0                	xor    %eax,%eax
 273:	89 e5                	mov    %esp,%ebp
 275:	53                   	push   %ebx
 276:	8b 4d 08             	mov    0x8(%ebp),%ecx
 279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 280:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 284:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 287:	83 c0 01             	add    $0x1,%eax
 28a:	84 d2                	test   %dl,%dl
 28c:	75 f2                	jne    280 <strcpy+0x10>
 28e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 291:	89 c8                	mov    %ecx,%eax
 293:	c9                   	leave  
 294:	c3                   	ret    
 295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <strcmp>:
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2aa:	0f b6 02             	movzbl (%edx),%eax
 2ad:	84 c0                	test   %al,%al
 2af:	75 17                	jne    2c8 <strcmp+0x28>
 2b1:	eb 3a                	jmp    2ed <strcmp+0x4d>
 2b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b7:	90                   	nop
 2b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
 2bc:	83 c2 01             	add    $0x1,%edx
 2bf:	8d 59 01             	lea    0x1(%ecx),%ebx
 2c2:	84 c0                	test   %al,%al
 2c4:	74 1a                	je     2e0 <strcmp+0x40>
 2c6:	89 d9                	mov    %ebx,%ecx
 2c8:	0f b6 19             	movzbl (%ecx),%ebx
 2cb:	38 c3                	cmp    %al,%bl
 2cd:	74 e9                	je     2b8 <strcmp+0x18>
 2cf:	29 d8                	sub    %ebx,%eax
 2d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2d4:	c9                   	leave  
 2d5:	c3                   	ret    
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2e4:	31 c0                	xor    %eax,%eax
 2e6:	29 d8                	sub    %ebx,%eax
 2e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    
 2ed:	0f b6 19             	movzbl (%ecx),%ebx
 2f0:	31 c0                	xor    %eax,%eax
 2f2:	eb db                	jmp    2cf <strcmp+0x2f>
 2f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <strlen>:
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 55 08             	mov    0x8(%ebp),%edx
 306:	80 3a 00             	cmpb   $0x0,(%edx)
 309:	74 15                	je     320 <strlen+0x20>
 30b:	31 c0                	xor    %eax,%eax
 30d:	8d 76 00             	lea    0x0(%esi),%esi
 310:	83 c0 01             	add    $0x1,%eax
 313:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 317:	89 c1                	mov    %eax,%ecx
 319:	75 f5                	jne    310 <strlen+0x10>
 31b:	89 c8                	mov    %ecx,%eax
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    
 31f:	90                   	nop
 320:	31 c9                	xor    %ecx,%ecx
 322:	5d                   	pop    %ebp
 323:	89 c8                	mov    %ecx,%eax
 325:	c3                   	ret    
 326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32d:	8d 76 00             	lea    0x0(%esi),%esi

00000330 <memset>:
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	8b 55 08             	mov    0x8(%ebp),%edx
 337:	8b 4d 10             	mov    0x10(%ebp),%ecx
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 d7                	mov    %edx,%edi
 33f:	fc                   	cld    
 340:	f3 aa                	rep stos %al,%es:(%edi)
 342:	8b 7d fc             	mov    -0x4(%ebp),%edi
 345:	89 d0                	mov    %edx,%eax
 347:	c9                   	leave  
 348:	c3                   	ret    
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000350 <strchr>:
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 35a:	0f b6 10             	movzbl (%eax),%edx
 35d:	84 d2                	test   %dl,%dl
 35f:	75 12                	jne    373 <strchr+0x23>
 361:	eb 1d                	jmp    380 <strchr+0x30>
 363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 367:	90                   	nop
 368:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 36c:	83 c0 01             	add    $0x1,%eax
 36f:	84 d2                	test   %dl,%dl
 371:	74 0d                	je     380 <strchr+0x30>
 373:	38 d1                	cmp    %dl,%cl
 375:	75 f1                	jne    368 <strchr+0x18>
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 380:	31 c0                	xor    %eax,%eax
 382:	5d                   	pop    %ebp
 383:	c3                   	ret    
 384:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 38f:	90                   	nop

00000390 <gets>:
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	8d 7d e7             	lea    -0x19(%ebp),%edi
 398:	53                   	push   %ebx
 399:	31 db                	xor    %ebx,%ebx
 39b:	83 ec 1c             	sub    $0x1c,%esp
 39e:	eb 27                	jmp    3c7 <gets+0x37>
 3a0:	83 ec 04             	sub    $0x4,%esp
 3a3:	6a 01                	push   $0x1
 3a5:	57                   	push   %edi
 3a6:	6a 00                	push   $0x0
 3a8:	e8 2e 01 00 00       	call   4db <read>
 3ad:	83 c4 10             	add    $0x10,%esp
 3b0:	85 c0                	test   %eax,%eax
 3b2:	7e 1d                	jle    3d1 <gets+0x41>
 3b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b8:	8b 55 08             	mov    0x8(%ebp),%edx
 3bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
 3bf:	3c 0a                	cmp    $0xa,%al
 3c1:	74 1d                	je     3e0 <gets+0x50>
 3c3:	3c 0d                	cmp    $0xd,%al
 3c5:	74 19                	je     3e0 <gets+0x50>
 3c7:	89 de                	mov    %ebx,%esi
 3c9:	83 c3 01             	add    $0x1,%ebx
 3cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3cf:	7c cf                	jl     3a0 <gets+0x10>
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 3d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3db:	5b                   	pop    %ebx
 3dc:	5e                   	pop    %esi
 3dd:	5f                   	pop    %edi
 3de:	5d                   	pop    %ebp
 3df:	c3                   	ret    
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	89 de                	mov    %ebx,%esi
 3e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 3e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ec:	5b                   	pop    %ebx
 3ed:	5e                   	pop    %esi
 3ee:	5f                   	pop    %edi
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <stat>:
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	push   0x8(%ebp)
 40d:	e8 f1 00 00 00       	call   503 <open>
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
 419:	83 ec 08             	sub    $0x8,%esp
 41c:	ff 75 0c             	push   0xc(%ebp)
 41f:	89 c3                	mov    %eax,%ebx
 421:	50                   	push   %eax
 422:	e8 f4 00 00 00       	call   51b <fstat>
 427:	89 1c 24             	mov    %ebx,(%esp)
 42a:	89 c6                	mov    %eax,%esi
 42c:	e8 ba 00 00 00       	call   4eb <close>
 431:	83 c4 10             	add    $0x10,%esp
 434:	8d 65 f8             	lea    -0x8(%ebp),%esp
 437:	89 f0                	mov    %esi,%eax
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44e:	66 90                	xchg   %ax,%ax

00000450 <atoi>:
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 55 08             	mov    0x8(%ebp),%edx
 457:	0f be 02             	movsbl (%edx),%eax
 45a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 45d:	80 f9 09             	cmp    $0x9,%cl
 460:	b9 00 00 00 00       	mov    $0x0,%ecx
 465:	77 1e                	ja     485 <atoi+0x35>
 467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46e:	66 90                	xchg   %ax,%ax
 470:	83 c2 01             	add    $0x1,%edx
 473:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 476:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 47a:	0f be 02             	movsbl (%edx),%eax
 47d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x20>
 485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 488:	89 c8                	mov    %ecx,%eax
 48a:	c9                   	leave  
 48b:	c3                   	ret    
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000490 <memmove>:
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	8b 45 10             	mov    0x10(%ebp),%eax
 497:	8b 55 08             	mov    0x8(%ebp),%edx
 49a:	56                   	push   %esi
 49b:	8b 75 0c             	mov    0xc(%ebp),%esi
 49e:	85 c0                	test   %eax,%eax
 4a0:	7e 13                	jle    4b5 <memmove+0x25>
 4a2:	01 d0                	add    %edx,%eax
 4a4:	89 d7                	mov    %edx,%edi
 4a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
 4b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 4b1:	39 f8                	cmp    %edi,%eax
 4b3:	75 fb                	jne    4b0 <memmove+0x20>
 4b5:	5e                   	pop    %esi
 4b6:	89 d0                	mov    %edx,%eax
 4b8:	5f                   	pop    %edi
 4b9:	5d                   	pop    %ebp
 4ba:	c3                   	ret    

000004bb <fork>:
 4bb:	b8 01 00 00 00       	mov    $0x1,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <exit>:
 4c3:	b8 02 00 00 00       	mov    $0x2,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <wait>:
 4cb:	b8 03 00 00 00       	mov    $0x3,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <pipe>:
 4d3:	b8 04 00 00 00       	mov    $0x4,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <read>:
 4db:	b8 05 00 00 00       	mov    $0x5,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <write>:
 4e3:	b8 10 00 00 00       	mov    $0x10,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <close>:
 4eb:	b8 15 00 00 00       	mov    $0x15,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <kill>:
 4f3:	b8 06 00 00 00       	mov    $0x6,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <exec>:
 4fb:	b8 07 00 00 00       	mov    $0x7,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <open>:
 503:	b8 0f 00 00 00       	mov    $0xf,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <mknod>:
 50b:	b8 11 00 00 00       	mov    $0x11,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <unlink>:
 513:	b8 12 00 00 00       	mov    $0x12,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <fstat>:
 51b:	b8 08 00 00 00       	mov    $0x8,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <link>:
 523:	b8 13 00 00 00       	mov    $0x13,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <mkdir>:
 52b:	b8 14 00 00 00       	mov    $0x14,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <chdir>:
 533:	b8 09 00 00 00       	mov    $0x9,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <dup>:
 53b:	b8 0a 00 00 00       	mov    $0xa,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <getpid>:
 543:	b8 0b 00 00 00       	mov    $0xb,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <sbrk>:
 54b:	b8 0c 00 00 00       	mov    $0xc,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <sleep>:
 553:	b8 0d 00 00 00       	mov    $0xd,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <uptime>:
 55b:	b8 0e 00 00 00       	mov    $0xe,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <settickets>:
 563:	b8 16 00 00 00       	mov    $0x16,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <getpinfo>:
 56b:	b8 17 00 00 00       	mov    $0x17,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <mprotect>:
 573:	b8 18 00 00 00       	mov    $0x18,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <munprotect>:
 57b:	b8 19 00 00 00       	mov    $0x19,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    
 583:	66 90                	xchg   %ax,%ax
 585:	66 90                	xchg   %ax,%ax
 587:	66 90                	xchg   %ax,%ax
 589:	66 90                	xchg   %ax,%ax
 58b:	66 90                	xchg   %ax,%ax
 58d:	66 90                	xchg   %ax,%ax
 58f:	90                   	nop

00000590 <printint>:
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 3c             	sub    $0x3c,%esp
 599:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 59c:	89 d1                	mov    %edx,%ecx
 59e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 5a1:	85 d2                	test   %edx,%edx
 5a3:	0f 89 7f 00 00 00    	jns    628 <printint+0x98>
 5a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5ad:	74 79                	je     628 <printint+0x98>
 5af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 5b6:	f7 d9                	neg    %ecx
 5b8:	31 db                	xor    %ebx,%ebx
 5ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
 5c0:	89 c8                	mov    %ecx,%eax
 5c2:	31 d2                	xor    %edx,%edx
 5c4:	89 cf                	mov    %ecx,%edi
 5c6:	f7 75 c4             	divl   -0x3c(%ebp)
 5c9:	0f b6 92 94 0a 00 00 	movzbl 0xa94(%edx),%edx
 5d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 5d3:	89 d8                	mov    %ebx,%eax
 5d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
 5d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 5db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 5de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5e1:	76 dd                	jbe    5c0 <printint+0x30>
 5e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5e6:	85 c9                	test   %ecx,%ecx
 5e8:	74 0c                	je     5f6 <printint+0x66>
 5ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 5ef:	89 d8                	mov    %ebx,%eax
 5f1:	ba 2d 00 00 00       	mov    $0x2d,%edx
 5f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5fd:	eb 07                	jmp    606 <printint+0x76>
 5ff:	90                   	nop
 600:	0f b6 13             	movzbl (%ebx),%edx
 603:	83 eb 01             	sub    $0x1,%ebx
 606:	83 ec 04             	sub    $0x4,%esp
 609:	88 55 d7             	mov    %dl,-0x29(%ebp)
 60c:	6a 01                	push   $0x1
 60e:	56                   	push   %esi
 60f:	57                   	push   %edi
 610:	e8 ce fe ff ff       	call   4e3 <write>
 615:	83 c4 10             	add    $0x10,%esp
 618:	39 de                	cmp    %ebx,%esi
 61a:	75 e4                	jne    600 <printint+0x70>
 61c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 628:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 62f:	eb 87                	jmp    5b8 <printint+0x28>
 631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop

00000640 <printf>:
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
 649:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 64c:	8b 75 08             	mov    0x8(%ebp),%esi
 64f:	0f b6 13             	movzbl (%ebx),%edx
 652:	84 d2                	test   %dl,%dl
 654:	74 6a                	je     6c0 <printf+0x80>
 656:	8d 45 10             	lea    0x10(%ebp),%eax
 659:	83 c3 01             	add    $0x1,%ebx
 65c:	8d 7d e7             	lea    -0x19(%ebp),%edi
 65f:	31 c9                	xor    %ecx,%ecx
 661:	89 45 d0             	mov    %eax,-0x30(%ebp)
 664:	eb 36                	jmp    69c <printf+0x5c>
 666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66d:	8d 76 00             	lea    0x0(%esi),%esi
 670:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 673:	b9 25 00 00 00       	mov    $0x25,%ecx
 678:	83 f8 25             	cmp    $0x25,%eax
 67b:	74 15                	je     692 <printf+0x52>
 67d:	83 ec 04             	sub    $0x4,%esp
 680:	88 55 e7             	mov    %dl,-0x19(%ebp)
 683:	6a 01                	push   $0x1
 685:	57                   	push   %edi
 686:	56                   	push   %esi
 687:	e8 57 fe ff ff       	call   4e3 <write>
 68c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 68f:	83 c4 10             	add    $0x10,%esp
 692:	0f b6 13             	movzbl (%ebx),%edx
 695:	83 c3 01             	add    $0x1,%ebx
 698:	84 d2                	test   %dl,%dl
 69a:	74 24                	je     6c0 <printf+0x80>
 69c:	0f b6 c2             	movzbl %dl,%eax
 69f:	85 c9                	test   %ecx,%ecx
 6a1:	74 cd                	je     670 <printf+0x30>
 6a3:	83 f9 25             	cmp    $0x25,%ecx
 6a6:	75 ea                	jne    692 <printf+0x52>
 6a8:	83 f8 25             	cmp    $0x25,%eax
 6ab:	0f 84 07 01 00 00    	je     7b8 <printf+0x178>
 6b1:	83 e8 63             	sub    $0x63,%eax
 6b4:	83 f8 15             	cmp    $0x15,%eax
 6b7:	77 17                	ja     6d0 <printf+0x90>
 6b9:	ff 24 85 3c 0a 00 00 	jmp    *0xa3c(,%eax,4)
 6c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c3:	5b                   	pop    %ebx
 6c4:	5e                   	pop    %esi
 6c5:	5f                   	pop    %edi
 6c6:	5d                   	pop    %ebp
 6c7:	c3                   	ret    
 6c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cf:	90                   	nop
 6d0:	83 ec 04             	sub    $0x4,%esp
 6d3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 6d6:	6a 01                	push   $0x1
 6d8:	57                   	push   %edi
 6d9:	56                   	push   %esi
 6da:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6de:	e8 00 fe ff ff       	call   4e3 <write>
 6e3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
 6e7:	83 c4 0c             	add    $0xc,%esp
 6ea:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6ed:	6a 01                	push   $0x1
 6ef:	57                   	push   %edi
 6f0:	56                   	push   %esi
 6f1:	e8 ed fd ff ff       	call   4e3 <write>
 6f6:	83 c4 10             	add    $0x10,%esp
 6f9:	31 c9                	xor    %ecx,%ecx
 6fb:	eb 95                	jmp    692 <printf+0x52>
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	b9 10 00 00 00       	mov    $0x10,%ecx
 708:	6a 00                	push   $0x0
 70a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 70d:	8b 10                	mov    (%eax),%edx
 70f:	89 f0                	mov    %esi,%eax
 711:	e8 7a fe ff ff       	call   590 <printint>
 716:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 71a:	83 c4 10             	add    $0x10,%esp
 71d:	31 c9                	xor    %ecx,%ecx
 71f:	e9 6e ff ff ff       	jmp    692 <printf+0x52>
 724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 728:	8b 45 d0             	mov    -0x30(%ebp),%eax
 72b:	8b 10                	mov    (%eax),%edx
 72d:	83 c0 04             	add    $0x4,%eax
 730:	89 45 d0             	mov    %eax,-0x30(%ebp)
 733:	85 d2                	test   %edx,%edx
 735:	0f 84 8d 00 00 00    	je     7c8 <printf+0x188>
 73b:	0f b6 02             	movzbl (%edx),%eax
 73e:	31 c9                	xor    %ecx,%ecx
 740:	84 c0                	test   %al,%al
 742:	0f 84 4a ff ff ff    	je     692 <printf+0x52>
 748:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 74b:	89 d3                	mov    %edx,%ebx
 74d:	8d 76 00             	lea    0x0(%esi),%esi
 750:	83 ec 04             	sub    $0x4,%esp
 753:	83 c3 01             	add    $0x1,%ebx
 756:	88 45 e7             	mov    %al,-0x19(%ebp)
 759:	6a 01                	push   $0x1
 75b:	57                   	push   %edi
 75c:	56                   	push   %esi
 75d:	e8 81 fd ff ff       	call   4e3 <write>
 762:	0f b6 03             	movzbl (%ebx),%eax
 765:	83 c4 10             	add    $0x10,%esp
 768:	84 c0                	test   %al,%al
 76a:	75 e4                	jne    750 <printf+0x110>
 76c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 76f:	31 c9                	xor    %ecx,%ecx
 771:	e9 1c ff ff ff       	jmp    692 <printf+0x52>
 776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77d:	8d 76 00             	lea    0x0(%esi),%esi
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 0a 00 00 00       	mov    $0xa,%ecx
 788:	6a 01                	push   $0x1
 78a:	e9 7b ff ff ff       	jmp    70a <printf+0xca>
 78f:	90                   	nop
 790:	8b 45 d0             	mov    -0x30(%ebp),%eax
 793:	83 ec 04             	sub    $0x4,%esp
 796:	8b 00                	mov    (%eax),%eax
 798:	6a 01                	push   $0x1
 79a:	57                   	push   %edi
 79b:	56                   	push   %esi
 79c:	88 45 e7             	mov    %al,-0x19(%ebp)
 79f:	e8 3f fd ff ff       	call   4e3 <write>
 7a4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7a8:	83 c4 10             	add    $0x10,%esp
 7ab:	31 c9                	xor    %ecx,%ecx
 7ad:	e9 e0 fe ff ff       	jmp    692 <printf+0x52>
 7b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7b8:	88 55 e7             	mov    %dl,-0x19(%ebp)
 7bb:	83 ec 04             	sub    $0x4,%esp
 7be:	e9 2a ff ff ff       	jmp    6ed <printf+0xad>
 7c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7c7:	90                   	nop
 7c8:	ba 35 0a 00 00       	mov    $0xa35,%edx
 7cd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 7d0:	b8 28 00 00 00       	mov    $0x28,%eax
 7d5:	89 d3                	mov    %edx,%ebx
 7d7:	e9 74 ff ff ff       	jmp    750 <printf+0x110>
 7dc:	66 90                	xchg   %ax,%ax
 7de:	66 90                	xchg   %ax,%ax

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 b4 0d 00 00       	mov    0xdb4,%eax
{
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	57                   	push   %edi
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7f8:	89 c2                	mov    %eax,%edx
 7fa:	8b 00                	mov    (%eax),%eax
 7fc:	39 ca                	cmp    %ecx,%edx
 7fe:	73 30                	jae    830 <free+0x50>
 800:	39 c1                	cmp    %eax,%ecx
 802:	72 04                	jb     808 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	39 c2                	cmp    %eax,%edx
 806:	72 f0                	jb     7f8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 808:	8b 73 fc             	mov    -0x4(%ebx),%esi
 80b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80e:	39 f8                	cmp    %edi,%eax
 810:	74 30                	je     842 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 812:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 815:	8b 42 04             	mov    0x4(%edx),%eax
 818:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 81b:	39 f1                	cmp    %esi,%ecx
 81d:	74 3a                	je     859 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 81f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 821:	5b                   	pop    %ebx
  freep = p;
 822:	89 15 b4 0d 00 00    	mov    %edx,0xdb4
}
 828:	5e                   	pop    %esi
 829:	5f                   	pop    %edi
 82a:	5d                   	pop    %ebp
 82b:	c3                   	ret    
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	39 c2                	cmp    %eax,%edx
 832:	72 c4                	jb     7f8 <free+0x18>
 834:	39 c1                	cmp    %eax,%ecx
 836:	73 c0                	jae    7f8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 838:	8b 73 fc             	mov    -0x4(%ebx),%esi
 83b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83e:	39 f8                	cmp    %edi,%eax
 840:	75 d0                	jne    812 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 842:	03 70 04             	add    0x4(%eax),%esi
 845:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	8b 02                	mov    (%edx),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 84f:	8b 42 04             	mov    0x4(%edx),%eax
 852:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 855:	39 f1                	cmp    %esi,%ecx
 857:	75 c6                	jne    81f <free+0x3f>
    p->s.size += bp->s.size;
 859:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 85c:	89 15 b4 0d 00 00    	mov    %edx,0xdb4
    p->s.size += bp->s.size;
 862:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 865:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 868:	89 0a                	mov    %ecx,(%edx)
}
 86a:	5b                   	pop    %ebx
 86b:	5e                   	pop    %esi
 86c:	5f                   	pop    %edi
 86d:	5d                   	pop    %ebp
 86e:	c3                   	ret    
 86f:	90                   	nop

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 87c:	8b 3d b4 0d 00 00    	mov    0xdb4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	8d 70 07             	lea    0x7(%eax),%esi
 885:	c1 ee 03             	shr    $0x3,%esi
 888:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 88b:	85 ff                	test   %edi,%edi
 88d:	0f 84 9d 00 00 00    	je     930 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 895:	8b 4a 04             	mov    0x4(%edx),%ecx
 898:	39 f1                	cmp    %esi,%ecx
 89a:	73 6a                	jae    906 <malloc+0x96>
 89c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8a1:	39 de                	cmp    %ebx,%esi
 8a3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8a6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8b0:	eb 17                	jmp    8c9 <malloc+0x59>
 8b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ba:	8b 48 04             	mov    0x4(%eax),%ecx
 8bd:	39 f1                	cmp    %esi,%ecx
 8bf:	73 4f                	jae    910 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c1:	8b 3d b4 0d 00 00    	mov    0xdb4,%edi
 8c7:	89 c2                	mov    %eax,%edx
 8c9:	39 d7                	cmp    %edx,%edi
 8cb:	75 eb                	jne    8b8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8cd:	83 ec 0c             	sub    $0xc,%esp
 8d0:	ff 75 e4             	push   -0x1c(%ebp)
 8d3:	e8 73 fc ff ff       	call   54b <sbrk>
  if(p == (char*)-1)
 8d8:	83 c4 10             	add    $0x10,%esp
 8db:	83 f8 ff             	cmp    $0xffffffff,%eax
 8de:	74 1c                	je     8fc <malloc+0x8c>
  hp->s.size = nu;
 8e0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8e3:	83 ec 0c             	sub    $0xc,%esp
 8e6:	83 c0 08             	add    $0x8,%eax
 8e9:	50                   	push   %eax
 8ea:	e8 f1 fe ff ff       	call   7e0 <free>
  return freep;
 8ef:	8b 15 b4 0d 00 00    	mov    0xdb4,%edx
      if((p = morecore(nunits)) == 0)
 8f5:	83 c4 10             	add    $0x10,%esp
 8f8:	85 d2                	test   %edx,%edx
 8fa:	75 bc                	jne    8b8 <malloc+0x48>
        return 0;
  }
}
 8fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8ff:	31 c0                	xor    %eax,%eax
}
 901:	5b                   	pop    %ebx
 902:	5e                   	pop    %esi
 903:	5f                   	pop    %edi
 904:	5d                   	pop    %ebp
 905:	c3                   	ret    
    if(p->s.size >= nunits){
 906:	89 d0                	mov    %edx,%eax
 908:	89 fa                	mov    %edi,%edx
 90a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 910:	39 ce                	cmp    %ecx,%esi
 912:	74 4c                	je     960 <malloc+0xf0>
        p->s.size -= nunits;
 914:	29 f1                	sub    %esi,%ecx
 916:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 919:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 91c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 91f:	89 15 b4 0d 00 00    	mov    %edx,0xdb4
}
 925:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 928:	83 c0 08             	add    $0x8,%eax
}
 92b:	5b                   	pop    %ebx
 92c:	5e                   	pop    %esi
 92d:	5f                   	pop    %edi
 92e:	5d                   	pop    %ebp
 92f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 930:	c7 05 b4 0d 00 00 b8 	movl   $0xdb8,0xdb4
 937:	0d 00 00 
    base.s.size = 0;
 93a:	bf b8 0d 00 00       	mov    $0xdb8,%edi
    base.s.ptr = freep = prevp = &base;
 93f:	c7 05 b8 0d 00 00 b8 	movl   $0xdb8,0xdb8
 946:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 949:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 94b:	c7 05 bc 0d 00 00 00 	movl   $0x0,0xdbc
 952:	00 00 00 
    if(p->s.size >= nunits){
 955:	e9 42 ff ff ff       	jmp    89c <malloc+0x2c>
 95a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 960:	8b 08                	mov    (%eax),%ecx
 962:	89 0a                	mov    %ecx,(%edx)
 964:	eb b9                	jmp    91f <malloc+0xaf>
