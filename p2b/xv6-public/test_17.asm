
_test_17:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#define PGSIZE 4096


int 
main(void){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    const uint PAGES_NUM = 5;
    
    // Allocate 5 pages
    char *ptr = sbrk(PGSIZE * PAGES_NUM * sizeof(char));
   f:	83 ec 0c             	sub    $0xc,%esp
  12:	68 00 50 00 00       	push   $0x5000
  17:	e8 5a 02 00 00       	call   276 <sbrk>
  1c:	89 c3                	mov    %eax,%ebx
    mprotect(ptr, PAGES_NUM);
  1e:	83 c4 08             	add    $0x8,%esp
  21:	6a 05                	push   $0x5
  23:	50                   	push   %eax
  24:	e8 75 02 00 00       	call   29e <mprotect>
    munprotect(ptr, PAGES_NUM);
  29:	83 c4 08             	add    $0x8,%esp
  2c:	6a 05                	push   $0x5
  2e:	53                   	push   %ebx
  2f:	e8 72 02 00 00       	call   2a6 <munprotect>
    
    ptr[PGSIZE * 1] = 0xAA;
  34:	c6 83 00 10 00 00 aa 	movb   $0xaa,0x1000(%ebx)
    printf(1, "XV6_TEST_OUTPUT TEST PASS\n");
  3b:	83 c4 08             	add    $0x8,%esp
  3e:	68 00 06 00 00       	push   $0x600
  43:	6a 01                	push   $0x1
  45:	e8 09 03 00 00       	call   353 <printf>

    exit();
  4a:	e8 9f 01 00 00       	call   1ee <exit>

0000004f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  4f:	55                   	push   %ebp
  50:	89 e5                	mov    %esp,%ebp
  52:	56                   	push   %esi
  53:	53                   	push   %ebx
  54:	8b 75 08             	mov    0x8(%ebp),%esi
  57:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5a:	89 f0                	mov    %esi,%eax
  5c:	89 d1                	mov    %edx,%ecx
  5e:	83 c2 01             	add    $0x1,%edx
  61:	89 c3                	mov    %eax,%ebx
  63:	83 c0 01             	add    $0x1,%eax
  66:	0f b6 09             	movzbl (%ecx),%ecx
  69:	88 0b                	mov    %cl,(%ebx)
  6b:	84 c9                	test   %cl,%cl
  6d:	75 ed                	jne    5c <strcpy+0xd>
    ;
  return os;
}
  6f:	89 f0                	mov    %esi,%eax
  71:	5b                   	pop    %ebx
  72:	5e                   	pop    %esi
  73:	5d                   	pop    %ebp
  74:	c3                   	ret    

00000075 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  75:	55                   	push   %ebp
  76:	89 e5                	mov    %esp,%ebp
  78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  7e:	eb 06                	jmp    86 <strcmp+0x11>
    p++, q++;
  80:	83 c1 01             	add    $0x1,%ecx
  83:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  86:	0f b6 01             	movzbl (%ecx),%eax
  89:	84 c0                	test   %al,%al
  8b:	74 04                	je     91 <strcmp+0x1c>
  8d:	3a 02                	cmp    (%edx),%al
  8f:	74 ef                	je     80 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  91:	0f b6 c0             	movzbl %al,%eax
  94:	0f b6 12             	movzbl (%edx),%edx
  97:	29 d0                	sub    %edx,%eax
}
  99:	5d                   	pop    %ebp
  9a:	c3                   	ret    

0000009b <strlen>:

