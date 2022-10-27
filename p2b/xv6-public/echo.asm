
_echo:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	b8 01 00 00 00       	mov    $0x1,%eax
  1e:	eb 1a                	jmp    3a <main+0x3a>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  20:	ba 06 06 00 00       	mov    $0x606,%edx
  25:	52                   	push   %edx
  26:	ff 34 87             	push   (%edi,%eax,4)
  29:	68 08 06 00 00       	push   $0x608
  2e:	6a 01                	push   $0x1
  30:	e8 20 03 00 00       	call   355 <printf>
  35:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  38:	89 d8                	mov    %ebx,%eax
  3a:	39 f0                	cmp    %esi,%eax
  3c:	7d 0e                	jge    4c <main+0x4c>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  3e:	8d 58 01             	lea    0x1(%eax),%ebx
  41:	39 f3                	cmp    %esi,%ebx
  43:	7d db                	jge    20 <main+0x20>
  45:	ba 04 06 00 00       	mov    $0x604,%edx
  4a:	eb d9                	jmp    25 <main+0x25>
  exit();
  4c:	e8 9f 01 00 00       	call   1f0 <exit>

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	56                   	push   %esi
  55:	53                   	push   %ebx
  56:	8b 75 08             	mov    0x8(%ebp),%esi
  59:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5c:	89 f0                	mov    %esi,%eax
  5e:	89 d1                	mov    %edx,%ecx
  60:	83 c2 01             	add    $0x1,%edx
  63:	89 c3                	mov    %eax,%ebx
  65:	83 c0 01             	add    $0x1,%eax
  68:	0f b6 09             	movzbl (%ecx),%ecx
  6b:	88 0b                	mov    %cl,(%ebx)
  6d:	84 c9                	test   %cl,%cl
  6f:	75 ed                	jne    5e <strcpy+0xd>
    ;
  return os;
}
  71:	89 f0                	mov    %esi,%eax
  73:	5b                   	pop    %ebx
  74:	5e                   	pop    %esi
  75:	5d                   	pop    %ebp
  76:	c3                   	ret    

00000077 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  80:	eb 06                	jmp    88 <strcmp+0x11>
    p++, q++;
  82:	83 c1 01             	add    $0x1,%ecx
  85:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  88:	0f b6 01             	movzbl (%ecx),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 04                	je     93 <strcmp+0x1c>
  8f:	3a 02                	cmp    (%edx),%al
  91:	74 ef                	je     82 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  93:	0f b6 c0             	movzbl %al,%eax
  96:	0f b6 12             	movzbl (%edx),%edx
  99:	29 d0                	sub    %edx,%eax
}
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    

0000009d <strlen>:

uint
strlen(const char *s)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a3:	b8 00 00 00 00       	mov    $0x0,%eax
  a8:	eb 03                	jmp    ad <strlen+0x10>
  aa:	83 c0 01             	add    $0x1,%eax
  ad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  b1:	75 f7                	jne    aa <strlen+0xd>
    ;
  return n;
}
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	57                   	push   %edi
  b9:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  bc:	89 d7                	mov    %edx,%edi
  be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  c4:	fc                   	cld    
  c5:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c7:	89 d0                	mov    %edx,%eax
  c9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strchr>:

char*
strchr(const char *s, char c)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d8:	eb 03                	jmp    dd <strchr+0xf>
  da:	83 c0 01             	add    $0x1,%eax
  dd:	0f b6 10             	movzbl (%eax),%edx
  e0:	84 d2                	test   %dl,%dl
  e2:	74 06                	je     ea <strchr+0x1c>
    if(*s == c)
  e4:	38 ca                	cmp    %cl,%dl
  e6:	75 f2                	jne    da <strchr+0xc>
  e8:	eb 05                	jmp    ef <strchr+0x21>
      return (char*)s;
  return 0;
  ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <gets>:

char*
gets(char *buf, int max)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	57                   	push   %edi
  f5:	56                   	push   %esi
  f6:	53                   	push   %ebx
  f7:	83 ec 1c             	sub    $0x1c,%esp
  fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fd:	bb 00 00 00 00       	mov    $0x0,%ebx
 102:	89 de                	mov    %ebx,%esi
 104:	83 c3 01             	add    $0x1,%ebx
 107:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 10a:	7d 2e                	jge    13a <gets+0x49>
    cc = read(0, &c, 1);
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	6a 01                	push   $0x1
 111:	8d 45 e7             	lea    -0x19(%ebp),%eax
 114:	50                   	push   %eax
 115:	6a 00                	push   $0x0
 117:	e8 ec 00 00 00       	call   208 <read>
    if(cc < 1)
 11c:	83 c4 10             	add    $0x10,%esp
 11f:	85 c0                	test   %eax,%eax
 121:	7e 17                	jle    13a <gets+0x49>
      break;
    buf[i++] = c;
 123:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 127:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 12a:	3c 0a                	cmp    $0xa,%al
 12c:	0f 94 c2             	sete   %dl
 12f:	3c 0d                	cmp    $0xd,%al
 131:	0f 94 c0             	sete   %al
 134:	08 c2                	or     %al,%dl
 136:	74 ca                	je     102 <gets+0x11>
    buf[i++] = c;
 138:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 13a:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 13e:	89 f8                	mov    %edi,%eax
 140:	8d 65 f4             	lea    -0xc(%ebp),%esp
 143:	5b                   	pop    %ebx
 144:	5e                   	pop    %esi
 145:	5f                   	pop    %edi
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    

00000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	56                   	push   %esi
 14c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	6a 00                	push   $0x0
 152:	ff 75 08             	push   0x8(%ebp)
 155:	e8 d6 00 00 00       	call   230 <open>
  if(fd < 0)
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	85 c0                	test   %eax,%eax
 15f:	78 24                	js     185 <stat+0x3d>
 161:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 163:	83 ec 08             	sub    $0x8,%esp
 166:	ff 75 0c             	push   0xc(%ebp)
 169:	50                   	push   %eax
 16a:	e8 d9 00 00 00       	call   248 <fstat>
 16f:	89 c6                	mov    %eax,%esi
  close(fd);
 171:	89 1c 24             	mov    %ebx,(%esp)
 174:	e8 9f 00 00 00       	call   218 <close>
  return r;
 179:	83 c4 10             	add    $0x10,%esp
}
 17c:	89 f0                	mov    %esi,%eax
 17e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 181:	5b                   	pop    %ebx
 182:	5e                   	pop    %esi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
    return -1;
 185:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18a:	eb f0                	jmp    17c <stat+0x34>

0000018c <atoi>:

int
atoi(const char *s)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	53                   	push   %ebx
 190:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 193:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 198:	eb 10                	jmp    1aa <atoi+0x1e>
    n = n*10 + *s++ - '0';
 19a:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 19d:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1a0:	83 c1 01             	add    $0x1,%ecx
 1a3:	0f be c0             	movsbl %al,%eax
 1a6:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1aa:	0f b6 01             	movzbl (%ecx),%eax
 1ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1b0:	80 fb 09             	cmp    $0x9,%bl
 1b3:	76 e5                	jbe    19a <atoi+0xe>
  return n;
}
 1b5:	89 d0                	mov    %edx,%eax
 1b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ba:	c9                   	leave  
 1bb:	c3                   	ret    

