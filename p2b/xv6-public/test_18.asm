
_test_18:     file format elf32-i386


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
  17:	e8 70 02 00 00       	call   28c <sbrk>
  1c:	89 c3                	mov    %eax,%ebx
    mprotect(ptr, PAGES_NUM);
  1e:	83 c4 08             	add    $0x8,%esp
  21:	6a 05                	push   $0x5
  23:	50                   	push   %eax
  24:	e8 8b 02 00 00       	call   2b4 <mprotect>

    if (fork() == 0) {
  29:	e8 ce 01 00 00       	call   1fc <fork>
  2e:	83 c4 10             	add    $0x10,%esp
  31:	85 c0                	test   %eax,%eax
  33:	75 26                	jne    5b <main+0x5b>
        // Should NOT page fault 
        munprotect(ptr, PAGES_NUM);
  35:	83 ec 08             	sub    $0x8,%esp
  38:	6a 05                	push   $0x5
  3a:	53                   	push   %ebx
  3b:	e8 7c 02 00 00       	call   2bc <munprotect>
        ptr[4 * PGSIZE] = 0xAA;
  40:	c6 83 00 40 00 00 aa 	movb   $0xaa,0x4000(%ebx)
        printf(1, "XV6_TEST_OUTPUT TEST PASS\n");
  47:	83 c4 08             	add    $0x8,%esp
  4a:	68 18 06 00 00       	push   $0x618
  4f:	6a 01                	push   $0x1
  51:	e8 13 03 00 00       	call   369 <printf>
        exit();
  56:	e8 a9 01 00 00       	call   204 <exit>
    } else {
        wait();
  5b:	e8 ac 01 00 00       	call   20c <wait>
    }
    exit();
  60:	e8 9f 01 00 00       	call   204 <exit>

00000065 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	56                   	push   %esi
  69:	53                   	push   %ebx
  6a:	8b 75 08             	mov    0x8(%ebp),%esi
  6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  70:	89 f0                	mov    %esi,%eax
  72:	89 d1                	mov    %edx,%ecx
  74:	83 c2 01             	add    $0x1,%edx
  77:	89 c3                	mov    %eax,%ebx
  79:	83 c0 01             	add    $0x1,%eax
  7c:	0f b6 09             	movzbl (%ecx),%ecx
  7f:	88 0b                	mov    %cl,(%ebx)
  81:	84 c9                	test   %cl,%cl
  83:	75 ed                	jne    72 <strcpy+0xd>
    ;
  return os;
}
  85:	89 f0                	mov    %esi,%eax
  87:	5b                   	pop    %ebx
  88:	5e                   	pop    %esi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  91:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  94:	eb 06                	jmp    9c <strcmp+0x11>
    p++, q++;
  96:	83 c1 01             	add    $0x1,%ecx
  99:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  9c:	0f b6 01             	movzbl (%ecx),%eax
  9f:	84 c0                	test   %al,%al
  a1:	74 04                	je     a7 <strcmp+0x1c>
  a3:	3a 02                	cmp    (%edx),%al
  a5:	74 ef                	je     96 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  a7:	0f b6 c0             	movzbl %al,%eax
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	29 d0                	sub    %edx,%eax
}
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    

000000b1 <strlen>:

uint
strlen(const char *s)
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b7:	b8 00 00 00 00       	mov    $0x0,%eax
  bc:	eb 03                	jmp    c1 <strlen+0x10>
  be:	83 c0 01             	add    $0x1,%eax
  c1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  c5:	75 f7                	jne    be <strlen+0xd>
    ;
  return n;
}
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    

000000c9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  cc:	57                   	push   %edi
  cd:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d0:	89 d7                	mov    %edx,%edi
  d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  d8:	fc                   	cld    
  d9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  db:	89 d0                	mov    %edx,%eax
  dd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  e0:	c9                   	leave  
  e1:	c3                   	ret    

000000e2 <strchr>:

char*
strchr(const char *s, char c)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ec:	eb 03                	jmp    f1 <strchr+0xf>
  ee:	83 c0 01             	add    $0x1,%eax
  f1:	0f b6 10             	movzbl (%eax),%edx
  f4:	84 d2                	test   %dl,%dl
  f6:	74 06                	je     fe <strchr+0x1c>
    if(*s == c)
  f8:	38 ca                	cmp    %cl,%dl
  fa:	75 f2                	jne    ee <strchr+0xc>
  fc:	eb 05                	jmp    103 <strchr+0x21>
      return (char*)s;
  return 0;
  fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <gets>:

char*
gets(char *buf, int max)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	57                   	push   %edi
 109:	56                   	push   %esi
 10a:	53                   	push   %ebx
 10b:	83 ec 1c             	sub    $0x1c,%esp
 10e:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 111:	bb 00 00 00 00       	mov    $0x0,%ebx
 116:	89 de                	mov    %ebx,%esi
 118:	83 c3 01             	add    $0x1,%ebx
 11b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 11e:	7d 2e                	jge    14e <gets+0x49>
    cc = read(0, &c, 1);
 120:	83 ec 04             	sub    $0x4,%esp
 123:	6a 01                	push   $0x1
 125:	8d 45 e7             	lea    -0x19(%ebp),%eax
 128:	50                   	push   %eax
 129:	6a 00                	push   $0x0
 12b:	e8 ec 00 00 00       	call   21c <read>
    if(cc < 1)
 130:	83 c4 10             	add    $0x10,%esp
 133:	85 c0                	test   %eax,%eax
 135:	7e 17                	jle    14e <gets+0x49>
      break;
    buf[i++] = c;
 137:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 13b:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 13e:	3c 0a                	cmp    $0xa,%al
 140:	0f 94 c2             	sete   %dl
 143:	3c 0d                	cmp    $0xd,%al
 145:	0f 94 c0             	sete   %al
 148:	08 c2                	or     %al,%dl
 14a:	74 ca                	je     116 <gets+0x11>
    buf[i++] = c;
 14c:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 14e:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 152:	89 f8                	mov    %edi,%eax
 154:	8d 65 f4             	lea    -0xc(%ebp),%esp
 157:	5b                   	pop    %ebx
 158:	5e                   	pop    %esi
 159:	5f                   	pop    %edi
 15a:	5d                   	pop    %ebp
 15b:	c3                   	ret    

0000015c <stat>:

int
stat(const char *n, struct stat *st)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	56                   	push   %esi
 160:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 161:	83 ec 08             	sub    $0x8,%esp
 164:	6a 00                	push   $0x0
 166:	ff 75 08             	push   0x8(%ebp)
 169:	e8 d6 00 00 00       	call   244 <open>
  if(fd < 0)
 16e:	83 c4 10             	add    $0x10,%esp
 171:	85 c0                	test   %eax,%eax
 173:	78 24                	js     199 <stat+0x3d>
 175:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 177:	83 ec 08             	sub    $0x8,%esp
 17a:	ff 75 0c             	push   0xc(%ebp)
 17d:	50                   	push   %eax
 17e:	e8 d9 00 00 00       	call   25c <fstat>
 183:	89 c6                	mov    %eax,%esi
  close(fd);
 185:	89 1c 24             	mov    %ebx,(%esp)
 188:	e8 9f 00 00 00       	call   22c <close>
  return r;
 18d:	83 c4 10             	add    $0x10,%esp
}
 190:	89 f0                	mov    %esi,%eax
 192:	8d 65 f8             	lea    -0x8(%ebp),%esp
 195:	5b                   	pop    %ebx
 196:	5e                   	pop    %esi
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
    return -1;
 199:	be ff ff ff ff       	mov    $0xffffffff,%esi
 19e:	eb f0                	jmp    190 <stat+0x34>

