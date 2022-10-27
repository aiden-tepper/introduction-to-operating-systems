
_test_14:     file format elf32-i386


Disassembly of section .text:

00000000 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
   8:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
   b:	89 f0                	mov    %esi,%eax
   d:	89 d1                	mov    %edx,%ecx
   f:	83 c2 01             	add    $0x1,%edx
  12:	89 c3                	mov    %eax,%ebx
  14:	83 c0 01             	add    $0x1,%eax
  17:	0f b6 09             	movzbl (%ecx),%ecx
  1a:	88 0b                	mov    %cl,(%ebx)
  1c:	84 c9                	test   %cl,%cl
  1e:	75 ed                	jne    d <strcpy+0xd>
    ;
  return os;
}
  20:	89 f0                	mov    %esi,%eax
  22:	5b                   	pop    %ebx
  23:	5e                   	pop    %esi
  24:	5d                   	pop    %ebp
  25:	c3                   	ret    

00000026 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  26:	55                   	push   %ebp
  27:	89 e5                	mov    %esp,%ebp
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  2f:	eb 06                	jmp    37 <strcmp+0x11>
    p++, q++;
  31:	83 c1 01             	add    $0x1,%ecx
  34:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  37:	0f b6 01             	movzbl (%ecx),%eax
  3a:	84 c0                	test   %al,%al
  3c:	74 04                	je     42 <strcmp+0x1c>
  3e:	3a 02                	cmp    (%edx),%al
  40:	74 ef                	je     31 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  42:	0f b6 c0             	movzbl %al,%eax
  45:	0f b6 12             	movzbl (%edx),%edx
  48:	29 d0                	sub    %edx,%eax
}
  4a:	5d                   	pop    %ebp
  4b:	c3                   	ret    

0000004c <strlen>:

uint
strlen(const char *s)
{
  4c:	55                   	push   %ebp
  4d:	89 e5                	mov    %esp,%ebp
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  52:	b8 00 00 00 00       	mov    $0x0,%eax
  57:	eb 03                	jmp    5c <strlen+0x10>
  59:	83 c0 01             	add    $0x1,%eax
  5c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  60:	75 f7                	jne    59 <strlen+0xd>
    ;
  return n;
}
  62:	5d                   	pop    %ebp
  63:	c3                   	ret    

00000064 <memset>:

void*
memset(void *dst, int c, uint n)
{
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	57                   	push   %edi
  68:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  6b:	89 d7                	mov    %edx,%edi
  6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	fc                   	cld    
  74:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  76:	89 d0                	mov    %edx,%eax
  78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  7b:	c9                   	leave  
  7c:	c3                   	ret    

0000007d <strchr>:

char*
strchr(const char *s, char c)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  80:	8b 45 08             	mov    0x8(%ebp),%eax
  83:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  87:	eb 03                	jmp    8c <strchr+0xf>
  89:	83 c0 01             	add    $0x1,%eax
  8c:	0f b6 10             	movzbl (%eax),%edx
  8f:	84 d2                	test   %dl,%dl
  91:	74 06                	je     99 <strchr+0x1c>
    if(*s == c)
  93:	38 ca                	cmp    %cl,%dl
  95:	75 f2                	jne    89 <strchr+0xc>
  97:	eb 05                	jmp    9e <strchr+0x21>
      return (char*)s;
  return 0;
  99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <gets>:

char*
gets(char *buf, int max)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  a6:	83 ec 1c             	sub    $0x1c,%esp
  a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  b1:	89 de                	mov    %ebx,%esi
  b3:	83 c3 01             	add    $0x1,%ebx
  b6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  b9:	7d 2e                	jge    e9 <gets+0x49>
    cc = read(0, &c, 1);
  bb:	83 ec 04             	sub    $0x4,%esp
  be:	6a 01                	push   $0x1
  c0:	8d 45 e7             	lea    -0x19(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	6a 00                	push   $0x0
  c6:	e8 ec 00 00 00       	call   1b7 <read>
    if(cc < 1)
  cb:	83 c4 10             	add    $0x10,%esp
  ce:	85 c0                	test   %eax,%eax
  d0:	7e 17                	jle    e9 <gets+0x49>
      break;
    buf[i++] = c;
  d2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  d6:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
  d9:	3c 0a                	cmp    $0xa,%al
  db:	0f 94 c2             	sete   %dl
  de:	3c 0d                	cmp    $0xd,%al
  e0:	0f 94 c0             	sete   %al
  e3:	08 c2                	or     %al,%dl
  e5:	74 ca                	je     b1 <gets+0x11>
    buf[i++] = c;
  e7:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
  e9:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
  ed:	89 f8                	mov    %edi,%eax
  ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  f2:	5b                   	pop    %ebx
  f3:	5e                   	pop    %esi
  f4:	5f                   	pop    %edi
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    

000000f7 <stat>:

int
stat(const char *n, struct stat *st)
{
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	56                   	push   %esi
  fb:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  fc:	83 ec 08             	sub    $0x8,%esp
  ff:	6a 00                	push   $0x0
 101:	ff 75 08             	push   0x8(%ebp)
 104:	e8 d6 00 00 00       	call   1df <open>
  if(fd < 0)
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	78 24                	js     134 <stat+0x3d>
 110:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 112:	83 ec 08             	sub    $0x8,%esp
 115:	ff 75 0c             	push   0xc(%ebp)
 118:	50                   	push   %eax
 119:	e8 d9 00 00 00       	call   1f7 <fstat>
 11e:	89 c6                	mov    %eax,%esi
  close(fd);
 120:	89 1c 24             	mov    %ebx,(%esp)
 123:	e8 9f 00 00 00       	call   1c7 <close>
  return r;
 128:	83 c4 10             	add    $0x10,%esp
}
 12b:	89 f0                	mov    %esi,%eax
 12d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 130:	5b                   	pop    %ebx
 131:	5e                   	pop    %esi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    
    return -1;
 134:	be ff ff ff ff       	mov    $0xffffffff,%esi
 139:	eb f0                	jmp    12b <stat+0x34>

0000013b <atoi>:

int
atoi(const char *s)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	53                   	push   %ebx
 13f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 142:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 147:	eb 10                	jmp    159 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 149:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 14c:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 14f:	83 c1 01             	add    $0x1,%ecx
 152:	0f be c0             	movsbl %al,%eax
 155:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 159:	0f b6 01             	movzbl (%ecx),%eax
 15c:	8d 58 d0             	lea    -0x30(%eax),%ebx
 15f:	80 fb 09             	cmp    $0x9,%bl
 162:	76 e5                	jbe    149 <atoi+0xe>
  return n;
}
 164:	89 d0                	mov    %edx,%eax
 166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 169:	c9                   	leave  
 16a:	c3                   	ret    

0000016b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	56                   	push   %esi
 16f:	53                   	push   %ebx
 170:	8b 75 08             	mov    0x8(%ebp),%esi
 173:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 176:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 179:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 17b:	eb 0d                	jmp    18a <memmove+0x1f>
    *dst++ = *src++;
 17d:	0f b6 01             	movzbl (%ecx),%eax
 180:	88 02                	mov    %al,(%edx)
 182:	8d 49 01             	lea    0x1(%ecx),%ecx
 185:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 188:	89 d8                	mov    %ebx,%eax
 18a:	8d 58 ff             	lea    -0x1(%eax),%ebx
 18d:	85 c0                	test   %eax,%eax
 18f:	7f ec                	jg     17d <memmove+0x12>
  return vdst;
}
 191:	89 f0                	mov    %esi,%eax
 193:	5b                   	pop    %ebx
 194:	5e                   	pop    %esi
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    

00000197 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 197:	b8 01 00 00 00       	mov    $0x1,%eax
 19c:	cd 40                	int    $0x40
 19e:	c3                   	ret    

0000019f <exit>:
SYSCALL(exit)
 19f:	b8 02 00 00 00       	mov    $0x2,%eax
 1a4:	cd 40                	int    $0x40
 1a6:	c3                   	ret    

000001a7 <wait>:
SYSCALL(wait)
 1a7:	b8 03 00 00 00       	mov    $0x3,%eax
 1ac:	cd 40                	int    $0x40
 1ae:	c3                   	ret    

000001af <pipe>:
SYSCALL(pipe)
 1af:	b8 04 00 00 00       	mov    $0x4,%eax
 1b4:	cd 40                	int    $0x40
 1b6:	c3                   	ret    

000001b7 <read>:
SYSCALL(read)
 1b7:	b8 05 00 00 00       	mov    $0x5,%eax
 1bc:	cd 40                	int    $0x40
 1be:	c3                   	ret    

000001bf <write>:
SYSCALL(write)
 1bf:	b8 10 00 00 00       	mov    $0x10,%eax
 1c4:	cd 40                	int    $0x40
 1c6:	c3                   	ret    

