
_test_1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
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
   e:	81 ec 10 04 00 00    	sub    $0x410,%esp
   struct pstat st;
  
  if(getpinfo(&st) == 0)
  14:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  1a:	50                   	push   %eax
  1b:	e8 79 02 00 00       	call   299 <getpinfo>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	75 17                	jne    3e <main+0x3e>
  {
   printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	68 04 06 00 00       	push   $0x604
  2f:	6a 01                	push   $0x1
  31:	e8 20 03 00 00       	call   356 <printf>
  36:	83 c4 10             	add    $0x10,%esp
  }
  else
  {
   printf(1, "XV6_SCHEDULER\t FAILED\n");
  }
   exit();
  39:	e8 b3 01 00 00       	call   1f1 <exit>
   printf(1, "XV6_SCHEDULER\t FAILED\n");
  3e:	83 ec 08             	sub    $0x8,%esp
  41:	68 1c 06 00 00       	push   $0x61c
  46:	6a 01                	push   $0x1
  48:	e8 09 03 00 00       	call   356 <printf>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	eb e7                	jmp    39 <main+0x39>

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	56                   	push   %esi
  56:	53                   	push   %ebx
  57:	8b 75 08             	mov    0x8(%ebp),%esi
  5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5d:	89 f0                	mov    %esi,%eax
  5f:	89 d1                	mov    %edx,%ecx
  61:	83 c2 01             	add    $0x1,%edx
  64:	89 c3                	mov    %eax,%ebx
  66:	83 c0 01             	add    $0x1,%eax
  69:	0f b6 09             	movzbl (%ecx),%ecx
  6c:	88 0b                	mov    %cl,(%ebx)
  6e:	84 c9                	test   %cl,%cl
  70:	75 ed                	jne    5f <strcpy+0xd>
    ;
  return os;
}
  72:	89 f0                	mov    %esi,%eax
  74:	5b                   	pop    %ebx
  75:	5e                   	pop    %esi
  76:	5d                   	pop    %ebp
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  81:	eb 06                	jmp    89 <strcmp+0x11>
    p++, q++;
  83:	83 c1 01             	add    $0x1,%ecx
  86:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  89:	0f b6 01             	movzbl (%ecx),%eax
  8c:	84 c0                	test   %al,%al
  8e:	74 04                	je     94 <strcmp+0x1c>
  90:	3a 02                	cmp    (%edx),%al
  92:	74 ef                	je     83 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  94:	0f b6 c0             	movzbl %al,%eax
  97:	0f b6 12             	movzbl (%edx),%edx
  9a:	29 d0                	sub    %edx,%eax
}
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strlen>:

uint
strlen(const char *s)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a4:	b8 00 00 00 00       	mov    $0x0,%eax
  a9:	eb 03                	jmp    ae <strlen+0x10>
  ab:	83 c0 01             	add    $0x1,%eax
  ae:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  b2:	75 f7                	jne    ab <strlen+0xd>
    ;
  return n;
}
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	57                   	push   %edi
  ba:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  bd:	89 d7                	mov    %edx,%edi
  bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  c5:	fc                   	cld    
  c6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c8:	89 d0                	mov    %edx,%eax
  ca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  cd:	c9                   	leave  
  ce:	c3                   	ret    

000000cf <strchr>:

char*
strchr(const char *s, char c)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d9:	eb 03                	jmp    de <strchr+0xf>
  db:	83 c0 01             	add    $0x1,%eax
  de:	0f b6 10             	movzbl (%eax),%edx
  e1:	84 d2                	test   %dl,%dl
  e3:	74 06                	je     eb <strchr+0x1c>
    if(*s == c)
  e5:	38 ca                	cmp    %cl,%dl
  e7:	75 f2                	jne    db <strchr+0xc>
  e9:	eb 05                	jmp    f0 <strchr+0x21>
      return (char*)s;
  return 0;
  eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  f0:	5d                   	pop    %ebp
  f1:	c3                   	ret    

000000f2 <gets>:

