
_test_3:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "pstat.h"

int
main(int argc, char *argv[])
{  
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 10             	sub    $0x10,%esp
  if(settickets(0) == 0)
  11:	6a 00                	push   $0x0
  13:	e8 71 02 00 00       	call   289 <settickets>
  18:	83 c4 10             	add    $0x10,%esp
  1b:	85 c0                	test   %eax,%eax
  1d:	75 17                	jne    36 <main+0x36>
  {
   printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  1f:	83 ec 08             	sub    $0x8,%esp
  22:	68 fc 05 00 00       	push   $0x5fc
  27:	6a 01                	push   $0x1
  29:	e8 20 03 00 00       	call   34e <printf>
  2e:	83 c4 10             	add    $0x10,%esp
  }
  else
  {
   printf(1, "XV6_SCHEDULER\t FAILED\n");
  }
   exit();
  31:	e8 b3 01 00 00       	call   1e9 <exit>
   printf(1, "XV6_SCHEDULER\t FAILED\n");
  36:	83 ec 08             	sub    $0x8,%esp
  39:	68 14 06 00 00       	push   $0x614
  3e:	6a 01                	push   $0x1
  40:	e8 09 03 00 00       	call   34e <printf>
  45:	83 c4 10             	add    $0x10,%esp
  48:	eb e7                	jmp    31 <main+0x31>

0000004a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  4a:	55                   	push   %ebp
  4b:	89 e5                	mov    %esp,%ebp
  4d:	56                   	push   %esi
  4e:	53                   	push   %ebx
  4f:	8b 75 08             	mov    0x8(%ebp),%esi
  52:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  55:	89 f0                	mov    %esi,%eax
  57:	89 d1                	mov    %edx,%ecx
  59:	83 c2 01             	add    $0x1,%edx
  5c:	89 c3                	mov    %eax,%ebx
  5e:	83 c0 01             	add    $0x1,%eax
  61:	0f b6 09             	movzbl (%ecx),%ecx
  64:	88 0b                	mov    %cl,(%ebx)
  66:	84 c9                	test   %cl,%cl
  68:	75 ed                	jne    57 <strcpy+0xd>
    ;
  return os;
}
  6a:	89 f0                	mov    %esi,%eax
  6c:	5b                   	pop    %ebx
  6d:	5e                   	pop    %esi
  6e:	5d                   	pop    %ebp
  6f:	c3                   	ret    

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  76:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  79:	eb 06                	jmp    81 <strcmp+0x11>
    p++, q++;
  7b:	83 c1 01             	add    $0x1,%ecx
  7e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  81:	0f b6 01             	movzbl (%ecx),%eax
  84:	84 c0                	test   %al,%al
  86:	74 04                	je     8c <strcmp+0x1c>
  88:	3a 02                	cmp    (%edx),%al
  8a:	74 ef                	je     7b <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  8c:	0f b6 c0             	movzbl %al,%eax
  8f:	0f b6 12             	movzbl (%edx),%edx
  92:	29 d0                	sub    %edx,%eax
}
  94:	5d                   	pop    %ebp
  95:	c3                   	ret    

00000096 <strlen>:

uint
strlen(const char *s)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  9c:	b8 00 00 00 00       	mov    $0x0,%eax
  a1:	eb 03                	jmp    a6 <strlen+0x10>
  a3:	83 c0 01             	add    $0x1,%eax
  a6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  aa:	75 f7                	jne    a3 <strlen+0xd>
    ;
  return n;
}
  ac:	5d                   	pop    %ebp
  ad:	c3                   	ret    

000000ae <memset>:

