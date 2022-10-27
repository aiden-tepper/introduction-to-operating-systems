
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 10 06 00 00       	push   $0x610
  1f:	6a 02                	push   $0x2
  21:	e8 3a 03 00 00       	call   360 <printf>
    exit();
  26:	e8 d0 01 00 00       	call   1fb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	push   0x8(%ebx)
  31:	ff 73 04             	push   0x4(%ebx)
  34:	e8 22 02 00 00       	call   25b <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	78 05                	js     45 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  40:	e8 b6 01 00 00       	call   1fb <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  45:	ff 73 08             	push   0x8(%ebx)
  48:	ff 73 04             	push   0x4(%ebx)
  4b:	68 23 06 00 00       	push   $0x623
  50:	6a 02                	push   $0x2
  52:	e8 09 03 00 00       	call   360 <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb e4                	jmp    40 <main+0x40>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	56                   	push   %esi
  60:	53                   	push   %ebx
  61:	8b 75 08             	mov    0x8(%ebp),%esi
  64:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  67:	89 f0                	mov    %esi,%eax
  69:	89 d1                	mov    %edx,%ecx
  6b:	83 c2 01             	add    $0x1,%edx
  6e:	89 c3                	mov    %eax,%ebx
  70:	83 c0 01             	add    $0x1,%eax
  73:	0f b6 09             	movzbl (%ecx),%ecx
  76:	88 0b                	mov    %cl,(%ebx)
  78:	84 c9                	test   %cl,%cl
  7a:	75 ed                	jne    69 <strcpy+0xd>
    ;
  return os;
}
  7c:	89 f0                	mov    %esi,%eax
  7e:	5b                   	pop    %ebx
  7f:	5e                   	pop    %esi
  80:	5d                   	pop    %ebp
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  88:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8b:	eb 06                	jmp    93 <strcmp+0x11>
    p++, q++;
  8d:	83 c1 01             	add    $0x1,%ecx
  90:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  93:	0f b6 01             	movzbl (%ecx),%eax
  96:	84 c0                	test   %al,%al
  98:	74 04                	je     9e <strcmp+0x1c>
  9a:	3a 02                	cmp    (%edx),%al
  9c:	74 ef                	je     8d <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  9e:	0f b6 c0             	movzbl %al,%eax
  a1:	0f b6 12             	movzbl (%edx),%edx
  a4:	29 d0                	sub    %edx,%eax
}
  a6:	5d                   	pop    %ebp
  a7:	c3                   	ret    

000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ae:	b8 00 00 00 00       	mov    $0x0,%eax
  b3:	eb 03                	jmp    b8 <strlen+0x10>
  b5:	83 c0 01             	add    $0x1,%eax
  b8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  bc:	75 f7                	jne    b5 <strlen+0xd>
    ;
  return n;
}
  be:	5d                   	pop    %ebp
  bf:	c3                   	ret    

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	89 d7                	mov    %edx,%edi
  c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	89 d0                	mov    %edx,%eax
  d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d7:	c9                   	leave  
  d8:	c3                   	ret    

000000d9 <strchr>:

char*
strchr(const char *s, char c)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  e3:	eb 03                	jmp    e8 <strchr+0xf>
  e5:	83 c0 01             	add    $0x1,%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	84 d2                	test   %dl,%dl
  ed:	74 06                	je     f5 <strchr+0x1c>
    if(*s == c)
  ef:	38 ca                	cmp    %cl,%dl
  f1:	75 f2                	jne    e5 <strchr+0xc>
  f3:	eb 05                	jmp    fa <strchr+0x21>
      return (char*)s;
  return 0;
  f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	57                   	push   %edi
 100:	56                   	push   %esi
 101:	53                   	push   %ebx
 102:	83 ec 1c             	sub    $0x1c,%esp
 105:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 108:	bb 00 00 00 00       	mov    $0x0,%ebx
 10d:	89 de                	mov    %ebx,%esi
 10f:	83 c3 01             	add    $0x1,%ebx
 112:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 115:	7d 2e                	jge    145 <gets+0x49>
    cc = read(0, &c, 1);
 117:	83 ec 04             	sub    $0x4,%esp
 11a:	6a 01                	push   $0x1
 11c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 11f:	50                   	push   %eax
 120:	6a 00                	push   $0x0
 122:	e8 ec 00 00 00       	call   213 <read>
    if(cc < 1)
 127:	83 c4 10             	add    $0x10,%esp
 12a:	85 c0                	test   %eax,%eax
 12c:	7e 17                	jle    145 <gets+0x49>
      break;
    buf[i++] = c;
 12e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 132:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 135:	3c 0a                	cmp    $0xa,%al
 137:	0f 94 c2             	sete   %dl
 13a:	3c 0d                	cmp    $0xd,%al
 13c:	0f 94 c0             	sete   %al
 13f:	08 c2                	or     %al,%dl
 141:	74 ca                	je     10d <gets+0x11>
    buf[i++] = c;
 143:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 145:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 149:	89 f8                	mov    %edi,%eax
 14b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 14e:	5b                   	pop    %ebx
 14f:	5e                   	pop    %esi
 150:	5f                   	pop    %edi
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    

