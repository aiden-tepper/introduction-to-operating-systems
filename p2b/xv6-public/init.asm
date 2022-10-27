
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 90 06 00 00       	push   $0x690
  19:	e8 9e 02 00 00       	call   2bc <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	78 1b                	js     40 <main+0x40>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	6a 00                	push   $0x0
  2a:	e8 c5 02 00 00       	call   2f4 <dup>
  dup(0);  // stderr
  2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  36:	e8 b9 02 00 00       	call   2f4 <dup>
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	eb 58                	jmp    98 <main+0x98>
    mknod("console", 1, 1);
  40:	83 ec 04             	sub    $0x4,%esp
  43:	6a 01                	push   $0x1
  45:	6a 01                	push   $0x1
  47:	68 90 06 00 00       	push   $0x690
  4c:	e8 73 02 00 00       	call   2c4 <mknod>
    open("console", O_RDWR);
  51:	83 c4 08             	add    $0x8,%esp
  54:	6a 02                	push   $0x2
  56:	68 90 06 00 00       	push   $0x690
  5b:	e8 5c 02 00 00       	call   2bc <open>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb c0                	jmp    25 <main+0x25>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 ab 06 00 00       	push   $0x6ab
  6d:	6a 01                	push   $0x1
  6f:	e8 6d 03 00 00       	call   3e1 <printf>
      exit();
  74:	e8 03 02 00 00       	call   27c <exit>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 d7 06 00 00       	push   $0x6d7
  81:	6a 01                	push   $0x1
  83:	e8 59 03 00 00       	call   3e1 <printf>
  88:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  8b:	e8 f4 01 00 00       	call   284 <wait>
  90:	85 c0                	test   %eax,%eax
  92:	78 04                	js     98 <main+0x98>
  94:	39 c3                	cmp    %eax,%ebx
  96:	75 e1                	jne    79 <main+0x79>
    printf(1, "init: starting sh\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 98 06 00 00       	push   $0x698
  a0:	6a 01                	push   $0x1
  a2:	e8 3a 03 00 00       	call   3e1 <printf>
    pid = fork();
  a7:	e8 c8 01 00 00       	call   274 <fork>
  ac:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	85 c0                	test   %eax,%eax
  b3:	78 b0                	js     65 <main+0x65>
    if(pid == 0){
  b5:	75 d4                	jne    8b <main+0x8b>
      exec("sh", argv);
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	68 e4 09 00 00       	push   $0x9e4
  bf:	68 be 06 00 00       	push   $0x6be
  c4:	e8 eb 01 00 00       	call   2b4 <exec>
      printf(1, "init: exec sh failed\n");
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	68 c1 06 00 00       	push   $0x6c1
  d1:	6a 01                	push   $0x1
  d3:	e8 09 03 00 00       	call   3e1 <printf>
      exit();
  d8:	e8 9f 01 00 00       	call   27c <exit>

000000dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	56                   	push   %esi
  e1:	53                   	push   %ebx
  e2:	8b 75 08             	mov    0x8(%ebp),%esi
  e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e8:	89 f0                	mov    %esi,%eax
  ea:	89 d1                	mov    %edx,%ecx
  ec:	83 c2 01             	add    $0x1,%edx
  ef:	89 c3                	mov    %eax,%ebx
  f1:	83 c0 01             	add    $0x1,%eax
  f4:	0f b6 09             	movzbl (%ecx),%ecx
  f7:	88 0b                	mov    %cl,(%ebx)
  f9:	84 c9                	test   %cl,%cl
  fb:	75 ed                	jne    ea <strcpy+0xd>
    ;
  return os;
}
  fd:	89 f0                	mov    %esi,%eax
  ff:	5b                   	pop    %ebx
 100:	5e                   	pop    %esi
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    

00000103 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10c:	eb 06                	jmp    114 <strcmp+0x11>
    p++, q++;
 10e:	83 c1 01             	add    $0x1,%ecx
 111:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 114:	0f b6 01             	movzbl (%ecx),%eax
 117:	84 c0                	test   %al,%al
 119:	74 04                	je     11f <strcmp+0x1c>
 11b:	3a 02                	cmp    (%edx),%al
 11d:	74 ef                	je     10e <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 11f:	0f b6 c0             	movzbl %al,%eax
 122:	0f b6 12             	movzbl (%edx),%edx
 125:	29 d0                	sub    %edx,%eax
}
 127:	5d                   	pop    %ebp
 128:	c3                   	ret    