000001c7 <close>:
SYSCALL(close)
 1c7:	b8 15 00 00 00       	mov    $0x15,%eax
 1cc:	cd 40                	int    $0x40
 1ce:	c3                   	ret    

000001cf <kill>:
SYSCALL(kill)
 1cf:	b8 06 00 00 00       	mov    $0x6,%eax
 1d4:	cd 40                	int    $0x40
 1d6:	c3                   	ret    

000001d7 <exec>:
SYSCALL(exec)
 1d7:	b8 07 00 00 00       	mov    $0x7,%eax
 1dc:	cd 40                	int    $0x40
 1de:	c3                   	ret    

000001df <open>:
SYSCALL(open)
 1df:	b8 0f 00 00 00       	mov    $0xf,%eax
 1e4:	cd 40                	int    $0x40
 1e6:	c3                   	ret    

000001e7 <mknod>:
SYSCALL(mknod)
 1e7:	b8 11 00 00 00       	mov    $0x11,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret    

000001ef <unlink>:
SYSCALL(unlink)
 1ef:	b8 12 00 00 00       	mov    $0x12,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret    

000001f7 <fstat>:
SYSCALL(fstat)
 1f7:	b8 08 00 00 00       	mov    $0x8,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <link>:
SYSCALL(link)
 1ff:	b8 13 00 00 00       	mov    $0x13,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <mkdir>:
SYSCALL(mkdir)
 207:	b8 14 00 00 00       	mov    $0x14,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <chdir>:
SYSCALL(chdir)
 20f:	b8 09 00 00 00       	mov    $0x9,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <dup>:
SYSCALL(dup)
 217:	b8 0a 00 00 00       	mov    $0xa,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <getpid>:
SYSCALL(getpid)
 21f:	b8 0b 00 00 00       	mov    $0xb,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <sbrk>:
SYSCALL(sbrk)
 227:	b8 0c 00 00 00       	mov    $0xc,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <sleep>:
SYSCALL(sleep)
 22f:	b8 0d 00 00 00       	mov    $0xd,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <uptime>:
SYSCALL(uptime)
 237:	b8 0e 00 00 00       	mov    $0xe,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <settickets>:
SYSCALL(settickets)
 23f:	b8 16 00 00 00       	mov    $0x16,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <getpinfo>:
SYSCALL(getpinfo)
 247:	b8 17 00 00 00       	mov    $0x17,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <mprotect>:
SYSCALL(mprotect)
 24f:	b8 18 00 00 00       	mov    $0x18,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <munprotect>:
SYSCALL(munprotect)
 257:	b8 19 00 00 00       	mov    $0x19,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 25f:	55                   	push   %ebp
 260:	89 e5                	mov    %esp,%ebp
 262:	83 ec 1c             	sub    $0x1c,%esp
 265:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 268:	6a 01                	push   $0x1
 26a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 26d:	52                   	push   %edx
 26e:	50                   	push   %eax
 26f:	e8 4b ff ff ff       	call   1bf <write>
}
 274:	83 c4 10             	add    $0x10,%esp
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	57                   	push   %edi
 27d:	56                   	push   %esi
 27e:	53                   	push   %ebx
 27f:	83 ec 2c             	sub    $0x2c,%esp
 282:	89 45 d0             	mov    %eax,-0x30(%ebp)
 285:	89 d0                	mov    %edx,%eax
 287:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 28d:	0f 95 c1             	setne  %cl
 290:	c1 ea 1f             	shr    $0x1f,%edx
 293:	84 d1                	test   %dl,%cl
 295:	74 44                	je     2db <printint+0x62>
    neg = 1;
    x = -xx;
 297:	f7 d8                	neg    %eax
 299:	89 c1                	mov    %eax,%ecx
    neg = 1;
 29b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2a7:	89 c8                	mov    %ecx,%eax
 2a9:	ba 00 00 00 00       	mov    $0x0,%edx
 2ae:	f7 f6                	div    %esi
 2b0:	89 df                	mov    %ebx,%edi
 2b2:	83 c3 01             	add    $0x1,%ebx
 2b5:	0f b6 92 14 06 00 00 	movzbl 0x614(%edx),%edx
 2bc:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2c0:	89 ca                	mov    %ecx,%edx
 2c2:	89 c1                	mov    %eax,%ecx
 2c4:	39 d6                	cmp    %edx,%esi
 2c6:	76 df                	jbe    2a7 <printint+0x2e>
  if(neg)
 2c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 2cc:	74 31                	je     2ff <printint+0x86>
    buf[i++] = '-';
 2ce:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2d3:	8d 5f 02             	lea    0x2(%edi),%ebx
 2d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
 2d9:	eb 17                	jmp    2f2 <printint+0x79>
    x = xx;
 2db:	89 c1                	mov    %eax,%ecx
  neg = 0;
 2dd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 2e4:	eb bc                	jmp    2a2 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 2e6:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 2eb:	89 f0                	mov    %esi,%eax
 2ed:	e8 6d ff ff ff       	call   25f <putc>
  while(--i >= 0)
 2f2:	83 eb 01             	sub    $0x1,%ebx
 2f5:	79 ef                	jns    2e6 <printint+0x6d>
}
 2f7:	83 c4 2c             	add    $0x2c,%esp
 2fa:	5b                   	pop    %ebx
 2fb:	5e                   	pop    %esi
 2fc:	5f                   	pop    %edi
 2fd:	5d                   	pop    %ebp
 2fe:	c3                   	ret    
 2ff:	8b 75 d0             	mov    -0x30(%ebp),%esi
 302:	eb ee                	jmp    2f2 <printint+0x79>