000001bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	56                   	push   %esi
 1c0:	53                   	push   %ebx
 1c1:	8b 75 08             	mov    0x8(%ebp),%esi
 1c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1ca:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1cc:	eb 0d                	jmp    1db <memmove+0x1f>
    *dst++ = *src++;
 1ce:	0f b6 01             	movzbl (%ecx),%eax
 1d1:	88 02                	mov    %al,(%edx)
 1d3:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d6:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d9:	89 d8                	mov    %ebx,%eax
 1db:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1de:	85 c0                	test   %eax,%eax
 1e0:	7f ec                	jg     1ce <memmove+0x12>
  return vdst;
}
 1e2:	89 f0                	mov    %esi,%eax
 1e4:	5b                   	pop    %ebx
 1e5:	5e                   	pop    %esi
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    

000001e8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e8:	b8 01 00 00 00       	mov    $0x1,%eax
 1ed:	cd 40                	int    $0x40
 1ef:	c3                   	ret    

000001f0 <exit>:
SYSCALL(exit)
 1f0:	b8 02 00 00 00       	mov    $0x2,%eax
 1f5:	cd 40                	int    $0x40
 1f7:	c3                   	ret    

000001f8 <wait>:
SYSCALL(wait)
 1f8:	b8 03 00 00 00       	mov    $0x3,%eax
 1fd:	cd 40                	int    $0x40
 1ff:	c3                   	ret    

00000200 <pipe>:
SYSCALL(pipe)
 200:	b8 04 00 00 00       	mov    $0x4,%eax
 205:	cd 40                	int    $0x40
 207:	c3                   	ret    

00000208 <read>:
SYSCALL(read)
 208:	b8 05 00 00 00       	mov    $0x5,%eax
 20d:	cd 40                	int    $0x40
 20f:	c3                   	ret    

00000210 <write>:
SYSCALL(write)
 210:	b8 10 00 00 00       	mov    $0x10,%eax
 215:	cd 40                	int    $0x40
 217:	c3                   	ret    

00000218 <close>:
SYSCALL(close)
 218:	b8 15 00 00 00       	mov    $0x15,%eax
 21d:	cd 40                	int    $0x40
 21f:	c3                   	ret    

00000220 <kill>:
SYSCALL(kill)
 220:	b8 06 00 00 00       	mov    $0x6,%eax
 225:	cd 40                	int    $0x40
 227:	c3                   	ret    

00000228 <exec>:
SYSCALL(exec)
 228:	b8 07 00 00 00       	mov    $0x7,%eax
 22d:	cd 40                	int    $0x40
 22f:	c3                   	ret    

00000230 <open>:
SYSCALL(open)
 230:	b8 0f 00 00 00       	mov    $0xf,%eax
 235:	cd 40                	int    $0x40
 237:	c3                   	ret    

00000238 <mknod>:
SYSCALL(mknod)
 238:	b8 11 00 00 00       	mov    $0x11,%eax
 23d:	cd 40                	int    $0x40
 23f:	c3                   	ret    

00000240 <unlink>:
SYSCALL(unlink)
 240:	b8 12 00 00 00       	mov    $0x12,%eax
 245:	cd 40                	int    $0x40
 247:	c3                   	ret    

00000248 <fstat>:
SYSCALL(fstat)
 248:	b8 08 00 00 00       	mov    $0x8,%eax
 24d:	cd 40                	int    $0x40
 24f:	c3                   	ret    

00000250 <link>:
SYSCALL(link)
 250:	b8 13 00 00 00       	mov    $0x13,%eax
 255:	cd 40                	int    $0x40
 257:	c3                   	ret    

00000258 <mkdir>:
SYSCALL(mkdir)
 258:	b8 14 00 00 00       	mov    $0x14,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <chdir>:
SYSCALL(chdir)
 260:	b8 09 00 00 00       	mov    $0x9,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <dup>:
SYSCALL(dup)
 268:	b8 0a 00 00 00       	mov    $0xa,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <getpid>:
SYSCALL(getpid)
 270:	b8 0b 00 00 00       	mov    $0xb,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <sbrk>:
SYSCALL(sbrk)
 278:	b8 0c 00 00 00       	mov    $0xc,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <sleep>:
SYSCALL(sleep)
 280:	b8 0d 00 00 00       	mov    $0xd,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <uptime>:
SYSCALL(uptime)
 288:	b8 0e 00 00 00       	mov    $0xe,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <settickets>:
SYSCALL(settickets)
 290:	b8 16 00 00 00       	mov    $0x16,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <getpinfo>:
SYSCALL(getpinfo)
 298:	b8 17 00 00 00       	mov    $0x17,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <mprotect>:
SYSCALL(mprotect)
 2a0:	b8 18 00 00 00       	mov    $0x18,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <munprotect>:
SYSCALL(munprotect)
 2a8:	b8 19 00 00 00       	mov    $0x19,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	83 ec 1c             	sub    $0x1c,%esp
 2b6:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2b9:	6a 01                	push   $0x1
 2bb:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2be:	52                   	push   %edx
 2bf:	50                   	push   %eax
 2c0:	e8 4b ff ff ff       	call   210 <write>
}
 2c5:	83 c4 10             	add    $0x10,%esp
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	57                   	push   %edi
 2ce:	56                   	push   %esi
 2cf:	53                   	push   %ebx
 2d0:	83 ec 2c             	sub    $0x2c,%esp
 2d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2d6:	89 d0                	mov    %edx,%eax
 2d8:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2de:	0f 95 c1             	setne  %cl
 2e1:	c1 ea 1f             	shr    $0x1f,%edx
 2e4:	84 d1                	test   %dl,%cl
 2e6:	74 44                	je     32c <printint+0x62>
    neg = 1;
    x = -xx;
 2e8:	f7 d8                	neg    %eax
 2ea:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2ec:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f8:	89 c8                	mov    %ecx,%eax
 2fa:	ba 00 00 00 00       	mov    $0x0,%edx
 2ff:	f7 f6                	div    %esi
 301:	89 df                	mov    %ebx,%edi
 303:	83 c3 01             	add    $0x1,%ebx
 306:	0f b6 92 6c 06 00 00 	movzbl 0x66c(%edx),%edx
 30d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 311:	89 ca                	mov    %ecx,%edx
 313:	89 c1                	mov    %eax,%ecx
 315:	39 d6                	cmp    %edx,%esi
 317:	76 df                	jbe    2f8 <printint+0x2e>
  if(neg)
 319:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 31d:	74 31                	je     350 <printint+0x86>
    buf[i++] = '-';
 31f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 324:	8d 5f 02             	lea    0x2(%edi),%ebx
 327:	8b 75 d0             	mov    -0x30(%ebp),%esi
 32a:	eb 17                	jmp    343 <printint+0x79>
    x = xx;
 32c:	89 c1                	mov    %eax,%ecx
  neg = 0;
 32e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 335:	eb bc                	jmp    2f3 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 337:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 33c:	89 f0                	mov    %esi,%eax
 33e:	e8 6d ff ff ff       	call   2b0 <putc>
  while(--i >= 0)
 343:	83 eb 01             	sub    $0x1,%ebx
 346:	79 ef                	jns    337 <printint+0x6d>
}
 348:	83 c4 2c             	add    $0x2c,%esp
 34b:	5b                   	pop    %ebx
 34c:	5e                   	pop    %esi
 34d:	5f                   	pop    %edi
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    
 350:	8b 75 d0             	mov    -0x30(%ebp),%esi
 353:	eb ee                	jmp    343 <printint+0x79>