00000129 <strlen>:

uint
strlen(const char *s)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
 12c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 12f:	b8 00 00 00 00       	mov    $0x0,%eax
 134:	eb 03                	jmp    139 <strlen+0x10>
 136:	83 c0 01             	add    $0x1,%eax
 139:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 13d:	75 f7                	jne    136 <strlen+0xd>
    ;
  return n;
}
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <memset>:

void*
memset(void *dst, int c, uint n)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	57                   	push   %edi
 145:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 148:	89 d7                	mov    %edx,%edi
 14a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	fc                   	cld    
 151:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 153:	89 d0                	mov    %edx,%eax
 155:	8b 7d fc             	mov    -0x4(%ebp),%edi
 158:	c9                   	leave  
 159:	c3                   	ret    

0000015a <strchr>:

char*
strchr(const char *s, char c)
{
 15a:	55                   	push   %ebp
 15b:	89 e5                	mov    %esp,%ebp
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 164:	eb 03                	jmp    169 <strchr+0xf>
 166:	83 c0 01             	add    $0x1,%eax
 169:	0f b6 10             	movzbl (%eax),%edx
 16c:	84 d2                	test   %dl,%dl
 16e:	74 06                	je     176 <strchr+0x1c>
    if(*s == c)
 170:	38 ca                	cmp    %cl,%dl
 172:	75 f2                	jne    166 <strchr+0xc>
 174:	eb 05                	jmp    17b <strchr+0x21>
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	57                   	push   %edi
 181:	56                   	push   %esi
 182:	53                   	push   %ebx
 183:	83 ec 1c             	sub    $0x1c,%esp
 186:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 189:	bb 00 00 00 00       	mov    $0x0,%ebx
 18e:	89 de                	mov    %ebx,%esi
 190:	83 c3 01             	add    $0x1,%ebx
 193:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 196:	7d 2e                	jge    1c6 <gets+0x49>
    cc = read(0, &c, 1);
 198:	83 ec 04             	sub    $0x4,%esp
 19b:	6a 01                	push   $0x1
 19d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1a0:	50                   	push   %eax
 1a1:	6a 00                	push   $0x0
 1a3:	e8 ec 00 00 00       	call   294 <read>
    if(cc < 1)
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	85 c0                	test   %eax,%eax
 1ad:	7e 17                	jle    1c6 <gets+0x49>
      break;
    buf[i++] = c;
 1af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b3:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1b6:	3c 0a                	cmp    $0xa,%al
 1b8:	0f 94 c2             	sete   %dl
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	0f 94 c0             	sete   %al
 1c0:	08 c2                	or     %al,%dl
 1c2:	74 ca                	je     18e <gets+0x11>
    buf[i++] = c;
 1c4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1c6:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1ca:	89 f8                	mov    %edi,%eax
 1cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cf:	5b                   	pop    %ebx
 1d0:	5e                   	pop    %esi
 1d1:	5f                   	pop    %edi
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    

000001d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	56                   	push   %esi
 1d8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	6a 00                	push   $0x0
 1de:	ff 75 08             	push   0x8(%ebp)
 1e1:	e8 d6 00 00 00       	call   2bc <open>
  if(fd < 0)
 1e6:	83 c4 10             	add    $0x10,%esp
 1e9:	85 c0                	test   %eax,%eax
 1eb:	78 24                	js     211 <stat+0x3d>
 1ed:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1ef:	83 ec 08             	sub    $0x8,%esp
 1f2:	ff 75 0c             	push   0xc(%ebp)
 1f5:	50                   	push   %eax
 1f6:	e8 d9 00 00 00       	call   2d4 <fstat>
 1fb:	89 c6                	mov    %eax,%esi
  close(fd);
 1fd:	89 1c 24             	mov    %ebx,(%esp)
 200:	e8 9f 00 00 00       	call   2a4 <close>
  return r;
 205:	83 c4 10             	add    $0x10,%esp
}
 208:	89 f0                	mov    %esi,%eax
 20a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 20d:	5b                   	pop    %ebx
 20e:	5e                   	pop    %esi
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret    
    return -1;
 211:	be ff ff ff ff       	mov    $0xffffffff,%esi
 216:	eb f0                	jmp    208 <stat+0x34>