00000153 <stat>:

int
stat(const char *n, struct stat *st)
{
 153:	55                   	push   %ebp
 154:	89 e5                	mov    %esp,%ebp
 156:	56                   	push   %esi
 157:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 158:	83 ec 08             	sub    $0x8,%esp
 15b:	6a 00                	push   $0x0
 15d:	ff 75 08             	push   0x8(%ebp)
 160:	e8 d6 00 00 00       	call   23b <open>
  if(fd < 0)
 165:	83 c4 10             	add    $0x10,%esp
 168:	85 c0                	test   %eax,%eax
 16a:	78 24                	js     190 <stat+0x3d>
 16c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 16e:	83 ec 08             	sub    $0x8,%esp
 171:	ff 75 0c             	push   0xc(%ebp)
 174:	50                   	push   %eax
 175:	e8 d9 00 00 00       	call   253 <fstat>
 17a:	89 c6                	mov    %eax,%esi
  close(fd);
 17c:	89 1c 24             	mov    %ebx,(%esp)
 17f:	e8 9f 00 00 00       	call   223 <close>
  return r;
 184:	83 c4 10             	add    $0x10,%esp
}
 187:	89 f0                	mov    %esi,%eax
 189:	8d 65 f8             	lea    -0x8(%ebp),%esp
 18c:	5b                   	pop    %ebx
 18d:	5e                   	pop    %esi
 18e:	5d                   	pop    %ebp
 18f:	c3                   	ret    
    return -1;
 190:	be ff ff ff ff       	mov    $0xffffffff,%esi
 195:	eb f0                	jmp    187 <stat+0x34>

00000197 <atoi>:

int
atoi(const char *s)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	53                   	push   %ebx
 19b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 19e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a3:	eb 10                	jmp    1b5 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1a5:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1a8:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1ab:	83 c1 01             	add    $0x1,%ecx
 1ae:	0f be c0             	movsbl %al,%eax
 1b1:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1b5:	0f b6 01             	movzbl (%ecx),%eax
 1b8:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1bb:	80 fb 09             	cmp    $0x9,%bl
 1be:	76 e5                	jbe    1a5 <atoi+0xe>
  return n;
}
 1c0:	89 d0                	mov    %edx,%eax
 1c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c5:	c9                   	leave  
 1c6:	c3                   	ret    

000001c7 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
 1ca:	56                   	push   %esi
 1cb:	53                   	push   %ebx
 1cc:	8b 75 08             	mov    0x8(%ebp),%esi
 1cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1d2:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1d5:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1d7:	eb 0d                	jmp    1e6 <memmove+0x1f>
    *dst++ = *src++;
 1d9:	0f b6 01             	movzbl (%ecx),%eax
 1dc:	88 02                	mov    %al,(%edx)
 1de:	8d 49 01             	lea    0x1(%ecx),%ecx
 1e1:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1e4:	89 d8                	mov    %ebx,%eax
 1e6:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1e9:	85 c0                	test   %eax,%eax
 1eb:	7f ec                	jg     1d9 <memmove+0x12>
  return vdst;
}
 1ed:	89 f0                	mov    %esi,%eax
 1ef:	5b                   	pop    %ebx
 1f0:	5e                   	pop    %esi
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    

000001f3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f3:	b8 01 00 00 00       	mov    $0x1,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	ret    

000001fb <exit>:
SYSCALL(exit)
 1fb:	b8 02 00 00 00       	mov    $0x2,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	ret    

00000203 <wait>:
SYSCALL(wait)
 203:	b8 03 00 00 00       	mov    $0x3,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	ret    

0000020b <pipe>:
SYSCALL(pipe)
 20b:	b8 04 00 00 00       	mov    $0x4,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret    