void*
memset(void *dst, int c, uint n)
{
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	57                   	push   %edi
  b2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b5:	89 d7                	mov    %edx,%edi
  b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  bd:	fc                   	cld    
  be:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c0:	89 d0                	mov    %edx,%eax
  c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  c5:	c9                   	leave  
  c6:	c3                   	ret    

000000c7 <strchr>:

char*
strchr(const char *s, char c)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d1:	eb 03                	jmp    d6 <strchr+0xf>
  d3:	83 c0 01             	add    $0x1,%eax
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	84 d2                	test   %dl,%dl
  db:	74 06                	je     e3 <strchr+0x1c>
    if(*s == c)
  dd:	38 ca                	cmp    %cl,%dl
  df:	75 f2                	jne    d3 <strchr+0xc>
  e1:	eb 05                	jmp    e8 <strchr+0x21>
      return (char*)s;
  return 0;
  e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <gets>:

char*
gets(char *buf, int max)
{
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	57                   	push   %edi
  ee:	56                   	push   %esi
  ef:	53                   	push   %ebx
  f0:	83 ec 1c             	sub    $0x1c,%esp
  f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  fb:	89 de                	mov    %ebx,%esi
  fd:	83 c3 01             	add    $0x1,%ebx
 100:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 103:	7d 2e                	jge    133 <gets+0x49>
    cc = read(0, &c, 1);
 105:	83 ec 04             	sub    $0x4,%esp
 108:	6a 01                	push   $0x1
 10a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 10d:	50                   	push   %eax
 10e:	6a 00                	push   $0x0
 110:	e8 ec 00 00 00       	call   201 <read>
    if(cc < 1)
 115:	83 c4 10             	add    $0x10,%esp
 118:	85 c0                	test   %eax,%eax
 11a:	7e 17                	jle    133 <gets+0x49>
      break;
    buf[i++] = c;
 11c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 120:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 123:	3c 0a                	cmp    $0xa,%al
 125:	0f 94 c2             	sete   %dl
 128:	3c 0d                	cmp    $0xd,%al
 12a:	0f 94 c0             	sete   %al
 12d:	08 c2                	or     %al,%dl
 12f:	74 ca                	je     fb <gets+0x11>
    buf[i++] = c;
 131:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 133:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 137:	89 f8                	mov    %edi,%eax
 139:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13c:	5b                   	pop    %ebx
 13d:	5e                   	pop    %esi
 13e:	5f                   	pop    %edi
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <stat>:

int
stat(const char *n, struct stat *st)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 146:	83 ec 08             	sub    $0x8,%esp
 149:	6a 00                	push   $0x0
 14b:	ff 75 08             	push   0x8(%ebp)
 14e:	e8 d6 00 00 00       	call   229 <open>
  if(fd < 0)
 153:	83 c4 10             	add    $0x10,%esp
 156:	85 c0                	test   %eax,%eax
 158:	78 24                	js     17e <stat+0x3d>
 15a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	ff 75 0c             	push   0xc(%ebp)
 162:	50                   	push   %eax
 163:	e8 d9 00 00 00       	call   241 <fstat>
 168:	89 c6                	mov    %eax,%esi
  close(fd);
 16a:	89 1c 24             	mov    %ebx,(%esp)
 16d:	e8 9f 00 00 00       	call   211 <close>
  return r;
 172:	83 c4 10             	add    $0x10,%esp
}
 175:	89 f0                	mov    %esi,%eax
 177:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17a:	5b                   	pop    %ebx
 17b:	5e                   	pop    %esi
 17c:	5d                   	pop    %ebp
 17d:	c3                   	ret    
    return -1;
 17e:	be ff ff ff ff       	mov    $0xffffffff,%esi
 183:	eb f0                	jmp    175 <stat+0x34>

00000185 <atoi>:

int
atoi(const char *s)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	53                   	push   %ebx
 189:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 18c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 191:	eb 10                	jmp    1a3 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 193:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 196:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 199:	83 c1 01             	add    $0x1,%ecx
 19c:	0f be c0             	movsbl %al,%eax
 19f:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1a3:	0f b6 01             	movzbl (%ecx),%eax
 1a6:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1a9:	80 fb 09             	cmp    $0x9,%bl
 1ac:	76 e5                	jbe    193 <atoi+0xe>
  return n;
}
 1ae:	89 d0                	mov    %edx,%eax
 1b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b3:	c9                   	leave  
 1b4:	c3                   	ret    

000001b5 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	8b 75 08             	mov    0x8(%ebp),%esi
 1bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c3:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1c5:	eb 0d                	jmp    1d4 <memmove+0x1f>
    *dst++ = *src++;
 1c7:	0f b6 01             	movzbl (%ecx),%eax
 1ca:	88 02                	mov    %al,(%edx)
 1cc:	8d 49 01             	lea    0x1(%ecx),%ecx
 1cf:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d2:	89 d8                	mov    %ebx,%eax
 1d4:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1d7:	85 c0                	test   %eax,%eax
 1d9:	7f ec                	jg     1c7 <memmove+0x12>
  return vdst;
}
 1db:	89 f0                	mov    %esi,%eax
 1dd:	5b                   	pop    %ebx
 1de:	5e                   	pop    %esi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e1:	b8 01 00 00 00       	mov    $0x1,%eax
 1e6:	cd 40                	int    $0x40
 1e8:	c3                   	ret    