00000218 <atoi>:

int
atoi(const char *s)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	53                   	push   %ebx
 21c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 21f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 224:	eb 10                	jmp    236 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 226:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 229:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 22c:	83 c1 01             	add    $0x1,%ecx
 22f:	0f be c0             	movsbl %al,%eax
 232:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 236:	0f b6 01             	movzbl (%ecx),%eax
 239:	8d 58 d0             	lea    -0x30(%eax),%ebx
 23c:	80 fb 09             	cmp    $0x9,%bl
 23f:	76 e5                	jbe    226 <atoi+0xe>
  return n;
}
 241:	89 d0                	mov    %edx,%eax
 243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	56                   	push   %esi
 24c:	53                   	push   %ebx
 24d:	8b 75 08             	mov    0x8(%ebp),%esi
 250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 253:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 256:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 258:	eb 0d                	jmp    267 <memmove+0x1f>
    *dst++ = *src++;
 25a:	0f b6 01             	movzbl (%ecx),%eax
 25d:	88 02                	mov    %al,(%edx)
 25f:	8d 49 01             	lea    0x1(%ecx),%ecx
 262:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 265:	89 d8                	mov    %ebx,%eax
 267:	8d 58 ff             	lea    -0x1(%eax),%ebx
 26a:	85 c0                	test   %eax,%eax
 26c:	7f ec                	jg     25a <memmove+0x12>
  return vdst;
}
 26e:	89 f0                	mov    %esi,%eax
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5d                   	pop    %ebp
 273:	c3                   	ret    

00000274 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 274:	b8 01 00 00 00       	mov    $0x1,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <exit>:
SYSCALL(exit)
 27c:	b8 02 00 00 00       	mov    $0x2,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <wait>:
SYSCALL(wait)
 284:	b8 03 00 00 00       	mov    $0x3,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <pipe>:
SYSCALL(pipe)
 28c:	b8 04 00 00 00       	mov    $0x4,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <read>:
SYSCALL(read)
 294:	b8 05 00 00 00       	mov    $0x5,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <write>:
SYSCALL(write)
 29c:	b8 10 00 00 00       	mov    $0x10,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <close>:
SYSCALL(close)
 2a4:	b8 15 00 00 00       	mov    $0x15,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <kill>:
SYSCALL(kill)
 2ac:	b8 06 00 00 00       	mov    $0x6,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <exec>:
SYSCALL(exec)
 2b4:	b8 07 00 00 00       	mov    $0x7,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <open>:
SYSCALL(open)
 2bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <mknod>:
SYSCALL(mknod)
 2c4:	b8 11 00 00 00       	mov    $0x11,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <unlink>:
SYSCALL(unlink)
 2cc:	b8 12 00 00 00       	mov    $0x12,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <fstat>:
SYSCALL(fstat)
 2d4:	b8 08 00 00 00       	mov    $0x8,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <link>:
SYSCALL(link)
 2dc:	b8 13 00 00 00       	mov    $0x13,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <mkdir>:
SYSCALL(mkdir)
 2e4:	b8 14 00 00 00       	mov    $0x14,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <chdir>:
SYSCALL(chdir)
 2ec:	b8 09 00 00 00       	mov    $0x9,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <dup>:
SYSCALL(dup)
 2f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <getpid>:
SYSCALL(getpid)
 2fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <sbrk>:
SYSCALL(sbrk)
 304:	b8 0c 00 00 00       	mov    $0xc,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <sleep>:
SYSCALL(sleep)
 30c:	b8 0d 00 00 00       	mov    $0xd,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <uptime>:
SYSCALL(uptime)
 314:	b8 0e 00 00 00       	mov    $0xe,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <settickets>:
SYSCALL(settickets)
 31c:	b8 16 00 00 00       	mov    $0x16,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <getpinfo>:
SYSCALL(getpinfo)
 324:	b8 17 00 00 00       	mov    $0x17,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mprotect>:
SYSCALL(mprotect)
 32c:	b8 18 00 00 00       	mov    $0x18,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <munprotect>:
SYSCALL(munprotect)
 334:	b8 19 00 00 00       	mov    $0x19,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 1c             	sub    $0x1c,%esp
 342:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 345:	6a 01                	push   $0x1
 347:	8d 55 f4             	lea    -0xc(%ebp),%edx
 34a:	52                   	push   %edx
 34b:	50                   	push   %eax
 34c:	e8 4b ff ff ff       	call   29c <write>
}
 351:	83 c4 10             	add    $0x10,%esp
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	57                   	push   %edi
 35a:	56                   	push   %esi
 35b:	53                   	push   %ebx
 35c:	83 ec 2c             	sub    $0x2c,%esp
 35f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 362:	89 d0                	mov    %edx,%eax
 364:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 366:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 36a:	0f 95 c1             	setne  %cl
 36d:	c1 ea 1f             	shr    $0x1f,%edx
 370:	84 d1                	test   %dl,%cl
 372:	74 44                	je     3b8 <printint+0x62>
    neg = 1;
    x = -xx;
 374:	f7 d8                	neg    %eax
 376:	89 c1                	mov    %eax,%ecx
    neg = 1;
 378:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 384:	89 c8                	mov    %ecx,%eax
 386:	ba 00 00 00 00       	mov    $0x0,%edx
 38b:	f7 f6                	div    %esi
 38d:	89 df                	mov    %ebx,%edi
 38f:	83 c3 01             	add    $0x1,%ebx
 392:	0f b6 92 40 07 00 00 	movzbl 0x740(%edx),%edx
 399:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 39d:	89 ca                	mov    %ecx,%edx
 39f:	89 c1                	mov    %eax,%ecx
 3a1:	39 d6                	cmp    %edx,%esi
 3a3:	76 df                	jbe    384 <printint+0x2e>
  if(neg)
 3a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3a9:	74 31                	je     3dc <printint+0x86>
    buf[i++] = '-';
 3ab:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3b0:	8d 5f 02             	lea    0x2(%edi),%ebx
 3b3:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3b6:	eb 17                	jmp    3cf <printint+0x79>
    x = xx;
 3b8:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3ba:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3c1:	eb bc                	jmp    37f <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3c3:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3c8:	89 f0                	mov    %esi,%eax
 3ca:	e8 6d ff ff ff       	call   33c <putc>
  while(--i >= 0)
 3cf:	83 eb 01             	sub    $0x1,%ebx
 3d2:	79 ef                	jns    3c3 <printint+0x6d>
}
 3d4:	83 c4 2c             	add    $0x2c,%esp
 3d7:	5b                   	pop    %ebx
 3d8:	5e                   	pop    %esi
 3d9:	5f                   	pop    %edi
 3da:	5d                   	pop    %ebp
 3db:	c3                   	ret    
 3dc:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3df:	eb ee                	jmp    3cf <printint+0x79>