00000213 <read>:
SYSCALL(read)
 213:	b8 05 00 00 00       	mov    $0x5,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <write>:
SYSCALL(write)
 21b:	b8 10 00 00 00       	mov    $0x10,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <close>:
SYSCALL(close)
 223:	b8 15 00 00 00       	mov    $0x15,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <kill>:
SYSCALL(kill)
 22b:	b8 06 00 00 00       	mov    $0x6,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <exec>:
SYSCALL(exec)
 233:	b8 07 00 00 00       	mov    $0x7,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <open>:
SYSCALL(open)
 23b:	b8 0f 00 00 00       	mov    $0xf,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <mknod>:
SYSCALL(mknod)
 243:	b8 11 00 00 00       	mov    $0x11,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <unlink>:
SYSCALL(unlink)
 24b:	b8 12 00 00 00       	mov    $0x12,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <fstat>:
SYSCALL(fstat)
 253:	b8 08 00 00 00       	mov    $0x8,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <link>:
SYSCALL(link)
 25b:	b8 13 00 00 00       	mov    $0x13,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <mkdir>:
SYSCALL(mkdir)
 263:	b8 14 00 00 00       	mov    $0x14,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <chdir>:
SYSCALL(chdir)
 26b:	b8 09 00 00 00       	mov    $0x9,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <dup>:
SYSCALL(dup)
 273:	b8 0a 00 00 00       	mov    $0xa,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <getpid>:
SYSCALL(getpid)
 27b:	b8 0b 00 00 00       	mov    $0xb,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <sbrk>:
SYSCALL(sbrk)
 283:	b8 0c 00 00 00       	mov    $0xc,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <sleep>:
SYSCALL(sleep)
 28b:	b8 0d 00 00 00       	mov    $0xd,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <uptime>:
SYSCALL(uptime)
 293:	b8 0e 00 00 00       	mov    $0xe,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <settickets>:
SYSCALL(settickets)
 29b:	b8 16 00 00 00       	mov    $0x16,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <getpinfo>:
SYSCALL(getpinfo)
 2a3:	b8 17 00 00 00       	mov    $0x17,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <mprotect>:
SYSCALL(mprotect)
 2ab:	b8 18 00 00 00       	mov    $0x18,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <munprotect>:
SYSCALL(munprotect)
 2b3:	b8 19 00 00 00       	mov    $0x19,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2bb:	55                   	push   %ebp
 2bc:	89 e5                	mov    %esp,%ebp
 2be:	83 ec 1c             	sub    $0x1c,%esp
 2c1:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2c4:	6a 01                	push   $0x1
 2c6:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2c9:	52                   	push   %edx
 2ca:	50                   	push   %eax
 2cb:	e8 4b ff ff ff       	call   21b <write>
}
 2d0:	83 c4 10             	add    $0x10,%esp
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	57                   	push   %edi
 2d9:	56                   	push   %esi
 2da:	53                   	push   %ebx
 2db:	83 ec 2c             	sub    $0x2c,%esp
 2de:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2e1:	89 d0                	mov    %edx,%eax
 2e3:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e9:	0f 95 c1             	setne  %cl
 2ec:	c1 ea 1f             	shr    $0x1f,%edx
 2ef:	84 d1                	test   %dl,%cl
 2f1:	74 44                	je     337 <printint+0x62>
    neg = 1;
    x = -xx;
 2f3:	f7 d8                	neg    %eax
 2f5:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 303:	89 c8                	mov    %ecx,%eax
 305:	ba 00 00 00 00       	mov    $0x0,%edx
 30a:	f7 f6                	div    %esi
 30c:	89 df                	mov    %ebx,%edi
 30e:	83 c3 01             	add    $0x1,%ebx
 311:	0f b6 92 98 06 00 00 	movzbl 0x698(%edx),%edx
 318:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 31c:	89 ca                	mov    %ecx,%edx
 31e:	89 c1                	mov    %eax,%ecx
 320:	39 d6                	cmp    %edx,%esi
 322:	76 df                	jbe    303 <printint+0x2e>
  if(neg)
 324:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 328:	74 31                	je     35b <printint+0x86>
    buf[i++] = '-';
 32a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 32f:	8d 5f 02             	lea    0x2(%edi),%ebx
 332:	8b 75 d0             	mov    -0x30(%ebp),%esi
 335:	eb 17                	jmp    34e <printint+0x79>
    x = xx;
 337:	89 c1                	mov    %eax,%ecx
  neg = 0;
 339:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 340:	eb bc                	jmp    2fe <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 342:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 347:	89 f0                	mov    %esi,%eax
 349:	e8 6d ff ff ff       	call   2bb <putc>
  while(--i >= 0)
 34e:	83 eb 01             	sub    $0x1,%ebx
 351:	79 ef                	jns    342 <printint+0x6d>
}
 353:	83 c4 2c             	add    $0x2c,%esp
 356:	5b                   	pop    %ebx
 357:	5e                   	pop    %esi
 358:	5f                   	pop    %edi
 359:	5d                   	pop    %ebp
 35a:	c3                   	ret    
 35b:	8b 75 d0             	mov    -0x30(%ebp),%esi
 35e:	eb ee                	jmp    34e <printint+0x79>