000001e9 <exit>:
SYSCALL(exit)
 1e9:	b8 02 00 00 00       	mov    $0x2,%eax
 1ee:	cd 40                	int    $0x40
 1f0:	c3                   	ret    

000001f1 <wait>:
SYSCALL(wait)
 1f1:	b8 03 00 00 00       	mov    $0x3,%eax
 1f6:	cd 40                	int    $0x40
 1f8:	c3                   	ret    

000001f9 <pipe>:
SYSCALL(pipe)
 1f9:	b8 04 00 00 00       	mov    $0x4,%eax
 1fe:	cd 40                	int    $0x40
 200:	c3                   	ret    

00000201 <read>:
SYSCALL(read)
 201:	b8 05 00 00 00       	mov    $0x5,%eax
 206:	cd 40                	int    $0x40
 208:	c3                   	ret    

00000209 <write>:
SYSCALL(write)
 209:	b8 10 00 00 00       	mov    $0x10,%eax
 20e:	cd 40                	int    $0x40
 210:	c3                   	ret    

00000211 <close>:
SYSCALL(close)
 211:	b8 15 00 00 00       	mov    $0x15,%eax
 216:	cd 40                	int    $0x40
 218:	c3                   	ret    

00000219 <kill>:
SYSCALL(kill)
 219:	b8 06 00 00 00       	mov    $0x6,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	ret    

00000221 <exec>:
SYSCALL(exec)
 221:	b8 07 00 00 00       	mov    $0x7,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <open>:
SYSCALL(open)
 229:	b8 0f 00 00 00       	mov    $0xf,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <mknod>:
SYSCALL(mknod)
 231:	b8 11 00 00 00       	mov    $0x11,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <unlink>:
SYSCALL(unlink)
 239:	b8 12 00 00 00       	mov    $0x12,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <fstat>:
SYSCALL(fstat)
 241:	b8 08 00 00 00       	mov    $0x8,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <link>:
SYSCALL(link)
 249:	b8 13 00 00 00       	mov    $0x13,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <mkdir>:
SYSCALL(mkdir)
 251:	b8 14 00 00 00       	mov    $0x14,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <chdir>:
SYSCALL(chdir)
 259:	b8 09 00 00 00       	mov    $0x9,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <dup>:
SYSCALL(dup)
 261:	b8 0a 00 00 00       	mov    $0xa,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <getpid>:
SYSCALL(getpid)
 269:	b8 0b 00 00 00       	mov    $0xb,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <sbrk>:
SYSCALL(sbrk)
 271:	b8 0c 00 00 00       	mov    $0xc,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <sleep>:
SYSCALL(sleep)
 279:	b8 0d 00 00 00       	mov    $0xd,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <uptime>:
SYSCALL(uptime)
 281:	b8 0e 00 00 00       	mov    $0xe,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <settickets>:
SYSCALL(settickets)
 289:	b8 16 00 00 00       	mov    $0x16,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <getpinfo>:
SYSCALL(getpinfo)
 291:	b8 17 00 00 00       	mov    $0x17,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <mprotect>:
SYSCALL(mprotect)
 299:	b8 18 00 00 00       	mov    $0x18,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <munprotect>:
SYSCALL(munprotect)
 2a1:	b8 19 00 00 00       	mov    $0x19,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	83 ec 1c             	sub    $0x1c,%esp
 2af:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2b2:	6a 01                	push   $0x1
 2b4:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2b7:	52                   	push   %edx
 2b8:	50                   	push   %eax
 2b9:	e8 4b ff ff ff       	call   209 <write>
}
 2be:	83 c4 10             	add    $0x10,%esp
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	57                   	push   %edi
 2c7:	56                   	push   %esi
 2c8:	53                   	push   %ebx
 2c9:	83 ec 2c             	sub    $0x2c,%esp
 2cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2cf:	89 d0                	mov    %edx,%eax
 2d1:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d7:	0f 95 c1             	setne  %cl
 2da:	c1 ea 1f             	shr    $0x1f,%edx
 2dd:	84 d1                	test   %dl,%cl
 2df:	74 44                	je     325 <printint+0x62>
    neg = 1;
    x = -xx;
 2e1:	f7 d8                	neg    %eax
 2e3:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2e5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f1:	89 c8                	mov    %ecx,%eax
 2f3:	ba 00 00 00 00       	mov    $0x0,%edx
 2f8:	f7 f6                	div    %esi
 2fa:	89 df                	mov    %ebx,%edi
 2fc:	83 c3 01             	add    $0x1,%ebx
 2ff:	0f b6 92 8c 06 00 00 	movzbl 0x68c(%edx),%edx
 306:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 30a:	89 ca                	mov    %ecx,%edx
 30c:	89 c1                	mov    %eax,%ecx
 30e:	39 d6                	cmp    %edx,%esi
 310:	76 df                	jbe    2f1 <printint+0x2e>
  if(neg)
 312:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 316:	74 31                	je     349 <printint+0x86>
    buf[i++] = '-';
 318:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 31d:	8d 5f 02             	lea    0x2(%edi),%ebx
 320:	8b 75 d0             	mov    -0x30(%ebp),%esi
 323:	eb 17                	jmp    33c <printint+0x79>
    x = xx;
 325:	89 c1                	mov    %eax,%ecx
  neg = 0;
 327:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 32e:	eb bc                	jmp    2ec <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 330:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 335:	89 f0                	mov    %esi,%eax
 337:	e8 6d ff ff ff       	call   2a9 <putc>
  while(--i >= 0)
 33c:	83 eb 01             	sub    $0x1,%ebx
 33f:	79 ef                	jns    330 <printint+0x6d>
}
 341:	83 c4 2c             	add    $0x2c,%esp
 344:	5b                   	pop    %ebx
 345:	5e                   	pop    %esi
 346:	5f                   	pop    %edi
 347:	5d                   	pop    %ebp
 348:	c3                   	ret    
 349:	8b 75 d0             	mov    -0x30(%ebp),%esi
 34c:	eb ee                	jmp    33c <printint+0x79>

