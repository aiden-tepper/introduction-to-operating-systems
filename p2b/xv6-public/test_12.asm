
_test_12:     file format elf32-i386


Disassembly of section .text:

00000000 <spin>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "pstat.h"

int spin() {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
  int i = 0;
  int j = 0;
  int k = 0;
   4:	b8 00 00 00 00       	mov    $0x0,%eax
  for (i = 0; i < 5000; ++i) {
   9:	bb 00 00 00 00       	mov    $0x0,%ebx
   e:	eb 2f                	jmp    3f <spin+0x3f>
    for (j = 0; j < 200000; ++j) {
      k = j % 10;
  10:	ba 67 66 66 66       	mov    $0x66666667,%edx
  15:	89 c8                	mov    %ecx,%eax
  17:	f7 ea                	imul   %edx
  19:	c1 fa 02             	sar    $0x2,%edx
  1c:	89 c8                	mov    %ecx,%eax
  1e:	c1 f8 1f             	sar    $0x1f,%eax
  21:	29 c2                	sub    %eax,%edx
  23:	8d 14 92             	lea    (%edx,%edx,4),%edx
  26:	8d 04 12             	lea    (%edx,%edx,1),%eax
  29:	89 ca                	mov    %ecx,%edx
  2b:	29 c2                	sub    %eax,%edx
      k += i + 1;
  2d:	8d 44 13 01          	lea    0x1(%ebx,%edx,1),%eax
    for (j = 0; j < 200000; ++j) {
  31:	83 c1 01             	add    $0x1,%ecx
  34:	81 f9 3f 0d 03 00    	cmp    $0x30d3f,%ecx
  3a:	7e d4                	jle    10 <spin+0x10>
  for (i = 0; i < 5000; ++i) {
  3c:	83 c3 01             	add    $0x1,%ebx
  3f:	81 fb 87 13 00 00    	cmp    $0x1387,%ebx
  45:	7f 07                	jg     4e <spin+0x4e>
    for (j = 0; j < 200000; ++j) {
  47:	b9 00 00 00 00       	mov    $0x0,%ecx
  4c:	eb e6                	jmp    34 <spin+0x34>
    }
  }
  return k;
}
  4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  51:	c9                   	leave  
  52:	c3                   	ret    

00000053 <print>:

void print(struct pstat *st) {
  53:	55                   	push   %ebp
  54:	89 e5                	mov    %esp,%ebp
  56:	56                   	push   %esi
  57:	53                   	push   %ebx
  58:	8b 75 08             	mov    0x8(%ebp),%esi
   int i;
   for(i = 0; i < NPROC; i++) {
  5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  60:	eb 03                	jmp    65 <print+0x12>
  62:	83 c3 01             	add    $0x1,%ebx
  65:	83 fb 3f             	cmp    $0x3f,%ebx
  68:	7f 2f                	jg     99 <print+0x46>
     if (st->inuse[i]) {
  6a:	83 3c 9e 00          	cmpl   $0x0,(%esi,%ebx,4)
  6e:	74 f2                	je     62 <print+0xf>
       printf(1, "pid: %d tickets: %d ticks: %d\n", st->pid[i], st->tickets[i], st->ticks[i]);
  70:	83 ec 0c             	sub    $0xc,%esp
  73:	ff b4 9e 00 03 00 00 	push   0x300(%esi,%ebx,4)
  7a:	ff b4 9e 00 01 00 00 	push   0x100(%esi,%ebx,4)
  81:	ff b4 9e 00 02 00 00 	push   0x200(%esi,%ebx,4)
  88:	68 94 08 00 00       	push   $0x894
  8d:	6a 01                	push   $0x1
  8f:	e8 53 05 00 00       	call   5e7 <printf>
  94:	83 c4 20             	add    $0x20,%esp
  97:	eb c9                	jmp    62 <print+0xf>
     }
   }
}
  99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  9c:	5b                   	pop    %ebx
  9d:	5e                   	pop    %esi
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <compare>:

void compare(int pid_low, int pid_high, struct pstat *before, struct pstat *after) {
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  a6:	83 ec 1c             	sub    $0x1c,%esp
  a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  af:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i, ticks_low_before=-1, ticks_low_after=-1, ticks_high_before=-1, ticks_high_after=-1;
  b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  b9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  c7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  for(i = 0; i < NPROC; i++) {
  ce:	b8 00 00 00 00       	mov    $0x0,%eax
  d3:	eb 27                	jmp    fc <compare+0x5c>
    if (before->pid[i] == pid_low) 
        ticks_low_before = before->ticks[i];
  d5:	8b b4 87 00 03 00 00 	mov    0x300(%edi,%eax,4),%esi
  dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  df:	eb 2b                	jmp    10c <compare+0x6c>
    if (before->pid[i] == pid_high)
        ticks_high_before = before->ticks[i];
  e1:	8b b4 87 00 03 00 00 	mov    0x300(%edi,%eax,4),%esi
  e8:	89 75 dc             	mov    %esi,-0x24(%ebp)
  eb:	eb 23                	jmp    110 <compare+0x70>
    if (after->pid[i] == pid_low)
        ticks_low_after = after->ticks[i];
  ed:	8b b4 86 00 03 00 00 	mov    0x300(%esi,%eax,4),%esi
  f4:	89 75 e0             	mov    %esi,-0x20(%ebp)
  f7:	eb 25                	jmp    11e <compare+0x7e>
  for(i = 0; i < NPROC; i++) {
  f9:	83 c0 01             	add    $0x1,%eax
  fc:	83 f8 3f             	cmp    $0x3f,%eax
  ff:	7f 30                	jg     131 <compare+0x91>
    if (before->pid[i] == pid_low) 
 101:	8b 94 87 00 02 00 00 	mov    0x200(%edi,%eax,4),%edx
 108:	39 da                	cmp    %ebx,%edx
 10a:	74 c9                	je     d5 <compare+0x35>
    if (before->pid[i] == pid_high)
 10c:	39 ca                	cmp    %ecx,%edx
 10e:	74 d1                	je     e1 <compare+0x41>
    if (after->pid[i] == pid_low)
 110:	8b 75 14             	mov    0x14(%ebp),%esi
 113:	8b 94 86 00 02 00 00 	mov    0x200(%esi,%eax,4),%edx
 11a:	39 da                	cmp    %ebx,%edx
 11c:	74 cf                	je     ed <compare+0x4d>
    if (after->pid[i] == pid_high)
 11e:	39 ca                	cmp    %ecx,%edx
 120:	75 d7                	jne    f9 <compare+0x59>
        ticks_high_after = after->ticks[i];
 122:	8b 75 14             	mov    0x14(%ebp),%esi
 125:	8b b4 86 00 03 00 00 	mov    0x300(%esi,%eax,4),%esi
 12c:	89 75 d8             	mov    %esi,-0x28(%ebp)
 12f:	eb c8                	jmp    f9 <compare+0x59>
  }
  printf(1, "high before: %d high after: %d, low before: %d low after: %d\n", 
 131:	83 ec 08             	sub    $0x8,%esp
 134:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 137:	53                   	push   %ebx
 138:	ff 75 e4             	push   -0x1c(%ebp)
 13b:	8b 7d d8             	mov    -0x28(%ebp),%edi
 13e:	57                   	push   %edi
 13f:	8b 75 dc             	mov    -0x24(%ebp),%esi
 142:	56                   	push   %esi
 143:	68 b4 08 00 00       	push   $0x8b4
 148:	6a 01                	push   $0x1
 14a:	e8 98 04 00 00       	call   5e7 <printf>
                     ticks_high_before, ticks_high_after, ticks_low_before, ticks_low_after);
  
  if ( (ticks_high_after-ticks_high_before) > (ticks_low_after - ticks_low_before)) {
 14f:	29 f7                	sub    %esi,%edi
 151:	89 d8                	mov    %ebx,%eax
 153:	2b 45 e4             	sub    -0x1c(%ebp),%eax
 156:	83 c4 20             	add    $0x20,%esp
 159:	39 c7                	cmp    %eax,%edi
 15b:	7e 17                	jle    174 <compare+0xd4>
    printf(1, "XV6_SCHEDULER\t SUCCESS\n"); 
 15d:	83 ec 08             	sub    $0x8,%esp
 160:	68 f2 08 00 00       	push   $0x8f2
 165:	6a 01                	push   $0x1
 167:	e8 7b 04 00 00       	call   5e7 <printf>
  } else {
    printf(1, "XV6_SCHEDULER\t FAILED\n"); 
    exit();
  }
}
 16c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16f:	5b                   	pop    %ebx
 170:	5e                   	pop    %esi
 171:	5f                   	pop    %edi
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
    printf(1, "XV6_SCHEDULER\t FAILED\n"); 
 174:	83 ec 08             	sub    $0x8,%esp
 177:	68 0a 09 00 00       	push   $0x90a
 17c:	6a 01                	push   $0x1
 17e:	e8 64 04 00 00       	call   5e7 <printf>
    exit();
 183:	e8 fa 02 00 00       	call   482 <exit>

00000188 <main>:

int
main(int argc, char *argv[])
{
 188:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 18c:	83 e4 f0             	and    $0xfffffff0,%esp
 18f:	ff 71 fc             	push   -0x4(%ecx)
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	57                   	push   %edi
 196:	56                   	push   %esi
 197:	53                   	push   %ebx
 198:	51                   	push   %ecx
 199:	81 ec 08 08 00 00    	sub    $0x808,%esp
  int pid_low = getpid();
 19f:	e8 5e 03 00 00       	call   502 <getpid>
 1a4:	89 c3                	mov    %eax,%ebx
  int lowtickets = 0, hightickets = 1;

  if (settickets(lowtickets) != 0) {
 1a6:	83 ec 0c             	sub    $0xc,%esp
 1a9:	6a 00                	push   $0x0
 1ab:	e8 72 03 00 00       	call   522 <settickets>
 1b0:	83 c4 10             	add    $0x10,%esp
 1b3:	85 c0                	test   %eax,%eax
 1b5:	74 14                	je     1cb <main+0x43>
    printf(1, "XV6_SCHEDULER\t FAILED\n"); 
 1b7:	83 ec 08             	sub    $0x8,%esp
 1ba:	68 0a 09 00 00       	push   $0x90a
 1bf:	6a 01                	push   $0x1
 1c1:	e8 21 04 00 00       	call   5e7 <printf>
    exit();
 1c6:	e8 b7 02 00 00       	call   482 <exit>
  }

  if (fork() == 0) {  	
 1cb:	e8 aa 02 00 00       	call   47a <fork>
 1d0:	85 c0                	test   %eax,%eax
 1d2:	0f 85 e5 00 00 00    	jne    2bd <main+0x135>
    if (settickets(hightickets) != 0) {
 1d8:	83 ec 0c             	sub    $0xc,%esp
 1db:	6a 01                	push   $0x1
 1dd:	e8 40 03 00 00       	call   522 <settickets>
 1e2:	83 c4 10             	add    $0x10,%esp
 1e5:	85 c0                	test   %eax,%eax
 1e7:	74 14                	je     1fd <main+0x75>
      printf(1, "XV6_SCHEDULER\t FAILED\n"); 
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	68 0a 09 00 00       	push   $0x90a
 1f1:	6a 01                	push   $0x1
 1f3:	e8 ef 03 00 00       	call   5e7 <printf>
      exit();
 1f8:	e8 85 02 00 00       	call   482 <exit>
    }
    
    int pid_high = getpid();
 1fd:	e8 00 03 00 00       	call   502 <getpid>
 202:	89 c6                	mov    %eax,%esi
    struct pstat st_before, st_after;
        
    if (getpinfo(&st_before) != 0) {
 204:	83 ec 0c             	sub    $0xc,%esp
 207:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
 20d:	50                   	push   %eax
 20e:	e8 17 03 00 00       	call   52a <getpinfo>
 213:	83 c4 10             	add    $0x10,%esp
 216:	85 c0                	test   %eax,%eax
 218:	74 14                	je     22e <main+0xa6>
      printf(1, "XV6_SCHEDULER\t FAILED\n"); 
 21a:	83 ec 08             	sub    $0x8,%esp
 21d:	68 0a 09 00 00       	push   $0x90a
 222:	6a 01                	push   $0x1
 224:	e8 be 03 00 00       	call   5e7 <printf>
      exit();
 229:	e8 54 02 00 00       	call   482 <exit>
    }
        
    printf(1, "\n ****PInfo before**** \n");
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	68 21 09 00 00       	push   $0x921
 236:	6a 01                	push   $0x1
 238:	e8 aa 03 00 00       	call   5e7 <printf>
    print(&st_before);
 23d:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
 243:	89 04 24             	mov    %eax,(%esp)
 246:	e8 08 fe ff ff       	call   53 <print>
    printf(1,"Spinning...%d\n", spin());
 24b:	e8 b0 fd ff ff       	call   0 <spin>
 250:	83 c4 0c             	add    $0xc,%esp
 253:	50                   	push   %eax
 254:	68 3a 09 00 00       	push   $0x93a
 259:	6a 01                	push   $0x1
 25b:	e8 87 03 00 00       	call   5e7 <printf>

        
    if (getpinfo(&st_after) != 0) {
 260:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 266:	89 04 24             	mov    %eax,(%esp)
 269:	e8 bc 02 00 00       	call   52a <getpinfo>
 26e:	83 c4 10             	add    $0x10,%esp
 271:	85 c0                	test   %eax,%eax
 273:	74 14                	je     289 <main+0x101>
      printf(1, "XV6_SCHEDULER\t FAILED\n"); 
 275:	83 ec 08             	sub    $0x8,%esp
 278:	68 0a 09 00 00       	push   $0x90a
 27d:	6a 01                	push   $0x1
 27f:	e8 63 03 00 00       	call   5e7 <printf>
      exit();
 284:	e8 f9 01 00 00       	call   482 <exit>
    }
        
    printf(1, "\n ****PInfo after**** \n");
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	68 49 09 00 00       	push   $0x949
 291:	6a 01                	push   $0x1
 293:	e8 4f 03 00 00       	call   5e7 <printf>
    print(&st_after);
 298:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
 29e:	89 3c 24             	mov    %edi,(%esp)
 2a1:	e8 ad fd ff ff       	call   53 <print>
	
    compare(pid_low, pid_high, &st_before, &st_after);
 2a6:	57                   	push   %edi
 2a7:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
 2ad:	50                   	push   %eax
 2ae:	56                   	push   %esi
 2af:	53                   	push   %ebx
 2b0:	e8 eb fd ff ff       	call   a0 <compare>
         
    exit();
 2b5:	83 c4 20             	add    $0x20,%esp
 2b8:	e8 c5 01 00 00       	call   482 <exit>
  }
  printf(1,"Spinning...%d\n", spin());
 2bd:	e8 3e fd ff ff       	call   0 <spin>
 2c2:	83 ec 04             	sub    $0x4,%esp
 2c5:	50                   	push   %eax
 2c6:	68 3a 09 00 00       	push   $0x93a
 2cb:	6a 01                	push   $0x1
 2cd:	e8 15 03 00 00       	call   5e7 <printf>

  while (wait() > -1);
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	e8 b0 01 00 00       	call   48a <wait>
 2da:	85 c0                	test   %eax,%eax
 2dc:	79 f7                	jns    2d5 <main+0x14d>
  exit();
 2de:	e8 9f 01 00 00       	call   482 <exit>

000002e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2e3:	55                   	push   %ebp
 2e4:	89 e5                	mov    %esp,%ebp
 2e6:	56                   	push   %esi
 2e7:	53                   	push   %ebx
 2e8:	8b 75 08             	mov    0x8(%ebp),%esi
 2eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ee:	89 f0                	mov    %esi,%eax
 2f0:	89 d1                	mov    %edx,%ecx
 2f2:	83 c2 01             	add    $0x1,%edx
 2f5:	89 c3                	mov    %eax,%ebx
 2f7:	83 c0 01             	add    $0x1,%eax
 2fa:	0f b6 09             	movzbl (%ecx),%ecx
 2fd:	88 0b                	mov    %cl,(%ebx)
 2ff:	84 c9                	test   %cl,%cl
 301:	75 ed                	jne    2f0 <strcpy+0xd>
    ;
  return os;
}
 303:	89 f0                	mov    %esi,%eax
 305:	5b                   	pop    %ebx
 306:	5e                   	pop    %esi
 307:	5d                   	pop    %ebp
 308:	c3                   	ret    

00000309 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 30f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 312:	eb 06                	jmp    31a <strcmp+0x11>
    p++, q++;
 314:	83 c1 01             	add    $0x1,%ecx
 317:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 31a:	0f b6 01             	movzbl (%ecx),%eax
 31d:	84 c0                	test   %al,%al
 31f:	74 04                	je     325 <strcmp+0x1c>
 321:	3a 02                	cmp    (%edx),%al
 323:	74 ef                	je     314 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 325:	0f b6 c0             	movzbl %al,%eax
 328:	0f b6 12             	movzbl (%edx),%edx
 32b:	29 d0                	sub    %edx,%eax
}
 32d:	5d                   	pop    %ebp
 32e:	c3                   	ret    

0000032f <strlen>:

uint
strlen(const char *s)
{
 32f:	55                   	push   %ebp
 330:	89 e5                	mov    %esp,%ebp
 332:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 335:	b8 00 00 00 00       	mov    $0x0,%eax
 33a:	eb 03                	jmp    33f <strlen+0x10>
 33c:	83 c0 01             	add    $0x1,%eax
 33f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 343:	75 f7                	jne    33c <strlen+0xd>
    ;
  return n;
}
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    

00000347 <memset>:

void*
memset(void *dst, int c, uint n)
{
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp
 34a:	57                   	push   %edi
 34b:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 34e:	89 d7                	mov    %edx,%edi
 350:	8b 4d 10             	mov    0x10(%ebp),%ecx
 353:	8b 45 0c             	mov    0xc(%ebp),%eax
 356:	fc                   	cld    
 357:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 359:	89 d0                	mov    %edx,%eax
 35b:	8b 7d fc             	mov    -0x4(%ebp),%edi
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <strchr>:

char*
strchr(const char *s, char c)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 36a:	eb 03                	jmp    36f <strchr+0xf>
 36c:	83 c0 01             	add    $0x1,%eax
 36f:	0f b6 10             	movzbl (%eax),%edx
 372:	84 d2                	test   %dl,%dl
 374:	74 06                	je     37c <strchr+0x1c>
    if(*s == c)
 376:	38 ca                	cmp    %cl,%dl
 378:	75 f2                	jne    36c <strchr+0xc>
 37a:	eb 05                	jmp    381 <strchr+0x21>
      return (char*)s;
  return 0;
 37c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 381:	5d                   	pop    %ebp
 382:	c3                   	ret    

00000383 <gets>:

char*
gets(char *buf, int max)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	57                   	push   %edi
 387:	56                   	push   %esi
 388:	53                   	push   %ebx
 389:	83 ec 1c             	sub    $0x1c,%esp
 38c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 38f:	bb 00 00 00 00       	mov    $0x0,%ebx
 394:	89 de                	mov    %ebx,%esi
 396:	83 c3 01             	add    $0x1,%ebx
 399:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 39c:	7d 2e                	jge    3cc <gets+0x49>
    cc = read(0, &c, 1);
 39e:	83 ec 04             	sub    $0x4,%esp
 3a1:	6a 01                	push   $0x1
 3a3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3a6:	50                   	push   %eax
 3a7:	6a 00                	push   $0x0
 3a9:	e8 ec 00 00 00       	call   49a <read>
    if(cc < 1)
 3ae:	83 c4 10             	add    $0x10,%esp
 3b1:	85 c0                	test   %eax,%eax
 3b3:	7e 17                	jle    3cc <gets+0x49>
      break;
    buf[i++] = c;
 3b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b9:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 3bc:	3c 0a                	cmp    $0xa,%al
 3be:	0f 94 c2             	sete   %dl
 3c1:	3c 0d                	cmp    $0xd,%al
 3c3:	0f 94 c0             	sete   %al
 3c6:	08 c2                	or     %al,%dl
 3c8:	74 ca                	je     394 <gets+0x11>
    buf[i++] = c;
 3ca:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3cc:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3d0:	89 f8                	mov    %edi,%eax
 3d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d5:	5b                   	pop    %ebx
 3d6:	5e                   	pop    %esi
 3d7:	5f                   	pop    %edi
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    

000003da <stat>:

int
stat(const char *n, struct stat *st)
{
 3da:	55                   	push   %ebp
 3db:	89 e5                	mov    %esp,%ebp
 3dd:	56                   	push   %esi
 3de:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3df:	83 ec 08             	sub    $0x8,%esp
 3e2:	6a 00                	push   $0x0
 3e4:	ff 75 08             	push   0x8(%ebp)
 3e7:	e8 d6 00 00 00       	call   4c2 <open>
  if(fd < 0)
 3ec:	83 c4 10             	add    $0x10,%esp
 3ef:	85 c0                	test   %eax,%eax
 3f1:	78 24                	js     417 <stat+0x3d>
 3f3:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3f5:	83 ec 08             	sub    $0x8,%esp
 3f8:	ff 75 0c             	push   0xc(%ebp)
 3fb:	50                   	push   %eax
 3fc:	e8 d9 00 00 00       	call   4da <fstat>
 401:	89 c6                	mov    %eax,%esi
  close(fd);
 403:	89 1c 24             	mov    %ebx,(%esp)
 406:	e8 9f 00 00 00       	call   4aa <close>
  return r;
 40b:	83 c4 10             	add    $0x10,%esp
}
 40e:	89 f0                	mov    %esi,%eax
 410:	8d 65 f8             	lea    -0x8(%ebp),%esp
 413:	5b                   	pop    %ebx
 414:	5e                   	pop    %esi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
    return -1;
 417:	be ff ff ff ff       	mov    $0xffffffff,%esi
 41c:	eb f0                	jmp    40e <stat+0x34>

0000041e <atoi>:

int
atoi(const char *s)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	53                   	push   %ebx
 422:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 425:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 42a:	eb 10                	jmp    43c <atoi+0x1e>
    n = n*10 + *s++ - '0';
 42c:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 42f:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 432:	83 c1 01             	add    $0x1,%ecx
 435:	0f be c0             	movsbl %al,%eax
 438:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 43c:	0f b6 01             	movzbl (%ecx),%eax
 43f:	8d 58 d0             	lea    -0x30(%eax),%ebx
 442:	80 fb 09             	cmp    $0x9,%bl
 445:	76 e5                	jbe    42c <atoi+0xe>
  return n;
}
 447:	89 d0                	mov    %edx,%eax
 449:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 44c:	c9                   	leave  
 44d:	c3                   	ret    

0000044e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	56                   	push   %esi
 452:	53                   	push   %ebx
 453:	8b 75 08             	mov    0x8(%ebp),%esi
 456:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 459:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 45c:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 45e:	eb 0d                	jmp    46d <memmove+0x1f>
    *dst++ = *src++;
 460:	0f b6 01             	movzbl (%ecx),%eax
 463:	88 02                	mov    %al,(%edx)
 465:	8d 49 01             	lea    0x1(%ecx),%ecx
 468:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 46b:	89 d8                	mov    %ebx,%eax
 46d:	8d 58 ff             	lea    -0x1(%eax),%ebx
 470:	85 c0                	test   %eax,%eax
 472:	7f ec                	jg     460 <memmove+0x12>
  return vdst;
}
 474:	89 f0                	mov    %esi,%eax
 476:	5b                   	pop    %ebx
 477:	5e                   	pop    %esi
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    

0000047a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 47a:	b8 01 00 00 00       	mov    $0x1,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <exit>:
SYSCALL(exit)
 482:	b8 02 00 00 00       	mov    $0x2,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <wait>:
SYSCALL(wait)
 48a:	b8 03 00 00 00       	mov    $0x3,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <pipe>:
SYSCALL(pipe)
 492:	b8 04 00 00 00       	mov    $0x4,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <read>:
SYSCALL(read)
 49a:	b8 05 00 00 00       	mov    $0x5,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <write>:
SYSCALL(write)
 4a2:	b8 10 00 00 00       	mov    $0x10,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <close>:
SYSCALL(close)
 4aa:	b8 15 00 00 00       	mov    $0x15,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <kill>:
SYSCALL(kill)
 4b2:	b8 06 00 00 00       	mov    $0x6,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <exec>:
SYSCALL(exec)
 4ba:	b8 07 00 00 00       	mov    $0x7,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <open>:
SYSCALL(open)
 4c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <mknod>:
SYSCALL(mknod)
 4ca:	b8 11 00 00 00       	mov    $0x11,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <unlink>:
SYSCALL(unlink)
 4d2:	b8 12 00 00 00       	mov    $0x12,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <fstat>:
SYSCALL(fstat)
 4da:	b8 08 00 00 00       	mov    $0x8,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <link>:
SYSCALL(link)
 4e2:	b8 13 00 00 00       	mov    $0x13,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <mkdir>:
SYSCALL(mkdir)
 4ea:	b8 14 00 00 00       	mov    $0x14,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <chdir>:
SYSCALL(chdir)
 4f2:	b8 09 00 00 00       	mov    $0x9,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <dup>:
SYSCALL(dup)
 4fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <getpid>:
SYSCALL(getpid)
 502:	b8 0b 00 00 00       	mov    $0xb,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <sbrk>:
SYSCALL(sbrk)
 50a:	b8 0c 00 00 00       	mov    $0xc,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <sleep>:
SYSCALL(sleep)
 512:	b8 0d 00 00 00       	mov    $0xd,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <uptime>:
SYSCALL(uptime)
 51a:	b8 0e 00 00 00       	mov    $0xe,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <settickets>:
SYSCALL(settickets)
 522:	b8 16 00 00 00       	mov    $0x16,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <getpinfo>:
SYSCALL(getpinfo)
 52a:	b8 17 00 00 00       	mov    $0x17,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <mprotect>:
SYSCALL(mprotect)
 532:	b8 18 00 00 00       	mov    $0x18,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <munprotect>:
SYSCALL(munprotect)
 53a:	b8 19 00 00 00       	mov    $0x19,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 542:	55                   	push   %ebp
 543:	89 e5                	mov    %esp,%ebp
 545:	83 ec 1c             	sub    $0x1c,%esp
 548:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 54b:	6a 01                	push   $0x1
 54d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 550:	52                   	push   %edx
 551:	50                   	push   %eax
 552:	e8 4b ff ff ff       	call   4a2 <write>
}
 557:	83 c4 10             	add    $0x10,%esp
 55a:	c9                   	leave  
 55b:	c3                   	ret    

0000055c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	57                   	push   %edi
 560:	56                   	push   %esi
 561:	53                   	push   %ebx
 562:	83 ec 2c             	sub    $0x2c,%esp
 565:	89 45 d0             	mov    %eax,-0x30(%ebp)
 568:	89 d0                	mov    %edx,%eax
 56a:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 56c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 570:	0f 95 c1             	setne  %cl
 573:	c1 ea 1f             	shr    $0x1f,%edx
 576:	84 d1                	test   %dl,%cl
 578:	74 44                	je     5be <printint+0x62>
    neg = 1;
    x = -xx;
 57a:	f7 d8                	neg    %eax
 57c:	89 c1                	mov    %eax,%ecx
    neg = 1;
 57e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 585:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 58a:	89 c8                	mov    %ecx,%eax
 58c:	ba 00 00 00 00       	mov    $0x0,%edx
 591:	f7 f6                	div    %esi
 593:	89 df                	mov    %ebx,%edi
 595:	83 c3 01             	add    $0x1,%ebx
 598:	0f b6 92 c0 09 00 00 	movzbl 0x9c0(%edx),%edx
 59f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 5a3:	89 ca                	mov    %ecx,%edx
 5a5:	89 c1                	mov    %eax,%ecx
 5a7:	39 d6                	cmp    %edx,%esi
 5a9:	76 df                	jbe    58a <printint+0x2e>
  if(neg)
 5ab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 5af:	74 31                	je     5e2 <printint+0x86>
    buf[i++] = '-';
 5b1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 5b6:	8d 5f 02             	lea    0x2(%edi),%ebx
 5b9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5bc:	eb 17                	jmp    5d5 <printint+0x79>
    x = xx;
 5be:	89 c1                	mov    %eax,%ecx
  neg = 0;
 5c0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 5c7:	eb bc                	jmp    585 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 5c9:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 5ce:	89 f0                	mov    %esi,%eax
 5d0:	e8 6d ff ff ff       	call   542 <putc>
  while(--i >= 0)
 5d5:	83 eb 01             	sub    $0x1,%ebx
 5d8:	79 ef                	jns    5c9 <printint+0x6d>
}
 5da:	83 c4 2c             	add    $0x2c,%esp
 5dd:	5b                   	pop    %ebx
 5de:	5e                   	pop    %esi
 5df:	5f                   	pop    %edi
 5e0:	5d                   	pop    %ebp
 5e1:	c3                   	ret    
 5e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5e5:	eb ee                	jmp    5d5 <printint+0x79>