uint
strlen(const char *s)
{
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a1:	b8 00 00 00 00       	mov    $0x0,%eax
  a6:	eb 03                	jmp    ab <strlen+0x10>
  a8:	83 c0 01             	add    $0x1,%eax
  ab:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  af:	75 f7                	jne    a8 <strlen+0xd>
    ;
  return n;
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	57                   	push   %edi
  b7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ba:	89 d7                	mov    %edx,%edi
  bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  c2:	fc                   	cld    
  c3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c5:	89 d0                	mov    %edx,%eax
  c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ca:	c9                   	leave  
  cb:	c3                   	ret    

000000cc <strchr>:

char*
strchr(const char *s, char c)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d6:	eb 03                	jmp    db <strchr+0xf>
  d8:	83 c0 01             	add    $0x1,%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	84 d2                	test   %dl,%dl
  e0:	74 06                	je     e8 <strchr+0x1c>
    if(*s == c)
  e2:	38 ca                	cmp    %cl,%dl
  e4:	75 f2                	jne    d8 <strchr+0xc>
  e6:	eb 05                	jmp    ed <strchr+0x21>
      return (char*)s;
  return 0;
  e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    

000000ef <gets>:

char*
gets(char *buf, int max)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	57                   	push   %edi
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	83 ec 1c             	sub    $0x1c,%esp
  f8:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fb:	bb 00 00 00 00       	mov    $0x0,%ebx
 100:	89 de                	mov    %ebx,%esi
 102:	83 c3 01             	add    $0x1,%ebx
 105:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 108:	7d 2e                	jge    138 <gets+0x49>
    cc = read(0, &c, 1);
 10a:	83 ec 04             	sub    $0x4,%esp
 10d:	6a 01                	push   $0x1
 10f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 112:	50                   	push   %eax
 113:	6a 00                	push   $0x0
 115:	e8 ec 00 00 00       	call   206 <read>
    if(cc < 1)
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	85 c0                	test   %eax,%eax
 11f:	7e 17                	jle    138 <gets+0x49>
      break;
    buf[i++] = c;
 121:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 125:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 128:	3c 0a                	cmp    $0xa,%al
 12a:	0f 94 c2             	sete   %dl
 12d:	3c 0d                	cmp    $0xd,%al
 12f:	0f 94 c0             	sete   %al
 132:	08 c2                	or     %al,%dl
 134:	74 ca                	je     100 <gets+0x11>
    buf[i++] = c;
 136:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 138:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 13c:	89 f8                	mov    %edi,%eax
 13e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 141:	5b                   	pop    %ebx
 142:	5e                   	pop    %esi
 143:	5f                   	pop    %edi
 144:	5d                   	pop    %ebp
 145:	c3                   	ret    

00000146 <stat>:

int
stat(const char *n, struct stat *st)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	56                   	push   %esi
 14a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	6a 00                	push   $0x0
 150:	ff 75 08             	push   0x8(%ebp)
 153:	e8 d6 00 00 00       	call   22e <open>
  if(fd < 0)
 158:	83 c4 10             	add    $0x10,%esp
 15b:	85 c0                	test   %eax,%eax
 15d:	78 24                	js     183 <stat+0x3d>
 15f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 161:	83 ec 08             	sub    $0x8,%esp
 164:	ff 75 0c             	push   0xc(%ebp)
 167:	50                   	push   %eax
 168:	e8 d9 00 00 00       	call   246 <fstat>
 16d:	89 c6                	mov    %eax,%esi
  close(fd);
 16f:	89 1c 24             	mov    %ebx,(%esp)
 172:	e8 9f 00 00 00       	call   216 <close>
  return r;
 177:	83 c4 10             	add    $0x10,%esp
}
 17a:	89 f0                	mov    %esi,%eax
 17c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17f:	5b                   	pop    %ebx
 180:	5e                   	pop    %esi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
    return -1;
 183:	be ff ff ff ff       	mov    $0xffffffff,%esi
 188:	eb f0                	jmp    17a <stat+0x34>

0000018a <atoi>:

int
atoi(const char *s)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	53                   	push   %ebx
 18e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 191:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 196:	eb 10                	jmp    1a8 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 198:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 19b:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 19e:	83 c1 01             	add    $0x1,%ecx
 1a1:	0f be c0             	movsbl %al,%eax
 1a4:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1a8:	0f b6 01             	movzbl (%ecx),%eax
 1ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ae:	80 fb 09             	cmp    $0x9,%bl
 1b1:	76 e5                	jbe    198 <atoi+0xe>
  return n;
}
 1b3:	89 d0                	mov    %edx,%eax
 1b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	56                   	push   %esi
 1be:	53                   	push   %ebx
 1bf:	8b 75 08             	mov    0x8(%ebp),%esi
 1c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c5:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c8:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ca:	eb 0d                	jmp    1d9 <memmove+0x1f>
    *dst++ = *src++;
 1cc:	0f b6 01             	movzbl (%ecx),%eax
 1cf:	88 02                	mov    %al,(%edx)
 1d1:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d4:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d7:	89 d8                	mov    %ebx,%eax
 1d9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1dc:	85 c0                	test   %eax,%eax
 1de:	7f ec                	jg     1cc <memmove+0x12>
  return vdst;
}
 1e0:	89 f0                	mov    %esi,%eax
 1e2:	5b                   	pop    %ebx
 1e3:	5e                   	pop    %esi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    

000001e6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e6:	b8 01 00 00 00       	mov    $0x1,%eax
 1eb:	cd 40                	int    $0x40
 1ed:	c3                   	ret    

000001ee <exit>:
SYSCALL(exit)
 1ee:	b8 02 00 00 00       	mov    $0x2,%eax
 1f3:	cd 40                	int    $0x40
 1f5:	c3                   	ret    

000001f6 <wait>:
SYSCALL(wait)
 1f6:	b8 03 00 00 00       	mov    $0x3,%eax
 1fb:	cd 40                	int    $0x40
 1fd:	c3                   	ret    

000001fe <pipe>:
SYSCALL(pipe)
 1fe:	b8 04 00 00 00       	mov    $0x4,%eax
 203:	cd 40                	int    $0x40
 205:	c3                   	ret    

00000206 <read>:
SYSCALL(read)
 206:	b8 05 00 00 00       	mov    $0x5,%eax
 20b:	cd 40                	int    $0x40
 20d:	c3                   	ret    

0000020e <write>:
SYSCALL(write)
 20e:	b8 10 00 00 00       	mov    $0x10,%eax
 213:	cd 40                	int    $0x40
 215:	c3                   	ret    

00000216 <close>:
SYSCALL(close)
 216:	b8 15 00 00 00       	mov    $0x15,%eax
 21b:	cd 40                	int    $0x40
 21d:	c3                   	ret    

0000021e <kill>:
SYSCALL(kill)
 21e:	b8 06 00 00 00       	mov    $0x6,%eax
 223:	cd 40                	int    $0x40
 225:	c3                   	ret    

00000226 <exec>:
SYSCALL(exec)
 226:	b8 07 00 00 00       	mov    $0x7,%eax
 22b:	cd 40                	int    $0x40
 22d:	c3                   	ret    

0000022e <open>:
SYSCALL(open)
 22e:	b8 0f 00 00 00       	mov    $0xf,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <mknod>:
SYSCALL(mknod)
 236:	b8 11 00 00 00       	mov    $0x11,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <unlink>:
SYSCALL(unlink)
 23e:	b8 12 00 00 00       	mov    $0x12,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <fstat>:
SYSCALL(fstat)
 246:	b8 08 00 00 00       	mov    $0x8,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <link>:
SYSCALL(link)
 24e:	b8 13 00 00 00       	mov    $0x13,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <mkdir>:
SYSCALL(mkdir)
 256:	b8 14 00 00 00       	mov    $0x14,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <chdir>:
SYSCALL(chdir)
 25e:	b8 09 00 00 00       	mov    $0x9,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <dup>:
SYSCALL(dup)
 266:	b8 0a 00 00 00       	mov    $0xa,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <getpid>:
SYSCALL(getpid)
 26e:	b8 0b 00 00 00       	mov    $0xb,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <sbrk>:
SYSCALL(sbrk)
 276:	b8 0c 00 00 00       	mov    $0xc,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <sleep>:
SYSCALL(sleep)
 27e:	b8 0d 00 00 00       	mov    $0xd,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <uptime>:
SYSCALL(uptime)
 286:	b8 0e 00 00 00       	mov    $0xe,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <settickets>:
SYSCALL(settickets)
 28e:	b8 16 00 00 00       	mov    $0x16,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <getpinfo>:
SYSCALL(getpinfo)
 296:	b8 17 00 00 00       	mov    $0x17,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <mprotect>:
SYSCALL(mprotect)
 29e:	b8 18 00 00 00       	mov    $0x18,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <munprotect>:
SYSCALL(munprotect)
 2a6:	b8 19 00 00 00       	mov    $0x19,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 1c             	sub    $0x1c,%esp
 2b4:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2b7:	6a 01                	push   $0x1
 2b9:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2bc:	52                   	push   %edx
 2bd:	50                   	push   %eax
 2be:	e8 4b ff ff ff       	call   20e <write>
}
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	c9                   	leave  
 2c7:	c3                   	ret    

000002c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	57                   	push   %edi
 2cc:	56                   	push   %esi
 2cd:	53                   	push   %ebx
 2ce:	83 ec 2c             	sub    $0x2c,%esp
 2d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2d4:	89 d0                	mov    %edx,%eax
 2d6:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2dc:	0f 95 c1             	setne  %cl
 2df:	c1 ea 1f             	shr    $0x1f,%edx
 2e2:	84 d1                	test   %dl,%cl
 2e4:	74 44                	je     32a <printint+0x62>
    neg = 1;
    x = -xx;
 2e6:	f7 d8                	neg    %eax
 2e8:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2ea:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f6:	89 c8                	mov    %ecx,%eax
 2f8:	ba 00 00 00 00       	mov    $0x0,%edx
 2fd:	f7 f6                	div    %esi
 2ff:	89 df                	mov    %ebx,%edi
 301:	83 c3 01             	add    $0x1,%ebx
 304:	0f b6 92 7c 06 00 00 	movzbl 0x67c(%edx),%edx
 30b:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 30f:	89 ca                	mov    %ecx,%edx
 311:	89 c1                	mov    %eax,%ecx
 313:	39 d6                	cmp    %edx,%esi
 315:	76 df                	jbe    2f6 <printint+0x2e>
  if(neg)
 317:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 31b:	74 31                	je     34e <printint+0x86>
    buf[i++] = '-';
 31d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 322:	8d 5f 02             	lea    0x2(%edi),%ebx
 325:	8b 75 d0             	mov    -0x30(%ebp),%esi
 328:	eb 17                	jmp    341 <printint+0x79>
    x = xx;
 32a:	89 c1                	mov    %eax,%ecx
  neg = 0;
 32c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 333:	eb bc                	jmp    2f1 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 335:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 33a:	89 f0                	mov    %esi,%eax
 33c:	e8 6d ff ff ff       	call   2ae <putc>
  while(--i >= 0)
 341:	83 eb 01             	sub    $0x1,%ebx
 344:	79 ef                	jns    335 <printint+0x6d>
}
 346:	83 c4 2c             	add    $0x2c,%esp
 349:	5b                   	pop    %ebx
 34a:	5e                   	pop    %esi
 34b:	5f                   	pop    %edi
 34c:	5d                   	pop    %ebp
 34d:	c3                   	ret    
 34e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 351:	eb ee                	jmp    341 <printint+0x79>