00000355 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	57                   	push   %edi
 359:	56                   	push   %esi
 35a:	53                   	push   %ebx
 35b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 35e:	8d 45 10             	lea    0x10(%ebp),%eax
 361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 364:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 369:	bb 00 00 00 00       	mov    $0x0,%ebx
 36e:	eb 14                	jmp    384 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 370:	89 fa                	mov    %edi,%edx
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	e8 36 ff ff ff       	call   2b0 <putc>
 37a:	eb 05                	jmp    381 <printf+0x2c>
      }
    } else if(state == '%'){
 37c:	83 fe 25             	cmp    $0x25,%esi
 37f:	74 25                	je     3a6 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 381:	83 c3 01             	add    $0x1,%ebx
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 38b:	84 c0                	test   %al,%al
 38d:	0f 84 20 01 00 00    	je     4b3 <printf+0x15e>
    c = fmt[i] & 0xff;
 393:	0f be f8             	movsbl %al,%edi
 396:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 399:	85 f6                	test   %esi,%esi
 39b:	75 df                	jne    37c <printf+0x27>
      if(c == '%'){
 39d:	83 f8 25             	cmp    $0x25,%eax
 3a0:	75 ce                	jne    370 <printf+0x1b>
        state = '%';
 3a2:	89 c6                	mov    %eax,%esi
 3a4:	eb db                	jmp    381 <printf+0x2c>
      if(c == 'd'){
 3a6:	83 f8 25             	cmp    $0x25,%eax
 3a9:	0f 84 cf 00 00 00    	je     47e <printf+0x129>
 3af:	0f 8c dd 00 00 00    	jl     492 <printf+0x13d>
 3b5:	83 f8 78             	cmp    $0x78,%eax
 3b8:	0f 8f d4 00 00 00    	jg     492 <printf+0x13d>
 3be:	83 f8 63             	cmp    $0x63,%eax
 3c1:	0f 8c cb 00 00 00    	jl     492 <printf+0x13d>
 3c7:	83 e8 63             	sub    $0x63,%eax
 3ca:	83 f8 15             	cmp    $0x15,%eax
 3cd:	0f 87 bf 00 00 00    	ja     492 <printf+0x13d>
 3d3:	ff 24 85 14 06 00 00 	jmp    *0x614(,%eax,4)
        printint(fd, *ap, 10, 1);
 3da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3dd:	8b 17                	mov    (%edi),%edx
 3df:	83 ec 0c             	sub    $0xc,%esp
 3e2:	6a 01                	push   $0x1
 3e4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	e8 d9 fe ff ff       	call   2ca <printint>
        ap++;
 3f1:	83 c7 04             	add    $0x4,%edi
 3f4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f7:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3fa:	be 00 00 00 00       	mov    $0x0,%esi
 3ff:	eb 80                	jmp    381 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 404:	8b 17                	mov    (%edi),%edx
 406:	83 ec 0c             	sub    $0xc,%esp
 409:	6a 00                	push   $0x0
 40b:	b9 10 00 00 00       	mov    $0x10,%ecx
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	e8 b2 fe ff ff       	call   2ca <printint>
        ap++;
 418:	83 c7 04             	add    $0x4,%edi
 41b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 421:	be 00 00 00 00       	mov    $0x0,%esi
 426:	e9 56 ff ff ff       	jmp    381 <printf+0x2c>
        s = (char*)*ap;
 42b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 42e:	8b 30                	mov    (%eax),%esi
        ap++;
 430:	83 c0 04             	add    $0x4,%eax
 433:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 436:	85 f6                	test   %esi,%esi
 438:	75 15                	jne    44f <printf+0xfa>
          s = "(null)";
 43a:	be 0d 06 00 00       	mov    $0x60d,%esi
 43f:	eb 0e                	jmp    44f <printf+0xfa>
          putc(fd, *s);
 441:	0f be d2             	movsbl %dl,%edx
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	e8 64 fe ff ff       	call   2b0 <putc>
          s++;
 44c:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 44f:	0f b6 16             	movzbl (%esi),%edx
 452:	84 d2                	test   %dl,%dl
 454:	75 eb                	jne    441 <printf+0xec>
      state = 0;
 456:	be 00 00 00 00       	mov    $0x0,%esi
 45b:	e9 21 ff ff ff       	jmp    381 <printf+0x2c>
        putc(fd, *ap);
 460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 463:	0f be 17             	movsbl (%edi),%edx
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	e8 42 fe ff ff       	call   2b0 <putc>
        ap++;
 46e:	83 c7 04             	add    $0x4,%edi
 471:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 474:	be 00 00 00 00       	mov    $0x0,%esi
 479:	e9 03 ff ff ff       	jmp    381 <printf+0x2c>
        putc(fd, c);
 47e:	89 fa                	mov    %edi,%edx
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	e8 28 fe ff ff       	call   2b0 <putc>
      state = 0;
 488:	be 00 00 00 00       	mov    $0x0,%esi
 48d:	e9 ef fe ff ff       	jmp    381 <printf+0x2c>
        putc(fd, '%');
 492:	ba 25 00 00 00       	mov    $0x25,%edx
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	e8 11 fe ff ff       	call   2b0 <putc>
        putc(fd, c);
 49f:	89 fa                	mov    %edi,%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	e8 07 fe ff ff       	call   2b0 <putc>
      state = 0;
 4a9:	be 00 00 00 00       	mov    $0x0,%esi
 4ae:	e9 ce fe ff ff       	jmp    381 <printf+0x2c>
    }
  }
}
 4b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b6:	5b                   	pop    %ebx
 4b7:	5e                   	pop    %esi
 4b8:	5f                   	pop    %edi
 4b9:	5d                   	pop    %ebp
 4ba:	c3                   	ret    