0000034e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	57                   	push   %edi
 352:	56                   	push   %esi
 353:	53                   	push   %ebx
 354:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 357:	8d 45 10             	lea    0x10(%ebp),%eax
 35a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 35d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 362:	bb 00 00 00 00       	mov    $0x0,%ebx
 367:	eb 14                	jmp    37d <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 369:	89 fa                	mov    %edi,%edx
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	e8 36 ff ff ff       	call   2a9 <putc>
 373:	eb 05                	jmp    37a <printf+0x2c>
      }
    } else if(state == '%'){
 375:	83 fe 25             	cmp    $0x25,%esi
 378:	74 25                	je     39f <printf+0x51>
  for(i = 0; fmt[i]; i++){
 37a:	83 c3 01             	add    $0x1,%ebx
 37d:	8b 45 0c             	mov    0xc(%ebp),%eax
 380:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 384:	84 c0                	test   %al,%al
 386:	0f 84 20 01 00 00    	je     4ac <printf+0x15e>
    c = fmt[i] & 0xff;
 38c:	0f be f8             	movsbl %al,%edi
 38f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 392:	85 f6                	test   %esi,%esi
 394:	75 df                	jne    375 <printf+0x27>
      if(c == '%'){
 396:	83 f8 25             	cmp    $0x25,%eax
 399:	75 ce                	jne    369 <printf+0x1b>
        state = '%';
 39b:	89 c6                	mov    %eax,%esi
 39d:	eb db                	jmp    37a <printf+0x2c>
      if(c == 'd'){
 39f:	83 f8 25             	cmp    $0x25,%eax
 3a2:	0f 84 cf 00 00 00    	je     477 <printf+0x129>
 3a8:	0f 8c dd 00 00 00    	jl     48b <printf+0x13d>
 3ae:	83 f8 78             	cmp    $0x78,%eax
 3b1:	0f 8f d4 00 00 00    	jg     48b <printf+0x13d>
 3b7:	83 f8 63             	cmp    $0x63,%eax
 3ba:	0f 8c cb 00 00 00    	jl     48b <printf+0x13d>
 3c0:	83 e8 63             	sub    $0x63,%eax
 3c3:	83 f8 15             	cmp    $0x15,%eax
 3c6:	0f 87 bf 00 00 00    	ja     48b <printf+0x13d>
 3cc:	ff 24 85 34 06 00 00 	jmp    *0x634(,%eax,4)
        printint(fd, *ap, 10, 1);
 3d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d6:	8b 17                	mov    (%edi),%edx
 3d8:	83 ec 0c             	sub    $0xc,%esp
 3db:	6a 01                	push   $0x1
 3dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	e8 d9 fe ff ff       	call   2c3 <printint>
        ap++;
 3ea:	83 c7 04             	add    $0x4,%edi
 3ed:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f0:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3f3:	be 00 00 00 00       	mov    $0x0,%esi
 3f8:	eb 80                	jmp    37a <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3fd:	8b 17                	mov    (%edi),%edx
 3ff:	83 ec 0c             	sub    $0xc,%esp
 402:	6a 00                	push   $0x0
 404:	b9 10 00 00 00       	mov    $0x10,%ecx
 409:	8b 45 08             	mov    0x8(%ebp),%eax
 40c:	e8 b2 fe ff ff       	call   2c3 <printint>
        ap++;
 411:	83 c7 04             	add    $0x4,%edi
 414:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 417:	83 c4 10             	add    $0x10,%esp
      state = 0;
 41a:	be 00 00 00 00       	mov    $0x0,%esi
 41f:	e9 56 ff ff ff       	jmp    37a <printf+0x2c>
        s = (char*)*ap;
 424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 427:	8b 30                	mov    (%eax),%esi
        ap++;
 429:	83 c0 04             	add    $0x4,%eax
 42c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 42f:	85 f6                	test   %esi,%esi
 431:	75 15                	jne    448 <printf+0xfa>
          s = "(null)";
 433:	be 2b 06 00 00       	mov    $0x62b,%esi
 438:	eb 0e                	jmp    448 <printf+0xfa>
          putc(fd, *s);
 43a:	0f be d2             	movsbl %dl,%edx
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	e8 64 fe ff ff       	call   2a9 <putc>
          s++;
 445:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 448:	0f b6 16             	movzbl (%esi),%edx
 44b:	84 d2                	test   %dl,%dl
 44d:	75 eb                	jne    43a <printf+0xec>
      state = 0;
 44f:	be 00 00 00 00       	mov    $0x0,%esi
 454:	e9 21 ff ff ff       	jmp    37a <printf+0x2c>
        putc(fd, *ap);
 459:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 45c:	0f be 17             	movsbl (%edi),%edx
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	e8 42 fe ff ff       	call   2a9 <putc>
        ap++;
 467:	83 c7 04             	add    $0x4,%edi
 46a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 46d:	be 00 00 00 00       	mov    $0x0,%esi
 472:	e9 03 ff ff ff       	jmp    37a <printf+0x2c>
        putc(fd, c);
 477:	89 fa                	mov    %edi,%edx
 479:	8b 45 08             	mov    0x8(%ebp),%eax
 47c:	e8 28 fe ff ff       	call   2a9 <putc>
      state = 0;
 481:	be 00 00 00 00       	mov    $0x0,%esi
 486:	e9 ef fe ff ff       	jmp    37a <printf+0x2c>
        putc(fd, '%');
 48b:	ba 25 00 00 00       	mov    $0x25,%edx
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	e8 11 fe ff ff       	call   2a9 <putc>
        putc(fd, c);
 498:	89 fa                	mov    %edi,%edx
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	e8 07 fe ff ff       	call   2a9 <putc>
      state = 0;
 4a2:	be 00 00 00 00       	mov    $0x0,%esi
 4a7:	e9 ce fe ff ff       	jmp    37a <printf+0x2c>
    }
  }
}
 4ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4af:	5b                   	pop    %ebx
 4b0:	5e                   	pop    %esi
 4b1:	5f                   	pop    %edi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    

000004b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	57                   	push   %edi
 4b8:	56                   	push   %esi
 4b9:	53                   	push   %ebx
 4ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4bd:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c0:	a1 2c 09 00 00       	mov    0x92c,%eax
 4c5:	eb 02                	jmp    4c9 <free+0x15>
 4c7:	89 d0                	mov    %edx,%eax
 4c9:	39 c8                	cmp    %ecx,%eax
 4cb:	73 04                	jae    4d1 <free+0x1d>
 4cd:	39 08                	cmp    %ecx,(%eax)
 4cf:	77 12                	ja     4e3 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d1:	8b 10                	mov    (%eax),%edx
 4d3:	39 c2                	cmp    %eax,%edx
 4d5:	77 f0                	ja     4c7 <free+0x13>
 4d7:	39 c8                	cmp    %ecx,%eax
 4d9:	72 08                	jb     4e3 <free+0x2f>
 4db:	39 ca                	cmp    %ecx,%edx
 4dd:	77 04                	ja     4e3 <free+0x2f>
 4df:	89 d0                	mov    %edx,%eax
 4e1:	eb e6                	jmp    4c9 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4e3:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4e6:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4e9:	8b 10                	mov    (%eax),%edx
 4eb:	39 d7                	cmp    %edx,%edi
 4ed:	74 19                	je     508 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4ef:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4f2:	8b 50 04             	mov    0x4(%eax),%edx
 4f5:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4f8:	39 ce                	cmp    %ecx,%esi
 4fa:	74 1b                	je     517 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4fc:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4fe:	a3 2c 09 00 00       	mov    %eax,0x92c
}
 503:	5b                   	pop    %ebx
 504:	5e                   	pop    %esi
 505:	5f                   	pop    %edi
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 508:	03 72 04             	add    0x4(%edx),%esi
 50b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 50e:	8b 10                	mov    (%eax),%edx
 510:	8b 12                	mov    (%edx),%edx
 512:	89 53 f8             	mov    %edx,-0x8(%ebx)
 515:	eb db                	jmp    4f2 <free+0x3e>
    p->s.size += bp->s.size;
 517:	03 53 fc             	add    -0x4(%ebx),%edx
 51a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 51d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 520:	89 10                	mov    %edx,(%eax)
 522:	eb da                	jmp    4fe <free+0x4a>