00000360 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 369:	8d 45 10             	lea    0x10(%ebp),%eax
 36c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 36f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 374:	bb 00 00 00 00       	mov    $0x0,%ebx
 379:	eb 14                	jmp    38f <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 37b:	89 fa                	mov    %edi,%edx
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	e8 36 ff ff ff       	call   2bb <putc>
 385:	eb 05                	jmp    38c <printf+0x2c>
      }
    } else if(state == '%'){
 387:	83 fe 25             	cmp    $0x25,%esi
 38a:	74 25                	je     3b1 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 38c:	83 c3 01             	add    $0x1,%ebx
 38f:	8b 45 0c             	mov    0xc(%ebp),%eax
 392:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 396:	84 c0                	test   %al,%al
 398:	0f 84 20 01 00 00    	je     4be <printf+0x15e>
    c = fmt[i] & 0xff;
 39e:	0f be f8             	movsbl %al,%edi
 3a1:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3a4:	85 f6                	test   %esi,%esi
 3a6:	75 df                	jne    387 <printf+0x27>
      if(c == '%'){
 3a8:	83 f8 25             	cmp    $0x25,%eax
 3ab:	75 ce                	jne    37b <printf+0x1b>
        state = '%';
 3ad:	89 c6                	mov    %eax,%esi
 3af:	eb db                	jmp    38c <printf+0x2c>
      if(c == 'd'){
 3b1:	83 f8 25             	cmp    $0x25,%eax
 3b4:	0f 84 cf 00 00 00    	je     489 <printf+0x129>
 3ba:	0f 8c dd 00 00 00    	jl     49d <printf+0x13d>
 3c0:	83 f8 78             	cmp    $0x78,%eax
 3c3:	0f 8f d4 00 00 00    	jg     49d <printf+0x13d>
 3c9:	83 f8 63             	cmp    $0x63,%eax
 3cc:	0f 8c cb 00 00 00    	jl     49d <printf+0x13d>
 3d2:	83 e8 63             	sub    $0x63,%eax
 3d5:	83 f8 15             	cmp    $0x15,%eax
 3d8:	0f 87 bf 00 00 00    	ja     49d <printf+0x13d>
 3de:	ff 24 85 40 06 00 00 	jmp    *0x640(,%eax,4)
        printint(fd, *ap, 10, 1);
 3e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3e8:	8b 17                	mov    (%edi),%edx
 3ea:	83 ec 0c             	sub    $0xc,%esp
 3ed:	6a 01                	push   $0x1
 3ef:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	e8 d9 fe ff ff       	call   2d5 <printint>
        ap++;
 3fc:	83 c7 04             	add    $0x4,%edi
 3ff:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 402:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 405:	be 00 00 00 00       	mov    $0x0,%esi
 40a:	eb 80                	jmp    38c <printf+0x2c>
        printint(fd, *ap, 16, 0);
 40c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 40f:	8b 17                	mov    (%edi),%edx
 411:	83 ec 0c             	sub    $0xc,%esp
 414:	6a 00                	push   $0x0
 416:	b9 10 00 00 00       	mov    $0x10,%ecx
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	e8 b2 fe ff ff       	call   2d5 <printint>
        ap++;
 423:	83 c7 04             	add    $0x4,%edi
 426:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 429:	83 c4 10             	add    $0x10,%esp
      state = 0;
 42c:	be 00 00 00 00       	mov    $0x0,%esi
 431:	e9 56 ff ff ff       	jmp    38c <printf+0x2c>
        s = (char*)*ap;
 436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 439:	8b 30                	mov    (%eax),%esi
        ap++;
 43b:	83 c0 04             	add    $0x4,%eax
 43e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 441:	85 f6                	test   %esi,%esi
 443:	75 15                	jne    45a <printf+0xfa>
          s = "(null)";
 445:	be 37 06 00 00       	mov    $0x637,%esi
 44a:	eb 0e                	jmp    45a <printf+0xfa>
          putc(fd, *s);
 44c:	0f be d2             	movsbl %dl,%edx
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	e8 64 fe ff ff       	call   2bb <putc>
          s++;
 457:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 45a:	0f b6 16             	movzbl (%esi),%edx
 45d:	84 d2                	test   %dl,%dl
 45f:	75 eb                	jne    44c <printf+0xec>
      state = 0;
 461:	be 00 00 00 00       	mov    $0x0,%esi
 466:	e9 21 ff ff ff       	jmp    38c <printf+0x2c>
        putc(fd, *ap);
 46b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 46e:	0f be 17             	movsbl (%edi),%edx
 471:	8b 45 08             	mov    0x8(%ebp),%eax
 474:	e8 42 fe ff ff       	call   2bb <putc>
        ap++;
 479:	83 c7 04             	add    $0x4,%edi
 47c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 47f:	be 00 00 00 00       	mov    $0x0,%esi
 484:	e9 03 ff ff ff       	jmp    38c <printf+0x2c>
        putc(fd, c);
 489:	89 fa                	mov    %edi,%edx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	e8 28 fe ff ff       	call   2bb <putc>
      state = 0;
 493:	be 00 00 00 00       	mov    $0x0,%esi
 498:	e9 ef fe ff ff       	jmp    38c <printf+0x2c>
        putc(fd, '%');
 49d:	ba 25 00 00 00       	mov    $0x25,%edx
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	e8 11 fe ff ff       	call   2bb <putc>
        putc(fd, c);
 4aa:	89 fa                	mov    %edi,%edx
 4ac:	8b 45 08             	mov    0x8(%ebp),%eax
 4af:	e8 07 fe ff ff       	call   2bb <putc>
      state = 0;
 4b4:	be 00 00 00 00       	mov    $0x0,%esi
 4b9:	e9 ce fe ff ff       	jmp    38c <printf+0x2c>
    }
  }
}
 4be:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c1:	5b                   	pop    %ebx
 4c2:	5e                   	pop    %esi
 4c3:	5f                   	pop    %edi
 4c4:	5d                   	pop    %ebp
 4c5:	c3                   	ret    