000004bb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4bb:	55                   	push   %ebp
 4bc:	89 e5                	mov    %esp,%ebp
 4be:	57                   	push   %edi
 4bf:	56                   	push   %esi
 4c0:	53                   	push   %ebx
 4c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c7:	a1 18 09 00 00       	mov    0x918,%eax
 4cc:	eb 02                	jmp    4d0 <free+0x15>
 4ce:	89 d0                	mov    %edx,%eax
 4d0:	39 c8                	cmp    %ecx,%eax
 4d2:	73 04                	jae    4d8 <free+0x1d>
 4d4:	39 08                	cmp    %ecx,(%eax)
 4d6:	77 12                	ja     4ea <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d8:	8b 10                	mov    (%eax),%edx
 4da:	39 c2                	cmp    %eax,%edx
 4dc:	77 f0                	ja     4ce <free+0x13>
 4de:	39 c8                	cmp    %ecx,%eax
 4e0:	72 08                	jb     4ea <free+0x2f>
 4e2:	39 ca                	cmp    %ecx,%edx
 4e4:	77 04                	ja     4ea <free+0x2f>
 4e6:	89 d0                	mov    %edx,%eax
 4e8:	eb e6                	jmp    4d0 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4ea:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ed:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f0:	8b 10                	mov    (%eax),%edx
 4f2:	39 d7                	cmp    %edx,%edi
 4f4:	74 19                	je     50f <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4f6:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4f9:	8b 50 04             	mov    0x4(%eax),%edx
 4fc:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4ff:	39 ce                	cmp    %ecx,%esi
 501:	74 1b                	je     51e <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 503:	89 08                	mov    %ecx,(%eax)
  freep = p;
 505:	a3 18 09 00 00       	mov    %eax,0x918
}
 50a:	5b                   	pop    %ebx
 50b:	5e                   	pop    %esi
 50c:	5f                   	pop    %edi
 50d:	5d                   	pop    %ebp
 50e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 50f:	03 72 04             	add    0x4(%edx),%esi
 512:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 515:	8b 10                	mov    (%eax),%edx
 517:	8b 12                	mov    (%edx),%edx
 519:	89 53 f8             	mov    %edx,-0x8(%ebx)
 51c:	eb db                	jmp    4f9 <free+0x3e>
    p->s.size += bp->s.size;
 51e:	03 53 fc             	add    -0x4(%ebx),%edx
 521:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 524:	8b 53 f8             	mov    -0x8(%ebx),%edx
 527:	89 10                	mov    %edx,(%eax)
 529:	eb da                	jmp    505 <free+0x4a>

