
_test_16:     file format elf32-i386


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
  17:	e8 4f 02 00 00       	call   26b <sbrk>
  1c:	89 c3                	mov    %eax,%ebx
    munprotect(ptr, PAGES_NUM);
  1e:	83 c4 08             	add    $0x8,%esp
  21:	6a 05                	push   $0x5
  23:	50                   	push   %eax
  24:	e8 72 02 00 00       	call   29b <munprotect>
    ptr[PGSIZE * 3] = 0xAA;
  29:	c6 83 00 30 00 00 aa 	movb   $0xaa,0x3000(%ebx)
    printf(1, "XV6_TEST_OUTPUT TEST PASS\n");
  30:	83 c4 08             	add    $0x8,%esp
  33:	68 f8 05 00 00       	push   $0x5f8
  38:	6a 01                	push   $0x1
  3a:	e8 09 03 00 00       	call   348 <printf>
    exit();
  3f:	e8 9f 01 00 00       	call   1e3 <exit>

00000044 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  44:	55                   	push   %ebp
  45:	89 e5                	mov    %esp,%ebp
  47:	56                   	push   %esi
  48:	53                   	push   %ebx
  49:	8b 75 08             	mov    0x8(%ebp),%esi
  4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4f:	89 f0                	mov    %esi,%eax
  51:	89 d1                	mov    %edx,%ecx
  53:	83 c2 01             	add    $0x1,%edx
  56:	89 c3                	mov    %eax,%ebx
  58:	83 c0 01             	add    $0x1,%eax
  5b:	0f b6 09             	movzbl (%ecx),%ecx
  5e:	88 0b                	mov    %cl,(%ebx)
  60:	84 c9                	test   %cl,%cl
  62:	75 ed                	jne    51 <strcpy+0xd>
    ;
  return os;
}
  64:	89 f0                	mov    %esi,%eax
  66:	5b                   	pop    %ebx
  67:	5e                   	pop    %esi
  68:	5d                   	pop    %ebp
  69:	c3                   	ret    

0000006a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6a:	55                   	push   %ebp
  6b:	89 e5                	mov    %esp,%ebp
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  73:	eb 06                	jmp    7b <strcmp+0x11>
    p++, q++;
  75:	83 c1 01             	add    $0x1,%ecx
  78:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  7b:	0f b6 01             	movzbl (%ecx),%eax
  7e:	84 c0                	test   %al,%al
  80:	74 04                	je     86 <strcmp+0x1c>
  82:	3a 02                	cmp    (%edx),%al
  84:	74 ef                	je     75 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  86:	0f b6 c0             	movzbl %al,%eax
  89:	0f b6 12             	movzbl (%edx),%edx
  8c:	29 d0                	sub    %edx,%eax
}
  8e:	5d                   	pop    %ebp
  8f:	c3                   	ret    

00000090 <strlen>:

uint
strlen(const char *s)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  96:	b8 00 00 00 00       	mov    $0x0,%eax
  9b:	eb 03                	jmp    a0 <strlen+0x10>
  9d:	83 c0 01             	add    $0x1,%eax
  a0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  a4:	75 f7                	jne    9d <strlen+0xd>
    ;
  return n;
}
  a6:	5d                   	pop    %ebp
  a7:	c3                   	ret    

000000a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  af:	89 d7                	mov    %edx,%edi
  b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  b7:	fc                   	cld    
  b8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ba:	89 d0                	mov    %edx,%eax
  bc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strchr>:

char*
strchr(const char *s, char c)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  cb:	eb 03                	jmp    d0 <strchr+0xf>
  cd:	83 c0 01             	add    $0x1,%eax
  d0:	0f b6 10             	movzbl (%eax),%edx
  d3:	84 d2                	test   %dl,%dl
  d5:	74 06                	je     dd <strchr+0x1c>
    if(*s == c)
  d7:	38 ca                	cmp    %cl,%dl
  d9:	75 f2                	jne    cd <strchr+0xc>
  db:	eb 05                	jmp    e2 <strchr+0x21>
      return (char*)s;
  return 0;
  dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    

000000e4 <gets>:

char*
gets(char *buf, int max)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	57                   	push   %edi
  e8:	56                   	push   %esi
  e9:	53                   	push   %ebx
  ea:	83 ec 1c             	sub    $0x1c,%esp
  ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  f5:	89 de                	mov    %ebx,%esi
  f7:	83 c3 01             	add    $0x1,%ebx
  fa:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  fd:	7d 2e                	jge    12d <gets+0x49>
    cc = read(0, &c, 1);
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	6a 01                	push   $0x1
 104:	8d 45 e7             	lea    -0x19(%ebp),%eax
 107:	50                   	push   %eax
 108:	6a 00                	push   $0x0
 10a:	e8 ec 00 00 00       	call   1fb <read>
    if(cc < 1)
 10f:	83 c4 10             	add    $0x10,%esp
 112:	85 c0                	test   %eax,%eax
 114:	7e 17                	jle    12d <gets+0x49>
      break;
    buf[i++] = c;
 116:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 11d:	3c 0a                	cmp    $0xa,%al
 11f:	0f 94 c2             	sete   %dl
 122:	3c 0d                	cmp    $0xd,%al
 124:	0f 94 c0             	sete   %al
 127:	08 c2                	or     %al,%dl
 129:	74 ca                	je     f5 <gets+0x11>
    buf[i++] = c;
 12b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 12d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 131:	89 f8                	mov    %edi,%eax
 133:	8d 65 f4             	lea    -0xc(%ebp),%esp
 136:	5b                   	pop    %ebx
 137:	5e                   	pop    %esi
 138:	5f                   	pop    %edi
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    

0000013b <stat>:

int
stat(const char *n, struct stat *st)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	56                   	push   %esi
 13f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 140:	83 ec 08             	sub    $0x8,%esp
 143:	6a 00                	push   $0x0
 145:	ff 75 08             	push   0x8(%ebp)
 148:	e8 d6 00 00 00       	call   223 <open>
  if(fd < 0)
 14d:	83 c4 10             	add    $0x10,%esp
 150:	85 c0                	test   %eax,%eax
 152:	78 24                	js     178 <stat+0x3d>
 154:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 156:	83 ec 08             	sub    $0x8,%esp
 159:	ff 75 0c             	push   0xc(%ebp)
 15c:	50                   	push   %eax
 15d:	e8 d9 00 00 00       	call   23b <fstat>
 162:	89 c6                	mov    %eax,%esi
  close(fd);
 164:	89 1c 24             	mov    %ebx,(%esp)
 167:	e8 9f 00 00 00       	call   20b <close>
  return r;
 16c:	83 c4 10             	add    $0x10,%esp
}
 16f:	89 f0                	mov    %esi,%eax
 171:	8d 65 f8             	lea    -0x8(%ebp),%esp
 174:	5b                   	pop    %ebx
 175:	5e                   	pop    %esi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    
    return -1;
 178:	be ff ff ff ff       	mov    $0xffffffff,%esi
 17d:	eb f0                	jmp    16f <stat+0x34>

0000017f <atoi>:

int
atoi(const char *s)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	53                   	push   %ebx
 183:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 186:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 18b:	eb 10                	jmp    19d <atoi+0x1e>
    n = n*10 + *s++ - '0';
 18d:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 190:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 193:	83 c1 01             	add    $0x1,%ecx
 196:	0f be c0             	movsbl %al,%eax
 199:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 19d:	0f b6 01             	movzbl (%ecx),%eax
 1a0:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1a3:	80 fb 09             	cmp    $0x9,%bl
 1a6:	76 e5                	jbe    18d <atoi+0xe>
  return n;
}
 1a8:	89 d0                	mov    %edx,%eax
 1aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	56                   	push   %esi
 1b3:	53                   	push   %ebx
 1b4:	8b 75 08             	mov    0x8(%ebp),%esi
 1b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1ba:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1bd:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1bf:	eb 0d                	jmp    1ce <memmove+0x1f>
    *dst++ = *src++;
 1c1:	0f b6 01             	movzbl (%ecx),%eax
 1c4:	88 02                	mov    %al,(%edx)
 1c6:	8d 49 01             	lea    0x1(%ecx),%ecx
 1c9:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1cc:	89 d8                	mov    %ebx,%eax
 1ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1d1:	85 c0                	test   %eax,%eax
 1d3:	7f ec                	jg     1c1 <memmove+0x12>
  return vdst;
}
 1d5:	89 f0                	mov    %esi,%eax
 1d7:	5b                   	pop    %ebx
 1d8:	5e                   	pop    %esi
 1d9:	5d                   	pop    %ebp
 1da:	c3                   	ret    

000001db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1db:	b8 01 00 00 00       	mov    $0x1,%eax
 1e0:	cd 40                	int    $0x40
 1e2:	c3                   	ret    