000004c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c6:	55                   	push   %ebp
 4c7:	89 e5                	mov    %esp,%ebp
 4c9:	57                   	push   %edi
 4ca:	56                   	push   %esi
 4cb:	53                   	push   %ebx
 4cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4cf:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d2:	a1 3c 09 00 00       	mov    0x93c,%eax
 4d7:	eb 02                	jmp    4db <free+0x15>
 4d9:	89 d0                	mov    %edx,%eax
 4db:	39 c8                	cmp    %ecx,%eax
 4dd:	73 04                	jae    4e3 <free+0x1d>
 4df:	39 08                	cmp    %ecx,(%eax)
 4e1:	77 12                	ja     4f5 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e3:	8b 10                	mov    (%eax),%edx
 4e5:	39 c2                	cmp    %eax,%edx
 4e7:	77 f0                	ja     4d9 <free+0x13>
 4e9:	39 c8                	cmp    %ecx,%eax
 4eb:	72 08                	jb     4f5 <free+0x2f>
 4ed:	39 ca                	cmp    %ecx,%edx
 4ef:	77 04                	ja     4f5 <free+0x2f>
 4f1:	89 d0                	mov    %edx,%eax
 4f3:	eb e6                	jmp    4db <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4f5:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4f8:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4fb:	8b 10                	mov    (%eax),%edx
 4fd:	39 d7                	cmp    %edx,%edi
 4ff:	74 19                	je     51a <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 501:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 504:	8b 50 04             	mov    0x4(%eax),%edx
 507:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 50a:	39 ce                	cmp    %ecx,%esi
 50c:	74 1b                	je     529 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 50e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 510:	a3 3c 09 00 00       	mov    %eax,0x93c
}
 515:	5b                   	pop    %ebx
 516:	5e                   	pop    %esi
 517:	5f                   	pop    %edi
 518:	5d                   	pop    %ebp
 519:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 51a:	03 72 04             	add    0x4(%edx),%esi
 51d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 520:	8b 10                	mov    (%eax),%edx
 522:	8b 12                	mov    (%edx),%edx
 524:	89 53 f8             	mov    %edx,-0x8(%ebx)
 527:	eb db                	jmp    504 <free+0x3e>
    p->s.size += bp->s.size;
 529:	03 53 fc             	add    -0x4(%ebx),%edx
 52c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 52f:	8b 53 f8             	mov    -0x8(%ebx),%edx
 532:	89 10                	mov    %edx,(%eax)
 534:	eb da                	jmp    510 <free+0x4a>