000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1a7:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1ac:	eb 10                	jmp    1be <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1ae:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1b1:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1b4:	83 c1 01             	add    $0x1,%ecx
 1b7:	0f be c0             	movsbl %al,%eax
 1ba:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1be:	0f b6 01             	movzbl (%ecx),%eax
 1c1:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1c4:	80 fb 09             	cmp    $0x9,%bl
 1c7:	76 e5                	jbe    1ae <atoi+0xe>
  return n;
}
 1c9:	89 d0                	mov    %edx,%eax
 1cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
 1d5:	8b 75 08             	mov    0x8(%ebp),%esi
 1d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1db:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1de:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1e0:	eb 0d                	jmp    1ef <memmove+0x1f>
    *dst++ = *src++;
 1e2:	0f b6 01             	movzbl (%ecx),%eax
 1e5:	88 02                	mov    %al,(%edx)
 1e7:	8d 49 01             	lea    0x1(%ecx),%ecx
 1ea:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1ed:	89 d8                	mov    %ebx,%eax
 1ef:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1f2:	85 c0                	test   %eax,%eax
 1f4:	7f ec                	jg     1e2 <memmove+0x12>
  return vdst;
}
 1f6:	89 f0                	mov    %esi,%eax
 1f8:	5b                   	pop    %ebx
 1f9:	5e                   	pop    %esi
 1fa:	5d                   	pop    %ebp
 1fb:	c3                   	ret    

000001fc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1fc:	b8 01 00 00 00       	mov    $0x1,%eax
 201:	cd 40                	int    $0x40
 203:	c3                   	ret    

00000204 <exit>:
SYSCALL(exit)
 204:	b8 02 00 00 00       	mov    $0x2,%eax
 209:	cd 40                	int    $0x40
 20b:	c3                   	ret    

0000020c <wait>:
SYSCALL(wait)
 20c:	b8 03 00 00 00       	mov    $0x3,%eax
 211:	cd 40                	int    $0x40
 213:	c3                   	ret    

00000214 <pipe>:
SYSCALL(pipe)
 214:	b8 04 00 00 00       	mov    $0x4,%eax
 219:	cd 40                	int    $0x40
 21b:	c3                   	ret    

0000021c <read>:
SYSCALL(read)
 21c:	b8 05 00 00 00       	mov    $0x5,%eax
 221:	cd 40                	int    $0x40
 223:	c3                   	ret    

00000224 <write>:
SYSCALL(write)
 224:	b8 10 00 00 00       	mov    $0x10,%eax
 229:	cd 40                	int    $0x40
 22b:	c3                   	ret    

0000022c <close>:
SYSCALL(close)
 22c:	b8 15 00 00 00       	mov    $0x15,%eax
 231:	cd 40                	int    $0x40
 233:	c3                   	ret    

00000234 <kill>:
SYSCALL(kill)
 234:	b8 06 00 00 00       	mov    $0x6,%eax
 239:	cd 40                	int    $0x40
 23b:	c3                   	ret    

0000023c <exec>:
SYSCALL(exec)
 23c:	b8 07 00 00 00       	mov    $0x7,%eax
 241:	cd 40                	int    $0x40
 243:	c3                   	ret    

00000244 <open>:
SYSCALL(open)
 244:	b8 0f 00 00 00       	mov    $0xf,%eax
 249:	cd 40                	int    $0x40
 24b:	c3                   	ret    

0000024c <mknod>:
SYSCALL(mknod)
 24c:	b8 11 00 00 00       	mov    $0x11,%eax
 251:	cd 40                	int    $0x40
 253:	c3                   	ret    

00000254 <unlink>:
SYSCALL(unlink)
 254:	b8 12 00 00 00       	mov    $0x12,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	ret    

0000025c <fstat>:
SYSCALL(fstat)
 25c:	b8 08 00 00 00       	mov    $0x8,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <link>:
SYSCALL(link)
 264:	b8 13 00 00 00       	mov    $0x13,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <mkdir>:
SYSCALL(mkdir)
 26c:	b8 14 00 00 00       	mov    $0x14,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <chdir>:
SYSCALL(chdir)
 274:	b8 09 00 00 00       	mov    $0x9,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <dup>:
SYSCALL(dup)
 27c:	b8 0a 00 00 00       	mov    $0xa,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <getpid>:
SYSCALL(getpid)
 284:	b8 0b 00 00 00       	mov    $0xb,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <sbrk>:
SYSCALL(sbrk)
 28c:	b8 0c 00 00 00       	mov    $0xc,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <sleep>:
SYSCALL(sleep)
 294:	b8 0d 00 00 00       	mov    $0xd,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <uptime>:
SYSCALL(uptime)
 29c:	b8 0e 00 00 00       	mov    $0xe,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <settickets>:
SYSCALL(settickets)
 2a4:	b8 16 00 00 00       	mov    $0x16,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <getpinfo>:
SYSCALL(getpinfo)
 2ac:	b8 17 00 00 00       	mov    $0x17,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <mprotect>:
SYSCALL(mprotect)
 2b4:	b8 18 00 00 00       	mov    $0x18,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <munprotect>:
SYSCALL(munprotect)
 2bc:	b8 19 00 00 00       	mov    $0x19,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 1c             	sub    $0x1c,%esp
 2ca:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2cd:	6a 01                	push   $0x1
 2cf:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2d2:	52                   	push   %edx
 2d3:	50                   	push   %eax
 2d4:	e8 4b ff ff ff       	call   224 <write>
}
 2d9:	83 c4 10             	add    $0x10,%esp
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	57                   	push   %edi
 2e2:	56                   	push   %esi
 2e3:	53                   	push   %ebx
 2e4:	83 ec 2c             	sub    $0x2c,%esp
 2e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2ea:	89 d0                	mov    %edx,%eax
 2ec:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f2:	0f 95 c1             	setne  %cl
 2f5:	c1 ea 1f             	shr    $0x1f,%edx
 2f8:	84 d1                	test   %dl,%cl
 2fa:	74 44                	je     340 <printint+0x62>
    neg = 1;
    x = -xx;
 2fc:	f7 d8                	neg    %eax
 2fe:	89 c1                	mov    %eax,%ecx
    neg = 1;
 300:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 307:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 30c:	89 c8                	mov    %ecx,%eax
 30e:	ba 00 00 00 00       	mov    $0x0,%edx
 313:	f7 f6                	div    %esi
 315:	89 df                	mov    %ebx,%edi
 317:	83 c3 01             	add    $0x1,%ebx
 31a:	0f b6 92 94 06 00 00 	movzbl 0x694(%edx),%edx
 321:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 325:	89 ca                	mov    %ecx,%edx
 327:	89 c1                	mov    %eax,%ecx
 329:	39 d6                	cmp    %edx,%esi
 32b:	76 df                	jbe    30c <printint+0x2e>
  if(neg)
 32d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 331:	74 31                	je     364 <printint+0x86>
    buf[i++] = '-';
 333:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 338:	8d 5f 02             	lea    0x2(%edi),%ebx
 33b:	8b 75 d0             	mov    -0x30(%ebp),%esi
 33e:	eb 17                	jmp    357 <printint+0x79>
    x = xx;
 340:	89 c1                	mov    %eax,%ecx
  neg = 0;
 342:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 349:	eb bc                	jmp    307 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 34b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 350:	89 f0                	mov    %esi,%eax
 352:	e8 6d ff ff ff       	call   2c4 <putc>
  while(--i >= 0)
 357:	83 eb 01             	sub    $0x1,%ebx
 35a:	79 ef                	jns    34b <printint+0x6d>
}
 35c:	83 c4 2c             	add    $0x2c,%esp
 35f:	5b                   	pop    %ebx
 360:	5e                   	pop    %esi
 361:	5f                   	pop    %edi
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    
 364:	8b 75 d0             	mov    -0x30(%ebp),%esi
 367:	eb ee                	jmp    357 <printint+0x79>