00000524 <morecore>:

static Header*
morecore(uint nu)
{
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	53                   	push   %ebx
 528:	83 ec 04             	sub    $0x4,%esp
 52b:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 52d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 532:	77 05                	ja     539 <morecore+0x15>
    nu = 4096;
 534:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 539:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	50                   	push   %eax
 544:	e8 28 fd ff ff       	call   271 <sbrk>
  if(p == (char*)-1)
 549:	83 c4 10             	add    $0x10,%esp
 54c:	83 f8 ff             	cmp    $0xffffffff,%eax
 54f:	74 1c                	je     56d <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 551:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 554:	83 c0 08             	add    $0x8,%eax
 557:	83 ec 0c             	sub    $0xc,%esp
 55a:	50                   	push   %eax
 55b:	e8 54 ff ff ff       	call   4b4 <free>
  return freep;
 560:	a1 2c 09 00 00       	mov    0x92c,%eax
 565:	83 c4 10             	add    $0x10,%esp
}
 568:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 56b:	c9                   	leave  
 56c:	c3                   	ret    
    return 0;
 56d:	b8 00 00 00 00       	mov    $0x0,%eax
 572:	eb f4                	jmp    568 <morecore+0x44>

00000574 <malloc>:

void*
malloc(uint nbytes)
{
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	53                   	push   %ebx
 578:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 57b:	8b 45 08             	mov    0x8(%ebp),%eax
 57e:	8d 58 07             	lea    0x7(%eax),%ebx
 581:	c1 eb 03             	shr    $0x3,%ebx
 584:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 587:	8b 0d 2c 09 00 00    	mov    0x92c,%ecx
 58d:	85 c9                	test   %ecx,%ecx
 58f:	74 04                	je     595 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 591:	8b 01                	mov    (%ecx),%eax
 593:	eb 4a                	jmp    5df <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 595:	c7 05 2c 09 00 00 30 	movl   $0x930,0x92c
 59c:	09 00 00 
 59f:	c7 05 30 09 00 00 30 	movl   $0x930,0x930
 5a6:	09 00 00 
    base.s.size = 0;
 5a9:	c7 05 34 09 00 00 00 	movl   $0x0,0x934
 5b0:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5b3:	b9 30 09 00 00       	mov    $0x930,%ecx
 5b8:	eb d7                	jmp    591 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5ba:	74 19                	je     5d5 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5bc:	29 da                	sub    %ebx,%edx
 5be:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5c1:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5c4:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5c7:	89 0d 2c 09 00 00    	mov    %ecx,0x92c
      return (void*)(p + 1);
 5cd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d3:	c9                   	leave  
 5d4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5d5:	8b 10                	mov    (%eax),%edx
 5d7:	89 11                	mov    %edx,(%ecx)
 5d9:	eb ec                	jmp    5c7 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5db:	89 c1                	mov    %eax,%ecx
 5dd:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5df:	8b 50 04             	mov    0x4(%eax),%edx
 5e2:	39 da                	cmp    %ebx,%edx
 5e4:	73 d4                	jae    5ba <malloc+0x46>
    if(p == freep)
 5e6:	39 05 2c 09 00 00    	cmp    %eax,0x92c
 5ec:	75 ed                	jne    5db <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5ee:	89 d8                	mov    %ebx,%eax
 5f0:	e8 2f ff ff ff       	call   524 <morecore>
 5f5:	85 c0                	test   %eax,%eax
 5f7:	75 e2                	jne    5db <malloc+0x67>
 5f9:	eb d5                	jmp    5d0 <malloc+0x5c>