char*
gets(char *buf, int max)
{
  f2:	55                   	push   %ebp
  f3:	89 e5                	mov    %esp,%ebp
  f5:	57                   	push   %edi
  f6:	56                   	push   %esi
  f7:	53                   	push   %ebx
  f8:	83 ec 1c             	sub    $0x1c,%esp
  fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fe:	bb 00 00 00 00       	mov    $0x0,%ebx
 103:	89 de                	mov    %ebx,%esi
 105:	83 c3 01             	add    $0x1,%ebx
 108:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 10b:	7d 2e                	jge    13b <gets+0x49>
    cc = read(0, &c, 1);
 10d:	83 ec 04             	sub    $0x4,%esp
 110:	6a 01                	push   $0x1
 112:	8d 45 e7             	lea    -0x19(%ebp),%eax
 115:	50                   	push   %eax
 116:	6a 00                	push   $0x0
 118:	e8 ec 00 00 00       	call   209 <read>
    if(cc < 1)
 11d:	83 c4 10             	add    $0x10,%esp
 120:	85 c0                	test   %eax,%eax
 122:	7e 17                	jle    13b <gets+0x49>
      break;
    buf[i++] = c;
 124:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 128:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 12b:	3c 0a                	cmp    $0xa,%al
 12d:	0f 94 c2             	sete   %dl
 130:	3c 0d                	cmp    $0xd,%al
 132:	0f 94 c0             	sete   %al
 135:	08 c2                	or     %al,%dl
 137:	74 ca                	je     103 <gets+0x11>
    buf[i++] = c;
 139:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 13b:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 13f:	89 f8                	mov    %edi,%eax
 141:	8d 65 f4             	lea    -0xc(%ebp),%esp
 144:	5b                   	pop    %ebx
 145:	5e                   	pop    %esi
 146:	5f                   	pop    %edi
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    

00000149 <stat>:

int
stat(const char *n, struct stat *st)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	56                   	push   %esi
 14d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14e:	83 ec 08             	sub    $0x8,%esp
 151:	6a 00                	push   $0x0
 153:	ff 75 08             	push   0x8(%ebp)
 156:	e8 d6 00 00 00       	call   231 <open>
  if(fd < 0)
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	85 c0                	test   %eax,%eax
 160:	78 24                	js     186 <stat+0x3d>
 162:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 164:	83 ec 08             	sub    $0x8,%esp
 167:	ff 75 0c             	push   0xc(%ebp)
 16a:	50                   	push   %eax
 16b:	e8 d9 00 00 00       	call   249 <fstat>
 170:	89 c6                	mov    %eax,%esi
  close(fd);
 172:	89 1c 24             	mov    %ebx,(%esp)
 175:	e8 9f 00 00 00       	call   219 <close>
  return r;
 17a:	83 c4 10             	add    $0x10,%esp
}
 17d:	89 f0                	mov    %esi,%eax
 17f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 182:	5b                   	pop    %ebx
 183:	5e                   	pop    %esi
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    
    return -1;
 186:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18b:	eb f0                	jmp    17d <stat+0x34>

0000018d <atoi>:

int
atoi(const char *s)
{
 18d:	55                   	push   %ebp
 18e:	89 e5                	mov    %esp,%ebp
 190:	53                   	push   %ebx
 191:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 194:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 199:	eb 10                	jmp    1ab <atoi+0x1e>
    n = n*10 + *s++ - '0';
 19b:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 19e:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1a1:	83 c1 01             	add    $0x1,%ecx
 1a4:	0f be c0             	movsbl %al,%eax
 1a7:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1ab:	0f b6 01             	movzbl (%ecx),%eax
 1ae:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1b1:	80 fb 09             	cmp    $0x9,%bl
 1b4:	76 e5                	jbe    19b <atoi+0xe>
  return n;
}
 1b6:	89 d0                	mov    %edx,%eax
 1b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	56                   	push   %esi
 1c1:	53                   	push   %ebx
 1c2:	8b 75 08             	mov    0x8(%ebp),%esi
 1c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c8:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1cb:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1cd:	eb 0d                	jmp    1dc <memmove+0x1f>
    *dst++ = *src++;
 1cf:	0f b6 01             	movzbl (%ecx),%eax
 1d2:	88 02                	mov    %al,(%edx)
 1d4:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d7:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1da:	89 d8                	mov    %ebx,%eax
 1dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1df:	85 c0                	test   %eax,%eax
 1e1:	7f ec                	jg     1cf <memmove+0x12>
  return vdst;
}
 1e3:	89 f0                	mov    %esi,%eax
 1e5:	5b                   	pop    %ebx
 1e6:	5e                   	pop    %esi
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    

000001e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e9:	b8 01 00 00 00       	mov    $0x1,%eax
 1ee:	cd 40                	int    $0x40
 1f0:	c3                   	ret    