00000304 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	57                   	push   %edi
 308:	56                   	push   %esi
 309:	53                   	push   %ebx
 30a:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 30d:	8d 45 10             	lea    0x10(%ebp),%eax
 310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 313:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 318:	bb 00 00 00 00       	mov    $0x0,%ebx
 31d:	eb 14                	jmp    333 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 31f:	89 fa                	mov    %edi,%edx
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	e8 36 ff ff ff       	call   25f <putc>
 329:	eb 05                	jmp    330 <printf+0x2c>
      }
    } else if(state == '%'){
 32b:	83 fe 25             	cmp    $0x25,%esi
 32e:	74 25                	je     355 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 330:	83 c3 01             	add    $0x1,%ebx
 333:	8b 45 0c             	mov    0xc(%ebp),%eax
 336:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 33a:	84 c0                	test   %al,%al
 33c:	0f 84 20 01 00 00    	je     462 <printf+0x15e>
    c = fmt[i] & 0xff;
 342:	0f be f8             	movsbl %al,%edi
 345:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 348:	85 f6                	test   %esi,%esi
 34a:	75 df                	jne    32b <printf+0x27>
      if(c == '%'){
 34c:	83 f8 25             	cmp    $0x25,%eax
 34f:	75 ce                	jne    31f <printf+0x1b>
        state = '%';
 351:	89 c6                	mov    %eax,%esi
 353:	eb db                	jmp    330 <printf+0x2c>
      if(c == 'd'){
 355:	83 f8 25             	cmp    $0x25,%eax
 358:	0f 84 cf 00 00 00    	je     42d <printf+0x129>
 35e:	0f 8c dd 00 00 00    	jl     441 <printf+0x13d>
 364:	83 f8 78             	cmp    $0x78,%eax
 367:	0f 8f d4 00 00 00    	jg     441 <printf+0x13d>
 36d:	83 f8 63             	cmp    $0x63,%eax
 370:	0f 8c cb 00 00 00    	jl     441 <printf+0x13d>
 376:	83 e8 63             	sub    $0x63,%eax
 379:	83 f8 15             	cmp    $0x15,%eax
 37c:	0f 87 bf 00 00 00    	ja     441 <printf+0x13d>
 382:	ff 24 85 bc 05 00 00 	jmp    *0x5bc(,%eax,4)
        printint(fd, *ap, 10, 1);
 389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 38c:	8b 17                	mov    (%edi),%edx
 38e:	83 ec 0c             	sub    $0xc,%esp
 391:	6a 01                	push   $0x1
 393:	b9 0a 00 00 00       	mov    $0xa,%ecx
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	e8 d9 fe ff ff       	call   279 <printint>
        ap++;
 3a0:	83 c7 04             	add    $0x4,%edi
 3a3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3a6:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3a9:	be 00 00 00 00       	mov    $0x0,%esi
 3ae:	eb 80                	jmp    330 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3b3:	8b 17                	mov    (%edi),%edx
 3b5:	83 ec 0c             	sub    $0xc,%esp
 3b8:	6a 00                	push   $0x0
 3ba:	b9 10 00 00 00       	mov    $0x10,%ecx
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	e8 b2 fe ff ff       	call   279 <printint>
        ap++;
 3c7:	83 c7 04             	add    $0x4,%edi
 3ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3cd:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3d0:	be 00 00 00 00       	mov    $0x0,%esi
 3d5:	e9 56 ff ff ff       	jmp    330 <printf+0x2c>
        s = (char*)*ap;
 3da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3dd:	8b 30                	mov    (%eax),%esi
        ap++;
 3df:	83 c0 04             	add    $0x4,%eax
 3e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 3e5:	85 f6                	test   %esi,%esi
 3e7:	75 15                	jne    3fe <printf+0xfa>
          s = "(null)";
 3e9:	be b4 05 00 00       	mov    $0x5b4,%esi
 3ee:	eb 0e                	jmp    3fe <printf+0xfa>
          putc(fd, *s);
 3f0:	0f be d2             	movsbl %dl,%edx
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	e8 64 fe ff ff       	call   25f <putc>
          s++;
 3fb:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 3fe:	0f b6 16             	movzbl (%esi),%edx
 401:	84 d2                	test   %dl,%dl
 403:	75 eb                	jne    3f0 <printf+0xec>
      state = 0;
 405:	be 00 00 00 00       	mov    $0x0,%esi
 40a:	e9 21 ff ff ff       	jmp    330 <printf+0x2c>
        putc(fd, *ap);
 40f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 412:	0f be 17             	movsbl (%edi),%edx
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	e8 42 fe ff ff       	call   25f <putc>
        ap++;
 41d:	83 c7 04             	add    $0x4,%edi
 420:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 423:	be 00 00 00 00       	mov    $0x0,%esi
 428:	e9 03 ff ff ff       	jmp    330 <printf+0x2c>
        putc(fd, c);
 42d:	89 fa                	mov    %edi,%edx
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	e8 28 fe ff ff       	call   25f <putc>
      state = 0;
 437:	be 00 00 00 00       	mov    $0x0,%esi
 43c:	e9 ef fe ff ff       	jmp    330 <printf+0x2c>
        putc(fd, '%');
 441:	ba 25 00 00 00       	mov    $0x25,%edx
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	e8 11 fe ff ff       	call   25f <putc>
        putc(fd, c);
 44e:	89 fa                	mov    %edi,%edx
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	e8 07 fe ff ff       	call   25f <putc>
      state = 0;
 458:	be 00 00 00 00       	mov    $0x0,%esi
 45d:	e9 ce fe ff ff       	jmp    330 <printf+0x2c>
    }
  }
}
 462:	8d 65 f4             	lea    -0xc(%ebp),%esp
 465:	5b                   	pop    %ebx
 466:	5e                   	pop    %esi
 467:	5f                   	pop    %edi
 468:	5d                   	pop    %ebp
 469:	c3                   	ret    