0000052b <morecore>:

static Header*
morecore(uint nu)
{
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	53                   	push   %ebx
 52f:	83 ec 04             	sub    $0x4,%esp
 532:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 534:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 539:	77 05                	ja     540 <morecore+0x15>
    nu = 4096;
 53b:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 540:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 547:	83 ec 0c             	sub    $0xc,%esp
 54a:	50                   	push   %eax
 54b:	e8 28 fd ff ff       	call   278 <sbrk>
  if(p == (char*)-1)
 550:	83 c4 10             	add    $0x10,%esp
 553:	83 f8 ff             	cmp    $0xffffffff,%eax
 556:	74 1c                	je     574 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 558:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 55b:	83 c0 08             	add    $0x8,%eax
 55e:	83 ec 0c             	sub    $0xc,%esp
 561:	50                   	push   %eax
 562:	e8 54 ff ff ff       	call   4bb <free>
  return freep;
 567:	a1 18 09 00 00       	mov    0x918,%eax
 56c:	83 c4 10             	add    $0x10,%esp
}
 56f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 572:	c9                   	leave  
 573:	c3                   	ret    
    return 0;
 574:	b8 00 00 00 00       	mov    $0x0,%eax
 579:	eb f4                	jmp    56f <morecore+0x44>

0000057b <malloc>:

void*
malloc(uint nbytes)
{
 57b:	55                   	push   %ebp
 57c:	89 e5                	mov    %esp,%ebp
 57e:	53                   	push   %ebx
 57f:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 582:	8b 45 08             	mov    0x8(%ebp),%eax
 585:	8d 58 07             	lea    0x7(%eax),%ebx
 588:	c1 eb 03             	shr    $0x3,%ebx
 58b:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 58e:	8b 0d 18 09 00 00    	mov    0x918,%ecx
 594:	85 c9                	test   %ecx,%ecx
 596:	74 04                	je     59c <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 598:	8b 01                	mov    (%ecx),%eax
 59a:	eb 4a                	jmp    5e6 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 59c:	c7 05 18 09 00 00 1c 	movl   $0x91c,0x918
 5a3:	09 00 00 
 5a6:	c7 05 1c 09 00 00 1c 	movl   $0x91c,0x91c
 5ad:	09 00 00 
    base.s.size = 0;
 5b0:	c7 05 20 09 00 00 00 	movl   $0x0,0x920
 5b7:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5ba:	b9 1c 09 00 00       	mov    $0x91c,%ecx
 5bf:	eb d7                	jmp    598 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5c1:	74 19                	je     5dc <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c3:	29 da                	sub    %ebx,%edx
 5c5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5c8:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5cb:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5ce:	89 0d 18 09 00 00    	mov    %ecx,0x918
      return (void*)(p + 1);
 5d4:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5da:	c9                   	leave  
 5db:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5dc:	8b 10                	mov    (%eax),%edx
 5de:	89 11                	mov    %edx,(%ecx)
 5e0:	eb ec                	jmp    5ce <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e2:	89 c1                	mov    %eax,%ecx
 5e4:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5e6:	8b 50 04             	mov    0x4(%eax),%edx
 5e9:	39 da                	cmp    %ebx,%edx
 5eb:	73 d4                	jae    5c1 <malloc+0x46>
    if(p == freep)
 5ed:	39 05 18 09 00 00    	cmp    %eax,0x918
 5f3:	75 ed                	jne    5e2 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5f5:	89 d8                	mov    %ebx,%eax
 5f7:	e8 2f ff ff ff       	call   52b <morecore>
 5fc:	85 c0                	test   %eax,%eax
 5fe:	75 e2                	jne    5e2 <malloc+0x67>
 600:	eb d5                	jmp    5d7 <malloc+0x5c>