000005e7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e7:	55                   	push   %ebp
 5e8:	89 e5                	mov    %esp,%ebp
 5ea:	57                   	push   %edi
 5eb:	56                   	push   %esi
 5ec:	53                   	push   %ebx
 5ed:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5f0:	8d 45 10             	lea    0x10(%ebp),%eax
 5f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5f6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5fb:	bb 00 00 00 00       	mov    $0x0,%ebx
 600:	eb 14                	jmp    616 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 602:	89 fa                	mov    %edi,%edx
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	e8 36 ff ff ff       	call   542 <putc>
 60c:	eb 05                	jmp    613 <printf+0x2c>
      }
    } else if(state == '%'){
 60e:	83 fe 25             	cmp    $0x25,%esi
 611:	74 25                	je     638 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 613:	83 c3 01             	add    $0x1,%ebx
 616:	8b 45 0c             	mov    0xc(%ebp),%eax
 619:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 61d:	84 c0                	test   %al,%al
 61f:	0f 84 20 01 00 00    	je     745 <printf+0x15e>
    c = fmt[i] & 0xff;
 625:	0f be f8             	movsbl %al,%edi
 628:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 62b:	85 f6                	test   %esi,%esi
 62d:	75 df                	jne    60e <printf+0x27>
      if(c == '%'){
 62f:	83 f8 25             	cmp    $0x25,%eax
 632:	75 ce                	jne    602 <printf+0x1b>
        state = '%';
 634:	89 c6                	mov    %eax,%esi
 636:	eb db                	jmp    613 <printf+0x2c>
      if(c == 'd'){
 638:	83 f8 25             	cmp    $0x25,%eax
 63b:	0f 84 cf 00 00 00    	je     710 <printf+0x129>
 641:	0f 8c dd 00 00 00    	jl     724 <printf+0x13d>
 647:	83 f8 78             	cmp    $0x78,%eax
 64a:	0f 8f d4 00 00 00    	jg     724 <printf+0x13d>
 650:	83 f8 63             	cmp    $0x63,%eax
 653:	0f 8c cb 00 00 00    	jl     724 <printf+0x13d>
 659:	83 e8 63             	sub    $0x63,%eax
 65c:	83 f8 15             	cmp    $0x15,%eax
 65f:	0f 87 bf 00 00 00    	ja     724 <printf+0x13d>
 665:	ff 24 85 68 09 00 00 	jmp    *0x968(,%eax,4)
        printint(fd, *ap, 10, 1);
 66c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 66f:	8b 17                	mov    (%edi),%edx
 671:	83 ec 0c             	sub    $0xc,%esp
 674:	6a 01                	push   $0x1
 676:	b9 0a 00 00 00       	mov    $0xa,%ecx
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	e8 d9 fe ff ff       	call   55c <printint>
        ap++;
 683:	83 c7 04             	add    $0x4,%edi
 686:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 689:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 68c:	be 00 00 00 00       	mov    $0x0,%esi
 691:	eb 80                	jmp    613 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 693:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 696:	8b 17                	mov    (%edi),%edx
 698:	83 ec 0c             	sub    $0xc,%esp
 69b:	6a 00                	push   $0x0
 69d:	b9 10 00 00 00       	mov    $0x10,%ecx
 6a2:	8b 45 08             	mov    0x8(%ebp),%eax
 6a5:	e8 b2 fe ff ff       	call   55c <printint>
        ap++;
 6aa:	83 c7 04             	add    $0x4,%edi
 6ad:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6b0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6b3:	be 00 00 00 00       	mov    $0x0,%esi
 6b8:	e9 56 ff ff ff       	jmp    613 <printf+0x2c>
        s = (char*)*ap;
 6bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c0:	8b 30                	mov    (%eax),%esi
        ap++;
 6c2:	83 c0 04             	add    $0x4,%eax
 6c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 6c8:	85 f6                	test   %esi,%esi
 6ca:	75 15                	jne    6e1 <printf+0xfa>
          s = "(null)";
 6cc:	be 61 09 00 00       	mov    $0x961,%esi
 6d1:	eb 0e                	jmp    6e1 <printf+0xfa>
          putc(fd, *s);
 6d3:	0f be d2             	movsbl %dl,%edx
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	e8 64 fe ff ff       	call   542 <putc>
          s++;
 6de:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 6e1:	0f b6 16             	movzbl (%esi),%edx
 6e4:	84 d2                	test   %dl,%dl
 6e6:	75 eb                	jne    6d3 <printf+0xec>
      state = 0;
 6e8:	be 00 00 00 00       	mov    $0x0,%esi
 6ed:	e9 21 ff ff ff       	jmp    613 <printf+0x2c>
        putc(fd, *ap);
 6f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6f5:	0f be 17             	movsbl (%edi),%edx
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	e8 42 fe ff ff       	call   542 <putc>
        ap++;
 700:	83 c7 04             	add    $0x4,%edi
 703:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 706:	be 00 00 00 00       	mov    $0x0,%esi
 70b:	e9 03 ff ff ff       	jmp    613 <printf+0x2c>
        putc(fd, c);
 710:	89 fa                	mov    %edi,%edx
 712:	8b 45 08             	mov    0x8(%ebp),%eax
 715:	e8 28 fe ff ff       	call   542 <putc>
      state = 0;
 71a:	be 00 00 00 00       	mov    $0x0,%esi
 71f:	e9 ef fe ff ff       	jmp    613 <printf+0x2c>
        putc(fd, '%');
 724:	ba 25 00 00 00       	mov    $0x25,%edx
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	e8 11 fe ff ff       	call   542 <putc>
        putc(fd, c);
 731:	89 fa                	mov    %edi,%edx
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	e8 07 fe ff ff       	call   542 <putc>
      state = 0;
 73b:	be 00 00 00 00       	mov    $0x0,%esi
 740:	e9 ce fe ff ff       	jmp    613 <printf+0x2c>
    }
  }
}
 745:	8d 65 f4             	lea    -0xc(%ebp),%esp
 748:	5b                   	pop    %ebx
 749:	5e                   	pop    %esi
 74a:	5f                   	pop    %edi
 74b:	5d                   	pop    %ebp
 74c:	c3                   	ret    