00000536 <morecore>:

static Header*
morecore(uint nu)
{
 536:	55                   	push   %ebp
 537:	89 e5                	mov    %esp,%ebp
 539:	53                   	push   %ebx
 53a:	83 ec 04             	sub    $0x4,%esp
 53d:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 53f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 544:	77 05                	ja     54b <morecore+0x15>
    nu = 4096;
 546:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 54b:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 552:	83 ec 0c             	sub    $0xc,%esp
 555:	50                   	push   %eax
 556:	e8 28 fd ff ff       	call   283 <sbrk>
  if(p == (char*)-1)
 55b:	83 c4 10             	add    $0x10,%esp
 55e:	83 f8 ff             	cmp    $0xffffffff,%eax
 561:	74 1c                	je     57f <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 563:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 566:	83 c0 08             	add    $0x8,%eax
 569:	83 ec 0c             	sub    $0xc,%esp
 56c:	50                   	push   %eax
 56d:	e8 54 ff ff ff       	call   4c6 <free>
  return freep;
 572:	a1 3c 09 00 00       	mov    0x93c,%eax
 577:	83 c4 10             	add    $0x10,%esp
}
 57a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 57d:	c9                   	leave  
 57e:	c3                   	ret    
    return 0;
 57f:	b8 00 00 00 00       	mov    $0x0,%eax
 584:	eb f4                	jmp    57a <morecore+0x44>

00000586 <malloc>:

void*
malloc(uint nbytes)
{
 586:	55                   	push   %ebp
 587:	89 e5                	mov    %esp,%ebp
 589:	53                   	push   %ebx
 58a:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	8d 58 07             	lea    0x7(%eax),%ebx
 593:	c1 eb 03             	shr    $0x3,%ebx
 596:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 599:	8b 0d 3c 09 00 00    	mov    0x93c,%ecx
 59f:	85 c9                	test   %ecx,%ecx
 5a1:	74 04                	je     5a7 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a3:	8b 01                	mov    (%ecx),%eax
 5a5:	eb 4a                	jmp    5f1 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5a7:	c7 05 3c 09 00 00 40 	movl   $0x940,0x93c
 5ae:	09 00 00 
 5b1:	c7 05 40 09 00 00 40 	movl   $0x940,0x940
 5b8:	09 00 00 
    base.s.size = 0;
 5bb:	c7 05 44 09 00 00 00 	movl   $0x0,0x944
 5c2:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5c5:	b9 40 09 00 00       	mov    $0x940,%ecx
 5ca:	eb d7                	jmp    5a3 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5cc:	74 19                	je     5e7 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ce:	29 da                	sub    %ebx,%edx
 5d0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5d3:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5d6:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5d9:	89 0d 3c 09 00 00    	mov    %ecx,0x93c
      return (void*)(p + 1);
 5df:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e5:	c9                   	leave  
 5e6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5e7:	8b 10                	mov    (%eax),%edx
 5e9:	89 11                	mov    %edx,(%ecx)
 5eb:	eb ec                	jmp    5d9 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ed:	89 c1                	mov    %eax,%ecx
 5ef:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5f1:	8b 50 04             	mov    0x4(%eax),%edx
 5f4:	39 da                	cmp    %ebx,%edx
 5f6:	73 d4                	jae    5cc <malloc+0x46>
    if(p == freep)
 5f8:	39 05 3c 09 00 00    	cmp    %eax,0x93c
 5fe:	75 ed                	jne    5ed <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 600:	89 d8                	mov    %ebx,%eax
 602:	e8 2f ff ff ff       	call   536 <morecore>
 607:	85 c0                	test   %eax,%eax
 609:	75 e2                	jne    5ed <malloc+0x67>
 60b:	eb d5                	jmp    5e2 <malloc+0x5c>
