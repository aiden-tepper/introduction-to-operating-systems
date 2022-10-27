
_test_8:     file format elf32-i386


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

   if(getpinfo((struct pstat *)1000000) == -1)
  11:	68 40 42 0f 00       	push   $0xf4240
  16:	e8 7a 02 00 00       	call   295 <getpinfo>
  1b:	83 c4 10             	add    $0x10,%esp
  1e:	83 f8 ff             	cmp    $0xffffffff,%eax
  21:	74 17                	je     3a <main+0x3a>
   {
    printf(1, "XV6_SCHEDULER\t SUCCESS\n");
   }
   else
   {
    printf(1, "XV6_SCHEDULER\t FAILED\n");
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 18 06 00 00       	push   $0x618
  2b:	6a 01                	push   $0x1
  2d:	e8 20 03 00 00       	call   352 <printf>
  32:	83 c4 10             	add    $0x10,%esp
   }
   
   exit();
  35:	e8 b3 01 00 00       	call   1ed <exit>
    printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  3a:	83 ec 08             	sub    $0x8,%esp
  3d:	68 00 06 00 00       	push   $0x600
  42:	6a 01                	push   $0x1
  44:	e8 09 03 00 00       	call   352 <printf>
  49:	83 c4 10             	add    $0x10,%esp
  4c:	eb e7                	jmp    35 <main+0x35>

0000004e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  4e:	55                   	push   %ebp
  4f:	89 e5                	mov    %esp,%ebp
  51:	56                   	push   %esi
  52:	53                   	push   %ebx
  53:	8b 75 08             	mov    0x8(%ebp),%esi
  56:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  59:	89 f0                	mov    %esi,%eax
  5b:	89 d1                	mov    %edx,%ecx
  5d:	83 c2 01             	add    $0x1,%edx
  60:	89 c3                	mov    %eax,%ebx
  62:	83 c0 01             	add    $0x1,%eax
  65:	0f b6 09             	movzbl (%ecx),%ecx
  68:	88 0b                	mov    %cl,(%ebx)
  6a:	84 c9                	test   %cl,%cl
  6c:	75 ed                	jne    5b <strcpy+0xd>
    ;
  return os;
}
  6e:	89 f0                	mov    %esi,%eax
  70:	5b                   	pop    %ebx
  71:	5e                   	pop    %esi
  72:	5d                   	pop    %ebp
  73:	c3                   	ret    

00000074 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  7d:	eb 06                	jmp    85 <strcmp+0x11>
    p++, q++;
  7f:	83 c1 01             	add    $0x1,%ecx
  82:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  85:	0f b6 01             	movzbl (%ecx),%eax
  88:	84 c0                	test   %al,%al
  8a:	74 04                	je     90 <strcmp+0x1c>
  8c:	3a 02                	cmp    (%edx),%al
  8e:	74 ef                	je     7f <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  90:	0f b6 c0             	movzbl %al,%eax
  93:	0f b6 12             	movzbl (%edx),%edx
  96:	29 d0                	sub    %edx,%eax
}
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strlen>:

uint
strlen(const char *s)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a0:	b8 00 00 00 00       	mov    $0x0,%eax
  a5:	eb 03                	jmp    aa <strlen+0x10>
  a7:	83 c0 01             	add    $0x1,%eax
  aa:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  ae:	75 f7                	jne    a7 <strlen+0xd>
    ;
  return n;
}
  b0:	5d                   	pop    %ebp
  b1:	c3                   	ret    

000000b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b2:	55                   	push   %ebp
  b3:	89 e5                	mov    %esp,%ebp
  b5:	57                   	push   %edi
  b6:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b9:	89 d7                	mov    %edx,%edi
  bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  be:	8b 45 0c             	mov    0xc(%ebp),%eax
  c1:	fc                   	cld    
  c2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c4:	89 d0                	mov    %edx,%eax
  c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  c9:	c9                   	leave  
  ca:	c3                   	ret    

000000cb <strchr>:

char*
strchr(const char *s, char c)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d5:	eb 03                	jmp    da <strchr+0xf>
  d7:	83 c0 01             	add    $0x1,%eax
  da:	0f b6 10             	movzbl (%eax),%edx
  dd:	84 d2                	test   %dl,%dl
  df:	74 06                	je     e7 <strchr+0x1c>
    if(*s == c)
  e1:	38 ca                	cmp    %cl,%dl
  e3:	75 f2                	jne    d7 <strchr+0xc>
  e5:	eb 05                	jmp    ec <strchr+0x21>
      return (char*)s;
  return 0;
  e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret    