0000074d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	57                   	push   %edi
 751:	56                   	push   %esi
 752:	53                   	push   %ebx
 753:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 756:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 759:	a1 e8 0c 00 00       	mov    0xce8,%eax
 75e:	eb 02                	jmp    762 <free+0x15>
 760:	89 d0                	mov    %edx,%eax
 762:	39 c8                	cmp    %ecx,%eax
 764:	73 04                	jae    76a <free+0x1d>
 766:	39 08                	cmp    %ecx,(%eax)
 768:	77 12                	ja     77c <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	8b 10                	mov    (%eax),%edx
 76c:	39 c2                	cmp    %eax,%edx
 76e:	77 f0                	ja     760 <free+0x13>
 770:	39 c8                	cmp    %ecx,%eax
 772:	72 08                	jb     77c <free+0x2f>
 774:	39 ca                	cmp    %ecx,%edx
 776:	77 04                	ja     77c <free+0x2f>
 778:	89 d0                	mov    %edx,%eax
 77a:	eb e6                	jmp    762 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 77c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 77f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 782:	8b 10                	mov    (%eax),%edx
 784:	39 d7                	cmp    %edx,%edi
 786:	74 19                	je     7a1 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 788:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 78b:	8b 50 04             	mov    0x4(%eax),%edx
 78e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 791:	39 ce                	cmp    %ecx,%esi
 793:	74 1b                	je     7b0 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 795:	89 08                	mov    %ecx,(%eax)
  freep = p;
 797:	a3 e8 0c 00 00       	mov    %eax,0xce8
}
 79c:	5b                   	pop    %ebx
 79d:	5e                   	pop    %esi
 79e:	5f                   	pop    %edi
 79f:	5d                   	pop    %ebp
 7a0:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 7a1:	03 72 04             	add    0x4(%edx),%esi
 7a4:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a7:	8b 10                	mov    (%eax),%edx
 7a9:	8b 12                	mov    (%edx),%edx
 7ab:	89 53 f8             	mov    %edx,-0x8(%ebx)
 7ae:	eb db                	jmp    78b <free+0x3e>
    p->s.size += bp->s.size;
 7b0:	03 53 fc             	add    -0x4(%ebx),%edx
 7b3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7b9:	89 10                	mov    %edx,(%eax)
 7bb:	eb da                	jmp    797 <free+0x4a>