000001e3 <exit>:
SYSCALL(exit)
 1e3:	b8 02 00 00 00       	mov    $0x2,%eax
 1e8:	cd 40                	int    $0x40
 1ea:	c3                   	ret    

000001eb <wait>:
SYSCALL(wait)
 1eb:	b8 03 00 00 00       	mov    $0x3,%eax
 1f0:	cd 40                	int    $0x40
 1f2:	c3                   	ret    

000001f3 <pipe>:
SYSCALL(pipe)
 1f3:	b8 04 00 00 00       	mov    $0x4,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	ret    

000001fb <read>:
SYSCALL(read)
 1fb:	b8 05 00 00 00       	mov    $0x5,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	ret    

00000203 <write>:
SYSCALL(write)
 203:	b8 10 00 00 00       	mov    $0x10,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	ret    

0000020b <close>:
SYSCALL(close)
 20b:	b8 15 00 00 00       	mov    $0x15,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret    

00000213 <kill>:
SYSCALL(kill)
 213:	b8 06 00 00 00       	mov    $0x6,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <exec>:
SYSCALL(exec)
 21b:	b8 07 00 00 00       	mov    $0x7,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <open>:
SYSCALL(open)
 223:	b8 0f 00 00 00       	mov    $0xf,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <mknod>:
SYSCALL(mknod)
 22b:	b8 11 00 00 00       	mov    $0x11,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <unlink>:
SYSCALL(unlink)
 233:	b8 12 00 00 00       	mov    $0x12,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <fstat>:
SYSCALL(fstat)
 23b:	b8 08 00 00 00       	mov    $0x8,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <link>:
SYSCALL(link)
 243:	b8 13 00 00 00       	mov    $0x13,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <mkdir>:
SYSCALL(mkdir)
 24b:	b8 14 00 00 00       	mov    $0x14,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <chdir>:
SYSCALL(chdir)
 253:	b8 09 00 00 00       	mov    $0x9,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <dup>:
SYSCALL(dup)
 25b:	b8 0a 00 00 00       	mov    $0xa,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <getpid>:
SYSCALL(getpid)
 263:	b8 0b 00 00 00       	mov    $0xb,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <sbrk>:
SYSCALL(sbrk)
 26b:	b8 0c 00 00 00       	mov    $0xc,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <sleep>:
SYSCALL(sleep)
 273:	b8 0d 00 00 00       	mov    $0xd,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <uptime>:
SYSCALL(uptime)
 27b:	b8 0e 00 00 00       	mov    $0xe,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <settickets>:
SYSCALL(settickets)
 283:	b8 16 00 00 00       	mov    $0x16,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <getpinfo>:
SYSCALL(getpinfo)
 28b:	b8 17 00 00 00       	mov    $0x17,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <mprotect>:
SYSCALL(mprotect)
 293:	b8 18 00 00 00       	mov    $0x18,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <munprotect>:
SYSCALL(munprotect)
 29b:	b8 19 00 00 00       	mov    $0x19,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 1c             	sub    $0x1c,%esp
 2a9:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2ac:	6a 01                	push   $0x1
 2ae:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2b1:	52                   	push   %edx
 2b2:	50                   	push   %eax
 2b3:	e8 4b ff ff ff       	call   203 <write>
}
 2b8:	83 c4 10             	add    $0x10,%esp
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	57                   	push   %edi
 2c1:	56                   	push   %esi
 2c2:	53                   	push   %ebx
 2c3:	83 ec 2c             	sub    $0x2c,%esp
 2c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2c9:	89 d0                	mov    %edx,%eax
 2cb:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d1:	0f 95 c1             	setne  %cl
 2d4:	c1 ea 1f             	shr    $0x1f,%edx
 2d7:	84 d1                	test   %dl,%cl
 2d9:	74 44                	je     31f <printint+0x62>
    neg = 1;
    x = -xx;
 2db:	f7 d8                	neg    %eax
 2dd:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2df:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2eb:	89 c8                	mov    %ecx,%eax
 2ed:	ba 00 00 00 00       	mov    $0x0,%edx
 2f2:	f7 f6                	div    %esi
 2f4:	89 df                	mov    %ebx,%edi
 2f6:	83 c3 01             	add    $0x1,%ebx
 2f9:	0f b6 92 74 06 00 00 	movzbl 0x674(%edx),%edx
 300:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 304:	89 ca                	mov    %ecx,%edx
 306:	89 c1                	mov    %eax,%ecx
 308:	39 d6                	cmp    %edx,%esi
 30a:	76 df                	jbe    2eb <printint+0x2e>
  if(neg)
 30c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 310:	74 31                	je     343 <printint+0x86>
    buf[i++] = '-';
 312:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 317:	8d 5f 02             	lea    0x2(%edi),%ebx
 31a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 31d:	eb 17                	jmp    336 <printint+0x79>
    x = xx;
 31f:	89 c1                	mov    %eax,%ecx
  neg = 0;
 321:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 328:	eb bc                	jmp    2e6 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 32a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 32f:	89 f0                	mov    %esi,%eax
 331:	e8 6d ff ff ff       	call   2a3 <putc>
  while(--i >= 0)
 336:	83 eb 01             	sub    $0x1,%ebx
 339:	79 ef                	jns    32a <printint+0x6d>
}
 33b:	83 c4 2c             	add    $0x2c,%esp
 33e:	5b                   	pop    %ebx
 33f:	5e                   	pop    %esi
 340:	5f                   	pop    %edi
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
 343:	8b 75 d0             	mov    -0x30(%ebp),%esi
 346:	eb ee                	jmp    336 <printint+0x79>