000000ee <gets>:

char*
gets(char *buf, int max)
{
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	57                   	push   %edi
  f2:	56                   	push   %esi
  f3:	53                   	push   %ebx
  f4:	83 ec 1c             	sub    $0x1c,%esp
  f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  ff:	89 de                	mov    %ebx,%esi
 101:	83 c3 01             	add    $0x1,%ebx
 104:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 107:	7d 2e                	jge    137 <gets+0x49>
    cc = read(0, &c, 1);
 109:	83 ec 04             	sub    $0x4,%esp
 10c:	6a 01                	push   $0x1
 10e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 111:	50                   	push   %eax
 112:	6a 00                	push   $0x0
 114:	e8 ec 00 00 00       	call   205 <read>
    if(cc < 1)
 119:	83 c4 10             	add    $0x10,%esp
 11c:	85 c0                	test   %eax,%eax
 11e:	7e 17                	jle    137 <gets+0x49>
      break;
    buf[i++] = c;
 120:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 124:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 127:	3c 0a                	cmp    $0xa,%al
 129:	0f 94 c2             	sete   %dl
 12c:	3c 0d                	cmp    $0xd,%al
 12e:	0f 94 c0             	sete   %al
 131:	08 c2                	or     %al,%dl
 133:	74 ca                	je     ff <gets+0x11>
    buf[i++] = c;
 135:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 137:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 13b:	89 f8                	mov    %edi,%eax
 13d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	5f                   	pop    %edi
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    

00000145 <stat>:

int
stat(const char *n, struct stat *st)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	56                   	push   %esi
 149:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14a:	83 ec 08             	sub    $0x8,%esp
 14d:	6a 00                	push   $0x0
 14f:	ff 75 08             	push   0x8(%ebp)
 152:	e8 d6 00 00 00       	call   22d <open>
  if(fd < 0)
 157:	83 c4 10             	add    $0x10,%esp
 15a:	85 c0                	test   %eax,%eax
 15c:	78 24                	js     182 <stat+0x3d>
 15e:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 160:	83 ec 08             	sub    $0x8,%esp
 163:	ff 75 0c             	push   0xc(%ebp)
 166:	50                   	push   %eax
 167:	e8 d9 00 00 00       	call   245 <fstat>
 16c:	89 c6                	mov    %eax,%esi
  close(fd);
 16e:	89 1c 24             	mov    %ebx,(%esp)
 171:	e8 9f 00 00 00       	call   215 <close>
  return r;
 176:	83 c4 10             	add    $0x10,%esp
}
 179:	89 f0                	mov    %esi,%eax
 17b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17e:	5b                   	pop    %ebx
 17f:	5e                   	pop    %esi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    
    return -1;
 182:	be ff ff ff ff       	mov    $0xffffffff,%esi
 187:	eb f0                	jmp    179 <stat+0x34>

00000189 <atoi>:

int
atoi(const char *s)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	53                   	push   %ebx
 18d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 190:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 195:	eb 10                	jmp    1a7 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 197:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 19a:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 19d:	83 c1 01             	add    $0x1,%ecx
 1a0:	0f be c0             	movsbl %al,%eax
 1a3:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1a7:	0f b6 01             	movzbl (%ecx),%eax
 1aa:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ad:	80 fb 09             	cmp    $0x9,%bl
 1b0:	76 e5                	jbe    197 <atoi+0xe>
  return n;
}
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b7:	c9                   	leave  
 1b8:	c3                   	ret    

000001b9 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	56                   	push   %esi
 1bd:	53                   	push   %ebx
 1be:	8b 75 08             	mov    0x8(%ebp),%esi
 1c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1c9:	eb 0d                	jmp    1d8 <memmove+0x1f>
    *dst++ = *src++;
 1cb:	0f b6 01             	movzbl (%ecx),%eax
 1ce:	88 02                	mov    %al,(%edx)
 1d0:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d3:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d6:	89 d8                	mov    %ebx,%eax
 1d8:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1db:	85 c0                	test   %eax,%eax
 1dd:	7f ec                	jg     1cb <memmove+0x12>
  return vdst;
}
 1df:	89 f0                	mov    %esi,%eax
 1e1:	5b                   	pop    %ebx
 1e2:	5e                   	pop    %esi
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    