000001f1 <exit>:
SYSCALL(exit)
 1f1:	b8 02 00 00 00       	mov    $0x2,%eax
 1f6:	cd 40                	int    $0x40
 1f8:	c3                   	ret    

000001f9 <wait>:
SYSCALL(wait)
 1f9:	b8 03 00 00 00       	mov    $0x3,%eax
 1fe:	cd 40                	int    $0x40
 200:	c3                   	ret    

00000201 <pipe>:
SYSCALL(pipe)
 201:	b8 04 00 00 00       	mov    $0x4,%eax
 206:	cd 40                	int    $0x40
 208:	c3                   	ret    

00000209 <read>:
SYSCALL(read)
 209:	b8 05 00 00 00       	mov    $0x5,%eax
 20e:	cd 40                	int    $0x40
 210:	c3                   	ret    

00000211 <write>:
SYSCALL(write)
 211:	b8 10 00 00 00       	mov    $0x10,%eax
 216:	cd 40                	int    $0x40
 218:	c3                   	ret    

00000219 <close>:
SYSCALL(close)
 219:	b8 15 00 00 00       	mov    $0x15,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	ret    

00000221 <kill>:
SYSCALL(kill)
 221:	b8 06 00 00 00       	mov    $0x6,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <exec>:
SYSCALL(exec)
 229:	b8 07 00 00 00       	mov    $0x7,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <open>:
SYSCALL(open)
 231:	b8 0f 00 00 00       	mov    $0xf,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <mknod>:
SYSCALL(mknod)
 239:	b8 11 00 00 00       	mov    $0x11,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <unlink>:
SYSCALL(unlink)
 241:	b8 12 00 00 00       	mov    $0x12,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <fstat>:
SYSCALL(fstat)
 249:	b8 08 00 00 00       	mov    $0x8,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <link>:
SYSCALL(link)
 251:	b8 13 00 00 00       	mov    $0x13,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <mkdir>:
SYSCALL(mkdir)
 259:	b8 14 00 00 00       	mov    $0x14,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <chdir>:
SYSCALL(chdir)
 261:	b8 09 00 00 00       	mov    $0x9,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <dup>:
SYSCALL(dup)
 269:	b8 0a 00 00 00       	mov    $0xa,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <getpid>:
SYSCALL(getpid)
 271:	b8 0b 00 00 00       	mov    $0xb,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <sbrk>:
SYSCALL(sbrk)
 279:	b8 0c 00 00 00       	mov    $0xc,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <sleep>:
SYSCALL(sleep)
 281:	b8 0d 00 00 00       	mov    $0xd,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <uptime>:
SYSCALL(uptime)
 289:	b8 0e 00 00 00       	mov    $0xe,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <settickets>:
SYSCALL(settickets)
 291:	b8 16 00 00 00       	mov    $0x16,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <getpinfo>:
SYSCALL(getpinfo)
 299:	b8 17 00 00 00       	mov    $0x17,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <mprotect>:
SYSCALL(mprotect)
 2a1:	b8 18 00 00 00       	mov    $0x18,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <munprotect>:
SYSCALL(munprotect)
 2a9:	b8 19 00 00 00       	mov    $0x19,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp
 2b4:	83 ec 1c             	sub    $0x1c,%esp
 2b7:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2ba:	6a 01                	push   $0x1
 2bc:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2bf:	52                   	push   %edx
 2c0:	50                   	push   %eax
 2c1:	e8 4b ff ff ff       	call   211 <write>
}
 2c6:	83 c4 10             	add    $0x10,%esp
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    