00000348 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	57                   	push   %edi
 34c:	56                   	push   %esi
 34d:	53                   	push   %ebx
 34e:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 351:	8d 45 10             	lea    0x10(%ebp),%eax
 354:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 357:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 35c:	bb 00 00 00 00       	mov    $0x0,%ebx
 361:	eb 14                	jmp    377 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 363:	89 fa                	mov    %edi,%edx
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	e8 36 ff ff ff       	call   2a3 <putc>
 36d:	eb 05                	jmp    374 <printf+0x2c>
      }
    } else if(state == '%'){
 36f:	83 fe 25             	cmp    $0x25,%esi
 372:	74 25                	je     399 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 374:	83 c3 01             	add    $0x1,%ebx
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 37e:	84 c0                	test   %al,%al
 380:	0f 84 20 01 00 00    	je     4a6 <printf+0x15e>
    c = fmt[i] & 0xff;
 386:	0f be f8             	movsbl %al,%edi
 389:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 38c:	85 f6                	test   %esi,%esi
 38e:	75 df                	jne    36f <printf+0x27>
      if(c == '%'){
 390:	83 f8 25             	cmp    $0x25,%eax
 393:	75 ce                	jne    363 <printf+0x1b>
        state = '%';
 395:	89 c6                	mov    %eax,%esi
 397:	eb db                	jmp    374 <printf+0x2c>
      if(c == 'd'){
 399:	83 f8 25             	cmp    $0x25,%eax
 39c:	0f 84 cf 00 00 00    	je     471 <printf+0x129>
 3a2:	0f 8c dd 00 00 00    	jl     485 <printf+0x13d>
 3a8:	83 f8 78             	cmp    $0x78,%eax
 3ab:	0f 8f d4 00 00 00    	jg     485 <printf+0x13d>
 3b1:	83 f8 63             	cmp    $0x63,%eax
 3b4:	0f 8c cb 00 00 00    	jl     485 <printf+0x13d>
 3ba:	83 e8 63             	sub    $0x63,%eax
 3bd:	83 f8 15             	cmp    $0x15,%eax
 3c0:	0f 87 bf 00 00 00    	ja     485 <printf+0x13d>
 3c6:	ff 24 85 1c 06 00 00 	jmp    *0x61c(,%eax,4)
        printint(fd, *ap, 10, 1);
 3cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d0:	8b 17                	mov    (%edi),%edx
 3d2:	83 ec 0c             	sub    $0xc,%esp
 3d5:	6a 01                	push   $0x1
 3d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	e8 d9 fe ff ff       	call   2bd <printint>
        ap++;
 3e4:	83 c7 04             	add    $0x4,%edi
 3e7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3ea:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3ed:	be 00 00 00 00       	mov    $0x0,%esi
 3f2:	eb 80                	jmp    374 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f7:	8b 17                	mov    (%edi),%edx
 3f9:	83 ec 0c             	sub    $0xc,%esp
 3fc:	6a 00                	push   $0x0
 3fe:	b9 10 00 00 00       	mov    $0x10,%ecx
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	e8 b2 fe ff ff       	call   2bd <printint>
        ap++;
 40b:	83 c7 04             	add    $0x4,%edi
 40e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 411:	83 c4 10             	add    $0x10,%esp
      state = 0;
 414:	be 00 00 00 00       	mov    $0x0,%esi
 419:	e9 56 ff ff ff       	jmp    374 <printf+0x2c>
        s = (char*)*ap;
 41e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 421:	8b 30                	mov    (%eax),%esi
        ap++;
 423:	83 c0 04             	add    $0x4,%eax
 426:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 429:	85 f6                	test   %esi,%esi
 42b:	75 15                	jne    442 <printf+0xfa>
          s = "(null)";
 42d:	be 13 06 00 00       	mov    $0x613,%esi
 432:	eb 0e                	jmp    442 <printf+0xfa>
          putc(fd, *s);
 434:	0f be d2             	movsbl %dl,%edx
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	e8 64 fe ff ff       	call   2a3 <putc>
          s++;
 43f:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 442:	0f b6 16             	movzbl (%esi),%edx
 445:	84 d2                	test   %dl,%dl
 447:	75 eb                	jne    434 <printf+0xec>
      state = 0;
 449:	be 00 00 00 00       	mov    $0x0,%esi
 44e:	e9 21 ff ff ff       	jmp    374 <printf+0x2c>
        putc(fd, *ap);
 453:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 456:	0f be 17             	movsbl (%edi),%edx
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	e8 42 fe ff ff       	call   2a3 <putc>
        ap++;
 461:	83 c7 04             	add    $0x4,%edi
 464:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 467:	be 00 00 00 00       	mov    $0x0,%esi
 46c:	e9 03 ff ff ff       	jmp    374 <printf+0x2c>
        putc(fd, c);
 471:	89 fa                	mov    %edi,%edx
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	e8 28 fe ff ff       	call   2a3 <putc>
      state = 0;
 47b:	be 00 00 00 00       	mov    $0x0,%esi
 480:	e9 ef fe ff ff       	jmp    374 <printf+0x2c>
        putc(fd, '%');
 485:	ba 25 00 00 00       	mov    $0x25,%edx
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	e8 11 fe ff ff       	call   2a3 <putc>
        putc(fd, c);
 492:	89 fa                	mov    %edi,%edx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	e8 07 fe ff ff       	call   2a3 <putc>
      state = 0;
 49c:	be 00 00 00 00       	mov    $0x0,%esi
 4a1:	e9 ce fe ff ff       	jmp    374 <printf+0x2c>
    }
  }
}
 4a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a9:	5b                   	pop    %ebx
 4aa:	5e                   	pop    %esi
 4ab:	5f                   	pop    %edi
 4ac:	5d                   	pop    %ebp
 4ad:	c3                   	ret    