000001e5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e5:	b8 01 00 00 00       	mov    $0x1,%eax
 1ea:	cd 40                	int    $0x40
 1ec:	c3                   	ret    

000001ed <exit>:
SYSCALL(exit)
 1ed:	b8 02 00 00 00       	mov    $0x2,%eax
 1f2:	cd 40                	int    $0x40
 1f4:	c3                   	ret    

000001f5 <wait>:
SYSCALL(wait)
 1f5:	b8 03 00 00 00       	mov    $0x3,%eax
 1fa:	cd 40                	int    $0x40
 1fc:	c3                   	ret    

000001fd <pipe>:
SYSCALL(pipe)
 1fd:	b8 04 00 00 00       	mov    $0x4,%eax
 202:	cd 40                	int    $0x40
 204:	c3                   	ret    

00000205 <read>:
SYSCALL(read)
 205:	b8 05 00 00 00       	mov    $0x5,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <write>:
SYSCALL(write)
 20d:	b8 10 00 00 00       	mov    $0x10,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <close>:
SYSCALL(close)
 215:	b8 15 00 00 00       	mov    $0x15,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <kill>:
SYSCALL(kill)
 21d:	b8 06 00 00 00       	mov    $0x6,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <exec>:
SYSCALL(exec)
 225:	b8 07 00 00 00       	mov    $0x7,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <open>:
SYSCALL(open)
 22d:	b8 0f 00 00 00       	mov    $0xf,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <mknod>:
SYSCALL(mknod)
 235:	b8 11 00 00 00       	mov    $0x11,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <unlink>:
SYSCALL(unlink)
 23d:	b8 12 00 00 00       	mov    $0x12,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <fstat>:
SYSCALL(fstat)
 245:	b8 08 00 00 00       	mov    $0x8,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <link>:
SYSCALL(link)
 24d:	b8 13 00 00 00       	mov    $0x13,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <mkdir>:
SYSCALL(mkdir)
 255:	b8 14 00 00 00       	mov    $0x14,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <chdir>:
SYSCALL(chdir)
 25d:	b8 09 00 00 00       	mov    $0x9,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <dup>:
SYSCALL(dup)
 265:	b8 0a 00 00 00       	mov    $0xa,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <getpid>:
SYSCALL(getpid)
 26d:	b8 0b 00 00 00       	mov    $0xb,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <sbrk>:
SYSCALL(sbrk)
 275:	b8 0c 00 00 00       	mov    $0xc,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <sleep>:
SYSCALL(sleep)
 27d:	b8 0d 00 00 00       	mov    $0xd,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <uptime>:
SYSCALL(uptime)
 285:	b8 0e 00 00 00       	mov    $0xe,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <settickets>:
SYSCALL(settickets)
 28d:	b8 16 00 00 00       	mov    $0x16,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <getpinfo>:
SYSCALL(getpinfo)
 295:	b8 17 00 00 00       	mov    $0x17,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <mprotect>:
SYSCALL(mprotect)
 29d:	b8 18 00 00 00       	mov    $0x18,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <munprotect>:
SYSCALL(munprotect)
 2a5:	b8 19 00 00 00       	mov    $0x19,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2ad:	55                   	push   %ebp
 2ae:	89 e5                	mov    %esp,%ebp
 2b0:	83 ec 1c             	sub    $0x1c,%esp
 2b3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2b6:	6a 01                	push   $0x1
 2b8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2bb:	52                   	push   %edx
 2bc:	50                   	push   %eax
 2bd:	e8 4b ff ff ff       	call   20d <write>
}
 2c2:	83 c4 10             	add    $0x10,%esp
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	57                   	push   %edi
 2cb:	56                   	push   %esi
 2cc:	53                   	push   %ebx
 2cd:	83 ec 2c             	sub    $0x2c,%esp
 2d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2d3:	89 d0                	mov    %edx,%eax
 2d5:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2db:	0f 95 c1             	setne  %cl
 2de:	c1 ea 1f             	shr    $0x1f,%edx
 2e1:	84 d1                	test   %dl,%cl
 2e3:	74 44                	je     329 <printint+0x62>
    neg = 1;
    x = -xx;
 2e5:	f7 d8                	neg    %eax
 2e7:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2e9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f5:	89 c8                	mov    %ecx,%eax
 2f7:	ba 00 00 00 00       	mov    $0x0,%edx
 2fc:	f7 f6                	div    %esi
 2fe:	89 df                	mov    %ebx,%edi
 300:	83 c3 01             	add    $0x1,%ebx
 303:	0f b6 92 90 06 00 00 	movzbl 0x690(%edx),%edx
 30a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 30e:	89 ca                	mov    %ecx,%edx
 310:	89 c1                	mov    %eax,%ecx
 312:	39 d6                	cmp    %edx,%esi
 314:	76 df                	jbe    2f5 <printint+0x2e>
  if(neg)
 316:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 31a:	74 31                	je     34d <printint+0x86>
    buf[i++] = '-';
 31c:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 321:	8d 5f 02             	lea    0x2(%edi),%ebx
 324:	8b 75 d0             	mov    -0x30(%ebp),%esi
 327:	eb 17                	jmp    340 <printint+0x79>
    x = xx;
 329:	89 c1                	mov    %eax,%ecx
  neg = 0;
 32b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 332:	eb bc                	jmp    2f0 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 334:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 339:	89 f0                	mov    %esi,%eax
 33b:	e8 6d ff ff ff       	call   2ad <putc>
  while(--i >= 0)
 340:	83 eb 01             	sub    $0x1,%ebx
 343:	79 ef                	jns    334 <printint+0x6d>
}
 345:	83 c4 2c             	add    $0x2c,%esp
 348:	5b                   	pop    %ebx
 349:	5e                   	pop    %esi
 34a:	5f                   	pop    %edi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
 34d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 350:	eb ee                	jmp    340 <printint+0x79>