000007bd <morecore>:

static Header*
morecore(uint nu)
{
 7bd:	55                   	push   %ebp
 7be:	89 e5                	mov    %esp,%ebp
 7c0:	53                   	push   %ebx
 7c1:	83 ec 04             	sub    $0x4,%esp
 7c4:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 7c6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 7cb:	77 05                	ja     7d2 <morecore+0x15>
    nu = 4096;
 7cd:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 7d2:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7d9:	83 ec 0c             	sub    $0xc,%esp
 7dc:	50                   	push   %eax
 7dd:	e8 28 fd ff ff       	call   50a <sbrk>
  if(p == (char*)-1)
 7e2:	83 c4 10             	add    $0x10,%esp
 7e5:	83 f8 ff             	cmp    $0xffffffff,%eax
 7e8:	74 1c                	je     806 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7ea:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7ed:	83 c0 08             	add    $0x8,%eax
 7f0:	83 ec 0c             	sub    $0xc,%esp
 7f3:	50                   	push   %eax
 7f4:	e8 54 ff ff ff       	call   74d <free>
  return freep;
 7f9:	a1 e8 0c 00 00       	mov    0xce8,%eax
 7fe:	83 c4 10             	add    $0x10,%esp
}
 801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 804:	c9                   	leave  
 805:	c3                   	ret    
    return 0;
 806:	b8 00 00 00 00       	mov    $0x0,%eax
 80b:	eb f4                	jmp    801 <morecore+0x44>