000003e1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e1:	55                   	push   %ebp
 3e2:	89 e5                	mov    %esp,%ebp
 3e4:	57                   	push   %edi
 3e5:	56                   	push   %esi
 3e6:	53                   	push   %ebx
 3e7:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ea:	8d 45 10             	lea    0x10(%ebp),%eax
 3ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3f0:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3f5:	bb 00 00 00 00       	mov    $0x0,%ebx
 3fa:	eb 14                	jmp    410 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3fc:	89 fa                	mov    %edi,%edx
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	e8 36 ff ff ff       	call   33c <putc>
 406:	eb 05                	jmp    40d <printf+0x2c>
      }
    } else if(state == '%'){
 408:	83 fe 25             	cmp    $0x25,%esi
 40b:	74 25                	je     432 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 40d:	83 c3 01             	add    $0x1,%ebx
 410:	8b 45 0c             	mov    0xc(%ebp),%eax
 413:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 417:	84 c0                	test   %al,%al
 419:	0f 84 20 01 00 00    	je     53f <printf+0x15e>
    c = fmt[i] & 0xff;
 41f:	0f be f8             	movsbl %al,%edi
 422:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 425:	85 f6                	test   %esi,%esi
 427:	75 df                	jne    408 <printf+0x27>
      if(c == '%'){
 429:	83 f8 25             	cmp    $0x25,%eax
 42c:	75 ce                	jne    3fc <printf+0x1b>
        state = '%';
 42e:	89 c6                	mov    %eax,%esi
 430:	eb db                	jmp    40d <printf+0x2c>
      if(c == 'd'){
 432:	83 f8 25             	cmp    $0x25,%eax
 435:	0f 84 cf 00 00 00    	je     50a <printf+0x129>
 43b:	0f 8c dd 00 00 00    	jl     51e <printf+0x13d>
 441:	83 f8 78             	cmp    $0x78,%eax
 444:	0f 8f d4 00 00 00    	jg     51e <printf+0x13d>
 44a:	83 f8 63             	cmp    $0x63,%eax
 44d:	0f 8c cb 00 00 00    	jl     51e <printf+0x13d>
 453:	83 e8 63             	sub    $0x63,%eax
 456:	83 f8 15             	cmp    $0x15,%eax
 459:	0f 87 bf 00 00 00    	ja     51e <printf+0x13d>
 45f:	ff 24 85 e8 06 00 00 	jmp    *0x6e8(,%eax,4)
        printint(fd, *ap, 10, 1);
 466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 469:	8b 17                	mov    (%edi),%edx
 46b:	83 ec 0c             	sub    $0xc,%esp
 46e:	6a 01                	push   $0x1
 470:	b9 0a 00 00 00       	mov    $0xa,%ecx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	e8 d9 fe ff ff       	call   356 <printint>
        ap++;
 47d:	83 c7 04             	add    $0x4,%edi
 480:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 483:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 486:	be 00 00 00 00       	mov    $0x0,%esi
 48b:	eb 80                	jmp    40d <printf+0x2c>
        printint(fd, *ap, 16, 0);
 48d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 490:	8b 17                	mov    (%edi),%edx
 492:	83 ec 0c             	sub    $0xc,%esp
 495:	6a 00                	push   $0x0
 497:	b9 10 00 00 00       	mov    $0x10,%ecx
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	e8 b2 fe ff ff       	call   356 <printint>
        ap++;
 4a4:	83 c7 04             	add    $0x4,%edi
 4a7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4aa:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ad:	be 00 00 00 00       	mov    $0x0,%esi
 4b2:	e9 56 ff ff ff       	jmp    40d <printf+0x2c>
        s = (char*)*ap;
 4b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ba:	8b 30                	mov    (%eax),%esi
        ap++;
 4bc:	83 c0 04             	add    $0x4,%eax
 4bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4c2:	85 f6                	test   %esi,%esi
 4c4:	75 15                	jne    4db <printf+0xfa>
          s = "(null)";
 4c6:	be e0 06 00 00       	mov    $0x6e0,%esi
 4cb:	eb 0e                	jmp    4db <printf+0xfa>
          putc(fd, *s);
 4cd:	0f be d2             	movsbl %dl,%edx
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	e8 64 fe ff ff       	call   33c <putc>
          s++;
 4d8:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4db:	0f b6 16             	movzbl (%esi),%edx
 4de:	84 d2                	test   %dl,%dl
 4e0:	75 eb                	jne    4cd <printf+0xec>
      state = 0;
 4e2:	be 00 00 00 00       	mov    $0x0,%esi
 4e7:	e9 21 ff ff ff       	jmp    40d <printf+0x2c>
        putc(fd, *ap);
 4ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ef:	0f be 17             	movsbl (%edi),%edx
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	e8 42 fe ff ff       	call   33c <putc>
        ap++;
 4fa:	83 c7 04             	add    $0x4,%edi
 4fd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 500:	be 00 00 00 00       	mov    $0x0,%esi
 505:	e9 03 ff ff ff       	jmp    40d <printf+0x2c>
        putc(fd, c);
 50a:	89 fa                	mov    %edi,%edx
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
 50f:	e8 28 fe ff ff       	call   33c <putc>
      state = 0;
 514:	be 00 00 00 00       	mov    $0x0,%esi
 519:	e9 ef fe ff ff       	jmp    40d <printf+0x2c>
        putc(fd, '%');
 51e:	ba 25 00 00 00       	mov    $0x25,%edx
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	e8 11 fe ff ff       	call   33c <putc>
        putc(fd, c);
 52b:	89 fa                	mov    %edi,%edx
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	e8 07 fe ff ff       	call   33c <putc>
      state = 0;
 535:	be 00 00 00 00       	mov    $0x0,%esi
 53a:	e9 ce fe ff ff       	jmp    40d <printf+0x2c>
    }
  }
}
 53f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 542:	5b                   	pop    %ebx
 543:	5e                   	pop    %esi
 544:	5f                   	pop    %edi
 545:	5d                   	pop    %ebp
 546:	c3                   	ret    