00000369 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	57                   	push   %edi
 36d:	56                   	push   %esi
 36e:	53                   	push   %ebx
 36f:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 372:	8d 45 10             	lea    0x10(%ebp),%eax
 375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 378:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 37d:	bb 00 00 00 00       	mov    $0x0,%ebx
 382:	eb 14                	jmp    398 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 384:	89 fa                	mov    %edi,%edx
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	e8 36 ff ff ff       	call   2c4 <putc>
 38e:	eb 05                	jmp    395 <printf+0x2c>
      }
    } else if(state == '%'){
 390:	83 fe 25             	cmp    $0x25,%esi
 393:	74 25                	je     3ba <printf+0x51>
  for(i = 0; fmt[i]; i++){
 395:	83 c3 01             	add    $0x1,%ebx
 398:	8b 45 0c             	mov    0xc(%ebp),%eax
 39b:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	0f 84 20 01 00 00    	je     4c7 <printf+0x15e>
    c = fmt[i] & 0xff;
 3a7:	0f be f8             	movsbl %al,%edi
 3aa:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3ad:	85 f6                	test   %esi,%esi
 3af:	75 df                	jne    390 <printf+0x27>
      if(c == '%'){
 3b1:	83 f8 25             	cmp    $0x25,%eax
 3b4:	75 ce                	jne    384 <printf+0x1b>
        state = '%';
 3b6:	89 c6                	mov    %eax,%esi
 3b8:	eb db                	jmp    395 <printf+0x2c>
      if(c == 'd'){
 3ba:	83 f8 25             	cmp    $0x25,%eax
 3bd:	0f 84 cf 00 00 00    	je     492 <printf+0x129>
 3c3:	0f 8c dd 00 00 00    	jl     4a6 <printf+0x13d>
 3c9:	83 f8 78             	cmp    $0x78,%eax
 3cc:	0f 8f d4 00 00 00    	jg     4a6 <printf+0x13d>
 3d2:	83 f8 63             	cmp    $0x63,%eax
 3d5:	0f 8c cb 00 00 00    	jl     4a6 <printf+0x13d>
 3db:	83 e8 63             	sub    $0x63,%eax
 3de:	83 f8 15             	cmp    $0x15,%eax
 3e1:	0f 87 bf 00 00 00    	ja     4a6 <printf+0x13d>
 3e7:	ff 24 85 3c 06 00 00 	jmp    *0x63c(,%eax,4)
        printint(fd, *ap, 10, 1);
 3ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f1:	8b 17                	mov    (%edi),%edx
 3f3:	83 ec 0c             	sub    $0xc,%esp
 3f6:	6a 01                	push   $0x1
 3f8:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
 400:	e8 d9 fe ff ff       	call   2de <printint>
        ap++;
 405:	83 c7 04             	add    $0x4,%edi
 408:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 40b:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 40e:	be 00 00 00 00       	mov    $0x0,%esi
 413:	eb 80                	jmp    395 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 418:	8b 17                	mov    (%edi),%edx
 41a:	83 ec 0c             	sub    $0xc,%esp
 41d:	6a 00                	push   $0x0
 41f:	b9 10 00 00 00       	mov    $0x10,%ecx
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	e8 b2 fe ff ff       	call   2de <printint>
        ap++;
 42c:	83 c7 04             	add    $0x4,%edi
 42f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 432:	83 c4 10             	add    $0x10,%esp
      state = 0;
 435:	be 00 00 00 00       	mov    $0x0,%esi
 43a:	e9 56 ff ff ff       	jmp    395 <printf+0x2c>
        s = (char*)*ap;
 43f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 442:	8b 30                	mov    (%eax),%esi
        ap++;
 444:	83 c0 04             	add    $0x4,%eax
 447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 44a:	85 f6                	test   %esi,%esi
 44c:	75 15                	jne    463 <printf+0xfa>
          s = "(null)";
 44e:	be 33 06 00 00       	mov    $0x633,%esi
 453:	eb 0e                	jmp    463 <printf+0xfa>
          putc(fd, *s);
 455:	0f be d2             	movsbl %dl,%edx
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	e8 64 fe ff ff       	call   2c4 <putc>
          s++;
 460:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 463:	0f b6 16             	movzbl (%esi),%edx
 466:	84 d2                	test   %dl,%dl
 468:	75 eb                	jne    455 <printf+0xec>
      state = 0;
 46a:	be 00 00 00 00       	mov    $0x0,%esi
 46f:	e9 21 ff ff ff       	jmp    395 <printf+0x2c>
        putc(fd, *ap);
 474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 477:	0f be 17             	movsbl (%edi),%edx
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	e8 42 fe ff ff       	call   2c4 <putc>
        ap++;
 482:	83 c7 04             	add    $0x4,%edi
 485:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 488:	be 00 00 00 00       	mov    $0x0,%esi
 48d:	e9 03 ff ff ff       	jmp    395 <printf+0x2c>
        putc(fd, c);
 492:	89 fa                	mov    %edi,%edx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	e8 28 fe ff ff       	call   2c4 <putc>
      state = 0;
 49c:	be 00 00 00 00       	mov    $0x0,%esi
 4a1:	e9 ef fe ff ff       	jmp    395 <printf+0x2c>
        putc(fd, '%');
 4a6:	ba 25 00 00 00       	mov    $0x25,%edx
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	e8 11 fe ff ff       	call   2c4 <putc>
        putc(fd, c);
 4b3:	89 fa                	mov    %edi,%edx
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
 4b8:	e8 07 fe ff ff       	call   2c4 <putc>
      state = 0;
 4bd:	be 00 00 00 00       	mov    $0x0,%esi
 4c2:	e9 ce fe ff ff       	jmp    395 <printf+0x2c>
    }
  }
}
 4c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ca:	5b                   	pop    %ebx
 4cb:	5e                   	pop    %esi
 4cc:	5f                   	pop    %edi
 4cd:	5d                   	pop    %ebp
 4ce:	c3                   	ret    

000004cf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4cf:	55                   	push   %ebp
 4d0:	89 e5                	mov    %esp,%ebp
 4d2:	57                   	push   %edi
 4d3:	56                   	push   %esi
 4d4:	53                   	push   %ebx
 4d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4db:	a1 38 09 00 00       	mov    0x938,%eax
 4e0:	eb 02                	jmp    4e4 <free+0x15>
 4e2:	89 d0                	mov    %edx,%eax
 4e4:	39 c8                	cmp    %ecx,%eax
 4e6:	73 04                	jae    4ec <free+0x1d>
 4e8:	39 08                	cmp    %ecx,(%eax)
 4ea:	77 12                	ja     4fe <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4ec:	8b 10                	mov    (%eax),%edx
 4ee:	39 c2                	cmp    %eax,%edx
 4f0:	77 f0                	ja     4e2 <free+0x13>
 4f2:	39 c8                	cmp    %ecx,%eax
 4f4:	72 08                	jb     4fe <free+0x2f>
 4f6:	39 ca                	cmp    %ecx,%edx
 4f8:	77 04                	ja     4fe <free+0x2f>
 4fa:	89 d0                	mov    %edx,%eax
 4fc:	eb e6                	jmp    4e4 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4fe:	8b 73 fc             	mov    -0x4(%ebx),%esi
 501:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 504:	8b 10                	mov    (%eax),%edx
 506:	39 d7                	cmp    %edx,%edi
 508:	74 19                	je     523 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 50a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 50d:	8b 50 04             	mov    0x4(%eax),%edx
 510:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 513:	39 ce                	cmp    %ecx,%esi
 515:	74 1b                	je     532 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 517:	89 08                	mov    %ecx,(%eax)
  freep = p;
 519:	a3 38 09 00 00       	mov    %eax,0x938
}
 51e:	5b                   	pop    %ebx
 51f:	5e                   	pop    %esi
 520:	5f                   	pop    %edi
 521:	5d                   	pop    %ebp
 522:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 523:	03 72 04             	add    0x4(%edx),%esi
 526:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 529:	8b 10                	mov    (%eax),%edx
 52b:	8b 12                	mov    (%edx),%edx
 52d:	89 53 f8             	mov    %edx,-0x8(%ebx)
 530:	eb db                	jmp    50d <free+0x3e>
    p->s.size += bp->s.size;
 532:	03 53 fc             	add    -0x4(%ebx),%edx
 535:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 538:	8b 53 f8             	mov    -0x8(%ebx),%edx
 53b:	89 10                	mov    %edx,(%eax)
 53d:	eb da                	jmp    519 <free+0x4a>