0000046a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	57                   	push   %edi
 46e:	56                   	push   %esi
 46f:	53                   	push   %ebx
 470:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 473:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 476:	a1 90 08 00 00       	mov    0x890,%eax
 47b:	eb 02                	jmp    47f <free+0x15>
 47d:	89 d0                	mov    %edx,%eax
 47f:	39 c8                	cmp    %ecx,%eax
 481:	73 04                	jae    487 <free+0x1d>
 483:	39 08                	cmp    %ecx,(%eax)
 485:	77 12                	ja     499 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 487:	8b 10                	mov    (%eax),%edx
 489:	39 c2                	cmp    %eax,%edx
 48b:	77 f0                	ja     47d <free+0x13>
 48d:	39 c8                	cmp    %ecx,%eax
 48f:	72 08                	jb     499 <free+0x2f>
 491:	39 ca                	cmp    %ecx,%edx
 493:	77 04                	ja     499 <free+0x2f>
 495:	89 d0                	mov    %edx,%eax
 497:	eb e6                	jmp    47f <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 499:	8b 73 fc             	mov    -0x4(%ebx),%esi
 49c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 49f:	8b 10                	mov    (%eax),%edx
 4a1:	39 d7                	cmp    %edx,%edi
 4a3:	74 19                	je     4be <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4a5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4a8:	8b 50 04             	mov    0x4(%eax),%edx
 4ab:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4ae:	39 ce                	cmp    %ecx,%esi
 4b0:	74 1b                	je     4cd <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4b2:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4b4:	a3 90 08 00 00       	mov    %eax,0x890
}
 4b9:	5b                   	pop    %ebx
 4ba:	5e                   	pop    %esi
 4bb:	5f                   	pop    %edi
 4bc:	5d                   	pop    %ebp
 4bd:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4be:	03 72 04             	add    0x4(%edx),%esi
 4c1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4c4:	8b 10                	mov    (%eax),%edx
 4c6:	8b 12                	mov    (%edx),%edx
 4c8:	89 53 f8             	mov    %edx,-0x8(%ebx)
 4cb:	eb db                	jmp    4a8 <free+0x3e>
    p->s.size += bp->s.size;
 4cd:	03 53 fc             	add    -0x4(%ebx),%edx
 4d0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 4d3:	8b 53 f8             	mov    -0x8(%ebx),%edx
 4d6:	89 10                	mov    %edx,(%eax)
 4d8:	eb da                	jmp    4b4 <free+0x4a>