000002cb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	57                   	push   %edi
 2cf:	56                   	push   %esi
 2d0:	53                   	push   %ebx
 2d1:	83 ec 2c             	sub    $0x2c,%esp
 2d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2d7:	89 d0                	mov    %edx,%eax
 2d9:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2df:	0f 95 c1             	setne  %cl
 2e2:	c1 ea 1f             	shr    $0x1f,%edx
 2e5:	84 d1                	test   %dl,%cl
 2e7:	74 44                	je     32d <printint+0x62>
    neg = 1;
    x = -xx;
 2e9:	f7 d8                	neg    %eax
 2eb:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2ed:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f9:	89 c8                	mov    %ecx,%eax
 2fb:	ba 00 00 00 00       	mov    $0x0,%edx
 300:	f7 f6                	div    %esi
 302:	89 df                	mov    %ebx,%edi
 304:	83 c3 01             	add    $0x1,%ebx
 307:	0f b6 92 94 06 00 00 	movzbl 0x694(%edx),%edx
 30e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 312:	89 ca                	mov    %ecx,%edx
 314:	89 c1                	mov    %eax,%ecx
 316:	39 d6                	cmp    %edx,%esi
 318:	76 df                	jbe    2f9 <printint+0x2e>
  if(neg)
 31a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 31e:	74 31                	je     351 <printint+0x86>
    buf[i++] = '-';
 320:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 325:	8d 5f 02             	lea    0x2(%edi),%ebx
 328:	8b 75 d0             	mov    -0x30(%ebp),%esi
 32b:	eb 17                	jmp    344 <printint+0x79>
    x = xx;
 32d:	89 c1                	mov    %eax,%ecx
  neg = 0;
 32f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 336:	eb bc                	jmp    2f4 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 338:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 33d:	89 f0                	mov    %esi,%eax
 33f:	e8 6d ff ff ff       	call   2b1 <putc>
  while(--i >= 0)
 344:	83 eb 01             	sub    $0x1,%ebx
 347:	79 ef                	jns    338 <printint+0x6d>
}
 349:	83 c4 2c             	add    $0x2c,%esp
 34c:	5b                   	pop    %ebx
 34d:	5e                   	pop    %esi
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    
 351:	8b 75 d0             	mov    -0x30(%ebp),%esi
 354:	eb ee                	jmp    344 <printint+0x79>

00000356 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	57                   	push   %edi
 35a:	56                   	push   %esi
 35b:	53                   	push   %ebx
 35c:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 35f:	8d 45 10             	lea    0x10(%ebp),%eax
 362:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 365:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 36a:	bb 00 00 00 00       	mov    $0x0,%ebx
 36f:	eb 14                	jmp    385 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 371:	89 fa                	mov    %edi,%edx
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	e8 36 ff ff ff       	call   2b1 <putc>
 37b:	eb 05                	jmp    382 <printf+0x2c>
      }
    } else if(state == '%'){
 37d:	83 fe 25             	cmp    $0x25,%esi
 380:	74 25                	je     3a7 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 382:	83 c3 01             	add    $0x1,%ebx
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 38c:	84 c0                	test   %al,%al
 38e:	0f 84 20 01 00 00    	je     4b4 <printf+0x15e>
    c = fmt[i] & 0xff;
 394:	0f be f8             	movsbl %al,%edi
 397:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 39a:	85 f6                	test   %esi,%esi
 39c:	75 df                	jne    37d <printf+0x27>
      if(c == '%'){
 39e:	83 f8 25             	cmp    $0x25,%eax
 3a1:	75 ce                	jne    371 <printf+0x1b>
        state = '%';
 3a3:	89 c6                	mov    %eax,%esi
 3a5:	eb db                	jmp    382 <printf+0x2c>
      if(c == 'd'){
 3a7:	83 f8 25             	cmp    $0x25,%eax
 3aa:	0f 84 cf 00 00 00    	je     47f <printf+0x129>
 3b0:	0f 8c dd 00 00 00    	jl     493 <printf+0x13d>
 3b6:	83 f8 78             	cmp    $0x78,%eax
 3b9:	0f 8f d4 00 00 00    	jg     493 <printf+0x13d>
 3bf:	83 f8 63             	cmp    $0x63,%eax
 3c2:	0f 8c cb 00 00 00    	jl     493 <printf+0x13d>
 3c8:	83 e8 63             	sub    $0x63,%eax
 3cb:	83 f8 15             	cmp    $0x15,%eax
 3ce:	0f 87 bf 00 00 00    	ja     493 <printf+0x13d>
 3d4:	ff 24 85 3c 06 00 00 	jmp    *0x63c(,%eax,4)
        printint(fd, *ap, 10, 1);
 3db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3de:	8b 17                	mov    (%edi),%edx
 3e0:	83 ec 0c             	sub    $0xc,%esp
 3e3:	6a 01                	push   $0x1
 3e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	e8 d9 fe ff ff       	call   2cb <printint>
        ap++;
 3f2:	83 c7 04             	add    $0x4,%edi
 3f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3fb:	be 00 00 00 00       	mov    $0x0,%esi
 400:	eb 80                	jmp    382 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 405:	8b 17                	mov    (%edi),%edx
 407:	83 ec 0c             	sub    $0xc,%esp
 40a:	6a 00                	push   $0x0
 40c:	b9 10 00 00 00       	mov    $0x10,%ecx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	e8 b2 fe ff ff       	call   2cb <printint>
        ap++;
 419:	83 c7 04             	add    $0x4,%edi
 41c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 422:	be 00 00 00 00       	mov    $0x0,%esi
 427:	e9 56 ff ff ff       	jmp    382 <printf+0x2c>
        s = (char*)*ap;
 42c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 42f:	8b 30                	mov    (%eax),%esi
        ap++;
 431:	83 c0 04             	add    $0x4,%eax
 434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 437:	85 f6                	test   %esi,%esi
 439:	75 15                	jne    450 <printf+0xfa>
          s = "(null)";
 43b:	be 33 06 00 00       	mov    $0x633,%esi
 440:	eb 0e                	jmp    450 <printf+0xfa>
          putc(fd, *s);
 442:	0f be d2             	movsbl %dl,%edx
 445:	8b 45 08             	mov    0x8(%ebp),%eax
 448:	e8 64 fe ff ff       	call   2b1 <putc>
          s++;
 44d:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 450:	0f b6 16             	movzbl (%esi),%edx
 453:	84 d2                	test   %dl,%dl
 455:	75 eb                	jne    442 <printf+0xec>
      state = 0;
 457:	be 00 00 00 00       	mov    $0x0,%esi
 45c:	e9 21 ff ff ff       	jmp    382 <printf+0x2c>
        putc(fd, *ap);
 461:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 464:	0f be 17             	movsbl (%edi),%edx
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	e8 42 fe ff ff       	call   2b1 <putc>
        ap++;
 46f:	83 c7 04             	add    $0x4,%edi
 472:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 475:	be 00 00 00 00       	mov    $0x0,%esi
 47a:	e9 03 ff ff ff       	jmp    382 <printf+0x2c>
        putc(fd, c);
 47f:	89 fa                	mov    %edi,%edx
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	e8 28 fe ff ff       	call   2b1 <putc>
      state = 0;
 489:	be 00 00 00 00       	mov    $0x0,%esi
 48e:	e9 ef fe ff ff       	jmp    382 <printf+0x2c>
        putc(fd, '%');
 493:	ba 25 00 00 00       	mov    $0x25,%edx
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	e8 11 fe ff ff       	call   2b1 <putc>
        putc(fd, c);
 4a0:	89 fa                	mov    %edi,%edx
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	e8 07 fe ff ff       	call   2b1 <putc>
      state = 0;
 4aa:	be 00 00 00 00       	mov    $0x0,%esi
 4af:	e9 ce fe ff ff       	jmp    382 <printf+0x2c>
    }
  }
}
 4b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b7:	5b                   	pop    %ebx
 4b8:	5e                   	pop    %esi
 4b9:	5f                   	pop    %edi
 4ba:	5d                   	pop    %ebp
 4bb:	c3                   	ret    