00000353 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
 356:	57                   	push   %edi
 357:	56                   	push   %esi
 358:	53                   	push   %ebx
 359:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 35c:	8d 45 10             	lea    0x10(%ebp),%eax
 35f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 362:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 367:	bb 00 00 00 00       	mov    $0x0,%ebx
 36c:	eb 14                	jmp    382 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 36e:	89 fa                	mov    %edi,%edx
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	e8 36 ff ff ff       	call   2ae <putc>
 378:	eb 05                	jmp    37f <printf+0x2c>
      }
    } else if(state == '%'){
 37a:	83 fe 25             	cmp    $0x25,%esi
 37d:	74 25                	je     3a4 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 37f:	83 c3 01             	add    $0x1,%ebx
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 389:	84 c0                	test   %al,%al
 38b:	0f 84 20 01 00 00    	je     4b1 <printf+0x15e>
    c = fmt[i] & 0xff;
 391:	0f be f8             	movsbl %al,%edi
 394:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 397:	85 f6                	test   %esi,%esi
 399:	75 df                	jne    37a <printf+0x27>
      if(c == '%'){
 39b:	83 f8 25             	cmp    $0x25,%eax
 39e:	75 ce                	jne    36e <printf+0x1b>
        state = '%';
 3a0:	89 c6                	mov    %eax,%esi
 3a2:	eb db                	jmp    37f <printf+0x2c>
      if(c == 'd'){
 3a4:	83 f8 25             	cmp    $0x25,%eax
 3a7:	0f 84 cf 00 00 00    	je     47c <printf+0x129>
 3ad:	0f 8c dd 00 00 00    	jl     490 <printf+0x13d>
 3b3:	83 f8 78             	cmp    $0x78,%eax
 3b6:	0f 8f d4 00 00 00    	jg     490 <printf+0x13d>
 3bc:	83 f8 63             	cmp    $0x63,%eax
 3bf:	0f 8c cb 00 00 00    	jl     490 <printf+0x13d>
 3c5:	83 e8 63             	sub    $0x63,%eax
 3c8:	83 f8 15             	cmp    $0x15,%eax
 3cb:	0f 87 bf 00 00 00    	ja     490 <printf+0x13d>
 3d1:	ff 24 85 24 06 00 00 	jmp    *0x624(,%eax,4)
        printint(fd, *ap, 10, 1);
 3d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3db:	8b 17                	mov    (%edi),%edx
 3dd:	83 ec 0c             	sub    $0xc,%esp
 3e0:	6a 01                	push   $0x1
 3e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	e8 d9 fe ff ff       	call   2c8 <printint>
        ap++;
 3ef:	83 c7 04             	add    $0x4,%edi
 3f2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f5:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3f8:	be 00 00 00 00       	mov    $0x0,%esi
 3fd:	eb 80                	jmp    37f <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 402:	8b 17                	mov    (%edi),%edx
 404:	83 ec 0c             	sub    $0xc,%esp
 407:	6a 00                	push   $0x0
 409:	b9 10 00 00 00       	mov    $0x10,%ecx
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	e8 b2 fe ff ff       	call   2c8 <printint>
        ap++;
 416:	83 c7 04             	add    $0x4,%edi
 419:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 41f:	be 00 00 00 00       	mov    $0x0,%esi
 424:	e9 56 ff ff ff       	jmp    37f <printf+0x2c>
        s = (char*)*ap;
 429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 42c:	8b 30                	mov    (%eax),%esi
        ap++;
 42e:	83 c0 04             	add    $0x4,%eax
 431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 434:	85 f6                	test   %esi,%esi
 436:	75 15                	jne    44d <printf+0xfa>
          s = "(null)";
 438:	be 1b 06 00 00       	mov    $0x61b,%esi
 43d:	eb 0e                	jmp    44d <printf+0xfa>
          putc(fd, *s);
 43f:	0f be d2             	movsbl %dl,%edx
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	e8 64 fe ff ff       	call   2ae <putc>
          s++;
 44a:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 44d:	0f b6 16             	movzbl (%esi),%edx
 450:	84 d2                	test   %dl,%dl
 452:	75 eb                	jne    43f <printf+0xec>
      state = 0;
 454:	be 00 00 00 00       	mov    $0x0,%esi
 459:	e9 21 ff ff ff       	jmp    37f <printf+0x2c>
        putc(fd, *ap);
 45e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 461:	0f be 17             	movsbl (%edi),%edx
 464:	8b 45 08             	mov    0x8(%ebp),%eax
 467:	e8 42 fe ff ff       	call   2ae <putc>
        ap++;
 46c:	83 c7 04             	add    $0x4,%edi
 46f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 472:	be 00 00 00 00       	mov    $0x0,%esi
 477:	e9 03 ff ff ff       	jmp    37f <printf+0x2c>
        putc(fd, c);
 47c:	89 fa                	mov    %edi,%edx
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	e8 28 fe ff ff       	call   2ae <putc>
      state = 0;
 486:	be 00 00 00 00       	mov    $0x0,%esi
 48b:	e9 ef fe ff ff       	jmp    37f <printf+0x2c>
        putc(fd, '%');
 490:	ba 25 00 00 00       	mov    $0x25,%edx
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	e8 11 fe ff ff       	call   2ae <putc>
        putc(fd, c);
 49d:	89 fa                	mov    %edi,%edx
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	e8 07 fe ff ff       	call   2ae <putc>
      state = 0;
 4a7:	be 00 00 00 00       	mov    $0x0,%esi
 4ac:	e9 ce fe ff ff       	jmp    37f <printf+0x2c>
    }
  }
}
 4b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b4:	5b                   	pop    %ebx
 4b5:	5e                   	pop    %esi
 4b6:	5f                   	pop    %edi
 4b7:	5d                   	pop    %ebp
 4b8:	c3                   	ret    