0000053f <morecore>:

static Header*
morecore(uint nu)
{
 53f:	55                   	push   %ebp
 540:	89 e5                	mov    %esp,%ebp
 542:	53                   	push   %ebx
 543:	83 ec 04             	sub    $0x4,%esp
 546:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 548:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 54d:	77 05                	ja     554 <morecore+0x15>
    nu = 4096;
 54f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 554:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 55b:	83 ec 0c             	sub    $0xc,%esp
 55e:	50                   	push   %eax
 55f:	e8 28 fd ff ff       	call   28c <sbrk>
  if(p == (char*)-1)
 564:	83 c4 10             	add    $0x10,%esp
 567:	83 f8 ff             	cmp    $0xffffffff,%eax
 56a:	74 1c                	je     588 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 56c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 56f:	83 c0 08             	add    $0x8,%eax
 572:	83 ec 0c             	sub    $0xc,%esp
 575:	50                   	push   %eax
 576:	e8 54 ff ff ff       	call   4cf <free>
  return freep;
 57b:	a1 38 09 00 00       	mov    0x938,%eax
 580:	83 c4 10             	add    $0x10,%esp
}
 583:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 586:	c9                   	leave  
 587:	c3                   	ret    
    return 0;
 588:	b8 00 00 00 00       	mov    $0x0,%eax
 58d:	eb f4                	jmp    583 <morecore+0x44>