00000352 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	57                   	push   %edi
 356:	56                   	push   %esi
 357:	53                   	push   %ebx
 358:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 35b:	8d 45 10             	lea    0x10(%ebp),%eax
 35e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 361:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 366:	bb 00 00 00 00       	mov    $0x0,%ebx
 36b:	eb 14                	jmp    381 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 36d:	89 fa                	mov    %edi,%edx
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	e8 36 ff ff ff       	call   2ad <putc>
 377:	eb 05                	jmp    37e <printf+0x2c>
      }
    } else if(state == '%'){
 379:	83 fe 25             	cmp    $0x25,%esi
 37c:	74 25                	je     3a3 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 37e:	83 c3 01             	add    $0x1,%ebx
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 388:	84 c0                	test   %al,%al
 38a:	0f 84 20 01 00 00    	je     4b0 <printf+0x15e>
    c = fmt[i] & 0xff;
 390:	0f be f8             	movsbl %al,%edi
 393:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 396:	85 f6                	test   %esi,%esi
 398:	75 df                	jne    379 <printf+0x27>
      if(c == '%'){
 39a:	83 f8 25             	cmp    $0x25,%eax
 39d:	75 ce                	jne    36d <printf+0x1b>
        state = '%';
 39f:	89 c6                	mov    %eax,%esi
 3a1:	eb db                	jmp    37e <printf+0x2c>
      if(c == 'd'){
 3a3:	83 f8 25             	cmp    $0x25,%eax
 3a6:	0f 84 cf 00 00 00    	je     47b <printf+0x129>
 3ac:	0f 8c dd 00 00 00    	jl     48f <printf+0x13d>
 3b2:	83 f8 78             	cmp    $0x78,%eax
 3b5:	0f 8f d4 00 00 00    	jg     48f <printf+0x13d>
 3bb:	83 f8 63             	cmp    $0x63,%eax
 3be:	0f 8c cb 00 00 00    	jl     48f <printf+0x13d>
 3c4:	83 e8 63             	sub    $0x63,%eax
 3c7:	83 f8 15             	cmp    $0x15,%eax
 3ca:	0f 87 bf 00 00 00    	ja     48f <printf+0x13d>
 3d0:	ff 24 85 38 06 00 00 	jmp    *0x638(,%eax,4)
        printint(fd, *ap, 10, 1);
 3d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3da:	8b 17                	mov    (%edi),%edx
 3dc:	83 ec 0c             	sub    $0xc,%esp
 3df:	6a 01                	push   $0x1
 3e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	e8 d9 fe ff ff       	call   2c7 <printint>
        ap++;
 3ee:	83 c7 04             	add    $0x4,%edi
 3f1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f4:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3f7:	be 00 00 00 00       	mov    $0x0,%esi
 3fc:	eb 80                	jmp    37e <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 401:	8b 17                	mov    (%edi),%edx
 403:	83 ec 0c             	sub    $0xc,%esp
 406:	6a 00                	push   $0x0
 408:	b9 10 00 00 00       	mov    $0x10,%ecx
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	e8 b2 fe ff ff       	call   2c7 <printint>
        ap++;
 415:	83 c7 04             	add    $0x4,%edi
 418:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 41e:	be 00 00 00 00       	mov    $0x0,%esi
 423:	e9 56 ff ff ff       	jmp    37e <printf+0x2c>
        s = (char*)*ap;
 428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 42b:	8b 30                	mov    (%eax),%esi
        ap++;
 42d:	83 c0 04             	add    $0x4,%eax
 430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 433:	85 f6                	test   %esi,%esi
 435:	75 15                	jne    44c <printf+0xfa>
          s = "(null)";
 437:	be 2f 06 00 00       	mov    $0x62f,%esi
 43c:	eb 0e                	jmp    44c <printf+0xfa>
          putc(fd, *s);
 43e:	0f be d2             	movsbl %dl,%edx
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	e8 64 fe ff ff       	call   2ad <putc>
          s++;
 449:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 44c:	0f b6 16             	movzbl (%esi),%edx
 44f:	84 d2                	test   %dl,%dl
 451:	75 eb                	jne    43e <printf+0xec>
      state = 0;
 453:	be 00 00 00 00       	mov    $0x0,%esi
 458:	e9 21 ff ff ff       	jmp    37e <printf+0x2c>
        putc(fd, *ap);
 45d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 460:	0f be 17             	movsbl (%edi),%edx
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	e8 42 fe ff ff       	call   2ad <putc>
        ap++;
 46b:	83 c7 04             	add    $0x4,%edi
 46e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 471:	be 00 00 00 00       	mov    $0x0,%esi
 476:	e9 03 ff ff ff       	jmp    37e <printf+0x2c>
        putc(fd, c);
 47b:	89 fa                	mov    %edi,%edx
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	e8 28 fe ff ff       	call   2ad <putc>
      state = 0;
 485:	be 00 00 00 00       	mov    $0x0,%esi
 48a:	e9 ef fe ff ff       	jmp    37e <printf+0x2c>
        putc(fd, '%');
 48f:	ba 25 00 00 00       	mov    $0x25,%edx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	e8 11 fe ff ff       	call   2ad <putc>
        putc(fd, c);
 49c:	89 fa                	mov    %edi,%edx
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	e8 07 fe ff ff       	call   2ad <putc>
      state = 0;
 4a6:	be 00 00 00 00       	mov    $0x0,%esi
 4ab:	e9 ce fe ff ff       	jmp    37e <printf+0x2c>
    }
  }
}
 4b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    

000004b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	57                   	push   %edi
 4bc:	56                   	push   %esi
 4bd:	53                   	push   %ebx
 4be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4c1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c4:	a1 30 09 00 00       	mov    0x930,%eax
 4c9:	eb 02                	jmp    4cd <free+0x15>
 4cb:	89 d0                	mov    %edx,%eax
 4cd:	39 c8                	cmp    %ecx,%eax
 4cf:	73 04                	jae    4d5 <free+0x1d>
 4d1:	39 08                	cmp    %ecx,(%eax)
 4d3:	77 12                	ja     4e7 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d5:	8b 10                	mov    (%eax),%edx
 4d7:	39 c2                	cmp    %eax,%edx
 4d9:	77 f0                	ja     4cb <free+0x13>
 4db:	39 c8                	cmp    %ecx,%eax
 4dd:	72 08                	jb     4e7 <free+0x2f>
 4df:	39 ca                	cmp    %ecx,%edx
 4e1:	77 04                	ja     4e7 <free+0x2f>
 4e3:	89 d0                	mov    %edx,%eax
 4e5:	eb e6                	jmp    4cd <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4e7:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ea:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ed:	8b 10                	mov    (%eax),%edx
 4ef:	39 d7                	cmp    %edx,%edi
 4f1:	74 19                	je     50c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4f3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4f6:	8b 50 04             	mov    0x4(%eax),%edx
 4f9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4fc:	39 ce                	cmp    %ecx,%esi
 4fe:	74 1b                	je     51b <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 500:	89 08                	mov    %ecx,(%eax)
  freep = p;
 502:	a3 30 09 00 00       	mov    %eax,0x930
}
 507:	5b                   	pop    %ebx
 508:	5e                   	pop    %esi
 509:	5f                   	pop    %edi
 50a:	5d                   	pop    %ebp
 50b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 50c:	03 72 04             	add    0x4(%edx),%esi
 50f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 512:	8b 10                	mov    (%eax),%edx
 514:	8b 12                	mov    (%edx),%edx
 516:	89 53 f8             	mov    %edx,-0x8(%ebx)
 519:	eb db                	jmp    4f6 <free+0x3e>
    p->s.size += bp->s.size;
 51b:	03 53 fc             	add    -0x4(%ebx),%edx
 51e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 521:	8b 53 f8             	mov    -0x8(%ebx),%edx
 524:	89 10                	mov    %edx,(%eax)
 526:	eb da                	jmp    502 <free+0x4a>