000004ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	57                   	push   %edi
 4b2:	56                   	push   %esi
 4b3:	53                   	push   %ebx
 4b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4b7:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ba:	a1 18 09 00 00       	mov    0x918,%eax
 4bf:	eb 02                	jmp    4c3 <free+0x15>
 4c1:	89 d0                	mov    %edx,%eax
 4c3:	39 c8                	cmp    %ecx,%eax
 4c5:	73 04                	jae    4cb <free+0x1d>
 4c7:	39 08                	cmp    %ecx,(%eax)
 4c9:	77 12                	ja     4dd <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4cb:	8b 10                	mov    (%eax),%edx
 4cd:	39 c2                	cmp    %eax,%edx
 4cf:	77 f0                	ja     4c1 <free+0x13>
 4d1:	39 c8                	cmp    %ecx,%eax
 4d3:	72 08                	jb     4dd <free+0x2f>
 4d5:	39 ca                	cmp    %ecx,%edx
 4d7:	77 04                	ja     4dd <free+0x2f>
 4d9:	89 d0                	mov    %edx,%eax
 4db:	eb e6                	jmp    4c3 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4dd:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4e0:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4e3:	8b 10                	mov    (%eax),%edx
 4e5:	39 d7                	cmp    %edx,%edi
 4e7:	74 19                	je     502 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4e9:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4ec:	8b 50 04             	mov    0x4(%eax),%edx
 4ef:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4f2:	39 ce                	cmp    %ecx,%esi
 4f4:	74 1b                	je     511 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4f6:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4f8:	a3 18 09 00 00       	mov    %eax,0x918
}
 4fd:	5b                   	pop    %ebx
 4fe:	5e                   	pop    %esi
 4ff:	5f                   	pop    %edi
 500:	5d                   	pop    %ebp
 501:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 502:	03 72 04             	add    0x4(%edx),%esi
 505:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 508:	8b 10                	mov    (%eax),%edx
 50a:	8b 12                	mov    (%edx),%edx
 50c:	89 53 f8             	mov    %edx,-0x8(%ebx)
 50f:	eb db                	jmp    4ec <free+0x3e>
    p->s.size += bp->s.size;
 511:	03 53 fc             	add    -0x4(%ebx),%edx
 514:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 517:	8b 53 f8             	mov    -0x8(%ebx),%edx
 51a:	89 10                	mov    %edx,(%eax)
 51c:	eb da                	jmp    4f8 <free+0x4a>