0000058f <malloc>:

void*
malloc(uint nbytes)
{
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	53                   	push   %ebx
 593:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	8d 58 07             	lea    0x7(%eax),%ebx
 59c:	c1 eb 03             	shr    $0x3,%ebx
 59f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a2:	8b 0d 38 09 00 00    	mov    0x938,%ecx
 5a8:	85 c9                	test   %ecx,%ecx
 5aa:	74 04                	je     5b0 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ac:	8b 01                	mov    (%ecx),%eax
 5ae:	eb 4a                	jmp    5fa <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5b0:	c7 05 38 09 00 00 3c 	movl   $0x93c,0x938
 5b7:	09 00 00 
 5ba:	c7 05 3c 09 00 00 3c 	movl   $0x93c,0x93c
 5c1:	09 00 00 
    base.s.size = 0;
 5c4:	c7 05 40 09 00 00 00 	movl   $0x0,0x940
 5cb:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5ce:	b9 3c 09 00 00       	mov    $0x93c,%ecx
 5d3:	eb d7                	jmp    5ac <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5d5:	74 19                	je     5f0 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5d7:	29 da                	sub    %ebx,%edx
 5d9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5dc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5df:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5e2:	89 0d 38 09 00 00    	mov    %ecx,0x938
      return (void*)(p + 1);
 5e8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ee:	c9                   	leave  
 5ef:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5f0:	8b 10                	mov    (%eax),%edx
 5f2:	89 11                	mov    %edx,(%ecx)
 5f4:	eb ec                	jmp    5e2 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f6:	89 c1                	mov    %eax,%ecx
 5f8:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5fa:	8b 50 04             	mov    0x4(%eax),%edx
 5fd:	39 da                	cmp    %ebx,%edx
 5ff:	73 d4                	jae    5d5 <malloc+0x46>
    if(p == freep)
 601:	39 05 38 09 00 00    	cmp    %eax,0x938
 607:	75 ed                	jne    5f6 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 609:	89 d8                	mov    %ebx,%eax
 60b:	e8 2f ff ff ff       	call   53f <morecore>
 610:	85 c0                	test   %eax,%eax
 612:	75 e2                	jne    5f6 <malloc+0x67>
 614:	eb d5                	jmp    5eb <malloc+0x5c>