000004bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	57                   	push   %edi
 4c0:	56                   	push   %esi
 4c1:	53                   	push   %ebx
 4c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4c5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c8:	a1 34 09 00 00       	mov    0x934,%eax
 4cd:	eb 02                	jmp    4d1 <free+0x15>
 4cf:	89 d0                	mov    %edx,%eax
 4d1:	39 c8                	cmp    %ecx,%eax
 4d3:	73 04                	jae    4d9 <free+0x1d>
 4d5:	39 08                	cmp    %ecx,(%eax)
 4d7:	77 12                	ja     4eb <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d9:	8b 10                	mov    (%eax),%edx
 4db:	39 c2                	cmp    %eax,%edx
 4dd:	77 f0                	ja     4cf <free+0x13>
 4df:	39 c8                	cmp    %ecx,%eax
 4e1:	72 08                	jb     4eb <free+0x2f>
 4e3:	39 ca                	cmp    %ecx,%edx
 4e5:	77 04                	ja     4eb <free+0x2f>
 4e7:	89 d0                	mov    %edx,%eax
 4e9:	eb e6                	jmp    4d1 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4eb:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ee:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f1:	8b 10                	mov    (%eax),%edx
 4f3:	39 d7                	cmp    %edx,%edi
 4f5:	74 19                	je     510 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4f7:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4fa:	8b 50 04             	mov    0x4(%eax),%edx
 4fd:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 500:	39 ce                	cmp    %ecx,%esi
 502:	74 1b                	je     51f <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 504:	89 08                	mov    %ecx,(%eax)
  freep = p;
 506:	a3 34 09 00 00       	mov    %eax,0x934
}
 50b:	5b                   	pop    %ebx
 50c:	5e                   	pop    %esi
 50d:	5f                   	pop    %edi
 50e:	5d                   	pop    %ebp
 50f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 510:	03 72 04             	add    0x4(%edx),%esi
 513:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 516:	8b 10                	mov    (%eax),%edx
 518:	8b 12                	mov    (%edx),%edx
 51a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 51d:	eb db                	jmp    4fa <free+0x3e>
    p->s.size += bp->s.size;
 51f:	03 53 fc             	add    -0x4(%ebx),%edx
 522:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 525:	8b 53 f8             	mov    -0x8(%ebx),%edx
 528:	89 10                	mov    %edx,(%eax)
 52a:	eb da                	jmp    506 <free+0x4a>