0000051e <morecore>:

static Header*
morecore(uint nu)
{
 51e:	55                   	push   %ebp
 51f:	89 e5                	mov    %esp,%ebp
 521:	53                   	push   %ebx
 522:	83 ec 04             	sub    $0x4,%esp
 525:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 527:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 52c:	77 05                	ja     533 <morecore+0x15>
    nu = 4096;
 52e:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 533:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 53a:	83 ec 0c             	sub    $0xc,%esp
 53d:	50                   	push   %eax
 53e:	e8 28 fd ff ff       	call   26b <sbrk>
  if(p == (char*)-1)
 543:	83 c4 10             	add    $0x10,%esp
 546:	83 f8 ff             	cmp    $0xffffffff,%eax
 549:	74 1c                	je     567 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 54b:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 54e:	83 c0 08             	add    $0x8,%eax
 551:	83 ec 0c             	sub    $0xc,%esp
 554:	50                   	push   %eax
 555:	e8 54 ff ff ff       	call   4ae <free>
  return freep;
 55a:	a1 18 09 00 00       	mov    0x918,%eax
 55f:	83 c4 10             	add    $0x10,%esp
}
 562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 565:	c9                   	leave  
 566:	c3                   	ret    
    return 0;
 567:	b8 00 00 00 00       	mov    $0x0,%eax
 56c:	eb f4                	jmp    562 <morecore+0x44>

0000056e <malloc>:

void*
malloc(uint nbytes)
{
 56e:	55                   	push   %ebp
 56f:	89 e5                	mov    %esp,%ebp
 571:	53                   	push   %ebx
 572:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	8d 58 07             	lea    0x7(%eax),%ebx
 57b:	c1 eb 03             	shr    $0x3,%ebx
 57e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 581:	8b 0d 18 09 00 00    	mov    0x918,%ecx
 587:	85 c9                	test   %ecx,%ecx
 589:	74 04                	je     58f <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 58b:	8b 01                	mov    (%ecx),%eax
 58d:	eb 4a                	jmp    5d9 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 58f:	c7 05 18 09 00 00 1c 	movl   $0x91c,0x918
 596:	09 00 00 
 599:	c7 05 1c 09 00 00 1c 	movl   $0x91c,0x91c
 5a0:	09 00 00 
    base.s.size = 0;
 5a3:	c7 05 20 09 00 00 00 	movl   $0x0,0x920
 5aa:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5ad:	b9 1c 09 00 00       	mov    $0x91c,%ecx
 5b2:	eb d7                	jmp    58b <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5b4:	74 19                	je     5cf <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5b6:	29 da                	sub    %ebx,%edx
 5b8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5bb:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5be:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5c1:	89 0d 18 09 00 00    	mov    %ecx,0x918
      return (void*)(p + 1);
 5c7:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5cd:	c9                   	leave  
 5ce:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5cf:	8b 10                	mov    (%eax),%edx
 5d1:	89 11                	mov    %edx,(%ecx)
 5d3:	eb ec                	jmp    5c1 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d5:	89 c1                	mov    %eax,%ecx
 5d7:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5d9:	8b 50 04             	mov    0x4(%eax),%edx
 5dc:	39 da                	cmp    %ebx,%edx
 5de:	73 d4                	jae    5b4 <malloc+0x46>
    if(p == freep)
 5e0:	39 05 18 09 00 00    	cmp    %eax,0x918
 5e6:	75 ed                	jne    5d5 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5e8:	89 d8                	mov    %ebx,%eax
 5ea:	e8 2f ff ff ff       	call   51e <morecore>
 5ef:	85 c0                	test   %eax,%eax
 5f1:	75 e2                	jne    5d5 <malloc+0x67>
 5f3:	eb d5                	jmp    5ca <malloc+0x5c>