000004b9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4b9:	55                   	push   %ebp
 4ba:	89 e5                	mov    %esp,%ebp
 4bc:	57                   	push   %edi
 4bd:	56                   	push   %esi
 4be:	53                   	push   %ebx
 4bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4c2:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c5:	a1 20 09 00 00       	mov    0x920,%eax
 4ca:	eb 02                	jmp    4ce <free+0x15>
 4cc:	89 d0                	mov    %edx,%eax
 4ce:	39 c8                	cmp    %ecx,%eax
 4d0:	73 04                	jae    4d6 <free+0x1d>
 4d2:	39 08                	cmp    %ecx,(%eax)
 4d4:	77 12                	ja     4e8 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d6:	8b 10                	mov    (%eax),%edx
 4d8:	39 c2                	cmp    %eax,%edx
 4da:	77 f0                	ja     4cc <free+0x13>
 4dc:	39 c8                	cmp    %ecx,%eax
 4de:	72 08                	jb     4e8 <free+0x2f>
 4e0:	39 ca                	cmp    %ecx,%edx
 4e2:	77 04                	ja     4e8 <free+0x2f>
 4e4:	89 d0                	mov    %edx,%eax
 4e6:	eb e6                	jmp    4ce <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ee:	8b 10                	mov    (%eax),%edx
 4f0:	39 d7                	cmp    %edx,%edi
 4f2:	74 19                	je     50d <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4f4:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4f7:	8b 50 04             	mov    0x4(%eax),%edx
 4fa:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4fd:	39 ce                	cmp    %ecx,%esi
 4ff:	74 1b                	je     51c <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 501:	89 08                	mov    %ecx,(%eax)
  freep = p;
 503:	a3 20 09 00 00       	mov    %eax,0x920
}
 508:	5b                   	pop    %ebx
 509:	5e                   	pop    %esi
 50a:	5f                   	pop    %edi
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 50d:	03 72 04             	add    0x4(%edx),%esi
 510:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 513:	8b 10                	mov    (%eax),%edx
 515:	8b 12                	mov    (%edx),%edx
 517:	89 53 f8             	mov    %edx,-0x8(%ebx)
 51a:	eb db                	jmp    4f7 <free+0x3e>
    p->s.size += bp->s.size;
 51c:	03 53 fc             	add    -0x4(%ebx),%edx
 51f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 522:	8b 53 f8             	mov    -0x8(%ebx),%edx
 525:	89 10                	mov    %edx,(%eax)
 527:	eb da                	jmp    503 <free+0x4a>