0000052c <morecore>:

static Header*
morecore(uint nu)
{
 52c:	55                   	push   %ebp
 52d:	89 e5                	mov    %esp,%ebp
 52f:	53                   	push   %ebx
 530:	83 ec 04             	sub    $0x4,%esp
 533:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 535:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 53a:	77 05                	ja     541 <morecore+0x15>
    nu = 4096;
 53c:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 541:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 548:	83 ec 0c             	sub    $0xc,%esp
 54b:	50                   	push   %eax
 54c:	e8 28 fd ff ff       	call   279 <sbrk>
  if(p == (char*)-1)
 551:	83 c4 10             	add    $0x10,%esp
 554:	83 f8 ff             	cmp    $0xffffffff,%eax
 557:	74 1c                	je     575 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 559:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 55c:	83 c0 08             	add    $0x8,%eax
 55f:	83 ec 0c             	sub    $0xc,%esp
 562:	50                   	push   %eax
 563:	e8 54 ff ff ff       	call   4bc <free>
  return freep;
 568:	a1 34 09 00 00       	mov    0x934,%eax
 56d:	83 c4 10             	add    $0x10,%esp
}
 570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 573:	c9                   	leave  
 574:	c3                   	ret    
    return 0;
 575:	b8 00 00 00 00       	mov    $0x0,%eax
 57a:	eb f4                	jmp    570 <morecore+0x44>

0000057c <malloc>:

void*
malloc(uint nbytes)
{
 57c:	55                   	push   %ebp
 57d:	89 e5                	mov    %esp,%ebp
 57f:	53                   	push   %ebx
 580:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	8d 58 07             	lea    0x7(%eax),%ebx
 589:	c1 eb 03             	shr    $0x3,%ebx
 58c:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 58f:	8b 0d 34 09 00 00    	mov    0x934,%ecx
 595:	85 c9                	test   %ecx,%ecx
 597:	74 04                	je     59d <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 599:	8b 01                	mov    (%ecx),%eax
 59b:	eb 4a                	jmp    5e7 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 59d:	c7 05 34 09 00 00 38 	movl   $0x938,0x934
 5a4:	09 00 00 
 5a7:	c7 05 38 09 00 00 38 	movl   $0x938,0x938
 5ae:	09 00 00 
    base.s.size = 0;
 5b1:	c7 05 3c 09 00 00 00 	movl   $0x0,0x93c
 5b8:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5bb:	b9 38 09 00 00       	mov    $0x938,%ecx
 5c0:	eb d7                	jmp    599 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5c2:	74 19                	je     5dd <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c4:	29 da                	sub    %ebx,%edx
 5c6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5c9:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5cc:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5cf:	89 0d 34 09 00 00    	mov    %ecx,0x934
      return (void*)(p + 1);
 5d5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5db:	c9                   	leave  
 5dc:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5dd:	8b 10                	mov    (%eax),%edx
 5df:	89 11                	mov    %edx,(%ecx)
 5e1:	eb ec                	jmp    5cf <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e3:	89 c1                	mov    %eax,%ecx
 5e5:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5e7:	8b 50 04             	mov    0x4(%eax),%edx
 5ea:	39 da                	cmp    %ebx,%edx
 5ec:	73 d4                	jae    5c2 <malloc+0x46>
    if(p == freep)
 5ee:	39 05 34 09 00 00    	cmp    %eax,0x934
 5f4:	75 ed                	jne    5e3 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5f6:	89 d8                	mov    %ebx,%eax
 5f8:	e8 2f ff ff ff       	call   52c <morecore>
 5fd:	85 c0                	test   %eax,%eax
 5ff:	75 e2                	jne    5e3 <malloc+0x67>
 601:	eb d5                	jmp    5d8 <malloc+0x5c>