0000080d <malloc>:

void*
malloc(uint nbytes)
{
 80d:	55                   	push   %ebp
 80e:	89 e5                	mov    %esp,%ebp
 810:	53                   	push   %ebx
 811:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	8d 58 07             	lea    0x7(%eax),%ebx
 81a:	c1 eb 03             	shr    $0x3,%ebx
 81d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 820:	8b 0d e8 0c 00 00    	mov    0xce8,%ecx
 826:	85 c9                	test   %ecx,%ecx
 828:	74 04                	je     82e <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	8b 01                	mov    (%ecx),%eax
 82c:	eb 4a                	jmp    878 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 82e:	c7 05 e8 0c 00 00 ec 	movl   $0xcec,0xce8
 835:	0c 00 00 
 838:	c7 05 ec 0c 00 00 ec 	movl   $0xcec,0xcec
 83f:	0c 00 00 
    base.s.size = 0;
 842:	c7 05 f0 0c 00 00 00 	movl   $0x0,0xcf0
 849:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 84c:	b9 ec 0c 00 00       	mov    $0xcec,%ecx
 851:	eb d7                	jmp    82a <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 853:	74 19                	je     86e <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 855:	29 da                	sub    %ebx,%edx
 857:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 85a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 85d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 860:	89 0d e8 0c 00 00    	mov    %ecx,0xce8
      return (void*)(p + 1);
 866:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 869:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 86c:	c9                   	leave  
 86d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 86e:	8b 10                	mov    (%eax),%edx
 870:	89 11                	mov    %edx,(%ecx)
 872:	eb ec                	jmp    860 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 874:	89 c1                	mov    %eax,%ecx
 876:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 878:	8b 50 04             	mov    0x4(%eax),%edx
 87b:	39 da                	cmp    %ebx,%edx
 87d:	73 d4                	jae    853 <malloc+0x46>
    if(p == freep)
 87f:	39 05 e8 0c 00 00    	cmp    %eax,0xce8
 885:	75 ed                	jne    874 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 887:	89 d8                	mov    %ebx,%eax
 889:	e8 2f ff ff ff       	call   7bd <morecore>
 88e:	85 c0                	test   %eax,%eax
 890:	75 e2                	jne    874 <malloc+0x67>
 892:	eb d5                	jmp    869 <malloc+0x5c>