00000529 <morecore>:

static Header*
morecore(uint nu)
{
 529:	55                   	push   %ebp
 52a:	89 e5                	mov    %esp,%ebp
 52c:	53                   	push   %ebx
 52d:	83 ec 04             	sub    $0x4,%esp
 530:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 532:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 537:	77 05                	ja     53e <morecore+0x15>
    nu = 4096;
 539:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 53e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 545:	83 ec 0c             	sub    $0xc,%esp
 548:	50                   	push   %eax
 549:	e8 28 fd ff ff       	call   276 <sbrk>
  if(p == (char*)-1)
 54e:	83 c4 10             	add    $0x10,%esp
 551:	83 f8 ff             	cmp    $0xffffffff,%eax
 554:	74 1c                	je     572 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 556:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 559:	83 c0 08             	add    $0x8,%eax
 55c:	83 ec 0c             	sub    $0xc,%esp
 55f:	50                   	push   %eax
 560:	e8 54 ff ff ff       	call   4b9 <free>
  return freep;
 565:	a1 20 09 00 00       	mov    0x920,%eax
 56a:	83 c4 10             	add    $0x10,%esp
}
 56d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 570:	c9                   	leave  
 571:	c3                   	ret    
    return 0;
 572:	b8 00 00 00 00       	mov    $0x0,%eax
 577:	eb f4                	jmp    56d <morecore+0x44>

00000579 <malloc>:

void*
malloc(uint nbytes)
{
 579:	55                   	push   %ebp
 57a:	89 e5                	mov    %esp,%ebp
 57c:	53                   	push   %ebx
 57d:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	8d 58 07             	lea    0x7(%eax),%ebx
 586:	c1 eb 03             	shr    $0x3,%ebx
 589:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 58c:	8b 0d 20 09 00 00    	mov    0x920,%ecx
 592:	85 c9                	test   %ecx,%ecx
 594:	74 04                	je     59a <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 596:	8b 01                	mov    (%ecx),%eax
 598:	eb 4a                	jmp    5e4 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 59a:	c7 05 20 09 00 00 24 	movl   $0x924,0x920
 5a1:	09 00 00 
 5a4:	c7 05 24 09 00 00 24 	movl   $0x924,0x924
 5ab:	09 00 00 
    base.s.size = 0;
 5ae:	c7 05 28 09 00 00 00 	movl   $0x0,0x928
 5b5:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5b8:	b9 24 09 00 00       	mov    $0x924,%ecx
 5bd:	eb d7                	jmp    596 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5bf:	74 19                	je     5da <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c1:	29 da                	sub    %ebx,%edx
 5c3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5c6:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5c9:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5cc:	89 0d 20 09 00 00    	mov    %ecx,0x920
      return (void*)(p + 1);
 5d2:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d8:	c9                   	leave  
 5d9:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5da:	8b 10                	mov    (%eax),%edx
 5dc:	89 11                	mov    %edx,(%ecx)
 5de:	eb ec                	jmp    5cc <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e0:	89 c1                	mov    %eax,%ecx
 5e2:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5e4:	8b 50 04             	mov    0x4(%eax),%edx
 5e7:	39 da                	cmp    %ebx,%edx
 5e9:	73 d4                	jae    5bf <malloc+0x46>
    if(p == freep)
 5eb:	39 05 20 09 00 00    	cmp    %eax,0x920
 5f1:	75 ed                	jne    5e0 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5f3:	89 d8                	mov    %ebx,%eax
 5f5:	e8 2f ff ff ff       	call   529 <morecore>
 5fa:	85 c0                	test   %eax,%eax
 5fc:	75 e2                	jne    5e0 <malloc+0x67>
 5fe:	eb d5                	jmp    5d5 <malloc+0x5c>