00000528 <morecore>:

static Header*
morecore(uint nu)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	53                   	push   %ebx
 52c:	83 ec 04             	sub    $0x4,%esp
 52f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 531:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 536:	77 05                	ja     53d <morecore+0x15>
    nu = 4096;
 538:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 53d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 544:	83 ec 0c             	sub    $0xc,%esp
 547:	50                   	push   %eax
 548:	e8 28 fd ff ff       	call   275 <sbrk>
  if(p == (char*)-1)
 54d:	83 c4 10             	add    $0x10,%esp
 550:	83 f8 ff             	cmp    $0xffffffff,%eax
 553:	74 1c                	je     571 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 555:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 558:	83 c0 08             	add    $0x8,%eax
 55b:	83 ec 0c             	sub    $0xc,%esp
 55e:	50                   	push   %eax
 55f:	e8 54 ff ff ff       	call   4b8 <free>
  return freep;
 564:	a1 30 09 00 00       	mov    0x930,%eax
 569:	83 c4 10             	add    $0x10,%esp
}
 56c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 56f:	c9                   	leave  
 570:	c3                   	ret    
    return 0;
 571:	b8 00 00 00 00       	mov    $0x0,%eax
 576:	eb f4                	jmp    56c <morecore+0x44>

00000578 <malloc>:

void*
malloc(uint nbytes)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	53                   	push   %ebx
 57c:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	8d 58 07             	lea    0x7(%eax),%ebx
 585:	c1 eb 03             	shr    $0x3,%ebx
 588:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 58b:	8b 0d 30 09 00 00    	mov    0x930,%ecx
 591:	85 c9                	test   %ecx,%ecx
 593:	74 04                	je     599 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 595:	8b 01                	mov    (%ecx),%eax
 597:	eb 4a                	jmp    5e3 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 599:	c7 05 30 09 00 00 34 	movl   $0x934,0x930
 5a0:	09 00 00 
 5a3:	c7 05 34 09 00 00 34 	movl   $0x934,0x934
 5aa:	09 00 00 
    base.s.size = 0;
 5ad:	c7 05 38 09 00 00 00 	movl   $0x0,0x938
 5b4:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5b7:	b9 34 09 00 00       	mov    $0x934,%ecx
 5bc:	eb d7                	jmp    595 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5be:	74 19                	je     5d9 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c0:	29 da                	sub    %ebx,%edx
 5c2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5c5:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5c8:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5cb:	89 0d 30 09 00 00    	mov    %ecx,0x930
      return (void*)(p + 1);
 5d1:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d7:	c9                   	leave  
 5d8:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5d9:	8b 10                	mov    (%eax),%edx
 5db:	89 11                	mov    %edx,(%ecx)
 5dd:	eb ec                	jmp    5cb <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5df:	89 c1                	mov    %eax,%ecx
 5e1:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5e3:	8b 50 04             	mov    0x4(%eax),%edx
 5e6:	39 da                	cmp    %ebx,%edx
 5e8:	73 d4                	jae    5be <malloc+0x46>
    if(p == freep)
 5ea:	39 05 30 09 00 00    	cmp    %eax,0x930
 5f0:	75 ed                	jne    5df <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5f2:	89 d8                	mov    %ebx,%eax
 5f4:	e8 2f ff ff ff       	call   528 <morecore>
 5f9:	85 c0                	test   %eax,%eax
 5fb:	75 e2                	jne    5df <malloc+0x67>
 5fd:	eb d5                	jmp    5d4 <malloc+0x5c>