00000547 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 547:	55                   	push   %ebp
 548:	89 e5                	mov    %esp,%ebp
 54a:	57                   	push   %edi
 54b:	56                   	push   %esi
 54c:	53                   	push   %ebx
 54d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 550:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 553:	a1 ec 09 00 00       	mov    0x9ec,%eax
 558:	eb 02                	jmp    55c <free+0x15>
 55a:	89 d0                	mov    %edx,%eax
 55c:	39 c8                	cmp    %ecx,%eax
 55e:	73 04                	jae    564 <free+0x1d>
 560:	39 08                	cmp    %ecx,(%eax)
 562:	77 12                	ja     576 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 564:	8b 10                	mov    (%eax),%edx
 566:	39 c2                	cmp    %eax,%edx
 568:	77 f0                	ja     55a <free+0x13>
 56a:	39 c8                	cmp    %ecx,%eax
 56c:	72 08                	jb     576 <free+0x2f>
 56e:	39 ca                	cmp    %ecx,%edx
 570:	77 04                	ja     576 <free+0x2f>
 572:	89 d0                	mov    %edx,%eax
 574:	eb e6                	jmp    55c <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 576:	8b 73 fc             	mov    -0x4(%ebx),%esi
 579:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57c:	8b 10                	mov    (%eax),%edx
 57e:	39 d7                	cmp    %edx,%edi
 580:	74 19                	je     59b <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 582:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 585:	8b 50 04             	mov    0x4(%eax),%edx
 588:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 58b:	39 ce                	cmp    %ecx,%esi
 58d:	74 1b                	je     5aa <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 58f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 591:	a3 ec 09 00 00       	mov    %eax,0x9ec
}
 596:	5b                   	pop    %ebx
 597:	5e                   	pop    %esi
 598:	5f                   	pop    %edi
 599:	5d                   	pop    %ebp
 59a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 59b:	03 72 04             	add    0x4(%edx),%esi
 59e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a1:	8b 10                	mov    (%eax),%edx
 5a3:	8b 12                	mov    (%edx),%edx
 5a5:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5a8:	eb db                	jmp    585 <free+0x3e>
    p->s.size += bp->s.size;
 5aa:	03 53 fc             	add    -0x4(%ebx),%edx
 5ad:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5b0:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b3:	89 10                	mov    %edx,(%eax)
 5b5:	eb da                	jmp    591 <free+0x4a>