000004da <morecore>:

static Header*
morecore(uint nu)
{
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	53                   	push   %ebx
 4de:	83 ec 04             	sub    $0x4,%esp
 4e1:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 4e3:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 4e8:	77 05                	ja     4ef <morecore+0x15>
    nu = 4096;
 4ea:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 4ef:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 4f6:	83 ec 0c             	sub    $0xc,%esp
 4f9:	50                   	push   %eax
 4fa:	e8 28 fd ff ff       	call   227 <sbrk>
  if(p == (char*)-1)
 4ff:	83 c4 10             	add    $0x10,%esp
 502:	83 f8 ff             	cmp    $0xffffffff,%eax
 505:	74 1c                	je     523 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 507:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 50a:	83 c0 08             	add    $0x8,%eax
 50d:	83 ec 0c             	sub    $0xc,%esp
 510:	50                   	push   %eax
 511:	e8 54 ff ff ff       	call   46a <free>
  return freep;
 516:	a1 90 08 00 00       	mov    0x890,%eax
 51b:	83 c4 10             	add    $0x10,%esp
}
 51e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 521:	c9                   	leave  
 522:	c3                   	ret    
    return 0;
 523:	b8 00 00 00 00       	mov    $0x0,%eax
 528:	eb f4                	jmp    51e <morecore+0x44>

0000052a <malloc>:

void*
malloc(uint nbytes)
{
 52a:	55                   	push   %ebp
 52b:	89 e5                	mov    %esp,%ebp
 52d:	53                   	push   %ebx
 52e:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	8d 58 07             	lea    0x7(%eax),%ebx
 537:	c1 eb 03             	shr    $0x3,%ebx
 53a:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 53d:	8b 0d 90 08 00 00    	mov    0x890,%ecx
 543:	85 c9                	test   %ecx,%ecx
 545:	74 04                	je     54b <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 547:	8b 01                	mov    (%ecx),%eax
 549:	eb 4a                	jmp    595 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 54b:	c7 05 90 08 00 00 94 	movl   $0x894,0x890
 552:	08 00 00 
 555:	c7 05 94 08 00 00 94 	movl   $0x894,0x894
 55c:	08 00 00 
    base.s.size = 0;
 55f:	c7 05 98 08 00 00 00 	movl   $0x0,0x898
 566:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 569:	b9 94 08 00 00       	mov    $0x894,%ecx
 56e:	eb d7                	jmp    547 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 570:	74 19                	je     58b <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 572:	29 da                	sub    %ebx,%edx
 574:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 577:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 57a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 57d:	89 0d 90 08 00 00    	mov    %ecx,0x890
      return (void*)(p + 1);
 583:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 589:	c9                   	leave  
 58a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 58b:	8b 10                	mov    (%eax),%edx
 58d:	89 11                	mov    %edx,(%ecx)
 58f:	eb ec                	jmp    57d <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 591:	89 c1                	mov    %eax,%ecx
 593:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 595:	8b 50 04             	mov    0x4(%eax),%edx
 598:	39 da                	cmp    %ebx,%edx
 59a:	73 d4                	jae    570 <malloc+0x46>
    if(p == freep)
 59c:	39 05 90 08 00 00    	cmp    %eax,0x890
 5a2:	75 ed                	jne    591 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5a4:	89 d8                	mov    %ebx,%eax
 5a6:	e8 2f ff ff ff       	call   4da <morecore>
 5ab:	85 c0                	test   %eax,%eax
 5ad:	75 e2                	jne    591 <malloc+0x67>
 5af:	eb d5                	jmp    586 <malloc+0x5c>