000005b7 <morecore>:

static Header*
morecore(uint nu)
{
 5b7:	55                   	push   %ebp
 5b8:	89 e5                	mov    %esp,%ebp
 5ba:	53                   	push   %ebx
 5bb:	83 ec 04             	sub    $0x4,%esp
 5be:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5c0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5c5:	77 05                	ja     5cc <morecore+0x15>
    nu = 4096;
 5c7:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5cc:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5d3:	83 ec 0c             	sub    $0xc,%esp
 5d6:	50                   	push   %eax
 5d7:	e8 28 fd ff ff       	call   304 <sbrk>
  if(p == (char*)-1)
 5dc:	83 c4 10             	add    $0x10,%esp
 5df:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e2:	74 1c                	je     600 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5e4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5e7:	83 c0 08             	add    $0x8,%eax
 5ea:	83 ec 0c             	sub    $0xc,%esp
 5ed:	50                   	push   %eax
 5ee:	e8 54 ff ff ff       	call   547 <free>
  return freep;
 5f3:	a1 ec 09 00 00       	mov    0x9ec,%eax
 5f8:	83 c4 10             	add    $0x10,%esp
}
 5fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5fe:	c9                   	leave  
 5ff:	c3                   	ret    
    return 0;
 600:	b8 00 00 00 00       	mov    $0x0,%eax
 605:	eb f4                	jmp    5fb <morecore+0x44>

00000607 <malloc>:

void*
malloc(uint nbytes)
{
 607:	55                   	push   %ebp
 608:	89 e5                	mov    %esp,%ebp
 60a:	53                   	push   %ebx
 60b:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	8d 58 07             	lea    0x7(%eax),%ebx
 614:	c1 eb 03             	shr    $0x3,%ebx
 617:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 61a:	8b 0d ec 09 00 00    	mov    0x9ec,%ecx
 620:	85 c9                	test   %ecx,%ecx
 622:	74 04                	je     628 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 624:	8b 01                	mov    (%ecx),%eax
 626:	eb 4a                	jmp    672 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 628:	c7 05 ec 09 00 00 f0 	movl   $0x9f0,0x9ec
 62f:	09 00 00 
 632:	c7 05 f0 09 00 00 f0 	movl   $0x9f0,0x9f0
 639:	09 00 00 
    base.s.size = 0;
 63c:	c7 05 f4 09 00 00 00 	movl   $0x0,0x9f4
 643:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 646:	b9 f0 09 00 00       	mov    $0x9f0,%ecx
 64b:	eb d7                	jmp    624 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 64d:	74 19                	je     668 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 64f:	29 da                	sub    %ebx,%edx
 651:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 654:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 657:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 65a:	89 0d ec 09 00 00    	mov    %ecx,0x9ec
      return (void*)(p + 1);
 660:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 666:	c9                   	leave  
 667:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 668:	8b 10                	mov    (%eax),%edx
 66a:	89 11                	mov    %edx,(%ecx)
 66c:	eb ec                	jmp    65a <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66e:	89 c1                	mov    %eax,%ecx
 670:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 672:	8b 50 04             	mov    0x4(%eax),%edx
 675:	39 da                	cmp    %ebx,%edx
 677:	73 d4                	jae    64d <malloc+0x46>
    if(p == freep)
 679:	39 05 ec 09 00 00    	cmp    %eax,0x9ec
 67f:	75 ed                	jne    66e <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 681:	89 d8                	mov    %ebx,%eax
 683:	e8 2f ff ff ff       	call   5b7 <morecore>
 688:	85 c0                	test   %eax,%eax
 68a:	75 e2                	jne    66e <malloc+0x67>
 68c:	eb d5                	jmp    663 <malloc+0x5c>
